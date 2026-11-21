v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {GNSS AFE (GPS L1 C/A + Galileo E1) for GF180MCU - analog hard macro (SPI registers in the digital core)} 100 80 0 0 0.6 0.6 {}
T {bias + LO generation} 100 190 0 0 0.4 0.4 {layer=8}
T {RF (single-ended 50 ohm) -> noise-cancelling LNA -> I/Q mixers} 100 710 0 0 0.4 0.4 {layer=8}
T {2-bit ADCs (sampled at fLO/96 = 16.368 MHz), clock out, AFC DAC} 100 1230 0 0 0.4 0.4 {layer=8}
C {devices/ipin.sym} -100 300 0 0 {name=p0 lab=RFIN}
C {devices/ipin.sym} -100 330 0 0 {name=p1 lab=REFIN}
C {devices/ipin.sym} -100 360 0 0 {name=p2 lab=IG1A}
C {devices/ipin.sym} -100 390 0 0 {name=p3 lab=IG1B}
C {devices/ipin.sym} -100 420 0 0 {name=p4 lab=IG2A}
C {devices/ipin.sym} -100 450 0 0 {name=p5 lab=IG2B}
C {devices/ipin.sym} -100 480 0 0 {name=p6 lab=IG3A}
C {devices/ipin.sym} -100 510 0 0 {name=p7 lab=IG3B}
C {devices/ipin.sym} -100 540 0 0 {name=p8 lab=B0}
C {devices/ipin.sym} -100 570 0 0 {name=p9 lab=B1}
C {devices/ipin.sym} -100 600 0 0 {name=p10 lab=AFC0}
C {devices/ipin.sym} -100 630 0 0 {name=p11 lab=AFC1}
C {devices/ipin.sym} -100 660 0 0 {name=p12 lab=AFC2}
C {devices/ipin.sym} -100 690 0 0 {name=p13 lab=AFC3}
C {devices/ipin.sym} -100 720 0 0 {name=p14 lab=AFC4}
C {devices/ipin.sym} -100 750 0 0 {name=p15 lab=AFC5}
C {devices/ipin.sym} -100 780 0 0 {name=p16 lab=AFC6}
C {devices/ipin.sym} -100 810 0 0 {name=p17 lab=AFC7}
C {devices/ipin.sym} -100 840 0 0 {name=p18 lab=ICP2}
C {devices/ipin.sym} -100 870 0 0 {name=p19 lab=BWK}
C {devices/ipin.sym} -100 900 0 0 {name=p20 lab=BWN}
C {devices/opin.sym} -100 930 0 0 {name=p21 lab=I_SIGN}
C {devices/opin.sym} -100 960 0 0 {name=p22 lab=I_MAG}
C {devices/opin.sym} -100 990 0 0 {name=p23 lab=Q_SIGN}
C {devices/opin.sym} -100 1020 0 0 {name=p24 lab=Q_MAG}
C {devices/opin.sym} -100 1050 0 0 {name=p25 lab=CLKOUT}
C {devices/opin.sym} -100 1080 0 0 {name=p26 lab=AFCOUT}
C {devices/opin.sym} -100 1110 0 0 {name=p27 lab=VCTRL}
C {devices/iopin.sym} -100 1140 0 0 {name=p28 lab=VDDV}
C {devices/iopin.sym} -100 1170 0 0 {name=p29 lab=VDD}
C {devices/iopin.sym} -100 1200 0 0 {name=p30 lab=VSS}
C {bias_gen.sym} 200 300 0 0 {name=XBIAS }
N 300 270 320 270 {lab=nb}
C {devices/lab_pin.sym} 320 270 0 1 {name=l1 sig_type=std_logic lab=nb}
N 300 290 320 290 {lab=pb}
C {devices/lab_pin.sym} 320 290 0 1 {name=l2 sig_type=std_logic lab=pb}
N 300 310 320 310 {lab=VDD}
C {devices/lab_pin.sym} 320 310 0 1 {name=l3 sig_type=std_logic lab=VDD}
N 300 330 320 330 {lab=VSS}
C {devices/lab_pin.sym} 320 330 0 1 {name=l4 sig_type=std_logic lab=VSS}
C {vmon_buf.sym} 620 300 0 0 {name=XMON }
N 520 280 500 280 {lab=vctrl}
C {devices/lab_pin.sym} 500 280 0 0 {name=l5 sig_type=std_logic lab=vctrl}
N 520 300 500 300 {lab=nb}
C {devices/lab_pin.sym} 500 300 0 0 {name=l6 sig_type=std_logic lab=nb}
N 720 280 740 280 {lab=vmon}
C {devices/lab_pin.sym} 740 280 0 1 {name=l7 sig_type=std_logic lab=vmon}
N 720 300 740 300 {lab=VDDV}
C {devices/lab_pin.sym} 740 300 0 1 {name=l8 sig_type=std_logic lab=VDDV}
N 720 320 740 320 {lab=VSS}
C {devices/lab_pin.sym} 740 320 0 1 {name=l9 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 1040 300 0 0 {name=RMON W=1u L=10u model=ppolyf_u_1k spiceprefix=X m=1}
N 1040 330 1040 350 {lab=vmon}
C {devices/lab_pin.sym} 1040 350 0 0 {name=l10 sig_type=std_logic lab=vmon}
N 1040 270 1040 250 {lab=VCTRL}
C {devices/lab_pin.sym} 1040 250 0 0 {name=l11 sig_type=std_logic lab=VCTRL}
N 1020 300 1000 300 {lab=VSS}
C {devices/lab_pin.sym} 1000 300 0 0 {name=l12 sig_type=std_logic lab=VSS}
C {vco_ring4.sym} 200 560 0 0 {name=XVCO }
N 100 450 80 450 {lab=vctrl}
C {devices/lab_pin.sym} 80 450 0 0 {name=l13 sig_type=std_logic lab=vctrl}
N 100 470 80 470 {lab=B0}
C {devices/lab_pin.sym} 80 470 0 0 {name=l14 sig_type=std_logic lab=B0}
N 100 490 80 490 {lab=B1}
C {devices/lab_pin.sym} 80 490 0 0 {name=l15 sig_type=std_logic lab=B1}
N 100 510 80 510 {lab=nb}
C {devices/lab_pin.sym} 80 510 0 0 {name=l16 sig_type=std_logic lab=nb}
N 300 450 320 450 {lab=l1p}
C {devices/lab_pin.sym} 320 450 0 1 {name=l17 sig_type=std_logic lab=l1p}
N 300 470 320 470 {lab=l1n}
C {devices/lab_pin.sym} 320 470 0 1 {name=l18 sig_type=std_logic lab=l1n}
N 300 490 320 490 {lab=l2p}
C {devices/lab_pin.sym} 320 490 0 1 {name=l19 sig_type=std_logic lab=l2p}
N 300 510 320 510 {lab=l2n}
C {devices/lab_pin.sym} 320 510 0 1 {name=l20 sig_type=std_logic lab=l2n}
N 300 530 320 530 {lab=l3p}
C {devices/lab_pin.sym} 320 530 0 1 {name=l21 sig_type=std_logic lab=l3p}
N 300 550 320 550 {lab=l3n}
C {devices/lab_pin.sym} 320 550 0 1 {name=l22 sig_type=std_logic lab=l3n}
N 300 570 320 570 {lab=l4p}
C {devices/lab_pin.sym} 320 570 0 1 {name=l23 sig_type=std_logic lab=l4p}
N 300 590 320 590 {lab=l4n}
C {devices/lab_pin.sym} 320 590 0 1 {name=l24 sig_type=std_logic lab=l4n}
N 300 610 320 610 {lab=ckr}
C {devices/lab_pin.sym} 320 610 0 1 {name=l25 sig_type=std_logic lab=ckr}
N 300 630 320 630 {lab=vr}
C {devices/lab_pin.sym} 320 630 0 1 {name=l26 sig_type=std_logic lab=vr}
N 300 650 320 650 {lab=VDDV}
C {devices/lab_pin.sym} 320 650 0 1 {name=l27 sig_type=std_logic lab=VDDV}
N 300 670 320 670 {lab=VSS}
C {devices/lab_pin.sym} 320 670 0 1 {name=l28 sig_type=std_logic lab=VSS}
C {refbuf.sym} 620 560 0 0 {name=XRB }
N 520 540 500 540 {lab=REFIN}
C {devices/lab_pin.sym} 500 540 0 0 {name=l29 sig_type=std_logic lab=REFIN}
N 720 540 740 540 {lab=refck}
C {devices/lab_pin.sym} 740 540 0 1 {name=l30 sig_type=std_logic lab=refck}
N 720 560 740 560 {lab=VDDV}
C {devices/lab_pin.sym} 740 560 0 1 {name=l31 sig_type=std_logic lab=VDDV}
N 720 580 740 580 {lab=VSS}
C {devices/lab_pin.sym} 740 580 0 1 {name=l32 sig_type=std_logic lab=VSS}
C {pll_core.sym} 1040 560 0 0 {name=XPLL }
N 940 520 920 520 {lab=refck}
C {devices/lab_pin.sym} 920 520 0 0 {name=l33 sig_type=std_logic lab=refck}
N 940 540 920 540 {lab=ckr}
C {devices/lab_pin.sym} 920 540 0 0 {name=l34 sig_type=std_logic lab=ckr}
N 940 560 920 560 {lab=nb}
C {devices/lab_pin.sym} 920 560 0 0 {name=l35 sig_type=std_logic lab=nb}
N 940 580 920 580 {lab=pb}
C {devices/lab_pin.sym} 920 580 0 0 {name=l36 sig_type=std_logic lab=pb}
N 940 600 920 600 {lab=ICP2}
C {devices/lab_pin.sym} 920 600 0 0 {name=l37 sig_type=std_logic lab=ICP2}
N 1140 520 1160 520 {lab=vctrl}
C {devices/lab_pin.sym} 1160 520 0 1 {name=l38 sig_type=std_logic lab=vctrl}
N 1140 540 1160 540 {lab=fs}
C {devices/lab_pin.sym} 1160 540 0 1 {name=l39 sig_type=std_logic lab=fs}
N 1140 560 1160 560 {lab=fb}
C {devices/lab_pin.sym} 1160 560 0 1 {name=l40 sig_type=std_logic lab=fb}
N 1140 580 1160 580 {lab=VDD}
C {devices/lab_pin.sym} 1160 580 0 1 {name=l41 sig_type=std_logic lab=VDD}
N 1140 600 1160 600 {lab=VSS}
C {devices/lab_pin.sym} 1160 600 0 1 {name=l42 sig_type=std_logic lab=VSS}
C {lna_nc.sym} 200 820 0 0 {name=XLNA }
N 100 790 80 790 {lab=RFIN}
C {devices/lab_pin.sym} 80 790 0 0 {name=l43 sig_type=std_logic lab=RFIN}
N 100 810 80 810 {lab=pb}
C {devices/lab_pin.sym} 80 810 0 0 {name=l44 sig_type=std_logic lab=pb}
N 300 790 320 790 {lab=rfp}
C {devices/lab_pin.sym} 320 790 0 1 {name=l45 sig_type=std_logic lab=rfp}
N 300 810 320 810 {lab=rfn}
C {devices/lab_pin.sym} 320 810 0 1 {name=l46 sig_type=std_logic lab=rfn}
N 300 830 320 830 {lab=VDD}
C {devices/lab_pin.sym} 320 830 0 1 {name=l47 sig_type=std_logic lab=VDD}
N 300 850 320 850 {lab=VSS}
C {devices/lab_pin.sym} 320 850 0 1 {name=l48 sig_type=std_logic lab=VSS}
C {mixer_iq.sym} 620 850 0 0 {name=XMIX }
N 520 750 500 750 {lab=rfp}
C {devices/lab_pin.sym} 500 750 0 0 {name=l49 sig_type=std_logic lab=rfp}
N 520 770 500 770 {lab=rfn}
C {devices/lab_pin.sym} 500 770 0 0 {name=l50 sig_type=std_logic lab=rfn}
N 520 790 500 790 {lab=l1p}
C {devices/lab_pin.sym} 500 790 0 0 {name=l51 sig_type=std_logic lab=l1p}
N 520 810 500 810 {lab=l1n}
C {devices/lab_pin.sym} 500 810 0 0 {name=l52 sig_type=std_logic lab=l1n}
N 520 830 500 830 {lab=l2p}
C {devices/lab_pin.sym} 500 830 0 0 {name=l53 sig_type=std_logic lab=l2p}
N 520 850 500 850 {lab=l2n}
C {devices/lab_pin.sym} 500 850 0 0 {name=l54 sig_type=std_logic lab=l2n}
N 520 870 500 870 {lab=l3p}
C {devices/lab_pin.sym} 500 870 0 0 {name=l55 sig_type=std_logic lab=l3p}
N 520 890 500 890 {lab=l3n}
C {devices/lab_pin.sym} 500 890 0 0 {name=l56 sig_type=std_logic lab=l3n}
N 520 910 500 910 {lab=l4p}
C {devices/lab_pin.sym} 500 910 0 0 {name=l57 sig_type=std_logic lab=l4p}
N 520 930 500 930 {lab=l4n}
C {devices/lab_pin.sym} 500 930 0 0 {name=l58 sig_type=std_logic lab=l4n}
N 520 950 500 950 {lab=nb}
C {devices/lab_pin.sym} 500 950 0 0 {name=l59 sig_type=std_logic lab=nb}
N 720 750 740 750 {lab=mip}
C {devices/lab_pin.sym} 740 750 0 1 {name=l60 sig_type=std_logic lab=mip}
N 720 770 740 770 {lab=min}
C {devices/lab_pin.sym} 740 770 0 1 {name=l61 sig_type=std_logic lab=min}
N 720 790 740 790 {lab=mqp}
C {devices/lab_pin.sym} 740 790 0 1 {name=l62 sig_type=std_logic lab=mqp}
N 720 810 740 810 {lab=mqn}
C {devices/lab_pin.sym} 740 810 0 1 {name=l63 sig_type=std_logic lab=mqn}
N 720 830 740 830 {lab=VDD}
C {devices/lab_pin.sym} 740 830 0 1 {name=l64 sig_type=std_logic lab=VDD}
N 720 850 740 850 {lab=VSS}
C {devices/lab_pin.sym} 740 850 0 1 {name=l65 sig_type=std_logic lab=VSS}
C {if_chain.sym} 1040 850 0 0 {name=XIFI }
N 940 750 920 750 {lab=mip}
C {devices/lab_pin.sym} 920 750 0 0 {name=l66 sig_type=std_logic lab=mip}
N 940 770 920 770 {lab=min}
C {devices/lab_pin.sym} 920 770 0 0 {name=l67 sig_type=std_logic lab=min}
N 940 790 920 790 {lab=IG1A}
C {devices/lab_pin.sym} 920 790 0 0 {name=l68 sig_type=std_logic lab=IG1A}
N 940 810 920 810 {lab=IG1B}
C {devices/lab_pin.sym} 920 810 0 0 {name=l69 sig_type=std_logic lab=IG1B}
N 940 830 920 830 {lab=IG2A}
C {devices/lab_pin.sym} 920 830 0 0 {name=l70 sig_type=std_logic lab=IG2A}
N 940 850 920 850 {lab=IG2B}
C {devices/lab_pin.sym} 920 850 0 0 {name=l71 sig_type=std_logic lab=IG2B}
N 940 870 920 870 {lab=IG3A}
C {devices/lab_pin.sym} 920 870 0 0 {name=l72 sig_type=std_logic lab=IG3A}
N 940 890 920 890 {lab=IG3B}
C {devices/lab_pin.sym} 920 890 0 0 {name=l73 sig_type=std_logic lab=IG3B}
N 940 910 920 910 {lab=pb}
C {devices/lab_pin.sym} 920 910 0 0 {name=l74 sig_type=std_logic lab=pb}
N 940 930 920 930 {lab=BWK}
C {devices/lab_pin.sym} 920 930 0 0 {name=l75 sig_type=std_logic lab=BWK}
N 940 950 920 950 {lab=BWN}
C {devices/lab_pin.sym} 920 950 0 0 {name=l76 sig_type=std_logic lab=BWN}
N 1140 750 1160 750 {lab=aip}
C {devices/lab_pin.sym} 1160 750 0 1 {name=l77 sig_type=std_logic lab=aip}
N 1140 770 1160 770 {lab=ain}
C {devices/lab_pin.sym} 1160 770 0 1 {name=l78 sig_type=std_logic lab=ain}
N 1140 790 1160 790 {lab=VDD}
C {devices/lab_pin.sym} 1160 790 0 1 {name=l79 sig_type=std_logic lab=VDD}
N 1140 810 1160 810 {lab=VSS}
C {devices/lab_pin.sym} 1160 810 0 1 {name=l80 sig_type=std_logic lab=VSS}
C {if_chain.sym} 200 1130 0 0 {name=XIFQ }
N 100 1030 80 1030 {lab=mqp}
C {devices/lab_pin.sym} 80 1030 0 0 {name=l81 sig_type=std_logic lab=mqp}
N 100 1050 80 1050 {lab=mqn}
C {devices/lab_pin.sym} 80 1050 0 0 {name=l82 sig_type=std_logic lab=mqn}
N 100 1070 80 1070 {lab=IG1A}
C {devices/lab_pin.sym} 80 1070 0 0 {name=l83 sig_type=std_logic lab=IG1A}
N 100 1090 80 1090 {lab=IG1B}
C {devices/lab_pin.sym} 80 1090 0 0 {name=l84 sig_type=std_logic lab=IG1B}
N 100 1110 80 1110 {lab=IG2A}
C {devices/lab_pin.sym} 80 1110 0 0 {name=l85 sig_type=std_logic lab=IG2A}
N 100 1130 80 1130 {lab=IG2B}
C {devices/lab_pin.sym} 80 1130 0 0 {name=l86 sig_type=std_logic lab=IG2B}
N 100 1150 80 1150 {lab=IG3A}
C {devices/lab_pin.sym} 80 1150 0 0 {name=l87 sig_type=std_logic lab=IG3A}
N 100 1170 80 1170 {lab=IG3B}
C {devices/lab_pin.sym} 80 1170 0 0 {name=l88 sig_type=std_logic lab=IG3B}
N 100 1190 80 1190 {lab=pb}
C {devices/lab_pin.sym} 80 1190 0 0 {name=l89 sig_type=std_logic lab=pb}
N 100 1210 80 1210 {lab=BWK}
C {devices/lab_pin.sym} 80 1210 0 0 {name=l90 sig_type=std_logic lab=BWK}
N 100 1230 80 1230 {lab=BWN}
C {devices/lab_pin.sym} 80 1230 0 0 {name=l91 sig_type=std_logic lab=BWN}
N 300 1030 320 1030 {lab=aqp}
C {devices/lab_pin.sym} 320 1030 0 1 {name=l92 sig_type=std_logic lab=aqp}
N 300 1050 320 1050 {lab=aqn}
C {devices/lab_pin.sym} 320 1050 0 1 {name=l93 sig_type=std_logic lab=aqn}
N 300 1070 320 1070 {lab=VDD}
C {devices/lab_pin.sym} 320 1070 0 1 {name=l94 sig_type=std_logic lab=VDD}
N 300 1090 320 1090 {lab=VSS}
C {devices/lab_pin.sym} 320 1090 0 1 {name=l95 sig_type=std_logic lab=VSS}
C {adc2b.sym} 200 1340 0 0 {name=XADI }
N 100 1310 80 1310 {lab=aip}
C {devices/lab_pin.sym} 80 1310 0 0 {name=l96 sig_type=std_logic lab=aip}
N 100 1330 80 1330 {lab=ain}
C {devices/lab_pin.sym} 80 1330 0 0 {name=l97 sig_type=std_logic lab=ain}
N 100 1350 80 1350 {lab=fs}
C {devices/lab_pin.sym} 80 1350 0 0 {name=l98 sig_type=std_logic lab=fs}
N 300 1310 320 1310 {lab=I_SIGN}
C {devices/lab_pin.sym} 320 1310 0 1 {name=l99 sig_type=std_logic lab=I_SIGN}
N 300 1330 320 1330 {lab=I_MAG}
C {devices/lab_pin.sym} 320 1330 0 1 {name=l100 sig_type=std_logic lab=I_MAG}
N 300 1350 320 1350 {lab=VDD}
C {devices/lab_pin.sym} 320 1350 0 1 {name=l101 sig_type=std_logic lab=VDD}
N 300 1370 320 1370 {lab=VSS}
C {devices/lab_pin.sym} 320 1370 0 1 {name=l102 sig_type=std_logic lab=VSS}
C {adc2b.sym} 620 1340 0 0 {name=XADQ }
N 520 1310 500 1310 {lab=aqp}
C {devices/lab_pin.sym} 500 1310 0 0 {name=l103 sig_type=std_logic lab=aqp}
N 520 1330 500 1330 {lab=aqn}
C {devices/lab_pin.sym} 500 1330 0 0 {name=l104 sig_type=std_logic lab=aqn}
N 520 1350 500 1350 {lab=fs}
C {devices/lab_pin.sym} 500 1350 0 0 {name=l105 sig_type=std_logic lab=fs}
N 720 1310 740 1310 {lab=Q_SIGN}
C {devices/lab_pin.sym} 740 1310 0 1 {name=l106 sig_type=std_logic lab=Q_SIGN}
N 720 1330 740 1330 {lab=Q_MAG}
C {devices/lab_pin.sym} 740 1330 0 1 {name=l107 sig_type=std_logic lab=Q_MAG}
N 720 1350 740 1350 {lab=VDD}
C {devices/lab_pin.sym} 740 1350 0 1 {name=l108 sig_type=std_logic lab=VDD}
N 720 1370 740 1370 {lab=VSS}
C {devices/lab_pin.sym} 740 1370 0 1 {name=l109 sig_type=std_logic lab=VSS}
C {inv_lo2.sym} 1040 1340 0 0 {name=XCKO1 }
N 940 1320 920 1320 {lab=fs}
C {devices/lab_pin.sym} 920 1320 0 0 {name=l110 sig_type=std_logic lab=fs}
N 1140 1320 1160 1320 {lab=fsb}
C {devices/lab_pin.sym} 1160 1320 0 1 {name=l111 sig_type=std_logic lab=fsb}
N 1140 1340 1160 1340 {lab=VDD}
C {devices/lab_pin.sym} 1160 1340 0 1 {name=l112 sig_type=std_logic lab=VDD}
N 1140 1360 1160 1360 {lab=VSS}
C {devices/lab_pin.sym} 1160 1360 0 1 {name=l113 sig_type=std_logic lab=VSS}
C {inv_lo2.sym} 200 1600 0 0 {name=XCKO2 }
N 100 1580 80 1580 {lab=fsb}
C {devices/lab_pin.sym} 80 1580 0 0 {name=l114 sig_type=std_logic lab=fsb}
N 300 1580 320 1580 {lab=CLKOUT}
C {devices/lab_pin.sym} 320 1580 0 1 {name=l115 sig_type=std_logic lab=CLKOUT}
N 300 1600 320 1600 {lab=VDD}
C {devices/lab_pin.sym} 320 1600 0 1 {name=l116 sig_type=std_logic lab=VDD}
N 300 1620 320 1620 {lab=VSS}
C {devices/lab_pin.sym} 320 1620 0 1 {name=l117 sig_type=std_logic lab=VSS}
C {afc_dac.sym} 620 1600 0 0 {name=XAFC }
N 520 1530 500 1530 {lab=AFC0}
C {devices/lab_pin.sym} 500 1530 0 0 {name=l118 sig_type=std_logic lab=AFC0}
N 520 1550 500 1550 {lab=AFC1}
C {devices/lab_pin.sym} 500 1550 0 0 {name=l119 sig_type=std_logic lab=AFC1}
N 520 1570 500 1570 {lab=AFC2}
C {devices/lab_pin.sym} 500 1570 0 0 {name=l120 sig_type=std_logic lab=AFC2}
N 520 1590 500 1590 {lab=AFC3}
C {devices/lab_pin.sym} 500 1590 0 0 {name=l121 sig_type=std_logic lab=AFC3}
N 520 1610 500 1610 {lab=AFC4}
C {devices/lab_pin.sym} 500 1610 0 0 {name=l122 sig_type=std_logic lab=AFC4}
N 520 1630 500 1630 {lab=AFC5}
C {devices/lab_pin.sym} 500 1630 0 0 {name=l123 sig_type=std_logic lab=AFC5}
N 520 1650 500 1650 {lab=AFC6}
C {devices/lab_pin.sym} 500 1650 0 0 {name=l124 sig_type=std_logic lab=AFC6}
N 520 1670 500 1670 {lab=AFC7}
C {devices/lab_pin.sym} 500 1670 0 0 {name=l125 sig_type=std_logic lab=AFC7}
N 720 1530 740 1530 {lab=AFCOUT}
C {devices/lab_pin.sym} 740 1530 0 1 {name=l126 sig_type=std_logic lab=AFCOUT}
N 720 1550 740 1550 {lab=VDD}
C {devices/lab_pin.sym} 740 1550 0 1 {name=l127 sig_type=std_logic lab=VDD}
N 720 1570 740 1570 {lab=VSS}
C {devices/lab_pin.sym} 740 1570 0 1 {name=l128 sig_type=std_logic lab=VSS}
C {decap.sym} 1040 1600 0 0 {name=XDEC }
N 1140 1590 1160 1590 {lab=VDD}
C {devices/lab_pin.sym} 1160 1590 0 1 {name=l129 sig_type=std_logic lab=VDD}
N 1140 1610 1160 1610 {lab=VSS}
C {devices/lab_pin.sym} 1160 1610 0 1 {name=l130 sig_type=std_logic lab=VSS}
C {devices/title.sym} 160 2300 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
