v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {tb_if: IF chain gain / bandwidth / noise for all gain codes} 100 80 0 0 0.6 0.6 {}
T {ADC input load} 100 800 0 0 0.4 0.4 {layer=8}
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
C {devices/vsource.sym} 720 300 0 0 {name=VIP value="dc 2.1 ac 0.5" savecurrent=false}
N 720 270 720 250 {lab=inp}
C {devices/lab_pin.sym} 720 250 0 0 {name=l7 sig_type=std_logic lab=inp}
N 720 330 720 350 {lab=0}
C {devices/lab_pin.sym} 720 350 0 0 {name=l8 sig_type=std_logic lab=0}
C {devices/vsource.sym} 980 300 0 0 {name=VIN value="dc 2.1 ac 0.5 180" savecurrent=false}
N 980 270 980 250 {lab=inn}
C {devices/lab_pin.sym} 980 250 0 0 {name=l9 sig_type=std_logic lab=inn}
N 980 330 980 350 {lab=0}
C {devices/lab_pin.sym} 980 350 0 0 {name=l10 sig_type=std_logic lab=0}
C {devices/vsource.sym} 1240 300 0 0 {name=VG1A value="0" savecurrent=false}
N 1240 270 1240 250 {lab=g1a}
C {devices/lab_pin.sym} 1240 250 0 0 {name=l11 sig_type=std_logic lab=g1a}
N 1240 330 1240 350 {lab=0}
C {devices/lab_pin.sym} 1240 350 0 0 {name=l12 sig_type=std_logic lab=0}
C {devices/vsource.sym} 1500 300 0 0 {name=VG1B value="0" savecurrent=false}
N 1500 270 1500 250 {lab=g1b}
C {devices/lab_pin.sym} 1500 250 0 0 {name=l13 sig_type=std_logic lab=g1b}
N 1500 330 1500 350 {lab=0}
C {devices/lab_pin.sym} 1500 350 0 0 {name=l14 sig_type=std_logic lab=0}
C {devices/vsource.sym} 200 500 0 0 {name=VG2A value="0" savecurrent=false}
N 200 470 200 450 {lab=g2a}
C {devices/lab_pin.sym} 200 450 0 0 {name=l15 sig_type=std_logic lab=g2a}
N 200 530 200 550 {lab=0}
C {devices/lab_pin.sym} 200 550 0 0 {name=l16 sig_type=std_logic lab=0}
C {devices/vsource.sym} 460 500 0 0 {name=VG2B value="0" savecurrent=false}
N 460 470 460 450 {lab=g2b}
C {devices/lab_pin.sym} 460 450 0 0 {name=l17 sig_type=std_logic lab=g2b}
N 460 530 460 550 {lab=0}
C {devices/lab_pin.sym} 460 550 0 0 {name=l18 sig_type=std_logic lab=0}
C {devices/vsource.sym} 720 500 0 0 {name=VG3A value="0" savecurrent=false}
N 720 470 720 450 {lab=g3a}
C {devices/lab_pin.sym} 720 450 0 0 {name=l19 sig_type=std_logic lab=g3a}
N 720 530 720 550 {lab=0}
C {devices/lab_pin.sym} 720 550 0 0 {name=l20 sig_type=std_logic lab=0}
C {devices/vsource.sym} 980 500 0 0 {name=VG3B value="0" savecurrent=false}
N 980 470 980 450 {lab=g3b}
C {devices/lab_pin.sym} 980 450 0 0 {name=l21 sig_type=std_logic lab=g3b}
N 980 530 980 550 {lab=0}
C {devices/lab_pin.sym} 980 550 0 0 {name=l22 sig_type=std_logic lab=0}
C {devices/vsource.sym} 1240 500 0 0 {name=VBWN value="0" savecurrent=false}
N 1240 470 1240 450 {lab=bwn}
C {devices/lab_pin.sym} 1240 450 0 0 {name=l23 sig_type=std_logic lab=bwn}
N 1240 530 1240 550 {lab=0}
C {devices/lab_pin.sym} 1240 550 0 0 {name=l24 sig_type=std_logic lab=0}
C {devices/vsource.sym} 1500 500 0 0 {name=VBWK value="3.3" savecurrent=false}
N 1500 470 1500 450 {lab=bwk}
C {devices/lab_pin.sym} 1500 450 0 0 {name=l25 sig_type=std_logic lab=bwk}
N 1500 530 1500 550 {lab=0}
C {devices/lab_pin.sym} 1500 550 0 0 {name=l26 sig_type=std_logic lab=0}
C {if_chain.sym} 200 710 0 0 {name=XIF }
N 100 610 80 610 {lab=inp}
C {devices/lab_pin.sym} 80 610 0 0 {name=l27 sig_type=std_logic lab=inp}
N 100 630 80 630 {lab=inn}
C {devices/lab_pin.sym} 80 630 0 0 {name=l28 sig_type=std_logic lab=inn}
N 100 650 80 650 {lab=g1a}
C {devices/lab_pin.sym} 80 650 0 0 {name=l29 sig_type=std_logic lab=g1a}
N 100 670 80 670 {lab=g1b}
C {devices/lab_pin.sym} 80 670 0 0 {name=l30 sig_type=std_logic lab=g1b}
N 100 690 80 690 {lab=g2a}
C {devices/lab_pin.sym} 80 690 0 0 {name=l31 sig_type=std_logic lab=g2a}
N 100 710 80 710 {lab=g2b}
C {devices/lab_pin.sym} 80 710 0 0 {name=l32 sig_type=std_logic lab=g2b}
N 100 730 80 730 {lab=g3a}
C {devices/lab_pin.sym} 80 730 0 0 {name=l33 sig_type=std_logic lab=g3a}
N 100 750 80 750 {lab=g3b}
C {devices/lab_pin.sym} 80 750 0 0 {name=l34 sig_type=std_logic lab=g3b}
N 100 770 80 770 {lab=pb}
C {devices/lab_pin.sym} 80 770 0 0 {name=l35 sig_type=std_logic lab=pb}
N 100 790 80 790 {lab=bwk}
C {devices/lab_pin.sym} 80 790 0 0 {name=l36 sig_type=std_logic lab=bwk}
N 100 810 80 810 {lab=bwn}
C {devices/lab_pin.sym} 80 810 0 0 {name=l37 sig_type=std_logic lab=bwn}
N 300 610 320 610 {lab=outp}
C {devices/lab_pin.sym} 320 610 0 1 {name=l38 sig_type=std_logic lab=outp}
N 300 630 320 630 {lab=outn}
C {devices/lab_pin.sym} 320 630 0 1 {name=l39 sig_type=std_logic lab=outn}
N 300 650 320 650 {lab=vdd}
C {devices/lab_pin.sym} 320 650 0 1 {name=l40 sig_type=std_logic lab=vdd}
N 300 670 320 670 {lab=0}
C {devices/lab_pin.sym} 320 670 0 1 {name=l41 sig_type=std_logic lab=0}
C {devices/capa.sym} 200 920 0 0 {name=CLP value=100f footprint=1206 device=capacitor m=1}
N 200 890 200 870 {lab=outp}
C {devices/lab_pin.sym} 200 870 0 0 {name=l42 sig_type=std_logic lab=outp}
N 200 950 200 970 {lab=0}
C {devices/lab_pin.sym} 200 970 0 0 {name=l43 sig_type=std_logic lab=0}
C {devices/capa.sym} 460 920 0 0 {name=CLN value=100f footprint=1206 device=capacitor m=1}
N 460 890 460 870 {lab=outn}
C {devices/lab_pin.sym} 460 870 0 0 {name=l44 sig_type=std_logic lab=outn}
N 460 950 460 970 {lab=0}
C {devices/lab_pin.sym} 460 970 0 0 {name=l45 sig_type=std_logic lab=0}
C {devices/code_shown.sym} 1860 300 0 0 {name=MODELS format="tcleval( @value )" only_toplevel=true value=".include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice mimcap_typical"}
C {devices/code_shown.sym} 1860 700 0 0 {name=SIM only_toplevel=true value=".control
set num_threads=1
op
echo RES op nbif=$&v(xif.nbif) pbif=$&v(xif.pbif) ix=$&v(xif.xbif.x) vdiv=$&v(xif.xbif.vdiv) a1p=$&v(xif.a1p) f1p=$&v(xif.f1p) a2p=$&v(xif.a2p) f2p=$&v(xif.f2p) outp=$&v(outp)
alter VG1A dc = 0
alter VG1B dc = 0
alter VG2A dc = 0
alter VG2B dc = 0
alter VG3A dc = 0
alter VG3B dc = 0
ac dec 40 1e4 1e9
let g = db(v(outp)-v(outn))
meas ac g4 find g at=4.092e6
meas ac g66 find g at=6.6e6
meas ac g112 find g at=11.25e6
meas ac g164 find g at=16.368e6
meas ac gmax max g
let gm3 = gmax - 3
meas ac fl when g=gm3 rise=1
meas ac fh when g=gm3 fall=last
echo RES code=0 g4=$&g4 g6.6=$&g66 g11.25=$&g112 g16.4=$&g164 gmax=$&gmax fl=$&fl fh=$&fh
wrdata if_ac_code0 g
noise v(outp,outn) VIP dec 20 1e5 1e8
setplot noise1
wrdata if_noise_code0 inoise_spectrum onoise_spectrum
alter VG1A dc = 3.3
alter VG1B dc = 0
alter VG2A dc = 3.3
alter VG2B dc = 0
alter VG3A dc = 3.3
alter VG3B dc = 0
ac dec 40 1e4 1e9
let g = db(v(outp)-v(outn))
meas ac g4 find g at=4.092e6
meas ac g66 find g at=6.6e6
meas ac g112 find g at=11.25e6
meas ac g164 find g at=16.368e6
meas ac gmax max g
let gm3 = gmax - 3
meas ac fl when g=gm3 rise=1
meas ac fh when g=gm3 fall=last
echo RES code=1 g4=$&g4 g6.6=$&g66 g11.25=$&g112 g16.4=$&g164 gmax=$&gmax fl=$&fl fh=$&fh
wrdata if_ac_code1 g
noise v(outp,outn) VIP dec 20 1e5 1e8
setplot noise3
wrdata if_noise_code1 inoise_spectrum onoise_spectrum
alter VG1A dc = 0
alter VG1B dc = 3.3
alter VG2A dc = 0
alter VG2B dc = 3.3
alter VG3A dc = 0
alter VG3B dc = 3.3
ac dec 40 1e4 1e9
let g = db(v(outp)-v(outn))
meas ac g4 find g at=4.092e6
meas ac g66 find g at=6.6e6
meas ac g112 find g at=11.25e6
meas ac g164 find g at=16.368e6
meas ac gmax max g
let gm3 = gmax - 3
meas ac fl when g=gm3 rise=1
meas ac fh when g=gm3 fall=last
echo RES code=2 g4=$&g4 g6.6=$&g66 g11.25=$&g112 g16.4=$&g164 gmax=$&gmax fl=$&fl fh=$&fh
wrdata if_ac_code2 g
noise v(outp,outn) VIP dec 20 1e5 1e8
setplot noise5
wrdata if_noise_code2 inoise_spectrum onoise_spectrum
alter VG1A dc = 3.3
alter VG1B dc = 3.3
alter VG2A dc = 3.3
alter VG2B dc = 3.3
alter VG3A dc = 3.3
alter VG3B dc = 3.3
ac dec 40 1e4 1e9
let g = db(v(outp)-v(outn))
meas ac g4 find g at=4.092e6
meas ac g66 find g at=6.6e6
meas ac g112 find g at=11.25e6
meas ac g164 find g at=16.368e6
meas ac gmax max g
let gm3 = gmax - 3
meas ac fl when g=gm3 rise=1
meas ac fh when g=gm3 fall=last
echo RES code=3 g4=$&g4 g6.6=$&g66 g11.25=$&g112 g16.4=$&g164 gmax=$&gmax fl=$&fl fh=$&fh
wrdata if_ac_code3 g
noise v(outp,outn) VIP dec 20 1e5 1e8
setplot noise7
wrdata if_noise_code3 inoise_spectrum onoise_spectrum
.endc"}
C {devices/title.sym} 160 1410 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
