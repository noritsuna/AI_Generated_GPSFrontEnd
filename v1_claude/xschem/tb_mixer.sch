v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {tb_mixer: conversion gain, I/Q phase (ideal 8-phase LO/2, 0-2.0 V)} 100 80 0 0 0.6 0.6 {}
T {100-ohm differential RF port, fRF = 1575.42 MHz (GPS L1) -> IF +4.092 MHz} 100 590 0 0 0.4 0.4 {layer=8}
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
C {devices/vsource.sym} 720 300 0 0 {name=VL1P value="pulse(0 2.0 0.000p 60p 60p 576.404p 1272.809p)" savecurrent=false}
N 720 270 720 250 {lab=l1p}
C {devices/lab_pin.sym} 720 250 0 0 {name=l7 sig_type=std_logic lab=l1p}
N 720 330 720 350 {lab=0}
C {devices/lab_pin.sym} 720 350 0 0 {name=l8 sig_type=std_logic lab=0}
C {devices/vsource.sym} 980 300 0 0 {name=VL1N value="pulse(0 2.0 636.404p 60p 60p 576.404p 1272.809p)" savecurrent=false}
N 980 270 980 250 {lab=l1n}
C {devices/lab_pin.sym} 980 250 0 0 {name=l9 sig_type=std_logic lab=l1n}
N 980 330 980 350 {lab=0}
C {devices/lab_pin.sym} 980 350 0 0 {name=l10 sig_type=std_logic lab=0}
C {devices/vsource.sym} 1240 300 0 0 {name=VL2P value="pulse(0 2.0 159.101p 60p 60p 576.404p 1272.809p)" savecurrent=false}
N 1240 270 1240 250 {lab=l2p}
C {devices/lab_pin.sym} 1240 250 0 0 {name=l11 sig_type=std_logic lab=l2p}
N 1240 330 1240 350 {lab=0}
C {devices/lab_pin.sym} 1240 350 0 0 {name=l12 sig_type=std_logic lab=0}
C {devices/vsource.sym} 1500 300 0 0 {name=VL2N value="pulse(0 2.0 795.505p 60p 60p 576.404p 1272.809p)" savecurrent=false}
N 1500 270 1500 250 {lab=l2n}
C {devices/lab_pin.sym} 1500 250 0 0 {name=l13 sig_type=std_logic lab=l2n}
N 1500 330 1500 350 {lab=0}
C {devices/lab_pin.sym} 1500 350 0 0 {name=l14 sig_type=std_logic lab=0}
C {devices/vsource.sym} 200 500 0 0 {name=VL3P value="pulse(0 2.0 318.202p 60p 60p 576.404p 1272.809p)" savecurrent=false}
N 200 470 200 450 {lab=l3p}
C {devices/lab_pin.sym} 200 450 0 0 {name=l15 sig_type=std_logic lab=l3p}
N 200 530 200 550 {lab=0}
C {devices/lab_pin.sym} 200 550 0 0 {name=l16 sig_type=std_logic lab=0}
C {devices/vsource.sym} 460 500 0 0 {name=VL3N value="pulse(0 2.0 954.607p 60p 60p 576.404p 1272.809p)" savecurrent=false}
N 460 470 460 450 {lab=l3n}
C {devices/lab_pin.sym} 460 450 0 0 {name=l17 sig_type=std_logic lab=l3n}
N 460 530 460 550 {lab=0}
C {devices/lab_pin.sym} 460 550 0 0 {name=l18 sig_type=std_logic lab=0}
C {devices/vsource.sym} 720 500 0 0 {name=VL4P value="pulse(0 2.0 477.303p 60p 60p 576.404p 1272.809p)" savecurrent=false}
N 720 470 720 450 {lab=l4p}
C {devices/lab_pin.sym} 720 450 0 0 {name=l19 sig_type=std_logic lab=l4p}
N 720 530 720 550 {lab=0}
C {devices/lab_pin.sym} 720 550 0 0 {name=l20 sig_type=std_logic lab=0}
C {devices/vsource.sym} 980 500 0 0 {name=VL4N value="pulse(0 2.0 1113.708p 60p 60p 576.404p 1272.809p)" savecurrent=false}
N 980 470 980 450 {lab=l4n}
C {devices/lab_pin.sym} 980 450 0 0 {name=l21 sig_type=std_logic lab=l4n}
N 980 530 980 550 {lab=0}
C {devices/lab_pin.sym} 980 550 0 0 {name=l22 sig_type=std_logic lab=0}
C {devices/vsource.sym} 200 700 0 0 {name=VRFP value="sin(0 ARF 1575.42e6 0 0 0)" savecurrent=false}
N 200 670 200 650 {lab=sp}
C {devices/lab_pin.sym} 200 650 0 0 {name=l23 sig_type=std_logic lab=sp}
N 200 730 200 750 {lab=0}
C {devices/lab_pin.sym} 200 750 0 0 {name=l24 sig_type=std_logic lab=0}
C {devices/vsource.sym} 460 700 0 0 {name=VRFN value="sin(0 ARF 1575.42e6 0 0 180)" savecurrent=false}
N 460 670 460 650 {lab=sn}
C {devices/lab_pin.sym} 460 650 0 0 {name=l25 sig_type=std_logic lab=sn}
N 460 730 460 750 {lab=0}
C {devices/lab_pin.sym} 460 750 0 0 {name=l26 sig_type=std_logic lab=0}
C {devices/res.sym} 720 700 0 0 {name=RSP value=50 footprint=1206 device=resistor m=1}
N 720 670 720 650 {lab=sp}
C {devices/lab_pin.sym} 720 650 0 0 {name=l27 sig_type=std_logic lab=sp}
N 720 730 720 750 {lab=rfp_s}
C {devices/lab_pin.sym} 720 750 0 0 {name=l28 sig_type=std_logic lab=rfp_s}
C {devices/res.sym} 980 700 0 0 {name=RSN value=50 footprint=1206 device=resistor m=1}
N 980 670 980 650 {lab=sn}
C {devices/lab_pin.sym} 980 650 0 0 {name=l29 sig_type=std_logic lab=sn}
N 980 730 980 750 {lab=rfn_s}
C {devices/lab_pin.sym} 980 750 0 0 {name=l30 sig_type=std_logic lab=rfn_s}
C {devices/capa.sym} 1240 700 0 0 {name=CCP value=10p footprint=1206 device=capacitor m=1}
N 1240 670 1240 650 {lab=rfp_s}
C {devices/lab_pin.sym} 1240 650 0 0 {name=l31 sig_type=std_logic lab=rfp_s}
N 1240 730 1240 750 {lab=rfp}
C {devices/lab_pin.sym} 1240 750 0 0 {name=l32 sig_type=std_logic lab=rfp}
C {devices/capa.sym} 1500 700 0 0 {name=CCN value=10p footprint=1206 device=capacitor m=1}
N 1500 670 1500 650 {lab=rfn_s}
C {devices/lab_pin.sym} 1500 650 0 0 {name=l33 sig_type=std_logic lab=rfn_s}
N 1500 730 1500 750 {lab=rfn}
C {devices/lab_pin.sym} 1500 750 0 0 {name=l34 sig_type=std_logic lab=rfn}
C {mixer_iq.sym} 200 910 0 0 {name=XM }
N 100 810 80 810 {lab=rfp}
C {devices/lab_pin.sym} 80 810 0 0 {name=l35 sig_type=std_logic lab=rfp}
N 100 830 80 830 {lab=rfn}
C {devices/lab_pin.sym} 80 830 0 0 {name=l36 sig_type=std_logic lab=rfn}
N 100 850 80 850 {lab=l1p}
C {devices/lab_pin.sym} 80 850 0 0 {name=l37 sig_type=std_logic lab=l1p}
N 100 870 80 870 {lab=l1n}
C {devices/lab_pin.sym} 80 870 0 0 {name=l38 sig_type=std_logic lab=l1n}
N 100 890 80 890 {lab=l2p}
C {devices/lab_pin.sym} 80 890 0 0 {name=l39 sig_type=std_logic lab=l2p}
N 100 910 80 910 {lab=l2n}
C {devices/lab_pin.sym} 80 910 0 0 {name=l40 sig_type=std_logic lab=l2n}
N 100 930 80 930 {lab=l3p}
C {devices/lab_pin.sym} 80 930 0 0 {name=l41 sig_type=std_logic lab=l3p}
N 100 950 80 950 {lab=l3n}
C {devices/lab_pin.sym} 80 950 0 0 {name=l42 sig_type=std_logic lab=l3n}
N 100 970 80 970 {lab=l4p}
C {devices/lab_pin.sym} 80 970 0 0 {name=l43 sig_type=std_logic lab=l4p}
N 100 990 80 990 {lab=l4n}
C {devices/lab_pin.sym} 80 990 0 0 {name=l44 sig_type=std_logic lab=l4n}
N 100 1010 80 1010 {lab=nb}
C {devices/lab_pin.sym} 80 1010 0 0 {name=l45 sig_type=std_logic lab=nb}
N 300 810 320 810 {lab=ifip}
C {devices/lab_pin.sym} 320 810 0 1 {name=l46 sig_type=std_logic lab=ifip}
N 300 830 320 830 {lab=ifin}
C {devices/lab_pin.sym} 320 830 0 1 {name=l47 sig_type=std_logic lab=ifin}
N 300 850 320 850 {lab=ifqp}
C {devices/lab_pin.sym} 320 850 0 1 {name=l48 sig_type=std_logic lab=ifqp}
N 300 870 320 870 {lab=ifqn}
C {devices/lab_pin.sym} 320 870 0 1 {name=l49 sig_type=std_logic lab=ifqn}
N 300 890 320 890 {lab=vdd}
C {devices/lab_pin.sym} 320 890 0 1 {name=l50 sig_type=std_logic lab=vdd}
N 300 910 320 910 {lab=0}
C {devices/lab_pin.sym} 320 910 0 1 {name=l51 sig_type=std_logic lab=0}
C {devices/code_shown.sym} 1860 300 0 0 {name=MODELS format="tcleval( @value )" only_toplevel=true value=".include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice mimcap_typical"}
C {devices/code_shown.sym} 1860 700 0 0 {name=SIM only_toplevel=true value=".param arf=1m
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
.endc"}
C {devices/title.sym} 160 1540 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
