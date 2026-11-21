"""Long whole-chip runs (chip_spice.py: ser_330l, ser_1kl, iso_l): rest of the IF outputs after removing the 4.092 MHz tone
(time-weighted least squares; also with 5 harmonics and a cubic removed), rms of mixer outputs and VSS, spectrum of the rest.
usage: chip_long.py ser_330l ser_1kl iso_l"""
import sys, numpy as np
import os; sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import chip_spice as cs
F0 = 4.092e6
def fit(t, v, a, b, harm=1, poly=1):
    m = (t >= a) & (t <= b); tt = t[m] - a; w = np.gradient(t)[m]
    cols = []
    for h in range(1, harm + 1):
        cols += [np.cos(2*np.pi*h*F0*tt), np.sin(2*np.pi*h*F0*tt)]
    cols += [(tt/(b-a))**k for k in range(poly + 1)]
    M = np.stack(cols, 1); sw = np.sqrt(w)[:, None]
    k = np.linalg.lstsq(M*sw, v[m]*sw[:, 0], rcond=None)[0]
    r = v[m] - M @ k
    return np.hypot(k[0], k[1]), np.degrees(np.arctan2(k[1], k[0])), np.sqrt(np.sum(r*r*w)/np.sum(w)), tt, r
def rms(t, v, a, b):
    m = (t >= a) & (t <= b); w = np.gradient(t)[m]; x = v[m] - np.sum(v[m]*w)/np.sum(w)
    return np.sqrt(np.sum(x*x*w)/np.sum(w))
for c in sys.argv[1:]:
    t, d = cs.load(c); g = lambda k: d[:, cs.COL[k]]; te = min(9.9e-6, t[-1] - 0.02e-6)
    print("==", c, "end %.2f us" % (t[-1]*1e6))
    wins = [(3.2, 4.2), (4.2, 5.2), (5.2, 6.2), (6.2, 7.2), (7.2, 8.2), (8.2, min(9.2, te*1e6)), (3.2, te*1e6), (5.2, te*1e6)]
    for a, b in wins:
        a, b = a*1e-6, b*1e-6
        o = []
        for k in ("ifI", "ifQ"):
            A, ph, r1, _, _ = fit(t, g(k), a, b, 1, 1); _, _, r3, _, _ = fit(t, g(k), a, b, 5, 3)
            o.append("%s tone %.1f mV %.0f deg rest %.1f (harm5+poly3: %.1f) mV rms" % (k, A*1e3, ph, r1*1e3, r3*1e3))
        print("  %.1f-%.2f us: %s | mix I/Q %.2f/%.2f mV  vssa %.2f vssd %.2f mV rms" % (a*1e6, b*1e6, " ; ".join(o),
              rms(t, g("mixI"), a, b)*1e3, rms(t, g("mixQ"), a, b)*1e3, rms(t, g("vssa"), a, b)*1e3, rms(t, g("vssd"), a, b)*1e3))
    # spectrum of the rest (tone + slope removed), 5.2 .. end, uniform 2 ns
    a = 5.2e-6
    for k in ("ifI", "ifQ"):
        _, _, _, tt, r = fit(t, g(k), a, te, 1, 1)
        tu = np.arange(0, te - a, 2e-9); ru = np.interp(tu, tt, r) * np.hanning(len(tu))
        S = np.abs(np.fft.rfft(ru))**2; f = np.fft.rfftfreq(len(tu), 2e-9); tot = S.sum()
        bands = [(0, 1e6), (1e6, 3e6), (3e6, 5e6), (5e6, 9e6), (9e6, 20e6), (20e6, 250e6)]
        pk = f[np.argsort(S)[-6:][::-1]]/1e6
        print("  %s rest spectrum share: %s ; peaks MHz %s" % (k, " ".join("%g-%gMHz %.0f%%" % (x/1e6, y/1e6, 100*S[(f >= x) & (f < y)].sum()/tot) for x, y in bands), np.round(pk, 2)))
