"""Review round 2: the same external loads as vctrl_load.py, but on the buffered monitor pin
(vctrl -> vmon_buf (PEX) -> 10 kohm -> pad).  The PLL must not see any of them.
usage: vmon_load.py [TSTOP=5e-6]"""
import os, sys, re
from concurrent.futures import ThreadPoolExecutor
import numpy as np
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE); sys.path.insert(0, os.path.join(HERE, "..")); sys.path.insert(0, os.path.join(HERE, "..", "layout"))
os.environ.setdefault("PDK", "gf180mcuD"); os.environ.setdefault("PDK_ROOT", os.path.expanduser("~/pdk"))
import pexsim, lvs, vctrl_load
from pexsim import run
BUF = "XMON vctrl nb vbo vdd 0 vmon_buf\nRMON vbo vmon 10k\n"


def main():
    tstop = float(sys.argv[1]) if len(sys.argv) > 1 else 5e-6
    full = open(run.netlist("tb_full")).read()
    sub = re.search(r"^\.subckt\s+vmon_buf\s.*?^\.ends.*?$", full, flags=re.M | re.S | re.I).group(0)
    if not os.environ.get("ANA"):
        lvs.pex("vmon_buf", pexsim.MAG)
    base = open(run.netlist("tb_pll")).read()
    base = pexsim.swap(base.replace(".end\n", "") .rstrip() + "\n" + sub + "\n.end\n", "vmon_buf")
    decks = []
    for tag, load in vctrl_load.CASES:
        if tag == "open":
            continue
        load = BUF + load.replace("RMON vctrl vmon 10k\n", "")
        t = vctrl_load.deck(base, "buf_" + tag, load, tstop).replace("v(l1n) v(vmon) ", "v(l1n) v(vmon) v(vbo) ")
        t = t.replace("wrdata review/vcl_buf_%s v(vctrl) v(l1p) v(l1n)" % tag, "wrdata review/vcl_buf_%s v(vctrl) v(l1p) v(l1n) v(vmon)" % tag)
        decks.append((tag, t))
    with ThreadPoolExecutor(len(decks)) as ex:
        outs = list(ex.map(lambda d: vctrl_load.NG(d[1], "rev_vcl_buf_" + d[0], timeout=200000), decks))
    for (tag, _), out in zip(decks, outs):
        print("== buf_" + tag, " ".join(l for l in out.splitlines() if "rror" in l))
        for l in vctrl_load.ana("buf_" + tag):
            print("   " + l)
        d = np.loadtxt(os.path.join(run.SIM, "review", "vcl_buf_%s" % tag))
        m = d[:, 0] > d[-1, 0] - 1e-6
        print("   pin VCTRL (monitor) mean %.4f V, loop vctrl mean %.4f V, monitor pp %.2f mV" % (d[m, 7].mean(), d[m, 1].mean(), 1e3 * np.ptp(d[m, 7])))
        sys.stdout.flush()


if __name__ == "__main__":
    main()
