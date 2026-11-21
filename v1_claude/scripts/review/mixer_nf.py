"""Review A-8: receiver noise figure with the LO harmonics folded in (ngspice has no PSS / PNOISE).
 1. LNA (PEX + pad + ESD + match, mixer as load): output noise S_lna(f) at rfp-rfn and the gain
    from the source EMF, 1 MHz .. 20 GHz.
 2. Mixer, quasi-static: the 8 LO phases are frozen at 64 points of one fLO/2 period (gate voltage =
    bias + 0.93 x LO swing, the AC coupling replaced by sources); at each point the small-signal gain
    g(tau) from rfp-rfn to the IF output and the mixer's own output noise at 4.092 MHz.
    c_n = Fourier coefficients of g at n x fLO/2 -> conversion gains; own noise = mean over tau.
 3. F = [sum_n |c_n|^2 S_lna(n fLO/2 +- fIF) + S_mixer] / [|c_2|^2 S_source(fLO + fIF)]
All MOS are converted to single fingers (the BSIM4 thermal noise in ngspice depends on nf, see A-5)."""
import os, sys, re
import numpy as np
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, "..")); sys.path.insert(0, os.path.join(HERE, "..", "layout"))
os.environ.setdefault("PDK", "gf180mcuD"); os.environ.setdefault("PDK_ROOT", os.path.expanduser("~/pdk"))
import pexsim, rfin_match
from pexsim import run

T = 1272.809e-12; FH = 1 / T; FIF = 4.092e6; K = 0.93; KT4 = 4 * 1.380649e-23 * 300.15
CORN = {"tt": ("typical", 27, 3.3), "ss": ("ss", 85, 3.135), "ff": ("ff", -20, 3.465)}
NUM = r"([0-9.]+)u"


def nf1(t):
    """every MOS -> single-finger devices (W/nf, m x nf), shared diffusions"""
    def f(m):
        nf = int(m.group(4)); w = float(m.group(3)) / nf; mult = int(m.group(5)) * nf
        return "%s L=%su W=%gu nf=1 ad='%gu*0.09u' as='%gu*0.09u' pd='%gu+0.18u' ps='%gu+0.18u' sa=0 sb=0 sd=0 m=%d" % (
            m.group(1), m.group(2), w, w, w, w, w, mult)
    t, k = re.subn(r"^(XM\S+ .*? [np]fet_03v3) L=%s W=%s nf=(\d+) .*\n\+ .*? m=(\d+) par=\d+$" % (NUM, NUM), f, t, flags=re.M)
    return t, k


def corner(t, c):
    lib, temp, v = CORN[c]
    t = re.sub(r"(sm141064\.ngspice) (res_|mimcap_|diode_)?typical", lambda m: "%s %s%s" % (m.group(1), m.group(2) or "", lib), t)
    t = t.replace("VDD vdd 0 3.3", "VDD vdd 0 %g" % v)
    return t.replace(".control", ".temp %g\n.control" % temp, 1), v


def lna(c):
    t = rfin_match.deck(True)
    body = ("set num_threads=1\nalter LP = 1\nalter CP = 2.7e-12\nalter LS = 6e-9\nop\n"
            "ac dec 60 1e6 2e10\nlet h = mag((v(rfp)-v(rfn))/v(s0))\nwrdata review/mnf_lna_h_%s h\n"
            "noise v(rfp,rfn) VRF dec 60 1e6 2e10\nsetplot noise1\nwrdata review/mnf_lna_n_%s onoise_spectrum\n" % (c, c))
    t, k = re.subn(r"^\.control.*?^\.endc", lambda m: ".control\n" + body + ".endc", t, flags=re.M | re.S); assert k == 1
    t, v = corner(t, c)
    out = run.ngspice(t, "rev_mnf_lna_" + c, timeout=3000)
    h = np.loadtxt(os.path.join(run.SIM, "review", "mnf_lna_h_%s" % c)); n = np.loadtxt(os.path.join(run.SIM, "review", "mnf_lna_n_%s" % c))
    return h[:, 0], h[:, 1], n[:, 1] ** 2


def lo(tau, d, tr=60e-12, vh=2.0):
    """trapezoid 0..vh of tb_rx (delay d, 50 % duty) at time tau"""
    x = (tau - d) % T; pw = T / 2 - tr
    return vh * (x / tr if x < tr else 1.0 if x < tr + pw else 1 - (x - tr - pw) / tr if x < 2 * tr + pw else 0.0)


def mixer(c, n=64):
    t = open(run.netlist("tb_rx")).read()
    t, k = nf1(t); assert k > 20, k
    src = {m.group(1): float(m.group(2)) * 1e-12 for m in re.finditer(r"^VL(\d[PN]) l\d[pn] 0 pulse\(0 2\.0 ([0-9.]+)p", t, flags=re.M)}
    assert len(src) == 8
    t = re.sub(r"^VL(\d[PN]) (l\d[pn]) 0 pulse.*$", r"VL\1 \2 0 dc 1", t, flags=re.M)
    t, k = re.subn(r"^XCAC(L\d[PN]) (\S+) (\S+) cap_mim.*$", r"VCAC\1 \2 \3 0", t, flags=re.M); assert k == 8
    t, k = re.subn(r"^XRACL\d[PN] .*\n", "", t, flags=re.M); assert k == 8
    t, k = re.subn(r"^VRF .*\nRS50 .*\nCIN .*\nXLNA .*\n", "VRFP rfp 0 dc 1.3 ac 0.5\nVRFN rfn 0 dc 1.3 ac -0.5\n", t, flags=re.M); assert k == 1
    v = CORN[c][2]
    t = t.replace("VRFP rfp 0 dc 1.3", "VRFP rfp 0 dc %g" % (v * 13 / 33)).replace("VRFN rfn 0 dc 1.3", "VRFN rfn 0 dc %g" % (v * 13 / 33))
    bias = {"1": v * 56 / 103, "2": v * 56 / 103, "3": v * 37 / 102, "4": v * 37 / 102}
    body = "set num_threads=1\n"
    for i in range(n):
        tau = i * T / n
        for s, d in src.items():
            body += "alter VL%s dc = %g\n" % (s, bias[s[0]] + K * (lo(tau, d) - 1.0))
        body += ("op\nac lin 1 1e5 1e5\nlet gi = real(v(ifip)-v(ifin))\nlet gq = real(v(ifqp)-v(ifqn))\n"
                 "noise v(ifip,ifin) VRFP lin 2 %g %g 1\nsetplot noise2\nprint all\n"
                 "echo QS %d $&ac1.gi $&ac1.gq\ndestroy all\n" % (FIF - 0.5e6, FIF + 0.5e6, i))
    t, k = re.subn(r"^\.option method=gear\n\.control.*?^\.endc", lambda m: ".control\n" + body + ".endc", t, flags=re.M | re.S); assert k == 1
    t, v = corner(t, c)
    out = run.ngspice(t, "rev_mnf_mix_" + c, timeout=3000)
    # noise integrated over 1 MHz around the IF.  The 1/f noise of the Gm pair and the tail is taken out: the
    # switches chop it up to the LO (a frozen-LO analysis would pass it straight to the IF output, and at
    # 4 MHz it is 5 x the thermal noise of the 0.28 um Gm pair); the switches' own 1/f noise stays in.
    q = []; tot = fl = 0.0
    for l in out.splitlines():
        m = re.match(r"onoise_total(\.\S+)? = (\S+)", l)
        if m and not m.group(1):
            tot = float(m.group(2)) ** 2
        elif m and re.search(r"\.xm(g\d|t)[iq]\.m\d+\.1overf$", m.group(1)):
            fl += float(m.group(2)) ** 2
        elif l.startswith("QS "):
            q.append([float(x) for x in l.split()[2:]] + [tot / 1e6, (tot - fl) / 1e6]); tot = fl = 0.0
    q = np.array(q)
    assert len(q) == n, out[-2000:]
    print("   mixer output noise, frozen LO: %.1f nV/rtHz with the Gm / tail 1/f noise, %.1f nV/rtHz without" % (
        np.sqrt(q[:, 2].mean()) * 1e9, np.sqrt(q[:, 3].mean()) * 1e9))
    return q[:, 0], q[:, 1], q[:, 3]


def main():
    os.makedirs(os.path.join(run.SIM, "review"), exist_ok=True)
    for c in sys.argv[1:] or ["tt"]:
        f, h, sl = lna(c)
        gi, gq, sm = mixer(c)
        n = len(gi); ks = np.arange(n)
        S = lambda x: float(np.interp(np.log10(x), np.log10(f), sl)); H = lambda x: float(np.interp(np.log10(x), np.log10(f), h))
        ci = {m: abs(np.mean(gi * np.exp(-2j * np.pi * m * ks / n))) for m in range(0, 25)}
        cq = {m: abs(np.mean(gq * np.exp(-2j * np.pi * m * ks / n))) for m in range(0, 25)}
        sig = ci[2] ** 2 * KT4 * 50 * H(2 * FH + FIF) ** 2
        own = sm.mean()
        print("== %s: LNA gain (EMF/2 -> diff) %.2f dB at 1575 MHz, LNA NF alone %.2f dB; mixer conversion gain |c2| I %.2f dB, Q %.2f dB "
              "(RF port -> IF: %.2f dB)" % (c, 20 * np.log10(2 * H(2 * FH + FIF)), 10 * np.log10(S(2 * FH + FIF) / (KT4 * 50 * H(2 * FH + FIF) ** 2)),
              20 * np.log10(ci[2]), 20 * np.log10(cq[2]), 20 * np.log10(2 * H(2 * FH + FIF) * ci[2])))
        print("   mixer own output noise %.1f nV/rtHz (I, 4.092 MHz) = %.2f x the wanted-sideband source noise" % (np.sqrt(own) * 1e9, own / sig))
        rows = []; tot_d = own; tot_c = own
        for m in range(0, 25):
            if ci[m] < 1e-4 * ci[2]:
                continue
            a = ci[m] ** 2 * S(max(m * FH + FIF, 1e6)); b = ci[m] ** 2 * S(max(abs(m * FH - FIF), 1e6))
            tot_d += a + b; tot_c += a if m else (a + b) / 2
            rows.append("     n=%2d (%7.1f MHz): |c_n|/|c_2| %6.1f dB, LNA output noise there %5.2f nV/rtHz, folded noise %.3f x source" % (
                m, m * FH / 1e6, 20 * np.log10(ci[m] / ci[2]), np.sqrt(S(max(m * FH, 1e6))) * 1e9, (a + b) / sig))
        print("\n".join(rows))
        print("   NF of the chip: one channel alone (both sidebands of every harmonic fold) %.2f dB; complex I/Q (one sideband per harmonic) %.2f dB; "
              "mixer-only NF referred to its input (source = LNA output noise) -> mixer adds %.2f dB to the LNA NF" % (
                  10 * np.log10(tot_d / sig), 10 * np.log10(tot_c / sig), 10 * np.log10(tot_c / sig) - 10 * np.log10(S(2 * FH + FIF) / (KT4 * 50 * H(2 * FH + FIF) ** 2))))
        sys.stdout.flush()


if __name__ == "__main__":
    main()
