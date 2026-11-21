"""Review A-3: PLL acquisition from bad starting states and supply sequencing (schematic tb_pll).
  hi   : VCTRL starts at VDD (VCO at its maximum frequency: can the divider follow, does the loop come back?)
  lo   : VCTRL starts at 0 V
  vddv_late / vdd_late : one supply 2 us after the other (VCO + refbuf are on VDDV, the rest on VDD)
  ramp : both supplies ramp 0 -> nominal in 30 us (slow compared with every time constant in the loop)
usage: pll_acq.py case[,case...]   with case = corner:band:icp2:mode"""
import os, sys, re
from concurrent.futures import ThreadPoolExecutor
import numpy as np
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))
os.environ.setdefault("PDK", "gf180mcuD"); os.environ.setdefault("PDK_ROOT", os.path.expanduser("~/pdk"))
import run
NG = (lambda *a, **k: "") if os.environ.get("ANA") else run.ngspice   # ANA=1: analyse the saved waveforms only

FR = 16.368e6
CORN = {"tt": ("typical", 27, 3.3), "ss": ("ss", 85, 3.135), "ff": ("ff", -20, 3.465)}


def deck(base, case):
    corner, b, icp2, mode = case.split(":")
    lib, temp, v = CORN[corner]; b = int(b)
    tag = case.replace(":", "_")
    t = base
    for k in ("typical", "res_typical", "mimcap_typical"):
        t = t.replace("sm141064.ngspice %s\n" % k, "sm141064.ngspice %s\n" % k.replace("typical", lib))
    t = t.replace("VB0 b0 0 0", "EB0 b0 0 vdd 0 %d" % (b & 1)).replace("VB1 b1 0 0", "EB1 b1 0 vdd 0 %d" % (b >> 1))
    t = t.replace("VICP2 icp2 0 0", "EICP2 icp2 0 vdd 0 %s" % icp2)
    t = t.replace("sin(1.65 0.4 16.368e6)", "sin(%g 0.4 16.368e6)" % (v / 2))
    n0 = t.count(" vr vdd 0 vco_ring4"); assert n0 == 1
    t = t.replace(" vr vdd 0 vco_ring4", " vr vddv 0 vco_ring4")
    t, k = re.subn(r"^(XRB .*) vdd 0 refbuf", r"\1 vddv 0 refbuf", t, flags=re.M); assert k == 1
    tstop = 6e-6; ic = ""
    if mode in ("hi", "lo"):
        vdd = "VDD vdd 0 %g\nVDDV vddv 0 %g" % (v, v)
        x = v if mode == "hi" else 0.0
        ic = ".ic v(vctrl)=%g v(xpll.xlf.z)=%g v(xpll.vcp)=%g v(xvco.xcore.p4)=0 v(xvco.xcore.n4)=2" % (x, x, x)
    elif mode == "vddv_late":
        vdd = "VDD vdd 0 pwl(0 0 1u %g)\nVDDV vddv 0 pwl(0 0 3u 0 4u %g)" % (v, v); tstop = 10e-6
    elif mode == "vdd_late":
        vdd = "VDD vdd 0 pwl(0 0 3u 0 4u %g)\nVDDV vddv 0 pwl(0 0 1u %g)" % (v, v); tstop = 10e-6
    elif mode == "ramp":
        vdd = "VDD vdd 0 pwl(0 0 30u %g)\nVDDV vddv 0 pwl(0 0 30u %g)" % (v, v); tstop = 38e-6
    t, k = re.subn(r"^VDD vdd 0 3\.3$", vdd, t, flags=re.M); assert k == 1
    t, k = re.subn(r"^\.ic .*$", ic, t, flags=re.M); assert k == 1
    t = t.replace("save v(vctrl) ", "save v(vctrl) v(vr) v(nb) v(vdd) v(vddv) i(VDDV) ")
    t = t.replace("tran 5p 4u 0 5p uic", "tran 5p %g 0 5p uic" % tstop)
    t = t.replace("wrdata tb_pll_vctrl v(vctrl)", "wrdata review/acq_%s v(vctrl) v(fb) v(vr) v(nb) v(vdd) i(VDDV)" % tag)
    t, k = re.subn(r"^meas tran .*\n|^let .*\n|^echo RES.*\n", "", t, flags=re.M)
    t = t.replace(".control", ".temp %g\n.control" % temp, 1)
    return tag, t, tstop


def ana(tag, tstop):
    d = np.loadtxt(os.path.join(run.SIM, "review", "acq_%s" % tag))
    t = d[:, 0]; vc = d[:, 1]; fb = d[:, 3]; vr = d[:, 5]; nb = d[:, 7]; vdd = d[:, 9]
    T = 1 / FR
    out = []
    # FB frequency per 0.5 us window (x96 -> fLO)
    th = vdd.max() / 2
    r = np.where((fb[:-1] < th) & (fb[1:] >= th))[0]; tr = t[r]
    w = 0.5e-6 if tstop < 20e-6 else 2e-6
    for a in np.arange(0, tstop - 1e-12, w):
        m = (t >= a) & (t < a + w); e = tr[(tr >= a) & (tr < a + w)]
        f = (len(e) - 1) / (e[-1] - e[0]) * 96 / 1e6 if len(e) > 2 else 0.0
        out.append("%5.1f-%5.1f us  VDD %.2f  VCTRL %.3f..%.3f V  VR %.2f V  NB %.3f V  fFB x96 = %7.1f MHz" % (
            a * 1e6, (a + w) * 1e6, vdd[m].mean(), vc[m].min(), vc[m].max(), vr[m].mean(), nb[m].mean(), f))
    m = t > tstop - 9 * T
    e = tr[tr > tstop - 9 * T]
    f = (len(e) - 1) / (e[-1] - e[0]) * 96 / 1e6 if len(e) > 2 else 0.0
    ok = abs(f - 96 * FR / 1e6) < 0.5 and np.ptp(vc[m]) < 0.05
    out.append("END VCTRL %.4f V pp %.1f mV  fLO %.2f MHz  -> %s" % (vc[m].mean(), 1e3 * np.ptp(vc[m]), f, "LOCKED" if ok else "NOT LOCKED"))
    return out


def main():
    os.makedirs(os.path.join(run.SIM, "review"), exist_ok=True)
    base = open(run.netlist("tb_pll")).read()
    decks = [deck(base, c) for c in sys.argv[1].split(",")]
    with ThreadPoolExecutor(len(decks)) as ex:
        outs = list(ex.map(lambda d: NG(d[1], "rev_acq_" + d[0], timeout=400000), decks))
    for (tag, _, tstop), out in zip(decks, outs):
        print("== " + tag, " ".join(l for l in out.splitlines() if "rror" in l))
        for l in ana(tag, tstop):
            print("   " + l)
        sys.stdout.flush()


if __name__ == "__main__":
    main()
