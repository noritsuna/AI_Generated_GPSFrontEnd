"""Make report figures from the ngspice result files in sim/."""
import glob, os, re
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
SIM, DOC = os.path.join(ROOT, "sim"), os.path.join(ROOT, "doc")
FLO = 96 * 16.368e6


def vco():
    plt.figure(figsize=(7, 4.5))
    for f in sorted(glob.glob(os.path.join(SIM, "vco_*_b*.log"))):
        rows = [(float(a), float(b) / 1e9) for a, b in re.findall(r"vc=([\d.]+) f=([\d.E+-]+)", open(f).read())]
        if not rows:
            continue
        n = os.path.basename(f)[4:-4]
        ls = "-" if n.startswith("tt") else ("--" if n.startswith("ss") else ":")
        x, y = zip(*rows)
        plt.plot(x, y, ls, marker="o", ms=3, label=n.replace("_", " "))
    plt.axhline(FLO / 1e9, color="k", lw=1)
    plt.text(0.8, FLO / 1e9 + 0.02, "LO = 1571.328 MHz", fontsize=8)
    plt.axvspan(0.5, 2.5, color="g", alpha=0.06)
    plt.xlabel("VCTRL [V]  (green: charge-pump compliance)"); plt.ylabel("f_VCO [GHz]")
    plt.title("Ring VCO tuning curves vs corner / band (B1B0)")
    plt.legend(fontsize=7, ncol=2); plt.grid(alpha=0.3); plt.tight_layout()
    plt.savefig(os.path.join(DOC, "vco_tuning.png"), dpi=110)


def ifchain():
    plt.figure(figsize=(7, 4.5))
    for k in range(4):
        d = np.loadtxt(os.path.join(SIM, "if_ac_code%d" % k))
        plt.semilogx(d[:, 0], d[:, 1], label="G1=G2=G3=%d%d" % (k >> 1, k & 1))
    for x, t in ((1.55e6, "GAL low"), (4.092e6, "GPS/GAL"), (6.64e6, "GAL high"), (8.184e6, "fs/2"),
                 (11.25e6, "alias of GPS")):
        plt.axvline(x, color="gray", lw=0.6, ls="--"); plt.text(x, -18, t, rotation=90, fontsize=7)
    plt.ylim(-20, 75); plt.xlim(1e5, 1e8)
    plt.xlabel("IF frequency [Hz]"); plt.ylabel("gain [dB]"); plt.grid(alpha=0.3, which="both")
    plt.title("IF chain (6 VGA + 2 Sallen-Key), GPS/Galileo - ngspice AC")
    plt.legend(fontsize=8); plt.tight_layout(); plt.savefig(os.path.join(DOC, "if_response.png"), dpi=110)


def pfdcp():
    xs, ys = [], []
    for f in glob.glob(os.path.join(SIM, "tb_pfdcp_*.log")):
        m = re.search(r"iavg=([-\d.E+]+)", open(f).read())
        if m:
            xs.append(float(os.path.basename(f)[9:-4])); ys.append(-float(m.group(1)) * 1e6)
    o = np.argsort(xs)
    plt.figure(figsize=(5, 3.5))
    plt.plot(np.array(xs)[o], np.array(ys)[o], "o-")
    plt.xlabel("FB delay vs REF [ns]"); plt.ylabel("avg CP current [uA]"); plt.grid(alpha=0.3)
    plt.title("PFD + CP transfer (ngspice)"); plt.tight_layout()
    plt.savefig(os.path.join(DOC, "pfdcp.png"), dpi=110)


def pll():
    p = os.path.join(SIM, "tb_pll_vctrl")
    if not os.path.exists(p):
        return
    d = np.loadtxt(p)
    plt.figure(figsize=(6, 3.5))
    plt.plot(d[:, 0] * 1e6, d[:, 1])
    plt.xlabel("time [us]"); plt.ylabel("VCTRL [V]"); plt.grid(alpha=0.3)
    plt.title("Transistor-level PLL lock transient"); plt.tight_layout()
    plt.savefig(os.path.join(DOC, "pll_lock.png"), dpi=110)


if __name__ == "__main__":
    vco(); ifchain(); pfdcp(); pll()
