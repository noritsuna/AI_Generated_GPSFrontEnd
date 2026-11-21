v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {Fixed /48 = /2/2/2 (TSPC) /3 /2 from the 785.664 MHz ring phase. FB = FS = 16.368 MHz (PFD + ADC clock)} 100 80 0 0 0.6 0.6 {}
T {/3 is clocked from the lightly loaded c8 (TSPC needs sharp edges); FS = buffered FB} 100 390 0 0 0.4 0.4 {layer=8}
C {devices/ipin.sym} -100 300 0 0 {name=p0 lab=CK}
C {devices/opin.sym} -100 330 0 0 {name=p1 lab=FS}
C {devices/opin.sym} -100 360 0 0 {name=p2 lab=FB}
C {devices/iopin.sym} -100 390 0 0 {name=p3 lab=VDD}
C {devices/iopin.sym} -100 420 0 0 {name=p4 lab=VSS}
C {div2.sym} 200 300 0 0 {name=XD1 }
N 100 270 80 270 {lab=CK}
C {devices/lab_pin.sym} 80 270 0 0 {name=l1 sig_type=std_logic lab=CK}
N 300 270 320 270 {lab=c2}
C {devices/lab_pin.sym} 320 270 0 1 {name=l2 sig_type=std_logic lab=c2}
N 300 290 320 290 {lab=c2b}
C {devices/lab_pin.sym} 320 290 0 1 {name=l3 sig_type=std_logic lab=c2b}
N 300 310 320 310 {lab=VDD}
C {devices/lab_pin.sym} 320 310 0 1 {name=l4 sig_type=std_logic lab=VDD}
N 300 330 320 330 {lab=VSS}
C {devices/lab_pin.sym} 320 330 0 1 {name=l5 sig_type=std_logic lab=VSS}
C {div2.sym} 500 300 0 0 {name=XD2 }
N 400 270 380 270 {lab=c2}
C {devices/lab_pin.sym} 380 270 0 0 {name=l6 sig_type=std_logic lab=c2}
N 600 270 620 270 {lab=c4}
C {devices/lab_pin.sym} 620 270 0 1 {name=l7 sig_type=std_logic lab=c4}
N 600 290 620 290 {lab=c4b}
C {devices/lab_pin.sym} 620 290 0 1 {name=l8 sig_type=std_logic lab=c4b}
N 600 310 620 310 {lab=VDD}
C {devices/lab_pin.sym} 620 310 0 1 {name=l9 sig_type=std_logic lab=VDD}
N 600 330 620 330 {lab=VSS}
C {devices/lab_pin.sym} 620 330 0 1 {name=l10 sig_type=std_logic lab=VSS}
C {div2.sym} 800 300 0 0 {name=XD3 }
N 700 270 680 270 {lab=c4}
C {devices/lab_pin.sym} 680 270 0 0 {name=l11 sig_type=std_logic lab=c4}
N 900 270 920 270 {lab=c8}
C {devices/lab_pin.sym} 920 270 0 1 {name=l12 sig_type=std_logic lab=c8}
N 900 290 920 290 {lab=c8b}
C {devices/lab_pin.sym} 920 290 0 1 {name=l13 sig_type=std_logic lab=c8b}
N 900 310 920 310 {lab=VDD}
C {devices/lab_pin.sym} 920 310 0 1 {name=l14 sig_type=std_logic lab=VDD}
N 900 330 920 330 {lab=VSS}
C {devices/lab_pin.sym} 920 330 0 1 {name=l15 sig_type=std_logic lab=VSS}
C {div3.sym} 200 500 0 0 {name=XD5 }
N 100 480 80 480 {lab=c8}
C {devices/lab_pin.sym} 80 480 0 0 {name=l16 sig_type=std_logic lab=c8}
N 300 480 320 480 {lab=c24}
C {devices/lab_pin.sym} 320 480 0 1 {name=l17 sig_type=std_logic lab=c24}
N 300 500 320 500 {lab=VDD}
C {devices/lab_pin.sym} 320 500 0 1 {name=l18 sig_type=std_logic lab=VDD}
N 300 520 320 520 {lab=VSS}
C {devices/lab_pin.sym} 320 520 0 1 {name=l19 sig_type=std_logic lab=VSS}
C {div2.sym} 500 500 0 0 {name=XD6 }
N 400 470 380 470 {lab=c24}
C {devices/lab_pin.sym} 380 470 0 0 {name=l20 sig_type=std_logic lab=c24}
N 600 470 620 470 {lab=FB}
C {devices/lab_pin.sym} 620 470 0 1 {name=l21 sig_type=std_logic lab=FB}
N 600 490 620 490 {lab=c48b}
C {devices/lab_pin.sym} 620 490 0 1 {name=l22 sig_type=std_logic lab=c48b}
N 600 510 620 510 {lab=VDD}
C {devices/lab_pin.sym} 620 510 0 1 {name=l23 sig_type=std_logic lab=VDD}
N 600 530 620 530 {lab=VSS}
C {devices/lab_pin.sym} 620 530 0 1 {name=l24 sig_type=std_logic lab=VSS}
C {inv_lo1.sym} 800 500 0 0 {name=XFB1 }
N 700 480 680 480 {lab=FB}
C {devices/lab_pin.sym} 680 480 0 0 {name=l25 sig_type=std_logic lab=FB}
N 900 480 920 480 {lab=fbi}
C {devices/lab_pin.sym} 920 480 0 1 {name=l26 sig_type=std_logic lab=fbi}
N 900 500 920 500 {lab=VDD}
C {devices/lab_pin.sym} 920 500 0 1 {name=l27 sig_type=std_logic lab=VDD}
N 900 520 920 520 {lab=VSS}
C {devices/lab_pin.sym} 920 520 0 1 {name=l28 sig_type=std_logic lab=VSS}
C {inv_lo2.sym} 1100 500 0 0 {name=XFB2 }
N 1000 480 980 480 {lab=fbi}
C {devices/lab_pin.sym} 980 480 0 0 {name=l29 sig_type=std_logic lab=fbi}
N 1200 480 1220 480 {lab=FS}
C {devices/lab_pin.sym} 1220 480 0 1 {name=l30 sig_type=std_logic lab=FS}
N 1200 500 1220 500 {lab=VDD}
C {devices/lab_pin.sym} 1220 500 0 1 {name=l31 sig_type=std_logic lab=VDD}
N 1200 520 1220 520 {lab=VSS}
C {devices/lab_pin.sym} 1220 520 0 1 {name=l32 sig_type=std_logic lab=VSS}
C {devices/title.sym} 160 1000 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
