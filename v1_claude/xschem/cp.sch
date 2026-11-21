v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {Current-steering charge pump, Icp = 100 uA (x2 when HI = 1), vd buffered to OUT} 100 80 0 0 0.6 0.6 {}
T {boost leg (HI = 1)} 100 590 0 0 0.4 0.4 {layer=8}
T {unity-gain buffer vd = OUT (NMOS pair, 50 uA tail from NB): sinks / sources the up / down mismatch} 100 990 0 0 0.4 0.4 {layer=8}
C {devices/ipin.sym} -100 300 0 0 {name=p0 lab=UPB}
C {devices/ipin.sym} -100 330 0 0 {name=p1 lab=DN}
C {devices/ipin.sym} -100 360 0 0 {name=p2 lab=DNB}
C {devices/ipin.sym} -100 390 0 0 {name=p3 lab=PB}
C {devices/ipin.sym} -100 420 0 0 {name=p4 lab=NB}
C {devices/ipin.sym} -100 450 0 0 {name=p5 lab=HI}
C {devices/opin.sym} -100 480 0 0 {name=p6 lab=OUT}
C {devices/iopin.sym} -100 510 0 0 {name=p7 lab=VDD}
C {devices/iopin.sym} -100 540 0 0 {name=p8 lab=VSS}
C {inv_dig.sym} 200 300 0 0 {name=XUD }
N 100 280 80 280 {lab=UPB}
C {devices/lab_pin.sym} 80 280 0 0 {name=l1 sig_type=std_logic lab=UPB}
N 300 280 320 280 {lab=upd}
C {devices/lab_pin.sym} 320 280 0 1 {name=l2 sig_type=std_logic lab=upd}
N 300 300 320 300 {lab=VDD}
C {devices/lab_pin.sym} 320 300 0 1 {name=l3 sig_type=std_logic lab=VDD}
N 300 320 320 320 {lab=VSS}
C {devices/lab_pin.sym} 320 320 0 1 {name=l4 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 460 300 0 0 {name=MPC L=2u W=32u nf=4 m=2 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 480 330 480 350 {lab=pc}
C {devices/lab_pin.sym} 480 350 0 0 {name=l5 sig_type=std_logic lab=pc}
N 440 300 420 300 {lab=PB}
C {devices/lab_pin.sym} 420 300 0 0 {name=l6 sig_type=std_logic lab=PB}
N 480 270 480 250 {lab=VDD}
C {devices/lab_pin.sym} 480 250 0 0 {name=l7 sig_type=std_logic lab=VDD}
N 480 300 500 300 {lab=VDD}
C {devices/lab_pin.sym} 500 300 0 1 {name=l8 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 720 300 0 0 {name=MPS L=0.28u W=8u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 740 330 740 350 {lab=OUT}
C {devices/lab_pin.sym} 740 350 0 0 {name=l9 sig_type=std_logic lab=OUT}
N 700 300 680 300 {lab=UPB}
C {devices/lab_pin.sym} 680 300 0 0 {name=l10 sig_type=std_logic lab=UPB}
N 740 270 740 250 {lab=pc}
C {devices/lab_pin.sym} 740 250 0 0 {name=l11 sig_type=std_logic lab=pc}
N 740 300 760 300 {lab=VDD}
C {devices/lab_pin.sym} 760 300 0 1 {name=l12 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 980 300 0 0 {name=MPD L=0.28u W=8u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1000 330 1000 350 {lab=vd}
C {devices/lab_pin.sym} 1000 350 0 0 {name=l13 sig_type=std_logic lab=vd}
N 960 300 940 300 {lab=upd}
C {devices/lab_pin.sym} 940 300 0 0 {name=l14 sig_type=std_logic lab=upd}
N 1000 270 1000 250 {lab=pc}
C {devices/lab_pin.sym} 1000 250 0 0 {name=l15 sig_type=std_logic lab=pc}
N 1000 300 1020 300 {lab=VDD}
C {devices/lab_pin.sym} 1020 300 0 1 {name=l16 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 1240 300 0 0 {name=MNS L=0.28u W=2u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 1260 270 1260 250 {lab=OUT}
C {devices/lab_pin.sym} 1260 250 0 0 {name=l17 sig_type=std_logic lab=OUT}
N 1220 300 1200 300 {lab=DN}
C {devices/lab_pin.sym} 1200 300 0 0 {name=l18 sig_type=std_logic lab=DN}
N 1260 330 1260 350 {lab=nc}
C {devices/lab_pin.sym} 1260 350 0 0 {name=l19 sig_type=std_logic lab=nc}
N 1260 300 1280 300 {lab=VSS}
C {devices/lab_pin.sym} 1280 300 0 1 {name=l20 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 1500 300 0 0 {name=MND L=0.28u W=2u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 1520 270 1520 250 {lab=vd}
C {devices/lab_pin.sym} 1520 250 0 0 {name=l21 sig_type=std_logic lab=vd}
N 1480 300 1460 300 {lab=DNB}
C {devices/lab_pin.sym} 1460 300 0 0 {name=l22 sig_type=std_logic lab=DNB}
N 1520 330 1520 350 {lab=nc}
C {devices/lab_pin.sym} 1520 350 0 0 {name=l23 sig_type=std_logic lab=nc}
N 1520 300 1540 300 {lab=VSS}
C {devices/lab_pin.sym} 1540 300 0 1 {name=l24 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 200 500 0 0 {name=MNC L=2u W=16u nf=2 m=2 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 470 220 450 {lab=nc}
C {devices/lab_pin.sym} 220 450 0 0 {name=l25 sig_type=std_logic lab=nc}
N 180 500 160 500 {lab=NB}
C {devices/lab_pin.sym} 160 500 0 0 {name=l26 sig_type=std_logic lab=NB}
N 220 530 220 550 {lab=VSS}
C {devices/lab_pin.sym} 220 550 0 0 {name=l27 sig_type=std_logic lab=VSS}
N 220 500 240 500 {lab=VSS}
C {devices/lab_pin.sym} 240 500 0 1 {name=l28 sig_type=std_logic lab=VSS}
C {inv_dig.sym} 200 700 0 0 {name=XHI }
N 100 680 80 680 {lab=HI}
C {devices/lab_pin.sym} 80 680 0 0 {name=l29 sig_type=std_logic lab=HI}
N 300 680 320 680 {lab=hib}
C {devices/lab_pin.sym} 320 680 0 1 {name=l30 sig_type=std_logic lab=hib}
N 300 700 320 700 {lab=VDD}
C {devices/lab_pin.sym} 320 700 0 1 {name=l31 sig_type=std_logic lab=VDD}
N 300 720 320 720 {lab=VSS}
C {devices/lab_pin.sym} 320 720 0 1 {name=l32 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 460 700 0 0 {name=MPC2 L=2u W=32u nf=4 m=2 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 480 730 480 750 {lab=pc2}
C {devices/lab_pin.sym} 480 750 0 0 {name=l33 sig_type=std_logic lab=pc2}
N 440 700 420 700 {lab=PB}
C {devices/lab_pin.sym} 420 700 0 0 {name=l34 sig_type=std_logic lab=PB}
N 480 670 480 650 {lab=VDD}
C {devices/lab_pin.sym} 480 650 0 0 {name=l35 sig_type=std_logic lab=VDD}
N 480 700 500 700 {lab=VDD}
C {devices/lab_pin.sym} 500 700 0 1 {name=l36 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 720 700 0 0 {name=MPE2 L=0.28u W=24u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 740 730 740 750 {lab=pe2}
C {devices/lab_pin.sym} 740 750 0 0 {name=l37 sig_type=std_logic lab=pe2}
N 700 700 680 700 {lab=hib}
C {devices/lab_pin.sym} 680 700 0 0 {name=l38 sig_type=std_logic lab=hib}
N 740 670 740 650 {lab=pc2}
C {devices/lab_pin.sym} 740 650 0 0 {name=l39 sig_type=std_logic lab=pc2}
N 740 700 760 700 {lab=VDD}
C {devices/lab_pin.sym} 760 700 0 1 {name=l40 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 980 700 0 0 {name=MPS2 L=0.28u W=8u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1000 730 1000 750 {lab=OUT}
C {devices/lab_pin.sym} 1000 750 0 0 {name=l41 sig_type=std_logic lab=OUT}
N 960 700 940 700 {lab=UPB}
C {devices/lab_pin.sym} 940 700 0 0 {name=l42 sig_type=std_logic lab=UPB}
N 1000 670 1000 650 {lab=pe2}
C {devices/lab_pin.sym} 1000 650 0 0 {name=l43 sig_type=std_logic lab=pe2}
N 1000 700 1020 700 {lab=VDD}
C {devices/lab_pin.sym} 1020 700 0 1 {name=l44 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 1240 700 0 0 {name=MPD2 L=0.28u W=8u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1260 730 1260 750 {lab=vd}
C {devices/lab_pin.sym} 1260 750 0 0 {name=l45 sig_type=std_logic lab=vd}
N 1220 700 1200 700 {lab=upd}
C {devices/lab_pin.sym} 1200 700 0 0 {name=l46 sig_type=std_logic lab=upd}
N 1260 670 1260 650 {lab=pe2}
C {devices/lab_pin.sym} 1260 650 0 0 {name=l47 sig_type=std_logic lab=pe2}
N 1260 700 1280 700 {lab=VDD}
C {devices/lab_pin.sym} 1280 700 0 1 {name=l48 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 1500 700 0 0 {name=MNS2 L=0.28u W=2u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 1520 670 1520 650 {lab=OUT}
C {devices/lab_pin.sym} 1520 650 0 0 {name=l49 sig_type=std_logic lab=OUT}
N 1480 700 1460 700 {lab=DN}
C {devices/lab_pin.sym} 1460 700 0 0 {name=l50 sig_type=std_logic lab=DN}
N 1520 730 1520 750 {lab=ne2}
C {devices/lab_pin.sym} 1520 750 0 0 {name=l51 sig_type=std_logic lab=ne2}
N 1520 700 1540 700 {lab=VSS}
C {devices/lab_pin.sym} 1540 700 0 1 {name=l52 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 200 900 0 0 {name=MND2 L=0.28u W=2u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 870 220 850 {lab=vd}
C {devices/lab_pin.sym} 220 850 0 0 {name=l53 sig_type=std_logic lab=vd}
N 180 900 160 900 {lab=DNB}
C {devices/lab_pin.sym} 160 900 0 0 {name=l54 sig_type=std_logic lab=DNB}
N 220 930 220 950 {lab=ne2}
C {devices/lab_pin.sym} 220 950 0 0 {name=l55 sig_type=std_logic lab=ne2}
N 220 900 240 900 {lab=VSS}
C {devices/lab_pin.sym} 240 900 0 1 {name=l56 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 460 900 0 0 {name=MNE2 L=0.28u W=4u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 480 870 480 850 {lab=ne2}
C {devices/lab_pin.sym} 480 850 0 0 {name=l57 sig_type=std_logic lab=ne2}
N 440 900 420 900 {lab=HI}
C {devices/lab_pin.sym} 420 900 0 0 {name=l58 sig_type=std_logic lab=HI}
N 480 930 480 950 {lab=nc2}
C {devices/lab_pin.sym} 480 950 0 0 {name=l59 sig_type=std_logic lab=nc2}
N 480 900 500 900 {lab=VSS}
C {devices/lab_pin.sym} 500 900 0 1 {name=l60 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 720 900 0 0 {name=MNC2 L=2u W=16u nf=2 m=2 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 740 870 740 850 {lab=nc2}
C {devices/lab_pin.sym} 740 850 0 0 {name=l61 sig_type=std_logic lab=nc2}
N 700 900 680 900 {lab=NB}
C {devices/lab_pin.sym} 680 900 0 0 {name=l62 sig_type=std_logic lab=NB}
N 740 930 740 950 {lab=VSS}
C {devices/lab_pin.sym} 740 950 0 0 {name=l63 sig_type=std_logic lab=VSS}
N 740 900 760 900 {lab=VSS}
C {devices/lab_pin.sym} 760 900 0 1 {name=l64 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 200 1100 0 0 {name=MBT L=2u W=16u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 1070 220 1050 {lab=bt}
C {devices/lab_pin.sym} 220 1050 0 0 {name=l65 sig_type=std_logic lab=bt}
N 180 1100 160 1100 {lab=NB}
C {devices/lab_pin.sym} 160 1100 0 0 {name=l66 sig_type=std_logic lab=NB}
N 220 1130 220 1150 {lab=VSS}
C {devices/lab_pin.sym} 220 1150 0 0 {name=l67 sig_type=std_logic lab=VSS}
N 220 1100 240 1100 {lab=VSS}
C {devices/lab_pin.sym} 240 1100 0 1 {name=l68 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 460 1100 0 0 {name=MB1 L=1u W=8u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 480 1070 480 1050 {lab=b1}
C {devices/lab_pin.sym} 480 1050 0 0 {name=l69 sig_type=std_logic lab=b1}
N 440 1100 420 1100 {lab=OUT}
C {devices/lab_pin.sym} 420 1100 0 0 {name=l70 sig_type=std_logic lab=OUT}
N 480 1130 480 1150 {lab=bt}
C {devices/lab_pin.sym} 480 1150 0 0 {name=l71 sig_type=std_logic lab=bt}
N 480 1100 500 1100 {lab=VSS}
C {devices/lab_pin.sym} 500 1100 0 1 {name=l72 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 720 1100 0 0 {name=MB2 L=1u W=8u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 740 1070 740 1050 {lab=vd}
C {devices/lab_pin.sym} 740 1050 0 0 {name=l73 sig_type=std_logic lab=vd}
N 700 1100 680 1100 {lab=vd}
C {devices/lab_pin.sym} 680 1100 0 0 {name=l74 sig_type=std_logic lab=vd}
N 740 1130 740 1150 {lab=bt}
C {devices/lab_pin.sym} 740 1150 0 0 {name=l75 sig_type=std_logic lab=bt}
N 740 1100 760 1100 {lab=VSS}
C {devices/lab_pin.sym} 760 1100 0 1 {name=l76 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 980 1100 0 0 {name=MBL1 L=1u W=8u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1000 1130 1000 1150 {lab=b1}
C {devices/lab_pin.sym} 1000 1150 0 0 {name=l77 sig_type=std_logic lab=b1}
N 960 1100 940 1100 {lab=b1}
C {devices/lab_pin.sym} 940 1100 0 0 {name=l78 sig_type=std_logic lab=b1}
N 1000 1070 1000 1050 {lab=VDD}
C {devices/lab_pin.sym} 1000 1050 0 0 {name=l79 sig_type=std_logic lab=VDD}
N 1000 1100 1020 1100 {lab=VDD}
C {devices/lab_pin.sym} 1020 1100 0 1 {name=l80 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 1240 1100 0 0 {name=MBL2 L=1u W=8u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1260 1130 1260 1150 {lab=vd}
C {devices/lab_pin.sym} 1260 1150 0 0 {name=l81 sig_type=std_logic lab=vd}
N 1220 1100 1200 1100 {lab=b1}
C {devices/lab_pin.sym} 1200 1100 0 0 {name=l82 sig_type=std_logic lab=b1}
N 1260 1070 1260 1050 {lab=VDD}
C {devices/lab_pin.sym} 1260 1050 0 0 {name=l83 sig_type=std_logic lab=VDD}
N 1260 1100 1280 1100 {lab=VDD}
C {devices/lab_pin.sym} 1280 1100 0 1 {name=l84 sig_type=std_logic lab=VDD}
C {symbols/cap_mim_2f0fF.sym} 1500 1100 0 0 {name=CVD W=32e-6 L=32e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 1500 1070 1500 1050 {lab=vd}
C {devices/lab_pin.sym} 1500 1050 0 0 {name=l85 sig_type=std_logic lab=vd}
N 1500 1130 1500 1150 {lab=VSS}
C {devices/lab_pin.sym} 1500 1150 0 0 {name=l86 sig_type=std_logic lab=VSS}
C {devices/title.sym} 160 1600 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
