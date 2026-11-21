"""VCO (vco_ring4) schematic vs PEX: LO frequency (= 2 x ring), phase errors of the 8 outputs
(mixer commutation instants), I/Q error at fLO, duty, swing, current.
usage: pex_vco.py [--nopex] [B=0,3] [vc=1.5,2.1,2.7] [corner=tt|ss|ff]
The ring nodes are anonymous after extraction; two complementary ones are found from the
netlist (the 8 nets gating the big ring devices) so PEX gets the same differential .ic."""
import os, sys, re, collections
import numpy as np
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
os.environ.setdefault("PDK", "gf180mcuD"); os.environ.setdefault("PDK_ROOT", os.path.expanduser("~/pdk"))
import pexsim, lvs
from concurrent.futures import ThreadPoolExecutor
from pexsim import run
base = lambda n: re.sub(r"\.[tn]\d+$", "", n)
CORNER = {"tt": ("typical", "res_typical", "mimcap_typical", 27, 3.3),
          "ss": ("ss", "res_ss", "mimcap_ss", 85, 3.135),
          "ff": ("ff", "res_ff", "mimcap_ff", -20, 3.465)}
OUT = os.path.join(pexsim.PROJ, "sim", "pex_vco")


def ring_ic():
    """two complementary ring nodes of the PEX netlist (4 inverters apart in the 8-node loop)"""
    txt = open(os.path.join(pexsim.MAG, "vco_ring4.pex.spice")).read().replace("\n+", " ")
    gates = collections.defaultdict(list); full = {}; drv = collections.defaultdict(set)
    for l in txt.split("\n"):
        p = l.split()
        if p and p[0][0] == "X" and "fet_03v3" in l:
            w = re.search(r" w=(\S+)", l).group(1); typ = "n" if "nfet" in l else "p"
            gates[base(p[2])].append(typ + w); full.setdefault(base(p[2]), p[2])
            if w in ("4u", "3u"):
                for d in (p[1], p[3]):
                    drv[base(d)].add(base(p[2]))
    ring = [n for n, g in gates.items() if g.count("n4u") >= 2 and g.count("p3u") >= 4]
    assert len(ring) == 8, ring
    # each node is driven by the previous stage and by its cross-coupled latch partner; the partner
    # (the two drive each other) is the complementary node of the same stage.  Sorted, because
    # walking the drive sets in set order picked a different (sometimes the same) node per run.
    a = sorted(ring)[0]
    c = [g for g in sorted(drv[a]) if g in ring and a in drv[g]][0]
    return full[a], full[c]


PH = ("l1p", "l1n", "l2p", "l2n", "l3p", "l3n", "l4p", "l4n")
# phase of the differential output k at the ring frequency relative to output 1 (output 4 is
# the inverted wrap-around stage: +45 = -135 + 180)
IDEAL = (0, -45, -90, 45)
# I/Q error at fLO: I commutes at outputs 1/3, Q at 2/4 -> (e2 + e4) - (e1 + e3)


def analyze(fn):
    d = np.loadtxt(fn); t = d[:, 0]; v = d[:, 1::2]
    tt = np.linspace(t[0], t[-1], 200001); y = [np.interp(tt, t, v[:, i]) for i in range(10)]
    D = [y[2 * k] - y[2 * k + 1] for k in range(4)]
    c = tt[np.where((D[0][:-1] < 0) & (D[0][1:] >= 0))[0]]
    T = (c[-1] - c[0]) / (len(c) - 1); f = 1 / T
    n = int((tt[-1] - tt[0]) / T); m = tt >= tt[-1] - n * T
    ph = [np.angle(np.sum(s_[m] * np.exp(-2j * np.pi * f * tt[m])), deg=True) for s_ in D]
    err = [((ph[k] - ph[0] - IDEAL[k]) + 180) % 360 - 180 for k in range(4)]
    return dict(f=2 * f, err=err, iq=(err[1] + err[3]) - (err[0] + err[2]),
                duty=[np.mean(D[k][m] > 0) for k in range(4)],
                vpp=min(np.ptp(y[k][m]) for k in range(8)), idd=-np.mean(y[8][m]), vr=np.mean(y[9][m]))


def deck(t, corner, b, vc, fn):
    mo, r, c, temp, vdd = CORNER[corner]
    t = re.sub(r"(sm141064\.ngspice) typical\b", r"\1 " + mo, t)
    t = t.replace("sm141064.ngspice res_typical", "sm141064.ngspice " + r).replace("sm141064.ngspice mimcap_typical", "sm141064.ngspice " + c)
    t = t.replace("VDD vdd 0 3.3", "VDD vdd 0 %g" % vdd)
    t = t.replace("VB0 b0 0 0", "VB0 b0 0 %g" % (vdd * (b & 1))).replace("VB1 b1 0 0", "VB1 b1 0 %g" % (vdd * (b >> 1)))
    ctl = (".option temp=%g\n.control\nset num_threads=1\nalter VC dc = %g\ntran 1p 40n 20n uic\n"
           "wrdata %s %s i(VDD) v(vr)\n.endc" % (temp, vc, fn, " ".join("v(%s)" % p for p in PH)))
    return re.sub(r"^\.control.*?^\.endc", lambda _: ctl, t, flags=re.M | re.S)


def main():
    args = dict(a.split("=", 1) for a in sys.argv[1:] if "=" in a)
    bands = [int(x) for x in args.get("B", "0,3").split(",")]
    vcs = [float(x) for x in args.get("vc", "1.5,1.8,2.1,2.4,2.7").split(",")]
    corner = args.get("corner", "tt")
    if "--nopex" not in sys.argv:
        lvs.pex("vco_ring4", pexsim.MAG)
    os.makedirs(OUT, exist_ok=True)
    t = open(run.netlist("tb_vco")).read()
    a, c = ring_ic()
    pex = pexsim.swap(t, "vco_ring4").replace("v(xvco.xcore.p4)=0 v(xvco.xcore.n4)=2", "v(xvco.xpex.%s)=0 v(xvco.xpex.%s)=2" % (a, c))
    jobs = [(k, b, vc) for b in bands for vc in vcs for k in ("sch", "pex")]

    def go(j):
        k, b, vc = j
        fn = os.path.join(OUT, "%s_%s_b%d_%g.txt" % (k, corner, b, vc))
        run.ngspice(deck(t if k == "sch" else pex, corner, b, vc, fn), "vco_%s_%s_b%d_%g" % (k, corner, b, vc))
        try:
            return j, analyze(fn)
        except Exception:
            return j, None
    with ThreadPoolExecutor(8) as ex:
        res = dict(ex.map(go, jobs))
    fmt = lambda r: ("fLO %7.1f MHz  I/Q err %5.2f deg  phase err %s  duty %s  swing %.2f V  %.2f mA  VR %.2f" % (
        r["f"] / 1e6, r["iq"], "/".join("%.1f" % e for e in r["err"][1:]), "/".join("%.3f" % x for x in r["duty"]),
        r["vpp"], r["idd"] * 1e3, r["vr"])) if r else "   (no oscillation)"
    for b in bands:
        print("== %s  band B1B0=%d" % (corner, b))
        for vc in vcs:
            print("vc=%.2f  sch %s" % (vc, fmt(res[("sch", b, vc)])))
            print("          pex %s" % fmt(res[("pex", b, vc)]))


if __name__ == "__main__":
    main()
