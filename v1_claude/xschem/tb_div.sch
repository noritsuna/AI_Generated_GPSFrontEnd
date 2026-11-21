v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {tb_div: LO buffer + /96 divider (TSPC) at 1571.328 MHz; FS = FB = /96 = 16.368 MHz} 100 80 0 0 0.6 0.6 {}
C {devices/vsource.sym} 200 300 0 0 {name=VDD value="3.3" savecurrent=false}
N 200 270 200 250 {lab=vdd}
C {devices/lab_pin.sym} 200 250 0 0 {name=l1 sig_type=std_logic lab=vdd}
N 200 330 200 350 {lab=0}
C {devices/lab_pin.sym} 200 350 0 0 {name=l2 sig_type=std_logic lab=0}
C {devices/vsource.sym} 460 300 0 0 {name=VLO value="pulse(0 2.3 0 60p 60p 258.202p 636.404p)" savecurrent=false}
N 460 270 460 250 {lab=lo}
C {devices/lab_pin.sym} 460 250 0 0 {name=l3 sig_type=std_logic lab=lo}
N 460 330 460 350 {lab=0}
C {devices/lab_pin.sym} 460 350 0 0 {name=l4 sig_type=std_logic lab=0}
C {divbuf.sym} 720 300 0 0 {name=XDB }
N 620 280 600 280 {lab=lo}
C {devices/lab_pin.sym} 600 280 0 0 {name=l5 sig_type=std_logic lab=lo}
N 820 280 840 280 {lab=ck}
C {devices/lab_pin.sym} 840 280 0 1 {name=l6 sig_type=std_logic lab=ck}
N 820 300 840 300 {lab=vdd}
C {devices/lab_pin.sym} 840 300 0 1 {name=l7 sig_type=std_logic lab=vdd}
N 820 320 840 320 {lab=0}
C {devices/lab_pin.sym} 840 320 0 1 {name=l8 sig_type=std_logic lab=0}
C {div96.sym} 980 300 0 0 {name=XDIV }
N 880 270 860 270 {lab=ck}
C {devices/lab_pin.sym} 860 270 0 0 {name=l9 sig_type=std_logic lab=ck}
N 1080 270 1100 270 {lab=fs}
C {devices/lab_pin.sym} 1100 270 0 1 {name=l10 sig_type=std_logic lab=fs}
N 1080 290 1100 290 {lab=fb}
C {devices/lab_pin.sym} 1100 290 0 1 {name=l11 sig_type=std_logic lab=fb}
N 1080 310 1100 310 {lab=vdd}
C {devices/lab_pin.sym} 1100 310 0 1 {name=l12 sig_type=std_logic lab=vdd}
N 1080 330 1100 330 {lab=0}
C {devices/lab_pin.sym} 1100 330 0 1 {name=l13 sig_type=std_logic lab=0}
C {devices/capa.sym} 1240 300 0 0 {name=CFS value=200f footprint=1206 device=capacitor m=1}
N 1240 270 1240 250 {lab=fs}
C {devices/lab_pin.sym} 1240 250 0 0 {name=l14 sig_type=std_logic lab=fs}
N 1240 330 1240 350 {lab=0}
C {devices/lab_pin.sym} 1240 350 0 0 {name=l15 sig_type=std_logic lab=0}
C {devices/capa.sym} 1500 300 0 0 {name=CFB value=50f footprint=1206 device=capacitor m=1}
N 1500 270 1500 250 {lab=fb}
C {devices/lab_pin.sym} 1500 250 0 0 {name=l16 sig_type=std_logic lab=fb}
N 1500 330 1500 350 {lab=0}
C {devices/lab_pin.sym} 1500 350 0 0 {name=l17 sig_type=std_logic lab=0}
C {devices/code_shown.sym} 1860 300 0 0 {name=MODELS format="tcleval( @value )" only_toplevel=true value=".include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice mimcap_typical"}
C {devices/code_shown.sym} 1860 700 0 0 {name=SIM only_toplevel=true value=".option method=gear
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
.endc"}
C {devices/title.sym} 160 800 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
