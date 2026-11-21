v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {tb_full: full-chip transient (supply ramp, SPI, PLL lock, RF -> 2-bit I/Q)} 100 80 0 0 0.6 0.6 {}
T {pad loads} 100 590 0 0 0.4 0.4 {layer=8}
C {devices/vsource.sym} 200 300 0 0 {name=VDD value="3.3" savecurrent=false}
N 200 270 200 250 {lab=vdd}
C {devices/lab_pin.sym} 200 250 0 0 {name=l1 sig_type=std_logic lab=vdd}
N 200 330 200 350 {lab=0}
C {devices/lab_pin.sym} 200 350 0 0 {name=l2 sig_type=std_logic lab=0}
C {devices/vsource.sym} 460 300 0 0 {name=VREF value="sin(1.65 0.4 16.368e6)" savecurrent=false}
N 460 270 460 250 {lab=refin}
C {devices/lab_pin.sym} 460 250 0 0 {name=l3 sig_type=std_logic lab=refin}
N 460 330 460 350 {lab=0}
C {devices/lab_pin.sym} 460 350 0 0 {name=l4 sig_type=std_logic lab=0}
C {devices/vsource.sym} 720 300 0 0 {name=VRFP value="sin(0 11.2u 1575.42e6)" savecurrent=false}
N 720 270 720 250 {lab=sp0}
C {devices/lab_pin.sym} 720 250 0 0 {name=l5 sig_type=std_logic lab=sp0}
N 720 330 720 350 {lab=0}
C {devices/lab_pin.sym} 720 350 0 0 {name=l6 sig_type=std_logic lab=0}
C {devices/vsource.sym} 980 300 0 0 {name=VRNP value="dc 0 trnoise(0.9m 49.7p 0 0)" savecurrent=false}
N 980 270 980 250 {lab=sp}
C {devices/lab_pin.sym} 980 250 0 0 {name=l7 sig_type=std_logic lab=sp}
N 980 330 980 350 {lab=sp0}
C {devices/lab_pin.sym} 980 350 0 0 {name=l8 sig_type=std_logic lab=sp0}
C {devices/res.sym} 1240 300 0 0 {name=RSP value=50 footprint=1206 device=resistor m=1}
N 1240 270 1240 250 {lab=sp}
C {devices/lab_pin.sym} 1240 250 0 0 {name=l9 sig_type=std_logic lab=sp}
N 1240 330 1240 350 {lab=sps}
C {devices/lab_pin.sym} 1240 350 0 0 {name=l10 sig_type=std_logic lab=sps}
C {devices/capa.sym} 1500 300 0 0 {name=CCP value=10p footprint=1206 device=capacitor m=1}
N 1500 270 1500 250 {lab=sps}
C {devices/lab_pin.sym} 1500 250 0 0 {name=l11 sig_type=std_logic lab=sps}
N 1500 330 1500 350 {lab=rfin}
C {devices/lab_pin.sym} 1500 350 0 0 {name=l12 sig_type=std_logic lab=rfin}
C {devices/vsource.sym} 200 500 0 0 {name=VSCLK value="pwl(0 0 2.6e-06 0 2.602e-06 3.3 2.65e-06 3.3 2.652e-06 0 2.7e-06 0 2.702e-06 3.3 2.75e-06 3.3 2.752e-06 0 2.8e-06 0 2.802e-06 3.3 2.85e-06 3.3 2.852e-06 0 2.9e-06 0 2.902e-06 3.3 2.95e-06 3.3 2.952e-06 0 3e-06 0 3.002e-06 3.3 3.05e-06 3.3 3.052e-06 0 3.1e-06 0 3.102e-06 3.3 3.15e-06 3.3 3.152e-06 0 3.2e-06 0 3.202e-06 3.3 3.25e-06 3.3 3.252e-06 0 3.3e-06 0 3.302e-06 3.3 3.35e-06 3.3 3.352e-06 0 3.4e-06 0 3.402e-06 3.3 3.45e-06 3.3 3.452e-06 0 3.5e-06 0 3.502e-06 3.3 3.55e-06 3.3 3.552e-06 0 3.6e-06 0 3.602e-06 3.3 3.65e-06 3.3 3.652e-06 0 3.7e-06 0 3.702e-06 3.3 3.75e-06 3.3 3.752e-06 0 3.8e-06 0 3.802e-06 3.3 3.85e-06 3.3 3.852e-06 0 3.9e-06 0 3.902e-06 3.3 3.95e-06 3.3 3.952e-06 0 4e-06 0 4.002e-06 3.3 4.05e-06 3.3 4.052e-06 0 4.1e-06 0 4.102e-06 3.3 4.15e-06 3.3 4.152e-06 0 4.2e-06 0 4.202e-06 3.3 4.25e-06 3.3 4.252e-06 0 4.3e-06 0 4.302e-06 3.3 4.35e-06 3.3 4.352e-06 0 4.4e-06 0 4.402e-06 3.3 4.45e-06 3.3 4.452e-06 0 4.5e-06 0 4.502e-06 3.3 4.55e-06 3.3 4.552e-06 0 4.6e-06 0 4.602e-06 3.3 4.65e-06 3.3 4.652e-06 0 4.7e-06 0 4.702e-06 3.3 4.75e-06 3.3 4.752e-06 0 4.8e-06 0 4.802e-06 3.3 4.85e-06 3.3 4.852e-06 0 4.9e-06 0 4.902e-06 3.3 4.95e-06 3.3 4.952e-06 0)" savecurrent=false}
N 200 470 200 450 {lab=sclk}
C {devices/lab_pin.sym} 200 450 0 0 {name=l13 sig_type=std_logic lab=sclk}
N 200 530 200 550 {lab=0}
C {devices/lab_pin.sym} 200 550 0 0 {name=l14 sig_type=std_logic lab=0}
C {devices/vsource.sym} 460 500 0 0 {name=VSDI value="pwl(0 0 2.55e-06 0 2.552e-06 0 2.65e-06 0 2.652e-06 0 2.75e-06 0 2.752e-06 0 2.85e-06 0 2.852e-06 0 2.95e-06 0 2.952e-06 0 3.05e-06 0 3.052e-06 0 3.15e-06 0 3.152e-06 0 3.25e-06 0 3.252e-06 0 3.35e-06 0 3.352e-06 0 3.45e-06 0 3.452e-06 0 3.55e-06 0 3.552e-06 0 3.65e-06 0 3.652e-06 0 3.75e-06 0 3.752e-06 0 3.85e-06 0 3.852e-06 0 3.95e-06 0 3.952e-06 0 4.05e-06 0 4.052e-06 0 4.15e-06 0 4.152e-06 0 4.25e-06 0 4.252e-06 0 4.35e-06 0 4.352e-06 0 4.45e-06 0 4.452e-06 3.3 4.55e-06 3.3 4.552e-06 0 4.65e-06 0 4.652e-06 3.3 4.75e-06 3.3 4.752e-06 0 4.85e-06 0 4.852e-06 3.3)" savecurrent=false}
N 460 470 460 450 {lab=sdi}
C {devices/lab_pin.sym} 460 450 0 0 {name=l15 sig_type=std_logic lab=sdi}
N 460 530 460 550 {lab=0}
C {devices/lab_pin.sym} 460 550 0 0 {name=l16 sig_type=std_logic lab=0}
C {devices/vsource.sym} 720 500 0 0 {name=VCSN value="pwl(0 3.3 2.5e-06 3.3 2.502e-06 0 5e-06 0 5.002e-06 3.3)" savecurrent=false}
N 720 470 720 450 {lab=csn}
C {devices/lab_pin.sym} 720 450 0 0 {name=l17 sig_type=std_logic lab=csn}
N 720 530 720 550 {lab=0}
C {devices/lab_pin.sym} 720 550 0 0 {name=l18 sig_type=std_logic lab=0}
C {gnss_afe_top.sym} 980 500 0 0 {name=XDUT }
N 880 410 860 410 {lab=rfin}
C {devices/lab_pin.sym} 860 410 0 0 {name=l19 sig_type=std_logic lab=rfin}
N 880 430 860 430 {lab=refin}
C {devices/lab_pin.sym} 860 430 0 0 {name=l20 sig_type=std_logic lab=refin}
N 880 450 860 450 {lab=sclk}
C {devices/lab_pin.sym} 860 450 0 0 {name=l21 sig_type=std_logic lab=sclk}
N 880 470 860 470 {lab=sdi}
C {devices/lab_pin.sym} 860 470 0 0 {name=l22 sig_type=std_logic lab=sdi}
N 880 490 860 490 {lab=csn}
C {devices/lab_pin.sym} 860 490 0 0 {name=l23 sig_type=std_logic lab=csn}
N 1080 410 1100 410 {lab=isign}
C {devices/lab_pin.sym} 1100 410 0 1 {name=l24 sig_type=std_logic lab=isign}
N 1080 430 1100 430 {lab=imag}
C {devices/lab_pin.sym} 1100 430 0 1 {name=l25 sig_type=std_logic lab=imag}
N 1080 450 1100 450 {lab=qsign}
C {devices/lab_pin.sym} 1100 450 0 1 {name=l26 sig_type=std_logic lab=qsign}
N 1080 470 1100 470 {lab=qmag}
C {devices/lab_pin.sym} 1100 470 0 1 {name=l27 sig_type=std_logic lab=qmag}
N 1080 490 1100 490 {lab=clkout}
C {devices/lab_pin.sym} 1100 490 0 1 {name=l28 sig_type=std_logic lab=clkout}
N 1080 510 1100 510 {lab=afcout}
C {devices/lab_pin.sym} 1100 510 0 1 {name=l29 sig_type=std_logic lab=afcout}
N 1080 530 1100 530 {lab=vctrl}
C {devices/lab_pin.sym} 1100 530 0 1 {name=l30 sig_type=std_logic lab=vctrl}
N 1080 550 1100 550 {lab=vddv}
C {devices/lab_pin.sym} 1100 550 0 1 {name=l31 sig_type=std_logic lab=vddv}
N 1080 570 1100 570 {lab=vdd}
C {devices/lab_pin.sym} 1100 570 0 1 {name=l32 sig_type=std_logic lab=vdd}
N 1080 590 1100 590 {lab=0}
C {devices/lab_pin.sym} 1100 590 0 1 {name=l33 sig_type=std_logic lab=0}
C {devices/vsource.sym} 1240 500 0 0 {name=VDDV value="0" savecurrent=false}
N 1240 470 1240 450 {lab=vdd}
C {devices/lab_pin.sym} 1240 450 0 0 {name=l34 sig_type=std_logic lab=vdd}
N 1240 530 1240 550 {lab=vddv}
C {devices/lab_pin.sym} 1240 550 0 0 {name=l35 sig_type=std_logic lab=vddv}
C {devices/capa.sym} 200 700 0 0 {name=CPisign value=2p footprint=1206 device=capacitor m=1}
N 200 670 200 650 {lab=isign}
C {devices/lab_pin.sym} 200 650 0 0 {name=l36 sig_type=std_logic lab=isign}
N 200 730 200 750 {lab=0}
C {devices/lab_pin.sym} 200 750 0 0 {name=l37 sig_type=std_logic lab=0}
C {devices/capa.sym} 460 700 0 0 {name=CPimag value=2p footprint=1206 device=capacitor m=1}
N 460 670 460 650 {lab=imag}
C {devices/lab_pin.sym} 460 650 0 0 {name=l38 sig_type=std_logic lab=imag}
N 460 730 460 750 {lab=0}
C {devices/lab_pin.sym} 460 750 0 0 {name=l39 sig_type=std_logic lab=0}
C {devices/capa.sym} 720 700 0 0 {name=CPqsign value=2p footprint=1206 device=capacitor m=1}
N 720 670 720 650 {lab=qsign}
C {devices/lab_pin.sym} 720 650 0 0 {name=l40 sig_type=std_logic lab=qsign}
N 720 730 720 750 {lab=0}
C {devices/lab_pin.sym} 720 750 0 0 {name=l41 sig_type=std_logic lab=0}
C {devices/capa.sym} 980 700 0 0 {name=CPqmag value=2p footprint=1206 device=capacitor m=1}
N 980 670 980 650 {lab=qmag}
C {devices/lab_pin.sym} 980 650 0 0 {name=l42 sig_type=std_logic lab=qmag}
N 980 730 980 750 {lab=0}
C {devices/lab_pin.sym} 980 750 0 0 {name=l43 sig_type=std_logic lab=0}
C {devices/capa.sym} 1240 700 0 0 {name=CPclkout value=2p footprint=1206 device=capacitor m=1}
N 1240 670 1240 650 {lab=clkout}
C {devices/lab_pin.sym} 1240 650 0 0 {name=l44 sig_type=std_logic lab=clkout}
N 1240 730 1240 750 {lab=0}
C {devices/lab_pin.sym} 1240 750 0 0 {name=l45 sig_type=std_logic lab=0}
C {devices/res.sym} 1500 700 0 0 {name=RAFC value=100k footprint=1206 device=resistor m=1}
N 1500 670 1500 650 {lab=afcout}
C {devices/lab_pin.sym} 1500 650 0 0 {name=l46 sig_type=std_logic lab=afcout}
N 1500 730 1500 750 {lab=0}
C {devices/lab_pin.sym} 1500 750 0 0 {name=l47 sig_type=std_logic lab=0}
C {devices/code_shown.sym} 1860 300 0 0 {name=MODELS format="tcleval( @value )" only_toplevel=true value=".include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice mimcap_typical"}
C {devices/code_shown.sym} 1860 700 0 0 {name=SIM only_toplevel=true value=".option method=gear reltol=2e-4 minbreak=1e-12
.ic v(xdut.vctrl)=1.7 v(xdut.xpll.xlf.z)=1.7 v(xdut.xpll.vcp)=1.7 v(xdut.xvco.xcore.p4)=0 v(xdut.xvco.xcore.n4)=1
.control
set num_threads=1
save v(vctrl) v(xdut.vctrl) v(clkout) v(isign) v(imag) v(qsign) v(qmag) v(afcout) v(xdut.aip) v(xdut.ain) v(xdut.aqp) v(xdut.aqn) v(xdut.mip) v(xdut.min) v(xdut.mqp) v(xdut.mqn) v(rfin) v(xdut.rfp) v(xdut.rfn) i(VDD)
tran 5p 12u 0 5p uic
wrdata tb_full_out v(vctrl) v(clkout) v(isign) v(imag) v(qsign) v(qmag) v(xdut.aip,xdut.ain) v(xdut.aqp,xdut.aqn) v(xdut.mip,xdut.min) v(xdut.mqp,xdut.mqn) v(rfin) v(xdut.rfp,xdut.rfn) i(VDD)
meas tran vc_end avg v(vctrl) from=11u to=12u
meas tran idd avg i(VDD) from=8u to=12u
echo RES vc_end=$&vc_end idd=$&idd
.endc"}
C {devices/title.sym} 160 1200 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
