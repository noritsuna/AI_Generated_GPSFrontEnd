v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {StrongARM comparator, decision sign[(INP-INN)-(REFP-REFN)] + SR latch} 100 80 0 0 0.6 0.6 {}
T {input pairs + tail} 100 190 0 0 0.4 0.4 {layer=8}
T {cross-coupled latch} 100 390 0 0 0.4 0.4 {layer=8}
T {reset switches} 100 590 0 0 0.4 0.4 {layer=8}
T {isolation inverters (state-independent load on op/on) + NOR SR latch} 100 790 0 0 0.4 0.4 {layer=8}
C {devices/ipin.sym} -100 300 0 0 {name=p0 lab=INP}
C {devices/ipin.sym} -100 330 0 0 {name=p1 lab=INN}
C {devices/ipin.sym} -100 360 0 0 {name=p2 lab=REFP}
C {devices/ipin.sym} -100 390 0 0 {name=p3 lab=REFN}
C {devices/ipin.sym} -100 420 0 0 {name=p4 lab=CLK}
C {devices/opin.sym} -100 450 0 0 {name=p5 lab=Q}
C {devices/opin.sym} -100 480 0 0 {name=p6 lab=QB}
C {devices/iopin.sym} -100 510 0 0 {name=p7 lab=VDD}
C {devices/iopin.sym} -100 540 0 0 {name=p8 lab=VSS}
C {symbols/nfet_03v3.sym} 200 300 0 0 {name=MT L=0.28u W=8u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 270 220 250 {lab=t}
C {devices/lab_pin.sym} 220 250 0 0 {name=l1 sig_type=std_logic lab=t}
N 180 300 160 300 {lab=CLK}
C {devices/lab_pin.sym} 160 300 0 0 {name=l2 sig_type=std_logic lab=CLK}
N 220 330 220 350 {lab=VSS}
C {devices/lab_pin.sym} 220 350 0 0 {name=l3 sig_type=std_logic lab=VSS}
N 220 300 240 300 {lab=VSS}
C {devices/lab_pin.sym} 240 300 0 1 {name=l4 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 460 300 0 0 {name=M1 L=0.28u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 480 270 480 250 {lab=x1}
C {devices/lab_pin.sym} 480 250 0 0 {name=l5 sig_type=std_logic lab=x1}
N 440 300 420 300 {lab=INP}
C {devices/lab_pin.sym} 420 300 0 0 {name=l6 sig_type=std_logic lab=INP}
N 480 330 480 350 {lab=t}
C {devices/lab_pin.sym} 480 350 0 0 {name=l7 sig_type=std_logic lab=t}
N 480 300 500 300 {lab=VSS}
C {devices/lab_pin.sym} 500 300 0 1 {name=l8 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 720 300 0 0 {name=M2 L=0.28u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 740 270 740 250 {lab=x2}
C {devices/lab_pin.sym} 740 250 0 0 {name=l9 sig_type=std_logic lab=x2}
N 700 300 680 300 {lab=INN}
C {devices/lab_pin.sym} 680 300 0 0 {name=l10 sig_type=std_logic lab=INN}
N 740 330 740 350 {lab=t}
C {devices/lab_pin.sym} 740 350 0 0 {name=l11 sig_type=std_logic lab=t}
N 740 300 760 300 {lab=VSS}
C {devices/lab_pin.sym} 760 300 0 1 {name=l12 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 980 300 0 0 {name=M3 L=0.28u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 1000 270 1000 250 {lab=x2}
C {devices/lab_pin.sym} 1000 250 0 0 {name=l13 sig_type=std_logic lab=x2}
N 960 300 940 300 {lab=REFP}
C {devices/lab_pin.sym} 940 300 0 0 {name=l14 sig_type=std_logic lab=REFP}
N 1000 330 1000 350 {lab=t}
C {devices/lab_pin.sym} 1000 350 0 0 {name=l15 sig_type=std_logic lab=t}
N 1000 300 1020 300 {lab=VSS}
C {devices/lab_pin.sym} 1020 300 0 1 {name=l16 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 1240 300 0 0 {name=M4 L=0.28u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 1260 270 1260 250 {lab=x1}
C {devices/lab_pin.sym} 1260 250 0 0 {name=l17 sig_type=std_logic lab=x1}
N 1220 300 1200 300 {lab=REFN}
C {devices/lab_pin.sym} 1200 300 0 0 {name=l18 sig_type=std_logic lab=REFN}
N 1260 330 1260 350 {lab=t}
C {devices/lab_pin.sym} 1260 350 0 0 {name=l19 sig_type=std_logic lab=t}
N 1260 300 1280 300 {lab=VSS}
C {devices/lab_pin.sym} 1280 300 0 1 {name=l20 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 200 500 0 0 {name=M5 L=0.28u W=2u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 470 220 450 {lab=on}
C {devices/lab_pin.sym} 220 450 0 0 {name=l21 sig_type=std_logic lab=on}
N 180 500 160 500 {lab=op}
C {devices/lab_pin.sym} 160 500 0 0 {name=l22 sig_type=std_logic lab=op}
N 220 530 220 550 {lab=x1}
C {devices/lab_pin.sym} 220 550 0 0 {name=l23 sig_type=std_logic lab=x1}
N 220 500 240 500 {lab=VSS}
C {devices/lab_pin.sym} 240 500 0 1 {name=l24 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 460 500 0 0 {name=M6 L=0.28u W=2u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 480 470 480 450 {lab=op}
C {devices/lab_pin.sym} 480 450 0 0 {name=l25 sig_type=std_logic lab=op}
N 440 500 420 500 {lab=on}
C {devices/lab_pin.sym} 420 500 0 0 {name=l26 sig_type=std_logic lab=on}
N 480 530 480 550 {lab=x2}
C {devices/lab_pin.sym} 480 550 0 0 {name=l27 sig_type=std_logic lab=x2}
N 480 500 500 500 {lab=VSS}
C {devices/lab_pin.sym} 500 500 0 1 {name=l28 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 720 500 0 0 {name=M7 L=0.28u W=2u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 740 530 740 550 {lab=on}
C {devices/lab_pin.sym} 740 550 0 0 {name=l29 sig_type=std_logic lab=on}
N 700 500 680 500 {lab=op}
C {devices/lab_pin.sym} 680 500 0 0 {name=l30 sig_type=std_logic lab=op}
N 740 470 740 450 {lab=VDD}
C {devices/lab_pin.sym} 740 450 0 0 {name=l31 sig_type=std_logic lab=VDD}
N 740 500 760 500 {lab=VDD}
C {devices/lab_pin.sym} 760 500 0 1 {name=l32 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 980 500 0 0 {name=M8 L=0.28u W=2u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1000 530 1000 550 {lab=op}
C {devices/lab_pin.sym} 1000 550 0 0 {name=l33 sig_type=std_logic lab=op}
N 960 500 940 500 {lab=on}
C {devices/lab_pin.sym} 940 500 0 0 {name=l34 sig_type=std_logic lab=on}
N 1000 470 1000 450 {lab=VDD}
C {devices/lab_pin.sym} 1000 450 0 0 {name=l35 sig_type=std_logic lab=VDD}
N 1000 500 1020 500 {lab=VDD}
C {devices/lab_pin.sym} 1020 500 0 1 {name=l36 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 200 700 0 0 {name=M9 L=0.28u W=1u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 220 730 220 750 {lab=on}
C {devices/lab_pin.sym} 220 750 0 0 {name=l37 sig_type=std_logic lab=on}
N 180 700 160 700 {lab=CLK}
C {devices/lab_pin.sym} 160 700 0 0 {name=l38 sig_type=std_logic lab=CLK}
N 220 670 220 650 {lab=VDD}
C {devices/lab_pin.sym} 220 650 0 0 {name=l39 sig_type=std_logic lab=VDD}
N 220 700 240 700 {lab=VDD}
C {devices/lab_pin.sym} 240 700 0 1 {name=l40 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 460 700 0 0 {name=M10 L=0.28u W=1u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 480 730 480 750 {lab=op}
C {devices/lab_pin.sym} 480 750 0 0 {name=l41 sig_type=std_logic lab=op}
N 440 700 420 700 {lab=CLK}
C {devices/lab_pin.sym} 420 700 0 0 {name=l42 sig_type=std_logic lab=CLK}
N 480 670 480 650 {lab=VDD}
C {devices/lab_pin.sym} 480 650 0 0 {name=l43 sig_type=std_logic lab=VDD}
N 480 700 500 700 {lab=VDD}
C {devices/lab_pin.sym} 500 700 0 1 {name=l44 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 720 700 0 0 {name=M11 L=0.28u W=1u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 740 730 740 750 {lab=x1}
C {devices/lab_pin.sym} 740 750 0 0 {name=l45 sig_type=std_logic lab=x1}
N 700 700 680 700 {lab=CLK}
C {devices/lab_pin.sym} 680 700 0 0 {name=l46 sig_type=std_logic lab=CLK}
N 740 670 740 650 {lab=VDD}
C {devices/lab_pin.sym} 740 650 0 0 {name=l47 sig_type=std_logic lab=VDD}
N 740 700 760 700 {lab=VDD}
C {devices/lab_pin.sym} 760 700 0 1 {name=l48 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 980 700 0 0 {name=M12 L=0.28u W=1u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1000 730 1000 750 {lab=x2}
C {devices/lab_pin.sym} 1000 750 0 0 {name=l49 sig_type=std_logic lab=x2}
N 960 700 940 700 {lab=CLK}
C {devices/lab_pin.sym} 940 700 0 0 {name=l50 sig_type=std_logic lab=CLK}
N 1000 670 1000 650 {lab=VDD}
C {devices/lab_pin.sym} 1000 650 0 0 {name=l51 sig_type=std_logic lab=VDD}
N 1000 700 1020 700 {lab=VDD}
C {devices/lab_pin.sym} 1020 700 0 1 {name=l52 sig_type=std_logic lab=VDD}
C {inv_dig.sym} 200 900 0 0 {name=XI1 }
N 100 880 80 880 {lab=op}
C {devices/lab_pin.sym} 80 880 0 0 {name=l53 sig_type=std_logic lab=op}
N 300 880 320 880 {lab=opb}
C {devices/lab_pin.sym} 320 880 0 1 {name=l54 sig_type=std_logic lab=opb}
N 300 900 320 900 {lab=VDD}
C {devices/lab_pin.sym} 320 900 0 1 {name=l55 sig_type=std_logic lab=VDD}
N 300 920 320 920 {lab=VSS}
C {devices/lab_pin.sym} 320 920 0 1 {name=l56 sig_type=std_logic lab=VSS}
C {inv_dig.sym} 460 900 0 0 {name=XI2 }
N 360 880 340 880 {lab=on}
C {devices/lab_pin.sym} 340 880 0 0 {name=l57 sig_type=std_logic lab=on}
N 560 880 580 880 {lab=onb}
C {devices/lab_pin.sym} 580 880 0 1 {name=l58 sig_type=std_logic lab=onb}
N 560 900 580 900 {lab=VDD}
C {devices/lab_pin.sym} 580 900 0 1 {name=l59 sig_type=std_logic lab=VDD}
N 560 920 580 920 {lab=VSS}
C {devices/lab_pin.sym} 580 920 0 1 {name=l60 sig_type=std_logic lab=VSS}
C {nor2.sym} 720 900 0 0 {name=XS1 }
N 620 880 600 880 {lab=opb}
C {devices/lab_pin.sym} 600 880 0 0 {name=l61 sig_type=std_logic lab=opb}
N 620 900 600 900 {lab=QB}
C {devices/lab_pin.sym} 600 900 0 0 {name=l62 sig_type=std_logic lab=QB}
N 820 880 840 880 {lab=Q}
C {devices/lab_pin.sym} 840 880 0 1 {name=l63 sig_type=std_logic lab=Q}
N 820 900 840 900 {lab=VDD}
C {devices/lab_pin.sym} 840 900 0 1 {name=l64 sig_type=std_logic lab=VDD}
N 820 920 840 920 {lab=VSS}
C {devices/lab_pin.sym} 840 920 0 1 {name=l65 sig_type=std_logic lab=VSS}
C {nor2.sym} 980 900 0 0 {name=XS2 }
N 880 880 860 880 {lab=onb}
C {devices/lab_pin.sym} 860 880 0 0 {name=l66 sig_type=std_logic lab=onb}
N 880 900 860 900 {lab=Q}
C {devices/lab_pin.sym} 860 900 0 0 {name=l67 sig_type=std_logic lab=Q}
N 1080 880 1100 880 {lab=QB}
C {devices/lab_pin.sym} 1100 880 0 1 {name=l68 sig_type=std_logic lab=QB}
N 1080 900 1100 900 {lab=VDD}
C {devices/lab_pin.sym} 1100 900 0 1 {name=l69 sig_type=std_logic lab=VDD}
N 1080 920 1100 920 {lab=VSS}
C {devices/lab_pin.sym} 1100 920 0 1 {name=l70 sig_type=std_logic lab=VSS}
C {devices/title.sym} 160 1380 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
