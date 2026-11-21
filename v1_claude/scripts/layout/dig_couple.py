"""Digital outputs -> RF input: how much 1575.42 MHz the I/Q data pads (gf180mcu_fd_io__bi_24t,
SL = 1, as wired in chip_core.sv) put on their bond wire and on the on-die DVSS when they send
random data at 16.368 MHz, and what that gives at RFIN for a range of coupling assumptions.
One pad (PDK spice netlist), the DVDD / DVSS bond wires (3 pads each), 100 pF ring capacitance, load.
  case: load behind the bond wire  (c5 = 5 pF, c15 = 15 pF, r100 = 100 ohm + 5 pF, r330 = 330 ohm + 5 pF)
        sdo5_c15 / sdo5_c30 / sdo10_c30: the SDO pad (same cell and wiring) with random data at 5 / 10 Mbit/s
usage: dig_couple.py run [case ...] | dig_couple.py ana [case ...]"""
import os, re, sys, subprocess, random
import numpy as np
ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
OUT = os.path.join(ROOT, "sim", "digc")
PDK = os.path.expanduser("~/pdk/gf180mcuD")
FS = 16.368e6; FRF = 1575.42e6; BW = 2.046e6
CASES = {"c5": (0, 5e-12), "c15": (0, 15e-12), "r100": (100, 5e-12), "r330": (330, 5e-12),
         "sdo5_c15": (0, 15e-12, 5e6, 20.3e-6), "sdo5_c30": (0, 30e-12, 5e6, 20.3e-6), "sdo10_c30": (0, 30e-12, 10e6, 10.3e-6)}
TEND = 2.3e-6; T0 = 0.3e-6; DT = 10e-12


def rate(case):
    """-> (bit rate, end time)"""
    return CASES[case][2:] or (FS, TEND)


def deck(case):
    rs, cl = CASES[case][:2]; fs, tend = rate(case)
    io = open(PDK + "/libs.ref/gf180mcu_fd_io/spice/gf180mcu_fd_io.spice").read()
    io = re.sub(r"(ppolyf_u[^\n]*?) m=1\.0 r=\S+", r"\1", io)
    rnd = random.Random(7); pw = ["0 0"]; b = 0; T = 1 / fs
    for k in range(int(tend * fs) + 2):
        nb = rnd.getrandbits(1)
        if nb != b:
            pw.append("%.6e %g %.6e %g" % (k * T, 3.3 * b, k * T + 0.1e-9, 3.3 * nb)); b = nb
    t = """* digital output pad -> 1575 MHz content
.include %s/libs.tech/ngspice/design.ngspice
.lib %s/libs.tech/ngspice/sm141064.ngspice typical
.lib %s/libs.tech/ngspice/sm141064.ngspice res_typical
.lib %s/libs.tech/ngspice/sm141064.ngspice diode_typical
.lib %s/libs.tech/ngspice/sm141064.ngspice moscap_typical
%s
VD dvp 0 3.3
LD dvp dv1 0.5n
RD dv1 dvdd 0.1
LS dvss ds1 0.5n
RS ds1 0 0.1
VC cvp 0 3.3
LC cvp cv1 1.5n
RC cv1 vdd 0.2
LG vss cg1 1.5n
RG cg1 0 0.2
* DVDD-DVSS capacitance of the pad ring (MOS capacitors of the pad cells, about 16 pF per cell) and
* the loss of the bond wires (the PDK supply-pad cells do not start in ngspice)
CDEC dvdd dvss 100p
RPD dvp dv1 150
RPS dvss ds1 150
RPC cvp cv1 300
RPG vss cg1 300
RPB pad pb1 300
CSUB dvss 0 1p
CSUBC vss 0 2p
CVD vdd vss 20p
VA a 0 pwl(%s)
XP a vss dvdd dvss vss vdd pad vss vss vdd vdd vss y gf180mcu_fd_io__bi_24t
LB pad pb1 1.5n
RB pb1 pin 0.15
CPIN pin 0 0.3p
%s
CL out 0 %g
.option method=gear reltol=1e-3
.control
set num_threads=1
save v(pad) v(out) v(dvss) v(dvdd) LB#branch LS#branch LD#branch v(vss)
tran %g %g 0 %g
linearize
wrdata %s_out v(pad) v(out) v(dvss) v(dvdd) LB#branch LS#branch LD#branch v(vss)
.endc
.end
""" % (PDK, PDK, PDK, PDK, PDK, io, " ".join(pw), ("RSER pin out %g" % rs) if rs else "VSER pin out 0", cl, DT, tend, DT, case)
    return t


def run(cases):
    for c in cases:
        open(os.path.join(OUT, c + ".spice"), "w").write(deck(c))
        for f in (c + ".end", c + "_out"):
            if os.path.exists(os.path.join(OUT, f)):
                os.remove(os.path.join(OUT, f))
        subprocess.Popen(["nohup", "sh", "-c", "ngspice -b %s.spice > %s.log 2>&1; date > %s.end" % ((c,) * 3)], cwd=OUT,
                         stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, start_new_session=True)
        print("started", c)


def band(t, v):
    """rms in BW around FRF from the smooth part of the spectrum (1555-1595 MHz without the
    lines at the multiples of FS) and the amplitude of the nearest clock lines"""
    m = t >= T0; v = v[m] - v[m].mean(); n = len(v); dt = t[1] - t[0]
    V = np.fft.rfft(v * np.hanning(n)); f = np.fft.rfftfreq(n, dt)
    psd = 2 * np.abs(V) ** 2 * dt / np.sum(np.hanning(n) ** 2)            # V^2/Hz one sided
    k = (f > FRF - 20e6) & (f < FRF + 20e6)
    line = np.zeros(len(f), bool)
    for h in (95, 96, 97, 98):
        line |= abs(f - h * FS) < 1.5e6
    cont = np.sqrt(np.median(psd[k & ~line]) / np.log(2) * BW)             # median -> mean of an exponential distribution
    df = f[1] - f[0]
    l96 = np.sqrt(psd[abs(f - 96 * FS) < 1.5e6].sum() * df)
    return cont, l96


def ana(cases):
    w = 2 * np.pi * FRF
    print("thermal noise of the 50 ohm source in %.3f MHz: emf %.2f uV rms (%.2f uV at a matched input)" % (BW / 1e6, np.sqrt(4 * 4.14e-21 * BW * 50) * 1e6, np.sqrt(4.14e-21 * BW * 50) * 1e6))
    for c in cases:
        d = np.loadtxt(os.path.join(OUT, c + "_out")); t = d[:, 0]
        s = {n: d[:, 2 * k + 1] for k, n in enumerate(["pad", "out", "dvss", "dvdd", "ilb", "ils", "ild", "vss"])}
        m = t >= T0; x = s["pad"][m]; tt = t[m]
        # 10-90 % edge times of the pad
        up = []; dn = []
        lo, hi = 0.33, 2.97
        i = 0
        a = np.where((x[:-1] < lo) & (x[1:] >= lo))[0]
        for i in a:
            j = np.where(x[i:i + 3000] >= hi)[0]
            if len(j):
                up.append(j[0] * DT)
        a = np.where((x[:-1] > hi) & (x[1:] <= hi))[0]
        for i in a:
            j = np.where(x[i:i + 3000] <= lo)[0]
            if len(j):
                dn.append(j[0] * DT)
        print("== %s  (series %g ohm, load %g pF, %g Mbit/s)  pad edges 10-90 %%: rise %.2f ns, fall %.2f ns; DVSS bounce %.0f mV pp, DVDD %.0f mV pp" % (
            c, CASES[c][0], CASES[c][1] * 1e12, rate(c)[0] / 1e6, np.median(up) * 1e9, np.median(dn) * 1e9, np.ptp(s["dvss"][m]) * 1e3, np.ptp(s["dvdd"][m]) * 1e3))
        r = {}
        for n in ("pad", "dvss", "dvdd", "ilb", "ils", "vss"):
            r[n] = band(t, s[n])
        print("   at %.2f MHz in %.3f MHz (one pad; x2 for the four data pads):" % (FRF / 1e6, BW / 1e6))
        print("     pad voltage %.2f uV, bond-wire current %.3f uA, DVSS bond current %.3f uA, on-die DVSS %.2f uV, DVDD %.2f uV, core VSS %.3f uV" % (
            r["pad"][0] * 1e6, r["ilb"][0] * 1e6, r["ils"][0] * 1e6, r["dvss"][0] * 1e6, r["dvdd"][0] * 1e6, r["vss"][0] * 1e6))
        print("     clock line 96 x 16.368 MHz = LO (falls at DC after the mixer): pad %.1f uV, bond current %.2f uA, DVSS %.1f uV" % (
            r["pad"][1] * 1e6, r["ilb"][1] * 1e6, r["dvss"][1] * 1e6))
        for M in (3e-12, 20e-12, 60e-12):
            print("     magnetic, M = %2.0f pH to the RFIN wire: emf %.4f uV (4 pads %.4f uV)" % (M * 1e12, w * M * r["ilb"][0] * 1e6, 2 * w * M * r["ilb"][0] * 1e6))
        for iso in (20, 40):
            print("     DVSS -> analog ground with %d dB isolation: %.4f uV (4 pads %.4f uV)" % (iso, r["dvss"][0] * 1e6 * 10 ** (-iso / 20), 2 * r["dvss"][0] * 1e6 * 10 ** (-iso / 20)))


if __name__ == "__main__":
    cs = sys.argv[2:] or list(CASES)
    run(cs) if sys.argv[1] == "run" else ana(cs)
