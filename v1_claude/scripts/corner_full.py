"""Full-chip transient (tb_full, schematic, ngspice) at the corners, without input noise so that the
tone gain and the I/Q phase can be read: the chip starts in its reset state (all SPI bits 0) and
the SPI word is written at 2.5 us, so 0-5 us also shows the behaviour before any SPI write.
  tt  typical, 27 C, 3.3 V,   B=00, ICP2=0
  ss  ss, 85 C, 3.135 V,      B=11, ICP2=1
  ff  ff, -20 C, 3.465 V,     B=00, ICP2=0
usage: corner_full.py run [case ...]   (detached, results in sim/full_corner/)
       corner_full.py ana [case ...]"""
import json, os, re, subprocess, sys
import numpy as np
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import gen_tb

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
OUT = os.path.abspath(os.path.join(ROOT, "sim", "full_corner"))
CASES = {"tt": dict(lib="typical", temp=27, v=3.3, band=0, icp2=0, tstop=12e-6),
         "ss": dict(lib="ss", temp=85, v=3.135, band=3, icp2=1, tstop=14e-6),
         "ff": dict(lib="ff", temp=-20, v=3.465, band=0, icp2=0, tstop=12e-6)}
SIG = ["vctrl", "clkout", "isign", "imag", "qsign", "qmag", "ifI", "ifQ", "mixI", "mixQ", "rfin", "lna", "idd",
       "l1", "l2", "b0", "b1"]
FR = 16.368e6; FLO = 96 * FR; FRF = 1575.42e6; FIF = FRF - FLO


def deck(case):
    c = CASES[case]
    t = open(os.path.join(ROOT, "sim", "netlist", "tb_full.spice")).read()
    t = re.sub(r"^VDD vdd 0 3\.3$", "VDD vdd 0 %g" % c["v"], t, flags=re.M)
    t = re.sub(r"^VRNP sp sp0 .*$", "VRNP sp sp0 dc 0", t, flags=re.M)
    sclk, sdi, csn = gen_tb.spi_frames([(2.5e-6, gen_tb.gain_word(1, 1, 1, band=c["band"], icp2=c["icp2"]))], vh=c["v"])
    for n, s in (("VSCLK sclk", sclk), ("VSDI sdi", sdi), ("VCSN csn", csn)):
        t, k = re.subn(r"^%s 0 pwl\(.*(?:\n\+.*)*$" % n, "%s 0 %s" % (n, s), t, flags=re.M)
        assert k == 1, n
    if c["lib"] != "typical":
        t, k = re.subn(r"(sm141064\.ngspice) (res_|mimcap_)?typical", lambda m: "%s %s%s" % (m.group(1), m.group(2) or "", c["lib"]), t)
        assert k == 3
    t = t.replace(".option method=gear", ".temp %g\n.option method=gear" % c["temp"])
    ctl = """.control
set num_threads=1
save v(vctrl) v(clkout) v(isign) v(imag) v(qsign) v(qmag) v(xdut.aip) v(xdut.ain) v(xdut.aqp) v(xdut.aqn) v(xdut.mip) v(xdut.min) v(xdut.mqp) v(xdut.mqn) v(rfin) v(xdut.rfp) v(xdut.rfn) i(VDD) v(xdut.l1p) v(xdut.l1n) v(xdut.l2p) v(xdut.l2n) v(xdut.b0) v(xdut.b1)
tran 5p %g 0 5p uic
wrdata %s_out v(vctrl) v(clkout) v(isign) v(imag) v(qsign) v(qmag) v(xdut.aip,xdut.ain) v(xdut.aqp,xdut.aqn) v(xdut.mip,xdut.min) v(xdut.mqp,xdut.mqn) v(rfin) v(xdut.rfp,xdut.rfn) i(VDD) v(xdut.l1p,xdut.l1n) v(xdut.l2p,xdut.l2n) v(xdut.b0) v(xdut.b1)
.endc""" % (c["tstop"], case)
    t, k = re.subn(r"^\.control.*?^\.endc", lambda m: ctl, t, flags=re.M | re.S)
    assert k == 1
    return t


def run(cases):
    os.makedirs(OUT, exist_ok=True)
    for case in cases:
        open(os.path.join(OUT, case + ".spice"), "w").write(deck(case))
        for f in (case + ".end", case + "_out"):
            if os.path.exists(os.path.join(OUT, f)):
                os.remove(os.path.join(OUT, f))
        subprocess.Popen(["nohup", "sh", "-c", "date > %s.start; ngspice -b %s.spice > %s.log 2>&1; date > %s.end" % ((case,) * 4)],
                         cwd=OUT, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, start_new_session=True)
        print("started", case, "-> progress: tr '\\r' '\\n' < sim/full_corner/%s.log | grep Reference | tail -1" % case)


def tone(t, v, f, a, b, dt):
    n = int((b - a) * f)
    tu = np.arange(a, a + n / f, dt)
    return 2 * np.mean(np.interp(tu, t, v) * np.exp(-2j * np.pi * f * tu))


def ana(case):
    c = CASES[case]
    d = np.loadtxt(os.path.join(OUT, case + "_out"))
    t = d[:, 0]; s = {n: d[:, 2 * k + 1] for k, n in enumerate(SIG)}
    te = t[-1]; r = dict(case=case, sim_end_us=round(te * 1e6, 3))
    r["vctrl"] = {"%g" % x: round(float(s["vctrl"][(t >= x * 1e-6 - 0.1e-6) & (t < x * 1e-6)].mean()), 4)
                  for x in (0.5, 1, 1.5, 2, 2.5, 3, 4, 5, 5.5, 6, 7, 8, 10, 12, 14) if x * 1e-6 <= te}
    r["vctrl_max"] = round(float(s["vctrl"].max()), 3)
    th = c["v"] / 2
    clk = s["clkout"]; e = t[1:][(clk[:-1] < th) & (clk[1:] >= th)]
    for name, a, b in (("reset", 1.5e-6, 2.5e-6), ("final", te - 4e-6, te)):
        m = (t >= a) & (t < b); ee = e[(e >= a) & (e < b)]
        q = dict(window_us=[round(a * 1e6, 2), round(b * 1e6, 2)], IDD_mA=round(float(-s["idd"][m].mean() * 1e3), 2),
                 vctrl_pp_mV=round(float(np.ptp(s["vctrl"][m]) * 1e3), 2))
        if len(ee) > 2:
            q["CLKOUT_MHz"] = round(float((len(ee) - 1) / (ee[-1] - ee[0]) / 1e6), 5)
        l1 = tone(t, s["l1"], FLO, b - 20e-9, b, 0.2e-12); l2 = tone(t, s["l2"], FLO, b - 20e-9, b, 0.2e-12)
        q["LO_V"] = [round(abs(l1), 3), round(abs(l2), 3)]; q["LO_l2_minus_l1_deg"] = round(float(np.degrees(np.angle(l2 / l1))), 2)
        if name == "final":
            q["rfin_uV"] = round(abs(tone(t, s["rfin"], FRF, b - 0.5e-6, b, 5e-12)) * 1e6, 3)
            q["lna_uV"] = round(abs(tone(t, s["lna"], FRF, b - 0.5e-6, b, 5e-12)) * 1e6, 3)
            for p in ("mix", "if"):
                I = tone(t, s[p + "I"], FIF, a, b, 1e-9); Q = tone(t, s[p + "Q"], FIF, a, b, 1e-9)
                q[p + "_I_Q_mV"] = [round(abs(I) * 1e3, 4), round(abs(Q) * 1e3, 4)]
                q[p + "_Q_over_I_dB"] = round(float(20 * np.log10(abs(Q) / abs(I))), 2)
                q[p + "_Q_minus_I_deg"] = round(float(np.degrees(np.angle(Q / I))), 2)
            q["conv_gain_dB"] = round(float(20 * np.log10(q["mix_I_Q_mV"][0] * 1e3 / q["rfin_uV"])), 2)
            q["if_gain_dB"] = round(float(20 * np.log10(q["if_I_Q_mV"][0] / q["mix_I_Q_mV"][0])), 2)
            q["if_dc_mV"] = [round(float(s[k][m].mean() * 1e3), 2) for k in ("ifI", "ifQ")]
            for ch in ("i", "q"):
                sg = np.interp(ee + 25e-9, t, s[ch + "sign"]) > th; mg = np.interp(ee + 25e-9, t, s[ch + "mag"]) > th
                q[ch.upper() + "_SIGN_mean"] = round(float(np.mean(np.where(sg, 1, -1))), 3)
                q[ch.upper() + "_MAG_fraction"] = round(float(mg.mean()), 3)
        else:
            for k in ("isign", "imag", "qsign", "qmag"):
                q[k + "_mean_V"] = round(float(s[k][m].mean()), 3)
            q["B0_B1_V"] = [round(float(s["b0"][m].mean()), 2), round(float(s["b1"][m].mean()), 2)]
        r[name] = q
    r["B0_B1_end_V"] = [round(float(s["b0"][-1]), 2), round(float(s["b1"][-1]), 2)]
    json.dump(r, open(os.path.join(OUT, case + "_summary.json"), "w"), indent=1)
    print(json.dumps(r, indent=1))


if __name__ == "__main__":
    cases = sys.argv[2:] or list(CASES)
    if sys.argv[1] == "run":
        run(cases)
    else:
        for c in cases:
            ana(c)
