v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {tb_top: full AFE top level (15 pins, SPI) - netlist / DC check} 100 80 0 0 0.6 0.6 {}
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
C {devices/vsource.sym} 720 300 0 0 {name=VRFP value="0" savecurrent=false}
N 720 270 720 250 {lab=sp}
C {devices/lab_pin.sym} 720 250 0 0 {name=l5 sig_type=std_logic lab=sp}
N 720 330 720 350 {lab=0}
C {devices/lab_pin.sym} 720 350 0 0 {name=l6 sig_type=std_logic lab=0}
C {devices/res.sym} 980 300 0 0 {name=RSP value=50 footprint=1206 device=resistor m=1}
N 980 270 980 250 {lab=sp}
C {devices/lab_pin.sym} 980 250 0 0 {name=l7 sig_type=std_logic lab=sp}
N 980 330 980 350 {lab=sps}
C {devices/lab_pin.sym} 980 350 0 0 {name=l8 sig_type=std_logic lab=sps}
C {devices/capa.sym} 1240 300 0 0 {name=CCP value=10p footprint=1206 device=capacitor m=1}
N 1240 270 1240 250 {lab=sps}
C {devices/lab_pin.sym} 1240 250 0 0 {name=l9 sig_type=std_logic lab=sps}
N 1240 330 1240 350 {lab=rfin}
C {devices/lab_pin.sym} 1240 350 0 0 {name=l10 sig_type=std_logic lab=rfin}
C {devices/vsource.sym} 1500 300 0 0 {name=VSCLK value="0" savecurrent=false}
N 1500 270 1500 250 {lab=sclk}
C {devices/lab_pin.sym} 1500 250 0 0 {name=l11 sig_type=std_logic lab=sclk}
N 1500 330 1500 350 {lab=0}
C {devices/lab_pin.sym} 1500 350 0 0 {name=l12 sig_type=std_logic lab=0}
C {devices/vsource.sym} 200 500 0 0 {name=VSDI value="0" savecurrent=false}
N 200 470 200 450 {lab=sdi}
C {devices/lab_pin.sym} 200 450 0 0 {name=l13 sig_type=std_logic lab=sdi}
N 200 530 200 550 {lab=0}
C {devices/lab_pin.sym} 200 550 0 0 {name=l14 sig_type=std_logic lab=0}
C {devices/vsource.sym} 460 500 0 0 {name=VCSN value="3.3" savecurrent=false}
N 460 470 460 450 {lab=csn}
C {devices/lab_pin.sym} 460 450 0 0 {name=l15 sig_type=std_logic lab=csn}
N 460 530 460 550 {lab=0}
C {devices/lab_pin.sym} 460 550 0 0 {name=l16 sig_type=std_logic lab=0}
C {gnss_afe_top.sym} 720 500 0 0 {name=XDUT }
N 620 410 600 410 {lab=rfin}
C {devices/lab_pin.sym} 600 410 0 0 {name=l17 sig_type=std_logic lab=rfin}
N 620 430 600 430 {lab=refin}
C {devices/lab_pin.sym} 600 430 0 0 {name=l18 sig_type=std_logic lab=refin}
N 620 450 600 450 {lab=sclk}
C {devices/lab_pin.sym} 600 450 0 0 {name=l19 sig_type=std_logic lab=sclk}
N 620 470 600 470 {lab=sdi}
C {devices/lab_pin.sym} 600 470 0 0 {name=l20 sig_type=std_logic lab=sdi}
N 620 490 600 490 {lab=csn}
C {devices/lab_pin.sym} 600 490 0 0 {name=l21 sig_type=std_logic lab=csn}
N 820 410 840 410 {lab=isign}
C {devices/lab_pin.sym} 840 410 0 1 {name=l22 sig_type=std_logic lab=isign}
N 820 430 840 430 {lab=imag}
C {devices/lab_pin.sym} 840 430 0 1 {name=l23 sig_type=std_logic lab=imag}
N 820 450 840 450 {lab=qsign}
C {devices/lab_pin.sym} 840 450 0 1 {name=l24 sig_type=std_logic lab=qsign}
N 820 470 840 470 {lab=qmag}
C {devices/lab_pin.sym} 840 470 0 1 {name=l25 sig_type=std_logic lab=qmag}
N 820 490 840 490 {lab=clkout}
C {devices/lab_pin.sym} 840 490 0 1 {name=l26 sig_type=std_logic lab=clkout}
N 820 510 840 510 {lab=afcout}
C {devices/lab_pin.sym} 840 510 0 1 {name=l27 sig_type=std_logic lab=afcout}
N 820 530 840 530 {lab=vctrl}
C {devices/lab_pin.sym} 840 530 0 1 {name=l28 sig_type=std_logic lab=vctrl}
N 820 550 840 550 {lab=vddv}
C {devices/lab_pin.sym} 840 550 0 1 {name=l29 sig_type=std_logic lab=vddv}
N 820 570 840 570 {lab=vdd}
C {devices/lab_pin.sym} 840 570 0 1 {name=l30 sig_type=std_logic lab=vdd}
N 820 590 840 590 {lab=0}
C {devices/lab_pin.sym} 840 590 0 1 {name=l31 sig_type=std_logic lab=0}
C {devices/vsource.sym} 980 500 0 0 {name=VDDV value="0" savecurrent=false}
N 980 470 980 450 {lab=vdd}
C {devices/lab_pin.sym} 980 450 0 0 {name=l32 sig_type=std_logic lab=vdd}
N 980 530 980 550 {lab=vddv}
C {devices/lab_pin.sym} 980 550 0 0 {name=l33 sig_type=std_logic lab=vddv}
C {devices/capa.sym} 200 700 0 0 {name=CPisign value=2p footprint=1206 device=capacitor m=1}
N 200 670 200 650 {lab=isign}
C {devices/lab_pin.sym} 200 650 0 0 {name=l34 sig_type=std_logic lab=isign}
N 200 730 200 750 {lab=0}
C {devices/lab_pin.sym} 200 750 0 0 {name=l35 sig_type=std_logic lab=0}
C {devices/capa.sym} 460 700 0 0 {name=CPimag value=2p footprint=1206 device=capacitor m=1}
N 460 670 460 650 {lab=imag}
C {devices/lab_pin.sym} 460 650 0 0 {name=l36 sig_type=std_logic lab=imag}
N 460 730 460 750 {lab=0}
C {devices/lab_pin.sym} 460 750 0 0 {name=l37 sig_type=std_logic lab=0}
C {devices/capa.sym} 720 700 0 0 {name=CPqsign value=2p footprint=1206 device=capacitor m=1}
N 720 670 720 650 {lab=qsign}
C {devices/lab_pin.sym} 720 650 0 0 {name=l38 sig_type=std_logic lab=qsign}
N 720 730 720 750 {lab=0}
C {devices/lab_pin.sym} 720 750 0 0 {name=l39 sig_type=std_logic lab=0}
C {devices/capa.sym} 980 700 0 0 {name=CPqmag value=2p footprint=1206 device=capacitor m=1}
N 980 670 980 650 {lab=qmag}
C {devices/lab_pin.sym} 980 650 0 0 {name=l40 sig_type=std_logic lab=qmag}
N 980 730 980 750 {lab=0}
C {devices/lab_pin.sym} 980 750 0 0 {name=l41 sig_type=std_logic lab=0}
C {devices/capa.sym} 1240 700 0 0 {name=CPclkout value=2p footprint=1206 device=capacitor m=1}
N 1240 670 1240 650 {lab=clkout}
C {devices/lab_pin.sym} 1240 650 0 0 {name=l42 sig_type=std_logic lab=clkout}
N 1240 730 1240 750 {lab=0}
C {devices/lab_pin.sym} 1240 750 0 0 {name=l43 sig_type=std_logic lab=0}
C {devices/res.sym} 1500 700 0 0 {name=RAFC value=100k footprint=1206 device=resistor m=1}
N 1500 670 1500 650 {lab=afcout}
C {devices/lab_pin.sym} 1500 650 0 0 {name=l44 sig_type=std_logic lab=afcout}
N 1500 730 1500 750 {lab=0}
C {devices/lab_pin.sym} 1500 750 0 0 {name=l45 sig_type=std_logic lab=0}
C {devices/code_shown.sym} 1860 300 0 0 {name=MODELS format="tcleval( @value )" only_toplevel=true value=".include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice mimcap_typical"}
C {devices/code_shown.sym} 1860 700 0 0 {name=SIM only_toplevel=true value=".control
set num_threads=1
op
echo RES idd_total=$&i(VDD) vctrl=$&v(vctrl) afcout=$&v(afcout)
.endc"}
C {devices/title.sym} 160 1200 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
