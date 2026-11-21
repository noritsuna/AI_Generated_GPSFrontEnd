v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {TSPC positive-edge DFF (9T) for 1.6 GHz prescaler} 100 80 0 0 0.6 0.6 {}
T {stage 1 (p-latch)} 100 190 0 0 0.4 0.4 {layer=8}
T {stage 2 (precharge)} 100 390 0 0 0.4 0.4 {layer=8}
T {stage 3 (evaluate)} 100 590 0 0 0.4 0.4 {layer=8}
T {output inverter} 100 790 0 0 0.4 0.4 {layer=8}
C {devices/ipin.sym} -100 300 0 0 {name=p0 lab=D}
C {devices/ipin.sym} -100 330 0 0 {name=p1 lab=CK}
C {devices/opin.sym} -100 360 0 0 {name=p2 lab=Q}
C {devices/opin.sym} -100 390 0 0 {name=p3 lab=QB}
C {devices/iopin.sym} -100 420 0 0 {name=p4 lab=VDD}
C {devices/iopin.sym} -100 450 0 0 {name=p5 lab=VSS}
C {symbols/pfet_03v3.sym} 200 300 0 0 {name=MP1 L=0.28u W=2u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 220 330 220 350 {lab=a1}
C {devices/lab_pin.sym} 220 350 0 0 {name=l1 sig_type=std_logic lab=a1}
N 180 300 160 300 {lab=D}
C {devices/lab_pin.sym} 160 300 0 0 {name=l2 sig_type=std_logic lab=D}
N 220 270 220 250 {lab=VDD}
C {devices/lab_pin.sym} 220 250 0 0 {name=l3 sig_type=std_logic lab=VDD}
N 220 300 240 300 {lab=VDD}
C {devices/lab_pin.sym} 240 300 0 1 {name=l4 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 460 300 0 0 {name=MP2 L=0.28u W=2u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 480 330 480 350 {lab=x}
C {devices/lab_pin.sym} 480 350 0 0 {name=l5 sig_type=std_logic lab=x}
N 440 300 420 300 {lab=CK}
C {devices/lab_pin.sym} 420 300 0 0 {name=l6 sig_type=std_logic lab=CK}
N 480 270 480 250 {lab=a1}
C {devices/lab_pin.sym} 480 250 0 0 {name=l7 sig_type=std_logic lab=a1}
N 480 300 500 300 {lab=VDD}
C {devices/lab_pin.sym} 500 300 0 1 {name=l8 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 720 300 0 0 {name=MN1 L=0.28u W=1u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 740 270 740 250 {lab=x}
C {devices/lab_pin.sym} 740 250 0 0 {name=l9 sig_type=std_logic lab=x}
N 700 300 680 300 {lab=D}
C {devices/lab_pin.sym} 680 300 0 0 {name=l10 sig_type=std_logic lab=D}
N 740 330 740 350 {lab=VSS}
C {devices/lab_pin.sym} 740 350 0 0 {name=l11 sig_type=std_logic lab=VSS}
N 740 300 760 300 {lab=VSS}
C {devices/lab_pin.sym} 760 300 0 1 {name=l12 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 200 500 0 0 {name=MP3 L=0.28u W=2u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 220 530 220 550 {lab=y}
C {devices/lab_pin.sym} 220 550 0 0 {name=l13 sig_type=std_logic lab=y}
N 180 500 160 500 {lab=CK}
C {devices/lab_pin.sym} 160 500 0 0 {name=l14 sig_type=std_logic lab=CK}
N 220 470 220 450 {lab=VDD}
C {devices/lab_pin.sym} 220 450 0 0 {name=l15 sig_type=std_logic lab=VDD}
N 220 500 240 500 {lab=VDD}
C {devices/lab_pin.sym} 240 500 0 1 {name=l16 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 460 500 0 0 {name=MN2 L=0.28u W=1.5u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 480 470 480 450 {lab=y}
C {devices/lab_pin.sym} 480 450 0 0 {name=l17 sig_type=std_logic lab=y}
N 440 500 420 500 {lab=x}
C {devices/lab_pin.sym} 420 500 0 0 {name=l18 sig_type=std_logic lab=x}
N 480 530 480 550 {lab=b2}
C {devices/lab_pin.sym} 480 550 0 0 {name=l19 sig_type=std_logic lab=b2}
N 480 500 500 500 {lab=VSS}
C {devices/lab_pin.sym} 500 500 0 1 {name=l20 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 720 500 0 0 {name=MN3 L=0.28u W=1.5u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 740 470 740 450 {lab=b2}
C {devices/lab_pin.sym} 740 450 0 0 {name=l21 sig_type=std_logic lab=b2}
N 700 500 680 500 {lab=CK}
C {devices/lab_pin.sym} 680 500 0 0 {name=l22 sig_type=std_logic lab=CK}
N 740 530 740 550 {lab=VSS}
C {devices/lab_pin.sym} 740 550 0 0 {name=l23 sig_type=std_logic lab=VSS}
N 740 500 760 500 {lab=VSS}
C {devices/lab_pin.sym} 760 500 0 1 {name=l24 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 200 700 0 0 {name=MP4 L=0.28u W=3u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 220 730 220 750 {lab=QB}
C {devices/lab_pin.sym} 220 750 0 0 {name=l25 sig_type=std_logic lab=QB}
N 180 700 160 700 {lab=y}
C {devices/lab_pin.sym} 160 700 0 0 {name=l26 sig_type=std_logic lab=y}
N 220 670 220 650 {lab=VDD}
C {devices/lab_pin.sym} 220 650 0 0 {name=l27 sig_type=std_logic lab=VDD}
N 220 700 240 700 {lab=VDD}
C {devices/lab_pin.sym} 240 700 0 1 {name=l28 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 460 700 0 0 {name=MN4 L=0.28u W=1.5u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 480 670 480 650 {lab=QB}
C {devices/lab_pin.sym} 480 650 0 0 {name=l29 sig_type=std_logic lab=QB}
N 440 700 420 700 {lab=CK}
C {devices/lab_pin.sym} 420 700 0 0 {name=l30 sig_type=std_logic lab=CK}
N 480 730 480 750 {lab=c3}
C {devices/lab_pin.sym} 480 750 0 0 {name=l31 sig_type=std_logic lab=c3}
N 480 700 500 700 {lab=VSS}
C {devices/lab_pin.sym} 500 700 0 1 {name=l32 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 720 700 0 0 {name=MN5 L=0.28u W=1.5u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 740 670 740 650 {lab=c3}
C {devices/lab_pin.sym} 740 650 0 0 {name=l33 sig_type=std_logic lab=c3}
N 700 700 680 700 {lab=y}
C {devices/lab_pin.sym} 680 700 0 0 {name=l34 sig_type=std_logic lab=y}
N 740 730 740 750 {lab=VSS}
C {devices/lab_pin.sym} 740 750 0 0 {name=l35 sig_type=std_logic lab=VSS}
N 740 700 760 700 {lab=VSS}
C {devices/lab_pin.sym} 760 700 0 1 {name=l36 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 200 900 0 0 {name=MP5 L=0.28u W=2u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 220 930 220 950 {lab=Q}
C {devices/lab_pin.sym} 220 950 0 0 {name=l37 sig_type=std_logic lab=Q}
N 180 900 160 900 {lab=QB}
C {devices/lab_pin.sym} 160 900 0 0 {name=l38 sig_type=std_logic lab=QB}
N 220 870 220 850 {lab=VDD}
C {devices/lab_pin.sym} 220 850 0 0 {name=l39 sig_type=std_logic lab=VDD}
N 220 900 240 900 {lab=VDD}
C {devices/lab_pin.sym} 240 900 0 1 {name=l40 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 460 900 0 0 {name=MN6 L=0.28u W=1u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 480 870 480 850 {lab=Q}
C {devices/lab_pin.sym} 480 850 0 0 {name=l41 sig_type=std_logic lab=Q}
N 440 900 420 900 {lab=QB}
C {devices/lab_pin.sym} 420 900 0 0 {name=l42 sig_type=std_logic lab=QB}
N 480 930 480 950 {lab=VSS}
C {devices/lab_pin.sym} 480 950 0 0 {name=l43 sig_type=std_logic lab=VSS}
N 480 900 500 900 {lab=VSS}
C {devices/lab_pin.sym} 500 900 0 1 {name=l44 sig_type=std_logic lab=VSS}
C {devices/title.sym} 160 1400 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
