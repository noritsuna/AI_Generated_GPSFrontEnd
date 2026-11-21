"""Ring-VCO phase noise from ngspice transient-noise run (tb_vco_pn).

Zero crossings of v(loip)-v(loin) -> period jitter sigma_T ->
L(df) = f0^3 * sigma_T^2 / df^2   (white-noise-limited oscillator, 1/f^2 region)
The noiseless run (tb_vco_pn0) gives the numerical jitter floor.
"""
import json, os, sys
import numpy as np

SIM = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "sim")


def crossings(fn, t0=0.2e-6):
    d = np.loadtxt(os.path.join(SIM, fn))
    t, v = d[:, 0], d[:, 1]
    i = np.where((v[:-1] < 0) & (v[1:] >= 0) & (t[:-1] > t0))[0]
    return t[i] - v[i] * (t[i + 1] - t[i]) / (v[i + 1] - v[i])


def main():
    out = {}
    for tag, fn in (("noise", "vco_noise_wave"), ("noiseless", "vco_nonoise_wave")):
        tc = crossings(fn)
        T = np.diff(tc)
        out[tag] = dict(f0=float(1 / T.mean()), sigma_T_fs=float(T.std() * 1e15), cycles=int(T.size))
    f0 = out["noise"]["f0"]
    sj2 = max((out["noise"]["sigma_T_fs"] ** 2 - out["noiseless"]["sigma_T_fs"] ** 2), 0) * 1e-30
    out["L_1MHz_dBc_Hz"] = float(10 * np.log10(f0 ** 3 * sj2 / 1e12))
    json.dump(out, open(os.path.join(SIM, "..", "doc", "vco_pn_summary.json"), "w"), indent=1)
    print(json.dumps(out, indent=1))


if __name__ == "__main__":
    main()
