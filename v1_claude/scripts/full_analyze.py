"""Analyse the full-chip transient (tb_full) from ngspice (wrdata) or Xyce (CSV).

Signals (same order in both): vctrl, clkout, isign, imag, qsign, qmag, IF I diff, IF Q diff,
mixer I diff, mixer Q diff, rfin, LNA diff out, I(VDD).
"""
import json, os, sys
import numpy as np

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
NAMES = ["vctrl", "clkout", "isign", "imag", "qsign", "qmag", "ifI", "ifQ", "mixI", "mixQ", "rfin", "lna", "idd"]


def load(tool):
    if tool == "ngspice":
        d = np.loadtxt(os.path.join(ROOT, "sim", "tb_full_out"))
        return d[:, 0], {n: d[:, 2 * k + 1] for k, n in enumerate(NAMES)}
    d = np.loadtxt(os.path.join(ROOT, "sim", "xyce", "tb_full.cir.csv"), delimiter=",", skiprows=1)
    return d[:, 0], {n: d[:, k + 1] for k, n in enumerate(NAMES)}


def tone(t, v, f, a, b, dt=0.5e-9):
    tu = np.arange(a, b, dt)
    x = np.interp(tu, t, v)
    n = int((b - a) * f)
    k = tu < a + n / f
    return np.mean(x[k] * np.exp(-2j * np.pi * f * tu[k])) * 2


def main(tool):
    t, s = load(tool)
    tend = t[-1]
    r = dict(tool=tool, sim_end_us=float(tend * 1e6))
    for x in (1, 2, 3, 4, 6, 8, 10, 11.5):
        if x * 1e-6 < tend:
            m = (t >= x * 1e-6) & (t < x * 1e-6 + 0.2e-6)
            r["vctrl@%gus" % x] = float(s["vctrl"][m].mean())
    a, b = max(tend - 4e-6, tend / 2), tend
    clk = s["clkout"]
    e = np.where((clk[:-1] < 1.65) & (clk[1:] >= 1.65))[0]
    te = t[e][t[e] > a]
    if len(te) > 2:
        r["CLKOUT_MHz"] = float((len(te) - 1) / (te[-1] - te[0]) / 1e6)
    m = t > a
    r["IDD_mA"] = float(-np.mean(s["idd"][m]) * 1e3)
    f_if = 1575.42e6 - 96 * 16.368e6
    for n in ("lna", "mixI", "mixQ", "ifI", "ifQ"):
        f = 1575.42e6 if n == "lna" else f_if
        if n == "lna":
            c = tone(t, s[n], f, b - 20e-9, b, dt=5e-12)
        else:
            c = tone(t, s[n], f, a, b)
        r["%s_tone_peak_mV" % n] = float(abs(c) * 1e3)
        if n in ("mixI", "ifI"):
            cI = c
        if n in ("mixQ", "ifQ"):
            r["%s_Q_minus_I_deg" % n[:-1]] = float(np.degrees(np.angle(c / cI)))
        r["%s_rms_mV" % n] = float(np.std(s[n][m]) * 1e3)
    ts = te + 25e-9
    for ch in ("i", "q"):
        sg = np.interp(ts, t, s[ch + "sign"]) > 1.65
        mg = np.interp(ts, t, s[ch + "mag"]) > 1.65
        r["%s_MAG_fraction" % ch.upper()] = float(mg.mean())
        r["%s_SIGN_mean" % ch.upper()] = float(np.mean(np.where(sg, 1, -1)))
    json.dump(r, open(os.path.join(ROOT, "doc", "full_%s_summary.json" % tool), "w"), indent=1)
    print(json.dumps(r, indent=1))


if __name__ == "__main__":
    main(sys.argv[1])
