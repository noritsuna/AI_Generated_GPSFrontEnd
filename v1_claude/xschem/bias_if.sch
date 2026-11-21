v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {IF VGA tail bias: I = a VDD / Rpoly (ratiometric)} 100 80 0 0 0.6 0.6 {}
T {divider a = 28.3 / 98.3} 100 190 0 0 0.4 0.4 {layer=8}
T {PMOS-input OTA (50 uA tail from PB) forces v(x) = v(vdiv)} 100 390 0 0 0.4 0.4 {layer=8}
T {V-I: MV + RREF (9 x VGA load unit), PMOS mirror 1:1 -> NMOS diode NBIF} 100 590 0 0 0.4 0.4 {layer=8}
T {PMOS bias for the Sallen-Key followers (same Iref)} 100 1190 0 0 0.4 0.4 {layer=8}
C {devices/ipin.sym} -100 300 0 0 {name=p0 lab=PB}
C {devices/opin.sym} -100 330 0 0 {name=p1 lab=NBIF}
C {devices/opin.sym} -100 360 0 0 {name=p2 lab=PBIF}
C {devices/iopin.sym} -100 390 0 0 {name=p3 lab=VDD}
C {devices/iopin.sym} -100 420 0 0 {name=p4 lab=VSS}
C {symbols/ppolyf_u_1k.sym} 200 300 0 0 {name=RDA W=1u L=70u model=ppolyf_u_1k spiceprefix=X m=1}
N 200 330 200 350 {lab=vdiv}
C {devices/lab_pin.sym} 200 350 0 0 {name=l1 sig_type=std_logic lab=vdiv}
N 200 270 200 250 {lab=VDD}
C {devices/lab_pin.sym} 200 250 0 0 {name=l2 sig_type=std_logic lab=VDD}
N 180 300 160 300 {lab=VSS}
C {devices/lab_pin.sym} 160 300 0 0 {name=l3 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 460 300 0 0 {name=RDB W=1u L=28.3u model=ppolyf_u_1k spiceprefix=X m=1}
N 460 330 460 350 {lab=VSS}
C {devices/lab_pin.sym} 460 350 0 0 {name=l4 sig_type=std_logic lab=VSS}
N 460 270 460 250 {lab=vdiv}
C {devices/lab_pin.sym} 460 250 0 0 {name=l5 sig_type=std_logic lab=vdiv}
N 440 300 420 300 {lab=VSS}
C {devices/lab_pin.sym} 420 300 0 0 {name=l6 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 200 500 0 0 {name=MOT L=2u W=32u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 220 530 220 550 {lab=ot}
C {devices/lab_pin.sym} 220 550 0 0 {name=l7 sig_type=std_logic lab=ot}
N 180 500 160 500 {lab=PB}
C {devices/lab_pin.sym} 160 500 0 0 {name=l8 sig_type=std_logic lab=PB}
N 220 470 220 450 {lab=VDD}
C {devices/lab_pin.sym} 220 450 0 0 {name=l9 sig_type=std_logic lab=VDD}
N 220 500 240 500 {lab=VDD}
C {devices/lab_pin.sym} 240 500 0 1 {name=l10 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 460 500 0 0 {name=MI1 L=1u W=16u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 480 530 480 550 {lab=o1}
C {devices/lab_pin.sym} 480 550 0 0 {name=l11 sig_type=std_logic lab=o1}
N 440 500 420 500 {lab=vdiv}
C {devices/lab_pin.sym} 420 500 0 0 {name=l12 sig_type=std_logic lab=vdiv}
N 480 470 480 450 {lab=ot}
C {devices/lab_pin.sym} 480 450 0 0 {name=l13 sig_type=std_logic lab=ot}
N 480 500 500 500 {lab=VDD}
C {devices/lab_pin.sym} 500 500 0 1 {name=l14 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 720 500 0 0 {name=MI2 L=1u W=16u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 740 530 740 550 {lab=og}
C {devices/lab_pin.sym} 740 550 0 0 {name=l15 sig_type=std_logic lab=og}
N 700 500 680 500 {lab=x}
C {devices/lab_pin.sym} 680 500 0 0 {name=l16 sig_type=std_logic lab=x}
N 740 470 740 450 {lab=ot}
C {devices/lab_pin.sym} 740 450 0 0 {name=l17 sig_type=std_logic lab=ot}
N 740 500 760 500 {lab=VDD}
C {devices/lab_pin.sym} 760 500 0 1 {name=l18 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 980 500 0 0 {name=ML1 L=2u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 1000 470 1000 450 {lab=o1}
C {devices/lab_pin.sym} 1000 450 0 0 {name=l19 sig_type=std_logic lab=o1}
N 960 500 940 500 {lab=o1}
C {devices/lab_pin.sym} 940 500 0 0 {name=l20 sig_type=std_logic lab=o1}
N 1000 530 1000 550 {lab=VSS}
C {devices/lab_pin.sym} 1000 550 0 0 {name=l21 sig_type=std_logic lab=VSS}
N 1000 500 1020 500 {lab=VSS}
C {devices/lab_pin.sym} 1020 500 0 1 {name=l22 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 1240 500 0 0 {name=ML2 L=2u W=4u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 1260 470 1260 450 {lab=og}
C {devices/lab_pin.sym} 1260 450 0 0 {name=l23 sig_type=std_logic lab=og}
N 1220 500 1200 500 {lab=o1}
C {devices/lab_pin.sym} 1200 500 0 0 {name=l24 sig_type=std_logic lab=o1}
N 1260 530 1260 550 {lab=VSS}
C {devices/lab_pin.sym} 1260 550 0 0 {name=l25 sig_type=std_logic lab=VSS}
N 1260 500 1280 500 {lab=VSS}
C {devices/lab_pin.sym} 1280 500 0 1 {name=l26 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 1500 500 0 0 {name=CC W=20e-6 L=20e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 1500 470 1500 450 {lab=og}
C {devices/lab_pin.sym} 1500 450 0 0 {name=l27 sig_type=std_logic lab=og}
N 1500 530 1500 550 {lab=VSS}
C {devices/lab_pin.sym} 1500 550 0 0 {name=l28 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 200 700 0 0 {name=MV L=1u W=20u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 670 220 650 {lab=dp}
C {devices/lab_pin.sym} 220 650 0 0 {name=l29 sig_type=std_logic lab=dp}
N 180 700 160 700 {lab=og}
C {devices/lab_pin.sym} 160 700 0 0 {name=l30 sig_type=std_logic lab=og}
N 220 730 220 750 {lab=x}
C {devices/lab_pin.sym} 220 750 0 0 {name=l31 sig_type=std_logic lab=x}
N 220 700 240 700 {lab=VSS}
C {devices/lab_pin.sym} 240 700 0 1 {name=l32 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 460 700 0 0 {name=RREF0 W=1u L=2u model=ppolyf_u_1k spiceprefix=X m=1}
N 460 730 460 750 {lab=r1}
C {devices/lab_pin.sym} 460 750 0 0 {name=l33 sig_type=std_logic lab=r1}
N 460 670 460 650 {lab=x}
C {devices/lab_pin.sym} 460 650 0 0 {name=l34 sig_type=std_logic lab=x}
N 440 700 420 700 {lab=VSS}
C {devices/lab_pin.sym} 420 700 0 0 {name=l35 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 720 700 0 0 {name=RREF1 W=1u L=2u model=ppolyf_u_1k spiceprefix=X m=1}
N 720 730 720 750 {lab=r2}
C {devices/lab_pin.sym} 720 750 0 0 {name=l36 sig_type=std_logic lab=r2}
N 720 670 720 650 {lab=r1}
C {devices/lab_pin.sym} 720 650 0 0 {name=l37 sig_type=std_logic lab=r1}
N 700 700 680 700 {lab=VSS}
C {devices/lab_pin.sym} 680 700 0 0 {name=l38 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 980 700 0 0 {name=RREF2 W=1u L=2u model=ppolyf_u_1k spiceprefix=X m=1}
N 980 730 980 750 {lab=r3}
C {devices/lab_pin.sym} 980 750 0 0 {name=l39 sig_type=std_logic lab=r3}
N 980 670 980 650 {lab=r2}
C {devices/lab_pin.sym} 980 650 0 0 {name=l40 sig_type=std_logic lab=r2}
N 960 700 940 700 {lab=VSS}
C {devices/lab_pin.sym} 940 700 0 0 {name=l41 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 1240 700 0 0 {name=RREF3 W=1u L=2u model=ppolyf_u_1k spiceprefix=X m=1}
N 1240 730 1240 750 {lab=r4}
C {devices/lab_pin.sym} 1240 750 0 0 {name=l42 sig_type=std_logic lab=r4}
N 1240 670 1240 650 {lab=r3}
C {devices/lab_pin.sym} 1240 650 0 0 {name=l43 sig_type=std_logic lab=r3}
N 1220 700 1200 700 {lab=VSS}
C {devices/lab_pin.sym} 1200 700 0 0 {name=l44 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 1500 700 0 0 {name=RREF4 W=1u L=2u model=ppolyf_u_1k spiceprefix=X m=1}
N 1500 730 1500 750 {lab=r5}
C {devices/lab_pin.sym} 1500 750 0 0 {name=l45 sig_type=std_logic lab=r5}
N 1500 670 1500 650 {lab=r4}
C {devices/lab_pin.sym} 1500 650 0 0 {name=l46 sig_type=std_logic lab=r4}
N 1480 700 1460 700 {lab=VSS}
C {devices/lab_pin.sym} 1460 700 0 0 {name=l47 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 200 900 0 0 {name=RREF5 W=1u L=2u model=ppolyf_u_1k spiceprefix=X m=1}
N 200 930 200 950 {lab=r6}
C {devices/lab_pin.sym} 200 950 0 0 {name=l48 sig_type=std_logic lab=r6}
N 200 870 200 850 {lab=r5}
C {devices/lab_pin.sym} 200 850 0 0 {name=l49 sig_type=std_logic lab=r5}
N 180 900 160 900 {lab=VSS}
C {devices/lab_pin.sym} 160 900 0 0 {name=l50 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 460 900 0 0 {name=RREF6 W=1u L=2u model=ppolyf_u_1k spiceprefix=X m=1}
N 460 930 460 950 {lab=r7}
C {devices/lab_pin.sym} 460 950 0 0 {name=l51 sig_type=std_logic lab=r7}
N 460 870 460 850 {lab=r6}
C {devices/lab_pin.sym} 460 850 0 0 {name=l52 sig_type=std_logic lab=r6}
N 440 900 420 900 {lab=VSS}
C {devices/lab_pin.sym} 420 900 0 0 {name=l53 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 720 900 0 0 {name=RREF7 W=1u L=2u model=ppolyf_u_1k spiceprefix=X m=1}
N 720 930 720 950 {lab=r8}
C {devices/lab_pin.sym} 720 950 0 0 {name=l54 sig_type=std_logic lab=r8}
N 720 870 720 850 {lab=r7}
C {devices/lab_pin.sym} 720 850 0 0 {name=l55 sig_type=std_logic lab=r7}
N 700 900 680 900 {lab=VSS}
C {devices/lab_pin.sym} 680 900 0 0 {name=l56 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 980 900 0 0 {name=RREF8 W=1u L=2u model=ppolyf_u_1k spiceprefix=X m=1}
N 980 930 980 950 {lab=VSS}
C {devices/lab_pin.sym} 980 950 0 0 {name=l57 sig_type=std_logic lab=VSS}
N 980 870 980 850 {lab=r8}
C {devices/lab_pin.sym} 980 850 0 0 {name=l58 sig_type=std_logic lab=r8}
N 960 900 940 900 {lab=VSS}
C {devices/lab_pin.sym} 940 900 0 0 {name=l59 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 1240 900 0 0 {name=MPD L=2u W=32u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1260 930 1260 950 {lab=dp}
C {devices/lab_pin.sym} 1260 950 0 0 {name=l60 sig_type=std_logic lab=dp}
N 1220 900 1200 900 {lab=dp}
C {devices/lab_pin.sym} 1200 900 0 0 {name=l61 sig_type=std_logic lab=dp}
N 1260 870 1260 850 {lab=VDD}
C {devices/lab_pin.sym} 1260 850 0 0 {name=l62 sig_type=std_logic lab=VDD}
N 1260 900 1280 900 {lab=VDD}
C {devices/lab_pin.sym} 1280 900 0 1 {name=l63 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 1500 900 0 0 {name=MPM L=2u W=32u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1520 930 1520 950 {lab=NBIF}
C {devices/lab_pin.sym} 1520 950 0 0 {name=l64 sig_type=std_logic lab=NBIF}
N 1480 900 1460 900 {lab=dp}
C {devices/lab_pin.sym} 1460 900 0 0 {name=l65 sig_type=std_logic lab=dp}
N 1520 870 1520 850 {lab=VDD}
C {devices/lab_pin.sym} 1520 850 0 0 {name=l66 sig_type=std_logic lab=VDD}
N 1520 900 1540 900 {lab=VDD}
C {devices/lab_pin.sym} 1540 900 0 1 {name=l67 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 200 1100 0 0 {name=MND L=2u W=16u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 1070 220 1050 {lab=NBIF}
C {devices/lab_pin.sym} 220 1050 0 0 {name=l68 sig_type=std_logic lab=NBIF}
N 180 1100 160 1100 {lab=NBIF}
C {devices/lab_pin.sym} 160 1100 0 0 {name=l69 sig_type=std_logic lab=NBIF}
N 220 1130 220 1150 {lab=VSS}
C {devices/lab_pin.sym} 220 1150 0 0 {name=l70 sig_type=std_logic lab=VSS}
N 220 1100 240 1100 {lab=VSS}
C {devices/lab_pin.sym} 240 1100 0 1 {name=l71 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 460 1100 0 0 {name=CNB W=20e-6 L=20e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 460 1070 460 1050 {lab=NBIF}
C {devices/lab_pin.sym} 460 1050 0 0 {name=l72 sig_type=std_logic lab=NBIF}
N 460 1130 460 1150 {lab=VSS}
C {devices/lab_pin.sym} 460 1150 0 0 {name=l73 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 200 1300 0 0 {name=MNP L=2u W=16u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 1270 220 1250 {lab=PBIF}
C {devices/lab_pin.sym} 220 1250 0 0 {name=l74 sig_type=std_logic lab=PBIF}
N 180 1300 160 1300 {lab=NBIF}
C {devices/lab_pin.sym} 160 1300 0 0 {name=l75 sig_type=std_logic lab=NBIF}
N 220 1330 220 1350 {lab=VSS}
C {devices/lab_pin.sym} 220 1350 0 0 {name=l76 sig_type=std_logic lab=VSS}
N 220 1300 240 1300 {lab=VSS}
C {devices/lab_pin.sym} 240 1300 0 1 {name=l77 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 460 1300 0 0 {name=MPP L=2u W=32u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 480 1330 480 1350 {lab=PBIF}
C {devices/lab_pin.sym} 480 1350 0 0 {name=l78 sig_type=std_logic lab=PBIF}
N 440 1300 420 1300 {lab=PBIF}
C {devices/lab_pin.sym} 420 1300 0 0 {name=l79 sig_type=std_logic lab=PBIF}
N 480 1270 480 1250 {lab=VDD}
C {devices/lab_pin.sym} 480 1250 0 0 {name=l80 sig_type=std_logic lab=VDD}
N 480 1300 500 1300 {lab=VDD}
C {devices/lab_pin.sym} 500 1300 0 1 {name=l81 sig_type=std_logic lab=VDD}
C {symbols/cap_mim_2f0fF.sym} 720 1300 0 0 {name=CPB W=20e-6 L=20e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 720 1270 720 1250 {lab=VDD}
C {devices/lab_pin.sym} 720 1250 0 0 {name=l82 sig_type=std_logic lab=VDD}
N 720 1330 720 1350 {lab=PBIF}
C {devices/lab_pin.sym} 720 1350 0 0 {name=l83 sig_type=std_logic lab=PBIF}
C {devices/title.sym} 160 1800 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
