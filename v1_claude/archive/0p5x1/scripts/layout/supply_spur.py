"""Supply ripple -> LO spurs, closed loop (schematic tb_pll, TT, B=00).  The VCO is on its own VDDV.
Cases: sine ripple on VDD (bias, PLL, VCO control) or on VDDV (VCO) only, and a package case:
VDD / VDDV / VSS through bond wires with the full chip's AC supply current (from tb_full) injected.
LO phase modulation is measured from the l1p - l1n zero crossings (2-6 us).
usage: supply_spur.py run [case ...] | supply_spur.py ana [case ...]"""
import os, re, sys, numpy as np
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))
import run
OUT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "sim", "supply"))
FR = 16.368e6
# name: (VDD ripple mVp, VDDV ripple mVp, f, package)
CASES = {"base": (0, 0, 1e6, 0),
         "vdd_0p5": (20, 0, 0.5e6, 0), "vdd_1": (20, 0, 1e6, 0), "vdd_5": (20, 0, 5e6, 0), "vdd_16": (20, 0, FR, 0),
         "vddv_0p5": (1, 0, 0.5e6, 0), "vddv_1": (0, 1, 1e6, 0), "vddv_5": (0, 1, 5e6, 0), "vddv_16": (0, 1, FR, 0),
         "pkg": (0, 0, 1e6, 1), "pkg_dec": (0, 0, 1e6, 2)}
CASES["vddv_0p5"] = (0, 1, 0.5e6, 0)
# diagnosis: VDD ripple 20 mVp at 1 MHz with some pll_core sub-blocks (or the bias) on a clean 3.3 V
CLEAN = {"c_rb": ["XRB"], "c_div": ["XDB", "XDIV"], "c_pfd": ["XPFD"], "c_cp": ["XCP"], "c_cpb": ["XCP", "XB"],
         "c_all": ["XRB", "XDB", "XDIV", "XPFD", "XCP", "XB"]}
for k in CLEAN:
    CASES[k] = (20, 0, 1e6, 0)
# design after the 2026-11-09 fix (refbuf on VDDV): a_<case> = <case> with XRB on vddv
for k in ["base", "vdd_0p5", "vdd_1", "vdd_5", "vdd_16", "vddv_0p5", "vddv_1", "vddv_5", "vddv_16", "pkg_dec"]:
    CASES["a_" + k] = CASES[k]
CASES["a_pkg_156"] = (0, 0, 1e6, 3)
TSTOP = 6e-6
SRC = None

def deck(name):
    a_vdd, a_vv, f, pkg = CASES[name]
    s = SRC
    s = s.replace("XVCO vctrl b0 b1 nb l1p l1n l2p l2n l3p l3n l4p l4n ckr vr vdd 0 vco_ring4",
                  "XVCO vctrl b0 b1 nb l1p l1n l2p l2n l3p l3n l4p l4n ckr vr vddv 0 vco_ring4")
    assert " vddv 0 vco_ring4" in s
    if name.startswith("a_"):
        s, n = re.subn(r"^XRB refin refck vdd 0 refbuf$", "XRB refin refck vddv 0 refbuf", s, flags=re.M)
        assert n == 1
    src = "VDD vdd 0 3.3"
    for x in CLEAN.get(name, []):
        if x == "XB":
            s = s.replace("XB nb pb vdd 0 bias_gen", "XB nb pb vclean 0 bias_gen")
        elif x == "XRB":
            s = s.replace("XRB refin refck vdd 0 refbuf", "XRB refin refck vclean 0 refbuf")
        else:
            s, n = re.subn(r"^(%s .*) VDD VSS (\w+)$" % x, r"\1 vclean VSS \2", s, flags=re.M)
            assert n == 1, x
    if name in CLEAN:
        s = s.replace(src, src + "\n.global vclean\nVCLEAN vclean 0 3.3")
    if pkg:
        # chip-side nets vdd / vddv / vssi; board side ideal.  1 VDDA pad, 1 VDDV pad, ~3 VSS pads.
        top = []
        for l in s.split("\n"):
            if re.match(r"^[XC]", l) and not l.startswith("CL"):
                l = re.sub(r" 0 (\w+)$", r" vssi \1", l) if l.startswith("X") else re.sub(r"^(C\w+ \w+) 0 ", r"\1 vssi ", l)
            elif l.startswith("CL"):
                l = re.sub(r"^(CL\w+ \w+) 0 ", r"\1 vssi ", l)
            top.append(l)
        s = "\n".join(top)
        cdie = {2: "200p", 3: "156p"}.get(pkg, "30p")     # 3: 126 pF decap + ~30 pF parasitic
        s = s.replace(src, "VDD vddb 0 3.3\nLVDD vddb vdd1 2n\nRVDD vdd1 vdd 0.3\n"
                      "VDDV vddvb 0 3.3\nLVDDV vddvb vddv1 2n\nRVDDV vddv1 vddv 0.3\n"
                      "LVSS vssi vss1 0.7n\nRVSS vss1 0 0.1\n"
                      "CDIE vdd vssi %s\nCDIEV vddv vssi 10p\n"
                      "AIAC %%id([vdd vssi]) iacsrc\n.model iacsrc filesource (file=\"%s/iac2.txt\" amploffset=[0] amplscale=[1] "
                      "timeoffset=0 timescale=1 timerelative=false amplstep=false)" % (cdie, OUT))
    else:
        s = s.replace(src, "VDD vdd 0 dc 3.3 sin(3.3 %ge-3 %g 0 0)\nVDDV vddv 0 dc 3.3 sin(3.3 %ge-3 %g 0 0)" % (a_vdd, f, a_vv, f))
    s = re.sub(r"\.ic v\(vctrl\)=1\.7 v\(xpll\.xlf\.z\)=1\.7 v\(xpll\.vcp\)=1\.7", ".ic v(vctrl)=1.56 v(xpll.xlf.z)=1.56 v(xpll.vcp)=1.56", s)
    s = re.sub(r"save .*\ntran 5p 4u 0 5p uic\nwrdata tb_pll_vctrl v\(vctrl\)",
               "save v(vctrl) v(fb) v(refck) v(fs) v(l1p) v(l1n) v(vdd) v(vddv)\ntran 2p %g 0 2p uic\n"
               "wrdata %s/%s_w v(vctrl) v(l1p,l1n) v(vdd) v(vddv)" % (TSTOP, OUT, name), s)
    assert "wrdata %s/%s_w" % (OUT, name) in s
    return s

def phase(name):
    d = np.loadtxt(os.path.join(OUT, name + "_w"))
    t, lo = d[:, 0], d[:, 3]
    m = t > 2e-6; t, lo = t[m], lo[m]
    k = np.where((lo[:-1] < 0) & (lo[1:] >= 0))[0]
    tz = t[k] - lo[k] * (t[k + 1] - t[k]) / (lo[k + 1] - lo[k])
    n = np.arange(len(tz)); p = np.polyfit(n, tz, 1)
    # l1 is a ring phase (785.664 MHz); the mixer's LO is 2 x ring, so the LO phase deviation is twice it
    ph = -2 * 2 * np.pi * (tz - np.polyval(p, n)) / p[0]
    return tz, ph, 2 / p[0], d

def comp(tz, y, f):
    w = np.hanning(len(tz)); w /= w.mean()
    return abs(2 * np.mean(w * (y - y.mean()) * np.exp(-2j * np.pi * f * tz)))

def ana(name):
    tz, ph, flo, d = phase(name)
    a_vdd, a_vv, f, pkg = CASES[name]
    m = d[:, 0] > 2e-6
    r = "%-9s fLO %.3f MHz  VCTRL %.4f V  phase rms %.2f mrad" % (name, flo / 1e6, d[m, 1].mean(), 1e3 * ph.std())
    fs = [f] if not pkg else [1e6, 4.092e6, FR, 2 * FR]
    if name == "base": fs = [0.5e6, 1e6, 5e6, FR]
    for fm in fs:
        b = comp(tz, ph, fm)
        r += " | %.3g MHz: beta %.2e -> %.1f dBc" % (fm / 1e6, b, 20 * np.log10(max(b, 1e-12) / 2))
    if pkg:
        v = d[m, 5]; vv = d[m, 7]
        r += " | VDD pp %.1f mV, VDDV pp %.1f mV" % (1e3 * np.ptp(v), 1e3 * np.ptp(vv))
    return r

if __name__ == "__main__":
    cmd, names = sys.argv[1], sys.argv[2:] or list(CASES)
    if cmd == "run":
        SRC = open(run.netlist("tb_pll")).read()     # once: parallel xschem netlisting races
        from concurrent.futures import ThreadPoolExecutor
        with ThreadPoolExecutor(len(names)) as ex:
            for n, o in zip(names, ex.map(lambda n: run.ngspice(deck(n), "sup_" + n, timeout=10 * 3600), names)):
                print(n, [l for l in o.splitlines() if l.startswith("RES")] or o[-300:], flush=True)
    for n in names:
        try: print(ana(n), flush=True)
        except Exception as e: print(n, "ana failed", e)
