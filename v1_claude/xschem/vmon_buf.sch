v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {VCTRL monitor buffer: unity-gain 5T OTA, 100 uA} 100 80 0 0 0.6 0.6 {}
C {devices/ipin.sym} -100 300 0 0 {name=p0 lab=IN}
C {devices/ipin.sym} -100 330 0 0 {name=p1 lab=NB}
C {devices/opin.sym} -100 360 0 0 {name=p2 lab=OUT}
C {devices/iopin.sym} -100 390 0 0 {name=p3 lab=VDD}
C {devices/iopin.sym} -100 420 0 0 {name=p4 lab=VSS}
C {symbols/nfet_03v3.sym} 200 300 0 0 {name=MT L=2u W=16u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 270 220 250 {lab=t}
C {devices/lab_pin.sym} 220 250 0 0 {name=l1 sig_type=std_logic lab=t}
N 180 300 160 300 {lab=NB}
C {devices/lab_pin.sym} 160 300 0 0 {name=l2 sig_type=std_logic lab=NB}
N 220 330 220 350 {lab=VSS}
C {devices/lab_pin.sym} 220 350 0 0 {name=l3 sig_type=std_logic lab=VSS}
N 220 300 240 300 {lab=VSS}
C {devices/lab_pin.sym} 240 300 0 1 {name=l4 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 460 300 0 0 {name=M1 L=1u W=16u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 480 270 480 250 {lab=x}
C {devices/lab_pin.sym} 480 250 0 0 {name=l5 sig_type=std_logic lab=x}
N 440 300 420 300 {lab=IN}
C {devices/lab_pin.sym} 420 300 0 0 {name=l6 sig_type=std_logic lab=IN}
N 480 330 480 350 {lab=t}
C {devices/lab_pin.sym} 480 350 0 0 {name=l7 sig_type=std_logic lab=t}
N 480 300 500 300 {lab=VSS}
C {devices/lab_pin.sym} 500 300 0 1 {name=l8 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 720 300 0 0 {name=M2 L=1u W=16u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 740 270 740 250 {lab=OUT}
C {devices/lab_pin.sym} 740 250 0 0 {name=l9 sig_type=std_logic lab=OUT}
N 700 300 680 300 {lab=OUT}
C {devices/lab_pin.sym} 680 300 0 0 {name=l10 sig_type=std_logic lab=OUT}
N 740 330 740 350 {lab=t}
C {devices/lab_pin.sym} 740 350 0 0 {name=l11 sig_type=std_logic lab=t}
N 740 300 760 300 {lab=VSS}
C {devices/lab_pin.sym} 760 300 0 1 {name=l12 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 980 300 0 0 {name=MP1 L=2u W=8u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1000 330 1000 350 {lab=x}
C {devices/lab_pin.sym} 1000 350 0 0 {name=l13 sig_type=std_logic lab=x}
N 960 300 940 300 {lab=x}
C {devices/lab_pin.sym} 940 300 0 0 {name=l14 sig_type=std_logic lab=x}
N 1000 270 1000 250 {lab=VDD}
C {devices/lab_pin.sym} 1000 250 0 0 {name=l15 sig_type=std_logic lab=VDD}
N 1000 300 1020 300 {lab=VDD}
C {devices/lab_pin.sym} 1020 300 0 1 {name=l16 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 1240 300 0 0 {name=MP2 L=2u W=8u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1260 330 1260 350 {lab=OUT}
C {devices/lab_pin.sym} 1260 350 0 0 {name=l17 sig_type=std_logic lab=OUT}
N 1220 300 1200 300 {lab=x}
C {devices/lab_pin.sym} 1200 300 0 0 {name=l18 sig_type=std_logic lab=x}
N 1260 270 1260 250 {lab=VDD}
C {devices/lab_pin.sym} 1260 250 0 0 {name=l19 sig_type=std_logic lab=VDD}
N 1260 300 1280 300 {lab=VDD}
C {devices/lab_pin.sym} 1280 300 0 1 {name=l20 sig_type=std_logic lab=VDD}
C {devices/title.sym} 160 800 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
