"""Review round 2: systematic INL / DNL of the AFC DAC (tb_afc, DC) against the ladder resistor geometry.
usage: afc_geom.py W:L2R:LR [...]   (um)"""
import os, sys, re
from concurrent.futures import ThreadPoolExecutor
import numpy as np
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))
os.environ.setdefault("PDK", "gf180mcuD"); os.environ.setdefault("PDK_ROOT", os.path.expanduser("~/pdk"))
import run, r_mismatch

base = open(os.path.join(run.SIM, "netlist", "tb_afc.spice")).read()


def one(a):
    w, l2, l1 = a.split(":")
    t = re.sub(r"^(XR(?:T|2_\d) .* r_width=)\S+ r_length=\S+", r"\g<1>%su r_length=%su" % (w, l2), base, flags=re.M)
    t = re.sub(r"^(XR1_\d .* r_width=)\S+ r_length=\S+", r"\g<1>%su r_length=%su" % (w, l1), t, flags=re.M)
    out = run.ngspice(t, "rev_afcg_" + a.replace(":", "_").replace(".", "p"), timeout=3000)
    v = np.array([float(l.split()[2]) for l in out.splitlines() if l.startswith("DAC ")])
    lsb, inl, dnl = r_mismatch.lin(v)
    return "W %s 2R L %s R L %s: %.4f..%.4f V LSB %.3f mV INL %+.2f/%+.2f DNL %+.2f/%+.2f (127->128 %+.2f, 63->64 %+.2f)" % (
        w, l2, l1, v[0], v[-1], lsb * 1e3, inl.min(), inl.max(), dnl.min(), dnl.max(), dnl[127], dnl[63])


with ThreadPoolExecutor(6) as ex:
    for l in ex.map(one, sys.argv[1:]):
        print(l, flush=True)
