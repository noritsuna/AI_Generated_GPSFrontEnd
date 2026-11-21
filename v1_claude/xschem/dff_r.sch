v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {Edge DFF (D=1) with async clear for PFD} 100 80 0 0 0.6 0.6 {}
C {devices/ipin.sym} -100 300 0 0 {name=p0 lab=CK}
C {devices/ipin.sym} -100 330 0 0 {name=p1 lab=RB}
C {devices/opin.sym} -100 360 0 0 {name=p2 lab=Q}
C {devices/iopin.sym} -100 390 0 0 {name=p3 lab=VDD}
C {devices/iopin.sym} -100 420 0 0 {name=p4 lab=VSS}
C {nand2.sym} 200 300 0 0 {name=X1 }
N 100 280 80 280 {lab=n4}
C {devices/lab_pin.sym} 80 280 0 0 {name=l1 sig_type=std_logic lab=n4}
N 100 300 80 300 {lab=n2}
C {devices/lab_pin.sym} 80 300 0 0 {name=l2 sig_type=std_logic lab=n2}
N 300 280 320 280 {lab=n1}
C {devices/lab_pin.sym} 320 280 0 1 {name=l3 sig_type=std_logic lab=n1}
N 300 300 320 300 {lab=VDD}
C {devices/lab_pin.sym} 320 300 0 1 {name=l4 sig_type=std_logic lab=VDD}
N 300 320 320 320 {lab=VSS}
C {devices/lab_pin.sym} 320 320 0 1 {name=l5 sig_type=std_logic lab=VSS}
C {nand3.sym} 520 300 0 0 {name=X2 }
N 420 280 400 280 {lab=n1}
C {devices/lab_pin.sym} 400 280 0 0 {name=l6 sig_type=std_logic lab=n1}
N 420 300 400 300 {lab=CK}
C {devices/lab_pin.sym} 400 300 0 0 {name=l7 sig_type=std_logic lab=CK}
N 420 320 400 320 {lab=RB}
C {devices/lab_pin.sym} 400 320 0 0 {name=l8 sig_type=std_logic lab=RB}
N 620 280 640 280 {lab=n2}
C {devices/lab_pin.sym} 640 280 0 1 {name=l9 sig_type=std_logic lab=n2}
N 620 300 640 300 {lab=VDD}
C {devices/lab_pin.sym} 640 300 0 1 {name=l10 sig_type=std_logic lab=VDD}
N 620 320 640 320 {lab=VSS}
C {devices/lab_pin.sym} 640 320 0 1 {name=l11 sig_type=std_logic lab=VSS}
C {nand3.sym} 840 300 0 0 {name=X3 }
N 740 280 720 280 {lab=n2}
C {devices/lab_pin.sym} 720 280 0 0 {name=l12 sig_type=std_logic lab=n2}
N 740 300 720 300 {lab=CK}
C {devices/lab_pin.sym} 720 300 0 0 {name=l13 sig_type=std_logic lab=CK}
N 740 320 720 320 {lab=n4}
C {devices/lab_pin.sym} 720 320 0 0 {name=l14 sig_type=std_logic lab=n4}
N 940 280 960 280 {lab=n3}
C {devices/lab_pin.sym} 960 280 0 1 {name=l15 sig_type=std_logic lab=n3}
N 940 300 960 300 {lab=VDD}
C {devices/lab_pin.sym} 960 300 0 1 {name=l16 sig_type=std_logic lab=VDD}
N 940 320 960 320 {lab=VSS}
C {devices/lab_pin.sym} 960 320 0 1 {name=l17 sig_type=std_logic lab=VSS}
C {nand2.sym} 200 500 0 0 {name=X4 }
N 100 480 80 480 {lab=n3}
C {devices/lab_pin.sym} 80 480 0 0 {name=l18 sig_type=std_logic lab=n3}
N 100 500 80 500 {lab=RB}
C {devices/lab_pin.sym} 80 500 0 0 {name=l19 sig_type=std_logic lab=RB}
N 300 480 320 480 {lab=n4}
C {devices/lab_pin.sym} 320 480 0 1 {name=l20 sig_type=std_logic lab=n4}
N 300 500 320 500 {lab=VDD}
C {devices/lab_pin.sym} 320 500 0 1 {name=l21 sig_type=std_logic lab=VDD}
N 300 520 320 520 {lab=VSS}
C {devices/lab_pin.sym} 320 520 0 1 {name=l22 sig_type=std_logic lab=VSS}
C {nand2.sym} 520 500 0 0 {name=X5 }
N 420 480 400 480 {lab=n2}
C {devices/lab_pin.sym} 400 480 0 0 {name=l23 sig_type=std_logic lab=n2}
N 420 500 400 500 {lab=qb}
C {devices/lab_pin.sym} 400 500 0 0 {name=l24 sig_type=std_logic lab=qb}
N 620 480 640 480 {lab=Q}
C {devices/lab_pin.sym} 640 480 0 1 {name=l25 sig_type=std_logic lab=Q}
N 620 500 640 500 {lab=VDD}
C {devices/lab_pin.sym} 640 500 0 1 {name=l26 sig_type=std_logic lab=VDD}
N 620 520 640 520 {lab=VSS}
C {devices/lab_pin.sym} 640 520 0 1 {name=l27 sig_type=std_logic lab=VSS}
C {nand3.sym} 840 500 0 0 {name=X6 }
N 740 480 720 480 {lab=Q}
C {devices/lab_pin.sym} 720 480 0 0 {name=l28 sig_type=std_logic lab=Q}
N 740 500 720 500 {lab=n3}
C {devices/lab_pin.sym} 720 500 0 0 {name=l29 sig_type=std_logic lab=n3}
N 740 520 720 520 {lab=RB}
C {devices/lab_pin.sym} 720 520 0 0 {name=l30 sig_type=std_logic lab=RB}
N 940 480 960 480 {lab=qb}
C {devices/lab_pin.sym} 960 480 0 1 {name=l31 sig_type=std_logic lab=qb}
N 940 500 960 500 {lab=VDD}
C {devices/lab_pin.sym} 960 500 0 1 {name=l32 sig_type=std_logic lab=VDD}
N 940 520 960 520 {lab=VSS}
C {devices/lab_pin.sym} 960 520 0 1 {name=l33 sig_type=std_logic lab=VSS}
C {devices/title.sym} 160 980 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
