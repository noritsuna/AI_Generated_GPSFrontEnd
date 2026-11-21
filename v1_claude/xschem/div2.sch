v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {TSPC divide-by-2} 100 80 0 0 0.6 0.6 {}
C {devices/ipin.sym} -100 300 0 0 {name=p0 lab=CK}
C {devices/opin.sym} -100 330 0 0 {name=p1 lab=Q}
C {devices/opin.sym} -100 360 0 0 {name=p2 lab=QB}
C {devices/iopin.sym} -100 390 0 0 {name=p3 lab=VDD}
C {devices/iopin.sym} -100 420 0 0 {name=p4 lab=VSS}
C {tspc_dff.sym} 200 300 0 0 {name=XF }
N 100 270 80 270 {lab=QB}
C {devices/lab_pin.sym} 80 270 0 0 {name=l1 sig_type=std_logic lab=QB}
N 100 290 80 290 {lab=CK}
C {devices/lab_pin.sym} 80 290 0 0 {name=l2 sig_type=std_logic lab=CK}
N 300 270 320 270 {lab=Q}
C {devices/lab_pin.sym} 320 270 0 1 {name=l3 sig_type=std_logic lab=Q}
N 300 290 320 290 {lab=QB}
C {devices/lab_pin.sym} 320 290 0 1 {name=l4 sig_type=std_logic lab=QB}
N 300 310 320 310 {lab=VDD}
C {devices/lab_pin.sym} 320 310 0 1 {name=l5 sig_type=std_logic lab=VDD}
N 300 330 320 330 {lab=VSS}
C {devices/lab_pin.sym} 320 330 0 1 {name=l6 sig_type=std_logic lab=VSS}
C {devices/title.sym} 160 800 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
