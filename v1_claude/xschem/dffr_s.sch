v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {Static TG master-slave DFF, async reset (SPI shift register)} 100 80 0 0 0.6 0.6 {}
T {master (transparent CK=0)} 100 390 0 0 0.4 0.4 {layer=8}
T {slave (transparent CK=1)} 100 790 0 0 0.4 0.4 {layer=8}
C {devices/ipin.sym} -100 300 0 0 {name=p0 lab=D}
C {devices/ipin.sym} -100 330 0 0 {name=p1 lab=CK}
C {devices/ipin.sym} -100 360 0 0 {name=p2 lab=RST}
C {devices/opin.sym} -100 390 0 0 {name=p3 lab=Q}
C {devices/iopin.sym} -100 420 0 0 {name=p4 lab=VDD}
C {devices/iopin.sym} -100 450 0 0 {name=p5 lab=VSS}
C {inv_dig.sym} 200 300 0 0 {name=XCI }
N 100 280 80 280 {lab=CK}
C {devices/lab_pin.sym} 80 280 0 0 {name=l1 sig_type=std_logic lab=CK}
N 300 280 320 280 {lab=ckb}
C {devices/lab_pin.sym} 320 280 0 1 {name=l2 sig_type=std_logic lab=ckb}
N 300 300 320 300 {lab=VDD}
C {devices/lab_pin.sym} 320 300 0 1 {name=l3 sig_type=std_logic lab=VDD}
N 300 320 320 320 {lab=VSS}
C {devices/lab_pin.sym} 320 320 0 1 {name=l4 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 200 500 0 0 {name=T1N L=0.28u W=1u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 470 220 450 {lab=D}
C {devices/lab_pin.sym} 220 450 0 0 {name=l5 sig_type=std_logic lab=D}
N 180 500 160 500 {lab=ckb}
C {devices/lab_pin.sym} 160 500 0 0 {name=l6 sig_type=std_logic lab=ckb}
N 220 530 220 550 {lab=m}
C {devices/lab_pin.sym} 220 550 0 0 {name=l7 sig_type=std_logic lab=m}
N 220 500 240 500 {lab=VSS}
C {devices/lab_pin.sym} 240 500 0 1 {name=l8 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 500 500 0 0 {name=T1P L=0.28u W=2u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 520 530 520 550 {lab=D}
C {devices/lab_pin.sym} 520 550 0 0 {name=l9 sig_type=std_logic lab=D}
N 480 500 460 500 {lab=CK}
C {devices/lab_pin.sym} 460 500 0 0 {name=l10 sig_type=std_logic lab=CK}
N 520 470 520 450 {lab=m}
C {devices/lab_pin.sym} 520 450 0 0 {name=l11 sig_type=std_logic lab=m}
N 520 500 540 500 {lab=VDD}
C {devices/lab_pin.sym} 540 500 0 1 {name=l12 sig_type=std_logic lab=VDD}
C {nor2.sym} 800 500 0 0 {name=XM }
N 700 480 680 480 {lab=m}
C {devices/lab_pin.sym} 680 480 0 0 {name=l13 sig_type=std_logic lab=m}
N 700 500 680 500 {lab=RST}
C {devices/lab_pin.sym} 680 500 0 0 {name=l14 sig_type=std_logic lab=RST}
N 900 480 920 480 {lab=mb}
C {devices/lab_pin.sym} 920 480 0 1 {name=l15 sig_type=std_logic lab=mb}
N 900 500 920 500 {lab=VDD}
C {devices/lab_pin.sym} 920 500 0 1 {name=l16 sig_type=std_logic lab=VDD}
N 900 520 920 520 {lab=VSS}
C {devices/lab_pin.sym} 920 520 0 1 {name=l17 sig_type=std_logic lab=VSS}
C {inv_dig.sym} 1100 500 0 0 {name=XMF }
N 1000 480 980 480 {lab=mb}
C {devices/lab_pin.sym} 980 480 0 0 {name=l18 sig_type=std_logic lab=mb}
N 1200 480 1220 480 {lab=mf}
C {devices/lab_pin.sym} 1220 480 0 1 {name=l19 sig_type=std_logic lab=mf}
N 1200 500 1220 500 {lab=VDD}
C {devices/lab_pin.sym} 1220 500 0 1 {name=l20 sig_type=std_logic lab=VDD}
N 1200 520 1220 520 {lab=VSS}
C {devices/lab_pin.sym} 1220 520 0 1 {name=l21 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 200 700 0 0 {name=T2N L=0.28u W=1u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 670 220 650 {lab=mf}
C {devices/lab_pin.sym} 220 650 0 0 {name=l22 sig_type=std_logic lab=mf}
N 180 700 160 700 {lab=CK}
C {devices/lab_pin.sym} 160 700 0 0 {name=l23 sig_type=std_logic lab=CK}
N 220 730 220 750 {lab=m}
C {devices/lab_pin.sym} 220 750 0 0 {name=l24 sig_type=std_logic lab=m}
N 220 700 240 700 {lab=VSS}
C {devices/lab_pin.sym} 240 700 0 1 {name=l25 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 500 700 0 0 {name=T2P L=0.28u W=2u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 520 730 520 750 {lab=mf}
C {devices/lab_pin.sym} 520 750 0 0 {name=l26 sig_type=std_logic lab=mf}
N 480 700 460 700 {lab=ckb}
C {devices/lab_pin.sym} 460 700 0 0 {name=l27 sig_type=std_logic lab=ckb}
N 520 670 520 650 {lab=m}
C {devices/lab_pin.sym} 520 650 0 0 {name=l28 sig_type=std_logic lab=m}
N 520 700 540 700 {lab=VDD}
C {devices/lab_pin.sym} 540 700 0 1 {name=l29 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 200 900 0 0 {name=T3N L=0.28u W=1u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 870 220 850 {lab=mb}
C {devices/lab_pin.sym} 220 850 0 0 {name=l30 sig_type=std_logic lab=mb}
N 180 900 160 900 {lab=CK}
C {devices/lab_pin.sym} 160 900 0 0 {name=l31 sig_type=std_logic lab=CK}
N 220 930 220 950 {lab=sl}
C {devices/lab_pin.sym} 220 950 0 0 {name=l32 sig_type=std_logic lab=sl}
N 220 900 240 900 {lab=VSS}
C {devices/lab_pin.sym} 240 900 0 1 {name=l33 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 500 900 0 0 {name=T3P L=0.28u W=2u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 520 930 520 950 {lab=mb}
C {devices/lab_pin.sym} 520 950 0 0 {name=l34 sig_type=std_logic lab=mb}
N 480 900 460 900 {lab=ckb}
C {devices/lab_pin.sym} 460 900 0 0 {name=l35 sig_type=std_logic lab=ckb}
N 520 870 520 850 {lab=sl}
C {devices/lab_pin.sym} 520 850 0 0 {name=l36 sig_type=std_logic lab=sl}
N 520 900 540 900 {lab=VDD}
C {devices/lab_pin.sym} 540 900 0 1 {name=l37 sig_type=std_logic lab=VDD}
C {nor2.sym} 800 900 0 0 {name=XS }
N 700 880 680 880 {lab=sl}
C {devices/lab_pin.sym} 680 880 0 0 {name=l38 sig_type=std_logic lab=sl}
N 700 900 680 900 {lab=RST}
C {devices/lab_pin.sym} 680 900 0 0 {name=l39 sig_type=std_logic lab=RST}
N 900 880 920 880 {lab=Q}
C {devices/lab_pin.sym} 920 880 0 1 {name=l40 sig_type=std_logic lab=Q}
N 900 900 920 900 {lab=VDD}
C {devices/lab_pin.sym} 920 900 0 1 {name=l41 sig_type=std_logic lab=VDD}
N 900 920 920 920 {lab=VSS}
C {devices/lab_pin.sym} 920 920 0 1 {name=l42 sig_type=std_logic lab=VSS}
C {inv_dig.sym} 1100 900 0 0 {name=XSF }
N 1000 880 980 880 {lab=Q}
C {devices/lab_pin.sym} 980 880 0 0 {name=l43 sig_type=std_logic lab=Q}
N 1200 880 1220 880 {lab=sf}
C {devices/lab_pin.sym} 1220 880 0 1 {name=l44 sig_type=std_logic lab=sf}
N 1200 900 1220 900 {lab=VDD}
C {devices/lab_pin.sym} 1220 900 0 1 {name=l45 sig_type=std_logic lab=VDD}
N 1200 920 1220 920 {lab=VSS}
C {devices/lab_pin.sym} 1220 920 0 1 {name=l46 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 200 1100 0 0 {name=T4N L=0.28u W=1u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 1070 220 1050 {lab=sf}
C {devices/lab_pin.sym} 220 1050 0 0 {name=l47 sig_type=std_logic lab=sf}
N 180 1100 160 1100 {lab=ckb}
C {devices/lab_pin.sym} 160 1100 0 0 {name=l48 sig_type=std_logic lab=ckb}
N 220 1130 220 1150 {lab=sl}
C {devices/lab_pin.sym} 220 1150 0 0 {name=l49 sig_type=std_logic lab=sl}
N 220 1100 240 1100 {lab=VSS}
C {devices/lab_pin.sym} 240 1100 0 1 {name=l50 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 500 1100 0 0 {name=T4P L=0.28u W=2u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 520 1130 520 1150 {lab=sf}
C {devices/lab_pin.sym} 520 1150 0 0 {name=l51 sig_type=std_logic lab=sf}
N 480 1100 460 1100 {lab=CK}
C {devices/lab_pin.sym} 460 1100 0 0 {name=l52 sig_type=std_logic lab=CK}
N 520 1070 520 1050 {lab=sl}
C {devices/lab_pin.sym} 520 1050 0 0 {name=l53 sig_type=std_logic lab=sl}
N 520 1100 540 1100 {lab=VDD}
C {devices/lab_pin.sym} 540 1100 0 1 {name=l54 sig_type=std_logic lab=VDD}
C {devices/title.sym} 160 1600 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
