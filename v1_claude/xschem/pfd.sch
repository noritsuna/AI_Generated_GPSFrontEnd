v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {Tri-state PFD with reset delay (anti dead-zone)} 100 80 0 0 0.6 0.6 {}
C {devices/ipin.sym} -100 300 0 0 {name=p0 lab=REF}
C {devices/ipin.sym} -100 330 0 0 {name=p1 lab=FB}
C {devices/opin.sym} -100 360 0 0 {name=p2 lab=UP}
C {devices/opin.sym} -100 390 0 0 {name=p3 lab=UPB}
C {devices/opin.sym} -100 420 0 0 {name=p4 lab=DN}
C {devices/opin.sym} -100 450 0 0 {name=p5 lab=DNB}
C {devices/iopin.sym} -100 480 0 0 {name=p6 lab=VDD}
C {devices/iopin.sym} -100 510 0 0 {name=p7 lab=VSS}
C {dff_r.sym} 200 300 0 0 {name=XU }
N 100 280 80 280 {lab=REF}
C {devices/lab_pin.sym} 80 280 0 0 {name=l1 sig_type=std_logic lab=REF}
N 100 300 80 300 {lab=rb}
C {devices/lab_pin.sym} 80 300 0 0 {name=l2 sig_type=std_logic lab=rb}
N 300 280 320 280 {lab=UP}
C {devices/lab_pin.sym} 320 280 0 1 {name=l3 sig_type=std_logic lab=UP}
N 300 300 320 300 {lab=VDD}
C {devices/lab_pin.sym} 320 300 0 1 {name=l4 sig_type=std_logic lab=VDD}
N 300 320 320 320 {lab=VSS}
C {devices/lab_pin.sym} 320 320 0 1 {name=l5 sig_type=std_logic lab=VSS}
C {dff_r.sym} 500 300 0 0 {name=XD }
N 400 280 380 280 {lab=FB}
C {devices/lab_pin.sym} 380 280 0 0 {name=l6 sig_type=std_logic lab=FB}
N 400 300 380 300 {lab=rb}
C {devices/lab_pin.sym} 380 300 0 0 {name=l7 sig_type=std_logic lab=rb}
N 600 280 620 280 {lab=DN}
C {devices/lab_pin.sym} 620 280 0 1 {name=l8 sig_type=std_logic lab=DN}
N 600 300 620 300 {lab=VDD}
C {devices/lab_pin.sym} 620 300 0 1 {name=l9 sig_type=std_logic lab=VDD}
N 600 320 620 320 {lab=VSS}
C {devices/lab_pin.sym} 620 320 0 1 {name=l10 sig_type=std_logic lab=VSS}
C {nand2.sym} 800 300 0 0 {name=XR }
N 700 280 680 280 {lab=UP}
C {devices/lab_pin.sym} 680 280 0 0 {name=l11 sig_type=std_logic lab=UP}
N 700 300 680 300 {lab=DN}
C {devices/lab_pin.sym} 680 300 0 0 {name=l12 sig_type=std_logic lab=DN}
N 900 280 920 280 {lab=r0}
C {devices/lab_pin.sym} 920 280 0 1 {name=l13 sig_type=std_logic lab=r0}
N 900 300 920 300 {lab=VDD}
C {devices/lab_pin.sym} 920 300 0 1 {name=l14 sig_type=std_logic lab=VDD}
N 900 320 920 320 {lab=VSS}
C {devices/lab_pin.sym} 920 320 0 1 {name=l15 sig_type=std_logic lab=VSS}
C {inv_dig.sym} 1100 300 0 0 {name=XD1 }
N 1000 280 980 280 {lab=r0}
C {devices/lab_pin.sym} 980 280 0 0 {name=l16 sig_type=std_logic lab=r0}
N 1200 280 1220 280 {lab=r1}
C {devices/lab_pin.sym} 1220 280 0 1 {name=l17 sig_type=std_logic lab=r1}
N 1200 300 1220 300 {lab=VDD}
C {devices/lab_pin.sym} 1220 300 0 1 {name=l18 sig_type=std_logic lab=VDD}
N 1200 320 1220 320 {lab=VSS}
C {devices/lab_pin.sym} 1220 320 0 1 {name=l19 sig_type=std_logic lab=VSS}
C {inv_dig.sym} 200 500 0 0 {name=XD2 }
N 100 480 80 480 {lab=r1}
C {devices/lab_pin.sym} 80 480 0 0 {name=l20 sig_type=std_logic lab=r1}
N 300 480 320 480 {lab=r2}
C {devices/lab_pin.sym} 320 480 0 1 {name=l21 sig_type=std_logic lab=r2}
N 300 500 320 500 {lab=VDD}
C {devices/lab_pin.sym} 320 500 0 1 {name=l22 sig_type=std_logic lab=VDD}
N 300 520 320 520 {lab=VSS}
C {devices/lab_pin.sym} 320 520 0 1 {name=l23 sig_type=std_logic lab=VSS}
C {inv_dig.sym} 500 500 0 0 {name=XD3 }
N 400 480 380 480 {lab=r2}
C {devices/lab_pin.sym} 380 480 0 0 {name=l24 sig_type=std_logic lab=r2}
N 600 480 620 480 {lab=r3}
C {devices/lab_pin.sym} 620 480 0 1 {name=l25 sig_type=std_logic lab=r3}
N 600 500 620 500 {lab=VDD}
C {devices/lab_pin.sym} 620 500 0 1 {name=l26 sig_type=std_logic lab=VDD}
N 600 520 620 520 {lab=VSS}
C {devices/lab_pin.sym} 620 520 0 1 {name=l27 sig_type=std_logic lab=VSS}
C {inv_dig.sym} 800 500 0 0 {name=XD4 }
N 700 480 680 480 {lab=r3}
C {devices/lab_pin.sym} 680 480 0 0 {name=l28 sig_type=std_logic lab=r3}
N 900 480 920 480 {lab=rb}
C {devices/lab_pin.sym} 920 480 0 1 {name=l29 sig_type=std_logic lab=rb}
N 900 500 920 500 {lab=VDD}
C {devices/lab_pin.sym} 920 500 0 1 {name=l30 sig_type=std_logic lab=VDD}
N 900 520 920 520 {lab=VSS}
C {devices/lab_pin.sym} 920 520 0 1 {name=l31 sig_type=std_logic lab=VSS}
C {inv_dig.sym} 1100 500 0 0 {name=XO1 }
N 1000 480 980 480 {lab=UP}
C {devices/lab_pin.sym} 980 480 0 0 {name=l32 sig_type=std_logic lab=UP}
N 1200 480 1220 480 {lab=UPB}
C {devices/lab_pin.sym} 1220 480 0 1 {name=l33 sig_type=std_logic lab=UPB}
N 1200 500 1220 500 {lab=VDD}
C {devices/lab_pin.sym} 1220 500 0 1 {name=l34 sig_type=std_logic lab=VDD}
N 1200 520 1220 520 {lab=VSS}
C {devices/lab_pin.sym} 1220 520 0 1 {name=l35 sig_type=std_logic lab=VSS}
C {inv_dig.sym} 200 700 0 0 {name=XO2 }
N 100 680 80 680 {lab=DN}
C {devices/lab_pin.sym} 80 680 0 0 {name=l36 sig_type=std_logic lab=DN}
N 300 680 320 680 {lab=DNB}
C {devices/lab_pin.sym} 320 680 0 1 {name=l37 sig_type=std_logic lab=DNB}
N 300 700 320 700 {lab=VDD}
C {devices/lab_pin.sym} 320 700 0 1 {name=l38 sig_type=std_logic lab=VDD}
N 300 720 320 720 {lab=VSS}
C {devices/lab_pin.sym} 320 720 0 1 {name=l39 sig_type=std_logic lab=VSS}
C {devices/title.sym} 160 1180 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
