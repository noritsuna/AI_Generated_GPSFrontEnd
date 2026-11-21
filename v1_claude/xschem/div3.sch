v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {Divide-by-3: D1=NOR(Q1,Q2), D2=Q1} 100 80 0 0 0.6 0.6 {}
C {devices/ipin.sym} -100 300 0 0 {name=p0 lab=CK}
C {devices/opin.sym} -100 330 0 0 {name=p1 lab=Q}
C {devices/iopin.sym} -100 360 0 0 {name=p2 lab=VDD}
C {devices/iopin.sym} -100 390 0 0 {name=p3 lab=VSS}
C {tspc_dff.sym} 200 300 0 0 {name=XF1 }
N 100 270 80 270 {lab=d1}
C {devices/lab_pin.sym} 80 270 0 0 {name=l1 sig_type=std_logic lab=d1}
N 100 290 80 290 {lab=CK}
C {devices/lab_pin.sym} 80 290 0 0 {name=l2 sig_type=std_logic lab=CK}
N 300 270 320 270 {lab=Q}
C {devices/lab_pin.sym} 320 270 0 1 {name=l3 sig_type=std_logic lab=Q}
N 300 290 320 290 {lab=q1b}
C {devices/lab_pin.sym} 320 290 0 1 {name=l4 sig_type=std_logic lab=q1b}
N 300 310 320 310 {lab=VDD}
C {devices/lab_pin.sym} 320 310 0 1 {name=l5 sig_type=std_logic lab=VDD}
N 300 330 320 330 {lab=VSS}
C {devices/lab_pin.sym} 320 330 0 1 {name=l6 sig_type=std_logic lab=VSS}
C {tspc_dff.sym} 460 300 0 0 {name=XF2 }
N 360 270 340 270 {lab=Q}
C {devices/lab_pin.sym} 340 270 0 0 {name=l7 sig_type=std_logic lab=Q}
N 360 290 340 290 {lab=CK}
C {devices/lab_pin.sym} 340 290 0 0 {name=l8 sig_type=std_logic lab=CK}
N 560 270 580 270 {lab=q2}
C {devices/lab_pin.sym} 580 270 0 1 {name=l9 sig_type=std_logic lab=q2}
N 560 290 580 290 {lab=q2b}
C {devices/lab_pin.sym} 580 290 0 1 {name=l10 sig_type=std_logic lab=q2b}
N 560 310 580 310 {lab=VDD}
C {devices/lab_pin.sym} 580 310 0 1 {name=l11 sig_type=std_logic lab=VDD}
N 560 330 580 330 {lab=VSS}
C {devices/lab_pin.sym} 580 330 0 1 {name=l12 sig_type=std_logic lab=VSS}
C {nor2.sym} 720 300 0 0 {name=XN }
N 620 280 600 280 {lab=Q}
C {devices/lab_pin.sym} 600 280 0 0 {name=l13 sig_type=std_logic lab=Q}
N 620 300 600 300 {lab=q2}
C {devices/lab_pin.sym} 600 300 0 0 {name=l14 sig_type=std_logic lab=q2}
N 820 280 840 280 {lab=d1}
C {devices/lab_pin.sym} 840 280 0 1 {name=l15 sig_type=std_logic lab=d1}
N 820 300 840 300 {lab=VDD}
C {devices/lab_pin.sym} 840 300 0 1 {name=l16 sig_type=std_logic lab=VDD}
N 820 320 840 320 {lab=VSS}
C {devices/lab_pin.sym} 840 320 0 1 {name=l17 sig_type=std_logic lab=VSS}
C {devices/title.sym} 160 800 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
