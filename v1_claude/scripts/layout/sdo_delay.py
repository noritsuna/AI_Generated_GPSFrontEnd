"""SPI readback: delay from the falling edge of SCLK (at the pad) to SDO at 3.3 V.
The timing libraries of the standard cells and pads are for 4.5-5.5 V, so the STA of the chip does not
cover the 3.3 V supply. This runs the worst STA path of chip/librelane/runs/RUN_2026-11-14_16-56-53
(max_ss_125C_4v50, endpoint bidir_PAD[5]) at transistor level with the PDK SPICE netlists:
  clk_pad (in_s) -> clkbuf_16 x 2 -> _207_ dffnrnq_1 (cnt[0]) -> buf_4 -> mux4_1 S0 -> mux2_2 -> nand2_2
  -> oai32_2 -> buf_1 -> buf_2 x 3 -> buf_4 -> bidir[5].pad (bi_24t, SL = 1) -> bond wire -> load
Every net carries the capacitance of the STA report (wire + all pins), and the next cell of the path is
connected as well, so its input capacitance is counted twice (pessimistic). cnt[0] toggles on every
falling edge, so both SDO edges are measured.
usage: sdo_delay.py run | sdo_delay.py ana"""
import os, re, sys, subprocess
import numpy as np
ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
OUT = os.path.join(ROOT, "sim", "sdo")
PDK = os.path.expanduser("~/pdk/gf180mcuD")
# name: (model corner, temperature, supply)
CORNERS = {"tt_27_3v3": ("typical", 27, 3.3), "ss_85_3v135": ("ss", 85, 3.135), "ss_125_3v135": ("ss", 125, 3.135),
           "ss_125_3v0": ("ss", 125, 3.0), "ff_m40_3v465": ("ff", -40, 3.465), "ss_125_4v5": ("ss", 125, 4.5)}
LOADS = {"c5": 5e-12, "c15": 15e-12, "c30": 30e-12}
TCK = 200e-9; TEND = 900e-9; DT = 20e-12; TR = 2e-9


def deck(cn, ln):
    lib, temp, vdd = CORNERS[cn]
    io = open(PDK + "/libs.ref/gf180mcu_fd_io/spice/gf180mcu_fd_io.spice").read()
    io = re.sub(r"(ppolyf_u[^\n]*?) m=1\.0 r=\S+", r"\1", io)
    sc = "gf180mcu_fd_sc_mcu7t5v0__"
    return """* SCLK pad -> SDO pad at %(vdd)g V, %(lib)s, %(temp)g C
.include %(pdk)s/libs.tech/ngspice/design.ngspice
.lib %(pdk)s/libs.tech/ngspice/sm141064.ngspice %(lib)s
.lib %(pdk)s/libs.tech/ngspice/sm141064.ngspice res_typical
.lib %(pdk)s/libs.tech/ngspice/sm141064.ngspice diode_typical
.lib %(pdk)s/libs.tech/ngspice/sm141064.ngspice moscap_typical
.include %(pdk)s/libs.ref/gf180mcu_fd_sc_mcu7t5v0/spice/gf180mcu_fd_sc_mcu7t5v0.spice
%(io)s
.temp %(temp)g
VD vdd 0 %(vdd)g
VCK sclk 0 pulse(0 %(vdd)g 50n %(tr)g %(tr)g %(th)g %(tck)g)
VRN rn 0 pwl(0 0 20n 0 21n %(vdd)g)
XCK vdd 0 sclk 0 0 vdd 0 ck0 gf180mcu_fd_io__in_s
C0 ck0 0 0.0777p
XB0 ck0 ck1 vdd vdd 0 0 %(sc)sclkbuf_16
C1 ck1 0 0.1183p
XB1 ck1 ck2 vdd vdd 0 0 %(sc)sclkbuf_16
C2 ck2 0 0.0460p
* cnt[0]: toggles on every falling edge
BD d 0 v = %(vdd)g - v(q)
XFF d rn ck2 q vdd vdd 0 0 %(sc)sdffnrnq_1
C3 q 0 0.0622p
XG1 q n1 vdd vdd 0 0 %(sc)sbuf_4
C4 n1 0 0.1725p
XG2 vdd 0 0 0 n1 0 n2 vdd vdd 0 0 %(sc)smux4_1
C5 n2 0 0.0261p
XG3 n2 0 0 n3 vdd vdd 0 0 %(sc)smux2_2
C6 n3 0 0.0202p
XG4 vdd n3 n4 vdd vdd 0 0 %(sc)snand2_2
C7 n4 0 0.0149p
XG5 vdd 0 0 n4 0 n5 vdd vdd 0 0 %(sc)soai32_2
C8 n5 0 0.0084p
XW5 n5 n6 vdd vdd 0 0 %(sc)sbuf_1
C9 n6 0 0.0152p
XW4 n6 n7 vdd vdd 0 0 %(sc)sbuf_2
C10 n7 0 0.0144p
XW3 n7 n8 vdd vdd 0 0 %(sc)sbuf_2
C11 n8 0 0.0155p
XW2 n8 n9 vdd vdd 0 0 %(sc)sbuf_2
C12 n9 0 0.0125p
XW1 n9 a vdd vdd 0 0 %(sc)sbuf_4
C13 a 0 0.0617p
* SDO pad as in chip_core.sv while CS_N is low: OE = 1, IE = 0, PD = 1, PU = 0, SL = 1, CS = 0
XP a 0 vdd 0 0 vdd pad vdd 0 vdd vdd 0 y gf180mcu_fd_io__bi_24t
LB pad pb1 1.5n
RB pb1 out 0.15
RPB pad pb1 300
CL out 0 %(cl)g
.option method=gear reltol=1e-3
.control
set num_threads=1
save v(sclk) v(ck2) v(q) v(a) v(pad) v(out)
tran %(dt)g %(tend)g 0 %(dt)g
linearize
wrdata %(name)s_out v(sclk) v(ck2) v(q) v(a) v(pad) v(out)
.endc
.end
""" % dict(pdk=PDK, lib=lib, temp=temp, vdd=vdd, io=io, sc=sc.replace("%", "%%") + "", tr=TR, th=TCK / 2 - TR, tck=TCK,
           cl=LOADS[ln], dt=DT, tend=TEND, name=cn + "_" + ln)


def run():
    ps = []
    for cn in CORNERS:
        for ln in LOADS:
            n = cn + "_" + ln
            open(os.path.join(OUT, n + ".spice"), "w").write(deck(cn, ln).replace("__s", "__"))
            ps.append(subprocess.Popen("ngspice -b %s.spice > %s.log 2>&1" % (n, n), shell=True, cwd=OUT))
    for p in ps:
        p.wait()


def cross(t, v, lev, t0, rising):
    """first time after t0 where v crosses lev in the given direction"""
    k = np.where((t[1:] > t0) & ((v[:-1] < lev) & (v[1:] >= lev) if rising else (v[:-1] > lev) & (v[1:] <= lev)))[0]
    if not len(k):
        return np.nan
    k = k[0]
    return t[k] + (lev - v[k]) / (v[k + 1] - v[k]) * (t[k + 1] - t[k])


def ana():
    print("delay from SCLK falling (50 %) at the pad; ns.  q = flop output, a = pad input, 50 = SDO at 50 %,")
    print("vih/vil = SDO at 0.7 VDD (rising) / 0.3 VDD (falling)")
    print("%-14s %-4s | %6s %6s %6s %6s | %6s %6s %6s %6s" % ("corner", "load", "q r", "a r", "50 r", "vih", "q f", "a f", "50 f", "vil"))
    for cn in CORNERS:
        vdd = CORNERS[cn][2]
        for ln in LOADS:
            d = np.loadtxt(os.path.join(OUT, cn + "_" + ln + "_out")); t = d[:, 0]
            s = {n: d[:, 2 * k + 1] for k, n in enumerate(["sclk", "ck2", "q", "a", "pad", "out"])}
            r = {}
            for k in (1, 2, 3):                       # falling edges of SCLK (the first one sets the flop)
                tf = cross(t, s["sclk"], vdd / 2, 50e-9 + k * TCK - TCK / 2 - 1e-9, False)
                # after this edge SDO falls when q rises (the path inverts once)
                up = s["q"][np.searchsorted(t, tf + TCK / 2 - 5e-9)] > vdd / 2
                key = "f" if up else "r"
                r[key] = [(cross(t, s["q"], vdd / 2, tf, up) - tf) * 1e9, (cross(t, s["a"], vdd / 2, tf, not up) - tf) * 1e9,
                          (cross(t, s["out"], vdd / 2, tf, not up) - tf) * 1e9,
                          (cross(t, s["out"], (0.3 if up else 0.7) * vdd, tf, not up) - tf) * 1e9]
            print("%-14s %-4s | %6.2f %6.2f %6.2f %6.2f | %6.2f %6.2f %6.2f %6.2f" % ((cn, ln) + tuple(r["r"]) + tuple(r["f"])))


if __name__ == "__main__":
    os.makedirs(OUT, exist_ok=True)
    run() if sys.argv[1] == "run" else ana()
