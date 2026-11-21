v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {Static D latch, transparent when EN=1} 100 80 0 0 0.6 0.6 {}
C {devices/ipin.sym} -100 300 0 0 {name=p0 lab=D}
C {devices/ipin.sym} -100 330 0 0 {name=p1 lab=EN}
C {devices/opin.sym} -100 360 0 0 {name=p2 lab=Q}
C {devices/iopin.sym} -100 390 0 0 {name=p3 lab=VDD}
C {devices/iopin.sym} -100 420 0 0 {name=p4 lab=VSS}
C {inv_dig.sym} 200 300 0 0 {name=XEI }
N 100 280 80 280 {lab=EN}
C {devices/lab_pin.sym} 80 280 0 0 {name=l1 sig_type=std_logic lab=EN}
N 300 280 320 280 {lab=enb}
C {devices/lab_pin.sym} 320 280 0 1 {name=l2 sig_type=std_logic lab=enb}
N 300 300 320 300 {lab=VDD}
C {devices/lab_pin.sym} 320 300 0 1 {name=l3 sig_type=std_logic lab=VDD}
N 300 320 320 320 {lab=VSS}
C {devices/lab_pin.sym} 320 320 0 1 {name=l4 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 460 300 0 0 {name=TIN L=0.28u W=1u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 480 270 480 250 {lab=D}
C {devices/lab_pin.sym} 480 250 0 0 {name=l5 sig_type=std_logic lab=D}
N 440 300 420 300 {lab=EN}
C {devices/lab_pin.sym} 420 300 0 0 {name=l6 sig_type=std_logic lab=EN}
N 480 330 480 350 {lab=l}
C {devices/lab_pin.sym} 480 350 0 0 {name=l7 sig_type=std_logic lab=l}
N 480 300 500 300 {lab=VSS}
C {devices/lab_pin.sym} 500 300 0 1 {name=l8 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 720 300 0 0 {name=TIP L=0.28u W=2u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 740 330 740 350 {lab=D}
C {devices/lab_pin.sym} 740 350 0 0 {name=l9 sig_type=std_logic lab=D}
N 700 300 680 300 {lab=enb}
C {devices/lab_pin.sym} 680 300 0 0 {name=l10 sig_type=std_logic lab=enb}
N 740 270 740 250 {lab=l}
C {devices/lab_pin.sym} 740 250 0 0 {name=l11 sig_type=std_logic lab=l}
N 740 300 760 300 {lab=VDD}
C {devices/lab_pin.sym} 760 300 0 1 {name=l12 sig_type=std_logic lab=VDD}
C {inv_dig.sym} 980 300 0 0 {name=X1 }
N 880 280 860 280 {lab=l}
C {devices/lab_pin.sym} 860 280 0 0 {name=l13 sig_type=std_logic lab=l}
N 1080 280 1100 280 {lab=lb}
C {devices/lab_pin.sym} 1100 280 0 1 {name=l14 sig_type=std_logic lab=lb}
N 1080 300 1100 300 {lab=VDD}
C {devices/lab_pin.sym} 1100 300 0 1 {name=l15 sig_type=std_logic lab=VDD}
N 1080 320 1100 320 {lab=VSS}
C {devices/lab_pin.sym} 1100 320 0 1 {name=l16 sig_type=std_logic lab=VSS}
C {inv_dig.sym} 1240 300 0 0 {name=X2 }
N 1140 280 1120 280 {lab=lb}
C {devices/lab_pin.sym} 1120 280 0 0 {name=l17 sig_type=std_logic lab=lb}
N 1340 280 1360 280 {lab=Q}
C {devices/lab_pin.sym} 1360 280 0 1 {name=l18 sig_type=std_logic lab=Q}
N 1340 300 1360 300 {lab=VDD}
C {devices/lab_pin.sym} 1360 300 0 1 {name=l19 sig_type=std_logic lab=VDD}
N 1340 320 1360 320 {lab=VSS}
C {devices/lab_pin.sym} 1360 320 0 1 {name=l20 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 1500 300 0 0 {name=TFN L=0.28u W=1u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 1520 270 1520 250 {lab=Q}
C {devices/lab_pin.sym} 1520 250 0 0 {name=l21 sig_type=std_logic lab=Q}
N 1480 300 1460 300 {lab=enb}
C {devices/lab_pin.sym} 1460 300 0 0 {name=l22 sig_type=std_logic lab=enb}
N 1520 330 1520 350 {lab=l}
C {devices/lab_pin.sym} 1520 350 0 0 {name=l23 sig_type=std_logic lab=l}
N 1520 300 1540 300 {lab=VSS}
C {devices/lab_pin.sym} 1540 300 0 1 {name=l24 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 200 500 0 0 {name=TFP L=0.28u W=2u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 220 530 220 550 {lab=Q}
C {devices/lab_pin.sym} 220 550 0 0 {name=l25 sig_type=std_logic lab=Q}
N 180 500 160 500 {lab=EN}
C {devices/lab_pin.sym} 160 500 0 0 {name=l26 sig_type=std_logic lab=EN}
N 220 470 220 450 {lab=l}
C {devices/lab_pin.sym} 220 450 0 0 {name=l27 sig_type=std_logic lab=l}
N 220 500 240 500 {lab=VDD}
C {devices/lab_pin.sym} 240 500 0 1 {name=l28 sig_type=std_logic lab=VDD}
C {devices/title.sym} 160 1000 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
