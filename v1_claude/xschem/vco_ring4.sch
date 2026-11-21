v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {VCO: 4-stage ring at fLO/2 = 785.664 MHz, 8 phases (45 deg) for the sub-harmonic mixer} 100 80 0 0 0.6 0.6 {}
T {V/I converter + PMOS mirror (ring is supplied by current)} 100 190 0 0 0.4 0.4 {layer=8}
T {coarse band: 1x and 2x extra mirror branches} 100 390 0 0 0.4 0.4 {layer=8}
T {ring: 4 stages, wrap-around inversion} 100 790 0 0 0.4 0.4 {layer=8}
T {start-up: common-mode latch detector -> kick (VR domain)} 100 1140 0 0 0.4 0.4 {layer=8}
C {devices/ipin.sym} -100 300 0 0 {name=p0 lab=VCTRL}
C {devices/ipin.sym} -100 330 0 0 {name=p1 lab=B0}
C {devices/ipin.sym} -100 360 0 0 {name=p2 lab=B1}
C {devices/ipin.sym} -100 390 0 0 {name=p3 lab=NB}
C {devices/opin.sym} -100 420 0 0 {name=p4 lab=L1P}
C {devices/opin.sym} -100 450 0 0 {name=p5 lab=L1N}
C {devices/opin.sym} -100 480 0 0 {name=p6 lab=L2P}
C {devices/opin.sym} -100 510 0 0 {name=p7 lab=L2N}
C {devices/opin.sym} -100 540 0 0 {name=p8 lab=L3P}
C {devices/opin.sym} -100 570 0 0 {name=p9 lab=L3N}
C {devices/opin.sym} -100 600 0 0 {name=p10 lab=L4P}
C {devices/opin.sym} -100 630 0 0 {name=p11 lab=L4N}
C {devices/opin.sym} -100 660 0 0 {name=p12 lab=CK}
C {devices/opin.sym} -100 690 0 0 {name=p13 lab=VR}
C {devices/iopin.sym} -100 720 0 0 {name=p14 lab=VDD}
C {devices/iopin.sym} -100 750 0 0 {name=p15 lab=VSS}
C {symbols/nfet_03v3.sym} 200 300 0 0 {name=MVI L=0.5u W=20u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 270 220 250 {lab=ng}
C {devices/lab_pin.sym} 220 250 0 0 {name=l1 sig_type=std_logic lab=ng}
N 180 300 160 300 {lab=VCTRL}
C {devices/lab_pin.sym} 160 300 0 0 {name=l2 sig_type=std_logic lab=VCTRL}
N 220 330 220 350 {lab=ns}
C {devices/lab_pin.sym} 220 350 0 0 {name=l3 sig_type=std_logic lab=ns}
N 220 300 240 300 {lab=VSS}
C {devices/lab_pin.sym} 240 300 0 1 {name=l4 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 460 300 0 0 {name=RDEG W=2u L=4u model=ppolyf_u_1k spiceprefix=X m=1}
N 460 330 460 350 {lab=VSS}
C {devices/lab_pin.sym} 460 350 0 0 {name=l5 sig_type=std_logic lab=VSS}
N 460 270 460 250 {lab=ns}
C {devices/lab_pin.sym} 460 250 0 0 {name=l6 sig_type=std_logic lab=ns}
N 440 300 420 300 {lab=VSS}
C {devices/lab_pin.sym} 420 300 0 0 {name=l7 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 720 300 0 0 {name=MPD L=0.56u W=80u nf=16 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 740 330 740 350 {lab=ng}
C {devices/lab_pin.sym} 740 350 0 0 {name=l8 sig_type=std_logic lab=ng}
N 700 300 680 300 {lab=ng}
C {devices/lab_pin.sym} 680 300 0 0 {name=l9 sig_type=std_logic lab=ng}
N 740 270 740 250 {lab=VDD}
C {devices/lab_pin.sym} 740 250 0 0 {name=l10 sig_type=std_logic lab=VDD}
N 740 300 760 300 {lab=VDD}
C {devices/lab_pin.sym} 760 300 0 1 {name=l11 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 980 300 0 0 {name=MPO L=0.56u W=80u nf=16 m=16 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1000 330 1000 350 {lab=VR}
C {devices/lab_pin.sym} 1000 350 0 0 {name=l12 sig_type=std_logic lab=VR}
N 960 300 940 300 {lab=ng}
C {devices/lab_pin.sym} 940 300 0 0 {name=l13 sig_type=std_logic lab=ng}
N 1000 270 1000 250 {lab=VDD}
C {devices/lab_pin.sym} 1000 250 0 0 {name=l14 sig_type=std_logic lab=VDD}
N 1000 300 1020 300 {lab=VDD}
C {devices/lab_pin.sym} 1020 300 0 1 {name=l15 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 1240 300 0 0 {name=MMIN L=2u W=12u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 1260 270 1260 250 {lab=ng}
C {devices/lab_pin.sym} 1260 250 0 0 {name=l16 sig_type=std_logic lab=ng}
N 1220 300 1200 300 {lab=NB}
C {devices/lab_pin.sym} 1200 300 0 0 {name=l17 sig_type=std_logic lab=NB}
N 1260 330 1260 350 {lab=VSS}
C {devices/lab_pin.sym} 1260 350 0 0 {name=l18 sig_type=std_logic lab=VSS}
N 1260 300 1280 300 {lab=VSS}
C {devices/lab_pin.sym} 1280 300 0 1 {name=l19 sig_type=std_logic lab=VSS}
C {inv_dig.sym} 200 500 0 0 {name=XB0 }
N 100 480 80 480 {lab=B0}
C {devices/lab_pin.sym} 80 480 0 0 {name=l20 sig_type=std_logic lab=B0}
N 300 480 320 480 {lab=b0n}
C {devices/lab_pin.sym} 320 480 0 1 {name=l21 sig_type=std_logic lab=b0n}
N 300 500 320 500 {lab=VDD}
C {devices/lab_pin.sym} 320 500 0 1 {name=l22 sig_type=std_logic lab=VDD}
N 300 520 320 520 {lab=VSS}
C {devices/lab_pin.sym} 320 520 0 1 {name=l23 sig_type=std_logic lab=VSS}
C {inv_dig.sym} 460 500 0 0 {name=XB1 }
N 360 480 340 480 {lab=B1}
C {devices/lab_pin.sym} 340 480 0 0 {name=l24 sig_type=std_logic lab=B1}
N 560 480 580 480 {lab=b1n}
C {devices/lab_pin.sym} 580 480 0 1 {name=l25 sig_type=std_logic lab=b1n}
N 560 500 580 500 {lab=VDD}
C {devices/lab_pin.sym} 580 500 0 1 {name=l26 sig_type=std_logic lab=VDD}
N 560 520 580 520 {lab=VSS}
C {devices/lab_pin.sym} 580 520 0 1 {name=l27 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 720 500 0 0 {name=MPB0 L=0.56u W=80u nf=16 m=12 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 740 530 740 550 {lab=nb0}
C {devices/lab_pin.sym} 740 550 0 0 {name=l28 sig_type=std_logic lab=nb0}
N 700 500 680 500 {lab=ng}
C {devices/lab_pin.sym} 680 500 0 0 {name=l29 sig_type=std_logic lab=ng}
N 740 470 740 450 {lab=VDD}
C {devices/lab_pin.sym} 740 450 0 0 {name=l30 sig_type=std_logic lab=VDD}
N 740 500 760 500 {lab=VDD}
C {devices/lab_pin.sym} 760 500 0 1 {name=l31 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 980 500 0 0 {name=MSB0 L=0.28u W=40u nf=8 m=12 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1000 530 1000 550 {lab=VR}
C {devices/lab_pin.sym} 1000 550 0 0 {name=l32 sig_type=std_logic lab=VR}
N 960 500 940 500 {lab=b0n}
C {devices/lab_pin.sym} 940 500 0 0 {name=l33 sig_type=std_logic lab=b0n}
N 1000 470 1000 450 {lab=nb0}
C {devices/lab_pin.sym} 1000 450 0 0 {name=l34 sig_type=std_logic lab=nb0}
N 1000 500 1020 500 {lab=VDD}
C {devices/lab_pin.sym} 1020 500 0 1 {name=l35 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 1240 500 0 0 {name=MPB1 L=0.56u W=80u nf=16 m=24 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1260 530 1260 550 {lab=nb1}
C {devices/lab_pin.sym} 1260 550 0 0 {name=l36 sig_type=std_logic lab=nb1}
N 1220 500 1200 500 {lab=ng}
C {devices/lab_pin.sym} 1200 500 0 0 {name=l37 sig_type=std_logic lab=ng}
N 1260 470 1260 450 {lab=VDD}
C {devices/lab_pin.sym} 1260 450 0 0 {name=l38 sig_type=std_logic lab=VDD}
N 1260 500 1280 500 {lab=VDD}
C {devices/lab_pin.sym} 1280 500 0 1 {name=l39 sig_type=std_logic lab=VDD}
C {symbols/pfet_03v3.sym} 1500 500 0 0 {name=MSB1 L=0.28u W=40u nf=8 m=24 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1520 530 1520 550 {lab=VR}
C {devices/lab_pin.sym} 1520 550 0 0 {name=l40 sig_type=std_logic lab=VR}
N 1480 500 1460 500 {lab=b1n}
C {devices/lab_pin.sym} 1460 500 0 0 {name=l41 sig_type=std_logic lab=b1n}
N 1520 470 1520 450 {lab=nb1}
C {devices/lab_pin.sym} 1520 450 0 0 {name=l42 sig_type=std_logic lab=nb1}
N 1520 500 1540 500 {lab=VDD}
C {devices/lab_pin.sym} 1540 500 0 1 {name=l43 sig_type=std_logic lab=VDD}
C {symbols/cap_mim_2f0fF.sym} 200 700 0 0 {name=CVR W=30e-6 L=30e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 200 670 200 650 {lab=VR}
C {devices/lab_pin.sym} 200 650 0 0 {name=l44 sig_type=std_logic lab=VR}
N 200 730 200 750 {lab=VSS}
C {devices/lab_pin.sym} 200 750 0 0 {name=l45 sig_type=std_logic lab=VSS}
C {vco_core.sym} 200 980 0 0 {name=XCORE }
N 300 810 320 810 {lab=L1P}
C {devices/lab_pin.sym} 320 810 0 1 {name=l46 sig_type=std_logic lab=L1P}
N 300 830 320 830 {lab=L1N}
C {devices/lab_pin.sym} 320 830 0 1 {name=l47 sig_type=std_logic lab=L1N}
N 300 850 320 850 {lab=L2P}
C {devices/lab_pin.sym} 320 850 0 1 {name=l48 sig_type=std_logic lab=L2P}
N 300 870 320 870 {lab=L2N}
C {devices/lab_pin.sym} 320 870 0 1 {name=l49 sig_type=std_logic lab=L2N}
N 300 890 320 890 {lab=L3P}
C {devices/lab_pin.sym} 320 890 0 1 {name=l50 sig_type=std_logic lab=L3P}
N 300 910 320 910 {lab=L3N}
C {devices/lab_pin.sym} 320 910 0 1 {name=l51 sig_type=std_logic lab=L3N}
N 300 930 320 930 {lab=L4P}
C {devices/lab_pin.sym} 320 930 0 1 {name=l52 sig_type=std_logic lab=L4P}
N 300 950 320 950 {lab=L4N}
C {devices/lab_pin.sym} 320 950 0 1 {name=l53 sig_type=std_logic lab=L4N}
N 300 970 320 970 {lab=CK}
C {devices/lab_pin.sym} 320 970 0 1 {name=l54 sig_type=std_logic lab=CK}
N 300 990 320 990 {lab=ckdn1}
C {devices/lab_pin.sym} 320 990 0 1 {name=l55 sig_type=std_logic lab=ckdn1}
N 300 1010 320 1010 {lab=ckdp2}
C {devices/lab_pin.sym} 320 1010 0 1 {name=l56 sig_type=std_logic lab=ckdp2}
N 300 1030 320 1030 {lab=ckdn2}
C {devices/lab_pin.sym} 320 1030 0 1 {name=l57 sig_type=std_logic lab=ckdn2}
N 300 1050 320 1050 {lab=ckdp3}
C {devices/lab_pin.sym} 320 1050 0 1 {name=l58 sig_type=std_logic lab=ckdp3}
N 300 1070 320 1070 {lab=ckdn3}
C {devices/lab_pin.sym} 320 1070 0 1 {name=l59 sig_type=std_logic lab=ckdn3}
N 300 1090 320 1090 {lab=ckdp4}
C {devices/lab_pin.sym} 320 1090 0 1 {name=l60 sig_type=std_logic lab=ckdp4}
N 300 1110 320 1110 {lab=ckdn4}
C {devices/lab_pin.sym} 320 1110 0 1 {name=l61 sig_type=std_logic lab=ckdn4}
N 100 810 80 810 {lab=kh}
C {devices/lab_pin.sym} 80 810 0 0 {name=l62 sig_type=std_logic lab=kh}
N 100 830 80 830 {lab=kl}
C {devices/lab_pin.sym} 80 830 0 0 {name=l63 sig_type=std_logic lab=kl}
N 300 1130 320 1130 {lab=VR}
C {devices/lab_pin.sym} 320 1130 0 1 {name=l64 sig_type=std_logic lab=VR}
N 300 1150 320 1150 {lab=VSS}
C {devices/lab_pin.sym} 320 1150 0 1 {name=l65 sig_type=std_logic lab=VSS}
C {nand2.sym} 200 1250 0 0 {name=XSUA }
N 100 1230 80 1230 {lab=ckdp2}
C {devices/lab_pin.sym} 80 1230 0 0 {name=l66 sig_type=std_logic lab=ckdp2}
N 100 1250 80 1250 {lab=ckdn2}
C {devices/lab_pin.sym} 80 1250 0 0 {name=l67 sig_type=std_logic lab=ckdn2}
N 300 1230 320 1230 {lab=sua}
C {devices/lab_pin.sym} 320 1230 0 1 {name=l68 sig_type=std_logic lab=sua}
N 300 1250 320 1250 {lab=VR}
C {devices/lab_pin.sym} 320 1250 0 1 {name=l69 sig_type=std_logic lab=VR}
N 300 1270 320 1270 {lab=VSS}
C {devices/lab_pin.sym} 320 1270 0 1 {name=l70 sig_type=std_logic lab=VSS}
C {nor2.sym} 460 1250 0 0 {name=XSUB }
N 360 1230 340 1230 {lab=ckdp2}
C {devices/lab_pin.sym} 340 1230 0 0 {name=l71 sig_type=std_logic lab=ckdp2}
N 360 1250 340 1250 {lab=ckdn2}
C {devices/lab_pin.sym} 340 1250 0 0 {name=l72 sig_type=std_logic lab=ckdn2}
N 560 1230 580 1230 {lab=sub}
C {devices/lab_pin.sym} 580 1230 0 1 {name=l73 sig_type=std_logic lab=sub}
N 560 1250 580 1250 {lab=VR}
C {devices/lab_pin.sym} 580 1250 0 1 {name=l74 sig_type=std_logic lab=VR}
N 560 1270 580 1270 {lab=VSS}
C {devices/lab_pin.sym} 580 1270 0 1 {name=l75 sig_type=std_logic lab=VSS}
C {nand2.sym} 720 1250 0 0 {name=XSUAD1 }
N 620 1230 600 1230 {lab=CK}
C {devices/lab_pin.sym} 600 1230 0 0 {name=l76 sig_type=std_logic lab=CK}
N 620 1250 600 1250 {lab=ckdn1}
C {devices/lab_pin.sym} 600 1250 0 0 {name=l77 sig_type=std_logic lab=ckdn1}
N 820 1230 840 1230 {lab=suad1}
C {devices/lab_pin.sym} 840 1230 0 1 {name=l78 sig_type=std_logic lab=suad1}
N 820 1250 840 1250 {lab=VR}
C {devices/lab_pin.sym} 840 1250 0 1 {name=l79 sig_type=std_logic lab=VR}
N 820 1270 840 1270 {lab=VSS}
C {devices/lab_pin.sym} 840 1270 0 1 {name=l80 sig_type=std_logic lab=VSS}
C {nor2.sym} 980 1250 0 0 {name=XSUBD1 }
N 880 1230 860 1230 {lab=CK}
C {devices/lab_pin.sym} 860 1230 0 0 {name=l81 sig_type=std_logic lab=CK}
N 880 1250 860 1250 {lab=ckdn1}
C {devices/lab_pin.sym} 860 1250 0 0 {name=l82 sig_type=std_logic lab=ckdn1}
N 1080 1230 1100 1230 {lab=subd1}
C {devices/lab_pin.sym} 1100 1230 0 1 {name=l83 sig_type=std_logic lab=subd1}
N 1080 1250 1100 1250 {lab=VR}
C {devices/lab_pin.sym} 1100 1250 0 1 {name=l84 sig_type=std_logic lab=VR}
N 1080 1270 1100 1270 {lab=VSS}
C {devices/lab_pin.sym} 1100 1270 0 1 {name=l85 sig_type=std_logic lab=VSS}
C {nand2.sym} 1240 1250 0 0 {name=XSUAD3 }
N 1140 1230 1120 1230 {lab=ckdp3}
C {devices/lab_pin.sym} 1120 1230 0 0 {name=l86 sig_type=std_logic lab=ckdp3}
N 1140 1250 1120 1250 {lab=ckdn3}
C {devices/lab_pin.sym} 1120 1250 0 0 {name=l87 sig_type=std_logic lab=ckdn3}
N 1340 1230 1360 1230 {lab=suad3}
C {devices/lab_pin.sym} 1360 1230 0 1 {name=l88 sig_type=std_logic lab=suad3}
N 1340 1250 1360 1250 {lab=VR}
C {devices/lab_pin.sym} 1360 1250 0 1 {name=l89 sig_type=std_logic lab=VR}
N 1340 1270 1360 1270 {lab=VSS}
C {devices/lab_pin.sym} 1360 1270 0 1 {name=l90 sig_type=std_logic lab=VSS}
C {nor2.sym} 1500 1250 0 0 {name=XSUBD3 }
N 1400 1230 1380 1230 {lab=ckdp3}
C {devices/lab_pin.sym} 1380 1230 0 0 {name=l91 sig_type=std_logic lab=ckdp3}
N 1400 1250 1380 1250 {lab=ckdn3}
C {devices/lab_pin.sym} 1380 1250 0 0 {name=l92 sig_type=std_logic lab=ckdn3}
N 1600 1230 1620 1230 {lab=subd3}
C {devices/lab_pin.sym} 1620 1230 0 1 {name=l93 sig_type=std_logic lab=subd3}
N 1600 1250 1620 1250 {lab=VR}
C {devices/lab_pin.sym} 1620 1250 0 1 {name=l94 sig_type=std_logic lab=VR}
N 1600 1270 1620 1270 {lab=VSS}
C {devices/lab_pin.sym} 1620 1270 0 1 {name=l95 sig_type=std_logic lab=VSS}
C {nand2.sym} 200 1450 0 0 {name=XSUAD4 }
N 100 1430 80 1430 {lab=ckdp4}
C {devices/lab_pin.sym} 80 1430 0 0 {name=l96 sig_type=std_logic lab=ckdp4}
N 100 1450 80 1450 {lab=ckdn4}
C {devices/lab_pin.sym} 80 1450 0 0 {name=l97 sig_type=std_logic lab=ckdn4}
N 300 1430 320 1430 {lab=suad4}
C {devices/lab_pin.sym} 320 1430 0 1 {name=l98 sig_type=std_logic lab=suad4}
N 300 1450 320 1450 {lab=VR}
C {devices/lab_pin.sym} 320 1450 0 1 {name=l99 sig_type=std_logic lab=VR}
N 300 1470 320 1470 {lab=VSS}
C {devices/lab_pin.sym} 320 1470 0 1 {name=l100 sig_type=std_logic lab=VSS}
C {nor2.sym} 460 1450 0 0 {name=XSUBD4 }
N 360 1430 340 1430 {lab=ckdp4}
C {devices/lab_pin.sym} 340 1430 0 0 {name=l101 sig_type=std_logic lab=ckdp4}
N 360 1450 340 1450 {lab=ckdn4}
C {devices/lab_pin.sym} 340 1450 0 0 {name=l102 sig_type=std_logic lab=ckdn4}
N 560 1430 580 1430 {lab=subd4}
C {devices/lab_pin.sym} 580 1430 0 1 {name=l103 sig_type=std_logic lab=subd4}
N 560 1450 580 1450 {lab=VR}
C {devices/lab_pin.sym} 580 1450 0 1 {name=l104 sig_type=std_logic lab=VR}
N 560 1470 580 1470 {lab=VSS}
C {devices/lab_pin.sym} 580 1470 0 1 {name=l105 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 720 1450 0 0 {name=RSUA W=1u L=100u model=ppolyf_u_1k spiceprefix=X m=1}
N 720 1480 720 1500 {lab=fsua}
C {devices/lab_pin.sym} 720 1500 0 0 {name=l106 sig_type=std_logic lab=fsua}
N 720 1420 720 1400 {lab=sua}
C {devices/lab_pin.sym} 720 1400 0 0 {name=l107 sig_type=std_logic lab=sua}
N 700 1450 680 1450 {lab=VSS}
C {devices/lab_pin.sym} 680 1450 0 0 {name=l108 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 980 1450 0 0 {name=CSUA W=5e-6 L=5e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 980 1420 980 1400 {lab=fsua}
C {devices/lab_pin.sym} 980 1400 0 0 {name=l109 sig_type=std_logic lab=fsua}
N 980 1480 980 1500 {lab=VSS}
C {devices/lab_pin.sym} 980 1500 0 0 {name=l110 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 1240 1450 0 0 {name=RSUB W=1u L=100u model=ppolyf_u_1k spiceprefix=X m=1}
N 1240 1480 1240 1500 {lab=fsub}
C {devices/lab_pin.sym} 1240 1500 0 0 {name=l111 sig_type=std_logic lab=fsub}
N 1240 1420 1240 1400 {lab=sub}
C {devices/lab_pin.sym} 1240 1400 0 0 {name=l112 sig_type=std_logic lab=sub}
N 1220 1450 1200 1450 {lab=VSS}
C {devices/lab_pin.sym} 1200 1450 0 0 {name=l113 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 1500 1450 0 0 {name=CSUB W=5e-6 L=5e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 1500 1420 1500 1400 {lab=fsub}
C {devices/lab_pin.sym} 1500 1400 0 0 {name=l114 sig_type=std_logic lab=fsub}
N 1500 1480 1500 1500 {lab=VSS}
C {devices/lab_pin.sym} 1500 1500 0 0 {name=l115 sig_type=std_logic lab=VSS}
C {nor2.sym} 200 1650 0 0 {name=XSUA1 }
N 100 1630 80 1630 {lab=sua}
C {devices/lab_pin.sym} 80 1630 0 0 {name=l116 sig_type=std_logic lab=sua}
N 100 1650 80 1650 {lab=fsua}
C {devices/lab_pin.sym} 80 1650 0 0 {name=l117 sig_type=std_logic lab=fsua}
N 300 1630 320 1630 {lab=kh}
C {devices/lab_pin.sym} 320 1630 0 1 {name=l118 sig_type=std_logic lab=kh}
N 300 1650 320 1650 {lab=VR}
C {devices/lab_pin.sym} 320 1650 0 1 {name=l119 sig_type=std_logic lab=VR}
N 300 1670 320 1670 {lab=VSS}
C {devices/lab_pin.sym} 320 1670 0 1 {name=l120 sig_type=std_logic lab=VSS}
C {inv_dig.sym} 460 1650 0 0 {name=XSUA2 }
N 360 1630 340 1630 {lab=kh}
C {devices/lab_pin.sym} 340 1630 0 0 {name=l121 sig_type=std_logic lab=kh}
N 560 1630 580 1630 {lab=khn}
C {devices/lab_pin.sym} 580 1630 0 1 {name=l122 sig_type=std_logic lab=khn}
N 560 1650 580 1650 {lab=VR}
C {devices/lab_pin.sym} 580 1650 0 1 {name=l123 sig_type=std_logic lab=VR}
N 560 1670 580 1670 {lab=VSS}
C {devices/lab_pin.sym} 580 1670 0 1 {name=l124 sig_type=std_logic lab=VSS}
C {nand2.sym} 720 1650 0 0 {name=XSUB1 }
N 620 1630 600 1630 {lab=sub}
C {devices/lab_pin.sym} 600 1630 0 0 {name=l125 sig_type=std_logic lab=sub}
N 620 1650 600 1650 {lab=fsub}
C {devices/lab_pin.sym} 600 1650 0 0 {name=l126 sig_type=std_logic lab=fsub}
N 820 1630 840 1630 {lab=kln}
C {devices/lab_pin.sym} 840 1630 0 1 {name=l127 sig_type=std_logic lab=kln}
N 820 1650 840 1650 {lab=VR}
C {devices/lab_pin.sym} 840 1650 0 1 {name=l128 sig_type=std_logic lab=VR}
N 820 1670 840 1670 {lab=VSS}
C {devices/lab_pin.sym} 840 1670 0 1 {name=l129 sig_type=std_logic lab=VSS}
C {inv_dig.sym} 980 1650 0 0 {name=XSUB2 }
N 880 1630 860 1630 {lab=kln}
C {devices/lab_pin.sym} 860 1630 0 0 {name=l130 sig_type=std_logic lab=kln}
N 1080 1630 1100 1630 {lab=kl}
C {devices/lab_pin.sym} 1100 1630 0 1 {name=l131 sig_type=std_logic lab=kl}
N 1080 1650 1100 1650 {lab=VR}
C {devices/lab_pin.sym} 1100 1650 0 1 {name=l132 sig_type=std_logic lab=VR}
N 1080 1670 1100 1670 {lab=VSS}
C {devices/lab_pin.sym} 1100 1670 0 1 {name=l133 sig_type=std_logic lab=VSS}
C {devices/title.sym} 160 2130 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
