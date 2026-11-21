"""Fit Sallen-Key MIM sizes so each section matches a 4th-order Butterworth section."""
import sys, re, numpy as np
sys.path.insert(0, __import__('os').path.dirname(__import__('os').path.abspath(__file__)))
import run
from scipy.optimize import minimize

t = open(run.SIM + '/netlist/tb_if.spice').read()
hdr = t[:t.index('**.subckt tb_if')]
models = t[t.index('**** begin user architecture code'):t.index('.control')]
subs = t[t.index('* expanding'):].replace('.end\n', '')
# isolate sk_lpf1 body to use as a template with parametrised caps
body = re.search(r'\.subckt sk_lpf1 .*?\.ends', subs, re.S).group(0)
F0 = float(sys.argv[1]) if len(sys.argv) > 1 else 7.5e6
f = np.logspace(5.5, np.log10(2 * F0), 40)


def target(q):
    s = 1j * f / F0
    return 20 * np.log10(np.abs(1 / (s * s + s / q + 1)))


def sim(c1, c2):
    b = body.replace('sk_lpf1', 'skx')
    b = re.sub(r'(XC1[PN] \S+ \S+ \S+) c_width=\S+ c_length=\S+', r'\1 c_width=%ge-6 c_length=%ge-6' % (c1, c1), b)
    b = re.sub(r'(XC2[PN] \S+ \S+ \S+) c_width=\S+ c_length=\S+', r'\1 c_width=%ge-6 c_length=%ge-6' % (c2, c2), b)
    top = '''
VDD vdd 0 3.3
XB nb pb vdd 0 bias_gen
VIP inp 0 dc 1.2 ac 0.5
VIN inn 0 dc 1.2 ac 0.5 180
RSP inp ip2 2k
RSN inn in2 2k
CSP ip2 0 120f
CSN in2 0 120f
XF ip2 in2 pb gp gn vdd 0 skx
.control
set num_threads=1
ac dec 20 1e5 1e9
let g = db(v(gp)-v(gn))
wrdata SKFIT g
.endc
'''
    run.ngspice(hdr + models + top.replace('SKFIT', run.SIM + '/sk_fit.txt') + subs + "\n" + b + "\n.end\n", 'skfit')
    d = np.loadtxt(run.SIM + '/sk_fit.txt')
    return np.interp(f, d[:, 0], d[:, 1])


def fit(q, x0):
    tg = target(q)
    def cost(x):
        if min(x) < 4: return 1e3
        g = sim(*x)
        return np.mean((g - g[0] - tg) ** 2) + 0.1 * g[0] ** 2
    r = minimize(cost, x0, method='Nelder-Mead', options=dict(xatol=0.2, fatol=0.01, maxiter=60))
    g = sim(*r.x)
    print("Q=%.2f sides C1=%.1f C2=%.1f um  rms err %.2f dB  passband %.2f dB" % (q, r.x[0], r.x[1], np.sqrt(r.fun), g[0]))
    return r.x


if __name__ == '__main__':
    k = np.sqrt(40e6 / F0)
    a = fit(0.541, [20.3 * k, 21.6 * k])
    b = fit(1.307, [43.7 * k, 10.8 * k])
    open(run.SIM + '/sk_sizes.txt', 'w').write("%g %g %g %g\n" % (a[0], a[1], b[0], b[1]))
