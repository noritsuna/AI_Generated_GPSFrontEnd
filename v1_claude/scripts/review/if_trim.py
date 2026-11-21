"""Review round 2: IF chain (PEX) with the bandwidth trim codes over corners (as if_corner.py).
trim: nom = BWW 0 BWN 0, W = BWW 1 (C2 x 0.64), N = BWN 1 (C2 x 1.6), WN = both (C2 x 1.24)"""
import os, sys, re
from concurrent.futures import ThreadPoolExecutor
import numpy as np
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE); sys.path.insert(0, os.path.join(HERE, "..")); sys.path.insert(0, os.path.join(HERE, "..", "layout"))
os.environ.setdefault("PDK", "gf180mcuD"); os.environ.setdefault("PDK_ROOT", os.path.expanduser("~/pdk"))
import pexsim, gnss_sysim, lvs, if_corner
from pexsim import run
NG = (lambda *a, **k: "") if os.environ.get("ANA") else run.ngspice
TRIM = {"nom": (1, 0), "W": (0, 0), "N": (1, 1), "WN": (0, 1)}      # (BWK, BWN)
CASES = [("tt", "nom"), ("tt", "W"), ("tt", "N"), ("tt", "WN"), ("ss85", "nom"), ("ss85", "W"), ("ssm20", "nom"), ("ssm20", "W"),
         ("ff85", "nom"), ("ff85", "N"), ("ff85", "WN"), ("ffm20", "nom"), ("ffm20", "N"), ("tt85", "nom"), ("ttm20", "nom")]


def main():
    if not os.environ.get("ANA"):
        lvs.pex("if_chain", pexsim.MAG)
    base = pexsim.swap(open(run.netlist("tb_if")).read(), "if_chain")
    decks = []
    for c, tr in CASES:
        v = if_corner.CORN[c][2]; k, n = TRIM[tr]
        t = if_corner.deck(base, c).replace("review/ifc_%s_" % c, "review/ift_%s_%s_" % (c, tr))
        a = t
        t = re.sub(r"^VBWK bwk 0 .*$", "VBWK bwk 0 %g" % (v * k), t, flags=re.M)
        t = re.sub(r"^VBWN bwn 0 .*$", "VBWN bwn 0 %g" % (v * n), t, flags=re.M)
        assert "VBWK bwk 0 %g" % (v * k) in t
        decks.append(("%s_%s" % (c, tr), t))
    with ThreadPoolExecutor(5) as ex:
        outs = list(ex.map(lambda d: NG(d[1], "rev_ift_" + d[0], timeout=20000), decks))
    for (c, _), out in zip(decks, outs):
        e = " ".join(l for l in out.splitlines() if "rror" in l)
        for k in (0, 3):
            d = np.loadtxt(os.path.join(run.SIM, "review", "ift_%s_%d" % (c, k)))
            fr, g = d[:, 0], d[:, 1]
            gi = lambda f: float(np.interp(np.log10(f), np.log10(fr), g))
            m = (fr > 1e5) & (fr < 3e7); gm = g[m].max(); i = np.where(m & (g >= gm - 3))[0]
            rip = lambda a, b: max(gi(f) for f in np.linspace(a, b, 60)) - min(gi(f) for f in np.linspace(a, b, 60))
            print("%-10s code %d: G %.1f dB, -3 dB %.2f-%.2f MHz, ripple GPS %.1f Gal %.1f dB, G(11.25) %+.1f G(16.37) %+.1f dB, alias GPS %.2f Gal %.2f dB %s"
                  % (c, k, gi(4.092e6), fr[i[0]] / 1e6, fr[i[-1]] / 1e6, rip(3.07e6, 5.12e6), rip(1.55e6, 6.64e6),
                     gi(11.25e6) - gi(4.092e6), gi(16.368e6) - gi(4.092e6),
                     gnss_sysim.aliasing_loss(fr, g, (3.07e6, 5.12e6)), gnss_sysim.aliasing_loss(fr, g, (1.55e6, 6.64e6)), e[:80]))
        sys.stdout.flush()


if __name__ == "__main__":
    main()
