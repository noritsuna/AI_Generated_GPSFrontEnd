v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {AFC DAC: 8-bit R-2R (R = 10 k) for VCTCXO steering (common clock-drift correction)} 100 80 0 0 0.6 0.6 {}
T {bit 0} 100 390 0 0 0.4 0.4 {layer=8}
T {bit 1} 100 590 0 0 0.4 0.4 {layer=8}
T {bit 2} 100 790 0 0 0.4 0.4 {layer=8}
T {bit 3} 100 990 0 0 0.4 0.4 {layer=8}
T {bit 4} 100 1190 0 0 0.4 0.4 {layer=8}
T {bit 5} 100 1390 0 0 0.4 0.4 {layer=8}
T {bit 6} 100 1590 0 0 0.4 0.4 {layer=8}
T {bit 7} 100 1790 0 0 0.4 0.4 {layer=8}
C {devices/ipin.sym} -100 300 0 0 {name=p0 lab=D0}
C {devices/ipin.sym} -100 330 0 0 {name=p1 lab=D1}
C {devices/ipin.sym} -100 360 0 0 {name=p2 lab=D2}
C {devices/ipin.sym} -100 390 0 0 {name=p3 lab=D3}
C {devices/ipin.sym} -100 420 0 0 {name=p4 lab=D4}
C {devices/ipin.sym} -100 450 0 0 {name=p5 lab=D5}
C {devices/ipin.sym} -100 480 0 0 {name=p6 lab=D6}
C {devices/ipin.sym} -100 510 0 0 {name=p7 lab=D7}
C {devices/opin.sym} -100 540 0 0 {name=p8 lab=OUT}
C {devices/iopin.sym} -100 570 0 0 {name=p9 lab=VDD}
C {devices/iopin.sym} -100 600 0 0 {name=p10 lab=VSS}
C {symbols/ppolyf_u_1k.sym} 200 300 0 0 {name=RT W=2u L=40u model=ppolyf_u_1k spiceprefix=X m=1}
N 200 330 200 350 {lab=VSS}
C {devices/lab_pin.sym} 200 350 0 0 {name=l1 sig_type=std_logic lab=VSS}
N 200 270 200 250 {lab=n0}
C {devices/lab_pin.sym} 200 250 0 0 {name=l2 sig_type=std_logic lab=n0}
N 180 300 160 300 {lab=VSS}
C {devices/lab_pin.sym} 160 300 0 0 {name=l3 sig_type=std_logic lab=VSS}
C {inv_dig.sym} 200 500 0 0 {name=XA0 }
N 100 480 80 480 {lab=D0}
C {devices/lab_pin.sym} 80 480 0 0 {name=l4 sig_type=std_logic lab=D0}
N 300 480 320 480 {lab=db0}
C {devices/lab_pin.sym} 320 480 0 1 {name=l5 sig_type=std_logic lab=db0}
N 300 500 320 500 {lab=VDD}
C {devices/lab_pin.sym} 320 500 0 1 {name=l6 sig_type=std_logic lab=VDD}
N 300 520 320 520 {lab=VSS}
C {devices/lab_pin.sym} 320 520 0 1 {name=l7 sig_type=std_logic lab=VSS}
C {inv_dac.sym} 500 500 0 0 {name=XB0 }
N 400 480 380 480 {lab=db0}
C {devices/lab_pin.sym} 380 480 0 0 {name=l8 sig_type=std_logic lab=db0}
N 600 480 620 480 {lab=dr0}
C {devices/lab_pin.sym} 620 480 0 1 {name=l9 sig_type=std_logic lab=dr0}
N 600 500 620 500 {lab=VDD}
C {devices/lab_pin.sym} 620 500 0 1 {name=l10 sig_type=std_logic lab=VDD}
N 600 520 620 520 {lab=VSS}
C {devices/lab_pin.sym} 620 520 0 1 {name=l11 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 800 500 0 0 {name=R2_0 W=2u L=40u model=ppolyf_u_1k spiceprefix=X m=1}
N 800 530 800 550 {lab=n0}
C {devices/lab_pin.sym} 800 550 0 0 {name=l12 sig_type=std_logic lab=n0}
N 800 470 800 450 {lab=dr0}
C {devices/lab_pin.sym} 800 450 0 0 {name=l13 sig_type=std_logic lab=dr0}
N 780 500 760 500 {lab=VSS}
C {devices/lab_pin.sym} 760 500 0 0 {name=l14 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 1100 500 0 0 {name=R1_0 W=2u L=20.1u model=ppolyf_u_1k spiceprefix=X m=1}
N 1100 530 1100 550 {lab=n1}
C {devices/lab_pin.sym} 1100 550 0 0 {name=l15 sig_type=std_logic lab=n1}
N 1100 470 1100 450 {lab=n0}
C {devices/lab_pin.sym} 1100 450 0 0 {name=l16 sig_type=std_logic lab=n0}
N 1080 500 1060 500 {lab=VSS}
C {devices/lab_pin.sym} 1060 500 0 0 {name=l17 sig_type=std_logic lab=VSS}
C {inv_dig.sym} 200 700 0 0 {name=XA1 }
N 100 680 80 680 {lab=D1}
C {devices/lab_pin.sym} 80 680 0 0 {name=l18 sig_type=std_logic lab=D1}
N 300 680 320 680 {lab=db1}
C {devices/lab_pin.sym} 320 680 0 1 {name=l19 sig_type=std_logic lab=db1}
N 300 700 320 700 {lab=VDD}
C {devices/lab_pin.sym} 320 700 0 1 {name=l20 sig_type=std_logic lab=VDD}
N 300 720 320 720 {lab=VSS}
C {devices/lab_pin.sym} 320 720 0 1 {name=l21 sig_type=std_logic lab=VSS}
C {inv_dac.sym} 500 700 0 0 {name=XB1 }
N 400 680 380 680 {lab=db1}
C {devices/lab_pin.sym} 380 680 0 0 {name=l22 sig_type=std_logic lab=db1}
N 600 680 620 680 {lab=dr1}
C {devices/lab_pin.sym} 620 680 0 1 {name=l23 sig_type=std_logic lab=dr1}
N 600 700 620 700 {lab=VDD}
C {devices/lab_pin.sym} 620 700 0 1 {name=l24 sig_type=std_logic lab=VDD}
N 600 720 620 720 {lab=VSS}
C {devices/lab_pin.sym} 620 720 0 1 {name=l25 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 800 700 0 0 {name=R2_1 W=2u L=40u model=ppolyf_u_1k spiceprefix=X m=1}
N 800 730 800 750 {lab=n1}
C {devices/lab_pin.sym} 800 750 0 0 {name=l26 sig_type=std_logic lab=n1}
N 800 670 800 650 {lab=dr1}
C {devices/lab_pin.sym} 800 650 0 0 {name=l27 sig_type=std_logic lab=dr1}
N 780 700 760 700 {lab=VSS}
C {devices/lab_pin.sym} 760 700 0 0 {name=l28 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 1100 700 0 0 {name=R1_1 W=2u L=20.1u model=ppolyf_u_1k spiceprefix=X m=1}
N 1100 730 1100 750 {lab=n2}
C {devices/lab_pin.sym} 1100 750 0 0 {name=l29 sig_type=std_logic lab=n2}
N 1100 670 1100 650 {lab=n1}
C {devices/lab_pin.sym} 1100 650 0 0 {name=l30 sig_type=std_logic lab=n1}
N 1080 700 1060 700 {lab=VSS}
C {devices/lab_pin.sym} 1060 700 0 0 {name=l31 sig_type=std_logic lab=VSS}
C {inv_dig.sym} 200 900 0 0 {name=XA2 }
N 100 880 80 880 {lab=D2}
C {devices/lab_pin.sym} 80 880 0 0 {name=l32 sig_type=std_logic lab=D2}
N 300 880 320 880 {lab=db2}
C {devices/lab_pin.sym} 320 880 0 1 {name=l33 sig_type=std_logic lab=db2}
N 300 900 320 900 {lab=VDD}
C {devices/lab_pin.sym} 320 900 0 1 {name=l34 sig_type=std_logic lab=VDD}
N 300 920 320 920 {lab=VSS}
C {devices/lab_pin.sym} 320 920 0 1 {name=l35 sig_type=std_logic lab=VSS}
C {inv_dac.sym} 500 900 0 0 {name=XB2 }
N 400 880 380 880 {lab=db2}
C {devices/lab_pin.sym} 380 880 0 0 {name=l36 sig_type=std_logic lab=db2}
N 600 880 620 880 {lab=dr2}
C {devices/lab_pin.sym} 620 880 0 1 {name=l37 sig_type=std_logic lab=dr2}
N 600 900 620 900 {lab=VDD}
C {devices/lab_pin.sym} 620 900 0 1 {name=l38 sig_type=std_logic lab=VDD}
N 600 920 620 920 {lab=VSS}
C {devices/lab_pin.sym} 620 920 0 1 {name=l39 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 800 900 0 0 {name=R2_2 W=2u L=40u model=ppolyf_u_1k spiceprefix=X m=1}
N 800 930 800 950 {lab=n2}
C {devices/lab_pin.sym} 800 950 0 0 {name=l40 sig_type=std_logic lab=n2}
N 800 870 800 850 {lab=dr2}
C {devices/lab_pin.sym} 800 850 0 0 {name=l41 sig_type=std_logic lab=dr2}
N 780 900 760 900 {lab=VSS}
C {devices/lab_pin.sym} 760 900 0 0 {name=l42 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 1100 900 0 0 {name=R1_2 W=2u L=20.1u model=ppolyf_u_1k spiceprefix=X m=1}
N 1100 930 1100 950 {lab=n3}
C {devices/lab_pin.sym} 1100 950 0 0 {name=l43 sig_type=std_logic lab=n3}
N 1100 870 1100 850 {lab=n2}
C {devices/lab_pin.sym} 1100 850 0 0 {name=l44 sig_type=std_logic lab=n2}
N 1080 900 1060 900 {lab=VSS}
C {devices/lab_pin.sym} 1060 900 0 0 {name=l45 sig_type=std_logic lab=VSS}
C {inv_dig.sym} 200 1100 0 0 {name=XA3 }
N 100 1080 80 1080 {lab=D3}
C {devices/lab_pin.sym} 80 1080 0 0 {name=l46 sig_type=std_logic lab=D3}
N 300 1080 320 1080 {lab=db3}
C {devices/lab_pin.sym} 320 1080 0 1 {name=l47 sig_type=std_logic lab=db3}
N 300 1100 320 1100 {lab=VDD}
C {devices/lab_pin.sym} 320 1100 0 1 {name=l48 sig_type=std_logic lab=VDD}
N 300 1120 320 1120 {lab=VSS}
C {devices/lab_pin.sym} 320 1120 0 1 {name=l49 sig_type=std_logic lab=VSS}
C {inv_dac.sym} 500 1100 0 0 {name=XB3 }
N 400 1080 380 1080 {lab=db3}
C {devices/lab_pin.sym} 380 1080 0 0 {name=l50 sig_type=std_logic lab=db3}
N 600 1080 620 1080 {lab=dr3}
C {devices/lab_pin.sym} 620 1080 0 1 {name=l51 sig_type=std_logic lab=dr3}
N 600 1100 620 1100 {lab=VDD}
C {devices/lab_pin.sym} 620 1100 0 1 {name=l52 sig_type=std_logic lab=VDD}
N 600 1120 620 1120 {lab=VSS}
C {devices/lab_pin.sym} 620 1120 0 1 {name=l53 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 800 1100 0 0 {name=R2_3 W=2u L=40u model=ppolyf_u_1k spiceprefix=X m=1}
N 800 1130 800 1150 {lab=n3}
C {devices/lab_pin.sym} 800 1150 0 0 {name=l54 sig_type=std_logic lab=n3}
N 800 1070 800 1050 {lab=dr3}
C {devices/lab_pin.sym} 800 1050 0 0 {name=l55 sig_type=std_logic lab=dr3}
N 780 1100 760 1100 {lab=VSS}
C {devices/lab_pin.sym} 760 1100 0 0 {name=l56 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 1100 1100 0 0 {name=R1_3 W=2u L=20.1u model=ppolyf_u_1k spiceprefix=X m=1}
N 1100 1130 1100 1150 {lab=n4}
C {devices/lab_pin.sym} 1100 1150 0 0 {name=l57 sig_type=std_logic lab=n4}
N 1100 1070 1100 1050 {lab=n3}
C {devices/lab_pin.sym} 1100 1050 0 0 {name=l58 sig_type=std_logic lab=n3}
N 1080 1100 1060 1100 {lab=VSS}
C {devices/lab_pin.sym} 1060 1100 0 0 {name=l59 sig_type=std_logic lab=VSS}
C {inv_dig.sym} 200 1300 0 0 {name=XA4 }
N 100 1280 80 1280 {lab=D4}
C {devices/lab_pin.sym} 80 1280 0 0 {name=l60 sig_type=std_logic lab=D4}
N 300 1280 320 1280 {lab=db4}
C {devices/lab_pin.sym} 320 1280 0 1 {name=l61 sig_type=std_logic lab=db4}
N 300 1300 320 1300 {lab=VDD}
C {devices/lab_pin.sym} 320 1300 0 1 {name=l62 sig_type=std_logic lab=VDD}
N 300 1320 320 1320 {lab=VSS}
C {devices/lab_pin.sym} 320 1320 0 1 {name=l63 sig_type=std_logic lab=VSS}
C {inv_dac.sym} 500 1300 0 0 {name=XB4 }
N 400 1280 380 1280 {lab=db4}
C {devices/lab_pin.sym} 380 1280 0 0 {name=l64 sig_type=std_logic lab=db4}
N 600 1280 620 1280 {lab=dr4}
C {devices/lab_pin.sym} 620 1280 0 1 {name=l65 sig_type=std_logic lab=dr4}
N 600 1300 620 1300 {lab=VDD}
C {devices/lab_pin.sym} 620 1300 0 1 {name=l66 sig_type=std_logic lab=VDD}
N 600 1320 620 1320 {lab=VSS}
C {devices/lab_pin.sym} 620 1320 0 1 {name=l67 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 800 1300 0 0 {name=R2_4 W=2u L=40u model=ppolyf_u_1k spiceprefix=X m=1}
N 800 1330 800 1350 {lab=n4}
C {devices/lab_pin.sym} 800 1350 0 0 {name=l68 sig_type=std_logic lab=n4}
N 800 1270 800 1250 {lab=dr4}
C {devices/lab_pin.sym} 800 1250 0 0 {name=l69 sig_type=std_logic lab=dr4}
N 780 1300 760 1300 {lab=VSS}
C {devices/lab_pin.sym} 760 1300 0 0 {name=l70 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 1100 1300 0 0 {name=R1_4 W=2u L=20.1u model=ppolyf_u_1k spiceprefix=X m=1}
N 1100 1330 1100 1350 {lab=n5}
C {devices/lab_pin.sym} 1100 1350 0 0 {name=l71 sig_type=std_logic lab=n5}
N 1100 1270 1100 1250 {lab=n4}
C {devices/lab_pin.sym} 1100 1250 0 0 {name=l72 sig_type=std_logic lab=n4}
N 1080 1300 1060 1300 {lab=VSS}
C {devices/lab_pin.sym} 1060 1300 0 0 {name=l73 sig_type=std_logic lab=VSS}
C {inv_dig.sym} 200 1500 0 0 {name=XA5 }
N 100 1480 80 1480 {lab=D5}
C {devices/lab_pin.sym} 80 1480 0 0 {name=l74 sig_type=std_logic lab=D5}
N 300 1480 320 1480 {lab=db5}
C {devices/lab_pin.sym} 320 1480 0 1 {name=l75 sig_type=std_logic lab=db5}
N 300 1500 320 1500 {lab=VDD}
C {devices/lab_pin.sym} 320 1500 0 1 {name=l76 sig_type=std_logic lab=VDD}
N 300 1520 320 1520 {lab=VSS}
C {devices/lab_pin.sym} 320 1520 0 1 {name=l77 sig_type=std_logic lab=VSS}
C {inv_dac.sym} 500 1500 0 0 {name=XB5 }
N 400 1480 380 1480 {lab=db5}
C {devices/lab_pin.sym} 380 1480 0 0 {name=l78 sig_type=std_logic lab=db5}
N 600 1480 620 1480 {lab=dr5}
C {devices/lab_pin.sym} 620 1480 0 1 {name=l79 sig_type=std_logic lab=dr5}
N 600 1500 620 1500 {lab=VDD}
C {devices/lab_pin.sym} 620 1500 0 1 {name=l80 sig_type=std_logic lab=VDD}
N 600 1520 620 1520 {lab=VSS}
C {devices/lab_pin.sym} 620 1520 0 1 {name=l81 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 800 1500 0 0 {name=R2_5 W=2u L=40u model=ppolyf_u_1k spiceprefix=X m=1}
N 800 1530 800 1550 {lab=n5}
C {devices/lab_pin.sym} 800 1550 0 0 {name=l82 sig_type=std_logic lab=n5}
N 800 1470 800 1450 {lab=dr5}
C {devices/lab_pin.sym} 800 1450 0 0 {name=l83 sig_type=std_logic lab=dr5}
N 780 1500 760 1500 {lab=VSS}
C {devices/lab_pin.sym} 760 1500 0 0 {name=l84 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 1100 1500 0 0 {name=R1_5 W=2u L=20.1u model=ppolyf_u_1k spiceprefix=X m=1}
N 1100 1530 1100 1550 {lab=n6}
C {devices/lab_pin.sym} 1100 1550 0 0 {name=l85 sig_type=std_logic lab=n6}
N 1100 1470 1100 1450 {lab=n5}
C {devices/lab_pin.sym} 1100 1450 0 0 {name=l86 sig_type=std_logic lab=n5}
N 1080 1500 1060 1500 {lab=VSS}
C {devices/lab_pin.sym} 1060 1500 0 0 {name=l87 sig_type=std_logic lab=VSS}
C {inv_dig.sym} 200 1700 0 0 {name=XA6 }
N 100 1680 80 1680 {lab=D6}
C {devices/lab_pin.sym} 80 1680 0 0 {name=l88 sig_type=std_logic lab=D6}
N 300 1680 320 1680 {lab=db6}
C {devices/lab_pin.sym} 320 1680 0 1 {name=l89 sig_type=std_logic lab=db6}
N 300 1700 320 1700 {lab=VDD}
C {devices/lab_pin.sym} 320 1700 0 1 {name=l90 sig_type=std_logic lab=VDD}
N 300 1720 320 1720 {lab=VSS}
C {devices/lab_pin.sym} 320 1720 0 1 {name=l91 sig_type=std_logic lab=VSS}
C {inv_dac.sym} 500 1700 0 0 {name=XB6 }
N 400 1680 380 1680 {lab=db6}
C {devices/lab_pin.sym} 380 1680 0 0 {name=l92 sig_type=std_logic lab=db6}
N 600 1680 620 1680 {lab=dr6}
C {devices/lab_pin.sym} 620 1680 0 1 {name=l93 sig_type=std_logic lab=dr6}
N 600 1700 620 1700 {lab=VDD}
C {devices/lab_pin.sym} 620 1700 0 1 {name=l94 sig_type=std_logic lab=VDD}
N 600 1720 620 1720 {lab=VSS}
C {devices/lab_pin.sym} 620 1720 0 1 {name=l95 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 800 1700 0 0 {name=R2_6 W=2u L=40u model=ppolyf_u_1k spiceprefix=X m=1}
N 800 1730 800 1750 {lab=n6}
C {devices/lab_pin.sym} 800 1750 0 0 {name=l96 sig_type=std_logic lab=n6}
N 800 1670 800 1650 {lab=dr6}
C {devices/lab_pin.sym} 800 1650 0 0 {name=l97 sig_type=std_logic lab=dr6}
N 780 1700 760 1700 {lab=VSS}
C {devices/lab_pin.sym} 760 1700 0 0 {name=l98 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 1100 1700 0 0 {name=R1_6 W=2u L=20.1u model=ppolyf_u_1k spiceprefix=X m=1}
N 1100 1730 1100 1750 {lab=OUT}
C {devices/lab_pin.sym} 1100 1750 0 0 {name=l99 sig_type=std_logic lab=OUT}
N 1100 1670 1100 1650 {lab=n6}
C {devices/lab_pin.sym} 1100 1650 0 0 {name=l100 sig_type=std_logic lab=n6}
N 1080 1700 1060 1700 {lab=VSS}
C {devices/lab_pin.sym} 1060 1700 0 0 {name=l101 sig_type=std_logic lab=VSS}
C {inv_dig.sym} 200 1900 0 0 {name=XA7 }
N 100 1880 80 1880 {lab=D7}
C {devices/lab_pin.sym} 80 1880 0 0 {name=l102 sig_type=std_logic lab=D7}
N 300 1880 320 1880 {lab=db7}
C {devices/lab_pin.sym} 320 1880 0 1 {name=l103 sig_type=std_logic lab=db7}
N 300 1900 320 1900 {lab=VDD}
C {devices/lab_pin.sym} 320 1900 0 1 {name=l104 sig_type=std_logic lab=VDD}
N 300 1920 320 1920 {lab=VSS}
C {devices/lab_pin.sym} 320 1920 0 1 {name=l105 sig_type=std_logic lab=VSS}
C {inv_dac.sym} 500 1900 0 0 {name=XB7 }
N 400 1880 380 1880 {lab=db7}
C {devices/lab_pin.sym} 380 1880 0 0 {name=l106 sig_type=std_logic lab=db7}
N 600 1880 620 1880 {lab=dr7}
C {devices/lab_pin.sym} 620 1880 0 1 {name=l107 sig_type=std_logic lab=dr7}
N 600 1900 620 1900 {lab=VDD}
C {devices/lab_pin.sym} 620 1900 0 1 {name=l108 sig_type=std_logic lab=VDD}
N 600 1920 620 1920 {lab=VSS}
C {devices/lab_pin.sym} 620 1920 0 1 {name=l109 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 800 1900 0 0 {name=R2_7 W=2u L=40u model=ppolyf_u_1k spiceprefix=X m=1}
N 800 1930 800 1950 {lab=OUT}
C {devices/lab_pin.sym} 800 1950 0 0 {name=l110 sig_type=std_logic lab=OUT}
N 800 1870 800 1850 {lab=dr7}
C {devices/lab_pin.sym} 800 1850 0 0 {name=l111 sig_type=std_logic lab=dr7}
N 780 1900 760 1900 {lab=VSS}
C {devices/lab_pin.sym} 760 1900 0 0 {name=l112 sig_type=std_logic lab=VSS}
C {devices/title.sym} 160 2400 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
