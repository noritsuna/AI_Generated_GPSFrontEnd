"""Whole-chip runs with noise (chip_spice.py cases nz_* / ns_* / cw_ref): effect of the leak of the chip's own ADC outputs on C/N0.
The noise source of a run is the same sequence in every run, so
  nz_<c>            noise only                 -> noise at the IF outputs
  ns_<c> - nz_<c>   same noise, CW 11.2 uV on  -> response to the signal (the noise cancels where the chain is linear)
  cw_ref            CW only, no noise          -> response to the signal in the reference (ns_ref did not get far enough)
conditions <c>: ser = 330 ohm in series on the board, VSS joined (0.5 ohm) = the chip as it is
                iso = digital and analog VSS separated (1 Mohm)
                ref = iso + analog supply wires without inductance = reference without the leak
usage: chip_noise.py [t0=4.5e-6] [t1=<common end>]    log: layout/review/r4_chip_spice_noise.log"""
import os, sys
import numpy as np
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import chip_spice as cs

FIF = 4.092e6; FS = 16.368e6; DTG = 50e-12; BW = 1.5e6          # IF, ADC clock, grid of the resampled waves, half width of the noise band
VIN = 11.2e-6; VN = 0.9e-3; TN = 49.7e-12                        # CW amplitude, noise rms and noise step of the source
PAIRS = {"ser": ("ns_ser", "nz_ser"), "iso": ("ns_iso", "nz_iso"), "ref": ("cw_ref", None)}
NOISE = {"ser": "nz_ser", "iso": "nz_iso", "ref": "nz_ref"}
KEYS = ("ifI", "ifQ", "isign", "imag", "qsign", "qmag", "fs")
db = lambda x: 20 * np.log10(x)


def grid(c, t0, t1):
    t, d = cs.load(c); g = np.arange(t0, t1, DTG)
    return g, {k: np.interp(g, t, d[:, cs.COL[k]]) for k in KEYS}


def fit(g, v, f):
    """complex amplitude of exp(+j 2 pi f t) in v (v may be complex), offset removed"""
    tt = g - g[0]; M = np.stack([np.exp(2j * np.pi * f * tt), np.exp(-2j * np.pi * f * tt), np.ones(len(tt))], 1)
    k = np.linalg.lstsq(M, v.astype(complex), rcond=None)[0]
    return k, v - M @ k


def psd(g, v):
    """one-sided (two-sided for complex v) PSD with a Hann window, V^2/Hz"""
    n = len(v); w = np.hanning(n); x = np.fft.fft((v - v.mean()) * w); f = np.fft.fftfreq(n, DTG)
    p = np.abs(x) ** 2 * DTG / (w ** 2).sum()
    return f, p


def band(g, v, fc):
    """mean PSD in fc +- BW (per Hz of that band) and the rms in it"""
    f, p = psd(g, v); m = np.abs(f - fc) <= BW
    return p[m].mean(), np.sqrt(p[m].sum() / (len(v) * DTG))


def split(g, zr, zc, fc, K=8, test=None):
    """noise of a condition (zc) against the reference (zr), both I + jQ of noise-only runs with the same noise sequence:
    in every block of K frequency bins of fc +- BW fit  Zc(f) = A Zr(f) + B conj(Zr(-f)) + E(f).
    A = gain change (acts on the signal too), B = image brought in, E = noise that is new. E is corrected for the two fitted values (K / (K - 2)).
    returns |A| at fc, power of B and of E relative to the A part"""
    n = len(zr); f = np.fft.fftfreq(n, DTG); R = np.fft.fft(zr - zr.mean()); C = np.fft.fft(zc - zc.mean())
    Rm = np.conj(R[(-np.arange(n)) % n])                       # conj(Zr(-f))
    i = np.where(np.abs(f - fc) <= BW)[0]; i = i[np.argsort(f[i])]; pa = pb = pe = 0; a0 = []
    for j in range(0, len(i) - K + 1, K):
        k = i[j:j + K]; M = np.stack([R[k], Rm[k]], 1); c = np.linalg.lstsq(M, C[k], rcond=None)[0]
        e = C[k] - M @ c; pa += (abs(c[0] * R[k]) ** 2).sum(); pb += (abs(c[1] * Rm[k]) ** 2).sum(); pe += (abs(e) ** 2).sum() * K / (K - 2)
        a0.append((abs(f[k].mean() - fc), abs(c[0])))
    return min(a0)[1], pb / pa, pe / pa


def samples(g, w):
    """2-bit samples of the pads, taken 3 ns before each rising edge of the ADC clock: values -3, -1, 1, 3"""
    c = w["fs"] > cs.VDD / 2; i = np.where(~c[:-1] & c[1:])[0]; i = i[i > 60] - 60
    q = lambda s, m: (2.0 * (w[s][i] > cs.VDD / 2) - 1) * (1 + 2 * (w[m][i] > cs.VDD / 2))
    return g[i], q("isign", "imag"), q("qsign", "qmag")


def main():
    a = dict(x.split("=") for x in sys.argv[1:]); t0 = float(a.get("t0", 4.5e-6))
    ends = {c: cs.load(c)[0][-1] for c in ("ns_ser", "nz_ser", "ns_iso", "nz_iso", "nz_ref", "cw_ref")}
    t1 = float(a.get("t1", min(ends.values()) - 5e-9))
    print("simulated: " + ", ".join("%s %.3f us" % (c, e * 1e6) for c, e in ends.items()))
    print("window %.3f ... %.3f us (%.2f us, %d ADC samples), noise band %.3f +- %.1f MHz" % (t0 * 1e6, t1 * 1e6, (t1 - t0) * 1e6, (t1 - t0) * FS, FIF / 1e6, BW / 1e6))
    cn_in = VIN ** 2 / 2 / (VN ** 2 * 2 * TN)
    print("source: CW %.1f uV, noise %.2e V^2/Hz -> C/N0 at the source %.1f dB-Hz" % (VIN * 1e6, VN ** 2 * 2 * TN, 10 * np.log10(cn_in)))
    res = {}
    for c in ("ref", "iso", "ser"):
        g, nz = grid(NOISE[c], t0, t1); _, ns = grid(PAIRS[c][0], t0, t1)
        if PAIRS[c][1]:
            sg = {k: ns[k] - nz[k] for k in ("ifI", "ifQ")}
        else:
            sg = {k: ns[k] for k in ("ifI", "ifQ")}
        r = {}
        print("== %s  (signal from %s%s, noise from %s)" % (c, PAIRS[c][0], " - " + PAIRS[c][1] if PAIRS[c][1] else "", NOISE[c]))
        for k in ("ifI", "ifQ"):
            (ap, am, _), rest = fit(g, sg[k], FIF); amp = 2 * abs(ap)
            n0, nb = band(g, nz[k], FIF); _, rb = band(g, rest.real, FIF)
            r[k] = (amp, n0, np.angle(ap))
            print("  %s: signal %.1f mV, noise total %.1f mV rms, in band %.1f mV rms, N0 %.3e V^2/Hz -> C/N0 %.1f dB-Hz; rest of the signal response in band %.2f mV rms"
                  % (k, amp * 1e3, nz[k].std() * 1e3, nb * 1e3, n0 * 2, 10 * np.log10(amp ** 2 / 2 / (n0 * 2)), rb * 1e3))
        ph = np.degrees(r["ifQ"][2] - r["ifI"][2]); ph = (ph + 180) % 360 - 180
        zs = sg["ifI"] + 1j * sg["ifQ"]; zn = nz["ifI"] + 1j * nz["ifQ"]
        (ap, am, _), rest = fit(g, zs, FIF); s = 1 if abs(ap) > abs(am) else -1; A = max(abs(ap), abs(am))
        n0, nb = band(g, zn, s * FIF); _, rb = band(g, rest, s * FIF)
        cn = A ** 2 / n0; res[c] = (A, n0, cn, rb)
        print("  I + jQ: Q - I phase %.1f deg, wanted sideband %.1f mV, image %.1f mV (%.1f dB), N0 %.3e V^2/Hz -> C/N0 %.1f dB-Hz (loss from the source %.1f dB); rest in band %.2f mV rms"
              % (ph, A * 1e3, min(abs(ap), abs(am)) * 1e3, db(min(abs(ap), abs(am)) / A), n0, 10 * np.log10(cn), 10 * np.log10(cn_in / cn), rb * 1e3))
        # 2-bit samples at the pads
        ts, xi, xq = samples(g, nz); out = "  pads, noise only: %d samples, MAG duty I %.2f Q %.2f" % (len(ts), (abs(xi) > 2).mean(), (abs(xq) > 2).mean())
        if PAIRS[c][1]:
            t2, yi, yq = samples(g, ns)
            if len(t2) == len(ts):
                e = np.exp(-2j * np.pi * s * FIF * (ts - ts[0])); zd = (yi - xi) + 1j * (yq - xq)
                out += "; with CW %d of %d I and %d Q samples change, correlation of the change with the IF tone %.2f LSB (of noise only %.2f, of CW + noise %.2f)" % (
                    (yi != xi).sum(), len(ts), (yq != xq).sum(), abs((zd * e).mean()), abs(((xi + 1j * xq) * e).mean()), abs(((yi + 1j * yq) * e).mean()))
        print(out)
    te = min(ends[c] for c in NOISE.values()) - 5e-9; z = {}
    for c in NOISE:
        g, w = grid(NOISE[c], t0, te); z[c] = w["ifI"] + 1j * w["ifQ"]
    print("== noise-only runs against the reference, %.3f ... %.3f us, I + jQ, band %.3f +- %.1f MHz, blocks of 8 bins (%.2f MHz)" % (t0 * 1e6, te * 1e6, FIF / 1e6, BW / 1e6, 8 / (te - t0) / 1e6))
    rng = np.random.default_rng(1); e = rng.normal(0, 1, len(g)) + 1j * rng.normal(0, 1, len(g)); f, p = psd(g, e); pr = psd(g, z["ref"])[1]; m = np.abs(f - s * FIF) <= BW
    e *= np.sqrt(0.02 * pr[m].mean() / p[m].mean()); d = int(round(40e-9 / DTG))
    a, b, n = split(g, z["ref"], 1.15 * np.roll(z["ref"], d) + 0.05 * np.conj(z["ref"]) + e, s * FIF)
    print("  check of the method: reference * 1.15 delayed 40 ns + image -27.2 dB + new noise -18.2 dB (both relative to the gain part) -> found gain %.3f, image %.1f dB, new noise %.1f dB" % (a, 10 * np.log10(b), 10 * np.log10(n)))
    print("  (so the new noise comes out up to about 3 dB too high and the image has a floor near new noise / 8: the losses below are on the high side)")
    for c in ("iso", "ser"):
        a, b, n = split(g, z["ref"], z[c], s * FIF)
        print("  %s: gain change %+.2f dB (signal measured above %+.2f dB), image noise %.1f dB, new noise %.1f dB -> C/N0 %+.2f dB"
              % (c, db(a), db(res[c][0] / res["ref"][0]), 10 * np.log10(b), 10 * np.log10(n), -10 * np.log10(1 + b + n)))
    print("== C/N0 of I + jQ relative to the reference from the signal amplitude and the band noise (each uncertain by about 1 dB in this short window)")
    for c in ("iso", "ser"):
        print("  %s: signal %+.2f dB, noise %+.2f dB -> C/N0 %+.2f dB" % (c, db(res[c][0] / res["ref"][0]), 10 * np.log10(res[c][1] / res["ref"][1]), 10 * np.log10(res[c][2] / res["ref"][2])))


if __name__ == "__main__":
    main()
