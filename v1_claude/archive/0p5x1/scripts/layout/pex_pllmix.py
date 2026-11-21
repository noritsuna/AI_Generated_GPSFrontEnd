"""Closed-loop PLL, post-layout with the real LO load: pll_core PEX + vco_ring4 PEX + top-level LO
wires (top_wires.json) + mixer_iq PEX in place of the 150 fF per-phase caps of tb_pll.
VCTRL and the loop-filter zero node start near the expected lock point (open-loop tuning curve)
so that 4 us is enough to see the settled VCTRL, fLO and the REF/FB phase error per corner.
usage: pex_pllmix.py [tt:0:0:2.22] [ss:3:1:2.3] ...   (corner:band:ICP2:VCTRL start)"""
import os, sys, re, collections
from concurrent.futures import ThreadPoolExecutor
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
os.environ.setdefault("PDK", "gf180mcuD"); os.environ.setdefault("PDK_ROOT", os.path.expanduser("~/pdk"))
import pexsim, pex_vco, pex_vcomix
from pexsim import run
PH = pex_vco.PH


def lf_nodes():
    """extracted names of the loop-filter C1 (zero) and C2 (CP output) plates: the two MIM arrays"""
    cnt = collections.Counter()
    for l in open(os.path.join(pexsim.MAG, "pll_core.pex.spice")):
        if "cap_mim" in l:
            cnt[l.split()[1]] += 1
    (z, _), (c2, _) = cnt.most_common(2)
    return "xpll.xpex." + z, "xpll.xpex." + c2


TSTOP = float(os.environ.get("TSTOP", "4e-6"))     # shorter runs: start at the lock point, waveform only


def deck(corner, b, icp2, vc0):
    mo, r, c, temp, vdd = pex_vco.CORNER[corner]
    t = pex_vcomix.netlist("tb_pll")
    t = re.sub(r"^CLl\d[pn] .*\n", "", t, flags=re.M)
    t = t.replace("XVCO vctrl b0 b1 %s " % " ".join(PH), "XVCO vctrl b0 b1 %s " % " ".join(n + "v" for n in PH))
    mix = ("RSP rfp 0 50\nRSN rfn 0 50\n"
           "XM rfp rfn %s nb ifip ifin ifqp ifqn vdd 0 mixer_iq\n" % " ".join(PH))
    t = t.replace("VICP2 icp2 0 0\n", "VICP2 icp2 0 %g\n" % (vdd * icp2) + pex_vcomix.wires(True) + mix)
    t = t.replace("VB0 b0 0 0", "VB0 b0 0 %g" % (vdd * (b & 1))).replace("VB1 b1 0 0", "VB1 b1 0 %g" % (vdd * (b >> 1)))
    t = t.replace("VDD vdd 0 3.3", "VDD vdd 0 %g" % vdd)
    t = re.sub(r"(sm141064\.ngspice) typical\b", r"\1 " + mo, t)
    t = t.replace("ngspice res_typical", "ngspice " + r).replace("ngspice mimcap_typical", "ngspice " + c)
    t = t.replace(".option method=gear reltol=2e-4", ".option method=gear reltol=2e-4 temp=%g" % temp)
    mixsub = pex_vcomix.netlist("tb_mixer")
    t = pex_vcomix.dedupe(t.replace(".end\n", "") + mixsub[mixsub.index("**.ends") + 7:])
    for cell in ("pll_core", "vco_ring4", "mixer_iq"):
        t = pexsim.swap(t, cell)
    a, cc = pex_vco.ring_ic()
    z, c2 = lf_nodes()
    t = t.replace(".ic v(vctrl)=1.7 v(xpll.xlf.z)=1.7 v(xpll.vcp)=1.7 v(xvco.xcore.p4)=0 v(xvco.xcore.n4)=2",
                  ".ic v(vctrl)=%g v(%s)=%g v(%s)=%g v(xvco.xpex.%s)=0 v(xvco.xpex.%s)=2" % (vc0, z, vc0, c2, vc0, a, cc))
    tag = "%s_b%d_i%d" % (corner, b, icp2)
    t = t.replace("set num_threads=1", "set num_threads=2")
    t = t.replace("save v(vctrl) ", "save v(vctrl) v(%s) v(l1n) " % c2)
    t = t.replace("tran 5p 4u 0 5p uic", "tran 5p %g 0 5p uic" % TSTOP)
    t = t.replace("wrdata tb_pll_vctrl v(vctrl)", "wrdata %s v(vctrl) v(%s) v(l1p) v(l1n)" % (os.path.join(pexsim.PROJ, "sim", "pllmix_" + tag), c2))
    # late-window fLO and VCTRL statistics
    t = t.replace("meas tran t1 when v(fs)=1.65 rise=25", "meas tran t1 when v(fs)=1.65 rise=40")
    t = t.replace("meas tran t2 when v(fs)=1.65 rise=55", "meas tran t2 when v(fs)=1.65 rise=62")
    t = t.replace("let ffs = 30/(t2-t1)", "let ffs = 22/(t2-t1)")
    t = t.replace("rise=60", "rise=62")
    t = t.replace("meas tran vc_pp pp v(vctrl) from=3.5u to=4u",
                  "meas tran vc_pp pp v(vctrl) from=3.5u to=4u\nmeas tran vc_m avg v(vctrl) from=2.5u to=3u\n"
                  "meas tran vc_e avg v(vctrl) from=3u to=3.5u")
    t = t.replace("echo RES vc_end=$&vc_end", "echo RES vc_m=$&vc_m vc_e=$&vc_e vc_end=$&vc_end")
    return tag, t


def main():
    jobs = [a.split(":") for a in sys.argv[1:]] or [["tt", "0", "0", "2.22"], ["ss", "3", "1", "2.3"], ["ff", "0", "0", "1.48"]]
    decks = [deck(c, int(b), int(i), float(v)) for c, b, i, v in jobs]
    with ThreadPoolExecutor(len(decks)) as ex:
        outs = list(ex.map(lambda d: run.ngspice(d[1], "pllmix_" + d[0], timeout=200000), decks))
    for (tag, _), out in zip(decks, outs):
        print("== " + tag)
        print("\n".join(l for l in out.splitlines() if l.startswith("RES") or "rror" in l), flush=True)


if __name__ == "__main__":
    main()
