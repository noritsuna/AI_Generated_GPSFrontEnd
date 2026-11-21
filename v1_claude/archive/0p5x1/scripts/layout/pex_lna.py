"""LNA (+ mixer load) schematic vs PEX: S11, differential gain, NF at 1.4-1.8 GHz."""
import os, sys, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import pexsim, lvs
lvs.pex("lna_nc", pexsim.MAG)
from pexsim import run
t = open(os.path.join(pexsim.PROJ, "sim", "netlist", "tb_lna.spice")).read()
t = re.sub(r"^echo RES op .*$", "echo RES op vx=$&v(rfin) vop=$&v(rfp) idd=$&i(VDD)", t, flags=re.M)
for tag, txt in (("lna_sch", t), ("lna_pex", pexsim.swap(t, "lna_nc"))):
    out = run.ngspice(txt, tag)
    print("==", tag)
    print("\n".join(l for l in out.splitlines() if l.startswith("RES") or re.match(r"^\d+\s", l) or "rror" in l))
