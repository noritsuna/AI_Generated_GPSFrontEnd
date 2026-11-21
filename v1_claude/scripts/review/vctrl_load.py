"""Review A-2: what an external load on the VCTRL monitor pin does to the PLL.
Closed-loop schematic PLL (tb_pll) with the macro's 10 kohm monitor resistor (RMON), the analog pad
(1.24 pF) and an external load (probe / meter / cable) on the pin.  Reports the settled VCTRL, the
REF/FB phase error, the VCTRL ripple at fref and the LO reference sidebands (Hann, 9 ref periods).
usage: vctrl_load.py [TSTOP=5e-6]"""
import os, sys, re
from concurrent.futures import ThreadPoolExecutor
import numpy as np
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))
os.environ.setdefault("PDK", "gf180mcuD"); os.environ.setdefault("PDK_ROOT", os.path.expanduser("~/pdk"))
import run
NG = (lambda *a, **k: "") if os.environ.get("ANA") else run.ngspice   # ANA=1: analyse the saved waveforms only

FR = 16.368e6
CASES = [("open", ""),                                              # no monitor branch at all (as verified so far)
         ("pad", "RMON vctrl vmon 10k\nCPAD vmon 0 1.24p\n"),
         ("probe10M", "RMON vctrl vmon 10k\nCPAD vmon 0 1.24p\nRL vmon 0 10meg\nCL vmon 0 15p\n"),      # 10x scope probe / DMM
         ("probe1M", "RMON vctrl vmon 10k\nCPAD vmon 0 1.24p\nRL vmon 0 1meg\nCL vmon 0 20p\n"),        # scope input, 1x
         ("leak100n", "RMON vctrl vmon 10k\nCPAD vmon 0 1.24p\nIL vmon 0 100n\n"),                      # leakage 100 nA (hot pad + dirty board)
         ("c100p", "RMON vctrl vmon 10k\nCPAD vmon 0 1.24p\nCL vmon 0 100p\n"),                         # coax / long trace
         ("adc", "RMON vctrl vmon 10k\nCPAD vmon 0 1.24p\nCL vmon 0 5p\nSW vmon sh smp 0 swm\nCSH sh 0 10p\nRSH sh 0 100k\n"
                 "VSMP smp 0 pulse(0 1 2.0u 5n 5n 0.3u 1u)\n.model swm sw(vt=0.5 ron=500 roff=1e12)\n")]   # SAR ADC sampling cap 10 pF, discharged between samples


def deck(base, tag, load, tstop):
    t = base.replace("VICP2 icp2 0 0\n", "VICP2 icp2 0 0\n" + load)
    assert load in t
    t = t.replace("save v(vctrl) ", "save v(vctrl) v(l1n) %s" % ("v(vmon) " if load else ""))
    t = t.replace("tran 5p 4u 0 5p uic", "tran 5p %g 0 5p uic" % tstop)
    t = t.replace("wrdata tb_pll_vctrl v(vctrl)", "wrdata review/vcl_%s v(vctrl) v(l1p) v(l1n)" % tag)
    t, k = re.subn(r"^meas tran .*\n|^let .*\n|^echo RES.*\n", "", t, flags=re.M)
    return t


def ana(tag):
    d = np.loadtxt(os.path.join(run.SIM, "review", "vcl_%s" % tag))
    t = d[:, 0]; vc = d[:, 1]; lo = d[:, 3] - d[:, 5]
    T = 1 / FR
    out = []
    for t1 in (t[-1] - 9 * T, t[-1]):
        t0 = t1 - 9 * T
        tt = np.linspace(t0, t1, 9 * 60000, endpoint=False)
        w = np.hanning(len(tt)); w /= w.mean()
        yv = np.interp(tt, t, vc); yl = np.interp(tt, t, lo)
        # carrier: strongest line near 96 fref
        fs = np.linspace(95.5 * FR, 96.5 * FR, 401)
        c = [abs(np.mean(w * yl * np.exp(-2j * np.pi * f * tt))) for f in fs]
        fc = fs[int(np.argmax(c))]; car = max(c)
        sb = [20 * np.log10(abs(np.mean(w * yl * np.exp(-2j * np.pi * (fc + s * FR) * tt))) / car) for s in (-1, 1)]
        a1 = 2 * abs(np.mean(w * (yv - yv.mean()) * np.exp(-2j * np.pi * FR * tt)))
        out.append("VCTRL %.4f V (pp %.2f mV, fref component %.3f mV)  fLO %.3f MHz  sidebands %.1f / %.1f dBc" % (
            yv.mean(), 1e3 * np.ptp(yv), a1 * 1e3, fc / 1e6, sb[0], sb[1]))
    return out


def main():
    tstop = float(sys.argv[1]) if len(sys.argv) > 1 else 5e-6
    os.makedirs(os.path.join(run.SIM, "review"), exist_ok=True)
    base = open(run.netlist("tb_pll")).read()
    decks = [(tag, deck(base, tag, load, tstop)) for tag, load in CASES]
    with ThreadPoolExecutor(len(decks)) as ex:
        outs = list(ex.map(lambda d: NG(d[1], "rev_vcl_" + d[0], timeout=200000), decks))
    for (tag, _), out in zip(decks, outs):
        print("== " + tag, " ".join(l for l in out.splitlines() if "rror" in l))
        for l in ana(tag):
            print("   " + l)
        sys.stdout.flush()


if __name__ == "__main__":
    main()
