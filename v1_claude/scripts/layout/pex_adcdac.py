"""ADC (adc2b) and AFC DAC (afc_dac), schematic vs PEX: the quarter layout expands their gates into
transistors (auto.FLAT_PARENTS), so this re-checks them after extraction.
  tb_adc: SIGN / MAG thresholds on a slow ramp clocked at fs = 16.368 MHz, ladder taps, supply current
  tb_afc: 256-code transfer into 100 kohm -> gain, offset, INL / DNL (LSB), monotonicity
usage: pex_adcdac.py [--nopex]"""
import os, sys, re
import numpy as np
from concurrent.futures import ThreadPoolExecutor
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
os.environ.setdefault("PDK", "gf180mcuD"); os.environ.setdefault("PDK_ROOT", os.path.expanduser("~/pdk"))
import pexsim, lvs
from pexsim import run

if "--nopex" not in sys.argv:
    with ThreadPoolExecutor(2) as ex:
        list(ex.map(lambda c: lvs.pex(c, pexsim.MAG), ("adc2b", "afc_dac")))

adc = open(run.netlist("tb_adc")).read()
afc = open(run.netlist("tb_afc")).read()
# the ladder taps sit one level deeper behind the PEX wrapper
adc_pex = pexsim.swap(adc, "adc2b").replace("v(xa.th", "v(xa.xpex.th")
jobs = {"adc_sch": adc, "adc_pex": adc_pex, "afc_sch": afc, "afc_pex": pexsim.swap(afc, "afc_dac")}
with ThreadPoolExecutor(len(jobs)) as ex:
    outs = dict(zip(jobs, ex.map(lambda k: run.ngspice(jobs[k], "q_" + k, timeout=20000), jobs)))

for k in ("adc_sch", "adc_pex"):
    print("==", k)
    print("\n".join(l for l in outs[k].splitlines() if l.startswith("RES") or "rror" in l))
for k in ("afc_sch", "afc_pex"):
    v = np.array([float(x) for x in re.findall(r"^DAC \d+ (\S+)", outs[k], re.M)])
    if len(v) != 256:
        print("==", k, "FAILED", len(v)); print(outs[k][-800:]); continue
    c = np.arange(256)
    g, o = np.polyfit(c, v, 1)
    lsb = (v[-1] - v[0]) / 255
    inl = (v - (v[0] + c * lsb)) / lsb
    dnl = np.diff(v) / lsb - 1
    print("== %s  out %.4f .. %.4f V  LSB %.3f mV  fit %.3f mV/code + %.4f V  INL %+.2f/%+.2f  DNL %+.2f/%+.2f LSB  monotonic %s" % (
        k, v[0], v[-1], lsb * 1e3, g * 1e3, o, inl.min(), inl.max(), dnl.min(), dnl.max(), bool(np.all(np.diff(v) > 0))))
