v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {VCO delay cell: pseudo-differential inverter pair + cross-coupled latch} 100 80 0 0 0.6 0.6 {}
T {main inverters} 100 190 0 0 0.4 0.4 {layer=8}
T {latch (forces differential, sets 45deg/stage)} 100 390 0 0 0.4 0.4 {layer=8}
C {devices/ipin.sym} -100 300 0 0 {name=p0 lab=IP}
C {devices/ipin.sym} -100 330 0 0 {name=p1 lab=IN}
C {devices/opin.sym} -100 360 0 0 {name=p2 lab=OP}
C {devices/opin.sym} -100 390 0 0 {name=p3 lab=ON}
C {devices/iopin.sym} -100 420 0 0 {name=p4 lab=VR}
C {devices/iopin.sym} -100 450 0 0 {name=p5 lab=VSS}
C {symbols/nfet_03v3.sym} 200 300 0 0 {name=MN1 L=0.28u W=8u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 270 220 250 {lab=ON}
C {devices/lab_pin.sym} 220 250 0 0 {name=l1 sig_type=std_logic lab=ON}
N 180 300 160 300 {lab=IP}
C {devices/lab_pin.sym} 160 300 0 0 {name=l2 sig_type=std_logic lab=IP}
N 220 330 220 350 {lab=VSS}
C {devices/lab_pin.sym} 220 350 0 0 {name=l3 sig_type=std_logic lab=VSS}
N 220 300 240 300 {lab=VSS}
C {devices/lab_pin.sym} 240 300 0 1 {name=l4 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 460 300 0 0 {name=MP1 L=0.28u W=12u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 480 330 480 350 {lab=ON}
C {devices/lab_pin.sym} 480 350 0 0 {name=l5 sig_type=std_logic lab=ON}
N 440 300 420 300 {lab=IP}
C {devices/lab_pin.sym} 420 300 0 0 {name=l6 sig_type=std_logic lab=IP}
N 480 270 480 250 {lab=VR}
C {devices/lab_pin.sym} 480 250 0 0 {name=l7 sig_type=std_logic lab=VR}
N 480 300 500 300 {lab=VR}
C {devices/lab_pin.sym} 500 300 0 1 {name=l8 sig_type=std_logic lab=VR}
C {symbols/nfet_03v3.sym} 720 300 0 0 {name=MN2 L=0.28u W=8u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 740 270 740 250 {lab=OP}
C {devices/lab_pin.sym} 740 250 0 0 {name=l9 sig_type=std_logic lab=OP}
N 700 300 680 300 {lab=IN}
C {devices/lab_pin.sym} 680 300 0 0 {name=l10 sig_type=std_logic lab=IN}
N 740 330 740 350 {lab=VSS}
C {devices/lab_pin.sym} 740 350 0 0 {name=l11 sig_type=std_logic lab=VSS}
N 740 300 760 300 {lab=VSS}
C {devices/lab_pin.sym} 760 300 0 1 {name=l12 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 980 300 0 0 {name=MP2 L=0.28u W=12u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1000 330 1000 350 {lab=OP}
C {devices/lab_pin.sym} 1000 350 0 0 {name=l13 sig_type=std_logic lab=OP}
N 960 300 940 300 {lab=IN}
C {devices/lab_pin.sym} 940 300 0 0 {name=l14 sig_type=std_logic lab=IN}
N 1000 270 1000 250 {lab=VR}
C {devices/lab_pin.sym} 1000 250 0 0 {name=l15 sig_type=std_logic lab=VR}
N 1000 300 1020 300 {lab=VR}
C {devices/lab_pin.sym} 1020 300 0 1 {name=l16 sig_type=std_logic lab=VR}
C {symbols/nfet_03v3.sym} 200 500 0 0 {name=MN3 L=0.28u W=1u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 470 220 450 {lab=ON}
C {devices/lab_pin.sym} 220 450 0 0 {name=l17 sig_type=std_logic lab=ON}
N 180 500 160 500 {lab=OP}
C {devices/lab_pin.sym} 160 500 0 0 {name=l18 sig_type=std_logic lab=OP}
N 220 530 220 550 {lab=VSS}
C {devices/lab_pin.sym} 220 550 0 0 {name=l19 sig_type=std_logic lab=VSS}
N 220 500 240 500 {lab=VSS}
C {devices/lab_pin.sym} 240 500 0 1 {name=l20 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 460 500 0 0 {name=MP3 L=0.28u W=2u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 480 530 480 550 {lab=ON}
C {devices/lab_pin.sym} 480 550 0 0 {name=l21 sig_type=std_logic lab=ON}
N 440 500 420 500 {lab=OP}
C {devices/lab_pin.sym} 420 500 0 0 {name=l22 sig_type=std_logic lab=OP}
N 480 470 480 450 {lab=VR}
C {devices/lab_pin.sym} 480 450 0 0 {name=l23 sig_type=std_logic lab=VR}
N 480 500 500 500 {lab=VR}
C {devices/lab_pin.sym} 500 500 0 1 {name=l24 sig_type=std_logic lab=VR}
C {symbols/nfet_03v3.sym} 720 500 0 0 {name=MN4 L=0.28u W=1u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 740 470 740 450 {lab=OP}
C {devices/lab_pin.sym} 740 450 0 0 {name=l25 sig_type=std_logic lab=OP}
N 700 500 680 500 {lab=ON}
C {devices/lab_pin.sym} 680 500 0 0 {name=l26 sig_type=std_logic lab=ON}
N 740 530 740 550 {lab=VSS}
C {devices/lab_pin.sym} 740 550 0 0 {name=l27 sig_type=std_logic lab=VSS}
N 740 500 760 500 {lab=VSS}
C {devices/lab_pin.sym} 760 500 0 1 {name=l28 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 980 500 0 0 {name=MP4 L=0.28u W=2u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1000 530 1000 550 {lab=OP}
C {devices/lab_pin.sym} 1000 550 0 0 {name=l29 sig_type=std_logic lab=OP}
N 960 500 940 500 {lab=ON}
C {devices/lab_pin.sym} 940 500 0 0 {name=l30 sig_type=std_logic lab=ON}
N 1000 470 1000 450 {lab=VR}
C {devices/lab_pin.sym} 1000 450 0 0 {name=l31 sig_type=std_logic lab=VR}
N 1000 500 1020 500 {lab=VR}
C {devices/lab_pin.sym} 1020 500 0 1 {name=l32 sig_type=std_logic lab=VR}
C {devices/title.sym} 160 1000 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
