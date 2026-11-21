"""Detail analysis of tb_full (after full_analyze.py): tone correlation over 4 us-end with noise-floor bins,
complex image ratio, 2-bit ADC statistics vs Gaussian expectation, 16.368 MHz harmonics on the IF outputs.
    python3 scripts/full_detail.py ngspice|xyce
"""
import os, sys
import numpy as np
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__))); import full_analyze as fa
from math import erfc, sqrt
tool = sys.argv[1]
t, s = fa.load(tool)
fif = 1575.42e6 - 96*16.368e6
a, b = 4e-6, 12e-6
dt = 2e-9
tu = np.arange(a, b, dt)
def c(x, f): return np.mean(x*np.exp(-2j*np.pi*f*tu))*2
for n in ("mixI","mixQ","ifI","ifQ"):
    x = np.interp(tu, t, s[n]); x = x - x.mean()
    sig = c(x, fif)
    off = [abs(c(x, fif+d)) for d in np.r_[-1.5e6:-0.3e6:0.125e6, 0.375e6:1.5e6:0.125e6]]
    print("%-5s tone %.4g mV  phase %7.1f deg  noise-bin rms %.3g mV" % (n, abs(sig)*1e3, np.degrees(np.angle(sig)), np.sqrt(np.mean(np.square(off)))*1e3))
# image check: complex I + jQ at +fif vs -fif
for p in ("mix","if"):
    I = np.interp(tu,t,s[p+"I"]); Q = np.interp(tu,t,s[p+"Q"]); z = (I-I.mean()) + 1j*(Q-Q.mean())
    pos = abs(np.mean(z*np.exp(-2j*np.pi*fif*tu))); neg = abs(np.mean(z*np.exp(2j*np.pi*fif*tu)))
    print(p, "complex +fif %.3g  -fif %.3g  ratio %.1f dB" % (pos*1e3, neg*1e3, 20*np.log10(max(pos,neg)/min(pos,neg))))
a, b = 4e-6, t[-1]
clk = s["clkout"]; e = np.where((clk[:-1] < 1.65) & (clk[1:] >= 1.65))[0]; te = t[e]; te = te[(te > a) & (te < b - 30e-9)]
ts = te + 25e-9
m = (t > a)
for ch, n in (("i","ifI"), ("q","ifQ")):
    sg = np.interp(ts, t, s[ch+"sign"]) > 1.65; mg = np.interp(ts, t, s[ch+"mag"]) > 1.65
    x = np.interp(ts - 25e-9, t, s[n])
    sd = np.std(s[n][m]); dc = np.mean(s[n][m])
    exp = 0.5*erfc(0.157/sd/sqrt(2))*2
    agree = np.mean(sg == (np.interp(te, t, s[n]) > 0))
    print("%s: N=%d MAG=1 %.3f (Gauss expect %.3f for rms %.1f mV)  SIGN mean %+.3f  IF dc %+.2f mV  sign/IF agree %.2f"
          % (ch.upper(), len(ts), mg.mean(), exp, sd*1e3, np.mean(np.where(sg,1,-1)), dc*1e3, agree))
    # levels
    lv = np.where(sg,1,-1)*np.where(mg,3,1); print("   level histogram -3,-1,+1,+3:", [int(np.sum(lv==k)) for k in (-3,-1,1,3)])
# 16.368 MHz harmonics on IF outputs (rev.2 issue)
dt = 0.25e-9; tu = np.arange(a, b, dt)
for n in ("ifI","ifQ"):
    x = np.interp(tu, t, s[n]); x -= x.mean()
    h = {k: abs(np.mean(x*np.exp(-2j*np.pi*k*16.368e6*tu)))*2e3 for k in range(1, 17)}
    print(n, "16.368 MHz harmonics peak mV:", " ".join("%d:%.2f" % (k, v) for k, v in h.items()))
