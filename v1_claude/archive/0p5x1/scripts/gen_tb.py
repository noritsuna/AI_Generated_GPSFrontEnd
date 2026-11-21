"""Testbench schematics (xschem) for the GNSS AFE blocks."""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from xsch import Sch
from gen_cells import LOPH

G = dict(VDD="vdd", VSS="0")
LO = {n: n.lower() for n in LOPH}


def tb_vco():
    t = Sch("tb_vco", title="tb_vco: tuning curve (fLO = 2 x ring), KVCO, quadrature error at fLO, supply current")
    t.vsrc("VDD", "vdd", "0", "3.3")
    t.vsrc("VC", "vctrl", "0", "1.5")
    t.vsrc("VB0", "b0", "0", "0")
    t.vsrc("VB1", "b1", "0", "0")
    t.sub("bias_gen", "XB", dict(NB="nb", PB="pb", **G))
    t.sub("vco_ring4", "XVCO", dict(VCTRL="vctrl", B0="b0", B1="b1", NB="nb", CK="ckr", VR="vr", **LO, **G))
    t.newrow("mixer switch gate load per phase (2 pF AC coupling in series with ~150 fF of gates)")
    for n in LO.values():
        t.cap("CL" + n, n, "0", "150f")
    t.models()
    t.code("SIM", """.option method=gear reltol=1e-4
.ic v(xvco.xcore.p4)=0 v(xvco.xcore.n4)=2
.control
set num_threads=1
let vlist = vector(9)*0.25+0.8
let k = 0
while k < 9
 let vv = vlist[k]
 alter VC dc = vv
 tran 2p 70n uic
 meas tran ta when v(l1p)=v(l1n) rise=1 td=55n
 meas tran tb when v(l1p)=v(l1n) rise=5 td=55n
 meas tran tq when v(l2p)=v(l2n) rise=1 td=55n
 meas tran ivdd avg i(VDD) from=55n to=70n
 meas tran vravg avg v(vr) from=55n to=70n
 let f = 8/(tb-ta)
 let qerr = ((tq-ta)*f/2 - floor((tq-ta)*f/2))*720 - 90
 echo RES vc=$&vv f=$&f qerr=$&qerr ivdd=$&ivdd vr=$&vravg
 let k = k + 1
end
.endc""")
    t.save()




def tb_bias():
    t = Sch("tb_bias", title="tb_bias: reference current vs temperature and VDD")
    t.vsrc("VDD", "vdd", "0", "3.3")
    t.sub("bias_gen", "XB", dict(NB="nb", PB="pb", **G))
    t.newrow("probe mirrors (unit 16u/2u NMOS, 32u/2u PMOS)")
    t.vsrc("VPN", "pn", "0", "1.65")
    t.nmos("MPRN", "pn", "nb", "0", b="0", W="16u", L="2u", nf=2)
    t.vsrc("VPP", "vdd", "pp", "1.65")
    t.pmos("MPRP", "pp", "pb", "vdd", b="vdd", W="32u", L="2u", nf=4)
    t.models()
    t.code("SIM", """.control
set num_threads=1
foreach tc -40 27 85 125
 set temp=$tc
 op
 echo RES temp=$tc in=$&@m.xmprn.m0[id] ip=$&@m.xmprp.m0[id] nb=$&v(nb) pb=$&v(pb)
end
set temp=27
dc VDD 2.8 3.6 0.2
print i(VPN)
.endc""")
    t.save()



FLO = 96 * 16.368e6
TLO = 1.0 / FLO


def lo_sources(t, vh="2.0", tr=60):
    """Ideal 8-phase ring outputs at fLO/2 (phase k at (k-1) x 45 deg, N = P + 180 deg)."""
    T = 2 * TLO * 1e12
    for n in LO.values():
        d = (int(n[1]) - 1) / 8 + (0.5 if n[2] == "n" else 0)
        t.vsrc("V" + n.upper(), n, "0", "pulse(0 %s %.3fp %dp %dp %.3fp %.3fp)" % (vh, d * T, tr, tr, T / 2 - tr, T))


def tb_mixer():
    t = Sch("tb_mixer", title="tb_mixer: conversion gain, I/Q phase (ideal 8-phase LO/2, 0-2.0 V)")
    t.vsrc("VDD", "vdd", "0", "3.3")
    t.sub("bias_gen", "XB", dict(NB="nb", PB="pb", **G))
    lo_sources(t)
    t.newrow("100-ohm differential RF port, fRF = 1575.42 MHz (GPS L1) -> IF +4.092 MHz")
    t.vsrc("VRFP", "sp", "0", "sin(0 ARF 1575.42e6 0 0 0)")
    t.vsrc("VRFN", "sn", "0", "sin(0 ARF 1575.42e6 0 0 180)")
    t.res("RSP", "sp", "rfp_s", "50")
    t.res("RSN", "sn", "rfn_s", "50")
    t.cap("CCP", "rfp_s", "rfp", "10p")
    t.cap("CCN", "rfn_s", "rfn", "10p")
    t.sub("mixer_iq", "XM", dict(RFP="rfp", RFN="rfn", **LO, NB="nb", IFIP="ifip", IFIN="ifin", IFQP="ifqp", IFQN="ifqn", **G))
    t.models()
    t.code("SIM", """.param arf=1m
.option method=gear
.control
set num_threads=1
tran 5p 0.75u 0 5p
linearize v(ifip) v(ifin) v(ifqp) v(ifqn) v(rfp) v(rfn)
let vi = v(ifip)-v(ifin)
let vq = v(ifqp)-v(ifqn)
let vrf = v(rfp)-v(rfn)
meas tran vin_pp pp vrf from=0.5u to=0.75u
meas tran ipp pp vi from=0.26u to=0.746u
meas tran qpp pp vq from=0.26u to=0.746u
meas tran ti when vi=0 rise=2
meas tran tq when vq=0 rise=2
echo RES vin_pp=$&vin_pp ipp=$&ipp qpp=$&qpp ti=$&ti tq=$&tq
wrdata tb_mixer_out vi vq
.endc""")
    t.save()


def tb_mixer_zin():
    t = Sch("tb_mixer_zin", title="tb_mixer_zin: RF input impedance (LO frozen, I and Q switches half on)")
    t.vsrc("VDD", "vdd", "0", "3.3")
    t.sub("bias_gen", "XB", dict(NB="nb", PB="pb", **G))
    for n in LO.values():
        t.vsrc("V" + n.upper(), n, "0", "2.0" if n.endswith("p") else "0")
    t.vsrc("VRF", "s", "0", "dc 0 ac 0.5")
    t.vsrc("VRFN", "sn", "0", "dc 0 ac 0.5 180")
    t.cap("CC", "s", "rfp", "10p")
    t.cap("CN", "sn", "rfn", "10p")
    t.sub("mixer_iq", "XM", dict(RFP="rfp", RFN="rfn", **LO, NB="nb", IFIP="ifip", IFIN="ifin", IFQP="ifqp", IFQN="ifqn", **G))
    t.models()
    t.code("SIM", """.control
set num_threads=1
op
echo RES itail=$&@m.xm.xmti.m0[id] vgm=$&v(xm.tI) vop=$&v(ifip) vbrf=$&v(rfp)
ac lin 3 1.55e9 1.6e9
let zin = (v(rfp)-v(rfn))/(-i(VRF))
let s11 = (zin-100)/(zin+100)
print real(zin) imag(zin) db(s11)
.endc""")
    t.save()



def tb_if():
    t = Sch("tb_if", title="tb_if: IF chain gain / bandwidth / noise for all gain codes")
    t.vsrc("VDD", "vdd", "0", "3.3")
    t.sub("bias_gen", "XB", dict(NB="nb", PB="pb", **G))
    t.vsrc("VIP", "inp", "0", "dc 2.1 ac 0.5")
    t.vsrc("VIN", "inn", "0", "dc 2.1 ac 0.5 180")
    for b in ("g1a", "g1b", "g2a", "g2b", "g3a", "g3b"):
        t.vsrc("V" + b.upper(), b, "0", "0")
    t.sub("if_chain", "XIF", dict(INP="inp", INN="inn", G1A="g1a", G1B="g1b", G2A="g2a", G2B="g2b", G3A="g3a", G3B="g3b",
                                  PB="pb", OUTP="outp", OUTN="outn", **G))
    t.newrow("ADC input load")
    t.cap("CLP", "outp", "0", "100f")
    t.cap("CLN", "outn", "0", "100f")
    t.models()
    ctl = [".control", "set num_threads=1", "op",
           "echo RES op nbif=$&v(xif.nbif) pbif=$&v(xif.pbif) ix=$&v(xif.xbif.x) vdiv=$&v(xif.xbif.vdiv) a1p=$&v(xif.a1p) f1p=$&v(xif.f1p) a2p=$&v(xif.a2p) f2p=$&v(xif.f2p) outp=$&v(outp)"]
    for k in range(4):
        ga, gb = 3.3 * (k & 1), 3.3 * (k >> 1)
        ctl += ["alter VG1A dc = %g" % ga, "alter VG1B dc = %g" % gb,
                "alter VG2A dc = %g" % ga, "alter VG2B dc = %g" % gb,
                "alter VG3A dc = %g" % ga, "alter VG3B dc = %g" % gb,
                "ac dec 40 1e4 1e9", "let g = db(v(outp)-v(outn))",
                "meas ac g4 find g at=4.092e6", "meas ac g66 find g at=6.6e6",
                "meas ac g112 find g at=11.25e6", "meas ac g164 find g at=16.368e6",
                "meas ac gmax max g", "let gm3 = gmax - 3",
                "meas ac fl when g=gm3 rise=1", "meas ac fh when g=gm3 fall=last",
                "echo RES code=%d g4=$&g4 g6.6=$&g66 g11.25=$&g112 g16.4=$&g164 gmax=$&gmax fl=$&fl fh=$&fh" % k,
                "wrdata if_ac_code%d g" % k,
                "noise v(outp,outn) VIP dec 20 1e5 1e8", "setplot noise%d" % (2 * k + 1),
                "wrdata if_noise_code%d inoise_spectrum onoise_spectrum" % k]
    ctl.append(".endc")
    t.code("SIM", "\n".join(ctl))
    t.save()



def tb_adc():
    t = Sch("tb_adc", title="tb_adc: 2-bit ADC thresholds (slow ramp) at fs = 16.368 MHz")
    t.vsrc("VDD", "vdd", "0", "3.3")
    fs = FLO / 96
    T = 1e9 / fs
    t.vsrc("VCK", "clk", "0", "pulse(0 3.3 0 0.2n 0.2n %.4fn %.4fn)" % (T / 2 - 0.2, T))
    t.vsrc("VIP", "inp", "0", "pwl(0 1.0 10u 1.4)")    # centred on the IF output CM (1.20 V)
    t.vsrc("VIN", "inn", "0", "pwl(0 1.4 10u 1.0)")
    t.sub("adc2b", "XA", dict(INP="inp", INN="inn", CLK="clk", SIGN="sign", MAG="mag", **G))
    t.cap("C1", "sign", "0", "50f")
    t.cap("C2", "mag", "0", "50f")
    t.models()
    t.code("SIM", """.control
set num_threads=1
tran 0.1n 10u
let vd = v(inp)-v(inn)
meas tran ts when v(sign)=1.65 rise=1
meas tran tm1 when v(mag)=1.65 fall=1
meas tran tm2 when v(mag)=1.65 rise=1
meas tran vs find vd at=ts
meas tran vm1 find vd at=tm1
meas tran vm2 find vd at=tm2
echo RES vth_sign=$&vs vth_mag_lo=$&vm1 vth_mag_hi=$&vm2
meas tran thp avg v(xa.thp) from=2u to=8u
meas tran thm avg v(xa.thm) from=2u to=8u
meas tran thn avg v(xa.thn) from=2u to=8u
echo RES ladder thp=$&thp thm=$&thm thn=$&thn
meas tran iavg avg i(VDD) from=2u to=8u
echo RES iavg=$&iavg
.endc""")
    t.save()



def tb_div():
    t = Sch("tb_div", title="tb_div: LO buffer + /96 divider (TSPC) at 1571.328 MHz; FS = FB = /96 = 16.368 MHz")
    t.vsrc("VDD", "vdd", "0", "3.3")
    T = 1e12 / FLO
    t.vsrc("VLO", "lo", "0", "pulse(0 2.3 0 60p 60p %.3fp %.3fp)" % (T / 2 - 60, T))
    t.sub("divbuf", "XDB", dict(IN="lo", OUT="ck", **G))
    t.sub("div96", "XDIV", dict(CK="ck", FS="fs", FB="fb", **G))
    t.cap("CFS", "fs", "0", "200f")
    t.cap("CFB", "fb", "0", "50f")
    t.models()
    t.code("SIM", """.option method=gear
.control
set num_threads=1
tran 5p 400n
meas tran f1 when v(fs)=1.65 rise=2
meas tran f2 when v(fs)=1.65 rise=5
meas tran b1 when v(fb)=1.65 rise=2
meas tran b2 when v(fb)=1.65 rise=5
wrdata tb_div_wave v(fs) v(fb)
let ffs = 3/(f2-f1)
let ffb = 3/(b2-b1)
meas tran idd avg i(VDD) from=100n to=400n
echo RES ffs=$&ffs ffb=$&ffb idd=$&idd
.endc""")
    t.save()



def tb_pfdcp():
    t = Sch("tb_pfdcp", title="tb_pfdcp: PFD + charge pump transfer (avg Icp vs phase error), Vctrl held at 1.9 V")
    t.vsrc("VDD", "vdd", "0", "3.3")
    t.sub("bias_gen", "XB", dict(NB="nb", PB="pb", **G))
    Tr = 1e9 / 16.368e6
    t.vsrc("VREF", "ref", "0", "pulse(0 3.3 10n 0.3n 0.3n %.4fn %.4fn)" % (Tr / 2 - 0.3, Tr))
    t.vsrc("VFB", "fb", "0", "pulse(0 3.3 DLYn 0.3n 0.3n %.4fn %.4fn)" % (Tr / 2 - 0.3, Tr))
    t.sub("pfd", "XP", dict(REF="ref", FB="fb", UP="up", UPB="upb", DN="dn", DNB="dnb", **G))
    t.sub("cp", "XC", dict(UPB="upb", DN="dn", DNB="dnb", PB="pb", NB="nb", HI="hi", OUT="vc", **G))
    t.vsrc("VHI", "hi", "0", "0")
    t.vsrc("VC", "vc", "0", "1.9")
    t.models()
    t.code("SIM", """.option method=gear
.control
set num_threads=1
tran 10p 400n
meas tran q integ i(VC) from=%.4fn to=%.4fn
let iavg = -q/(%.4fn)
meas tran upw when v(up)=1.65 rise=8
meas tran upf when v(up)=1.65 fall=8
echo RES dly=DLY iavg=$&iavg
.endc""" % (10 + 2 * Tr, 10 + 6 * Tr, 4 * Tr))
    t.save()



def tb_pll():
    t = Sch("tb_pll", title="tb_pll: closed-loop transistor-level PLL lock (TCXO 16.368 MHz clipped sine)")
    t.vsrc("VDD", "vdd", "0", "3.3")
    t.sub("bias_gen", "XB", dict(NB="nb", PB="pb", **G))
    t.vsrc("VREF", "refin", "0", "sin(1.65 0.4 16.368e6)")
    t.vsrc("VB0", "b0", "0", "0")
    t.vsrc("VB1", "b1", "0", "0")
    t.sub("vco_ring4", "XVCO", dict(VCTRL="vctrl", B0="b0", B1="b1", NB="nb", CK="ckr", VR="vr", **LO, **G))
    t.vsrc("VICP2", "icp2", "0", "0")
    t.sub("refbuf", "XRB", dict(IN="refin", OUT="refck", **G))
    t.sub("pll_core", "XPLL", dict(REFCK="refck", LO="ckr", NB="nb", PB="pb", ICP2="icp2", VCTRL="vctrl",
                                   FS="fs", FB="fb", **G))
    t.newrow("mixer LO load + ADC clock load")
    for n in LO.values():
        t.cap("CL" + n, n, "0", "150f")
    t.cap("CFS", "fs", "0", "300f")
    t.models()
    t.code("SIM", """.option method=gear reltol=2e-4
.ic v(vctrl)=1.7 v(xpll.xlf.z)=1.7 v(xpll.vcp)=1.7 v(xvco.xcore.p4)=0 v(xvco.xcore.n4)=2
.control
set num_threads=1
save v(vctrl) v(fb) v(refck) v(fs) v(l1p)
tran 5p 4u 0 5p uic
wrdata tb_pll_vctrl v(vctrl)
meas tran vc_end avg v(vctrl) from=3.5u to=4u
meas tran vc_pp pp v(vctrl) from=3.5u to=4u
meas tran t1 when v(fs)=1.65 rise=25
meas tran t2 when v(fs)=1.65 rise=55
let ffs = 30/(t2-t1)
let flo = ffs*96
meas tran r1 when v(refck)=1.65 rise=60
meas tran b1 when v(fb)=1.65 rise=60
let tpe = b1-r1
echo RES vc_end=$&vc_end vc_pp=$&vc_pp flo=$&flo phase_err_s=$&tpe
.endc""")
    t.save()



def tb_afc():
    t = Sch("tb_afc", title="tb_afc: 8-bit R-2R AFC DAC transfer (load = VCTCXO Vc input, 100 kohm)")
    t.vsrc("VDD", "vdd", "0", "3.3")
    d = {}
    for b in range(8):
        t.vsrc("VD%d" % b, "d%d" % b, "0", "0")
        d["D%d" % b] = "d%d" % b
    d.update(OUT="out", **G)
    t.sub("afc_dac", "XDAC", d)
    t.res("RLOAD", "out", "0", "100k")
    t.models()
    ctl = [".control", "set num_threads=1"]
    for code in range(256):
        for b in range(8):
            ctl.append("alter VD%d dc = %g" % (b, 3.3 * ((code >> b) & 1)))
        ctl += ["op", "echo DAC %d $&v(out)" % code]
    ctl.append(".endc")
    t.code("SIM", "\n".join(ctl))
    t.save()



def tb_top():
    t = Sch("tb_top", title="tb_top: full AFE top level (15 pins, SPI) - netlist / DC check")
    t.vsrc("VDD", "vdd", "0", "3.3")
    t.vsrc("VREF", "refin", "0", "sin(1.65 0.4 16.368e6)")
    t.vsrc("VRFP", "sp", "0", "0")
    t.res("RSP", "sp", "sps", "50")
    t.cap("CCP", "sps", "rfin", "10p")
    t.vsrc("VSCLK", "sclk", "0", "0")
    t.vsrc("VSDI", "sdi", "0", "0")
    t.vsrc("VCSN", "csn", "0", "3.3")
    t.sub("gnss_afe_top", "XDUT", dict(RFIN="rfin", REFIN="refin", SCLK="sclk", SDI="sdi", CS_N="csn",
                                       I_SIGN="isign", I_MAG="imag", Q_SIGN="qsign", Q_MAG="qmag",
                                       CLKOUT="clkout", AFCOUT="afcout", VCTRL="vctrl", VDDV="vddv", VDD="vdd", VSS="0"))
    t.vsrc("VDDV", "vdd", "vddv", "0")      # VCO supply pin: same 3.3 V, i(VDD) stays the chip total
    t.newrow("pad loads")
    for n in ("isign", "imag", "qsign", "qmag", "clkout"):
        t.cap("CP" + n, n, "0", "2p")
    t.res("RAFC", "afcout", "0", "100k")
    t.models()
    t.code("SIM", """.control
set num_threads=1
op
echo RES idd_total=$&i(VDD) vctrl=$&v(vctrl) afcout=$&v(afcout)
.endc""")
    t.save()


def spi_frame(word, t0=30e-6, tck=100e-9, vh=3.3, nbits=24):
    """PWL strings for a mode-0 MSB-first 24-bit SPI write starting at t0."""
    sclk, sdi, csn = ["0 0"], ["0 0"], ["0 %g" % vh]
    tr = 2e-9
    csn += ["%g %g" % (t0, vh), "%g 0" % (t0 + tr)]
    for k in range(nbits):
        bit = (word >> (nbits - 1 - k)) & 1
        ts = t0 + 0.5 * tck + k * tck
        sdi += ["%g %s" % (ts, sdi[-1].split()[1]), "%g %g" % (ts + tr, vh * bit)]
        tr_ = ts + 0.5 * tck
        sclk += ["%g 0" % tr_, "%g %g" % (tr_ + tr, vh), "%g %g" % (tr_ + 0.5 * tck, vh), "%g 0" % (tr_ + 0.5 * tck + tr)]
    te = t0 + (nbits + 1) * tck
    csn += ["%g 0" % te, "%g %g" % (te + tr, vh)]
    f = lambda l: "pwl(" + " ".join(l) + ")"
    return f(sclk), f(sdi), f(csn), te


SPI_OUT = ["IG1A", "IG1B", "IG2A", "IG2B", "IG3A", "IG3B", "B0", "B1"] + ["AFC%d" % i for i in range(8)] + ["ICP2"]
SPI_WORD = 0x813A96  # reserved bit 23 = 1 (must not leak), ICP2 = 1, AFC field 0x3A (-> DAC code 0xBA), B1B0 = 10, IG = 010110


def tb_spi():
    t = Sch("tb_spi", title="tb_spi: power-on reset defaults + one 24-bit SPI write (0x%06X, 10 MHz SCLK)" % SPI_WORD)
    t.vsrc("VDD", "vdd", "0", "pwl(0 0 1u 3.3)")
    sclk, sdi, csn, te = spi_frame(SPI_WORD)
    t.vsrc("VSCLK", "sclk", "0", sclk)
    t.vsrc("VSDI", "sdi", "0", sdi)
    t.vsrc("VCSN", "csn", "0", csn)
    d = {n: n.lower() for n in SPI_OUT}
    d.update(SCLK="sclk", SDI="sdi", CS_N="csn", **G)
    t.sub("spi_regs", "XS", d)
    t.models()
    ctl = [".control", "set num_threads=1", "tran 2n %gu" % (te * 1e6 + 2)]
    for tag, tm in (("por", 29e-6), ("write", te + 1.5e-6)):
        for n in SPI_OUT:
            ctl.append("meas tran %s_%s find v(%s) at=%g" % (tag, n.lower(), n.lower(), tm))
        ctl.append("echo RES %s " % tag + " ".join("%s=$&%s_%s" % (n, tag, n.lower()) for n in SPI_OUT))
    ctl.append("meas tran rstw when v(xs.rst)=1.65 fall=1")
    ctl.append("echo RES por_release=$&rstw")
    ctl.append(".endc")
    t.code("SIM", "\n".join(ctl))
    t.save()



def spi_frames(words, tck=100e-9, vh=3.3):
    """Several SPI writes: words = [(t_start, value), ...] -> merged PWL strings."""
    sclk, sdi, csn = ["0 0"], ["0 0"], ["0 %g" % vh]
    for t0, w in words:
        a, b, c, te = spi_frame(w, t0, tck, vh)
        strip = lambda x: x[4:-1].split(" ")
        pairs = lambda l: [" ".join(l[k:k + 2]) for k in range(0, len(l), 2)][1:]
        sclk += pairs(strip(a)); sdi += pairs(strip(b)); csn += pairs(strip(c))
    f = lambda l: "pwl(" + " ".join(l) + ")"
    return f(sclk), f(sdi), f(csn)


def gain_word(g1, g2, g3, band=0, afc=0, icp2=0):
    return (icp2 << 16) | ((afc & 0xFF) << 8) | (band << 6) | (g3 << 4) | (g2 << 2) | g1


def tb_ifadc():
    """IF chain + 2-bit ADC + SPI, driven by mixer-output-equivalent signal + noise."""
    t = Sch("tb_ifadc", title="tb_ifadc: SPI -> IF chain (I) -> 2-bit ADC; 4.092 MHz tone + white noise at mixer-output level")
    t.vsrc("VDD", "vdd", "0", "pwl(0 0 0.5137u 3.3)")
    t.sub("bias_gen", "XB", dict(NB="nb", PB="pb", **G))
    # mixer output equivalent: CM 2.0 V, white noise ~ LNA20dB noise x mixer gain (see gnss_sysim link budget)
    # in-band diff noise 0.41 mV rms (-> sigma 0.165 V at ADC with gain code 01, see gnss_sysim link budget;
    # rev.2 used 0.126 mV for its 4 fixed VGA stages, rev.3 has 3);
    # tone 10 dB below in-band noise at 4.13 MHz (4.092 MHz + 38 kHz Doppler, not locked to fs/4).
    # ngspice accepts only one transient function per source -> noise and tone are separate series sources.
    t.vsrc("VTP", "inp0", "0", "dc 2.0 sin(2.0 92u 4.13e6)")
    t.vsrc("VNP", "inp", "inp0", "dc 0 trnoise(0.56m 19.73n 0 0)")
    t.vsrc("VTN", "inn0", "0", "dc 2.0 sin(2.0 92u 4.13e6 0 0 180)")
    t.vsrc("VNN", "inn", "inn0", "dc 0 trnoise(0.56m 19.73n 0 0)")
    sclk, sdi, csn = spi_frames([(4e-6, gain_word(1, 1, 1)), (40e-6, gain_word(0, 0, 0))])
    t.vsrc("VSCLK", "sclk", "0", sclk)
    t.vsrc("VSDI", "sdi", "0", sdi)
    t.vsrc("VCSN", "csn", "0", csn)
    d = {n: n.lower() for n in SPI_OUT}
    d.update(SCLK="sclk", SDI="sdi", CS_N="csn", **G)
    t.sub("spi_regs", "XS", d)
    t.newrow("IF chain + ADC (16.368 MHz clock)")
    t.sub("if_chain", "XIF", dict(INP="inp", INN="inn", G1A="ig1a", G1B="ig1b", G2A="ig2a", G2B="ig2b",
                                  G3A="ig3a", G3B="ig3b", PB="pb", OUTP="aop", OUTN="aon", **G))
    T = 1e9 / (FLO / 96)
    t.vsrc("VCK", "clk", "0", "pulse(0 3.3 0 0.3n 0.3n %.4fn %.4fn)" % (T / 2 - 0.3, T))
    t.sub("adc2b", "XA", dict(INP="aop", INN="aon", CLK="clk", SIGN="sign", MAG="mag", **G))
    t.models()
    t.code("SIM", """.option method=gear
.control
set num_threads=1
tran 2n 80u 0 2n
wrdata tb_ifadc_out v(clk) v(sign) v(mag) v(aop,aon) v(ig1a) v(ig1b)
.endc""")
    t.save()


def tb_full():
    """Whole chip: supply ramp, POR, SPI write, PLL lock, RF noise + CW tone through to the 2-bit outputs."""
    t = Sch("tb_full", title="tb_full: full-chip transient (supply ramp, SPI, PLL lock, RF -> 2-bit I/Q)")
    t.vsrc("VDD", "vdd", "0", "3.3")   # uic: all nodes start at 0 V, POR still fires (RC charges from 0)
    t.vsrc("VREF", "refin", "0", "sin(1.65 0.4 16.368e6)")
    # RF port: 2 x 50 ohm; LNA(20 dB)+SAW noise -154 dBm/Hz -> per side open-circuit 0.9 mV rms over 10 GHz;
    # CW tone at 1575.42 MHz, -95 dBm (diff peak 5.6 uV x2 open circuit)
    t.vsrc("VRFP", "sp0", "0", "sin(0 11.2u 1575.42e6)")
    t.vsrc("VRNP", "sp", "sp0", "dc 0 trnoise(0.9m 49.7p 0 0)")
    t.res("RSP", "sp", "sps", "50")
    t.cap("CCP", "sps", "rfin", "10p")    # single-ended 50 ohm RF input, external AC coupling
    sclk, sdi, csn = spi_frames([(2.5e-6, gain_word(1, 1, 1))])
    t.vsrc("VSCLK", "sclk", "0", sclk)
    t.vsrc("VSDI", "sdi", "0", sdi)
    t.vsrc("VCSN", "csn", "0", csn)
    t.sub("gnss_afe_top", "XDUT", dict(RFIN="rfin", REFIN="refin", SCLK="sclk", SDI="sdi", CS_N="csn",
                                       I_SIGN="isign", I_MAG="imag", Q_SIGN="qsign", Q_MAG="qmag",
                                       CLKOUT="clkout", AFCOUT="afcout", VCTRL="vctrl", VDDV="vddv", VDD="vdd", VSS="0"))
    t.vsrc("VDDV", "vdd", "vddv", "0")      # VCO supply pin: same 3.3 V, i(VDD) stays the chip total
    t.newrow("pad loads")
    for n in ("isign", "imag", "qsign", "qmag", "clkout"):
        t.cap("CP" + n, n, "0", "2p")
    t.res("RAFC", "afcout", "0", "100k")
    t.models()
    # no 'klu': ngspice-47 KLU (default pivrel=1e-3, refactor reuses the old pivot order) hits a
    # near-zero pivot after a few ns -> "Timestep too small" (pivrel=0.1 still fails at 25 ns);
    # Sparse 1.3 runs cleanly at the same speed as Xyce
    t.code("SIM", """.option method=gear reltol=2e-4 minbreak=1e-12
.ic v(vctrl)=1.7 v(xdut.xpll.xlf.z)=1.7 v(xdut.xpll.vcp)=1.7 v(xdut.xvco.xcore.p4)=0 v(xdut.xvco.xcore.n4)=1
.control
set num_threads=1
save v(vctrl) v(clkout) v(isign) v(imag) v(qsign) v(qmag) v(afcout) v(xdut.aip) v(xdut.ain) v(xdut.aqp) v(xdut.aqn) v(xdut.mip) v(xdut.min) v(xdut.mqp) v(xdut.mqn) v(rfin) v(xdut.rfp) v(xdut.rfn) i(VDD)
tran 5p 12u 0 5p uic
wrdata tb_full_out v(vctrl) v(clkout) v(isign) v(imag) v(qsign) v(qmag) v(xdut.aip,xdut.ain) v(xdut.aqp,xdut.aqn) v(xdut.mip,xdut.min) v(xdut.mqp,xdut.mqn) v(rfin) v(xdut.rfp,xdut.rfn) i(VDD)
meas tran vc_end avg v(vctrl) from=11u to=12u
meas tran idd avg i(VDD) from=8u to=12u
echo RES vc_end=$&vc_end idd=$&idd
.endc""")
    t.save()



def tb_lna():
    t = Sch("tb_lna", title="tb_lna: NC-LNA S11 / gain / balance / NF (load = mixer_iq with static LO)")
    t.vsrc("VDD", "vdd", "0", "3.3")
    t.sub("bias_gen", "XB", dict(NB="nb", PB="pb", **G))
    t.vsrc("VRF", "s0", "0", "dc 0 ac 1")
    t.res("RS50", "s0", "s1", "50")
    t.cap("CIN", "s1", "rfin", "10p")
    t.sub("lna_nc", "XLNA", dict(RFIN="rfin", PB="pb", OUTP="rfp", OUTN="rfn", **G))
    t.newrow("load: real mixer, LO frozen (I/Q switches on one side)")
    for n in LO.values():
        t.vsrc("V" + n.upper(), n, "0", "2.0" if n.endswith("p") else "0")
    t.sub("mixer_iq", "XM", dict(RFP="rfp", RFN="rfn", **LO, NB="nb", IFIP="ifip", IFIN="ifin", IFQP="ifqp", IFQN="ifqn", **G))
    t.models()
    t.code("SIM", """.control
set num_threads=1
op
echo RES op i1=$&@m.xlna.xm1.m0[id] gm1=$&@m.xlna.xm1.m0[gm] gmb1=$&@m.xlna.xm1.m0[gmbs] i2=$&@m.xlna.xm2.m0[id] gm2=$&@m.xlna.xm2.m0[gm] vx=$&v(rfin) vop=$&v(xlna.op_i) von=$&v(xlna.on_i) vb1=$&v(xlna.vb1) vb2=$&v(xlna.vb2) idd=$&i(VDD)
ac lin 9 1.4e9 1.8e9
let zin = v(rfin)/(-i(VRF))
let s11 = db((zin-50)/(zin+50))
let gp = v(rfp)/v(s0)*2
let gn = v(rfn)/v(s0)*2
let gd = db((v(rfp)-v(rfn))/v(s0)*2)
let bal = db(mag(gp)/mag(gn))
let ph = (cph(gp)-cph(gn))*180/pi
print frequency real(zin) imag(zin) s11 gd bal ph
noise v(rfp,rfn) VRF lin 9 1.4e9 1.8e9
setplot noise1
let nf = 10*log10(inoise_spectrum^2/(4*1.380649e-23*300*50))
print frequency nf
.endc""")
    t.save()



def tb_rx():
    """LNA + mixer conversion gain from the 50 ohm RF port (ideal 8-phase LO/2, 0-2.0 V = VCO swing)."""
    t = Sch("tb_rx", title="tb_rx: RF port (50 ohm SE) -> NC-LNA -> I/Q mixer, conversion gain and I/Q balance (ideal 8-phase LO/2)")
    t.vsrc("VDD", "vdd", "0", "3.3")
    t.sub("bias_gen", "XB", dict(NB="nb", PB="pb", **G))
    lo_sources(t)
    t.vsrc("VRF", "s0", "0", "sin(0 ARF 1575.42e6)")
    t.res("RS50", "s0", "s1", "50")
    t.cap("CIN", "s1", "rfin", "10p")
    t.sub("lna_nc", "XLNA", dict(RFIN="rfin", PB="pb", OUTP="rfp", OUTN="rfn", **G))
    t.sub("mixer_iq", "XM", dict(RFP="rfp", RFN="rfn", **LO, NB="nb", IFIP="ifip", IFIN="ifin", IFQP="ifqp", IFQN="ifqn", **G))
    t.models()
    t.code("SIM", """.option method=gear
.control
set num_threads=1
tran 5p 0.75u 0 5p
linearize v(ifip) v(ifin) v(ifqp) v(ifqn) v(rfin)
let vi = v(ifip)-v(ifin)
let vq = v(ifqp)-v(ifqn)
wrdata tb_rx_out vi vq v(rfin)
.endc""")
    t.save()


if __name__ == "__main__":
    for f in [v for k, v in dict(globals()).items() if k.startswith("tb_")]:
        f()
    print("testbenches generated")
