"""System-level simulation of the GPS(+Galileo) AFE output.

GPS L1 C/A + Galileo E1 (BOC(1,1)) with rocket-class Doppler, through the
ngspice IF-chain response (sim/if_ac_code*), 2-bit I/Q ADC at
fs = fLO/96 = 16.368 MS/s, followed by FFT acquisition.
Also: noise-aliasing loss of the IF filter and the AGC link budget for a
20 dB external LNA.
"""
import json, os
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
DOC = os.path.join(ROOT, "doc")
rng = np.random.default_rng(1)

FREF = 16.368e6
FLO = 96 * FREF
FS = FLO / 96
F_L1 = 1575.42e6
TCXO_ERR = +2.0e-6
LO = FLO * (1 + TCXO_ERR)
k_B, T0 = 1.380649e-23, 290.0
G_RX_DB = 28.5           # tb_full (noise-free, dummy divbufs, AC-coupled LO): 50 ohm RF port -> NC-LNA -> mixer with
                         # the real VCO LO (IF diff / matched input voltage; ideal-LO tb_rx gives 28.6 dB)


def if_resp(code=2):
    d = np.loadtxt(os.path.join(ROOT, "sim", "if_ac_code%d" % code))
    return d[:, 0], d[:, 1]


def ca_code(prn):
    taps = {1: (2, 6), 2: (3, 7), 3: (4, 8)}[prn]
    g1 = np.ones(10, int); g2 = np.ones(10, int); c = []
    for _ in range(1023):
        c.append(g1[9] ^ g2[taps[0] - 1] ^ g2[taps[1] - 1])
        f1 = g1[2] ^ g1[9]; f2 = g2[1] ^ g2[2] ^ g2[5] ^ g2[7] ^ g2[8] ^ g2[9]
        g1 = np.r_[f1, g1[:9]]; g2 = np.r_[f2, g2[:9]]
    return 1 - 2 * np.array(c)


def chips(code, rate, tt, ph, boc=False):
    x = tt * rate + ph
    c = code[np.floor(x % len(code)).astype(int)]
    if boc:  # sine-phased BOC(1,1): sign flip in the second half of each chip
        c = c * np.where((x % 1.0) < 0.5, 1, -1)
    return c


def aliasing_loss(fr, gdb, band):
    """C/N0 loss from noise folding: mean over band of sum_k |H(f+k fs)|^2 / |H(f)|^2."""
    f = np.linspace(*band, 200)
    H2 = lambda x: 10 ** (np.interp(np.abs(x), fr, gdb, left=gdb[0], right=gdb[-1]) / 10)
    tot = sum(H2(f + k * FS) for k in range(-20, 21))
    return float(10 * np.log10(np.mean(tot / H2(f))))


def link_budget():
    """Noise at ADC input vs AGC code for a 20 dB external LNA (NF 1.5 dB, SAW 2 dB)."""
    out = {}
    nf_onchip_lna = 1.46    # tb_lna (.noise, NC-LNA with mixer load; AC-coupled LO, static switches at 1.6 V)
    g_lna_db = 14.4         # tb_lna differential voltage gain
    nf_mix = 16.0           # Gilbert mixer NF estimate (analytic, report 3.1)
    nf_chip = 10 * np.log10(10 ** (nf_onchip_lna / 10) + (10 ** (nf_mix / 10) - 1) / 10 ** (g_lna_db / 10))
    out["chip_NF_dB"] = float(nf_chip)
    g_lna, nf_lna, l_saw = 20.0, 1.5, 2.0
    # cascade: LNA -> SAW -> chip
    F = 10 ** (nf_lna / 10) + (10 ** (l_saw / 10) - 1) / 10 ** (g_lna / 10) \
        + (10 ** (nf_chip / 10) - 1) / 10 ** ((g_lna - l_saw) / 10)
    out["system_NF_dB"] = float(10 * np.log10(F))
    out["NF_degradation_vs_LNA_dB"] = float(10 * np.log10(F) - nf_lna)
    # available noise PSD at chip input (dBm/Hz), incl. chip noise referred to input
    n_in = -174 + nf_lna + g_lna - l_saw
    n_tot = 10 * np.log10(10 ** (n_in / 10) + 10 ** ((-174 + nf_chip) / 10))
    for code in range(4):
        fr, g = if_resp(code)
        f = np.linspace(1e4, FS * 3, 20000)
        gl = 10 ** (np.interp(f, fr, g) / 10)            # |H|^2 linear (diff V/V)
        # chip input: 100 ohm diff matched -> v^2 = P*R ; complex: per channel noise = one side band integral x2
        pw = 10 ** ((n_tot - 30) / 10)                     # W/Hz
        v2 = pw * 50 * 10 ** (G_RX_DB / 10) * np.trapezoid(gl, f) * 2  # 50 ohm SE input; both sidebands fold to each I/Q rail
        out["ADC_sigma_V code%d (G1=G2=G3=%d%d)" % (code, code >> 1, code & 1)] = float(np.sqrt(v2))
    out["ADC_threshold_V"] = 0.157
    return out


def main():
    ms = 4
    n = int(round(FS * 1e-3))
    t = np.arange(n * ms) / FS
    N0 = 1.0
    x = (rng.normal(size=t.size) + 1j * rng.normal(size=t.size)) * np.sqrt(N0 * FS / 2)
    gal_code = 1 - 2 * rng.integers(0, 2, 4092)
    sig = [dict(name="GPS PRN1 (C/A)", fd=38.0e3, code=ca_code(1), boc=False, ph=345.6, Tc=1e-3, nnc=4),
           dict(name="Galileo E1 (BOC(1,1))", fd=-39.9e3, code=gal_code, boc=True, ph=1234.3, Tc=4e-3, nnc=1)]
    for s in sig:
        s["f"] = F_L1 + s["fd"]
        s["rate"] = 1.023e6 * (1 + s["fd"] / F_L1)
        A = np.sqrt(10 ** (44.0 / 10) * N0)
        x += A * chips(s["code"], s["rate"], t, s["ph"], s["boc"]) * np.exp(2j * np.pi * (s["f"] - LO) * t + 0.7j)
    fr, gdb = if_resp(2)
    gdb = gdb - np.interp(4.092e6, fr, gdb)
    F = np.fft.fftfreq(t.size, 1 / FS)
    out = {}
    fig, axs = plt.subplots(1, 2, figsize=(11, 4))
    for quant in (False, True):
        # analog: filter applied before sampling -> model at 8x rate is costly; apply |H| incl. aliasing:
        # noise is white before the filter, so sampled noise PSD = sum_k |H(f+k fs)|^2 (done analytically
        # in aliasing_loss); here the in-band shaping is applied and the folded excess noise added.
        H = 10 ** (np.interp(np.abs(F), fr, gdb, left=gdb[0], right=gdb[-1]) / 20)
        fold = np.sqrt(sum(10 ** (np.interp(np.abs(F + k * FS), fr, gdb, left=gdb[0], right=gdb[-1]) / 10)
                           for k in (-3, -2, -1, 1, 2, 3)))
        extra = np.fft.fft((rng.normal(size=t.size) + 1j * rng.normal(size=t.size)) * np.sqrt(N0 * FS / 2))
        y = np.fft.ifft(np.fft.fft(x) * H + extra * fold)
        if quant:
            q = lambda v: np.sign(v) * np.where(np.abs(v) > np.std(v), 3, 1)
            y = q(y.real) + 1j * q(y.imag)
        for j, s in enumerate(sig):
            nc = int(round(FS * s["Tc"]))
            tt = t[:nc]
            rep = chips(s["code"], 1.023e6, tt, 0.0, s["boc"])
            C = np.conj(np.fft.fft(rep))
            fbins = np.arange(-60e3, 60.001e3, 0.5 / s["Tc"])
            fif0 = F_L1 - FLO
            M = np.zeros((len(fbins), nc))
            for i, fd in enumerate(fbins):
                acc = 0
                for k in range(s["nnc"]):
                    seg = y[k * nc:(k + 1) * nc] * np.exp(-2j * np.pi * (fif0 + fd) * (tt + k * s["Tc"]))
                    acc = acc + np.abs(np.fft.ifft(np.fft.fft(seg) * C)) ** 2
                M[i] = acc
            i, c = np.unravel_index(np.argmax(M), M.shape)
            mask = np.ones(nc, bool); w = int(FS / 1.023e6) + 3
            mask[max(0, c - w):c + w] = False
            pk2m = float(10 * np.log10(M[i, c] / np.mean(M[i][mask])))
            out["%s %s" % (s["name"], "2-bit" if quant else "unquantised")] = dict(
                true_apparent_doppler_Hz=float(s["fd"] - TCXO_ERR * FLO), found_doppler_Hz=float(fbins[i]),
                peak_to_mean_dB=pk2m)
            if quant:
                ax = axs[j]
                ax.plot(fbins / 1e3, M.max(axis=1) / np.mean(M[i][mask]))
                ax.set_title("%s: Doppler %+.1f kHz, TCXO %+.1f kHz\nfound %+.2f kHz, peak/mean %.1f dB "
                             "(2-bit, 16.368 MS/s)" % (s["name"], s["fd"] / 1e3, -TCXO_ERR * FLO / 1e3,
                                                        fbins[i] / 1e3, pk2m), fontsize=9)
                ax.set_xlabel("Doppler bin [kHz]"); ax.set_ylabel("max corr / mean"); ax.grid(alpha=0.3)
    plt.tight_layout(); plt.savefig(os.path.join(DOC, "acquisition.png"), dpi=110)
    fr, g2 = if_resp(2)
    out["aliasing_loss_GPS_band_dB"] = aliasing_loss(fr, g2, (3.07e6, 5.12e6))
    out["aliasing_loss_Galileo_band_dB"] = aliasing_loss(fr, g2, (1.55e6, 6.64e6))
    out["link_budget"] = link_budget()
    json.dump(out, open(os.path.join(DOC, "acquisition_summary.json"), "w"), indent=1)
    print(json.dumps(out, indent=1))


if __name__ == "__main__":
    main()
