"""Review A-2 (linear part): PLL open-loop gain with a load on the VCTRL monitor pin.
Loop filter: CP -> C2 || (RZ + C1) -> RVT -> VCTRL (C3) -> RMON 10k -> pin (pad 1.24 pF + external R || C).
Prints the crossover frequency, the phase margin and the reference spur expected from a DC load
(the charge pump has to replace I_load * Tref every cycle: ripple on C2 + C3)."""
import numpy as np
FREF, N = 16.368e6, 96
RZ, C1, C2, RVT, C3, RMON, CPAD = 10.4e3, 59.3e-12, 4.9e-12, 2.0e3, 1.5e-12, 10e3, 1.24e-12
f = np.logspace(3, 8, 6000); s = 2j * np.pi * f
par = lambda a, b: a * b / (a + b)


def loop(icp, kvco, rl=None, cl=0.0):
    yl = s * (CPAD + cl) + (1 / rl if rl else 0)          # pin admittance
    zmon = RMON + 1 / yl
    zv = 1 / (s * C3 + 1 / zmon)                          # VCTRL node to ground
    zin = 1 / (s * C2 + 1 / (RZ + 1 / (s * C1)) + 1 / (RVT + zv))
    h = zin * zv / (RVT + zv)                             # V(VCTRL) / Icp
    g = icp / (2 * np.pi) * h * 2 * np.pi * kvco / s / N
    i = np.argmin(np.abs(np.abs(g) - 1))
    return f[i], 180 + np.degrees(np.angle(g[i]))


for name, icp, kv in (("TT ICP2=0", 100e-6, 526e6), ("SS ICP2=1", 200e-6, 300e6), ("FF ICP2=0", 100e-6, 961e6)):
    print("== " + name)
    for lab, rl, cl in (("pin open (pad only)", None, 0), ("10 Mohm || 15 pF (10x probe)", 10e6, 15e-12), ("1 Mohm || 20 pF", 1e6, 20e-12),
                        ("100 pF", None, 100e-12), ("1 nF", None, 1e-9), ("10 nF", None, 10e-9), ("100 nF", None, 100e-9),
                        ("100 kohm", 100e3, 0), ("10 kohm", 10e3, 0)):
        fc, pm = loop(icp, kv, rl, cl)
        print("   %-30s fc %.2f MHz  PM %.1f deg" % (lab, fc / 1e6, pm))
print("== reference spur from a DC load on the pin (VCTRL 2.2 V, TT Kvco 526 MHz/V): sawtooth on C2+C3+C1 path")
for lab, il in (("pad leakage 1 nA", 1e-9), ("100 nA", 100e-9), ("10 Mohm probe", 2.2 / 10e6), ("1 Mohm", 2.2 / 1e6)):
    dv = il / FREF / (C2 + C3)                 # pp ripple, charge replaced once per reference period
    a1 = dv / np.pi                            # fundamental of a sawtooth
    print("   %-18s I %.3g uA  ripple %.3f mV pp  spur %.1f dBc  static phase offset %.2f deg" % (
        lab, il * 1e6, dv * 1e3, 20 * np.log10(526e6 * a1 / FREF / 2), 360 * il / 100e-6))
