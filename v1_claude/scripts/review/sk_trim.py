"""Review C (from A-6): bandwidth trim of the Sallen-Key filters by switching part of C2 (y -> VSS).
Schematic if_chain, C2 of both biquads scaled by k (area), corners as in if_corner.py.
usage: sk_trim.py [k ...]   (default 0.64 1.0 1.6)"""
import os, sys, re
from concurrent.futures import ThreadPoolExecutor
import numpy as np
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, "..")); sys.path.insert(0, HERE)
os.environ.setdefault("PDK", "gf180mcuD"); os.environ.setdefault("PDK_ROOT", os.path.expanduser("~/pdk"))
import run, gnss_sysim, if_corner


def scale(t, k):
    def sub(m):
        blk = m.group(0)
        return re.sub(r"^(XC2[PN] .*?c_width=)([0-9.e-]+)( c_length=)([0-9.e-]+)",
                      lambda q: "%s%g%s%g" % (q.group(1), float(q.group(2)) * k ** 0.5, q.group(3), float(q.group(4)) * k ** 0.5),
                      blk, flags=re.M)
    t, n = re.subn(r"^\.subckt sk_lpf\d.*?^\.ends", sub, t, flags=re.M | re.S)
    assert n == 2
    return t


def main():
    ks = [float(a) for a in sys.argv[1:]] or [0.64, 1.0, 1.6]
    base = open(run.netlist("tb_if")).read()
    jobs = [(c, k, if_corner.deck(scale(base, k), c).replace("review/ifc_%s_" % c, "review/skt_%s_%g_" % (c, k)))
            for c in ("tt", "ss85", "ssm20", "ff85", "ffm20") for k in ks]
    with ThreadPoolExecutor(4) as ex:
        list(ex.map(lambda j: if_corner.NG(j[2], "rev_skt_%s_%g" % (j[0], j[1]), timeout=20000), jobs))
    for c, k, _ in jobs:
        d = np.loadtxt(os.path.join(run.SIM, "review", "skt_%s_%g_3" % (c, k)))
        fr, g = d[:, 0], d[:, 1]
        gi = lambda f: float(np.interp(np.log10(f), np.log10(fr), g))
        m = (fr > 1e5) & (fr < 3e7); gm = g[m].max(); i = np.where(m & (g >= gm - 3))[0]
        rip = lambda a, b: max(gi(f) for f in np.linspace(a, b, 60)) - min(gi(f) for f in np.linspace(a, b, 60))
        print("%-6s C2 x%.2f: G(4.092) %.1f dB, -3 dB %.2f-%.2f MHz, ripple GPS %.1f / Galileo %.1f dB, aliasing loss GPS %.2f / Galileo %.2f dB" % (
            c, k, gi(4.092e6), fr[i[0]] / 1e6, fr[i[-1]] / 1e6, rip(3.07e6, 5.12e6), rip(1.55e6, 6.64e6),
            gnss_sysim.aliasing_loss(fr, g, (3.07e6, 5.12e6)), gnss_sysim.aliasing_loss(fr, g, (1.55e6, 6.64e6))), flush=True)


if __name__ == "__main__":
    main()
