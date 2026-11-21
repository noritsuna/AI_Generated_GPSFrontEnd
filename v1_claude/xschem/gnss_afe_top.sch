v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {GNSS AFE (GPS L1 C/A + Galileo E1) for GF180MCU - top level, 15 pins, on-chip NC-LNA, SPI control} 100 80 0 0 0.6 0.6 {}
T {SPI control registers} 100 190 0 0 0.4 0.4 {layer=8}
T {bias + LO generation} 100 490 0 0 0.4 0.4 {layer=8}
T {RF (single-ended 50 ohm) -> noise-cancelling LNA -> I/Q mixers} 100 1270 0 0 0.4 0.4 {layer=8}
T {2-bit ADCs (sampled at fLO/96 = 16.368 MHz), clock out, AFC DAC} 100 1790 0 0 0.4 0.4 {layer=8}
C {devices/ipin.sym} -100 300 0 0 {name=p0 lab=RFIN}
C {devices/ipin.sym} -100 330 0 0 {name=p1 lab=REFIN}
C {devices/ipin.sym} -100 360 0 0 {name=p2 lab=SCLK}
C {devices/ipin.sym} -100 390 0 0 {name=p3 lab=SDI}
C {devices/ipin.sym} -100 420 0 0 {name=p4 lab=CS_N}
C {devices/opin.sym} -100 450 0 0 {name=p5 lab=I_SIGN}
C {devices/opin.sym} -100 480 0 0 {name=p6 lab=I_MAG}
C {devices/opin.sym} -100 510 0 0 {name=p7 lab=Q_SIGN}
C {devices/opin.sym} -100 540 0 0 {name=p8 lab=Q_MAG}
C {devices/opin.sym} -100 570 0 0 {name=p9 lab=CLKOUT}
C {devices/opin.sym} -100 600 0 0 {name=p10 lab=AFCOUT}
C {devices/opin.sym} -100 630 0 0 {name=p11 lab=VCTRL}
C {devices/iopin.sym} -100 660 0 0 {name=p12 lab=VDDV}
C {devices/iopin.sym} -100 690 0 0 {name=p13 lab=VDD}
C {devices/iopin.sym} -100 720 0 0 {name=p14 lab=VSS}
C {spi_regs.sym} 200 300 0 0 {name=XSPI }
N 100 100 80 100 {lab=SCLK}
C {devices/lab_pin.sym} 80 100 0 0 {name=l1 sig_type=std_logic lab=SCLK}
N 100 120 80 120 {lab=SDI}
C {devices/lab_pin.sym} 80 120 0 0 {name=l2 sig_type=std_logic lab=SDI}
N 100 140 80 140 {lab=CS_N}
C {devices/lab_pin.sym} 80 140 0 0 {name=l3 sig_type=std_logic lab=CS_N}
N 300 100 320 100 {lab=IG1A}
C {devices/lab_pin.sym} 320 100 0 1 {name=l4 sig_type=std_logic lab=IG1A}
N 300 120 320 120 {lab=IG1B}
C {devices/lab_pin.sym} 320 120 0 1 {name=l5 sig_type=std_logic lab=IG1B}
N 300 140 320 140 {lab=IG2A}
C {devices/lab_pin.sym} 320 140 0 1 {name=l6 sig_type=std_logic lab=IG2A}
N 300 160 320 160 {lab=IG2B}
C {devices/lab_pin.sym} 320 160 0 1 {name=l7 sig_type=std_logic lab=IG2B}
N 300 180 320 180 {lab=IG3A}
C {devices/lab_pin.sym} 320 180 0 1 {name=l8 sig_type=std_logic lab=IG3A}
N 300 200 320 200 {lab=IG3B}
C {devices/lab_pin.sym} 320 200 0 1 {name=l9 sig_type=std_logic lab=IG3B}
N 300 220 320 220 {lab=B0}
C {devices/lab_pin.sym} 320 220 0 1 {name=l10 sig_type=std_logic lab=B0}
N 300 240 320 240 {lab=B1}
C {devices/lab_pin.sym} 320 240 0 1 {name=l11 sig_type=std_logic lab=B1}
N 300 260 320 260 {lab=AFC0}
C {devices/lab_pin.sym} 320 260 0 1 {name=l12 sig_type=std_logic lab=AFC0}
N 300 280 320 280 {lab=AFC1}
C {devices/lab_pin.sym} 320 280 0 1 {name=l13 sig_type=std_logic lab=AFC1}
N 300 300 320 300 {lab=AFC2}
C {devices/lab_pin.sym} 320 300 0 1 {name=l14 sig_type=std_logic lab=AFC2}
N 300 320 320 320 {lab=AFC3}
C {devices/lab_pin.sym} 320 320 0 1 {name=l15 sig_type=std_logic lab=AFC3}
N 300 340 320 340 {lab=AFC4}
C {devices/lab_pin.sym} 320 340 0 1 {name=l16 sig_type=std_logic lab=AFC4}
N 300 360 320 360 {lab=AFC5}
C {devices/lab_pin.sym} 320 360 0 1 {name=l17 sig_type=std_logic lab=AFC5}
N 300 380 320 380 {lab=AFC6}
C {devices/lab_pin.sym} 320 380 0 1 {name=l18 sig_type=std_logic lab=AFC6}
N 300 400 320 400 {lab=AFC7}
C {devices/lab_pin.sym} 320 400 0 1 {name=l19 sig_type=std_logic lab=AFC7}
N 300 420 320 420 {lab=ICP2}
C {devices/lab_pin.sym} 320 420 0 1 {name=l20 sig_type=std_logic lab=ICP2}
N 300 440 320 440 {lab=BWW}
C {devices/lab_pin.sym} 320 440 0 1 {name=l21 sig_type=std_logic lab=BWW}
N 300 460 320 460 {lab=BWN}
C {devices/lab_pin.sym} 320 460 0 1 {name=l22 sig_type=std_logic lab=BWN}
N 300 480 320 480 {lab=VDD}
C {devices/lab_pin.sym} 320 480 0 1 {name=l23 sig_type=std_logic lab=VDD}
N 300 500 320 500 {lab=VSS}
C {devices/lab_pin.sym} 320 500 0 1 {name=l24 sig_type=std_logic lab=VSS}
C {bias_gen.sym} 200 610 0 0 {name=XBIAS }
N 300 580 320 580 {lab=nb}
C {devices/lab_pin.sym} 320 580 0 1 {name=l25 sig_type=std_logic lab=nb}
N 300 600 320 600 {lab=pb}
C {devices/lab_pin.sym} 320 600 0 1 {name=l26 sig_type=std_logic lab=pb}
N 300 620 320 620 {lab=VDD}
C {devices/lab_pin.sym} 320 620 0 1 {name=l27 sig_type=std_logic lab=VDD}
N 300 640 320 640 {lab=VSS}
C {devices/lab_pin.sym} 320 640 0 1 {name=l28 sig_type=std_logic lab=VSS}
C {vmon_buf.sym} 620 600 0 0 {name=XMON }
N 520 580 500 580 {lab=vctrl}
C {devices/lab_pin.sym} 500 580 0 0 {name=l29 sig_type=std_logic lab=vctrl}
N 520 600 500 600 {lab=nb}
C {devices/lab_pin.sym} 500 600 0 0 {name=l30 sig_type=std_logic lab=nb}
N 720 580 740 580 {lab=vmon}
C {devices/lab_pin.sym} 740 580 0 1 {name=l31 sig_type=std_logic lab=vmon}
N 720 600 740 600 {lab=VDDV}
C {devices/lab_pin.sym} 740 600 0 1 {name=l32 sig_type=std_logic lab=VDDV}
N 720 620 740 620 {lab=VSS}
C {devices/lab_pin.sym} 740 620 0 1 {name=l33 sig_type=std_logic lab=VSS}
C {inv_dig.sym} 1040 600 0 0 {name=XBW }
N 940 580 920 580 {lab=BWW}
C {devices/lab_pin.sym} 920 580 0 0 {name=l34 sig_type=std_logic lab=BWW}
N 1140 580 1160 580 {lab=bwk}
C {devices/lab_pin.sym} 1160 580 0 1 {name=l35 sig_type=std_logic lab=bwk}
N 1140 600 1160 600 {lab=VDD}
C {devices/lab_pin.sym} 1160 600 0 1 {name=l36 sig_type=std_logic lab=VDD}
N 1140 620 1160 620 {lab=VSS}
C {devices/lab_pin.sym} 1160 620 0 1 {name=l37 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 200 860 0 0 {name=RMON W=1u L=10u model=ppolyf_u_1k spiceprefix=X m=1}
N 200 890 200 910 {lab=vmon}
C {devices/lab_pin.sym} 200 910 0 0 {name=l38 sig_type=std_logic lab=vmon}
N 200 830 200 810 {lab=VCTRL}
C {devices/lab_pin.sym} 200 810 0 0 {name=l39 sig_type=std_logic lab=VCTRL}
N 180 860 160 860 {lab=VSS}
C {devices/lab_pin.sym} 160 860 0 0 {name=l40 sig_type=std_logic lab=VSS}
C {vco_ring4.sym} 620 860 0 0 {name=XVCO }
N 520 750 500 750 {lab=vctrl}
C {devices/lab_pin.sym} 500 750 0 0 {name=l41 sig_type=std_logic lab=vctrl}
N 520 770 500 770 {lab=B0}
C {devices/lab_pin.sym} 500 770 0 0 {name=l42 sig_type=std_logic lab=B0}
N 520 790 500 790 {lab=B1}
C {devices/lab_pin.sym} 500 790 0 0 {name=l43 sig_type=std_logic lab=B1}
N 520 810 500 810 {lab=nb}
C {devices/lab_pin.sym} 500 810 0 0 {name=l44 sig_type=std_logic lab=nb}
N 720 750 740 750 {lab=l1p}
C {devices/lab_pin.sym} 740 750 0 1 {name=l45 sig_type=std_logic lab=l1p}
N 720 770 740 770 {lab=l1n}
C {devices/lab_pin.sym} 740 770 0 1 {name=l46 sig_type=std_logic lab=l1n}
N 720 790 740 790 {lab=l2p}
C {devices/lab_pin.sym} 740 790 0 1 {name=l47 sig_type=std_logic lab=l2p}
N 720 810 740 810 {lab=l2n}
C {devices/lab_pin.sym} 740 810 0 1 {name=l48 sig_type=std_logic lab=l2n}
N 720 830 740 830 {lab=l3p}
C {devices/lab_pin.sym} 740 830 0 1 {name=l49 sig_type=std_logic lab=l3p}
N 720 850 740 850 {lab=l3n}
C {devices/lab_pin.sym} 740 850 0 1 {name=l50 sig_type=std_logic lab=l3n}
N 720 870 740 870 {lab=l4p}
C {devices/lab_pin.sym} 740 870 0 1 {name=l51 sig_type=std_logic lab=l4p}
N 720 890 740 890 {lab=l4n}
C {devices/lab_pin.sym} 740 890 0 1 {name=l52 sig_type=std_logic lab=l4n}
N 720 910 740 910 {lab=ckr}
C {devices/lab_pin.sym} 740 910 0 1 {name=l53 sig_type=std_logic lab=ckr}
N 720 930 740 930 {lab=vr}
C {devices/lab_pin.sym} 740 930 0 1 {name=l54 sig_type=std_logic lab=vr}
N 720 950 740 950 {lab=VDDV}
C {devices/lab_pin.sym} 740 950 0 1 {name=l55 sig_type=std_logic lab=VDDV}
N 720 970 740 970 {lab=VSS}
C {devices/lab_pin.sym} 740 970 0 1 {name=l56 sig_type=std_logic lab=VSS}
C {refbuf.sym} 1040 860 0 0 {name=XRB }
N 940 840 920 840 {lab=REFIN}
C {devices/lab_pin.sym} 920 840 0 0 {name=l57 sig_type=std_logic lab=REFIN}
N 1140 840 1160 840 {lab=refck}
C {devices/lab_pin.sym} 1160 840 0 1 {name=l58 sig_type=std_logic lab=refck}
N 1140 860 1160 860 {lab=VDDV}
C {devices/lab_pin.sym} 1160 860 0 1 {name=l59 sig_type=std_logic lab=VDDV}
N 1140 880 1160 880 {lab=VSS}
C {devices/lab_pin.sym} 1160 880 0 1 {name=l60 sig_type=std_logic lab=VSS}
C {pll_core.sym} 200 1120 0 0 {name=XPLL }
N 100 1080 80 1080 {lab=refck}
C {devices/lab_pin.sym} 80 1080 0 0 {name=l61 sig_type=std_logic lab=refck}
N 100 1100 80 1100 {lab=ckr}
C {devices/lab_pin.sym} 80 1100 0 0 {name=l62 sig_type=std_logic lab=ckr}
N 100 1120 80 1120 {lab=nb}
C {devices/lab_pin.sym} 80 1120 0 0 {name=l63 sig_type=std_logic lab=nb}
N 100 1140 80 1140 {lab=pb}
C {devices/lab_pin.sym} 80 1140 0 0 {name=l64 sig_type=std_logic lab=pb}
N 100 1160 80 1160 {lab=ICP2}
C {devices/lab_pin.sym} 80 1160 0 0 {name=l65 sig_type=std_logic lab=ICP2}
N 300 1080 320 1080 {lab=vctrl}
C {devices/lab_pin.sym} 320 1080 0 1 {name=l66 sig_type=std_logic lab=vctrl}
N 300 1100 320 1100 {lab=fs}
C {devices/lab_pin.sym} 320 1100 0 1 {name=l67 sig_type=std_logic lab=fs}
N 300 1120 320 1120 {lab=fb}
C {devices/lab_pin.sym} 320 1120 0 1 {name=l68 sig_type=std_logic lab=fb}
N 300 1140 320 1140 {lab=VDD}
C {devices/lab_pin.sym} 320 1140 0 1 {name=l69 sig_type=std_logic lab=VDD}
N 300 1160 320 1160 {lab=VSS}
C {devices/lab_pin.sym} 320 1160 0 1 {name=l70 sig_type=std_logic lab=VSS}
C {lna_nc.sym} 200 1380 0 0 {name=XLNA }
N 100 1350 80 1350 {lab=RFIN}
C {devices/lab_pin.sym} 80 1350 0 0 {name=l71 sig_type=std_logic lab=RFIN}
N 100 1370 80 1370 {lab=pb}
C {devices/lab_pin.sym} 80 1370 0 0 {name=l72 sig_type=std_logic lab=pb}
N 300 1350 320 1350 {lab=rfp}
C {devices/lab_pin.sym} 320 1350 0 1 {name=l73 sig_type=std_logic lab=rfp}
N 300 1370 320 1370 {lab=rfn}
C {devices/lab_pin.sym} 320 1370 0 1 {name=l74 sig_type=std_logic lab=rfn}
N 300 1390 320 1390 {lab=VDD}
C {devices/lab_pin.sym} 320 1390 0 1 {name=l75 sig_type=std_logic lab=VDD}
N 300 1410 320 1410 {lab=VSS}
C {devices/lab_pin.sym} 320 1410 0 1 {name=l76 sig_type=std_logic lab=VSS}
C {mixer_iq.sym} 620 1380 0 0 {name=XMIX }
N 520 1280 500 1280 {lab=rfp}
C {devices/lab_pin.sym} 500 1280 0 0 {name=l77 sig_type=std_logic lab=rfp}
N 520 1300 500 1300 {lab=rfn}
C {devices/lab_pin.sym} 500 1300 0 0 {name=l78 sig_type=std_logic lab=rfn}
N 520 1320 500 1320 {lab=l1p}
C {devices/lab_pin.sym} 500 1320 0 0 {name=l79 sig_type=std_logic lab=l1p}
N 520 1340 500 1340 {lab=l1n}
C {devices/lab_pin.sym} 500 1340 0 0 {name=l80 sig_type=std_logic lab=l1n}
N 520 1360 500 1360 {lab=l2p}
C {devices/lab_pin.sym} 500 1360 0 0 {name=l81 sig_type=std_logic lab=l2p}
N 520 1380 500 1380 {lab=l2n}
C {devices/lab_pin.sym} 500 1380 0 0 {name=l82 sig_type=std_logic lab=l2n}
N 520 1400 500 1400 {lab=l3p}
C {devices/lab_pin.sym} 500 1400 0 0 {name=l83 sig_type=std_logic lab=l3p}
N 520 1420 500 1420 {lab=l3n}
C {devices/lab_pin.sym} 500 1420 0 0 {name=l84 sig_type=std_logic lab=l3n}
N 520 1440 500 1440 {lab=l4p}
C {devices/lab_pin.sym} 500 1440 0 0 {name=l85 sig_type=std_logic lab=l4p}
N 520 1460 500 1460 {lab=l4n}
C {devices/lab_pin.sym} 500 1460 0 0 {name=l86 sig_type=std_logic lab=l4n}
N 520 1480 500 1480 {lab=nb}
C {devices/lab_pin.sym} 500 1480 0 0 {name=l87 sig_type=std_logic lab=nb}
N 720 1280 740 1280 {lab=mip}
C {devices/lab_pin.sym} 740 1280 0 1 {name=l88 sig_type=std_logic lab=mip}
N 720 1300 740 1300 {lab=min}
C {devices/lab_pin.sym} 740 1300 0 1 {name=l89 sig_type=std_logic lab=min}
N 720 1320 740 1320 {lab=mqp}
C {devices/lab_pin.sym} 740 1320 0 1 {name=l90 sig_type=std_logic lab=mqp}
N 720 1340 740 1340 {lab=mqn}
C {devices/lab_pin.sym} 740 1340 0 1 {name=l91 sig_type=std_logic lab=mqn}
N 720 1360 740 1360 {lab=VDD}
C {devices/lab_pin.sym} 740 1360 0 1 {name=l92 sig_type=std_logic lab=VDD}
N 720 1380 740 1380 {lab=VSS}
C {devices/lab_pin.sym} 740 1380 0 1 {name=l93 sig_type=std_logic lab=VSS}
C {if_chain.sym} 1040 1380 0 0 {name=XIFI }
N 940 1280 920 1280 {lab=mip}
C {devices/lab_pin.sym} 920 1280 0 0 {name=l94 sig_type=std_logic lab=mip}
N 940 1300 920 1300 {lab=min}
C {devices/lab_pin.sym} 920 1300 0 0 {name=l95 sig_type=std_logic lab=min}
N 940 1320 920 1320 {lab=IG1A}
C {devices/lab_pin.sym} 920 1320 0 0 {name=l96 sig_type=std_logic lab=IG1A}
N 940 1340 920 1340 {lab=IG1B}
C {devices/lab_pin.sym} 920 1340 0 0 {name=l97 sig_type=std_logic lab=IG1B}
N 940 1360 920 1360 {lab=IG2A}
C {devices/lab_pin.sym} 920 1360 0 0 {name=l98 sig_type=std_logic lab=IG2A}
N 940 1380 920 1380 {lab=IG2B}
C {devices/lab_pin.sym} 920 1380 0 0 {name=l99 sig_type=std_logic lab=IG2B}
N 940 1400 920 1400 {lab=IG3A}
C {devices/lab_pin.sym} 920 1400 0 0 {name=l100 sig_type=std_logic lab=IG3A}
N 940 1420 920 1420 {lab=IG3B}
C {devices/lab_pin.sym} 920 1420 0 0 {name=l101 sig_type=std_logic lab=IG3B}
N 940 1440 920 1440 {lab=pb}
C {devices/lab_pin.sym} 920 1440 0 0 {name=l102 sig_type=std_logic lab=pb}
N 940 1460 920 1460 {lab=bwk}
C {devices/lab_pin.sym} 920 1460 0 0 {name=l103 sig_type=std_logic lab=bwk}
N 940 1480 920 1480 {lab=BWN}
C {devices/lab_pin.sym} 920 1480 0 0 {name=l104 sig_type=std_logic lab=BWN}
N 1140 1280 1160 1280 {lab=aip}
C {devices/lab_pin.sym} 1160 1280 0 1 {name=l105 sig_type=std_logic lab=aip}
N 1140 1300 1160 1300 {lab=ain}
C {devices/lab_pin.sym} 1160 1300 0 1 {name=l106 sig_type=std_logic lab=ain}
N 1140 1320 1160 1320 {lab=VDD}
C {devices/lab_pin.sym} 1160 1320 0 1 {name=l107 sig_type=std_logic lab=VDD}
N 1140 1340 1160 1340 {lab=VSS}
C {devices/lab_pin.sym} 1160 1340 0 1 {name=l108 sig_type=std_logic lab=VSS}
C {if_chain.sym} 200 1660 0 0 {name=XIFQ }
N 100 1560 80 1560 {lab=mqp}
C {devices/lab_pin.sym} 80 1560 0 0 {name=l109 sig_type=std_logic lab=mqp}
N 100 1580 80 1580 {lab=mqn}
C {devices/lab_pin.sym} 80 1580 0 0 {name=l110 sig_type=std_logic lab=mqn}
N 100 1600 80 1600 {lab=IG1A}
C {devices/lab_pin.sym} 80 1600 0 0 {name=l111 sig_type=std_logic lab=IG1A}
N 100 1620 80 1620 {lab=IG1B}
C {devices/lab_pin.sym} 80 1620 0 0 {name=l112 sig_type=std_logic lab=IG1B}
N 100 1640 80 1640 {lab=IG2A}
C {devices/lab_pin.sym} 80 1640 0 0 {name=l113 sig_type=std_logic lab=IG2A}
N 100 1660 80 1660 {lab=IG2B}
C {devices/lab_pin.sym} 80 1660 0 0 {name=l114 sig_type=std_logic lab=IG2B}
N 100 1680 80 1680 {lab=IG3A}
C {devices/lab_pin.sym} 80 1680 0 0 {name=l115 sig_type=std_logic lab=IG3A}
N 100 1700 80 1700 {lab=IG3B}
C {devices/lab_pin.sym} 80 1700 0 0 {name=l116 sig_type=std_logic lab=IG3B}
N 100 1720 80 1720 {lab=pb}
C {devices/lab_pin.sym} 80 1720 0 0 {name=l117 sig_type=std_logic lab=pb}
N 100 1740 80 1740 {lab=bwk}
C {devices/lab_pin.sym} 80 1740 0 0 {name=l118 sig_type=std_logic lab=bwk}
N 100 1760 80 1760 {lab=BWN}
C {devices/lab_pin.sym} 80 1760 0 0 {name=l119 sig_type=std_logic lab=BWN}
N 300 1560 320 1560 {lab=aqp}
C {devices/lab_pin.sym} 320 1560 0 1 {name=l120 sig_type=std_logic lab=aqp}
N 300 1580 320 1580 {lab=aqn}
C {devices/lab_pin.sym} 320 1580 0 1 {name=l121 sig_type=std_logic lab=aqn}
N 300 1600 320 1600 {lab=VDD}
C {devices/lab_pin.sym} 320 1600 0 1 {name=l122 sig_type=std_logic lab=VDD}
N 300 1620 320 1620 {lab=VSS}
C {devices/lab_pin.sym} 320 1620 0 1 {name=l123 sig_type=std_logic lab=VSS}
C {adc2b.sym} 200 1900 0 0 {name=XADI }
N 100 1870 80 1870 {lab=aip}
C {devices/lab_pin.sym} 80 1870 0 0 {name=l124 sig_type=std_logic lab=aip}
N 100 1890 80 1890 {lab=ain}
C {devices/lab_pin.sym} 80 1890 0 0 {name=l125 sig_type=std_logic lab=ain}
N 100 1910 80 1910 {lab=fs}
C {devices/lab_pin.sym} 80 1910 0 0 {name=l126 sig_type=std_logic lab=fs}
N 300 1870 320 1870 {lab=I_SIGN}
C {devices/lab_pin.sym} 320 1870 0 1 {name=l127 sig_type=std_logic lab=I_SIGN}
N 300 1890 320 1890 {lab=I_MAG}
C {devices/lab_pin.sym} 320 1890 0 1 {name=l128 sig_type=std_logic lab=I_MAG}
N 300 1910 320 1910 {lab=VDD}
C {devices/lab_pin.sym} 320 1910 0 1 {name=l129 sig_type=std_logic lab=VDD}
N 300 1930 320 1930 {lab=VSS}
C {devices/lab_pin.sym} 320 1930 0 1 {name=l130 sig_type=std_logic lab=VSS}
C {adc2b.sym} 620 1900 0 0 {name=XADQ }
N 520 1870 500 1870 {lab=aqp}
C {devices/lab_pin.sym} 500 1870 0 0 {name=l131 sig_type=std_logic lab=aqp}
N 520 1890 500 1890 {lab=aqn}
C {devices/lab_pin.sym} 500 1890 0 0 {name=l132 sig_type=std_logic lab=aqn}
N 520 1910 500 1910 {lab=fs}
C {devices/lab_pin.sym} 500 1910 0 0 {name=l133 sig_type=std_logic lab=fs}
N 720 1870 740 1870 {lab=Q_SIGN}
C {devices/lab_pin.sym} 740 1870 0 1 {name=l134 sig_type=std_logic lab=Q_SIGN}
N 720 1890 740 1890 {lab=Q_MAG}
C {devices/lab_pin.sym} 740 1890 0 1 {name=l135 sig_type=std_logic lab=Q_MAG}
N 720 1910 740 1910 {lab=VDD}
C {devices/lab_pin.sym} 740 1910 0 1 {name=l136 sig_type=std_logic lab=VDD}
N 720 1930 740 1930 {lab=VSS}
C {devices/lab_pin.sym} 740 1930 0 1 {name=l137 sig_type=std_logic lab=VSS}
C {inv_lo2.sym} 1040 1900 0 0 {name=XCKO1 }
N 940 1880 920 1880 {lab=fs}
C {devices/lab_pin.sym} 920 1880 0 0 {name=l138 sig_type=std_logic lab=fs}
N 1140 1880 1160 1880 {lab=fsb}
C {devices/lab_pin.sym} 1160 1880 0 1 {name=l139 sig_type=std_logic lab=fsb}
N 1140 1900 1160 1900 {lab=VDD}
C {devices/lab_pin.sym} 1160 1900 0 1 {name=l140 sig_type=std_logic lab=VDD}
N 1140 1920 1160 1920 {lab=VSS}
C {devices/lab_pin.sym} 1160 1920 0 1 {name=l141 sig_type=std_logic lab=VSS}
C {inv_lo2.sym} 200 2160 0 0 {name=XCKO2 }
N 100 2140 80 2140 {lab=fsb}
C {devices/lab_pin.sym} 80 2140 0 0 {name=l142 sig_type=std_logic lab=fsb}
N 300 2140 320 2140 {lab=CLKOUT}
C {devices/lab_pin.sym} 320 2140 0 1 {name=l143 sig_type=std_logic lab=CLKOUT}
N 300 2160 320 2160 {lab=VDD}
C {devices/lab_pin.sym} 320 2160 0 1 {name=l144 sig_type=std_logic lab=VDD}
N 300 2180 320 2180 {lab=VSS}
C {devices/lab_pin.sym} 320 2180 0 1 {name=l145 sig_type=std_logic lab=VSS}
C {afc_dac.sym} 620 2160 0 0 {name=XAFC }
N 520 2090 500 2090 {lab=AFC0}
C {devices/lab_pin.sym} 500 2090 0 0 {name=l146 sig_type=std_logic lab=AFC0}
N 520 2110 500 2110 {lab=AFC1}
C {devices/lab_pin.sym} 500 2110 0 0 {name=l147 sig_type=std_logic lab=AFC1}
N 520 2130 500 2130 {lab=AFC2}
C {devices/lab_pin.sym} 500 2130 0 0 {name=l148 sig_type=std_logic lab=AFC2}
N 520 2150 500 2150 {lab=AFC3}
C {devices/lab_pin.sym} 500 2150 0 0 {name=l149 sig_type=std_logic lab=AFC3}
N 520 2170 500 2170 {lab=AFC4}
C {devices/lab_pin.sym} 500 2170 0 0 {name=l150 sig_type=std_logic lab=AFC4}
N 520 2190 500 2190 {lab=AFC5}
C {devices/lab_pin.sym} 500 2190 0 0 {name=l151 sig_type=std_logic lab=AFC5}
N 520 2210 500 2210 {lab=AFC6}
C {devices/lab_pin.sym} 500 2210 0 0 {name=l152 sig_type=std_logic lab=AFC6}
N 520 2230 500 2230 {lab=AFC7}
C {devices/lab_pin.sym} 500 2230 0 0 {name=l153 sig_type=std_logic lab=AFC7}
N 720 2090 740 2090 {lab=AFCOUT}
C {devices/lab_pin.sym} 740 2090 0 1 {name=l154 sig_type=std_logic lab=AFCOUT}
N 720 2110 740 2110 {lab=VDD}
C {devices/lab_pin.sym} 740 2110 0 1 {name=l155 sig_type=std_logic lab=VDD}
N 720 2130 740 2130 {lab=VSS}
C {devices/lab_pin.sym} 740 2130 0 1 {name=l156 sig_type=std_logic lab=VSS}
C {decap.sym} 1040 2160 0 0 {name=XDEC }
N 1140 2150 1160 2150 {lab=VDD}
C {devices/lab_pin.sym} 1160 2150 0 1 {name=l157 sig_type=std_logic lab=VDD}
N 1140 2170 1160 2170 {lab=VSS}
C {devices/lab_pin.sym} 1160 2170 0 1 {name=l158 sig_type=std_logic lab=VSS}
C {devices/title.sym} 160 2860 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
