v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {refbuf: AC-coupled self-biased inverter (level restore to 3.3 V)} 100 80 0 0 0.6 0.6 {}
C {devices/ipin.sym} -100 300 0 0 {name=p0 lab=IN}
C {devices/opin.sym} -100 330 0 0 {name=p1 lab=OUT}
C {devices/iopin.sym} -100 360 0 0 {name=p2 lab=VDD}
C {devices/iopin.sym} -100 390 0 0 {name=p3 lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 200 300 0 0 {name=CIN W=20e-6 L=20e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 200 270 200 250 {lab=IN}
C {devices/lab_pin.sym} 200 250 0 0 {name=l1 sig_type=std_logic lab=IN}
N 200 330 200 350 {lab=a}
C {devices/lab_pin.sym} 200 350 0 0 {name=l2 sig_type=std_logic lab=a}
C {symbols/ppolyf_u_1k.sym} 460 300 0 0 {name=RF W=1u L=200u model=ppolyf_u_1k spiceprefix=X m=1}
N 460 330 460 350 {lab=b}
C {devices/lab_pin.sym} 460 350 0 0 {name=l3 sig_type=std_logic lab=b}
N 460 270 460 250 {lab=a}
C {devices/lab_pin.sym} 460 250 0 0 {name=l4 sig_type=std_logic lab=a}
N 440 300 420 300 {lab=VSS}
C {devices/lab_pin.sym} 420 300 0 0 {name=l5 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 720 300 0 0 {name=MN1 L=0.28u W=2u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 740 270 740 250 {lab=b}
C {devices/lab_pin.sym} 740 250 0 0 {name=l6 sig_type=std_logic lab=b}
N 700 300 680 300 {lab=a}
C {devices/lab_pin.sym} 680 300 0 0 {name=l7 sig_type=std_logic lab=a}
N 740 330 740 350 {lab=VSS}
C {devices/lab_pin.sym} 740 350 0 0 {name=l8 sig_type=std_logic lab=VSS}
N 740 300 760 300 {lab=VSS}
C {devices/lab_pin.sym} 760 300 0 1 {name=l9 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 980 300 0 0 {name=MP1 L=0.28u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1000 330 1000 350 {lab=b}
C {devices/lab_pin.sym} 1000 350 0 0 {name=l10 sig_type=std_logic lab=b}
N 960 300 940 300 {lab=a}
C {devices/lab_pin.sym} 940 300 0 0 {name=l11 sig_type=std_logic lab=a}
N 1000 270 1000 250 {lab=VDD}
C {devices/lab_pin.sym} 1000 250 0 0 {name=l12 sig_type=std_logic lab=VDD}
N 1000 300 1020 300 {lab=VDD}
C {devices/lab_pin.sym} 1020 300 0 1 {name=l13 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 1240 300 0 0 {name=MN2 L=0.28u W=2u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 1260 270 1260 250 {lab=OUT}
C {devices/lab_pin.sym} 1260 250 0 0 {name=l14 sig_type=std_logic lab=OUT}
N 1220 300 1200 300 {lab=b}
C {devices/lab_pin.sym} 1200 300 0 0 {name=l15 sig_type=std_logic lab=b}
N 1260 330 1260 350 {lab=VSS}
C {devices/lab_pin.sym} 1260 350 0 0 {name=l16 sig_type=std_logic lab=VSS}
N 1260 300 1280 300 {lab=VSS}
C {devices/lab_pin.sym} 1280 300 0 1 {name=l17 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 1500 300 0 0 {name=MP2 L=0.28u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1520 330 1520 350 {lab=OUT}
C {devices/lab_pin.sym} 1520 350 0 0 {name=l18 sig_type=std_logic lab=OUT}
N 1480 300 1460 300 {lab=b}
C {devices/lab_pin.sym} 1460 300 0 0 {name=l19 sig_type=std_logic lab=b}
N 1520 270 1520 250 {lab=VDD}
C {devices/lab_pin.sym} 1520 250 0 0 {name=l20 sig_type=std_logic lab=VDD}
N 1520 300 1540 300 {lab=VDD}
C {devices/lab_pin.sym} 1540 300 0 1 {name=l21 sig_type=std_logic lab=VDD}
C {devices/title.sym} 160 800 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
