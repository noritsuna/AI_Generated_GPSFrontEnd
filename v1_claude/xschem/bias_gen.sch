v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {Constant-gm bias, 50 uA unit} 100 80 0 0 0.6 0.6 {}
T {core} 100 190 0 0 0.4 0.4 {layer=8}
T {start-up} 100 390 0 0 0.4 0.4 {layer=8}
T {low-Vov distribution diodes} 100 590 0 0 0.4 0.4 {layer=8}
C {devices/opin.sym} -100 300 0 0 {name=p0 lab=NB}
C {devices/opin.sym} -100 330 0 0 {name=p1 lab=PB}
C {devices/iopin.sym} -100 360 0 0 {name=p2 lab=VDD}
C {devices/iopin.sym} -100 390 0 0 {name=p3 lab=VSS}
C {symbols/nfet_03v3.sym} 200 300 0 0 {name=MN1 L=2u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 270 220 250 {lab=nbc}
C {devices/lab_pin.sym} 220 250 0 0 {name=l1 sig_type=std_logic lab=nbc}
N 180 300 160 300 {lab=nbc}
C {devices/lab_pin.sym} 160 300 0 0 {name=l2 sig_type=std_logic lab=nbc}
N 220 330 220 350 {lab=VSS}
C {devices/lab_pin.sym} 220 350 0 0 {name=l3 sig_type=std_logic lab=VSS}
N 220 300 240 300 {lab=VSS}
C {devices/lab_pin.sym} 240 300 0 1 {name=l4 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 460 300 0 0 {name=MN2 L=2u W=16u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 480 270 480 250 {lab=pbc}
C {devices/lab_pin.sym} 480 250 0 0 {name=l5 sig_type=std_logic lab=pbc}
N 440 300 420 300 {lab=nbc}
C {devices/lab_pin.sym} 420 300 0 0 {name=l6 sig_type=std_logic lab=nbc}
N 480 330 480 350 {lab=nr}
C {devices/lab_pin.sym} 480 350 0 0 {name=l7 sig_type=std_logic lab=nr}
N 480 300 500 300 {lab=VSS}
C {devices/lab_pin.sym} 500 300 0 1 {name=l8 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 720 300 0 0 {name=RB W=1u L=4.6u model=ppolyf_u_1k spiceprefix=X m=1}
N 720 330 720 350 {lab=VSS}
C {devices/lab_pin.sym} 720 350 0 0 {name=l9 sig_type=std_logic lab=VSS}
N 720 270 720 250 {lab=nr}
C {devices/lab_pin.sym} 720 250 0 0 {name=l10 sig_type=std_logic lab=nr}
N 700 300 680 300 {lab=VSS}
C {devices/lab_pin.sym} 680 300 0 0 {name=l11 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 980 300 0 0 {name=MP1 L=2u W=8u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1000 330 1000 350 {lab=nbc}
C {devices/lab_pin.sym} 1000 350 0 0 {name=l12 sig_type=std_logic lab=nbc}
N 960 300 940 300 {lab=pbc}
C {devices/lab_pin.sym} 940 300 0 0 {name=l13 sig_type=std_logic lab=pbc}
N 1000 270 1000 250 {lab=VDD}
C {devices/lab_pin.sym} 1000 250 0 0 {name=l14 sig_type=std_logic lab=VDD}
N 1000 300 1020 300 {lab=VDD}
C {devices/lab_pin.sym} 1020 300 0 1 {name=l15 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 1240 300 0 0 {name=MP2 L=2u W=8u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1260 330 1260 350 {lab=pbc}
C {devices/lab_pin.sym} 1260 350 0 0 {name=l16 sig_type=std_logic lab=pbc}
N 1220 300 1200 300 {lab=pbc}
C {devices/lab_pin.sym} 1200 300 0 0 {name=l17 sig_type=std_logic lab=pbc}
N 1260 270 1260 250 {lab=VDD}
C {devices/lab_pin.sym} 1260 250 0 0 {name=l18 sig_type=std_logic lab=VDD}
N 1260 300 1280 300 {lab=VDD}
C {devices/lab_pin.sym} 1280 300 0 1 {name=l19 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 200 500 0 0 {name=MSP L=20u W=1u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 220 530 220 550 {lab=st}
C {devices/lab_pin.sym} 220 550 0 0 {name=l20 sig_type=std_logic lab=st}
N 180 500 160 500 {lab=VSS}
C {devices/lab_pin.sym} 160 500 0 0 {name=l21 sig_type=std_logic lab=VSS}
N 220 470 220 450 {lab=VDD}
C {devices/lab_pin.sym} 220 450 0 0 {name=l22 sig_type=std_logic lab=VDD}
N 220 500 240 500 {lab=VDD}
C {devices/lab_pin.sym} 240 500 0 1 {name=l23 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 460 500 0 0 {name=MSN L=1u W=2u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 480 470 480 450 {lab=st}
C {devices/lab_pin.sym} 480 450 0 0 {name=l24 sig_type=std_logic lab=st}
N 440 500 420 500 {lab=nbc}
C {devices/lab_pin.sym} 420 500 0 0 {name=l25 sig_type=std_logic lab=nbc}
N 480 530 480 550 {lab=VSS}
C {devices/lab_pin.sym} 480 550 0 0 {name=l26 sig_type=std_logic lab=VSS}
N 480 500 500 500 {lab=VSS}
C {devices/lab_pin.sym} 500 500 0 1 {name=l27 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 720 500 0 0 {name=MSU L=1u W=1u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 740 470 740 450 {lab=pbc}
C {devices/lab_pin.sym} 740 450 0 0 {name=l28 sig_type=std_logic lab=pbc}
N 700 500 680 500 {lab=st}
C {devices/lab_pin.sym} 680 500 0 0 {name=l29 sig_type=std_logic lab=st}
N 740 530 740 550 {lab=VSS}
C {devices/lab_pin.sym} 740 550 0 0 {name=l30 sig_type=std_logic lab=VSS}
N 740 500 760 500 {lab=VSS}
C {devices/lab_pin.sym} 760 500 0 1 {name=l31 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 200 700 0 0 {name=MP3 L=2u W=8u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 220 730 220 750 {lab=NB}
C {devices/lab_pin.sym} 220 750 0 0 {name=l32 sig_type=std_logic lab=NB}
N 180 700 160 700 {lab=pbc}
C {devices/lab_pin.sym} 160 700 0 0 {name=l33 sig_type=std_logic lab=pbc}
N 220 670 220 650 {lab=VDD}
C {devices/lab_pin.sym} 220 650 0 0 {name=l34 sig_type=std_logic lab=VDD}
N 220 700 240 700 {lab=VDD}
C {devices/lab_pin.sym} 240 700 0 1 {name=l35 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 460 700 0 0 {name=MN3 L=2u W=16u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 480 670 480 650 {lab=NB}
C {devices/lab_pin.sym} 480 650 0 0 {name=l36 sig_type=std_logic lab=NB}
N 440 700 420 700 {lab=NB}
C {devices/lab_pin.sym} 420 700 0 0 {name=l37 sig_type=std_logic lab=NB}
N 480 730 480 750 {lab=VSS}
C {devices/lab_pin.sym} 480 750 0 0 {name=l38 sig_type=std_logic lab=VSS}
N 480 700 500 700 {lab=VSS}
C {devices/lab_pin.sym} 500 700 0 1 {name=l39 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 720 700 0 0 {name=MN4 L=2u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 740 670 740 650 {lab=PB}
C {devices/lab_pin.sym} 740 650 0 0 {name=l40 sig_type=std_logic lab=PB}
N 700 700 680 700 {lab=nbc}
C {devices/lab_pin.sym} 680 700 0 0 {name=l41 sig_type=std_logic lab=nbc}
N 740 730 740 750 {lab=VSS}
C {devices/lab_pin.sym} 740 750 0 0 {name=l42 sig_type=std_logic lab=VSS}
N 740 700 760 700 {lab=VSS}
C {devices/lab_pin.sym} 760 700 0 1 {name=l43 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 980 700 0 0 {name=MP4 L=2u W=32u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1000 730 1000 750 {lab=PB}
C {devices/lab_pin.sym} 1000 750 0 0 {name=l44 sig_type=std_logic lab=PB}
N 960 700 940 700 {lab=PB}
C {devices/lab_pin.sym} 940 700 0 0 {name=l45 sig_type=std_logic lab=PB}
N 1000 670 1000 650 {lab=VDD}
C {devices/lab_pin.sym} 1000 650 0 0 {name=l46 sig_type=std_logic lab=VDD}
N 1000 700 1020 700 {lab=VDD}
C {devices/lab_pin.sym} 1020 700 0 1 {name=l47 sig_type=std_logic lab=VDD}
C {symbols/cap_mim_2f0fF.sym} 1240 700 0 0 {name=CNB W=20e-6 L=20e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 1240 670 1240 650 {lab=NB}
C {devices/lab_pin.sym} 1240 650 0 0 {name=l48 sig_type=std_logic lab=NB}
N 1240 730 1240 750 {lab=VSS}
C {devices/lab_pin.sym} 1240 750 0 0 {name=l49 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 1500 700 0 0 {name=CPB W=20e-6 L=20e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 1500 670 1500 650 {lab=VDD}
C {devices/lab_pin.sym} 1500 650 0 0 {name=l50 sig_type=std_logic lab=VDD}
N 1500 730 1500 750 {lab=PB}
C {devices/lab_pin.sym} 1500 750 0 0 {name=l51 sig_type=std_logic lab=PB}
C {devices/title.sym} 160 1200 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
