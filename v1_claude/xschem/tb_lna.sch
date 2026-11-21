v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {tb_lna: NC-LNA S11 / gain / balance / NF (load = mixer_iq with static LO)} 100 80 0 0 0.6 0.6 {}
T {load: real mixer, LO frozen (I/Q switches on one side)} 100 390 0 0 0.4 0.4 {layer=8}
C {devices/vsource.sym} 200 300 0 0 {name=VDD value="3.3" savecurrent=false}
N 200 270 200 250 {lab=vdd}
C {devices/lab_pin.sym} 200 250 0 0 {name=l1 sig_type=std_logic lab=vdd}
N 200 330 200 350 {lab=0}
C {devices/lab_pin.sym} 200 350 0 0 {name=l2 sig_type=std_logic lab=0}
C {bias_gen.sym} 460 300 0 0 {name=XB }
N 560 270 580 270 {lab=nb}
C {devices/lab_pin.sym} 580 270 0 1 {name=l3 sig_type=std_logic lab=nb}
N 560 290 580 290 {lab=pb}
C {devices/lab_pin.sym} 580 290 0 1 {name=l4 sig_type=std_logic lab=pb}
N 560 310 580 310 {lab=vdd}
C {devices/lab_pin.sym} 580 310 0 1 {name=l5 sig_type=std_logic lab=vdd}
N 560 330 580 330 {lab=0}
C {devices/lab_pin.sym} 580 330 0 1 {name=l6 sig_type=std_logic lab=0}
C {devices/vsource.sym} 720 300 0 0 {name=VRF value="dc 0 ac 1" savecurrent=false}
N 720 270 720 250 {lab=s0}
C {devices/lab_pin.sym} 720 250 0 0 {name=l7 sig_type=std_logic lab=s0}
N 720 330 720 350 {lab=0}
C {devices/lab_pin.sym} 720 350 0 0 {name=l8 sig_type=std_logic lab=0}
C {devices/res.sym} 980 300 0 0 {name=RS50 value=50 footprint=1206 device=resistor m=1}
N 980 270 980 250 {lab=s0}
C {devices/lab_pin.sym} 980 250 0 0 {name=l9 sig_type=std_logic lab=s0}
N 980 330 980 350 {lab=s1}
C {devices/lab_pin.sym} 980 350 0 0 {name=l10 sig_type=std_logic lab=s1}
C {devices/capa.sym} 1240 300 0 0 {name=CIN value=10p footprint=1206 device=capacitor m=1}
N 1240 270 1240 250 {lab=s1}
C {devices/lab_pin.sym} 1240 250 0 0 {name=l11 sig_type=std_logic lab=s1}
N 1240 330 1240 350 {lab=rfin}
C {devices/lab_pin.sym} 1240 350 0 0 {name=l12 sig_type=std_logic lab=rfin}
C {lna_nc.sym} 1500 300 0 0 {name=XLNA }
N 1400 270 1380 270 {lab=rfin}
C {devices/lab_pin.sym} 1380 270 0 0 {name=l13 sig_type=std_logic lab=rfin}
N 1400 290 1380 290 {lab=pb}
C {devices/lab_pin.sym} 1380 290 0 0 {name=l14 sig_type=std_logic lab=pb}
N 1600 270 1620 270 {lab=rfp}
C {devices/lab_pin.sym} 1620 270 0 1 {name=l15 sig_type=std_logic lab=rfp}
N 1600 290 1620 290 {lab=rfn}
C {devices/lab_pin.sym} 1620 290 0 1 {name=l16 sig_type=std_logic lab=rfn}
N 1600 310 1620 310 {lab=vdd}
C {devices/lab_pin.sym} 1620 310 0 1 {name=l17 sig_type=std_logic lab=vdd}
N 1600 330 1620 330 {lab=0}
C {devices/lab_pin.sym} 1620 330 0 1 {name=l18 sig_type=std_logic lab=0}
C {devices/vsource.sym} 200 500 0 0 {name=VL1P value="2.0" savecurrent=false}
N 200 470 200 450 {lab=l1p}
C {devices/lab_pin.sym} 200 450 0 0 {name=l19 sig_type=std_logic lab=l1p}
N 200 530 200 550 {lab=0}
C {devices/lab_pin.sym} 200 550 0 0 {name=l20 sig_type=std_logic lab=0}
C {devices/vsource.sym} 460 500 0 0 {name=VL1N value="0" savecurrent=false}
N 460 470 460 450 {lab=l1n}
C {devices/lab_pin.sym} 460 450 0 0 {name=l21 sig_type=std_logic lab=l1n}
N 460 530 460 550 {lab=0}
C {devices/lab_pin.sym} 460 550 0 0 {name=l22 sig_type=std_logic lab=0}
C {devices/vsource.sym} 720 500 0 0 {name=VL2P value="2.0" savecurrent=false}
N 720 470 720 450 {lab=l2p}
C {devices/lab_pin.sym} 720 450 0 0 {name=l23 sig_type=std_logic lab=l2p}
N 720 530 720 550 {lab=0}
C {devices/lab_pin.sym} 720 550 0 0 {name=l24 sig_type=std_logic lab=0}
C {devices/vsource.sym} 980 500 0 0 {name=VL2N value="0" savecurrent=false}
N 980 470 980 450 {lab=l2n}
C {devices/lab_pin.sym} 980 450 0 0 {name=l25 sig_type=std_logic lab=l2n}
N 980 530 980 550 {lab=0}
C {devices/lab_pin.sym} 980 550 0 0 {name=l26 sig_type=std_logic lab=0}
C {devices/vsource.sym} 1240 500 0 0 {name=VL3P value="2.0" savecurrent=false}
N 1240 470 1240 450 {lab=l3p}
C {devices/lab_pin.sym} 1240 450 0 0 {name=l27 sig_type=std_logic lab=l3p}
N 1240 530 1240 550 {lab=0}
C {devices/lab_pin.sym} 1240 550 0 0 {name=l28 sig_type=std_logic lab=0}
C {devices/vsource.sym} 1500 500 0 0 {name=VL3N value="0" savecurrent=false}
N 1500 470 1500 450 {lab=l3n}
C {devices/lab_pin.sym} 1500 450 0 0 {name=l29 sig_type=std_logic lab=l3n}
N 1500 530 1500 550 {lab=0}
C {devices/lab_pin.sym} 1500 550 0 0 {name=l30 sig_type=std_logic lab=0}
C {devices/vsource.sym} 200 700 0 0 {name=VL4P value="2.0" savecurrent=false}
N 200 670 200 650 {lab=l4p}
C {devices/lab_pin.sym} 200 650 0 0 {name=l31 sig_type=std_logic lab=l4p}
N 200 730 200 750 {lab=0}
C {devices/lab_pin.sym} 200 750 0 0 {name=l32 sig_type=std_logic lab=0}
C {devices/vsource.sym} 460 700 0 0 {name=VL4N value="0" savecurrent=false}
N 460 670 460 650 {lab=l4n}
C {devices/lab_pin.sym} 460 650 0 0 {name=l33 sig_type=std_logic lab=l4n}
N 460 730 460 750 {lab=0}
C {devices/lab_pin.sym} 460 750 0 0 {name=l34 sig_type=std_logic lab=0}
C {mixer_iq.sym} 720 710 0 0 {name=XM }
N 620 610 600 610 {lab=rfp}
C {devices/lab_pin.sym} 600 610 0 0 {name=l35 sig_type=std_logic lab=rfp}
N 620 630 600 630 {lab=rfn}
C {devices/lab_pin.sym} 600 630 0 0 {name=l36 sig_type=std_logic lab=rfn}
N 620 650 600 650 {lab=l1p}
C {devices/lab_pin.sym} 600 650 0 0 {name=l37 sig_type=std_logic lab=l1p}
N 620 670 600 670 {lab=l1n}
C {devices/lab_pin.sym} 600 670 0 0 {name=l38 sig_type=std_logic lab=l1n}
N 620 690 600 690 {lab=l2p}
C {devices/lab_pin.sym} 600 690 0 0 {name=l39 sig_type=std_logic lab=l2p}
N 620 710 600 710 {lab=l2n}
C {devices/lab_pin.sym} 600 710 0 0 {name=l40 sig_type=std_logic lab=l2n}
N 620 730 600 730 {lab=l3p}
C {devices/lab_pin.sym} 600 730 0 0 {name=l41 sig_type=std_logic lab=l3p}
N 620 750 600 750 {lab=l3n}
C {devices/lab_pin.sym} 600 750 0 0 {name=l42 sig_type=std_logic lab=l3n}
N 620 770 600 770 {lab=l4p}
C {devices/lab_pin.sym} 600 770 0 0 {name=l43 sig_type=std_logic lab=l4p}
N 620 790 600 790 {lab=l4n}
C {devices/lab_pin.sym} 600 790 0 0 {name=l44 sig_type=std_logic lab=l4n}
N 620 810 600 810 {lab=nb}
C {devices/lab_pin.sym} 600 810 0 0 {name=l45 sig_type=std_logic lab=nb}
N 820 610 840 610 {lab=ifip}
C {devices/lab_pin.sym} 840 610 0 1 {name=l46 sig_type=std_logic lab=ifip}
N 820 630 840 630 {lab=ifin}
C {devices/lab_pin.sym} 840 630 0 1 {name=l47 sig_type=std_logic lab=ifin}
N 820 650 840 650 {lab=ifqp}
C {devices/lab_pin.sym} 840 650 0 1 {name=l48 sig_type=std_logic lab=ifqp}
N 820 670 840 670 {lab=ifqn}
C {devices/lab_pin.sym} 840 670 0 1 {name=l49 sig_type=std_logic lab=ifqn}
N 820 690 840 690 {lab=vdd}
C {devices/lab_pin.sym} 840 690 0 1 {name=l50 sig_type=std_logic lab=vdd}
N 820 710 840 710 {lab=0}
C {devices/lab_pin.sym} 840 710 0 1 {name=l51 sig_type=std_logic lab=0}
C {devices/code_shown.sym} 1860 300 0 0 {name=MODELS format="tcleval( @value )" only_toplevel=true value=".include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice mimcap_typical"}
C {devices/code_shown.sym} 1860 700 0 0 {name=SIM only_toplevel=true value=".control
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
.endc"}
C {devices/title.sym} 160 1340 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
