"""Review A-9: whole RF path post-layout with the real LO.  Closed-loop PLL (pll_core PEX + vco_ring4
PEX + LO wires + mixer_iq PEX, deck of pex_pllmix) with the LNA PEX in front of the mixer, driven
from a 50 ohm source through the board match (shunt 3.3 nH, bond wire 1 nH), the RFIN pad (metal
capacitance + ESD diodes) and the macro RFIN wire.  RF = 1575.42 MHz at -70 dBm; the IF tone
(RF - fLO, fLO from the locked loop) is fitted in the last 1.5 us.
usage: rx_pex.py [tt:0:0:2.09] [ss:3:1:1.43] [ff:0:0:1.52]"""
import os, sys, re, json, math
from concurrent.futures import ThreadPoolExecutor
import numpy as np
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, "..")); sys.path.insert(0, os.path.join(HERE, "..", "layout"))
os.environ.setdefault("PDK", "gf180mcuD"); os.environ.setdefault("PDK_ROOT", os.path.expanduser("~/pdk"))
import pexsim, pex_vcomix, pex_pllmix, rfin_match
from pexsim import run
NG = (lambda *a, **k: "") if os.environ.get("ANA") else run.ngspice
FRF, PIN = 1575.42e6, -70.0
EMF = 2 * math.sqrt(2 * 50 * 1e-3 * 10 ** (PIN / 10))
OUT = os.path.join(pexsim.PROJ, "sim", "review")


def deck(corner, b, icp2, vc0):
    tag, t = pex_pllmix.deck(corner, b, icp2, vc0)
    w = json.load(open(os.path.join(pexsim.MAG, "top_wires.json")))["RFIN"]
    rf = ("VRF s0 0 sin(0 %g %.9g)\nRS50 s0 s1 50\nLP s1 0 3.3n\nCIN s1 s2 10p\nLS s2 pad 1n\n" % (EMF, FRF) +
          "CPV pad vdd %g\nCPS pad 0 %g\n" % (rfin_match.CPAD_VDD, rfin_match.CPAD_VSS) +
          "".join("DN%d 0 pad diode_nd2ps_06v0 area=150e-12 pj=106e-6\nDP%d pad vdd diode_pd2nw_06v0 area=150e-12 pj=106e-6\n" % (i, i)
                  for i in range(4)) +
          "RW pad rfin %g\nCW rfin 0 %g\nXLNA rfin pb rfp rfn vdd 0 lna_nc\n" % (max(w["r"], 1e-3), w["c"]))
    t, k = re.subn(r"^RSP rfp 0 50\nRSN rfn 0 50\n", lambda m: rf, t, flags=re.M)
    assert k == 1
    rx = pex_vcomix.netlist("tb_rx")
    t = pex_vcomix.dedupe(t + "\n" + rx[rx.index("**.ends") + 7:].replace(".end\n", ""))
    t = pexsim.swap(t, "lna_nc")
    t = t.replace("sm141064.ngspice " + pex_pllmix.pex_vco.CORNER[corner][2],
                  "sm141064.ngspice %s\n.lib %s/gf180mcuD/libs.tech/ngspice/sm141064.ngspice diode_%s" % (
                      pex_pllmix.pex_vco.CORNER[corner][2], os.environ["PDK_ROOT"], pex_pllmix.pex_vco.CORNER[corner][0]), 1)
    t, k = re.subn(r"^save v\(vctrl\) ", "save v(ifip) v(ifin) v(ifqp) v(ifqn) v(rfin) v(rfp) v(rfn) v(vctrl) ", t, flags=re.M)
    assert k == 1
    t, k = re.subn(r"^\.endc", "wrdata %s v(ifip) v(ifin) v(ifqp) v(ifqn) v(rfin) v(rfp) v(rfn) v(l1p) v(l1n)\n.endc"
                   % os.path.join(OUT, "rxpex_" + tag), t, flags=re.M)
    assert k == 1
    return tag, t + "\n.end\n"


def fit(t, y, f):
    A = np.column_stack([np.cos(2 * np.pi * f * t), np.sin(2 * np.pi * f * t), np.ones_like(t), t - t[0]])
    c = np.linalg.lstsq(A, y, rcond=None)[0]
    return math.hypot(c[0], c[1]), math.degrees(math.atan2(-c[1], c[0]))


def analyse(tag):
    d = np.loadtxt(os.path.join(OUT, "rxpex_" + tag))
    t = d[:, 0]; m = t > 2.5e-6
    t = t[m]; v = d[m][:, 1::2]
    lo = v[:, 7] - v[:, 8]
    c = t[np.where((lo[:-1] < 0) & (lo[1:] >= 0))[0]]
    flo = 2 * (len(c) - 1) / (c[-1] - c[0])
    fif = FRF - flo
    vi, vq = v[:, 0] - v[:, 1], v[:, 2] - v[:, 3]
    ai, pi_ = fit(t, vi, fif); aq, pq = fit(t, vq, fif)
    ar, _ = fit(t, v[:, 4], FRF); am, _ = fit(t, v[:, 5] - v[:, 6], FRF)
    vav = EMF / 2
    return ("fLO %.3f MHz  IF %.3f MHz | RFIN %.1f uV (source %.1f uV available)  LNA out %.1f uV (gain %.1f dB from the port)"
            " | I %.3f mV  Q %.3f mV  gain port->IF %.1f / %.1f dB  imb %.2f dB  I-Q %.1f deg" % (
                flo / 1e6, fif / 1e6, ar * 1e6, vav * 1e6, am * 1e6, 20 * math.log10(am / vav),
                ai * 1e3, aq * 1e3, 20 * math.log10(ai / vav), 20 * math.log10(aq / vav), 20 * math.log10(ai / aq),
                (pi_ - pq + 180) % 360 - 180))


def main():
    jobs = [a.split(":") for a in sys.argv[1:]] or [["tt", "0", "0", "2.09"], ["ss", "3", "1", "1.43"], ["ff", "0", "0", "1.52"]]
    os.makedirs(OUT, exist_ok=True)
    decks = [deck(c, int(b), int(i), float(v)) for c, b, i, v in jobs]
    with ThreadPoolExecutor(len(decks)) as ex:
        outs = list(ex.map(lambda d: NG(d[1], "rxpex_" + d[0], timeout=200000), decks))
    for (tag, _), out in zip(decks, outs):
        print("== " + tag)
        print("\n".join(l for l in out.splitlines() if l.startswith("RES") or "rror" in l))
        print(analyse(tag), flush=True)


if __name__ == "__main__":
    main()
