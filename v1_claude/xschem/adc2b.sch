v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {2-bit sign/magnitude ADC (MAX2769 compatible format), threshold +-0.15 V diff} 100 80 0 0 0.6 0.6 {}
T {threshold ladder (VCM = 0.363 VDD = 1.20 V = IF output CM, set by bias_if)} 100 190 0 0 0.4 0.4 {layer=8}
T {comparators} 100 590 0 0 0.4 0.4 {layer=8}
T {MAG = (v > +Vth) OR (v < -Vth)} 100 790 0 0 0.4 0.4 {layer=8}
C {devices/ipin.sym} -100 300 0 0 {name=p0 lab=INP}
C {devices/ipin.sym} -100 330 0 0 {name=p1 lab=INN}
C {devices/ipin.sym} -100 360 0 0 {name=p2 lab=CLK}
C {devices/opin.sym} -100 390 0 0 {name=p3 lab=SIGN}
C {devices/opin.sym} -100 420 0 0 {name=p4 lab=MAG}
C {devices/iopin.sym} -100 450 0 0 {name=p5 lab=VDD}
C {devices/iopin.sym} -100 480 0 0 {name=p6 lab=VSS}
C {symbols/ppolyf_u_1k.sym} 200 300 0 0 {name=RL0 W=10u L=40.1u model=ppolyf_u_1k spiceprefix=X m=1}
N 200 330 200 350 {lab=thp}
C {devices/lab_pin.sym} 200 350 0 0 {name=l1 sig_type=std_logic lab=thp}
N 200 270 200 250 {lab=VDD}
C {devices/lab_pin.sym} 200 250 0 0 {name=l2 sig_type=std_logic lab=VDD}
N 180 300 160 300 {lab=VSS}
C {devices/lab_pin.sym} 160 300 0 0 {name=l3 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 520 300 0 0 {name=RL1 W=10u L=1.4u model=ppolyf_u_1k spiceprefix=X m=1}
N 520 330 520 350 {lab=thm}
C {devices/lab_pin.sym} 520 350 0 0 {name=l4 sig_type=std_logic lab=thm}
N 520 270 520 250 {lab=thp}
C {devices/lab_pin.sym} 520 250 0 0 {name=l5 sig_type=std_logic lab=thp}
N 500 300 480 300 {lab=VSS}
C {devices/lab_pin.sym} 480 300 0 0 {name=l6 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 840 300 0 0 {name=RL2 W=10u L=1.4u model=ppolyf_u_1k spiceprefix=X m=1}
N 840 330 840 350 {lab=thn}
C {devices/lab_pin.sym} 840 350 0 0 {name=l7 sig_type=std_logic lab=thn}
N 840 270 840 250 {lab=thm}
C {devices/lab_pin.sym} 840 250 0 0 {name=l8 sig_type=std_logic lab=thm}
N 820 300 800 300 {lab=VSS}
C {devices/lab_pin.sym} 800 300 0 0 {name=l9 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 1160 300 0 0 {name=RL3 W=10u L=22.3u model=ppolyf_u_1k spiceprefix=X m=1}
N 1160 330 1160 350 {lab=VSS}
C {devices/lab_pin.sym} 1160 350 0 0 {name=l10 sig_type=std_logic lab=VSS}
N 1160 270 1160 250 {lab=thn}
C {devices/lab_pin.sym} 1160 250 0 0 {name=l11 sig_type=std_logic lab=thn}
N 1140 300 1120 300 {lab=VSS}
C {devices/lab_pin.sym} 1120 300 0 0 {name=l12 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 200 500 0 0 {name=CT1 W=50e-6 L=50e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 200 470 200 450 {lab=thp}
C {devices/lab_pin.sym} 200 450 0 0 {name=l13 sig_type=std_logic lab=thp}
N 200 530 200 550 {lab=VSS}
C {devices/lab_pin.sym} 200 550 0 0 {name=l14 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 520 500 0 0 {name=CT2 W=50e-6 L=50e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 520 470 520 450 {lab=thm}
C {devices/lab_pin.sym} 520 450 0 0 {name=l15 sig_type=std_logic lab=thm}
N 520 530 520 550 {lab=VSS}
C {devices/lab_pin.sym} 520 550 0 0 {name=l16 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 840 500 0 0 {name=CT3 W=50e-6 L=50e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 840 470 840 450 {lab=thn}
C {devices/lab_pin.sym} 840 450 0 0 {name=l17 sig_type=std_logic lab=thn}
N 840 530 840 550 {lab=VSS}
C {devices/lab_pin.sym} 840 550 0 0 {name=l18 sig_type=std_logic lab=VSS}
C {sa_comp.sym} 200 700 0 0 {name=XCS }
N 100 660 80 660 {lab=INP}
C {devices/lab_pin.sym} 80 660 0 0 {name=l19 sig_type=std_logic lab=INP}
N 100 680 80 680 {lab=INN}
C {devices/lab_pin.sym} 80 680 0 0 {name=l20 sig_type=std_logic lab=INN}
N 100 700 80 700 {lab=thm}
C {devices/lab_pin.sym} 80 700 0 0 {name=l21 sig_type=std_logic lab=thm}
N 100 720 80 720 {lab=thm}
C {devices/lab_pin.sym} 80 720 0 0 {name=l22 sig_type=std_logic lab=thm}
N 100 740 80 740 {lab=CLK}
C {devices/lab_pin.sym} 80 740 0 0 {name=l23 sig_type=std_logic lab=CLK}
N 300 660 320 660 {lab=SIGN}
C {devices/lab_pin.sym} 320 660 0 1 {name=l24 sig_type=std_logic lab=SIGN}
N 300 680 320 680 {lab=sb}
C {devices/lab_pin.sym} 320 680 0 1 {name=l25 sig_type=std_logic lab=sb}
N 300 700 320 700 {lab=VDD}
C {devices/lab_pin.sym} 320 700 0 1 {name=l26 sig_type=std_logic lab=VDD}
N 300 720 320 720 {lab=VSS}
C {devices/lab_pin.sym} 320 720 0 1 {name=l27 sig_type=std_logic lab=VSS}
C {sa_comp.sym} 520 700 0 0 {name=XCH }
N 420 660 400 660 {lab=INP}
C {devices/lab_pin.sym} 400 660 0 0 {name=l28 sig_type=std_logic lab=INP}
N 420 680 400 680 {lab=INN}
C {devices/lab_pin.sym} 400 680 0 0 {name=l29 sig_type=std_logic lab=INN}
N 420 700 400 700 {lab=thp}
C {devices/lab_pin.sym} 400 700 0 0 {name=l30 sig_type=std_logic lab=thp}
N 420 720 400 720 {lab=thn}
C {devices/lab_pin.sym} 400 720 0 0 {name=l31 sig_type=std_logic lab=thn}
N 420 740 400 740 {lab=CLK}
C {devices/lab_pin.sym} 400 740 0 0 {name=l32 sig_type=std_logic lab=CLK}
N 620 660 640 660 {lab=qh}
C {devices/lab_pin.sym} 640 660 0 1 {name=l33 sig_type=std_logic lab=qh}
N 620 680 640 680 {lab=qhb}
C {devices/lab_pin.sym} 640 680 0 1 {name=l34 sig_type=std_logic lab=qhb}
N 620 700 640 700 {lab=VDD}
C {devices/lab_pin.sym} 640 700 0 1 {name=l35 sig_type=std_logic lab=VDD}
N 620 720 640 720 {lab=VSS}
C {devices/lab_pin.sym} 640 720 0 1 {name=l36 sig_type=std_logic lab=VSS}
C {sa_comp.sym} 840 700 0 0 {name=XCL }
N 740 660 720 660 {lab=INP}
C {devices/lab_pin.sym} 720 660 0 0 {name=l37 sig_type=std_logic lab=INP}
N 740 680 720 680 {lab=INN}
C {devices/lab_pin.sym} 720 680 0 0 {name=l38 sig_type=std_logic lab=INN}
N 740 700 720 700 {lab=thn}
C {devices/lab_pin.sym} 720 700 0 0 {name=l39 sig_type=std_logic lab=thn}
N 740 720 720 720 {lab=thp}
C {devices/lab_pin.sym} 720 720 0 0 {name=l40 sig_type=std_logic lab=thp}
N 740 740 720 740 {lab=CLK}
C {devices/lab_pin.sym} 720 740 0 0 {name=l41 sig_type=std_logic lab=CLK}
N 940 660 960 660 {lab=ql}
C {devices/lab_pin.sym} 960 660 0 1 {name=l42 sig_type=std_logic lab=ql}
N 940 680 960 680 {lab=qlb}
C {devices/lab_pin.sym} 960 680 0 1 {name=l43 sig_type=std_logic lab=qlb}
N 940 700 960 700 {lab=VDD}
C {devices/lab_pin.sym} 960 700 0 1 {name=l44 sig_type=std_logic lab=VDD}
N 940 720 960 720 {lab=VSS}
C {devices/lab_pin.sym} 960 720 0 1 {name=l45 sig_type=std_logic lab=VSS}
C {nand2.sym} 200 900 0 0 {name=XM }
N 100 880 80 880 {lab=qhb}
C {devices/lab_pin.sym} 80 880 0 0 {name=l46 sig_type=std_logic lab=qhb}
N 100 900 80 900 {lab=ql}
C {devices/lab_pin.sym} 80 900 0 0 {name=l47 sig_type=std_logic lab=ql}
N 300 880 320 880 {lab=MAG}
C {devices/lab_pin.sym} 320 880 0 1 {name=l48 sig_type=std_logic lab=MAG}
N 300 900 320 900 {lab=VDD}
C {devices/lab_pin.sym} 320 900 0 1 {name=l49 sig_type=std_logic lab=VDD}
N 300 920 320 920 {lab=VSS}
C {devices/lab_pin.sym} 320 920 0 1 {name=l50 sig_type=std_logic lab=VSS}
C {devices/title.sym} 160 1380 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
