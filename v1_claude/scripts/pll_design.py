"""Integer-N PLL loop analysis + phase-noise budget (ring VCO vs LC VCO vs external LO).

Inputs taken from the transistor-level simulations (tb_vco, tb_pfdcp).
"""
import json, os, sys
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

DOC = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "doc")
k = 1.380649e-23
T = 300.0

FREF = 16.368e6
N = 96
F0 = N * FREF
ICP = float(sys.argv[1]) if len(sys.argv) > 1 else 100e-6   # quarter slot: half the CP current, 2x filter impedance
KVCO = float(sys.argv[2]) if len(sys.argv) > 2 else 550e6      # Hz/V (tb_vco)
PVCO = float(sys.argv[3]) if len(sys.argv) > 3 else 3.3 * 3.5e-3  # W  (tb_vco)
R, C1, C2 = 10.4e3, 59.5e-12, 4.9e-12                            # loop_filter.sch (2x impedance, quarter slot)

f = np.logspace(3, 8, 2000)
w = 2 * np.pi * f
s = 1j * w
Z = (1 + s * R * C1) / (s * (C1 + C2) * (1 + s * R * C1 * C2 / (C1 + C2)))
Gol = ICP / (2 * np.pi) * Z * 2 * np.pi * KVCO / s / N   # open-loop gain
ic = np.argmin(np.abs(np.abs(Gol) - 1))
fc = f[ic]
pm = 180 + np.degrees(np.angle(Gol[ic]))
H = Gol / (1 + Gol)          # ref -> out (/N)
E = 1 / (1 + Gol)            # VCO -> out


def ring_pn(df, extra_db=6.0):
    """Hajimiri/McNeill estimate L = (8/3)(kT/P)(Vdd/Vchar)(f0/df)^2, +6 dB margin."""
    return 10 * np.log10(8 / 3 * k * T / PVCO * 4 * (F0 / df) ** 2) + extra_db


def lc_pn(df):
    # external SMD inductor + bond wire, Q~25 -> typ. -118 dBc/Hz @ 1 MHz (1.6 GHz)
    return -118 - 20 * np.log10(df / 1e6)


L_vco = ring_pn(f)
L_ref = 10 * np.log10(10 ** (-13.0 - 0 * f) * (1e3 / f) ** 3 + 10 ** (-14.5) * (1e4 / f) ** 1 + 10 ** -15.2) + 20 * np.log10(N)
L_ref = np.maximum(L_ref, -155 + 20 * np.log10(N))
FOM = -215.0  # normalised in-band noise of PFD/CP (conservative for 180 nm)
L_cp = FOM + 10 * np.log10(FREF) + 20 * np.log10(N) + 0 * f
pll = 10 * np.log10(10 ** ((L_ref) / 10) * np.abs(H) ** 2 + 10 ** (L_cp / 10) * np.abs(H) ** 2
                    + 10 ** (L_vco / 10) * np.abs(E) ** 2)


def integ(Ldb, f1=1e3, f2=50e6):
    m = (f >= f1) & (f <= f2)
    pw = np.trapezoid(10 ** (Ldb[m] / 10), f[m]) * 2
    return np.degrees(np.sqrt(pw))


res = dict(Icp_uA=ICP * 1e6, Kvco_MHz_per_V=KVCO / 1e6, fc_MHz=fc / 1e6, phase_margin_deg=pm,
           ring_free_PN_1MHz=float(ring_pn(1e6)), pll_PN_100kHz=float(np.interp(1e5, f, pll)),
           pll_PN_1MHz=float(np.interp(1e6, f, pll)), pll_PN_10MHz=float(np.interp(1e7, f, pll)),
           rms_phase_err_deg=float(integ(pll)),
           correlation_loss_dB=float(-10 * np.log10(np.exp(-np.radians(integ(pll)) ** 2))))
# vibration: TCXO g-sensitivity (Gamma) x acceleration -> phase modulation of LO
for gam in (1e-9, 1e-10):
    for fv in (20, 100, 500):
        A = 10.0  # g peak (launch random/sine vib. order of magnitude)
        beta = gam * A * 1575.42e6 / fv
        res["vib_spur_dBc G=%gppb/g fv=%dHz" % (gam * 1e9, fv)] = float(20 * np.log10(beta / 2))
        res["vib_phase_pk_deg G=%gppb/g fv=%dHz" % (gam * 1e9, fv)] = float(np.degrees(beta))

plt.figure(figsize=(8, 5))
plt.semilogx(f, L_vco, "--", label="ring VCO free-running (est.)")
plt.semilogx(f, lc_pn(f), ":", label="LC VCO, external L (est.)")
plt.semilogx(f, L_ref + 0 * f, "-.", label="TCXO x N")
plt.semilogx(f, pll, "k", lw=2, label="PLL output, ring VCO (fc=%.2f MHz, PM=%.0f deg)" % (fc / 1e6, pm))
plt.ylim(-150, -40); plt.grid(alpha=0.3, which="both")
plt.xlabel("offset frequency [Hz]"); plt.ylabel("L(f) [dBc/Hz]")
plt.title("LO phase noise @ 1571.328 MHz  (integrated %.1f deg rms, 1k-50MHz)" % integ(pll))
plt.legend(fontsize=8)
plt.tight_layout(); plt.savefig(os.path.join(DOC, "pll_phase_noise.png"), dpi=110)

plt.figure(figsize=(8, 4))
plt.subplot(1, 2, 1)
plt.semilogx(f, 20 * np.log10(np.abs(Gol))); plt.axhline(0, color="k", lw=0.5); plt.grid(alpha=0.3)
plt.ylabel("|Gol| [dB]"); plt.xlabel("Hz")
plt.subplot(1, 2, 2)
plt.semilogx(f, np.degrees(np.angle(Gol))); plt.grid(alpha=0.3); plt.ylabel("phase [deg]"); plt.xlabel("Hz")
plt.tight_layout(); plt.savefig(os.path.join(DOC, "pll_loop.png"), dpi=110)
json.dump(res, open(os.path.join(DOC, "pll_summary.json"), "w"), indent=1)
print(json.dumps(res, indent=1))
