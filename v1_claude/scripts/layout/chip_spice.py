"""Transistor-level simulation of the whole chip, analog and digital together, at 3.3 V / TT / 27 C.
  digital : placed-and-routed netlist chip/final/pnl/chip_top.pnl.v (standard cells + pads, wire capacitance from SPEF),
            converted by core_spice.convert()
  analog  : the macro gnss_afe_analog = the schematic netlist of gnss_afe_top (sim/netlist/tb_full.spice) without its
            schematic SPI block; its control pins are driven by the digital core, its outputs drive the real pads
  supplies: not ideal; bond wires on every supply group, the analog and the digital side of the on-chip VSS net are
            joined by RVSS (assumed)
Two SPI frames with the same word W: frame 1 during the PLL acquisition (reads the reset value, sets the gain),
frame 2 after everything has settled (reads W back; the control word does not change, so every change of the IF
output during frame 2 is coupling from the SPI pins / SDO).
  case: load on the SDO pad (None = pad left open)
  pex_* : the analog blocks vco_ring4, pll_core, lna_nc, mixer_iq, if_chain (x2), adc2b (x2), afc_dac and vmon_buf are
          replaced by their extracted (PEX) netlists, and the top-level wiring of the macro is added from top_wires.json
          (ground and net-to-net coupling capacitance on every net, series resistance on the LO nets).  The internal
          vctrl net is kept apart from the VCTRL pad (the schematic netlist merges them: ngspice ignores case).
  iso_* : as sdo_*, but the analog and the digital side of VSS are not joined on the chip (RVSS = 1 MOhm); frame 1 only
  ser_* : as sdo_*, but every output pin has a series resistor RSER on the board (CPIN at the pin, the load behind it)
  *_l   : long runs (LTEND) with frame 1 only, to size the leak of the output pads into the IF after the start-up
          transient: ser_330l / ser_1kl = series resistor 330 ohm / 1 kohm, iso_l = VSS separated (reference)
  nz_* / ns_* : long runs (NTEND) with the RF noise of tb_full (LNA + SAW in front of the chip, -154 dBm/Hz) and frame 1
          only; nz = noise alone, ns = the same noise + the CW tone, so that ns - nz is the response to the signal.
          _ser = series resistor 330 ohm (the board), _iso = VSS separated, _ref = VSS separated and ideal analog
          supplies (no bond wire inductance): no path from the pads and no common supply impedance inside the macro
          cw_ref = as ns_ref without the noise (without a leak the IF chain is linear, so this is the same signal response)
usage: chip_spice.py run [case ...] | chip_spice.py ana [case ...] | chip_spice.py cmp caseA caseB"""
import os, re, sys, subprocess, json
import numpy as np
import core_spice
from core_spice import ROOT, PDK, RST, ID
OUT = os.path.join(ROOT, "sim", "chip")
TB = os.path.join(ROOT, "sim", "netlist", "tb_full.spice")
CASES = {"sdo_c30": 30e-12, "sdo_open": None, "pex_c30": 30e-12, "pex_open": None, "iso_c30": 30e-12, "ser_c30": 30e-12,
         "ser_330l": 30e-12, "ser_1kl": 30e-12, "iso_l": 30e-12,
         "nz_ser": 30e-12, "ns_ser": 30e-12, "nz_iso": 30e-12, "ns_iso": 30e-12, "nz_ref": 30e-12, "ns_ref": 30e-12, "cw_ref": 30e-12}
LONG = {"ser_330l": 330, "ser_1kl": 1000, "iso_l": None,      # series resistor of the long runs
        "nz_ser": 330, "ns_ser": 330, "nz_iso": None, "ns_iso": None, "nz_ref": None, "ns_ref": None, "cw_ref": None}
NOISE = [c for c in LONG if c[:3] in ("nz_", "ns_", "cw_")]
LTEND = 10e-6; NTEND = 11e-6
VNOISE = "dc 0 trnoise(0.9m 49.7p 0 0)"     # as tb_full: open-circuit 0.9 mV rms over 10 GHz
# ns_ref stops with "Timestep too small" (10 ps: at 1.178 us, 9.7 ps: at 0.694 us) -> third try with 10 aF from every node to ground
DTC = {"ns_ref": 9.85e-12}         # largest step
OPT = {"ns_ref": " cshunt=1e-17"}
PEXCELLS = "vco_ring4 pll_core lna_nc mixer_iq if_chain adc2b afc_dac vmon_buf".split()
VC0 = 2.09                         # PEX: VCTRL starts near the post-layout lock point (pex_pllmix: 2.093 V)
VDD = 3.3; F = 10e6; TR = 2e-9
W = 0x008015                       # gain 01 / 01 / 01, AFC7 = 1 (same as after reset)
FRAMES = [(0.5e-6, W), (4.2e-6, W)]
TEND = 6.9e-6; DT = 10e-12
PTEND = 4.2e-6                     # PEX runs: frame 1 only (about 0.2 s per step)
TRST = 300e-9                      # release of rst_n
CPAD = 5e-12                       # load on I/Q/CLKOUT pads
LW, RW, RDAMP = 1.5e-9, 0.15, 150  # one bond wire; RDAMP in parallel (loss of the wire / package)
RVSS = 0.5                         # on-chip VSS between the macro and the pad ring / core (assumed)
RSER, CPIN = 330, 0.5e-12          # ser_*: board series resistor at every output pin, stub capacitance at the pin
CRING = 100e-12                    # DVDD - DVSS capacitance of the pad ring
CTL = "IG1A IG1B IG2A IG2B IG3A IG3B B0 B1 AFC0 AFC1 AFC2 AFC3 AFC4 AFC5 AFC6 AFC7 ICP2 BWK BWN".split()
MPORTS = "RFIN REFIN".split() + CTL + "I_SIGN I_MAG Q_SIGN Q_MAG CLKOUT AFCOUT VCTRL VDDV VDD VSS".split()


def top_wires(body):
    """body of the macro with the parasitics of its top-level wiring -> lines"""
    import pexsim, pex_vco
    w = json.load(open(os.path.join(pexsim.MAG, "top_wires.json"))); PH = pex_vco.PH
    nets = set(n.lower() for l in body for n in l.split()[1:])
    name = lambda n: n if n.lower() in nets else None
    out = []
    for l in body:
        if l.startswith("XVCO "):       # LO nets: VCO pin <net>v -- R -- mixer pin <net>
            p = l.split(); l = " ".join(x + "v" if x in PH else x for x in p)
        out.append(l)
    k = 0
    for n, q in sorted(w.items()):
        assert name(n), n
        if n in PH:
            out += ["RW%s %sv %s %g" % (n, n, n, max(q["r"], 1e-3)), "CW%sa %sv VSS %g" % (n, n, q["c"] / 2), "CW%sb %s VSS %g" % (n, n, q["c"] / 2)]
        else:
            out.append("CW%s %s VSS %g" % (n, n, q["c"]))
        for o, v in sorted(q["cc"].items()):
            k += 1
            if n in PH and o in PH:
                if o > n:
                    out += ["CC%da %sv %sv %g" % (k, n, o, v / 2), "CC%db %s %s %g" % (k, n, o, v / 2)]
            elif n in PH or o in PH:    # LO net to another net: to ground, as in pex_vcomix
                if n in PH:
                    out.append("CC%d %s VSS %g" % (k, n, v))
            elif o > n:
                out.append("CC%d %s %s %g" % (k, n, o, v))
    return out


def analog(pex=False):
    """schematic netlist: (subcircuit gnss_afe_analog + all lower subcircuits); pex: see the module text"""
    s = open(TB).read()
    s = s[s.index("* expanding   symbol:  gnss_afe_top.sym"):s.rindex(".end")]
    a = s.index(".subckt gnss_afe_top"); b = s.index(".ends", a)
    body = [l for l in s[a:b].split("\n")[1:] if not l.startswith(("XSPI ", "XBW ", "*."))]
    assert len(body) == 17, len(body)
    if pex:
        body = [re.sub(r"\bvctrl\b", "vctrl_i", l) if l.startswith(("XMON ", "XVCO ", "XPLL ")) else l for l in body]
        assert sum("vctrl_i" in l for l in body) == 3
        body = top_wires(body)
    t = s[:a] + ".subckt gnss_afe_analog " + " ".join(MPORTS) + "\n" + "\n".join(body) + "\n" + s[b:]
    if pex:
        import pexsim
        for c in PEXCELLS:
            t = pexsim.swap(t + "\n.end\n", c)
            t = t[:t.rindex(".end")]
    return t


def pex_ic():
    import pex_vco, pex_pllmix
    a, c = pex_vco.ring_ic(); z, c2 = pex_pllmix.lf_nodes()
    return "v(a_vctrl)=%g v(xdut.vctrl_i)=%g v(xdut.%s)=%g v(xdut.%s)=%g v(xdut.xvco.xpex.%s)=0 v(xdut.xvco.xpex.%s)=1" % (VC0, VC0, z, VC0, c2, VC0, a, c)


def stim(n=2):
    """-> PWL of SCLK, SDI, CS_N, [(rising edges, word, t CS_N falls, t CS_N rises)] for the first n frames"""
    T = 1 / F; ck = [(0, 0)]; di = [(0, 0)]; cs = [(0, 1)]; fr = []
    for t, w in FRAMES[:n]:
        cs += [(t, 1), (t + TR, 0)]; edges = []
        for k in range(24):
            b = (w >> (23 - k)) & 1
            di += [(t + k * T, di[-1][1]), (t + k * T + TR, b)]
            tr = t + k * T + T / 2
            ck += [(tr, 0), (tr + TR, 1), (tr + T / 2, 1), (tr + T / 2 + TR, 0)]
            edges.append(tr + TR / 2)
        te = t + 24 * T + T / 2
        cs += [(te, 0), (te + TR, 1)]
        fr.append((edges, w, t + TR / 2, te + TR / 2))
    pwl = lambda p: "pwl(" + " ".join("%.5e %g" % (a, b * VDD) for a, b in p) + ")"
    return pwl(ck), pwl(di), pwl(cs), fr


def wire(name, a, b, n):
    """n bond wires in parallel between the board node a and the chip node b"""
    return ["L%s %s %s_m %g" % (name, a, name, LW / n), "RP%s %s %s_m %g" % (name, a, name, RDAMP / n),
            "RS%s %s_m %s %g" % (name, name, b, RW / n)]


def saved(node, mac, vc="a_vctrl", more=False):
    ctl = [node[mac[p]] for p in CTL]
    ex = ["v(%s)" % n for n in [node["bidir_PAD[1]"], node["bidir_PAD[3]"], "xdut.fs"] + [node[mac[p]] for p in "I_SIGN I_MAG Q_SIGN Q_MAG".split()]]
    return ["v(%s)" % n for n in [node["clk_PAD"], node["input_PAD[1]"], "out5", node["bidir_PAD[5]"]] + ctl] + \
        ["v(xdut.aip,xdut.ain)", "v(xdut.aqp,xdut.aqn)", "v(xdut.mip,xdut.min)", "v(xdut.mqp,xdut.mqn)", "v(%s)" % vc,
         "v(%s)" % node["bidir_PAD[4]"], "v(vssa)", "v(vssd)", "v(vdda)", "v(vddd)", "v(vddv)", "i(VSUP)", "i(VSUPD)",
         "v(%s)" % node["bidir_PAD[0]"], "v(%s)" % node["bidir_PAD[2]"]] + (ex if more else [])


def deck(case, tend=None):
    tend = tend or (NTEND if case in NOISE else LTEND if case in LONG else TEND if case.startswith("sdo") else PTEND)
    rser = LONG.get(case) or RSER
    ser = case.startswith("ser") or case.endswith("_ser"); iso = case.startswith("iso") or case in NOISE and not ser
    na = 1e6 if case.endswith("_ref") else 1          # _ref: ideal analog supplies
    cl = CASES[case]; pex = case.startswith("pex")
    lines, node, mac = core_spice.convert(vdd="vddd", vss="vssd")
    io = re.sub(r"(ppolyf_u[^\n]*?) m=1\.0 r=\S+", r"\1", open(PDK + "/libs.ref/gf180mcu_fd_io/spice/gf180mcu_fd_io.spice").read())
    ck, di, cs, fr = stim(1 if case in LONG else 2)
    # as in tb_full the supplies are on from t = 0 (uic); a ramp would discharge the preset loop filter through the well diodes
    x = ["VSUP vb 0 %g" % VDD, "VSUPD vbd 0 %g" % VDD]
    x += wire("vdda", "vb", "vdda", na) + wire("vddv", "vb", "vddv", na) + wire("vddd", "vbd", "vddd", 4)
    x += wire("vssa", "0", "vssa", 4 * na) + wire("vssd", "0", "vssd", 4)
    x += ["RVSS vssa vssd %g" % (1e6 if iso else RVSS), "CRING vddd vssd %g" % CRING]
    x += ["VCK %s 0 %s" % (node["clk_PAD"], ck), "VDI %s 0 %s" % (node["input_PAD[0]"], di), "VCS %s 0 %s" % (node["input_PAD[1]"], cs),
          "VRST %s 0 pwl(0 0 %g 0 %g %g)" % (node["rst_n_PAD"], TRST, TRST + TR, VDD)]
    # analog macro; reference, RF source (CW, no noise) as in tb_full
    con = {"VDDV": "vddv", "VDD": "vdda", "VSS": "vssa"}
    for p in ("RFIN", "REFIN", "AFCOUT", "VCTRL"):      # analog pads are not in the converted netlist
        node.setdefault(mac[p], "a_" + p.lower())
    x.append("XDUT " + " ".join(con[p] if p in con else node[mac[p]] for p in MPORTS) + " gnss_afe_analog")
    x += ["VREF %s 0 sin(1.65 0.4 16.368e6)" % node[mac["REFIN"]], "RSP sp sps 50",
          "CCP sps %s 10p" % node[mac["RFIN"]], "RAFC %s 0 100k" % node[mac["AFCOUT"]]]
    x += ["VRFP sp0 0 sin(0 %s 1575.42e6)" % ("0" if case.startswith("nz_") else "11.2u"), "VRNP sp sp0 " + ("dc 0" if case.startswith("cw_") else VNOISE)] if case in NOISE else \
        ["VRFP sp 0 sin(0 11.2u 1575.42e6)"]
    for k in range(6):                     # bond wire + load on every output pad
        n = node["bidir_PAD[%d]" % k]; c = cl if k == 5 else CPAD
        if c and ser:
            x += ["LB%d %s pb%d %g" % (k, n, k, LW), "RPB%d %s pb%d 300" % (k, n, k), "RB%d pb%d pin%d %g" % (k, k, k, RW),
                  "CP%d pin%d 0 %g" % (k, k, CPIN), "RSER%d pin%d out%d %g" % (k, k, k, rser), "CL%d out%d 0 %g" % (k, k, c)]
        elif c:
            x += ["LB%d %s pb%d %g" % (k, n, k, LW), "RPB%d %s pb%d 300" % (k, n, k), "RB%d pb%d out%d %g" % (k, k, k, RW), "CL%d out%d 0 %g" % (k, k, c)]
        else:
            x += ["RB%d %s out%d 1m" % (k, n, k)]
    sv = " ".join(saved(node, mac, "xdut.vctrl_i" if pex else "a_vctrl", case in NOISE))
    sav = sorted(set(re.findall(r"[\w.\[\]]+", sv.replace("v(", " ").replace("i(", " ").replace(")", " ").replace(",", " "))) - {"VSUP", "VSUPD"})
    return """* whole chip: analog macro (schematic) + digital core and pads (P&R netlist), %s
.include %s/libs.tech/ngspice/design.ngspice
.lib %s/libs.tech/ngspice/sm141064.ngspice typical
.lib %s/libs.tech/ngspice/sm141064.ngspice res_typical
.lib %s/libs.tech/ngspice/sm141064.ngspice mimcap_typical
.lib %s/libs.tech/ngspice/sm141064.ngspice diode_typical
.lib %s/libs.tech/ngspice/sm141064.ngspice moscap_typical
.include %s/libs.ref/gf180mcu_fd_sc_mcu7t5v0/spice/gf180mcu_fd_sc_mcu7t5v0.spice
%s
%s
.temp 27
%s
%s
.option method=gear reltol=2e-4 minbreak=1e-12%s
.ic v(vdda)=%g v(vddv)=%g v(vddd)=%g %s
.control
set num_threads=%d
save %s i(VSUP) i(VSUPD)
tran %g %g 0 %g uic
rusage time
wrdata %s_out %s
.endc
.end
""" % (case, PDK, PDK, PDK, PDK, PDK, PDK, PDK, io, analog(pex), "\n".join(x), "\n".join(lines),
       OPT.get(case, ""), VDD, VDD, VDD, pex_ic() if pex else "v(a_vctrl)=1.7 v(xdut.xpll.xlf.z)=1.7 v(xdut.xpll.vcp)=1.7 v(xdut.xvco.xcore.p4)=0 v(xdut.xvco.xcore.n4)=1",
       4 if pex else 2 if case in NOISE else 5 if case in LONG else 6, " ".join("v(%s)" % n for n in sav), DTC.get(case, DT), tend, DTC.get(case, DT), case, sv)


def run(cases, tend=None):
    for c in cases:
        open(os.path.join(OUT, c + ".spice"), "w").write(deck(c, tend))
        for f in (c + ".end", c + "_out"):
            if os.path.exists(os.path.join(OUT, f)):
                os.remove(os.path.join(OUT, f))
        subprocess.Popen(["nohup", "sh", "-c", "date > %s.start; ngspice -b %s.spice > %s.log 2>&1; date > %s.end" % ((c,) * 4)], cwd=OUT,
                         stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, start_new_session=True)
        print("started", c)


NS = 4 + len(CTL)      # columns of wrdata: (t, value) pairs
COL = {"ifI": NS, "ifQ": NS + 1, "mixI": NS + 2, "mixQ": NS + 3, "vctrl": NS + 4, "clkout": NS + 5, "vssa": NS + 6, "vssd": NS + 7,
       "vdda": NS + 8, "vddd": NS + 9, "vddv": NS + 10, "isup": NS + 11, "isupd": NS + 12, "isign": NS + 13, "qsign": NS + 14,
       "imag": NS + 15, "qmag": NS + 16, "fs": NS + 17, "aisign": NS + 18, "aimag": NS + 19, "aqsign": NS + 20, "aqmag": NS + 21}      # from imag on: nz_* / ns_* only


def load(c):
    f = os.path.join(OUT, c + "_out"); n = os.path.join(OUT, c + "_out.npy")
    if not os.path.exists(n) or os.path.getmtime(n) < os.path.getmtime(f):
        try:
            d = np.loadtxt(f)
        except (UnicodeDecodeError, ValueError):       # damaged lines in the file: leave out the whole stretch that holds them
            L = open(f, "rb").read().split(b"\n"); L = L[:-1] if not L[-1] else L; nf = len(L[0].split())

            def good(l):
                try:
                    v = [float(x) for x in l.decode("ascii").split()]
                except (UnicodeDecodeError, ValueError):
                    return False
                return len(v) == nf and len(set(v[::2])) == 1
            bad = [i for i, l in enumerate(L) if not good(l)]
            print("%s: %d damaged lines in %d ... %d left out with 20 lines around them" % (c, len(bad), bad[0] + 1, bad[-1] + 1))
            d = np.loadtxt(L[:bad[0] - 20] + L[bad[-1] + 21:])
        np.save(n, np.hstack([d[:, :1], d[:, 1::2]]))
    d = np.load(n)
    return d[:, 0], d[:, 1:]


def tone(t, v, f, a, b):
    """amplitude of the component of v at f in a..b (least squares, with offset and slope)"""
    m = (t >= a) & (t <= b); tt = t[m] - a
    M = np.stack([np.cos(2 * np.pi * f * tt), np.sin(2 * np.pi * f * tt), np.ones(m.sum()), tt], 1)
    k = np.linalg.lstsq(M, v[m], rcond=None)[0]
    return np.hypot(k[0], k[1]), v[m] - M @ k


def freq(t, v, a, b, th):
    m = (t >= a) & (t <= b); tt = t[m]; s = v[m] > th
    i = np.where(~s[:-1] & s[1:])[0]
    return (len(i) - 1) / (tt[i[-1]] - tt[i[0]]) if len(i) > 1 else 0


def ana(cases):
    for c in cases:
        t, d = load(c); sdo = d[:, 2]; ctl = [d[:, 4 + k] for k in range(len(CTL))]
        g = lambda k: d[:, COL[k]]
        fr = stim(1 if c in LONG else 2)[3]; T = 1 / F; hi, lo = 0.7 * VDD, 0.3 * VDD
        at = lambda s, x: s[min(np.searchsorted(t, x), len(t) - 1)]
        ok = True; print("== %s  (SDO load %s, simulated %.2f us)" % (c, "%g pF" % (CASES[c] * 1e12) if CASES.get(c) else "none", t[-1] * 1e6))
        exp_ctl = RST
        for i, (edges, w, t0, t1) in enumerate(fr):
            if t1 + 0.1e-6 > t[-1]:
                break
            exp = (ID << 19) | exp_ctl; got = 0; marg = []
            for k, te in enumerate(edges):
                b = (exp >> (23 - k)) & 1; got = (got << 1) | (1 if at(sdo, te) > VDD / 2 else 0)
                tb = t0 if k == 0 else edges[k - 1] + T / 2
                m = (t >= tb) & (t <= te); bad = np.where(m & ((sdo < hi) if b else (sdo > lo)))[0]
                marg.append((te - (t[bad[-1]] if len(bad) else tb)) * 1e9)
            print("  frame %d: sent %06X, SDO read %06X (expected %06X) %s; SCLK fall -> SDO valid max %.1f ns; least margin before the rising edge %.1f ns"
                  % (i + 1, w, got, exp, "OK" if got == exp else "MISMATCH", max(T / 2 * 1e9 - x for x in marg[1:]), min(marg)))
            ok &= got == exp; exp_ctl = w & 0x7FFFF; tc = t1 + 100e-9
            val = sum((1 if at(s, tc) > VDD / 2 else 0) << k for k, s in enumerate(ctl)) ^ (1 << 17)      # BWK = ~ctl[17]
            print("           control inputs of the macro 100 ns after CS_N rises: %05X (expected %05X) %s" % (val, exp_ctl, "OK" if val == exp_ctl else "MISMATCH"))
            ok &= val == exp_ctl
        print("  -> digital", "PASS" if ok else "FAIL")
        for a, b in ((1, 2), (2, 3), (3.2, 4.2), (4.2, 6.7), (6.7, 6.9), (6.9, 9.9)):
            a, b = a * 1e-6, b * 1e-6
            if b > t[-1]:
                continue
            m = (t >= a) & (t <= b); w = np.gradient(t)[m]; avg = lambda v: np.sum(v[m] * w) / np.sum(w)
            aI, rI = tone(t, g("ifI"), 4.092e6, a, b); aQ, rQ = tone(t, g("ifQ"), 4.092e6, a, b)
            print("  %.2f-%.2f us: vctrl %.4f V (pp %.2f mV)  CLKOUT pad %.4f MHz  IF tone I %.2f mV Q %.2f mV  rest pp I %.2f mV Q %.2f mV"
                  "  I(VDDA+VDDV) %.2f mA  I(VDD digital) %.3f mA" % (a * 1e6, b * 1e6, avg(g("vctrl")), np.ptp(g("vctrl")[m]) * 1e3,
                  freq(t, g("clkout"), a, b, VDD / 2) / 1e6, aI * 1e3, aQ * 1e3, np.ptp(rI) * 1e3, np.ptp(rQ) * 1e3, -avg(g("isup")) * 1e3, -avg(g("isupd")) * 1e3))
            print("                 pp: VSS analog %.2f mV  VSS digital %.2f mV  VDDA %.2f mV  VDDV %.2f mV  VDD digital %.2f mV"
                  % tuple(np.ptp(g(k)[m]) * 1e3 for k in ("vssa", "vssd", "vdda", "vddd" if 0 else "vddv", "vddd")))


def cmp(a, b):
    """difference of the IF outputs of two runs on a common time grid"""
    ta, da = load(a); tb, db = load(b); te = min(ta[-1], tb[-1]); tg = np.arange(0.2e-6, te, 20e-12)
    print("== %s minus %s (common grid 20 ps, up to %.2f us)" % (a, b, te * 1e6))
    for k in ("ifI", "ifQ", "mixI", "mixQ", "vctrl", "vssa", "vdda"):
        x = np.interp(tg, ta, da[:, COL[k]]) - np.interp(tg, tb, db[:, COL[k]])
        s = "  %-6s" % k
        for p, q in ((1, 2), (3.2, 4.2), (4.2, 6.7), (6.7, 6.9)):
            m = (tg >= p * 1e-6) & (tg <= q * 1e-6)
            if m.sum() > 10:
                s += "  %.2f-%.2f us: rms %.4f mV pp %.4f mV" % (p, q, np.std(x[m]) * 1e3, np.ptp(x[m]) * 1e3)
        print(s)


if __name__ == "__main__":
    os.makedirs(OUT, exist_ok=True)
    if sys.argv[1] == "cmp":
        cmp(*sys.argv[2:4])
    elif sys.argv[1] == "smoke":
        c = sys.argv[3] if len(sys.argv) > 3 else "sdo_c30"
        open(os.path.join(OUT, "smoke_%s.spice" % c), "w").write(deck(c, float(sys.argv[2])).replace(c + "_out", "smoke_%s_out" % c))
    else:
        cs = sys.argv[2:] or [c for c in CASES if c.startswith("sdo")]
        run(cs) if sys.argv[1] == "run" else ana(cs)
