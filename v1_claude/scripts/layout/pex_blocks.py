"""Re-PEX of the final block layouts: schematic vs PEX for the IF chain (tb_if: gain / band
edges per gain code), the LNA (+ mixer load, tb_lna), the mixer (tb_mixer) and the PLL
(tb_pll, pll_core + vco_ring4 both extracted).
usage: pex_blocks.py [if] [lna] [mixer] [pll] [--nopex]"""
import os, sys, re
from concurrent.futures import ThreadPoolExecutor
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
os.environ.setdefault("PDK", "gf180mcuD"); os.environ.setdefault("PDK_ROOT", os.path.expanduser("~/pdk"))
import pexsim, lvs, pex_vco
from pexsim import run

JOBS = {"if": ("tb_if", ["if_chain"]), "lna": ("tb_lna", ["lna_nc"]),
        "mixer": ("tb_mixer", ["mixer_iq"]), "pll": ("tb_pll", ["pll_core", "vco_ring4"])}


NET = {}


def deck(key, pex):
    tb, cells = JOBS[key]
    # separate waveform files for the schematic / PEX runs
    t = re.sub(r"^(wrdata\s+)(\S+)", lambda m: m.group(1) + m.group(2) + ("_pex" if pex else "_sch"),
               NET[tb], flags=re.M)
    if not pex:
        return t
    for c in cells:
        t = pexsim.swap(t, c)
    if key == "pll":
        a, c = pex_vco.ring_ic()
        t = t.replace("v(xvco.xcore.p4)=0 v(xvco.xcore.n4)=2", "v(xvco.xpex.%s)=0 v(xvco.xpex.%s)=2" % (a, c))
        t = t.replace(" v(xpll.xlf.z)=1.7", "")       # loop-filter node is anonymous after extraction
    return t


def main():
    keys = [k for k in JOBS if k in sys.argv[1:]] or list(JOBS)
    if "--nopex" not in sys.argv:
        cells = sorted(set(c for k in keys for c in JOBS[k][1]))
        with ThreadPoolExecutor(len(cells)) as ex:
            list(ex.map(lambda c: lvs.pex(c, pexsim.MAG), cells))
    # netlist each testbench once, before the threads: the schematic and PEX jobs of a block would
    # otherwise write and read the same netlist file at the same time
    for k in keys:
        NET[JOBS[k][0]] = open(run.netlist(JOBS[k][0])).read()
    jobs = [(k, p) for k in keys for p in (False, True)]
    with ThreadPoolExecutor(len(jobs)) as ex:
        outs = list(ex.map(lambda j: run.ngspice(deck(*j), "rp_%s_%s" % (j[0], "pex" if j[1] else "sch"), timeout=40000), jobs))
    for (k, p), out in zip(jobs, outs):
        print("== %s %s" % (k, "PEX" if p else "schematic"))
        print("\n".join(l for l in out.splitlines() if l.startswith("RES") or re.match(r"^\d+\s", l) or "rror" in l))


if __name__ == "__main__":
    main()
