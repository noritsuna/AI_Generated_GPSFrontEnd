v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {LO edge combiner: 8 phases at 785.7 MHz -> I/Q 1571 MHz} 100 80 0 0 0.6 0.6 {}
T {level shifters VR -> VDD} 100 190 0 0 0.4 0.4 {layer=8}
T {phase buffers: g<p> = !yn = p, g<n> = !yp = n} 100 990 0 0 0.4 0.4 {layer=8}
T {combiner IP} 100 1790 0 0 0.4 0.4 {layer=8}
T {combiner IN} 100 2390 0 0 0.4 0.4 {layer=8}
T {combiner QP} 100 2990 0 0 0.4 0.4 {layer=8}
T {combiner QN} 100 3590 0 0 0.4 0.4 {layer=8}
C {devices/ipin.sym} -100 300 0 0 {name=p0 lab=ap1}
C {devices/ipin.sym} -100 330 0 0 {name=p1 lab=an1}
C {devices/ipin.sym} -100 360 0 0 {name=p2 lab=ap2}
C {devices/ipin.sym} -100 390 0 0 {name=p3 lab=an2}
C {devices/ipin.sym} -100 420 0 0 {name=p4 lab=ap3}
C {devices/ipin.sym} -100 450 0 0 {name=p5 lab=an3}
C {devices/ipin.sym} -100 480 0 0 {name=p6 lab=ap4}
C {devices/ipin.sym} -100 510 0 0 {name=p7 lab=an4}
C {devices/opin.sym} -100 540 0 0 {name=p8 lab=LOIP}
C {devices/opin.sym} -100 570 0 0 {name=p9 lab=LOIN}
C {devices/opin.sym} -100 600 0 0 {name=p10 lab=LOQP}
C {devices/opin.sym} -100 630 0 0 {name=p11 lab=LOQN}
C {devices/iopin.sym} -100 660 0 0 {name=p12 lab=VDD}
C {devices/iopin.sym} -100 690 0 0 {name=p13 lab=VSS}
C {symbols/nfet_03v3.sym} 200 300 0 0 {name=MSNp1 L=0.28u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 270 220 250 {lab=yp1}
C {devices/lab_pin.sym} 220 250 0 0 {name=l1 sig_type=std_logic lab=yp1}
N 180 300 160 300 {lab=ap1}
C {devices/lab_pin.sym} 160 300 0 0 {name=l2 sig_type=std_logic lab=ap1}
N 220 330 220 350 {lab=VSS}
C {devices/lab_pin.sym} 220 350 0 0 {name=l3 sig_type=std_logic lab=VSS}
N 220 300 240 300 {lab=VSS}
C {devices/lab_pin.sym} 240 300 0 1 {name=l4 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 500 300 0 0 {name=MSNn1 L=0.28u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 520 270 520 250 {lab=yn1}
C {devices/lab_pin.sym} 520 250 0 0 {name=l5 sig_type=std_logic lab=yn1}
N 480 300 460 300 {lab=an1}
C {devices/lab_pin.sym} 460 300 0 0 {name=l6 sig_type=std_logic lab=an1}
N 520 330 520 350 {lab=VSS}
C {devices/lab_pin.sym} 520 350 0 0 {name=l7 sig_type=std_logic lab=VSS}
N 520 300 540 300 {lab=VSS}
C {devices/lab_pin.sym} 540 300 0 1 {name=l8 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 800 300 0 0 {name=MSPp1 L=0.28u W=1u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 820 330 820 350 {lab=yp1}
C {devices/lab_pin.sym} 820 350 0 0 {name=l9 sig_type=std_logic lab=yp1}
N 780 300 760 300 {lab=yn1}
C {devices/lab_pin.sym} 760 300 0 0 {name=l10 sig_type=std_logic lab=yn1}
N 820 270 820 250 {lab=VDD}
C {devices/lab_pin.sym} 820 250 0 0 {name=l11 sig_type=std_logic lab=VDD}
N 820 300 840 300 {lab=VDD}
C {devices/lab_pin.sym} 840 300 0 1 {name=l12 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 1100 300 0 0 {name=MSPn1 L=0.28u W=1u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1120 330 1120 350 {lab=yn1}
C {devices/lab_pin.sym} 1120 350 0 0 {name=l13 sig_type=std_logic lab=yn1}
N 1080 300 1060 300 {lab=yp1}
C {devices/lab_pin.sym} 1060 300 0 0 {name=l14 sig_type=std_logic lab=yp1}
N 1120 270 1120 250 {lab=VDD}
C {devices/lab_pin.sym} 1120 250 0 0 {name=l15 sig_type=std_logic lab=VDD}
N 1120 300 1140 300 {lab=VDD}
C {devices/lab_pin.sym} 1140 300 0 1 {name=l16 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 200 500 0 0 {name=MSNp2 L=0.28u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 470 220 450 {lab=yp2}
C {devices/lab_pin.sym} 220 450 0 0 {name=l17 sig_type=std_logic lab=yp2}
N 180 500 160 500 {lab=ap2}
C {devices/lab_pin.sym} 160 500 0 0 {name=l18 sig_type=std_logic lab=ap2}
N 220 530 220 550 {lab=VSS}
C {devices/lab_pin.sym} 220 550 0 0 {name=l19 sig_type=std_logic lab=VSS}
N 220 500 240 500 {lab=VSS}
C {devices/lab_pin.sym} 240 500 0 1 {name=l20 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 500 500 0 0 {name=MSNn2 L=0.28u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 520 470 520 450 {lab=yn2}
C {devices/lab_pin.sym} 520 450 0 0 {name=l21 sig_type=std_logic lab=yn2}
N 480 500 460 500 {lab=an2}
C {devices/lab_pin.sym} 460 500 0 0 {name=l22 sig_type=std_logic lab=an2}
N 520 530 520 550 {lab=VSS}
C {devices/lab_pin.sym} 520 550 0 0 {name=l23 sig_type=std_logic lab=VSS}
N 520 500 540 500 {lab=VSS}
C {devices/lab_pin.sym} 540 500 0 1 {name=l24 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 800 500 0 0 {name=MSPp2 L=0.28u W=1u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 820 530 820 550 {lab=yp2}
C {devices/lab_pin.sym} 820 550 0 0 {name=l25 sig_type=std_logic lab=yp2}
N 780 500 760 500 {lab=yn2}
C {devices/lab_pin.sym} 760 500 0 0 {name=l26 sig_type=std_logic lab=yn2}
N 820 470 820 450 {lab=VDD}
C {devices/lab_pin.sym} 820 450 0 0 {name=l27 sig_type=std_logic lab=VDD}
N 820 500 840 500 {lab=VDD}
C {devices/lab_pin.sym} 840 500 0 1 {name=l28 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 1100 500 0 0 {name=MSPn2 L=0.28u W=1u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1120 530 1120 550 {lab=yn2}
C {devices/lab_pin.sym} 1120 550 0 0 {name=l29 sig_type=std_logic lab=yn2}
N 1080 500 1060 500 {lab=yp2}
C {devices/lab_pin.sym} 1060 500 0 0 {name=l30 sig_type=std_logic lab=yp2}
N 1120 470 1120 450 {lab=VDD}
C {devices/lab_pin.sym} 1120 450 0 0 {name=l31 sig_type=std_logic lab=VDD}
N 1120 500 1140 500 {lab=VDD}
C {devices/lab_pin.sym} 1140 500 0 1 {name=l32 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 200 700 0 0 {name=MSNp3 L=0.28u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 670 220 650 {lab=yp3}
C {devices/lab_pin.sym} 220 650 0 0 {name=l33 sig_type=std_logic lab=yp3}
N 180 700 160 700 {lab=ap3}
C {devices/lab_pin.sym} 160 700 0 0 {name=l34 sig_type=std_logic lab=ap3}
N 220 730 220 750 {lab=VSS}
C {devices/lab_pin.sym} 220 750 0 0 {name=l35 sig_type=std_logic lab=VSS}
N 220 700 240 700 {lab=VSS}
C {devices/lab_pin.sym} 240 700 0 1 {name=l36 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 500 700 0 0 {name=MSNn3 L=0.28u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 520 670 520 650 {lab=yn3}
C {devices/lab_pin.sym} 520 650 0 0 {name=l37 sig_type=std_logic lab=yn3}
N 480 700 460 700 {lab=an3}
C {devices/lab_pin.sym} 460 700 0 0 {name=l38 sig_type=std_logic lab=an3}
N 520 730 520 750 {lab=VSS}
C {devices/lab_pin.sym} 520 750 0 0 {name=l39 sig_type=std_logic lab=VSS}
N 520 700 540 700 {lab=VSS}
C {devices/lab_pin.sym} 540 700 0 1 {name=l40 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 800 700 0 0 {name=MSPp3 L=0.28u W=1u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 820 730 820 750 {lab=yp3}
C {devices/lab_pin.sym} 820 750 0 0 {name=l41 sig_type=std_logic lab=yp3}
N 780 700 760 700 {lab=yn3}
C {devices/lab_pin.sym} 760 700 0 0 {name=l42 sig_type=std_logic lab=yn3}
N 820 670 820 650 {lab=VDD}
C {devices/lab_pin.sym} 820 650 0 0 {name=l43 sig_type=std_logic lab=VDD}
N 820 700 840 700 {lab=VDD}
C {devices/lab_pin.sym} 840 700 0 1 {name=l44 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 1100 700 0 0 {name=MSPn3 L=0.28u W=1u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1120 730 1120 750 {lab=yn3}
C {devices/lab_pin.sym} 1120 750 0 0 {name=l45 sig_type=std_logic lab=yn3}
N 1080 700 1060 700 {lab=yp3}
C {devices/lab_pin.sym} 1060 700 0 0 {name=l46 sig_type=std_logic lab=yp3}
N 1120 670 1120 650 {lab=VDD}
C {devices/lab_pin.sym} 1120 650 0 0 {name=l47 sig_type=std_logic lab=VDD}
N 1120 700 1140 700 {lab=VDD}
C {devices/lab_pin.sym} 1140 700 0 1 {name=l48 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 200 900 0 0 {name=MSNp4 L=0.28u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 870 220 850 {lab=yp4}
C {devices/lab_pin.sym} 220 850 0 0 {name=l49 sig_type=std_logic lab=yp4}
N 180 900 160 900 {lab=ap4}
C {devices/lab_pin.sym} 160 900 0 0 {name=l50 sig_type=std_logic lab=ap4}
N 220 930 220 950 {lab=VSS}
C {devices/lab_pin.sym} 220 950 0 0 {name=l51 sig_type=std_logic lab=VSS}
N 220 900 240 900 {lab=VSS}
C {devices/lab_pin.sym} 240 900 0 1 {name=l52 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 500 900 0 0 {name=MSNn4 L=0.28u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 520 870 520 850 {lab=yn4}
C {devices/lab_pin.sym} 520 850 0 0 {name=l53 sig_type=std_logic lab=yn4}
N 480 900 460 900 {lab=an4}
C {devices/lab_pin.sym} 460 900 0 0 {name=l54 sig_type=std_logic lab=an4}
N 520 930 520 950 {lab=VSS}
C {devices/lab_pin.sym} 520 950 0 0 {name=l55 sig_type=std_logic lab=VSS}
N 520 900 540 900 {lab=VSS}
C {devices/lab_pin.sym} 540 900 0 1 {name=l56 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 800 900 0 0 {name=MSPp4 L=0.28u W=1u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 820 930 820 950 {lab=yp4}
C {devices/lab_pin.sym} 820 950 0 0 {name=l57 sig_type=std_logic lab=yp4}
N 780 900 760 900 {lab=yn4}
C {devices/lab_pin.sym} 760 900 0 0 {name=l58 sig_type=std_logic lab=yn4}
N 820 870 820 850 {lab=VDD}
C {devices/lab_pin.sym} 820 850 0 0 {name=l59 sig_type=std_logic lab=VDD}
N 820 900 840 900 {lab=VDD}
C {devices/lab_pin.sym} 840 900 0 1 {name=l60 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 1100 900 0 0 {name=MSPn4 L=0.28u W=1u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1120 930 1120 950 {lab=yn4}
C {devices/lab_pin.sym} 1120 950 0 0 {name=l61 sig_type=std_logic lab=yn4}
N 1080 900 1060 900 {lab=yp4}
C {devices/lab_pin.sym} 1060 900 0 0 {name=l62 sig_type=std_logic lab=yp4}
N 1120 870 1120 850 {lab=VDD}
C {devices/lab_pin.sym} 1120 850 0 0 {name=l63 sig_type=std_logic lab=VDD}
N 1120 900 1140 900 {lab=VDD}
C {devices/lab_pin.sym} 1140 900 0 1 {name=l64 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 200 1100 0 0 {name=MGNp1 L=0.28u W=6u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 1070 220 1050 {lab=gp1}
C {devices/lab_pin.sym} 220 1050 0 0 {name=l65 sig_type=std_logic lab=gp1}
N 180 1100 160 1100 {lab=yn1}
C {devices/lab_pin.sym} 160 1100 0 0 {name=l66 sig_type=std_logic lab=yn1}
N 220 1130 220 1150 {lab=VSS}
C {devices/lab_pin.sym} 220 1150 0 0 {name=l67 sig_type=std_logic lab=VSS}
N 220 1100 240 1100 {lab=VSS}
C {devices/lab_pin.sym} 240 1100 0 1 {name=l68 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 500 1100 0 0 {name=MGPp1 L=0.28u W=12u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 520 1130 520 1150 {lab=gp1}
C {devices/lab_pin.sym} 520 1150 0 0 {name=l69 sig_type=std_logic lab=gp1}
N 480 1100 460 1100 {lab=yn1}
C {devices/lab_pin.sym} 460 1100 0 0 {name=l70 sig_type=std_logic lab=yn1}
N 520 1070 520 1050 {lab=VDD}
C {devices/lab_pin.sym} 520 1050 0 0 {name=l71 sig_type=std_logic lab=VDD}
N 520 1100 540 1100 {lab=VDD}
C {devices/lab_pin.sym} 540 1100 0 1 {name=l72 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 800 1100 0 0 {name=MGNn1 L=0.28u W=6u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 820 1070 820 1050 {lab=gn1}
C {devices/lab_pin.sym} 820 1050 0 0 {name=l73 sig_type=std_logic lab=gn1}
N 780 1100 760 1100 {lab=yp1}
C {devices/lab_pin.sym} 760 1100 0 0 {name=l74 sig_type=std_logic lab=yp1}
N 820 1130 820 1150 {lab=VSS}
C {devices/lab_pin.sym} 820 1150 0 0 {name=l75 sig_type=std_logic lab=VSS}
N 820 1100 840 1100 {lab=VSS}
C {devices/lab_pin.sym} 840 1100 0 1 {name=l76 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 1100 1100 0 0 {name=MGPn1 L=0.28u W=12u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1120 1130 1120 1150 {lab=gn1}
C {devices/lab_pin.sym} 1120 1150 0 0 {name=l77 sig_type=std_logic lab=gn1}
N 1080 1100 1060 1100 {lab=yp1}
C {devices/lab_pin.sym} 1060 1100 0 0 {name=l78 sig_type=std_logic lab=yp1}
N 1120 1070 1120 1050 {lab=VDD}
C {devices/lab_pin.sym} 1120 1050 0 0 {name=l79 sig_type=std_logic lab=VDD}
N 1120 1100 1140 1100 {lab=VDD}
C {devices/lab_pin.sym} 1140 1100 0 1 {name=l80 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 200 1300 0 0 {name=MGNp2 L=0.28u W=6u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 1270 220 1250 {lab=gp2}
C {devices/lab_pin.sym} 220 1250 0 0 {name=l81 sig_type=std_logic lab=gp2}
N 180 1300 160 1300 {lab=yn2}
C {devices/lab_pin.sym} 160 1300 0 0 {name=l82 sig_type=std_logic lab=yn2}
N 220 1330 220 1350 {lab=VSS}
C {devices/lab_pin.sym} 220 1350 0 0 {name=l83 sig_type=std_logic lab=VSS}
N 220 1300 240 1300 {lab=VSS}
C {devices/lab_pin.sym} 240 1300 0 1 {name=l84 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 500 1300 0 0 {name=MGPp2 L=0.28u W=12u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 520 1330 520 1350 {lab=gp2}
C {devices/lab_pin.sym} 520 1350 0 0 {name=l85 sig_type=std_logic lab=gp2}
N 480 1300 460 1300 {lab=yn2}
C {devices/lab_pin.sym} 460 1300 0 0 {name=l86 sig_type=std_logic lab=yn2}
N 520 1270 520 1250 {lab=VDD}
C {devices/lab_pin.sym} 520 1250 0 0 {name=l87 sig_type=std_logic lab=VDD}
N 520 1300 540 1300 {lab=VDD}
C {devices/lab_pin.sym} 540 1300 0 1 {name=l88 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 800 1300 0 0 {name=MGNn2 L=0.28u W=6u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 820 1270 820 1250 {lab=gn2}
C {devices/lab_pin.sym} 820 1250 0 0 {name=l89 sig_type=std_logic lab=gn2}
N 780 1300 760 1300 {lab=yp2}
C {devices/lab_pin.sym} 760 1300 0 0 {name=l90 sig_type=std_logic lab=yp2}
N 820 1330 820 1350 {lab=VSS}
C {devices/lab_pin.sym} 820 1350 0 0 {name=l91 sig_type=std_logic lab=VSS}
N 820 1300 840 1300 {lab=VSS}
C {devices/lab_pin.sym} 840 1300 0 1 {name=l92 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 1100 1300 0 0 {name=MGPn2 L=0.28u W=12u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1120 1330 1120 1350 {lab=gn2}
C {devices/lab_pin.sym} 1120 1350 0 0 {name=l93 sig_type=std_logic lab=gn2}
N 1080 1300 1060 1300 {lab=yp2}
C {devices/lab_pin.sym} 1060 1300 0 0 {name=l94 sig_type=std_logic lab=yp2}
N 1120 1270 1120 1250 {lab=VDD}
C {devices/lab_pin.sym} 1120 1250 0 0 {name=l95 sig_type=std_logic lab=VDD}
N 1120 1300 1140 1300 {lab=VDD}
C {devices/lab_pin.sym} 1140 1300 0 1 {name=l96 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 200 1500 0 0 {name=MGNp3 L=0.28u W=6u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 1470 220 1450 {lab=gp3}
C {devices/lab_pin.sym} 220 1450 0 0 {name=l97 sig_type=std_logic lab=gp3}
N 180 1500 160 1500 {lab=yn3}
C {devices/lab_pin.sym} 160 1500 0 0 {name=l98 sig_type=std_logic lab=yn3}
N 220 1530 220 1550 {lab=VSS}
C {devices/lab_pin.sym} 220 1550 0 0 {name=l99 sig_type=std_logic lab=VSS}
N 220 1500 240 1500 {lab=VSS}
C {devices/lab_pin.sym} 240 1500 0 1 {name=l100 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 500 1500 0 0 {name=MGPp3 L=0.28u W=12u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 520 1530 520 1550 {lab=gp3}
C {devices/lab_pin.sym} 520 1550 0 0 {name=l101 sig_type=std_logic lab=gp3}
N 480 1500 460 1500 {lab=yn3}
C {devices/lab_pin.sym} 460 1500 0 0 {name=l102 sig_type=std_logic lab=yn3}
N 520 1470 520 1450 {lab=VDD}
C {devices/lab_pin.sym} 520 1450 0 0 {name=l103 sig_type=std_logic lab=VDD}
N 520 1500 540 1500 {lab=VDD}
C {devices/lab_pin.sym} 540 1500 0 1 {name=l104 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 800 1500 0 0 {name=MGNn3 L=0.28u W=6u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 820 1470 820 1450 {lab=gn3}
C {devices/lab_pin.sym} 820 1450 0 0 {name=l105 sig_type=std_logic lab=gn3}
N 780 1500 760 1500 {lab=yp3}
C {devices/lab_pin.sym} 760 1500 0 0 {name=l106 sig_type=std_logic lab=yp3}
N 820 1530 820 1550 {lab=VSS}
C {devices/lab_pin.sym} 820 1550 0 0 {name=l107 sig_type=std_logic lab=VSS}
N 820 1500 840 1500 {lab=VSS}
C {devices/lab_pin.sym} 840 1500 0 1 {name=l108 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 1100 1500 0 0 {name=MGPn3 L=0.28u W=12u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1120 1530 1120 1550 {lab=gn3}
C {devices/lab_pin.sym} 1120 1550 0 0 {name=l109 sig_type=std_logic lab=gn3}
N 1080 1500 1060 1500 {lab=yp3}
C {devices/lab_pin.sym} 1060 1500 0 0 {name=l110 sig_type=std_logic lab=yp3}
N 1120 1470 1120 1450 {lab=VDD}
C {devices/lab_pin.sym} 1120 1450 0 0 {name=l111 sig_type=std_logic lab=VDD}
N 1120 1500 1140 1500 {lab=VDD}
C {devices/lab_pin.sym} 1140 1500 0 1 {name=l112 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 200 1700 0 0 {name=MGNp4 L=0.28u W=6u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 1670 220 1650 {lab=gp4}
C {devices/lab_pin.sym} 220 1650 0 0 {name=l113 sig_type=std_logic lab=gp4}
N 180 1700 160 1700 {lab=yn4}
C {devices/lab_pin.sym} 160 1700 0 0 {name=l114 sig_type=std_logic lab=yn4}
N 220 1730 220 1750 {lab=VSS}
C {devices/lab_pin.sym} 220 1750 0 0 {name=l115 sig_type=std_logic lab=VSS}
N 220 1700 240 1700 {lab=VSS}
C {devices/lab_pin.sym} 240 1700 0 1 {name=l116 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 500 1700 0 0 {name=MGPp4 L=0.28u W=12u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 520 1730 520 1750 {lab=gp4}
C {devices/lab_pin.sym} 520 1750 0 0 {name=l117 sig_type=std_logic lab=gp4}
N 480 1700 460 1700 {lab=yn4}
C {devices/lab_pin.sym} 460 1700 0 0 {name=l118 sig_type=std_logic lab=yn4}
N 520 1670 520 1650 {lab=VDD}
C {devices/lab_pin.sym} 520 1650 0 0 {name=l119 sig_type=std_logic lab=VDD}
N 520 1700 540 1700 {lab=VDD}
C {devices/lab_pin.sym} 540 1700 0 1 {name=l120 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 800 1700 0 0 {name=MGNn4 L=0.28u W=6u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 820 1670 820 1650 {lab=gn4}
C {devices/lab_pin.sym} 820 1650 0 0 {name=l121 sig_type=std_logic lab=gn4}
N 780 1700 760 1700 {lab=yp4}
C {devices/lab_pin.sym} 760 1700 0 0 {name=l122 sig_type=std_logic lab=yp4}
N 820 1730 820 1750 {lab=VSS}
C {devices/lab_pin.sym} 820 1750 0 0 {name=l123 sig_type=std_logic lab=VSS}
N 820 1700 840 1700 {lab=VSS}
C {devices/lab_pin.sym} 840 1700 0 1 {name=l124 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 1100 1700 0 0 {name=MGPn4 L=0.28u W=12u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1120 1730 1120 1750 {lab=gn4}
C {devices/lab_pin.sym} 1120 1750 0 0 {name=l125 sig_type=std_logic lab=gn4}
N 1080 1700 1060 1700 {lab=yp4}
C {devices/lab_pin.sym} 1060 1700 0 0 {name=l126 sig_type=std_logic lab=yp4}
N 1120 1670 1120 1650 {lab=VDD}
C {devices/lab_pin.sym} 1120 1650 0 0 {name=l127 sig_type=std_logic lab=VDD}
N 1120 1700 1140 1700 {lab=VDD}
C {devices/lab_pin.sym} 1140 1700 0 1 {name=l128 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 200 1900 0 0 {name=MCAIP L=0.28u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 1870 220 1850 {lab=xIP}
C {devices/lab_pin.sym} 220 1850 0 0 {name=l129 sig_type=std_logic lab=xIP}
N 180 1900 160 1900 {lab=gp1}
C {devices/lab_pin.sym} 160 1900 0 0 {name=l130 sig_type=std_logic lab=gp1}
N 220 1930 220 1950 {lab=naIP}
C {devices/lab_pin.sym} 220 1950 0 0 {name=l131 sig_type=std_logic lab=naIP}
N 220 1900 240 1900 {lab=VSS}
C {devices/lab_pin.sym} 240 1900 0 1 {name=l132 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 500 1900 0 0 {name=MCBIP L=0.28u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 520 1870 520 1850 {lab=naIP}
C {devices/lab_pin.sym} 520 1850 0 0 {name=l133 sig_type=std_logic lab=naIP}
N 480 1900 460 1900 {lab=gn3}
C {devices/lab_pin.sym} 460 1900 0 0 {name=l134 sig_type=std_logic lab=gn3}
N 520 1930 520 1950 {lab=VSS}
C {devices/lab_pin.sym} 520 1950 0 0 {name=l135 sig_type=std_logic lab=VSS}
N 520 1900 540 1900 {lab=VSS}
C {devices/lab_pin.sym} 540 1900 0 1 {name=l136 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 800 1900 0 0 {name=MCCIP L=0.28u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 820 1870 820 1850 {lab=xIP}
C {devices/lab_pin.sym} 820 1850 0 0 {name=l137 sig_type=std_logic lab=xIP}
N 780 1900 760 1900 {lab=gn1}
C {devices/lab_pin.sym} 760 1900 0 0 {name=l138 sig_type=std_logic lab=gn1}
N 820 1930 820 1950 {lab=ncIP}
C {devices/lab_pin.sym} 820 1950 0 0 {name=l139 sig_type=std_logic lab=ncIP}
N 820 1900 840 1900 {lab=VSS}
C {devices/lab_pin.sym} 840 1900 0 1 {name=l140 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 1100 1900 0 0 {name=MCDIP L=0.28u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 1120 1870 1120 1850 {lab=ncIP}
C {devices/lab_pin.sym} 1120 1850 0 0 {name=l141 sig_type=std_logic lab=ncIP}
N 1080 1900 1060 1900 {lab=gp3}
C {devices/lab_pin.sym} 1060 1900 0 0 {name=l142 sig_type=std_logic lab=gp3}
N 1120 1930 1120 1950 {lab=VSS}
C {devices/lab_pin.sym} 1120 1950 0 0 {name=l143 sig_type=std_logic lab=VSS}
N 1120 1900 1140 1900 {lab=VSS}
C {devices/lab_pin.sym} 1140 1900 0 1 {name=l144 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 200 2100 0 0 {name=MCPAIP L=0.28u W=8u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 220 2130 220 2150 {lab=pmIP}
C {devices/lab_pin.sym} 220 2150 0 0 {name=l145 sig_type=std_logic lab=pmIP}
N 180 2100 160 2100 {lab=gp1}
C {devices/lab_pin.sym} 160 2100 0 0 {name=l146 sig_type=std_logic lab=gp1}
N 220 2070 220 2050 {lab=VDD}
C {devices/lab_pin.sym} 220 2050 0 0 {name=l147 sig_type=std_logic lab=VDD}
N 220 2100 240 2100 {lab=VDD}
C {devices/lab_pin.sym} 240 2100 0 1 {name=l148 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 500 2100 0 0 {name=MCPBIP L=0.28u W=8u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 520 2130 520 2150 {lab=pmIP}
C {devices/lab_pin.sym} 520 2150 0 0 {name=l149 sig_type=std_logic lab=pmIP}
N 480 2100 460 2100 {lab=gn3}
C {devices/lab_pin.sym} 460 2100 0 0 {name=l150 sig_type=std_logic lab=gn3}
N 520 2070 520 2050 {lab=VDD}
C {devices/lab_pin.sym} 520 2050 0 0 {name=l151 sig_type=std_logic lab=VDD}
N 520 2100 540 2100 {lab=VDD}
C {devices/lab_pin.sym} 540 2100 0 1 {name=l152 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 800 2100 0 0 {name=MCPCIP L=0.28u W=8u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 820 2130 820 2150 {lab=xIP}
C {devices/lab_pin.sym} 820 2150 0 0 {name=l153 sig_type=std_logic lab=xIP}
N 780 2100 760 2100 {lab=gn1}
C {devices/lab_pin.sym} 760 2100 0 0 {name=l154 sig_type=std_logic lab=gn1}
N 820 2070 820 2050 {lab=pmIP}
C {devices/lab_pin.sym} 820 2050 0 0 {name=l155 sig_type=std_logic lab=pmIP}
N 820 2100 840 2100 {lab=VDD}
C {devices/lab_pin.sym} 840 2100 0 1 {name=l156 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 1100 2100 0 0 {name=MCPDIP L=0.28u W=8u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1120 2130 1120 2150 {lab=xIP}
C {devices/lab_pin.sym} 1120 2150 0 0 {name=l157 sig_type=std_logic lab=xIP}
N 1080 2100 1060 2100 {lab=gp3}
C {devices/lab_pin.sym} 1060 2100 0 0 {name=l158 sig_type=std_logic lab=gp3}
N 1120 2070 1120 2050 {lab=pmIP}
C {devices/lab_pin.sym} 1120 2050 0 0 {name=l159 sig_type=std_logic lab=pmIP}
N 1120 2100 1140 2100 {lab=VDD}
C {devices/lab_pin.sym} 1140 2100 0 1 {name=l160 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 200 2300 0 0 {name=MLNIP L=0.28u W=6u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 2270 220 2250 {lab=LOIP}
C {devices/lab_pin.sym} 220 2250 0 0 {name=l161 sig_type=std_logic lab=LOIP}
N 180 2300 160 2300 {lab=xIP}
C {devices/lab_pin.sym} 160 2300 0 0 {name=l162 sig_type=std_logic lab=xIP}
N 220 2330 220 2350 {lab=VSS}
C {devices/lab_pin.sym} 220 2350 0 0 {name=l163 sig_type=std_logic lab=VSS}
N 220 2300 240 2300 {lab=VSS}
C {devices/lab_pin.sym} 240 2300 0 1 {name=l164 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 500 2300 0 0 {name=MLPIP L=0.28u W=12u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 520 2330 520 2350 {lab=LOIP}
C {devices/lab_pin.sym} 520 2350 0 0 {name=l165 sig_type=std_logic lab=LOIP}
N 480 2300 460 2300 {lab=xIP}
C {devices/lab_pin.sym} 460 2300 0 0 {name=l166 sig_type=std_logic lab=xIP}
N 520 2270 520 2250 {lab=VDD}
C {devices/lab_pin.sym} 520 2250 0 0 {name=l167 sig_type=std_logic lab=VDD}
N 520 2300 540 2300 {lab=VDD}
C {devices/lab_pin.sym} 540 2300 0 1 {name=l168 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 200 2500 0 0 {name=MCAIN L=0.28u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 2470 220 2450 {lab=xIN}
C {devices/lab_pin.sym} 220 2450 0 0 {name=l169 sig_type=std_logic lab=xIN}
N 180 2500 160 2500 {lab=gp1}
C {devices/lab_pin.sym} 160 2500 0 0 {name=l170 sig_type=std_logic lab=gp1}
N 220 2530 220 2550 {lab=naIN}
C {devices/lab_pin.sym} 220 2550 0 0 {name=l171 sig_type=std_logic lab=naIN}
N 220 2500 240 2500 {lab=VSS}
C {devices/lab_pin.sym} 240 2500 0 1 {name=l172 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 500 2500 0 0 {name=MCBIN L=0.28u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 520 2470 520 2450 {lab=naIN}
C {devices/lab_pin.sym} 520 2450 0 0 {name=l173 sig_type=std_logic lab=naIN}
N 480 2500 460 2500 {lab=gp3}
C {devices/lab_pin.sym} 460 2500 0 0 {name=l174 sig_type=std_logic lab=gp3}
N 520 2530 520 2550 {lab=VSS}
C {devices/lab_pin.sym} 520 2550 0 0 {name=l175 sig_type=std_logic lab=VSS}
N 520 2500 540 2500 {lab=VSS}
C {devices/lab_pin.sym} 540 2500 0 1 {name=l176 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 800 2500 0 0 {name=MCCIN L=0.28u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 820 2470 820 2450 {lab=xIN}
C {devices/lab_pin.sym} 820 2450 0 0 {name=l177 sig_type=std_logic lab=xIN}
N 780 2500 760 2500 {lab=gn1}
C {devices/lab_pin.sym} 760 2500 0 0 {name=l178 sig_type=std_logic lab=gn1}
N 820 2530 820 2550 {lab=ncIN}
C {devices/lab_pin.sym} 820 2550 0 0 {name=l179 sig_type=std_logic lab=ncIN}
N 820 2500 840 2500 {lab=VSS}
C {devices/lab_pin.sym} 840 2500 0 1 {name=l180 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 1100 2500 0 0 {name=MCDIN L=0.28u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 1120 2470 1120 2450 {lab=ncIN}
C {devices/lab_pin.sym} 1120 2450 0 0 {name=l181 sig_type=std_logic lab=ncIN}
N 1080 2500 1060 2500 {lab=gn3}
C {devices/lab_pin.sym} 1060 2500 0 0 {name=l182 sig_type=std_logic lab=gn3}
N 1120 2530 1120 2550 {lab=VSS}
C {devices/lab_pin.sym} 1120 2550 0 0 {name=l183 sig_type=std_logic lab=VSS}
N 1120 2500 1140 2500 {lab=VSS}
C {devices/lab_pin.sym} 1140 2500 0 1 {name=l184 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 200 2700 0 0 {name=MCPAIN L=0.28u W=8u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 220 2730 220 2750 {lab=pmIN}
C {devices/lab_pin.sym} 220 2750 0 0 {name=l185 sig_type=std_logic lab=pmIN}
N 180 2700 160 2700 {lab=gp1}
C {devices/lab_pin.sym} 160 2700 0 0 {name=l186 sig_type=std_logic lab=gp1}
N 220 2670 220 2650 {lab=VDD}
C {devices/lab_pin.sym} 220 2650 0 0 {name=l187 sig_type=std_logic lab=VDD}
N 220 2700 240 2700 {lab=VDD}
C {devices/lab_pin.sym} 240 2700 0 1 {name=l188 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 500 2700 0 0 {name=MCPBIN L=0.28u W=8u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 520 2730 520 2750 {lab=pmIN}
C {devices/lab_pin.sym} 520 2750 0 0 {name=l189 sig_type=std_logic lab=pmIN}
N 480 2700 460 2700 {lab=gp3}
C {devices/lab_pin.sym} 460 2700 0 0 {name=l190 sig_type=std_logic lab=gp3}
N 520 2670 520 2650 {lab=VDD}
C {devices/lab_pin.sym} 520 2650 0 0 {name=l191 sig_type=std_logic lab=VDD}
N 520 2700 540 2700 {lab=VDD}
C {devices/lab_pin.sym} 540 2700 0 1 {name=l192 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 800 2700 0 0 {name=MCPCIN L=0.28u W=8u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 820 2730 820 2750 {lab=xIN}
C {devices/lab_pin.sym} 820 2750 0 0 {name=l193 sig_type=std_logic lab=xIN}
N 780 2700 760 2700 {lab=gn1}
C {devices/lab_pin.sym} 760 2700 0 0 {name=l194 sig_type=std_logic lab=gn1}
N 820 2670 820 2650 {lab=pmIN}
C {devices/lab_pin.sym} 820 2650 0 0 {name=l195 sig_type=std_logic lab=pmIN}
N 820 2700 840 2700 {lab=VDD}
C {devices/lab_pin.sym} 840 2700 0 1 {name=l196 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 1100 2700 0 0 {name=MCPDIN L=0.28u W=8u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1120 2730 1120 2750 {lab=xIN}
C {devices/lab_pin.sym} 1120 2750 0 0 {name=l197 sig_type=std_logic lab=xIN}
N 1080 2700 1060 2700 {lab=gn3}
C {devices/lab_pin.sym} 1060 2700 0 0 {name=l198 sig_type=std_logic lab=gn3}
N 1120 2670 1120 2650 {lab=pmIN}
C {devices/lab_pin.sym} 1120 2650 0 0 {name=l199 sig_type=std_logic lab=pmIN}
N 1120 2700 1140 2700 {lab=VDD}
C {devices/lab_pin.sym} 1140 2700 0 1 {name=l200 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 200 2900 0 0 {name=MLNIN L=0.28u W=6u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 2870 220 2850 {lab=LOIN}
C {devices/lab_pin.sym} 220 2850 0 0 {name=l201 sig_type=std_logic lab=LOIN}
N 180 2900 160 2900 {lab=xIN}
C {devices/lab_pin.sym} 160 2900 0 0 {name=l202 sig_type=std_logic lab=xIN}
N 220 2930 220 2950 {lab=VSS}
C {devices/lab_pin.sym} 220 2950 0 0 {name=l203 sig_type=std_logic lab=VSS}
N 220 2900 240 2900 {lab=VSS}
C {devices/lab_pin.sym} 240 2900 0 1 {name=l204 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 500 2900 0 0 {name=MLPIN L=0.28u W=12u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 520 2930 520 2950 {lab=LOIN}
C {devices/lab_pin.sym} 520 2950 0 0 {name=l205 sig_type=std_logic lab=LOIN}
N 480 2900 460 2900 {lab=xIN}
C {devices/lab_pin.sym} 460 2900 0 0 {name=l206 sig_type=std_logic lab=xIN}
N 520 2870 520 2850 {lab=VDD}
C {devices/lab_pin.sym} 520 2850 0 0 {name=l207 sig_type=std_logic lab=VDD}
N 520 2900 540 2900 {lab=VDD}
C {devices/lab_pin.sym} 540 2900 0 1 {name=l208 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 200 3100 0 0 {name=MCAQP L=0.28u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 3070 220 3050 {lab=xQP}
C {devices/lab_pin.sym} 220 3050 0 0 {name=l209 sig_type=std_logic lab=xQP}
N 180 3100 160 3100 {lab=gp2}
C {devices/lab_pin.sym} 160 3100 0 0 {name=l210 sig_type=std_logic lab=gp2}
N 220 3130 220 3150 {lab=naQP}
C {devices/lab_pin.sym} 220 3150 0 0 {name=l211 sig_type=std_logic lab=naQP}
N 220 3100 240 3100 {lab=VSS}
C {devices/lab_pin.sym} 240 3100 0 1 {name=l212 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 500 3100 0 0 {name=MCBQP L=0.28u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 520 3070 520 3050 {lab=naQP}
C {devices/lab_pin.sym} 520 3050 0 0 {name=l213 sig_type=std_logic lab=naQP}
N 480 3100 460 3100 {lab=gn4}
C {devices/lab_pin.sym} 460 3100 0 0 {name=l214 sig_type=std_logic lab=gn4}
N 520 3130 520 3150 {lab=VSS}
C {devices/lab_pin.sym} 520 3150 0 0 {name=l215 sig_type=std_logic lab=VSS}
N 520 3100 540 3100 {lab=VSS}
C {devices/lab_pin.sym} 540 3100 0 1 {name=l216 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 800 3100 0 0 {name=MCCQP L=0.28u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 820 3070 820 3050 {lab=xQP}
C {devices/lab_pin.sym} 820 3050 0 0 {name=l217 sig_type=std_logic lab=xQP}
N 780 3100 760 3100 {lab=gn2}
C {devices/lab_pin.sym} 760 3100 0 0 {name=l218 sig_type=std_logic lab=gn2}
N 820 3130 820 3150 {lab=ncQP}
C {devices/lab_pin.sym} 820 3150 0 0 {name=l219 sig_type=std_logic lab=ncQP}
N 820 3100 840 3100 {lab=VSS}
C {devices/lab_pin.sym} 840 3100 0 1 {name=l220 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 1100 3100 0 0 {name=MCDQP L=0.28u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 1120 3070 1120 3050 {lab=ncQP}
C {devices/lab_pin.sym} 1120 3050 0 0 {name=l221 sig_type=std_logic lab=ncQP}
N 1080 3100 1060 3100 {lab=gp4}
C {devices/lab_pin.sym} 1060 3100 0 0 {name=l222 sig_type=std_logic lab=gp4}
N 1120 3130 1120 3150 {lab=VSS}
C {devices/lab_pin.sym} 1120 3150 0 0 {name=l223 sig_type=std_logic lab=VSS}
N 1120 3100 1140 3100 {lab=VSS}
C {devices/lab_pin.sym} 1140 3100 0 1 {name=l224 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 200 3300 0 0 {name=MCPAQP L=0.28u W=8u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 220 3330 220 3350 {lab=pmQP}
C {devices/lab_pin.sym} 220 3350 0 0 {name=l225 sig_type=std_logic lab=pmQP}
N 180 3300 160 3300 {lab=gp2}
C {devices/lab_pin.sym} 160 3300 0 0 {name=l226 sig_type=std_logic lab=gp2}
N 220 3270 220 3250 {lab=VDD}
C {devices/lab_pin.sym} 220 3250 0 0 {name=l227 sig_type=std_logic lab=VDD}
N 220 3300 240 3300 {lab=VDD}
C {devices/lab_pin.sym} 240 3300 0 1 {name=l228 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 500 3300 0 0 {name=MCPBQP L=0.28u W=8u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 520 3330 520 3350 {lab=pmQP}
C {devices/lab_pin.sym} 520 3350 0 0 {name=l229 sig_type=std_logic lab=pmQP}
N 480 3300 460 3300 {lab=gn4}
C {devices/lab_pin.sym} 460 3300 0 0 {name=l230 sig_type=std_logic lab=gn4}
N 520 3270 520 3250 {lab=VDD}
C {devices/lab_pin.sym} 520 3250 0 0 {name=l231 sig_type=std_logic lab=VDD}
N 520 3300 540 3300 {lab=VDD}
C {devices/lab_pin.sym} 540 3300 0 1 {name=l232 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 800 3300 0 0 {name=MCPCQP L=0.28u W=8u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 820 3330 820 3350 {lab=xQP}
C {devices/lab_pin.sym} 820 3350 0 0 {name=l233 sig_type=std_logic lab=xQP}
N 780 3300 760 3300 {lab=gn2}
C {devices/lab_pin.sym} 760 3300 0 0 {name=l234 sig_type=std_logic lab=gn2}
N 820 3270 820 3250 {lab=pmQP}
C {devices/lab_pin.sym} 820 3250 0 0 {name=l235 sig_type=std_logic lab=pmQP}
N 820 3300 840 3300 {lab=VDD}
C {devices/lab_pin.sym} 840 3300 0 1 {name=l236 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 1100 3300 0 0 {name=MCPDQP L=0.28u W=8u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1120 3330 1120 3350 {lab=xQP}
C {devices/lab_pin.sym} 1120 3350 0 0 {name=l237 sig_type=std_logic lab=xQP}
N 1080 3300 1060 3300 {lab=gp4}
C {devices/lab_pin.sym} 1060 3300 0 0 {name=l238 sig_type=std_logic lab=gp4}
N 1120 3270 1120 3250 {lab=pmQP}
C {devices/lab_pin.sym} 1120 3250 0 0 {name=l239 sig_type=std_logic lab=pmQP}
N 1120 3300 1140 3300 {lab=VDD}
C {devices/lab_pin.sym} 1140 3300 0 1 {name=l240 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 200 3500 0 0 {name=MLNQP L=0.28u W=6u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 3470 220 3450 {lab=LOQN}
C {devices/lab_pin.sym} 220 3450 0 0 {name=l241 sig_type=std_logic lab=LOQN}
N 180 3500 160 3500 {lab=xQP}
C {devices/lab_pin.sym} 160 3500 0 0 {name=l242 sig_type=std_logic lab=xQP}
N 220 3530 220 3550 {lab=VSS}
C {devices/lab_pin.sym} 220 3550 0 0 {name=l243 sig_type=std_logic lab=VSS}
N 220 3500 240 3500 {lab=VSS}
C {devices/lab_pin.sym} 240 3500 0 1 {name=l244 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 500 3500 0 0 {name=MLPQP L=0.28u W=12u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 520 3530 520 3550 {lab=LOQN}
C {devices/lab_pin.sym} 520 3550 0 0 {name=l245 sig_type=std_logic lab=LOQN}
N 480 3500 460 3500 {lab=xQP}
C {devices/lab_pin.sym} 460 3500 0 0 {name=l246 sig_type=std_logic lab=xQP}
N 520 3470 520 3450 {lab=VDD}
C {devices/lab_pin.sym} 520 3450 0 0 {name=l247 sig_type=std_logic lab=VDD}
N 520 3500 540 3500 {lab=VDD}
C {devices/lab_pin.sym} 540 3500 0 1 {name=l248 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 200 3700 0 0 {name=MCAQN L=0.28u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 3670 220 3650 {lab=xQN}
C {devices/lab_pin.sym} 220 3650 0 0 {name=l249 sig_type=std_logic lab=xQN}
N 180 3700 160 3700 {lab=gp2}
C {devices/lab_pin.sym} 160 3700 0 0 {name=l250 sig_type=std_logic lab=gp2}
N 220 3730 220 3750 {lab=naQN}
C {devices/lab_pin.sym} 220 3750 0 0 {name=l251 sig_type=std_logic lab=naQN}
N 220 3700 240 3700 {lab=VSS}
C {devices/lab_pin.sym} 240 3700 0 1 {name=l252 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 500 3700 0 0 {name=MCBQN L=0.28u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 520 3670 520 3650 {lab=naQN}
C {devices/lab_pin.sym} 520 3650 0 0 {name=l253 sig_type=std_logic lab=naQN}
N 480 3700 460 3700 {lab=gp4}
C {devices/lab_pin.sym} 460 3700 0 0 {name=l254 sig_type=std_logic lab=gp4}
N 520 3730 520 3750 {lab=VSS}
C {devices/lab_pin.sym} 520 3750 0 0 {name=l255 sig_type=std_logic lab=VSS}
N 520 3700 540 3700 {lab=VSS}
C {devices/lab_pin.sym} 540 3700 0 1 {name=l256 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 800 3700 0 0 {name=MCCQN L=0.28u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 820 3670 820 3650 {lab=xQN}
C {devices/lab_pin.sym} 820 3650 0 0 {name=l257 sig_type=std_logic lab=xQN}
N 780 3700 760 3700 {lab=gn2}
C {devices/lab_pin.sym} 760 3700 0 0 {name=l258 sig_type=std_logic lab=gn2}
N 820 3730 820 3750 {lab=ncQN}
C {devices/lab_pin.sym} 820 3750 0 0 {name=l259 sig_type=std_logic lab=ncQN}
N 820 3700 840 3700 {lab=VSS}
C {devices/lab_pin.sym} 840 3700 0 1 {name=l260 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 1100 3700 0 0 {name=MCDQN L=0.28u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 1120 3670 1120 3650 {lab=ncQN}
C {devices/lab_pin.sym} 1120 3650 0 0 {name=l261 sig_type=std_logic lab=ncQN}
N 1080 3700 1060 3700 {lab=gn4}
C {devices/lab_pin.sym} 1060 3700 0 0 {name=l262 sig_type=std_logic lab=gn4}
N 1120 3730 1120 3750 {lab=VSS}
C {devices/lab_pin.sym} 1120 3750 0 0 {name=l263 sig_type=std_logic lab=VSS}
N 1120 3700 1140 3700 {lab=VSS}
C {devices/lab_pin.sym} 1140 3700 0 1 {name=l264 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 200 3900 0 0 {name=MCPAQN L=0.28u W=8u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 220 3930 220 3950 {lab=pmQN}
C {devices/lab_pin.sym} 220 3950 0 0 {name=l265 sig_type=std_logic lab=pmQN}
N 180 3900 160 3900 {lab=gp2}
C {devices/lab_pin.sym} 160 3900 0 0 {name=l266 sig_type=std_logic lab=gp2}
N 220 3870 220 3850 {lab=VDD}
C {devices/lab_pin.sym} 220 3850 0 0 {name=l267 sig_type=std_logic lab=VDD}
N 220 3900 240 3900 {lab=VDD}
C {devices/lab_pin.sym} 240 3900 0 1 {name=l268 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 500 3900 0 0 {name=MCPBQN L=0.28u W=8u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 520 3930 520 3950 {lab=pmQN}
C {devices/lab_pin.sym} 520 3950 0 0 {name=l269 sig_type=std_logic lab=pmQN}
N 480 3900 460 3900 {lab=gp4}
C {devices/lab_pin.sym} 460 3900 0 0 {name=l270 sig_type=std_logic lab=gp4}
N 520 3870 520 3850 {lab=VDD}
C {devices/lab_pin.sym} 520 3850 0 0 {name=l271 sig_type=std_logic lab=VDD}
N 520 3900 540 3900 {lab=VDD}
C {devices/lab_pin.sym} 540 3900 0 1 {name=l272 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 800 3900 0 0 {name=MCPCQN L=0.28u W=8u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 820 3930 820 3950 {lab=xQN}
C {devices/lab_pin.sym} 820 3950 0 0 {name=l273 sig_type=std_logic lab=xQN}
N 780 3900 760 3900 {lab=gn2}
C {devices/lab_pin.sym} 760 3900 0 0 {name=l274 sig_type=std_logic lab=gn2}
N 820 3870 820 3850 {lab=pmQN}
C {devices/lab_pin.sym} 820 3850 0 0 {name=l275 sig_type=std_logic lab=pmQN}
N 820 3900 840 3900 {lab=VDD}
C {devices/lab_pin.sym} 840 3900 0 1 {name=l276 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 1100 3900 0 0 {name=MCPDQN L=0.28u W=8u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1120 3930 1120 3950 {lab=xQN}
C {devices/lab_pin.sym} 1120 3950 0 0 {name=l277 sig_type=std_logic lab=xQN}
N 1080 3900 1060 3900 {lab=gn4}
C {devices/lab_pin.sym} 1060 3900 0 0 {name=l278 sig_type=std_logic lab=gn4}
N 1120 3870 1120 3850 {lab=pmQN}
C {devices/lab_pin.sym} 1120 3850 0 0 {name=l279 sig_type=std_logic lab=pmQN}
N 1120 3900 1140 3900 {lab=VDD}
C {devices/lab_pin.sym} 1140 3900 0 1 {name=l280 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 200 4100 0 0 {name=MLNQN L=0.28u W=6u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 4070 220 4050 {lab=LOQP}
C {devices/lab_pin.sym} 220 4050 0 0 {name=l281 sig_type=std_logic lab=LOQP}
N 180 4100 160 4100 {lab=xQN}
C {devices/lab_pin.sym} 160 4100 0 0 {name=l282 sig_type=std_logic lab=xQN}
N 220 4130 220 4150 {lab=VSS}
C {devices/lab_pin.sym} 220 4150 0 0 {name=l283 sig_type=std_logic lab=VSS}
N 220 4100 240 4100 {lab=VSS}
C {devices/lab_pin.sym} 240 4100 0 1 {name=l284 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 500 4100 0 0 {name=MLPQN L=0.28u W=12u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 520 4130 520 4150 {lab=LOQP}
C {devices/lab_pin.sym} 520 4150 0 0 {name=l285 sig_type=std_logic lab=LOQP}
N 480 4100 460 4100 {lab=xQN}
C {devices/lab_pin.sym} 460 4100 0 0 {name=l286 sig_type=std_logic lab=xQN}
N 520 4070 520 4050 {lab=VDD}
C {devices/lab_pin.sym} 520 4050 0 0 {name=l287 sig_type=std_logic lab=VDD}
N 520 4100 540 4100 {lab=VDD}
C {devices/lab_pin.sym} 540 4100 0 1 {name=l288 sig_type=std_logic lab=VDD}
C {devices/title.sym} 160 4600 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
