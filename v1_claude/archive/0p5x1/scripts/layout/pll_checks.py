"""Closed-loop PLL checks on the schematic tb_pll with the VCO and refbuf on their own VDDV:
  ff      FF / -20 C / 3.465 V lock (from VCTRL 1.7 V)
  seq_v   VDD first, VDDV ramps up at 3 us (all nodes from 0 V)
  seq_d   VDDV first, VDD ramps up at 3 us
Sequencing: the supply currents while the other domain is off (cross-domain back-powering) and
the lock after both are up.
usage: pll_checks.py run [case ...] | pll_checks.py ana [case ...]"""
import os, re, sys, numpy as np
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))
import run
OUT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "sim", "pll_checks"))
CASES = {"ff": dict(corner=("ff", "res_ff", "mimcap_ff"), temp=-20, v=3.465, tstop=5e-6),
         "seq_v": dict(seq=(0, 3e-6), tstop=10e-6), "seq_d": dict(seq=(3e-6, 0), tstop=10e-6)}


def deck(name, src):
    c = CASES[name]
    s = src
    for a in ("XVCO vctrl b0 b1 nb l1p l1n l2p l2n l3p l3n l4p l4n ckr vr vdd 0 vco_ring4", "XRB refin refck vdd 0 refbuf"):
        assert a in s, a
        s = s.replace(a, a.replace(" vdd 0 ", " vddv 0 "))
    v = c.get("v", 3.3)
    if "seq" in c:
        td, tdv = c["seq"]
        s = s.replace("VDD vdd 0 3.3", "VDD vdd 0 pwl(0 0 %g 0 %g %g)\nVDDV vddv 0 pwl(0 0 %g 0 %g %g)"
                      % (td, td + 100e-9, v, tdv, tdv + 100e-9, v))
        s = re.sub(r"^\.ic .*$", "", s, flags=re.M)          # everything starts at 0 V
    else:
        s = s.replace("VDD vdd 0 3.3", "VDD vdd 0 %g\nVDDV vddv 0 %g" % (v, v))
    if "corner" in c:
        for t, n in zip(("typical", "res_typical", "mimcap_typical"), c["corner"]):
            s = re.sub(r"(sm141064\.ngspice) %s$" % t, r"\1 " + n, s, flags=re.M)
        s = s.replace(".option method=gear", ".temp %g\n.option method=gear" % c["temp"])
    s = re.sub(r"save .*\ntran 5p 4u 0 5p uic\nwrdata tb_pll_vctrl v\(vctrl\)",
               "save v(vctrl) v(fb) v(refck) v(fs) v(vdd) v(vddv) i(VDD) i(VDDV)\ntran 5p %g 0 5p uic\n"
               "wrdata %s/%s_w v(vctrl) v(fs) i(VDD) i(VDDV) v(vdd) v(vddv)" % (c["tstop"], OUT, name), s)
    t1 = c["tstop"] - 0.5e-6
    s = s.replace("from=3.5u to=4u", "from=%gu to=%gu" % (t1 * 1e6, c["tstop"] * 1e6))
    s = s.replace("rise=25", "rise=%d" % int(t1 * 16.368e6 - 35)).replace("rise=55", "rise=%d" % int(t1 * 16.368e6 - 5))
    s = s.replace("rise=60", "rise=%d" % int(t1 * 16.368e6))
    assert "wrdata %s/%s_w" % (OUT, name) in s
    return s


def ana(name):
    c = CASES[name]
    d = np.loadtxt(os.path.join(OUT, name + "_w"))
    t, vc, fs, idd, iddv = d[:, 0], d[:, 1], d[:, 3], -d[:, 5], -d[:, 7]
    # lock: VCTRL within 10 mV of its final mean from then on
    m = t > c["tstop"] - 0.5e-6
    vend = vc[m].mean()
    off = np.where(abs(vc - vend) > 0.01)[0]
    tl = t[off[-1]] if len(off) else 0
    k = np.where((fs[:-1] < 1.65) & (fs[1:] >= 1.65) & (t[:-1] > c["tstop"] - 1e-6))[0]
    ffs = (len(k) - 1) / (t[k[-1]] - t[k[0]])
    r = "%-6s VCTRL %.4f V (pp %.1f mV), locked from %.2f us, fFS %.4f MHz (fLO %.3f MHz)" % (
        name, vend, 1e3 * np.ptp(vc[m]), tl * 1e6, ffs / 1e6, 96 * ffs / 1e6)
    if "seq" in c:
        td, tdv = c["seq"]
        t_on = max(td, tdv)
        w = (t > 0.5e-6) & (t < t_on - 0.1e-6)
        r += " | domain off (0.5-%.1f us): I(VDD) %.3f mA, I(VDDV) %.3f mA (max |I| %.3f / %.3f mA)" % (
            (t_on - 0.1e-6) * 1e6, 1e3 * idd[w].mean(), 1e3 * iddv[w].mean(), 1e3 * abs(idd[w]).max(), 1e3 * abs(iddv[w]).max())
    r += " | end I(VDD) %.2f mA, I(VDDV) %.2f mA" % (1e3 * idd[m].mean(), 1e3 * iddv[m].mean())
    return r


if __name__ == "__main__":
    cmd, names = sys.argv[1], sys.argv[2:] or list(CASES)
    os.makedirs(OUT, exist_ok=True)
    if cmd == "run":
        src = open(run.netlist("tb_pll")).read()     # once: parallel xschem netlisting races
        from concurrent.futures import ThreadPoolExecutor
        with ThreadPoolExecutor(len(names)) as ex:
            for n, o in zip(names, ex.map(lambda n: run.ngspice(deck(n, src), "chk_" + n, timeout=10 * 3600), names)):
                print(n, [l for l in o.splitlines() if l.startswith("RES")] or o[-300:], flush=True)
    for n in names:
        try: print(ana(n), flush=True)
        except Exception as e: print(n, "ana failed", e)
