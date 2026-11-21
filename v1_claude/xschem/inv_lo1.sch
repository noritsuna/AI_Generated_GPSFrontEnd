v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {inv_lo1: CMOS inverter} 100 80 0 0 0.6 0.6 {}
C {devices/ipin.sym} -100 300 0 0 {name=p0 lab=A}
C {devices/opin.sym} -100 330 0 0 {name=p1 lab=Y}
C {devices/iopin.sym} -100 360 0 0 {name=p2 lab=VDD}
C {devices/iopin.sym} -100 390 0 0 {name=p3 lab=VSS}
C {symbols/nfet_03v3.sym} 200 300 0 0 {name=MN L=0.28u W=2u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 270 220 250 {lab=Y}
C {devices/lab_pin.sym} 220 250 0 0 {name=l1 sig_type=std_logic lab=Y}
N 180 300 160 300 {lab=A}
C {devices/lab_pin.sym} 160 300 0 0 {name=l2 sig_type=std_logic lab=A}
N 220 330 220 350 {lab=VSS}
C {devices/lab_pin.sym} 220 350 0 0 {name=l3 sig_type=std_logic lab=VSS}
N 220 300 240 300 {lab=VSS}
C {devices/lab_pin.sym} 240 300 0 1 {name=l4 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 460 300 0 0 {name=MP L=0.28u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 480 330 480 350 {lab=Y}
C {devices/lab_pin.sym} 480 350 0 0 {name=l5 sig_type=std_logic lab=Y}
N 440 300 420 300 {lab=A}
C {devices/lab_pin.sym} 420 300 0 0 {name=l6 sig_type=std_logic lab=A}
N 480 270 480 250 {lab=VDD}
C {devices/lab_pin.sym} 480 250 0 0 {name=l7 sig_type=std_logic lab=VDD}
N 480 300 500 300 {lab=VDD}
C {devices/lab_pin.sym} 500 300 0 1 {name=l8 sig_type=std_logic lab=VDD}
C {devices/title.sym} 160 800 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
