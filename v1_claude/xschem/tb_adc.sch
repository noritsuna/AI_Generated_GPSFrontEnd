v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {tb_adc: 2-bit ADC thresholds (slow ramp) at fs = 16.368 MHz} 100 80 0 0 0.6 0.6 {}
C {devices/vsource.sym} 200 300 0 0 {name=VDD value="3.3" savecurrent=false}
N 200 270 200 250 {lab=vdd}
C {devices/lab_pin.sym} 200 250 0 0 {name=l1 sig_type=std_logic lab=vdd}
N 200 330 200 350 {lab=0}
C {devices/lab_pin.sym} 200 350 0 0 {name=l2 sig_type=std_logic lab=0}
C {devices/vsource.sym} 460 300 0 0 {name=VCK value="pulse(0 3.3 0 0.2n 0.2n 30.3474n 61.0948n)" savecurrent=false}
N 460 270 460 250 {lab=clk}
C {devices/lab_pin.sym} 460 250 0 0 {name=l3 sig_type=std_logic lab=clk}
N 460 330 460 350 {lab=0}
C {devices/lab_pin.sym} 460 350 0 0 {name=l4 sig_type=std_logic lab=0}
C {devices/vsource.sym} 720 300 0 0 {name=VIP value="pwl(0 1.0 10u 1.4)" savecurrent=false}
N 720 270 720 250 {lab=inp}
C {devices/lab_pin.sym} 720 250 0 0 {name=l5 sig_type=std_logic lab=inp}
N 720 330 720 350 {lab=0}
C {devices/lab_pin.sym} 720 350 0 0 {name=l6 sig_type=std_logic lab=0}
C {devices/vsource.sym} 980 300 0 0 {name=VIN value="pwl(0 1.4 10u 1.0)" savecurrent=false}
N 980 270 980 250 {lab=inn}
C {devices/lab_pin.sym} 980 250 0 0 {name=l7 sig_type=std_logic lab=inn}
N 980 330 980 350 {lab=0}
C {devices/lab_pin.sym} 980 350 0 0 {name=l8 sig_type=std_logic lab=0}
C {adc2b.sym} 1240 300 0 0 {name=XA }
N 1140 270 1120 270 {lab=inp}
C {devices/lab_pin.sym} 1120 270 0 0 {name=l9 sig_type=std_logic lab=inp}
N 1140 290 1120 290 {lab=inn}
C {devices/lab_pin.sym} 1120 290 0 0 {name=l10 sig_type=std_logic lab=inn}
N 1140 310 1120 310 {lab=clk}
C {devices/lab_pin.sym} 1120 310 0 0 {name=l11 sig_type=std_logic lab=clk}
N 1340 270 1360 270 {lab=sign}
C {devices/lab_pin.sym} 1360 270 0 1 {name=l12 sig_type=std_logic lab=sign}
N 1340 290 1360 290 {lab=mag}
C {devices/lab_pin.sym} 1360 290 0 1 {name=l13 sig_type=std_logic lab=mag}
N 1340 310 1360 310 {lab=vdd}
C {devices/lab_pin.sym} 1360 310 0 1 {name=l14 sig_type=std_logic lab=vdd}
N 1340 330 1360 330 {lab=0}
C {devices/lab_pin.sym} 1360 330 0 1 {name=l15 sig_type=std_logic lab=0}
C {devices/capa.sym} 1500 300 0 0 {name=C1 value=50f footprint=1206 device=capacitor m=1}
N 1500 270 1500 250 {lab=sign}
C {devices/lab_pin.sym} 1500 250 0 0 {name=l16 sig_type=std_logic lab=sign}
N 1500 330 1500 350 {lab=0}
C {devices/lab_pin.sym} 1500 350 0 0 {name=l17 sig_type=std_logic lab=0}
C {devices/capa.sym} 200 500 0 0 {name=C2 value=50f footprint=1206 device=capacitor m=1}
N 200 470 200 450 {lab=mag}
C {devices/lab_pin.sym} 200 450 0 0 {name=l18 sig_type=std_logic lab=mag}
N 200 530 200 550 {lab=0}
C {devices/lab_pin.sym} 200 550 0 0 {name=l19 sig_type=std_logic lab=0}
C {devices/code_shown.sym} 1860 300 0 0 {name=MODELS format="tcleval( @value )" only_toplevel=true value=".include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice mimcap_typical"}
C {devices/code_shown.sym} 1860 700 0 0 {name=SIM only_toplevel=true value=".control
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
.endc"}
C {devices/title.sym} 160 1000 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
