"""IF chain stability through the shared supply (final layout, PEX): the I and Q chains (if_chain
PEX x2) and the bias generator sit on one VDD / VSS pair that reaches the board through bond wires
(L, R per rail) and RG ohm of on-chip grid per chain and rail. All VGAs at maximum gain, a
1 mV x 5 ns kick on the I input at 2 us; the outputs must ring down (no sustained oscillation).
  cases: tt ideal / tt 2 nH 0.3 ohm / tt 5 nH 0.5 ohm / ss 5 nH / ff 5 nH
usage: if_stab.py [--nopex] [--keep=tag,tag]"""
import os, sys, re
from concurrent.futures import ThreadPoolExecutor
import numpy as np
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
os.environ.setdefault("PDK", "gf180mcuD"); os.environ.setdefault("PDK_ROOT", os.path.expanduser("~/pdk"))
import pexsim, lvs, pex_blocks
from pexsim import run

RG = 3.0
CORN = {"tt": ("typical", 27, 3.3), "ss": ("ss", 85, 3.135), "ff": ("ff", -20, 3.465)}
CASES = [("tt_ideal", "tt", None, 0), ("tt_2n", "tt", "2n", 0.3), ("tt_5n", "tt", "5n", 0.5),
         ("ss_5n", "ss", "5n", 0.5), ("ff_5n", "ff", "5n", 0.5)]
SIM = os.path.join(lvs.PROJ, "sim")


def deck(tag, corner, L, R):
    lib, temp, v = CORN[corner]
    t = pex_blocks.deck("if", True)
    t = t.replace("XB nb pb vdd 0 bias_gen", "XB nb pb vddc vssc bias_gen")
    xif = "XIF inp inn g1a g1b g2a g2b g3a g3b pb bwk bwn outp outn vdd 0 if_chain"
    assert xif in t
    t = t.replace(xif, "XIF inp inn g1a g1b g2a g2b g3a g3b pb bwk bwn outp outn vddi vssi if_chain\n"
                  "XIFQ inq inq2 g1a g1b g2a g2b g3a g3b pb bwk bwn outqp outqn vddq vssq if_chain\n"
                  "RGVI vddc vddi %g\nRGSI vssc vssi %g\nRGVQ vddc vddq %g\nRGSQ vssc vssq %g\n"
                  "VIQP inq vssc dc 2.1\nVIQN inq2 vssc dc 2.1\nCLQP outqp vssc 100f\nCLQN outqn vssc 100f" % ((RG,) * 4))
    sup = ("LBV vdd lv %s\nRBV lv vddc %g\nLBS 0 ls %s\nRBS ls vssc %g\n" % (L, R, L, R)) if L else "RBV vdd vddc 1m\nRBS 0 vssc 1m\n"
    t = t.replace("VDD vdd 0 3.3", "VDD vdd 0 %g\n" % v + sup)
    t = t.replace("VIP inp 0 dc 2.1 ac 0.5", "VIP inp vssc pulse(2.1 2.101 2u 1n 1n 5n 1)")
    t = t.replace("VIN inn 0 dc 2.1 ac 0.5 180", "VIN inn vssc dc 2.1")
    for b in ("G1A", "G1B", "G2A", "G2B", "G3A", "G3B"):
        t, k = re.subn(r"^V%s (\S+) 0 0$" % b, r"V%s \1 vssc %g" % (b, v), t, flags=re.M)
        assert k == 1
    t = t.replace("CLP outp 0", "CLP outp vssc").replace("CLN outn 0", "CLN outn vssc")
    if lib != "typical":
        t, k = re.subn(r"(sm141064\.ngspice) (res_|mimcap_)?typical", lambda m: "%s %s%s" % (m.group(1), m.group(2) or "", lib), t)
        assert k == 3
    fn = os.path.join(SIM, "ifstab_" + tag)
    ctl = ".temp %g\n.control\nset num_threads=2\ntran 0.2n 7u\nwrdata %s v(outp)-v(outn) v(outqp)-v(outqn) v(vddc)-v(vssc) i(VDD)\n.endc" % (temp, fn)
    t, k = re.subn(r"^\.control.*?^\.endc", lambda m: ctl, t, flags=re.M | re.S)
    assert k == 1
    return t, fn


def go(job):
    tag, t, fn = job
    o = run.ngspice(t, "ifstab_" + tag, timeout=80000) if t else ""
    try:
        d = np.loadtxt(fn)
    except Exception:
        return tag, "no data: " + o[-400:]
    tt, yi, yq, s, i = d[:, 0], d[:, 1], d[:, 3], d[:, 5], d[:, 7]
    res = ["IDD %.2f mA" % (-i[(tt > 1.5e-6) & (tt < 2e-6)].mean() * 1e3)]
    for a, b in ((1.5e-6, 2e-6), (2.0e-6, 2.5e-6), (2.5e-6, 3e-6), (3e-6, 4e-6), (4e-6, 5e-6), (5e-6, 6e-6), (6e-6, 7e-6)):
        m = (tt >= a) & (tt < b)
        res.append("%.1f-%.1f us  I out pp %8.3f mV  Q out pp %8.3f mV  supply pp %7.3f mV" %
                   (a * 1e6, b * 1e6, np.ptp(yi[m]) * 1e3, np.ptp(yq[m]) * 1e3, np.ptp(s[m]) * 1e3))
    return tag, res


def main():
    if "--nopex" not in sys.argv:
        lvs.pex("if_chain", pexsim.MAG)
    # decks are built one after another (run.netlist rewrites the netlist file); "--keep a,b" only
    # re-reads the waveforms of those cases
    keep = [a.split("=")[1].split(",") for a in sys.argv if a.startswith("--keep=")]
    keep = keep[0] if keep else []
    jobs = []
    for tag, corner, L, R in CASES:
        t, fn = deck(tag, corner, L, R)
        jobs.append((tag, None if tag in keep else t, fn))
    with ThreadPoolExecutor(len(CASES)) as ex:
        for tag, r in ex.map(go, jobs):
            print("==", tag); print("\n".join(r) if isinstance(r, list) else r, flush=True)


if __name__ == "__main__":
    main()
