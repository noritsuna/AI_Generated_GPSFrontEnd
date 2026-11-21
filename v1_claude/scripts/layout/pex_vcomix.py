"""VCO -> LO wiring -> mixer, post-layout: vco_ring4 PEX + the top-level LO wires (pi RC with
net-to-net coupling, from top_wires.json) + mixer_iq PEX, driven by an RF tone 4.092 MHz above
the measured LO.  Reports fLO, the LO phase errors at the mixer pins and the IF I/Q amplitude /
phase imbalance; the same with the schematic VCO + mixer (no wires) as reference.
usage: pex_vcomix.py [vcs=1.476] [vcp=2.15] [fs=..] [fp=..] [B=0] [corner=tt] [tstop=1e-6]"""
import os, sys, re, json
import numpy as np
from concurrent.futures import ThreadPoolExecutor
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
os.environ.setdefault("PDK", "gf180mcuD"); os.environ.setdefault("PDK_ROOT", os.path.expanduser("~/pdk"))
import pexsim, pex_vco
from pexsim import run
PH = pex_vco.PH
FIF = 4.092e6
OUT = os.path.join(pexsim.PROJ, "sim", "pex_vcomix")


def wires(pex):
    """LO nets: VCO pin <net>v -- R -- mixer pin <net>, C/2 at both ends, coupling split likewise"""
    if not pex:
        return "".join("R%s %sv %s 1m\n" % (n, n, n) for n in PH)
    w = json.load(open(os.path.join(pexsim.MAG, "top_wires.json")))
    s = ""
    for n in PH:
        q = w[n]
        s += "R%s %sv %s %g\nC%sa %sv 0 %g\nC%sb %s 0 %g\n" % (n, n, n, max(q["r"], 1e-3), n, n, q["c"] / 2, n, n, q["c"] / 2)
        for o, v in q["cc"].items():
            if o in PH and o > n:
                s += "CC%s_%sa %sv %sv %g\nCC%s_%sb %s %s %g\n" % (n, o, n, o, v / 2, n, o, n, o, v / 2)
            elif o not in PH:
                # coupling to other nets -> ground (index: VCTRL / vctrl differ only in case)
                s += "CX%s_%s_%d %s 0 %g\n" % (n, o, len(s), n, v)
    return s


def dedupe(text):
    """keep the first definition of every .subckt (the two testbenches share leaf cells)"""
    out, seen = [], set()
    for blk in re.split(r"(?=^\.subckt\s)", text, flags=re.M | re.I):
        mm = re.match(r"\.subckt\s+(\S+)", blk, re.I)
        if mm:
            if mm.group(1) in seen:
                blk = blk[re.search(r"^\.ends.*$", blk, re.M).end():]
            seen.add(mm.group(1))
        out.append(blk)
    return "".join(out)


_NET = {}


def netlist(tb):
    """generate each testbench netlist once (xschem rewrites the file; threads would race)"""
    if tb not in _NET:
        _NET[tb] = open(run.netlist(tb)).read()
    return _NET[tb]


def deck(pex, vc, b, corner, tstop, frf, fn):
    mo, r, c, temp, vdd = pex_vco.CORNER[corner]
    t = netlist("tb_vco")
    hdr = t[:t.index("XVCO")]
    lib = "\n".join(l for l in t[t.index("**** begin user architecture code"):t.index(".control")].splitlines()
                    if not l.startswith((".ic", ".option"))) + "\n"
    mix = netlist("tb_mixer")
    subs = dedupe(t[t.index("**.ends"):].replace(".end\n", "") + mix[mix.index("**.ends") + 7:].replace(".end\n", ""))
    top = hdr.replace("VC vctrl 0 1.5", "VC vctrl 0 %g" % vc)
    top = top.replace("VB0 b0 0 0", "VB0 b0 0 %g" % (vdd * (b & 1))).replace("VB1 b1 0 0", "VB1 b1 0 %g" % (vdd * (b >> 1)))
    if "bias_gen" not in top:
        top += "XB nb pb vdd 0 bias_gen\n"
    top += "XVCO vctrl b0 b1 nb %s ckr vr vdd 0 vco_ring4\n" % " ".join(n + "v" for n in PH)
    top += wires(pex)
    top += ("VRFP sp 0 sin(0 1m %g 0 0 0)\nVRFN sn 0 sin(0 1m %g 0 0 180)\nRSP sp rfp_s 50\nRSN sn rfn_s 50\n"
            "CCP rfp_s rfp 10p\nCCN rfn_s rfn 10p\n" % (frf, frf))
    top += "XM rfp rfn %s nb ifip ifin ifqp ifqn vdd 0 mixer_iq\n" % " ".join(PH)
    ic = ".ic v(xvco.xcore.p4)=0 v(xvco.xcore.n4)=2\n"
    ctl = (".option method=gear reltol=1e-4 temp=%g\n%s.control\nset num_threads=2\ntran 5p %g 0 5p uic\n"
           "linearize v(ifip) v(ifin) v(ifqp) v(ifqn) %s\nlet vi = v(ifip)-v(ifin)\nlet vq = v(ifqp)-v(ifqn)\n"
           "wrdata %s vi vq %s\n.endc\n" % (temp, ic, tstop, " ".join("v(%s)" % n for n in PH), fn, " ".join("v(%s)" % n for n in PH)))
    text = top + lib + ctl + subs + "\n.end\n"
    text = re.sub(r"(sm141064\.ngspice) typical\b", r"\1 " + mo, text)
    text = text.replace("ngspice res_typical", "ngspice " + r).replace("ngspice mimcap_typical", "ngspice " + c)
    text = text.replace("VDD vdd 0 3.3", "VDD vdd 0 %g" % vdd)
    if pex:
        for cell in ("vco_ring4", "mixer_iq"):
            text = pexsim.swap(text, cell)
        a, cc = pex_vco.ring_ic()
        text = text.replace("v(xvco.xcore.p4)=0 v(xvco.xcore.n4)=2", "v(xvco.xpex.%s)=0 v(xvco.xpex.%s)=2" % (a, cc))
    return text


def lo_metrics(t, v, tmin):
    """fLO and phase errors of the 8 LO pins (pex_vco conventions) after tmin"""
    m = t >= tmin
    tt = np.linspace(t[m][0], t[m][-1], 400001)
    y = [np.interp(tt, t, v[:, i]) for i in range(8)]
    D = [y[2 * k] - y[2 * k + 1] for k in range(4)]
    c = tt[np.where((D[0][:-1] < 0) & (D[0][1:] >= 0))[0]]
    f = (len(c) - 1) / (c[-1] - c[0])
    ph = [np.angle(np.sum(s_ * np.exp(-2j * np.pi * f * tt)), deg=True) for s_ in D]
    err = [((ph[k] - ph[0] - pex_vco.IDEAL[k]) + 180) % 360 - 180 for k in range(4)]
    return 2 * f, err, (err[1] + err[3]) - (err[0] + err[2])


def fit(t, y, f):
    A = np.column_stack([np.cos(2 * np.pi * f * t), np.sin(2 * np.pi * f * t), np.ones_like(t), t])
    c = np.linalg.lstsq(A, y, rcond=None)[0]
    return np.hypot(c[0], c[1]), np.degrees(np.arctan2(-c[1], c[0]))


def if_freq(t, y):
    """IF frequency from the rising zero crossings of the (DC-removed) waveform"""
    y = y - np.mean(y)
    c = t[np.where((y[:-1] < 0) & (y[1:] >= 0))[0]]
    return (len(c) - 1) / (c[-1] - c[0])


def main():
    """usage: vcs=<sch VCTRL> vcp=<PEX VCTRL> fs=<sch fLO guess> fp=<PEX fLO guess> (Hz) [B=0] [corner]"""
    args = dict(a.split("=", 1) for a in sys.argv[1:] if "=" in a)
    vc = {False: float(args.get("vcs", "1.476")), True: float(args.get("vcp", "2.15"))}
    fg = {False: float(args.get("fs", "1570.8e6")), True: float(args.get("fp", "1556.8e6"))}
    b = int(args.get("B", "0")); corner = args.get("corner", "tt")
    T0, T1 = 0.4e-6, float(args.get("tstop", "1.0e-6"))
    os.makedirs(OUT, exist_ok=True)
    netlist("tb_vco"); netlist("tb_mixer")

    def one(pex):
        fn = os.path.join(OUT, "if2_%s.txt" % ("pex" if pex else "sch"))
        frf = fg[pex] + FIF
        if os.path.exists(fn):
            os.remove(fn)      # never analyse a stale waveform from an earlier run
        run.ngspice(deck(pex, vc[pex], b, corner, T1, frf, fn), "vcomix2_%s" % ("pex" if pex else "sch"), timeout=80000)
        d = np.loadtxt(fn); t = d[:, 0]; m = t > T0
        flo, err, iq = lo_metrics(t, d[:, 5::2], T0)
        fif = if_freq(t[m], d[m, 1])
        ai, pi_ = fit(t[m], d[m, 1], fif); aq, pq = fit(t[m], d[m, 3], fif)
        # drift: fLO over the first / second half of the window
        h = T0 + (T1 - T0) / 2
        f1 = lo_metrics(t[t < h], d[t < h, 5::2], T0)[0]; f2 = lo_metrics(t, d[:, 5::2], h)[0]
        return flo, f1, f2, err, iq, frf, fif, ai, aq, (pi_ - pq + 180) % 360 - 180
    with ThreadPoolExecutor(2) as ex:
        res = dict(zip((False, True), ex.map(one, (False, True))))
    for p in (False, True):
        flo, f1, f2, err, iq, frf, fif, ai, aq, dphi = res[p]
        print("%s vc=%.3f  fLO %.2f MHz (halves %.2f / %.2f)  LO err %s  LO I/Q %.2f deg | RF %.2f MHz  IF %.3f MHz  "
              "I %.2f mV  Q %.2f mV  imb %.2f dB  I-Q %.2f deg" % (
                  "PEX" if p else "sch", vc[p], flo / 1e6, f1 / 1e6, f2 / 1e6, "/".join("%.2f" % e for e in err[1:]), iq,
                  frf / 1e6, fif / 1e6, ai * 1e3, aq * 1e3, 20 * np.log10(ai / aq), dphi), flush=True)


if __name__ == "__main__":
    main()
