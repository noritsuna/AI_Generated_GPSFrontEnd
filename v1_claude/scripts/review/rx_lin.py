"""Review A-1: linearity and blocker tests of the RF front end (LNA + sub-harmonic mixer, schematic,
ideal 8-phase LO at fLO/2, 50 ohm source through 10 pF).  Tones are placed relative to the LO of
the testbench (fLO = 2 / 1272.809 ps) so that every product falls on a 0.5 MHz grid; 2.4 us are
simulated and the last 2 us analysed (rectangular window, exact bins).
  * in-band two-tone (IF 4 + 5 MHz): IM3 at 3 / 6 MHz -> IIP3
  * out-of-band two-tone (LO + 100 MHz, LO + 196 MHz): IM3 at IF 4 MHz
  * single tone compression, desensitisation of a -60 dBm tone by a 1710 MHz blocker
  * spurious responses of the sub-harmonic mixer: RF at fLO/2 + 4 MHz and at 3 fLO/2 + 4 MHz
usage: rx_lin.py [jobs=14]"""
import os, sys, re, math
from concurrent.futures import ThreadPoolExecutor
import numpy as np
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))
os.environ.setdefault("PDK", "gf180mcuD"); os.environ.setdefault("PDK_ROOT", os.path.expanduser("~/pdk"))
import run
NG = (lambda *a, **k: "") if os.environ.get("ANA") else run.ngspice   # ANA=1: analyse the saved waveforms only

FLO = 2 / 1272.809e-12
TS, T0, T1 = 5e-12, 0.4e-6, 2.4e-6


def emf(dbm):
    """peak EMF of a 50 ohm source with the available power dbm"""
    return 2 * math.sqrt(2 * 50 * 1e-3 * 10 ** (dbm / 10))


def deck(base, tag, tones):
    src = "".join("VRF%d s0%d %s 0 sin(0 %g %.9g)\n" % (i, i, "s0%d" % (i + 1) if i + 1 < len(tones) else "0", emf(p), f)
                  for i, (f, p) in enumerate(tones))
    t, k = re.subn(r"^VRF s0 0 .*\n", lambda m: src.replace("s00 ", "s0 ", 1), base, flags=re.M)
    assert k == 1
    t, k = re.subn(r"^\.control.*?^\.endc", lambda m: ".control\nset num_threads=1\ntran 5p %g 0 5p\n"
                   "linearize v(ifip) v(ifin) v(ifqp) v(ifqn) v(rfin) v(rfp) v(rfn)\nlet vi = v(ifip)-v(ifin)\nlet vq = v(ifqp)-v(ifqn)\n"
                   "let vr = v(rfp)-v(rfn)\nwrdata review/rx_%s vi vq v(rfin) vr\n.endc" % (T1, tag), t, flags=re.M | re.S)
    assert k == 1
    return t


def amp(tt, x, f):
    return 2 * abs(np.mean(x * np.exp(-2j * np.pi * f * tt)))


def one(a):
    base, tag, tones = a
    out = NG(deck(base, tag, tones), "rev_rx_" + tag, timeout=6000)
    d = np.loadtxt(os.path.join(run.SIM, "review", "rx_%s" % tag))
    m = (d[:, 0] >= T0 - TS / 2) & (d[:, 0] < T1 - TS / 2)
    return tag, d[m, 0], d[m, 1], d[m, 3], d[m, 5], d[m, 7], [l for l in out.splitlines() if "rror" in l]


def db(x):
    return 20 * math.log10(max(x, 1e-12))


def main():
    jobs = int(sys.argv[1]) if len(sys.argv) > 1 else 14
    os.makedirs(os.path.join(run.SIM, "review"), exist_ok=True)
    base = open(run.netlist("tb_rx")).read()
    M = 1e6
    cases = []
    for p in (-50, -40, -30, -25):
        cases.append(("tt_%d" % -p, [(FLO + 4 * M, p), (FLO + 5 * M, p)]))
    for p in (-30, -20):
        cases.append(("oob_%d" % -p, [(FLO + 100 * M, p), (FLO + 196 * M, p)]))
    for p in (-50, -30, -25, -20, -15, -10):
        cases.append(("cp_%d" % -p, [(FLO + 4 * M, p)]))
    for p in (-30, -20, -10, 0):
        cases.append(("blk_%d" % -p, [(FLO + 4 * M, -60), (FLO + 138.5 * M, p)]))
    cases.append(("blk_none", [(FLO + 4 * M, -60)]))
    for p in (-30, -10):
        cases.append(("half_%d" % -p, [(FLO / 2 + 4 * M, p)]))
        cases.append(("x15_%d" % -p, [(1.5 * FLO + 4 * M, p)]))
    with ThreadPoolExecutor(jobs) as ex:
        res = {r[0]: r for r in ex.map(one, [(base, c[0], c[1]) for c in cases])}
    for tag, tones in cases:
        _, tt, vi, vq, vin, vr, err = res[tag]
        a = lambda f, x=vi: amp(tt, x, f)
        vm = lambda p: emf(p) / 2            # peak voltage at a matched input
        print("== %s  %s %s" % (tag, ", ".join("%.3f MHz %g dBm" % (f / M, p) for f, p in tones), " ".join(err)))
        if tag.startswith("tt_"):
            p = tones[0][1]
            f1, f2, l, h = a(4 * M), a(5 * M), a(3 * M), a(6 * M)
            dbc = db(math.sqrt((f1 * f1 + f2 * f2) / 2)) - db(math.sqrt((l * l + h * h) / 2))
            print("   IF 4/5 MHz %.3f / %.3f mV, IM3 3/6 MHz %.4f / %.4f mV: %.1f dBc -> IIP3 %.1f dBm; conv gain %.2f dB"
                  % (f1 * 1e3, f2 * 1e3, l * 1e3, h * 1e3, dbc, p + dbc / 2, db(f1 / vm(p))))
        elif tag.startswith("oob_"):
            p = tones[0][1]
            im = a(4 * M)
            g = 10 ** (28.6 / 20)             # in-band conversion gain (matched input voltage -> IF)
            pim = 10 * math.log10((im / g) ** 2 / (2 * 50) / 1e-3)      # input-referred IM3 power
            print("   IM3 at IF 4 MHz %.4f mV = %.1f dBm input-referred -> out-of-band IIP3 %.1f dBm" % (im * 1e3, pim, (3 * p - pim) / 2))
        elif tag.startswith("cp_"):
            p = tones[0][1]
            print("   IF %.3f mV (Q %.3f mV)  conv gain %.2f dB  LNA out diff %.2f mV" % (a(4 * M) * 1e3, amp(tt, vq, 4 * M) * 1e3,
                  db(a(4 * M) / vm(p)), amp(tt, vr, tones[0][0]) * 1e3))
        elif tag.startswith("blk_"):
            fb = tones[1][0] if len(tones) > 1 else 0
            print("   wanted: conv gain %.2f dB; blocker at the mixer output (IF %.1f MHz) %.2f mV, at the LNA output %.1f mV diff"
                  % (db(a(4 * M) / vm(-60)), (fb - FLO) / M, a(fb - FLO) * 1e3 if fb else 0, amp(tt, vr, fb) * 1e3 if fb else 0))
        else:
            p = tones[0][1]
            print("   IF 4 MHz %.4f mV (gain %.1f dB), IF 8 MHz %.4f mV (gain %.1f dB), IF 12 MHz %.4f mV" % (
                a(4 * M) * 1e3, db(a(4 * M) / vm(p)), a(8 * M) * 1e3, db(a(8 * M) / vm(p)), a(12 * M) * 1e3))
        sys.stdout.flush()


if __name__ == "__main__":
    main()
