v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {IF chain (GPS/Galileo): VGA1 - SK LPF (Q=0.54) - VGA2 - SK LPF (Q=1.31) - VGA3 - VGA4..5 (fixed, vga_fix); BW ~0.8-7 MHz} 100 80 0 0 0.6 0.6 {}
T {fixed gain stages (needed for 20 dB external LNA and 7.5 MHz noise bandwidth): 2 x vga_fix = 3 max-code VGAs} 100 790 0 0 0.4 0.4 {layer=8}
C {devices/ipin.sym} -100 300 0 0 {name=p0 lab=INP}
C {devices/ipin.sym} -100 330 0 0 {name=p1 lab=INN}
C {devices/ipin.sym} -100 360 0 0 {name=p2 lab=G1A}
C {devices/ipin.sym} -100 390 0 0 {name=p3 lab=G1B}
C {devices/ipin.sym} -100 420 0 0 {name=p4 lab=G2A}
C {devices/ipin.sym} -100 450 0 0 {name=p5 lab=G2B}
C {devices/ipin.sym} -100 480 0 0 {name=p6 lab=G3A}
C {devices/ipin.sym} -100 510 0 0 {name=p7 lab=G3B}
C {devices/ipin.sym} -100 540 0 0 {name=p8 lab=PB}
C {devices/ipin.sym} -100 570 0 0 {name=p9 lab=BWK}
C {devices/ipin.sym} -100 600 0 0 {name=p10 lab=BWN}
C {devices/opin.sym} -100 630 0 0 {name=p11 lab=OUTP}
C {devices/opin.sym} -100 660 0 0 {name=p12 lab=OUTN}
C {devices/iopin.sym} -100 690 0 0 {name=p13 lab=VDD}
C {devices/iopin.sym} -100 720 0 0 {name=p14 lab=VSS}
C {bias_if.sym} 200 300 0 0 {name=XBIF }
N 100 270 80 270 {lab=PB}
C {devices/lab_pin.sym} 80 270 0 0 {name=l1 sig_type=std_logic lab=PB}
N 300 270 320 270 {lab=nbif}
C {devices/lab_pin.sym} 320 270 0 1 {name=l2 sig_type=std_logic lab=nbif}
N 300 290 320 290 {lab=pbif}
C {devices/lab_pin.sym} 320 290 0 1 {name=l3 sig_type=std_logic lab=pbif}
N 300 310 320 310 {lab=VDD}
C {devices/lab_pin.sym} 320 310 0 1 {name=l4 sig_type=std_logic lab=VDD}
N 300 330 320 330 {lab=VSS}
C {devices/lab_pin.sym} 320 330 0 1 {name=l5 sig_type=std_logic lab=VSS}
C {vga.sym} 600 300 0 0 {name=XV1 }
N 500 260 480 260 {lab=INP}
C {devices/lab_pin.sym} 480 260 0 0 {name=l6 sig_type=std_logic lab=INP}
N 500 280 480 280 {lab=INN}
C {devices/lab_pin.sym} 480 280 0 0 {name=l7 sig_type=std_logic lab=INN}
N 500 300 480 300 {lab=G1A}
C {devices/lab_pin.sym} 480 300 0 0 {name=l8 sig_type=std_logic lab=G1A}
N 500 320 480 320 {lab=G1B}
C {devices/lab_pin.sym} 480 320 0 0 {name=l9 sig_type=std_logic lab=G1B}
N 500 340 480 340 {lab=nbif}
C {devices/lab_pin.sym} 480 340 0 0 {name=l10 sig_type=std_logic lab=nbif}
N 700 260 720 260 {lab=a1p}
C {devices/lab_pin.sym} 720 260 0 1 {name=l11 sig_type=std_logic lab=a1p}
N 700 280 720 280 {lab=a1n}
C {devices/lab_pin.sym} 720 280 0 1 {name=l12 sig_type=std_logic lab=a1n}
N 700 300 720 300 {lab=VDD}
C {devices/lab_pin.sym} 720 300 0 1 {name=l13 sig_type=std_logic lab=VDD}
N 700 320 720 320 {lab=VSS}
C {devices/lab_pin.sym} 720 320 0 1 {name=l14 sig_type=std_logic lab=VSS}
C {sk_lpf1.sym} 1000 300 0 0 {name=XF1 }
N 900 260 880 260 {lab=a1p}
C {devices/lab_pin.sym} 880 260 0 0 {name=l15 sig_type=std_logic lab=a1p}
N 900 280 880 280 {lab=a1n}
C {devices/lab_pin.sym} 880 280 0 0 {name=l16 sig_type=std_logic lab=a1n}
N 900 300 880 300 {lab=pbif}
C {devices/lab_pin.sym} 880 300 0 0 {name=l17 sig_type=std_logic lab=pbif}
N 900 320 880 320 {lab=BWK}
C {devices/lab_pin.sym} 880 320 0 0 {name=l18 sig_type=std_logic lab=BWK}
N 900 340 880 340 {lab=BWN}
C {devices/lab_pin.sym} 880 340 0 0 {name=l19 sig_type=std_logic lab=BWN}
N 1100 260 1120 260 {lab=f1p}
C {devices/lab_pin.sym} 1120 260 0 1 {name=l20 sig_type=std_logic lab=f1p}
N 1100 280 1120 280 {lab=f1n}
C {devices/lab_pin.sym} 1120 280 0 1 {name=l21 sig_type=std_logic lab=f1n}
N 1100 300 1120 300 {lab=VDD}
C {devices/lab_pin.sym} 1120 300 0 1 {name=l22 sig_type=std_logic lab=VDD}
N 1100 320 1120 320 {lab=VSS}
C {devices/lab_pin.sym} 1120 320 0 1 {name=l23 sig_type=std_logic lab=VSS}
C {vga.sym} 200 500 0 0 {name=XV2 }
N 100 460 80 460 {lab=f1p}
C {devices/lab_pin.sym} 80 460 0 0 {name=l24 sig_type=std_logic lab=f1p}
N 100 480 80 480 {lab=f1n}
C {devices/lab_pin.sym} 80 480 0 0 {name=l25 sig_type=std_logic lab=f1n}
N 100 500 80 500 {lab=G2A}
C {devices/lab_pin.sym} 80 500 0 0 {name=l26 sig_type=std_logic lab=G2A}
N 100 520 80 520 {lab=G2B}
C {devices/lab_pin.sym} 80 520 0 0 {name=l27 sig_type=std_logic lab=G2B}
N 100 540 80 540 {lab=nbif}
C {devices/lab_pin.sym} 80 540 0 0 {name=l28 sig_type=std_logic lab=nbif}
N 300 460 320 460 {lab=a2p}
C {devices/lab_pin.sym} 320 460 0 1 {name=l29 sig_type=std_logic lab=a2p}
N 300 480 320 480 {lab=a2n}
C {devices/lab_pin.sym} 320 480 0 1 {name=l30 sig_type=std_logic lab=a2n}
N 300 500 320 500 {lab=VDD}
C {devices/lab_pin.sym} 320 500 0 1 {name=l31 sig_type=std_logic lab=VDD}
N 300 520 320 520 {lab=VSS}
C {devices/lab_pin.sym} 320 520 0 1 {name=l32 sig_type=std_logic lab=VSS}
C {sk_lpf2.sym} 200 700 0 0 {name=XF2 }
N 100 660 80 660 {lab=a2p}
C {devices/lab_pin.sym} 80 660 0 0 {name=l33 sig_type=std_logic lab=a2p}
N 100 680 80 680 {lab=a2n}
C {devices/lab_pin.sym} 80 680 0 0 {name=l34 sig_type=std_logic lab=a2n}
N 100 700 80 700 {lab=pbif}
C {devices/lab_pin.sym} 80 700 0 0 {name=l35 sig_type=std_logic lab=pbif}
N 100 720 80 720 {lab=BWK}
C {devices/lab_pin.sym} 80 720 0 0 {name=l36 sig_type=std_logic lab=BWK}
N 100 740 80 740 {lab=BWN}
C {devices/lab_pin.sym} 80 740 0 0 {name=l37 sig_type=std_logic lab=BWN}
N 300 660 320 660 {lab=f2p}
C {devices/lab_pin.sym} 320 660 0 1 {name=l38 sig_type=std_logic lab=f2p}
N 300 680 320 680 {lab=f2n}
C {devices/lab_pin.sym} 320 680 0 1 {name=l39 sig_type=std_logic lab=f2n}
N 300 700 320 700 {lab=VDD}
C {devices/lab_pin.sym} 320 700 0 1 {name=l40 sig_type=std_logic lab=VDD}
N 300 720 320 720 {lab=VSS}
C {devices/lab_pin.sym} 320 720 0 1 {name=l41 sig_type=std_logic lab=VSS}
C {vga.sym} 600 700 0 0 {name=XV3 }
N 500 660 480 660 {lab=f2p}
C {devices/lab_pin.sym} 480 660 0 0 {name=l42 sig_type=std_logic lab=f2p}
N 500 680 480 680 {lab=f2n}
C {devices/lab_pin.sym} 480 680 0 0 {name=l43 sig_type=std_logic lab=f2n}
N 500 700 480 700 {lab=G3A}
C {devices/lab_pin.sym} 480 700 0 0 {name=l44 sig_type=std_logic lab=G3A}
N 500 720 480 720 {lab=G3B}
C {devices/lab_pin.sym} 480 720 0 0 {name=l45 sig_type=std_logic lab=G3B}
N 500 740 480 740 {lab=nbif}
C {devices/lab_pin.sym} 480 740 0 0 {name=l46 sig_type=std_logic lab=nbif}
N 700 660 720 660 {lab=a3p}
C {devices/lab_pin.sym} 720 660 0 1 {name=l47 sig_type=std_logic lab=a3p}
N 700 680 720 680 {lab=a3n}
C {devices/lab_pin.sym} 720 680 0 1 {name=l48 sig_type=std_logic lab=a3n}
N 700 700 720 700 {lab=VDD}
C {devices/lab_pin.sym} 720 700 0 1 {name=l49 sig_type=std_logic lab=VDD}
N 700 720 720 720 {lab=VSS}
C {devices/lab_pin.sym} 720 720 0 1 {name=l50 sig_type=std_logic lab=VSS}
C {vga_fix.sym} 200 900 0 0 {name=XV4 }
N 100 870 80 870 {lab=a3p}
C {devices/lab_pin.sym} 80 870 0 0 {name=l51 sig_type=std_logic lab=a3p}
N 100 890 80 890 {lab=a3n}
C {devices/lab_pin.sym} 80 890 0 0 {name=l52 sig_type=std_logic lab=a3n}
N 100 910 80 910 {lab=nbif}
C {devices/lab_pin.sym} 80 910 0 0 {name=l53 sig_type=std_logic lab=nbif}
N 300 870 320 870 {lab=a4p}
C {devices/lab_pin.sym} 320 870 0 1 {name=l54 sig_type=std_logic lab=a4p}
N 300 890 320 890 {lab=a4n}
C {devices/lab_pin.sym} 320 890 0 1 {name=l55 sig_type=std_logic lab=a4n}
N 300 910 320 910 {lab=VDD}
C {devices/lab_pin.sym} 320 910 0 1 {name=l56 sig_type=std_logic lab=VDD}
N 300 930 320 930 {lab=VSS}
C {devices/lab_pin.sym} 320 930 0 1 {name=l57 sig_type=std_logic lab=VSS}
C {vga_fix.sym} 600 900 0 0 {name=XV5 }
N 500 870 480 870 {lab=a4p}
C {devices/lab_pin.sym} 480 870 0 0 {name=l58 sig_type=std_logic lab=a4p}
N 500 890 480 890 {lab=a4n}
C {devices/lab_pin.sym} 480 890 0 0 {name=l59 sig_type=std_logic lab=a4n}
N 500 910 480 910 {lab=nbif}
C {devices/lab_pin.sym} 480 910 0 0 {name=l60 sig_type=std_logic lab=nbif}
N 700 870 720 870 {lab=OUTP}
C {devices/lab_pin.sym} 720 870 0 1 {name=l61 sig_type=std_logic lab=OUTP}
N 700 890 720 890 {lab=OUTN}
C {devices/lab_pin.sym} 720 890 0 1 {name=l62 sig_type=std_logic lab=OUTN}
N 700 910 720 910 {lab=VDD}
C {devices/lab_pin.sym} 720 910 0 1 {name=l63 sig_type=std_logic lab=VDD}
N 700 930 720 930 {lab=VSS}
C {devices/lab_pin.sym} 720 930 0 1 {name=l64 sig_type=std_logic lab=VSS}
C {devices/title.sym} 160 1400 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
