"""Retune the mixer LO trims (gen_cells.LO_TRIM) to a new mixer_iq layout.
The trims (NMOS gate caps on the switch gate nodes behind the LO coupling caps) equalise the load the
VCO sees on each of the 8 LO pins. Load per pin from the mixer PEX: the tb_mixer operating point (LO
pins at their mid level), AC 1 V on one pin at a time at fLO/2 = 785.664 MHz, C = Im(I) / (2 pi f).
A second pass with 5 fF on every gate node gives the pin load per fF of gate load; the trim widths are
then set so that every pin carries the same load, the lightest trim at WMIN (~8 fF per um of trim W, L = 2 um).
usage: lo_trim.py [--nopex]    (prints the loads and the proposed LO_TRIM)"""
import os, sys, re
import numpy as np
from concurrent.futures import ThreadPoolExecutor
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))
os.environ.setdefault("PDK", "gf180mcuD"); os.environ.setdefault("PDK_ROOT", os.path.expanduser("~/pdk"))
import pexsim, lvs
from pexsim import run
import gen_cells

if "--nopex" not in sys.argv:
    lvs.pex("mixer_iq", pexsim.MAG)
PINS = ["L1P", "L1N", "L2P", "L2N", "L3P", "L3N", "L4P", "L4N"]
F = 785.664e6
CPU = 8.0e-15            # trim gate cap per um of W (L = 2 um, inversion)
DC = 5e-15
pex = open(os.path.join(pexsim.MAG, "mixer_iq.pex.spice")).read()
# gate node behind each coupling cap: the MIM bottom plate of the L<k><P|N> unit caps
gl = {}
for m in re.finditer(r"^X\S+ (L[1-4][PN])\S* (\S+) cap_mim\S* c_width=5u", pex, re.M):
    gl.setdefault(m.group(1), m.group(2))
assert len(gl) == 8, gl
t = pexsim.swap(open(run.netlist("tb_mixer")).read(), "mixer_iq")
# LO sources -> DC at the mid level (1.0 V) + AC on one pin
t = re.sub(r"^(VL[1-4][PN] \S+ 0) pulse\(.*$", r"\1 dc 1.0 ac 0", t, flags=re.M)
ctl = [".control", "set num_threads=4"]
for p in PINS:
    q = p[1:]
    ctl += ["alter @VL%s[acmag] = 1" % q, "ac lin 1 %g %g" % (F, F), "print imag(i(VL%s))" % q, "alter @VL%s[acmag] = 0" % q]
ctl.append(".endc")
t = re.sub(r"^\.control.*?^\.endc", "\n".join(ctl), t, flags=re.M | re.S)


def deck(extra):
    s = t
    if extra:
        i = s.index(".subckt mixer_iq_flat"); j = s.index(".ends", i)
        s = s[:j] + "".join("CTRIMX%s %s VSS %g\n" % (k, n, extra) for k, n in gl.items()) + s[j:]
    return s


def loads(out):
    v = [abs(float(x)) for x in re.findall(r"^imag\(i\(vl[1-4][pn]\)\) = (\S+)", out, re.M)]
    assert len(v) == 8, out[-2000:]
    return {p: x / (2 * np.pi * F) for p, x in zip(PINS, v)}


with ThreadPoolExecutor(2) as ex:
    o0, o1 = ex.map(lambda e: run.ngspice(deck(e), "lotrim_%d" % (e > 0), timeout=8000), (0, DC))
c0, c1 = loads(o0), loads(o1)
k = {p: (c1[p] - c0[p]) / DC for p in PINS}
cmax = max(c0.values())
WMIN = 0.8               # smallest trim (um): the target load is set so that the lightest trim ends there
print("LO pin load (fF):", " ".join("%s %.1f" % (p, c0[p] * 1e15) for p in PINS), " spread %.1f fF" % ((cmax - min(c0.values())) * 1e15))
print("pin load per fF of gate load:", " ".join("%.2f" % k[p] for p in PINS))
w = lambda tgt: {p: gen_cells.LO_TRIM[p] + (tgt - c0[p]) / k[p] / CPU for p in PINS}
off = min(w(cmax).values()) - WMIN
new = {p: round(x - off, 2) for p, x in w(cmax).items()}
print("LO_TRIM =", new)
