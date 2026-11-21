"""VCTRL ripple and reference spurs from the pex_pllmix waveforms: VCTRL / C2 harmonics of fref, and the
LO (l1p - l1n) sidebands at fLO +/- k fref measured directly (Hann, 9 reference periods).
usage: pll_spur.py tt_b0_i0 ss_b3_i1 ff_b0_i0  (waveforms written by pex_pllmix.py)"""
import os, sys, numpy as np
fr = 16.368e6; T = 1 / fr; flo = 96 * fr
K = {"tt": 526e6, "ss": 300e6, "ff": 961e6}
for tag in sys.argv[1:]:
    d = np.loadtxt(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "sim", "pllmix_") + tag)
    t = d[:, 0]; vc = d[:, 1]; c2 = d[:, 3]; lo = d[:, 5] - d[:, 7]
    t1 = t[-1]; t0 = t1 - 9 * T
    tt = np.linspace(t0, t1, 9 * 60000, endpoint=False)
    w = np.hanning(len(tt)); w /= w.mean()
    def comp(y, f):
        return abs(2 * np.mean(w * y * np.exp(-2j * np.pi * f * tt)))
    yv = np.interp(tt, t, vc); y2 = np.interp(tt, t, c2); yl = np.interp(tt, t, lo)
    m = t >= t0
    print("%s  VCTRL %.4f V  pp %.1f mV  C2 pp %.1f mV" % (tag, yv.mean(), 1e3 * np.ptp(vc[m]), 1e3 * np.ptp(c2[m])))
    car = comp(yl, flo)
    for k in range(1, 4):
        a = comp(yv - yv.mean(), k * fr)
        est = 20 * np.log10(K[tag[:2]] * a / (k * fr) / 2)
        sb = [20 * np.log10(comp(yl, flo + s * k * fr) / car) for s in (-1, 1)]
        print("   k=%d  VCTRL %.3f mV -> est %.0f dBc | LO sidebands %.1f / %.1f dBc" % (k, a * 1e3, est, sb[0], sb[1]))
