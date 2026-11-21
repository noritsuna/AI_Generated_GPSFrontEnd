"""Review A-6: IF chain (PEX) over corners: gain, band edges and the C/N0 loss from noise aliasing
at fs = 16.368 MHz (gnss_sysim.aliasing_loss) for the GPS and Galileo bands, all gain codes."""
import os, sys, re
from concurrent.futures import ThreadPoolExecutor
import numpy as np
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, "..")); sys.path.insert(0, os.path.join(HERE, "..", "layout"))
os.environ.setdefault("PDK", "gf180mcuD"); os.environ.setdefault("PDK_ROOT", os.path.expanduser("~/pdk"))
import pexsim, gnss_sysim
from pexsim import run
NG = (lambda *a, **k: "") if os.environ.get("ANA") else run.ngspice   # ANA=1: analyse the saved waveforms only

CORN = {"tt": ("typical", 27, 3.3), "ss85": ("ss", 85, 3.135), "ssm20": ("ss", -20, 3.135), "ff85": ("ff", 85, 3.465),
        "ffm20": ("ff", -20, 3.465), "tt85": ("typical", 85, 3.3), "ttm20": ("typical", -20, 3.3)}


def deck(base, c):
    lib, temp, v = CORN[c]
    t = base
    for k in ("typical", "res_typical", "mimcap_typical"):
        t = t.replace("sm141064.ngspice %s\n" % k, "sm141064.ngspice %s\n" % k.replace("typical", lib))
    t = t.replace("VDD vdd 0 3.3", "VDD vdd 0 %g" % v)
    t = re.sub(r"dc = 3\.3\b", "dc = %g" % v, t)
    t = re.sub(r"^wrdata if_ac_code(\d) g", r"wrdata review/ifc_%s_\1 g" % c, t, flags=re.M)
    t = re.sub(r"^(noise|setplot noise|wrdata if_noise).*\n", "", t, flags=re.M)
    return t.replace(".control", ".temp %g\n.control" % temp, 1)


def main():
    os.makedirs(os.path.join(run.SIM, "review"), exist_ok=True)
    base = pexsim.swap(open(run.netlist("tb_if")).read(), "if_chain")
    decks = [(c, deck(base, c)) for c in CORN]
    with ThreadPoolExecutor(4) as ex:
        outs = list(ex.map(lambda d: NG(d[1], "rev_ifc_" + d[0], timeout=20000), decks))
    for (c, _), out in zip(decks, outs):
        print("== %s  %s" % (c, " ".join(l for l in out.splitlines() if "rror" in l)))
        for k in range(4):
            d = np.loadtxt(os.path.join(run.SIM, "review", "ifc_%s_%d" % (c, k)))
            fr, g = d[:, 0], d[:, 1]
            gi = lambda f: float(np.interp(np.log10(f), np.log10(fr), g))
            m = (fr > 1e5) & (fr < 3e7); gm = g[m].max(); i = np.where(m & (g >= gm - 3))[0]
            print("  code %d: G(4.092) %.1f dB, -3 dB %.2f-%.2f MHz, GPS band ripple %.1f dB, Galileo band ripple %.1f dB, G(11.25) %+.1f dB, G(16.37) %+.1f dB rel.; "
                  "aliasing loss GPS %.2f dB, Galileo %.2f dB" % (k, gi(4.092e6), fr[i[0]] / 1e6, fr[i[-1]] / 1e6,
                  max(gi(f) for f in np.linspace(3.07e6, 5.12e6, 30)) - min(gi(f) for f in np.linspace(3.07e6, 5.12e6, 30)),
                  max(gi(f) for f in np.linspace(1.55e6, 6.64e6, 60)) - min(gi(f) for f in np.linspace(1.55e6, 6.64e6, 60)),
                  gi(11.25e6) - gi(4.092e6), gi(16.368e6) - gi(4.092e6),
                  gnss_sysim.aliasing_loss(fr, g, (3.07e6, 5.12e6)), gnss_sysim.aliasing_loss(fr, g, (1.55e6, 6.64e6))))
        sys.stdout.flush()


if __name__ == "__main__":
    main()
