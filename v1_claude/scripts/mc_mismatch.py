"""Mismatch Monte Carlo on the final schematics (sw_stat_mismatch=1, MOS only; seed 0 = nominal).
  adc     adc2b: SIGN / MAG thresholds from a slow differential ramp
  vcomix  open-loop VCO -> mixer: LO I/Q phase error and IF I/Q gain / phase imbalance
          (two passes per seed: the first finds fLO, the second puts the RF tone 4.092 MHz above it)
  mixer   mixer_iq with an ideal 8-phase LO (tb_mixer): IF I/Q gain / phase imbalance and DC offset
  pll     closed-loop PLL (tb_pll): lock voltage, static phase error, VCTRL ripple and the
          reference spurs of the LO (charge-pump up / down mismatch), TT and SS
usage: mc_mismatch.py adc|vcomix|mixer|pll [n=40] [jobs=4] [corner=tt]   results: sim/mc/<kind>*.txt"""
import os, re, subprocess, sys
from concurrent.futures import ThreadPoolExecutor
import numpy as np
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE); sys.path.insert(0, os.path.join(HERE, "layout"))
os.environ.setdefault("PDK", "gf180mcuD"); os.environ.setdefault("PDK_ROOT", os.path.expanduser("~/pdk"))
import run

OUT = os.path.join(run.SIM, "mc")
FR = 16.368e6


def mm(text, seed):
    """switch the mismatch on (after the PDK include, so that it overrides the default)"""
    t, k = re.subn(r"^(\s*\.include .*design\.ngspice)$",
                   lambda m: m.group(1) + ("\n.param sw_stat_mismatch=1\n.option seed=%d" % seed if seed else ""), text, flags=re.M)
    assert k == 1
    return t


def corner(t, c):
    lib, temp, v = {"tt": ("typical", 27, 3.3), "ss": ("ss", 85, 3.135), "ff": ("ff", -20, 3.465)}[c]
    if c != "tt":
        t, k = re.subn(r"(sm141064\.ngspice) (res_|mimcap_)?typical", lambda m: "%s %s%s" % (m.group(1), m.group(2) or "", lib), t)
        assert k == 3
        t = t.replace("VDD vdd 0 3.3", "VDD vdd 0 %g" % v)
    return t.replace(".control", ".temp %g\n.control" % temp, 1), v


def ng(text, name):
    p = os.path.join(OUT, name + ".spice")
    open(p, "w").write(text)
    r = subprocess.run(["ngspice", "-b", p], cwd=OUT, capture_output=True, text=True)
    return (r.stdout + r.stderr).replace("\r", "\n")


def ctl(text, body):
    t, k = re.subn(r"^\.control.*?^\.endc", lambda m: ".control\nset num_threads=1\n" + body + "\n.endc", text, flags=re.M | re.S)
    assert k == 1
    return t


# ---------------------------------------------------------------- ADC
def adc(seed, base):
    w = "adc_%d_w" % seed
    t = re.sub(r"^VIP inp .*$", "VD vd 0 pwl(0 -0.25 16u 0.25)\nEP inp 0 vol='1.2+v(vd)/2'", base, flags=re.M)
    t = re.sub(r"^VIN inn .*$", "EN inn 0 vol='1.2-v(vd)/2'", t, flags=re.M)
    t = ctl(mm(t, seed), "tran 0.5n 16u\nwrdata %s v(vd) v(clk) v(sign) v(mag)" % w)
    ng(t, "adc_%d" % seed)
    d = np.loadtxt(os.path.join(OUT, w)); os.remove(os.path.join(OUT, w))
    tt, vd, ck, sg, mg = d[:, 0], d[:, 1], d[:, 3], d[:, 5], d[:, 7]
    e = np.where((ck[:-1] < 1.65) & (ck[1:] >= 1.65))[0]
    ts = tt[e] + 25e-9; S = np.interp(ts, tt, sg) > 1.65; M = np.interp(ts, tt, mg) > 1.65; V = np.interp(tt[e], tt, vd)

    def thr(b, sel):
        """threshold of a rising decision inside the window sel (the count of 0 decisions, so that
        chatter of a few samples at the threshold does not matter)"""
        v, b = V[sel], b[sel]
        return (v[0] + (v[1] - v[0]) * (np.sum(~b) - 0.5)) * 1e3
    return "seed=%d sign=%.2f magn=%.2f magp=%.2f" % (seed, thr(S, abs(V) < 0.12), thr(~M, V < -0.05), thr(M, V > 0.05))


# ---------------------------------------------------------------- VCO + mixer
def vcomix(seed, vc):
    import pex_vcomix as pv
    T0, T1 = 0.4e-6, 1.0e-6
    frf = 1571.3e6 + pv.FIF
    for k in (0, 1):
        fn = os.path.join(OUT, "vm_%d_%d.txt" % (seed, k))
        t = mm(pv.deck(False, vc, 0, "tt", T1, frf, fn), seed).replace("set num_threads=2", "set num_threads=1")
        ng(t, "vm_%d_%d" % (seed, k))
        d = np.loadtxt(fn); os.remove(fn)
        tt = d[:, 0]; m = tt > T0
        flo, err, iq = pv.lo_metrics(tt, d[:, 5::2], T0)
        if k == 0:
            frf = flo + pv.FIF
    fif = frf - flo        # known IF (zero crossings fail: the LO feedthrough is larger than the IF tone)
    ai, pi_ = pv.fit(tt[m], d[m, 1], fif); aq, pq = pv.fit(tt[m], d[m, 3], fif)
    lop = [np.ptp(d[m, 5 + 2 * i]) for i in range(8)]
    return "seed=%d flo=%.3f lo_iq=%.3f lo_err=%s fif=%.3f ai=%.4f aq=%.4f imb=%.3f dphi=%.3f lopp=%.3f" % (
        seed, flo / 1e6, iq, "/".join("%.2f" % x for x in err[1:]), fif / 1e6, ai * 1e3, aq * 1e3,
        20 * np.log10(aq / ai), (pq - pi_ + 180) % 360 - 180, min(lop))


# ---------------------------------------------------------------- mixer (ideal 8-phase LO)
def mixer(seed, base):
    import pex_vcomix as pv
    w = os.path.join(OUT, "mix_%d_w" % seed)
    t = ctl(mm(base.replace(" ARF ", " 1m "), seed), "tran 5p 0.75u 0 5p\nlinearize v(ifip) v(ifin) v(ifqp) v(ifqn)\n"
            "wrdata %s v(ifip)-v(ifin) v(ifqp)-v(ifqn)" % w)
    ng(t, "mix_%d" % seed)
    d = np.loadtxt(w); os.remove(w)
    tt = d[:, 0]; m = tt > 0.26e-6
    ai, pi_ = pv.fit(tt[m], d[m, 1], pv.FIF); aq, pq = pv.fit(tt[m], d[m, 3], pv.FIF)
    return "seed=%d ai=%.4f aq=%.4f imb=%.3f dphi=%.3f dci=%.3f dcq=%.3f" % (
        seed, ai * 1e3, aq * 1e3, 20 * np.log10(aq / ai), (pq - pi_ + 180) % 360 - 180,
        d[m, 1].mean() * 1e3, d[m, 3].mean() * 1e3)


# ---------------------------------------------------------------- PLL
def pll(seed, base, c):
    w = "pll_%s_%d_w" % (c, seed)
    t, v = corner(base, c)
    ts = 6e-6
    if c == "ss":
        t = t.replace("VB0 b0 0 0", "VB0 b0 0 %g" % v).replace("VB1 b1 0 0", "VB1 b1 0 %g" % v).replace("VICP2 icp2 0 0", "VICP2 icp2 0 %g" % v)
        t = t.replace("VREF refin 0 sin(1.65", "VREF refin 0 sin(%g" % (v / 2))
        ts = 8e-6
    t = ctl(mm(t, seed), "save v(vctrl) v(fb) v(refck) v(l1p) v(l1n)\ntran 5p %g 0 5p uic\n"
            "wrdata %s v(vctrl) v(fb) v(refck) v(l1p)-v(l1n)" % (ts, w))
    ng(t, "pll_%s_%d" % (c, seed))
    d = np.loadtxt(os.path.join(OUT, w)); os.remove(os.path.join(OUT, w))
    tt, vc, fb, rf, lo = d[:, 0], d[:, 1], d[:, 3], d[:, 5], d[:, 7]
    T = 1 / FR; t1 = tt[-1]; t0 = t1 - 9 * T
    tu = np.linspace(t0, t1, 9 * 60000, endpoint=False)
    wn = np.hanning(len(tu)); wn /= wn.mean()
    comp = lambda y, f: abs(2 * np.mean(wn * y * np.exp(-2j * np.pi * f * tu)))
    yv = np.interp(tu, tt, vc); yl = np.interp(tu, tt, lo)
    # LO frequency over the window from its zero crossings (the spur bins sit at +/- k fref of it)
    z = tu[1:][(yl[:-1] < 0) & (yl[1:] >= 0)]; flo = (len(z) - 1) / (z[-1] - z[0])
    car = comp(yl, flo)
    sb = [20 * np.log10(max(comp(yl, flo - k * FR), comp(yl, flo + k * FR)) / car) for k in (1, 2, 3)]
    th = v / 2; m = tt >= t0
    er = tt[1:][(rf[:-1] < th) & (rf[1:] >= th) & m[1:]]; ef = tt[1:][(fb[:-1] < th) & (fb[1:] >= th) & m[1:]]
    pe = np.mean([(a - er[np.argmin(abs(er - a))]) for a in ef]) if len(ef) and len(er) else np.nan
    early = vc[(tt > t1 - 1.5e-6) & (tt < t1 - 1.0e-6)].mean()
    return "seed=%d c=%s vctrl=%.4f drift_mV=%.2f vc_pp_mV=%.2f v1_mV=%.3f flo=%.3f pe_ps=%.1f sb1=%.1f sb2=%.1f sb3=%.1f" % (
        seed, c, yv.mean(), (yv.mean() - early) * 1e3, np.ptp(vc[m]) * 1e3, comp(yv - yv.mean(), FR) * 1e3, flo / 1e6, pe * 1e12, *sb)


def main():
    kind = sys.argv[1]
    a = dict(x.split("=", 1) for x in sys.argv[2:])
    n = int(a.get("n", 40)); jobs = int(a.get("jobs", 4)); c = a.get("corner", "tt")
    os.makedirs(OUT, exist_ok=True)
    seeds = range(int(a.get("first", 0)), n + 1)
    if kind == "adc":
        base = open(run.netlist("tb_adc")).read(); f = lambda s: adc(s, base); res = "adc.txt"
    elif kind == "vcomix":
        import pex_vcomix as pv
        pv.netlist("tb_vco"); pv.netlist("tb_mixer")
        vc = float(a.get("vc", 1.444)); f = lambda s: vcomix(s, vc); res = "vcomix.txt"
    elif kind == "mixer":
        base = open(run.netlist("tb_mixer")).read(); f = lambda s: mixer(s, base); res = "mixer.txt"
    else:
        base = open(run.netlist("tb_pll")).read(); f = lambda s: pll(s, base, c); res = "pll_%s.txt" % c

    def safe(s):
        try:
            return f(s)
        except Exception as e:
            return "seed=%d FAILED %r" % (s, e)
    with ThreadPoolExecutor(jobs) as ex, open(os.path.join(OUT, res), "a") as fo:
        for line in ex.map(safe, seeds):
            print(line, flush=True); fo.write(line + "\n"); fo.flush()


if __name__ == "__main__":
    main()
