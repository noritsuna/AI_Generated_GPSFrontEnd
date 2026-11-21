v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {VDD decoupling: 13 x 16 NMOS fingers 30/5 um (~125 pF)} 100 80 0 0 0.6 0.6 {}
C {devices/iopin.sym} -100 300 0 0 {name=p0 lab=VDD}
C {devices/iopin.sym} -100 330 0 0 {name=p1 lab=VSS}
C {symbols/nfet_03v3.sym} 200 300 0 0 {name=MD0 L=5u W=480u nf=16 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 270 220 250 {lab=VSS}
C {devices/lab_pin.sym} 220 250 0 0 {name=l1 sig_type=std_logic lab=VSS}
N 180 300 160 300 {lab=VDD}
C {devices/lab_pin.sym} 160 300 0 0 {name=l2 sig_type=std_logic lab=VDD}
N 220 330 220 350 {lab=VSS}
C {devices/lab_pin.sym} 220 350 0 0 {name=l3 sig_type=std_logic lab=VSS}
N 220 300 240 300 {lab=VSS}
C {devices/lab_pin.sym} 240 300 0 1 {name=l4 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 460 300 0 0 {name=MD1 L=5u W=480u nf=16 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 480 270 480 250 {lab=VSS}
C {devices/lab_pin.sym} 480 250 0 0 {name=l5 sig_type=std_logic lab=VSS}
N 440 300 420 300 {lab=VDD}
C {devices/lab_pin.sym} 420 300 0 0 {name=l6 sig_type=std_logic lab=VDD}
N 480 330 480 350 {lab=VSS}
C {devices/lab_pin.sym} 480 350 0 0 {name=l7 sig_type=std_logic lab=VSS}
N 480 300 500 300 {lab=VSS}
C {devices/lab_pin.sym} 500 300 0 1 {name=l8 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 720 300 0 0 {name=MD2 L=5u W=480u nf=16 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 740 270 740 250 {lab=VSS}
C {devices/lab_pin.sym} 740 250 0 0 {name=l9 sig_type=std_logic lab=VSS}
N 700 300 680 300 {lab=VDD}
C {devices/lab_pin.sym} 680 300 0 0 {name=l10 sig_type=std_logic lab=VDD}
N 740 330 740 350 {lab=VSS}
C {devices/lab_pin.sym} 740 350 0 0 {name=l11 sig_type=std_logic lab=VSS}
N 740 300 760 300 {lab=VSS}
C {devices/lab_pin.sym} 760 300 0 1 {name=l12 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 980 300 0 0 {name=MD3 L=5u W=480u nf=16 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 1000 270 1000 250 {lab=VSS}
C {devices/lab_pin.sym} 1000 250 0 0 {name=l13 sig_type=std_logic lab=VSS}
N 960 300 940 300 {lab=VDD}
C {devices/lab_pin.sym} 940 300 0 0 {name=l14 sig_type=std_logic lab=VDD}
N 1000 330 1000 350 {lab=VSS}
C {devices/lab_pin.sym} 1000 350 0 0 {name=l15 sig_type=std_logic lab=VSS}
N 1000 300 1020 300 {lab=VSS}
C {devices/lab_pin.sym} 1020 300 0 1 {name=l16 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 1240 300 0 0 {name=MD4 L=5u W=480u nf=16 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 1260 270 1260 250 {lab=VSS}
C {devices/lab_pin.sym} 1260 250 0 0 {name=l17 sig_type=std_logic lab=VSS}
N 1220 300 1200 300 {lab=VDD}
C {devices/lab_pin.sym} 1200 300 0 0 {name=l18 sig_type=std_logic lab=VDD}
N 1260 330 1260 350 {lab=VSS}
C {devices/lab_pin.sym} 1260 350 0 0 {name=l19 sig_type=std_logic lab=VSS}
N 1260 300 1280 300 {lab=VSS}
C {devices/lab_pin.sym} 1280 300 0 1 {name=l20 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 1500 300 0 0 {name=MD5 L=5u W=480u nf=16 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 1520 270 1520 250 {lab=VSS}
C {devices/lab_pin.sym} 1520 250 0 0 {name=l21 sig_type=std_logic lab=VSS}
N 1480 300 1460 300 {lab=VDD}
C {devices/lab_pin.sym} 1460 300 0 0 {name=l22 sig_type=std_logic lab=VDD}
N 1520 330 1520 350 {lab=VSS}
C {devices/lab_pin.sym} 1520 350 0 0 {name=l23 sig_type=std_logic lab=VSS}
N 1520 300 1540 300 {lab=VSS}
C {devices/lab_pin.sym} 1540 300 0 1 {name=l24 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 200 500 0 0 {name=MD6 L=5u W=480u nf=16 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 470 220 450 {lab=VSS}
C {devices/lab_pin.sym} 220 450 0 0 {name=l25 sig_type=std_logic lab=VSS}
N 180 500 160 500 {lab=VDD}
C {devices/lab_pin.sym} 160 500 0 0 {name=l26 sig_type=std_logic lab=VDD}
N 220 530 220 550 {lab=VSS}
C {devices/lab_pin.sym} 220 550 0 0 {name=l27 sig_type=std_logic lab=VSS}
N 220 500 240 500 {lab=VSS}
C {devices/lab_pin.sym} 240 500 0 1 {name=l28 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 460 500 0 0 {name=MD7 L=5u W=480u nf=16 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 480 470 480 450 {lab=VSS}
C {devices/lab_pin.sym} 480 450 0 0 {name=l29 sig_type=std_logic lab=VSS}
N 440 500 420 500 {lab=VDD}
C {devices/lab_pin.sym} 420 500 0 0 {name=l30 sig_type=std_logic lab=VDD}
N 480 530 480 550 {lab=VSS}
C {devices/lab_pin.sym} 480 550 0 0 {name=l31 sig_type=std_logic lab=VSS}
N 480 500 500 500 {lab=VSS}
C {devices/lab_pin.sym} 500 500 0 1 {name=l32 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 720 500 0 0 {name=MD8 L=5u W=480u nf=16 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 740 470 740 450 {lab=VSS}
C {devices/lab_pin.sym} 740 450 0 0 {name=l33 sig_type=std_logic lab=VSS}
N 700 500 680 500 {lab=VDD}
C {devices/lab_pin.sym} 680 500 0 0 {name=l34 sig_type=std_logic lab=VDD}
N 740 530 740 550 {lab=VSS}
C {devices/lab_pin.sym} 740 550 0 0 {name=l35 sig_type=std_logic lab=VSS}
N 740 500 760 500 {lab=VSS}
C {devices/lab_pin.sym} 760 500 0 1 {name=l36 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 980 500 0 0 {name=MD9 L=5u W=480u nf=16 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 1000 470 1000 450 {lab=VSS}
C {devices/lab_pin.sym} 1000 450 0 0 {name=l37 sig_type=std_logic lab=VSS}
N 960 500 940 500 {lab=VDD}
C {devices/lab_pin.sym} 940 500 0 0 {name=l38 sig_type=std_logic lab=VDD}
N 1000 530 1000 550 {lab=VSS}
C {devices/lab_pin.sym} 1000 550 0 0 {name=l39 sig_type=std_logic lab=VSS}
N 1000 500 1020 500 {lab=VSS}
C {devices/lab_pin.sym} 1020 500 0 1 {name=l40 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 1240 500 0 0 {name=MD10 L=5u W=480u nf=16 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 1260 470 1260 450 {lab=VSS}
C {devices/lab_pin.sym} 1260 450 0 0 {name=l41 sig_type=std_logic lab=VSS}
N 1220 500 1200 500 {lab=VDD}
C {devices/lab_pin.sym} 1200 500 0 0 {name=l42 sig_type=std_logic lab=VDD}
N 1260 530 1260 550 {lab=VSS}
C {devices/lab_pin.sym} 1260 550 0 0 {name=l43 sig_type=std_logic lab=VSS}
N 1260 500 1280 500 {lab=VSS}
C {devices/lab_pin.sym} 1280 500 0 1 {name=l44 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 1500 500 0 0 {name=MD11 L=5u W=480u nf=16 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 1520 470 1520 450 {lab=VSS}
C {devices/lab_pin.sym} 1520 450 0 0 {name=l45 sig_type=std_logic lab=VSS}
N 1480 500 1460 500 {lab=VDD}
C {devices/lab_pin.sym} 1460 500 0 0 {name=l46 sig_type=std_logic lab=VDD}
N 1520 530 1520 550 {lab=VSS}
C {devices/lab_pin.sym} 1520 550 0 0 {name=l47 sig_type=std_logic lab=VSS}
N 1520 500 1540 500 {lab=VSS}
C {devices/lab_pin.sym} 1540 500 0 1 {name=l48 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 200 700 0 0 {name=MD12 L=5u W=480u nf=16 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 670 220 650 {lab=VSS}
C {devices/lab_pin.sym} 220 650 0 0 {name=l49 sig_type=std_logic lab=VSS}
N 180 700 160 700 {lab=VDD}
C {devices/lab_pin.sym} 160 700 0 0 {name=l50 sig_type=std_logic lab=VDD}
N 220 730 220 750 {lab=VSS}
C {devices/lab_pin.sym} 220 750 0 0 {name=l51 sig_type=std_logic lab=VSS}
N 220 700 240 700 {lab=VSS}
C {devices/lab_pin.sym} 240 700 0 1 {name=l52 sig_type=std_logic lab=VSS}
C {devices/title.sym} 160 1200 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
