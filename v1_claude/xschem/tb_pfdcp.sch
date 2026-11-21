v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {tb_pfdcp: PFD + charge pump transfer (avg Icp vs phase error), Vctrl held at 1.9 V} 100 80 0 0 0.6 0.6 {}
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
C {devices/vsource.sym} 720 300 0 0 {name=VREF value="pulse(0 3.3 10n 0.3n 0.3n 30.2474n 61.0948n)" savecurrent=false}
N 720 270 720 250 {lab=ref}
C {devices/lab_pin.sym} 720 250 0 0 {name=l7 sig_type=std_logic lab=ref}
N 720 330 720 350 {lab=0}
C {devices/lab_pin.sym} 720 350 0 0 {name=l8 sig_type=std_logic lab=0}
C {devices/vsource.sym} 980 300 0 0 {name=VFB value="pulse(0 3.3 DLYn 0.3n 0.3n 30.2474n 61.0948n)" savecurrent=false}
N 980 270 980 250 {lab=fb}
C {devices/lab_pin.sym} 980 250 0 0 {name=l9 sig_type=std_logic lab=fb}
N 980 330 980 350 {lab=0}
C {devices/lab_pin.sym} 980 350 0 0 {name=l10 sig_type=std_logic lab=0}
C {pfd.sym} 1240 300 0 0 {name=XP }
N 1140 250 1120 250 {lab=ref}
C {devices/lab_pin.sym} 1120 250 0 0 {name=l11 sig_type=std_logic lab=ref}
N 1140 270 1120 270 {lab=fb}
C {devices/lab_pin.sym} 1120 270 0 0 {name=l12 sig_type=std_logic lab=fb}
N 1340 250 1360 250 {lab=up}
C {devices/lab_pin.sym} 1360 250 0 1 {name=l13 sig_type=std_logic lab=up}
N 1340 270 1360 270 {lab=upb}
C {devices/lab_pin.sym} 1360 270 0 1 {name=l14 sig_type=std_logic lab=upb}
N 1340 290 1360 290 {lab=dn}
C {devices/lab_pin.sym} 1360 290 0 1 {name=l15 sig_type=std_logic lab=dn}
N 1340 310 1360 310 {lab=dnb}
C {devices/lab_pin.sym} 1360 310 0 1 {name=l16 sig_type=std_logic lab=dnb}
N 1340 330 1360 330 {lab=vdd}
C {devices/lab_pin.sym} 1360 330 0 1 {name=l17 sig_type=std_logic lab=vdd}
N 1340 350 1360 350 {lab=0}
C {devices/lab_pin.sym} 1360 350 0 1 {name=l18 sig_type=std_logic lab=0}
C {cp.sym} 1500 300 0 0 {name=XC }
N 1400 250 1380 250 {lab=upb}
C {devices/lab_pin.sym} 1380 250 0 0 {name=l19 sig_type=std_logic lab=upb}
N 1400 270 1380 270 {lab=dn}
C {devices/lab_pin.sym} 1380 270 0 0 {name=l20 sig_type=std_logic lab=dn}
N 1400 290 1380 290 {lab=dnb}
C {devices/lab_pin.sym} 1380 290 0 0 {name=l21 sig_type=std_logic lab=dnb}
N 1400 310 1380 310 {lab=pb}
C {devices/lab_pin.sym} 1380 310 0 0 {name=l22 sig_type=std_logic lab=pb}
N 1400 330 1380 330 {lab=nb}
C {devices/lab_pin.sym} 1380 330 0 0 {name=l23 sig_type=std_logic lab=nb}
N 1400 350 1380 350 {lab=hi}
C {devices/lab_pin.sym} 1380 350 0 0 {name=l24 sig_type=std_logic lab=hi}
N 1600 250 1620 250 {lab=vc}
C {devices/lab_pin.sym} 1620 250 0 1 {name=l25 sig_type=std_logic lab=vc}
N 1600 270 1620 270 {lab=vdd}
C {devices/lab_pin.sym} 1620 270 0 1 {name=l26 sig_type=std_logic lab=vdd}
N 1600 290 1620 290 {lab=0}
C {devices/lab_pin.sym} 1620 290 0 1 {name=l27 sig_type=std_logic lab=0}
C {devices/vsource.sym} 200 500 0 0 {name=VHI value="0" savecurrent=false}
N 200 470 200 450 {lab=hi}
C {devices/lab_pin.sym} 200 450 0 0 {name=l28 sig_type=std_logic lab=hi}
N 200 530 200 550 {lab=0}
C {devices/lab_pin.sym} 200 550 0 0 {name=l29 sig_type=std_logic lab=0}
C {devices/vsource.sym} 460 500 0 0 {name=VC value="1.9" savecurrent=false}
N 460 470 460 450 {lab=vc}
C {devices/lab_pin.sym} 460 450 0 0 {name=l30 sig_type=std_logic lab=vc}
N 460 530 460 550 {lab=0}
C {devices/lab_pin.sym} 460 550 0 0 {name=l31 sig_type=std_logic lab=0}
C {devices/code_shown.sym} 1860 300 0 0 {name=MODELS format="tcleval( @value )" only_toplevel=true value=".include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice mimcap_typical"}
C {devices/code_shown.sym} 1860 700 0 0 {name=SIM only_toplevel=true value=".option method=gear
.control
set num_threads=1
tran 10p 400n
meas tran q integ i(VC) from=132.1896n to=376.5689n
let iavg = -q/(244.3793n)
meas tran upw when v(up)=1.65 rise=8
meas tran upf when v(up)=1.65 fall=8
echo RES dly=DLY iavg=$&iavg
.endc"}
C {devices/title.sym} 160 1000 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
