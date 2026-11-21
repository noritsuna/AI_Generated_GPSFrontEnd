v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {tb_afc: 8-bit R-2R AFC DAC transfer (load = VCTCXO Vc input, 100 kohm)} 100 80 0 0 0.6 0.6 {}
C {devices/vsource.sym} 200 300 0 0 {name=VDD value="3.3" savecurrent=false}
N 200 270 200 250 {lab=vdd}
C {devices/lab_pin.sym} 200 250 0 0 {name=l1 sig_type=std_logic lab=vdd}
N 200 330 200 350 {lab=0}
C {devices/lab_pin.sym} 200 350 0 0 {name=l2 sig_type=std_logic lab=0}
C {devices/vsource.sym} 460 300 0 0 {name=VD0 value="0" savecurrent=false}
N 460 270 460 250 {lab=d0}
C {devices/lab_pin.sym} 460 250 0 0 {name=l3 sig_type=std_logic lab=d0}
N 460 330 460 350 {lab=0}
C {devices/lab_pin.sym} 460 350 0 0 {name=l4 sig_type=std_logic lab=0}
C {devices/vsource.sym} 720 300 0 0 {name=VD1 value="0" savecurrent=false}
N 720 270 720 250 {lab=d1}
C {devices/lab_pin.sym} 720 250 0 0 {name=l5 sig_type=std_logic lab=d1}
N 720 330 720 350 {lab=0}
C {devices/lab_pin.sym} 720 350 0 0 {name=l6 sig_type=std_logic lab=0}
C {devices/vsource.sym} 980 300 0 0 {name=VD2 value="0" savecurrent=false}
N 980 270 980 250 {lab=d2}
C {devices/lab_pin.sym} 980 250 0 0 {name=l7 sig_type=std_logic lab=d2}
N 980 330 980 350 {lab=0}
C {devices/lab_pin.sym} 980 350 0 0 {name=l8 sig_type=std_logic lab=0}
C {devices/vsource.sym} 1240 300 0 0 {name=VD3 value="0" savecurrent=false}
N 1240 270 1240 250 {lab=d3}
C {devices/lab_pin.sym} 1240 250 0 0 {name=l9 sig_type=std_logic lab=d3}
N 1240 330 1240 350 {lab=0}
C {devices/lab_pin.sym} 1240 350 0 0 {name=l10 sig_type=std_logic lab=0}
C {devices/vsource.sym} 1500 300 0 0 {name=VD4 value="0" savecurrent=false}
N 1500 270 1500 250 {lab=d4}
C {devices/lab_pin.sym} 1500 250 0 0 {name=l11 sig_type=std_logic lab=d4}
N 1500 330 1500 350 {lab=0}
C {devices/lab_pin.sym} 1500 350 0 0 {name=l12 sig_type=std_logic lab=0}
C {devices/vsource.sym} 200 500 0 0 {name=VD5 value="0" savecurrent=false}
N 200 470 200 450 {lab=d5}
C {devices/lab_pin.sym} 200 450 0 0 {name=l13 sig_type=std_logic lab=d5}
N 200 530 200 550 {lab=0}
C {devices/lab_pin.sym} 200 550 0 0 {name=l14 sig_type=std_logic lab=0}
C {devices/vsource.sym} 460 500 0 0 {name=VD6 value="0" savecurrent=false}
N 460 470 460 450 {lab=d6}
C {devices/lab_pin.sym} 460 450 0 0 {name=l15 sig_type=std_logic lab=d6}
N 460 530 460 550 {lab=0}
C {devices/lab_pin.sym} 460 550 0 0 {name=l16 sig_type=std_logic lab=0}
C {devices/vsource.sym} 720 500 0 0 {name=VD7 value="0" savecurrent=false}
N 720 470 720 450 {lab=d7}
C {devices/lab_pin.sym} 720 450 0 0 {name=l17 sig_type=std_logic lab=d7}
N 720 530 720 550 {lab=0}
C {devices/lab_pin.sym} 720 550 0 0 {name=l18 sig_type=std_logic lab=0}
C {afc_dac.sym} 980 500 0 0 {name=XDAC }
N 880 430 860 430 {lab=d0}
C {devices/lab_pin.sym} 860 430 0 0 {name=l19 sig_type=std_logic lab=d0}
N 880 450 860 450 {lab=d1}
C {devices/lab_pin.sym} 860 450 0 0 {name=l20 sig_type=std_logic lab=d1}
N 880 470 860 470 {lab=d2}
C {devices/lab_pin.sym} 860 470 0 0 {name=l21 sig_type=std_logic lab=d2}
N 880 490 860 490 {lab=d3}
C {devices/lab_pin.sym} 860 490 0 0 {name=l22 sig_type=std_logic lab=d3}
N 880 510 860 510 {lab=d4}
C {devices/lab_pin.sym} 860 510 0 0 {name=l23 sig_type=std_logic lab=d4}
N 880 530 860 530 {lab=d5}
C {devices/lab_pin.sym} 860 530 0 0 {name=l24 sig_type=std_logic lab=d5}
N 880 550 860 550 {lab=d6}
C {devices/lab_pin.sym} 860 550 0 0 {name=l25 sig_type=std_logic lab=d6}
N 880 570 860 570 {lab=d7}
C {devices/lab_pin.sym} 860 570 0 0 {name=l26 sig_type=std_logic lab=d7}
N 1080 430 1100 430 {lab=out}
C {devices/lab_pin.sym} 1100 430 0 1 {name=l27 sig_type=std_logic lab=out}
N 1080 450 1100 450 {lab=vdd}
C {devices/lab_pin.sym} 1100 450 0 1 {name=l28 sig_type=std_logic lab=vdd}
N 1080 470 1100 470 {lab=0}
C {devices/lab_pin.sym} 1100 470 0 1 {name=l29 sig_type=std_logic lab=0}
C {devices/res.sym} 1240 500 0 0 {name=RLOAD value=100k footprint=1206 device=resistor m=1}
N 1240 470 1240 450 {lab=out}
C {devices/lab_pin.sym} 1240 450 0 0 {name=l30 sig_type=std_logic lab=out}
N 1240 530 1240 550 {lab=0}
C {devices/lab_pin.sym} 1240 550 0 0 {name=l31 sig_type=std_logic lab=0}
C {devices/code_shown.sym} 1860 300 0 0 {name=MODELS format="tcleval( @value )" only_toplevel=true value=".include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice mimcap_typical"}
C {devices/code_shown.sym} 1860 700 0 0 {name=SIM only_toplevel=true value=".control
set num_threads=1
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 0 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 1 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 2 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 3 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 4 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 5 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 6 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 7 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 8 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 9 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 10 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 11 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 12 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 13 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 14 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 15 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 16 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 17 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 18 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 19 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 20 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 21 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 22 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 23 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 24 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 25 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 26 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 27 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 28 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 29 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 30 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 31 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 32 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 33 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 34 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 35 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 36 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 37 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 38 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 39 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 40 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 41 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 42 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 43 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 44 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 45 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 46 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 47 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 48 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 49 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 50 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 51 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 52 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 53 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 54 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 55 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 56 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 57 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 58 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 59 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 60 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 61 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 62 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 0
op
echo DAC 63 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 64 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 65 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 66 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 67 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 68 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 69 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 70 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 71 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 72 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 73 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 74 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 75 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 76 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 77 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 78 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 79 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 80 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 81 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 82 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 83 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 84 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 85 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 86 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 87 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 88 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 89 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 90 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 91 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 92 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 93 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 94 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 95 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 96 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 97 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 98 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 99 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 100 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 101 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 102 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 103 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 104 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 105 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 106 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 107 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 108 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 109 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 110 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 111 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 112 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 113 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 114 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 115 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 116 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 117 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 118 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 119 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 120 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 121 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 122 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 123 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 124 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 125 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 126 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 0
op
echo DAC 127 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 128 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 129 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 130 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 131 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 132 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 133 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 134 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 135 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 136 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 137 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 138 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 139 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 140 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 141 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 142 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 143 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 144 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 145 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 146 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 147 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 148 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 149 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 150 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 151 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 152 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 153 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 154 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 155 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 156 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 157 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 158 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 159 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 160 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 161 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 162 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 163 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 164 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 165 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 166 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 167 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 168 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 169 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 170 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 171 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 172 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 173 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 174 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 175 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 176 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 177 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 178 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 179 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 180 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 181 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 182 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 183 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 184 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 185 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 186 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 187 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 188 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 189 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 190 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 0
alter VD7 dc = 3.3
op
echo DAC 191 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 192 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 193 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 194 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 195 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 196 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 197 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 198 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 199 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 200 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 201 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 202 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 203 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 204 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 205 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 206 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 207 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 208 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 209 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 210 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 211 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 212 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 213 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 214 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 215 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 216 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 217 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 218 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 219 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 220 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 221 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 222 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 0
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 223 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 224 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 225 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 226 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 227 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 228 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 229 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 230 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 231 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 232 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 233 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 234 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 235 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 236 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 237 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 238 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 0
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 239 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 240 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 241 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 242 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 243 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 244 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 245 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 246 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 0
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 247 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 248 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 249 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 250 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 0
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 251 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 252 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 0
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 253 $&v(out)
alter VD0 dc = 0
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 254 $&v(out)
alter VD0 dc = 3.3
alter VD1 dc = 3.3
alter VD2 dc = 3.3
alter VD3 dc = 3.3
alter VD4 dc = 3.3
alter VD5 dc = 3.3
alter VD6 dc = 3.3
alter VD7 dc = 3.3
op
echo DAC 255 $&v(out)
.endc"}
C {devices/title.sym} 160 1080 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
