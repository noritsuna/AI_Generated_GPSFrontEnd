"""Analyse tb_ifadc: 2-bit ADC statistics per SPI gain setting + tone detection."""
import json, os
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
d = np.loadtxt(os.path.join(ROOT, "sim", "tb_ifadc_out"))
t, clk, sign, mag, vif = d[:, 0], d[:, 1], d[:, 3], d[:, 5], d[:, 7]
FS = 16.368e6
# sample outputs 25 ns after each clock rising edge (comparator + latch delay)
re_ = np.where((clk[:-1] < 1.65) & (clk[1:] >= 1.65))[0]
ts = t[re_] + 25e-9
s = np.interp(ts, t, sign) > 1.65
m = np.interp(ts, t, mag) > 1.65
v = np.where(s, 1, -1) * np.where(m, 3, 1)
res = {}
for name, a, b in (("POR default G=00 (before first write)", 2.0e-6, 4e-6),
                   ("SPI write 1: G1=G2=G3=01", 15e-6, 40e-6),
                   ("SPI write 2: G1=G2=G3=00", 55e-6, 80e-6)):
    k = (ts > a) & (ts < b)
    vif_k = (t > a) & (t < b)
    tone = np.abs(np.mean(v[k] * np.exp(-2j * np.pi * 4.13e6 * ts[k])))
    res[name] = dict(samples=int(k.sum()), mag_fraction=float(m[k].mean()), sign_mean=float(np.mean(np.where(s[k], 1, -1))),
                     if_out_rms_V=float(np.std(vif[vif_k])), tone_4130kHz_amplitude=float(tone))
json.dump(res, open(os.path.join(ROOT, "doc", "ifadc_summary.json"), "w"), indent=1)
print(json.dumps(res, indent=1))
fig, ax = plt.subplots(2, 1, figsize=(9, 5), sharex=True)
ax[0].plot(t * 1e6, vif, lw=0.4); ax[0].set_ylabel("IF out diff [V]")
for y in (0.157, -0.157):
    ax[0].axhline(y, color="r", lw=0.6, ls="--")
ax[1].step(ts * 1e6, v, lw=0.4); ax[1].set_ylabel("ADC code (+-1, +-3)"); ax[1].set_xlabel("time [us]")
for x in (4, 40):
    for a_ in ax:
        a_.axvline(x, color="k", lw=0.6)
ax[0].set_title("tb_ifadc: SPI gain writes at 4 us (01) and 40 us (00); red = ADC thresholds")
plt.tight_layout(); plt.savefig(os.path.join(ROOT, "doc", "ifadc.png"), dpi=110)
