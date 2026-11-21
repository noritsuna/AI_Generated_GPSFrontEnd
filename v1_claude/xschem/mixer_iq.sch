v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {I/Q sub-harmonic Gilbert mixer, RF 1575.42 MHz, LO 2 x 785.664 MHz, 2 mA/mixer, driven by lna_nc} 100 80 0 0 0.6 0.6 {}
T {RF input bias (LNA drives the mixer: 5 kohm to VBRF) + bias divider} 100 190 0 0 0.4 0.4 {layer=8}
T {LO AC coupling (2 pF) + 20 kohm to the switch-gate biases (upper 1.8 V, lower 1.2 V)} 100 390 0 0 0.4 0.4 {layer=8}
T {LO load trim (NMOS gate caps on the switch-gate nodes, sized from the PEX loads)} 100 1190 0 0 0.4 0.4 {layer=8}
T {I mixer: Gm pair, lower switch pairs, upper switch quads, RC load} 100 1590 0 0 0.4 0.4 {layer=8}
T {Q mixer: Gm pair, lower switch pairs, upper switch quads, RC load} 100 2390 0 0 0.4 0.4 {layer=8}
C {devices/ipin.sym} -100 300 0 0 {name=p0 lab=RFP}
C {devices/ipin.sym} -100 330 0 0 {name=p1 lab=RFN}
C {devices/ipin.sym} -100 360 0 0 {name=p2 lab=L1P}
C {devices/ipin.sym} -100 390 0 0 {name=p3 lab=L1N}
C {devices/ipin.sym} -100 420 0 0 {name=p4 lab=L2P}
C {devices/ipin.sym} -100 450 0 0 {name=p5 lab=L2N}
C {devices/ipin.sym} -100 480 0 0 {name=p6 lab=L3P}
C {devices/ipin.sym} -100 510 0 0 {name=p7 lab=L3N}
C {devices/ipin.sym} -100 540 0 0 {name=p8 lab=L4P}
C {devices/ipin.sym} -100 570 0 0 {name=p9 lab=L4N}
C {devices/ipin.sym} -100 600 0 0 {name=p10 lab=NB}
C {devices/opin.sym} -100 630 0 0 {name=p11 lab=IFIP}
C {devices/opin.sym} -100 660 0 0 {name=p12 lab=IFIN}
C {devices/opin.sym} -100 690 0 0 {name=p13 lab=IFQP}
C {devices/opin.sym} -100 720 0 0 {name=p14 lab=IFQN}
C {devices/iopin.sym} -100 750 0 0 {name=p15 lab=VDD}
C {devices/iopin.sym} -100 780 0 0 {name=p16 lab=VSS}
C {symbols/ppolyf_u_1k.sym} 200 300 0 0 {name=RT1 W=1u L=5u model=ppolyf_u_1k spiceprefix=X m=1}
N 200 330 200 350 {lab=vbrf}
C {devices/lab_pin.sym} 200 350 0 0 {name=l1 sig_type=std_logic lab=vbrf}
N 200 270 200 250 {lab=RFP}
C {devices/lab_pin.sym} 200 250 0 0 {name=l2 sig_type=std_logic lab=RFP}
N 180 300 160 300 {lab=VSS}
C {devices/lab_pin.sym} 160 300 0 0 {name=l3 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 460 300 0 0 {name=RT2 W=1u L=5u model=ppolyf_u_1k spiceprefix=X m=1}
N 460 330 460 350 {lab=vbrf}
C {devices/lab_pin.sym} 460 350 0 0 {name=l4 sig_type=std_logic lab=vbrf}
N 460 270 460 250 {lab=RFN}
C {devices/lab_pin.sym} 460 250 0 0 {name=l5 sig_type=std_logic lab=RFN}
N 440 300 420 300 {lab=VSS}
C {devices/lab_pin.sym} 420 300 0 0 {name=l6 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 720 300 0 0 {name=RBA W=1u L=20u model=ppolyf_u_1k spiceprefix=X m=1}
N 720 330 720 350 {lab=vbrf}
C {devices/lab_pin.sym} 720 350 0 0 {name=l7 sig_type=std_logic lab=vbrf}
N 720 270 720 250 {lab=VDD}
C {devices/lab_pin.sym} 720 250 0 0 {name=l8 sig_type=std_logic lab=VDD}
N 700 300 680 300 {lab=VSS}
C {devices/lab_pin.sym} 680 300 0 0 {name=l9 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 980 300 0 0 {name=RBB W=1u L=13u model=ppolyf_u_1k spiceprefix=X m=1}
N 980 330 980 350 {lab=VSS}
C {devices/lab_pin.sym} 980 350 0 0 {name=l10 sig_type=std_logic lab=VSS}
N 980 270 980 250 {lab=vbrf}
C {devices/lab_pin.sym} 980 250 0 0 {name=l11 sig_type=std_logic lab=vbrf}
N 960 300 940 300 {lab=VSS}
C {devices/lab_pin.sym} 940 300 0 0 {name=l12 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 1240 300 0 0 {name=CBRF W=70e-6 L=70e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 1240 270 1240 250 {lab=vbrf}
C {devices/lab_pin.sym} 1240 250 0 0 {name=l13 sig_type=std_logic lab=vbrf}
N 1240 330 1240 350 {lab=VSS}
C {devices/lab_pin.sym} 1240 350 0 0 {name=l14 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 200 500 0 0 {name=RLUA W=1u L=47u model=ppolyf_u_1k spiceprefix=X m=1}
N 200 530 200 550 {lab=vlou}
C {devices/lab_pin.sym} 200 550 0 0 {name=l15 sig_type=std_logic lab=vlou}
N 200 470 200 450 {lab=VDD}
C {devices/lab_pin.sym} 200 450 0 0 {name=l16 sig_type=std_logic lab=VDD}
N 180 500 160 500 {lab=VSS}
C {devices/lab_pin.sym} 160 500 0 0 {name=l17 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 460 500 0 0 {name=RLUB W=1u L=56u model=ppolyf_u_1k spiceprefix=X m=1}
N 460 530 460 550 {lab=VSS}
C {devices/lab_pin.sym} 460 550 0 0 {name=l18 sig_type=std_logic lab=VSS}
N 460 470 460 450 {lab=vlou}
C {devices/lab_pin.sym} 460 450 0 0 {name=l19 sig_type=std_logic lab=vlou}
N 440 500 420 500 {lab=VSS}
C {devices/lab_pin.sym} 420 500 0 0 {name=l20 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 720 500 0 0 {name=CLOU W=50e-6 L=50e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 720 470 720 450 {lab=vlou}
C {devices/lab_pin.sym} 720 450 0 0 {name=l21 sig_type=std_logic lab=vlou}
N 720 530 720 550 {lab=VSS}
C {devices/lab_pin.sym} 720 550 0 0 {name=l22 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 980 500 0 0 {name=RLLA W=1u L=65u model=ppolyf_u_1k spiceprefix=X m=1}
N 980 530 980 550 {lab=vlol}
C {devices/lab_pin.sym} 980 550 0 0 {name=l23 sig_type=std_logic lab=vlol}
N 980 470 980 450 {lab=VDD}
C {devices/lab_pin.sym} 980 450 0 0 {name=l24 sig_type=std_logic lab=VDD}
N 960 500 940 500 {lab=VSS}
C {devices/lab_pin.sym} 940 500 0 0 {name=l25 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 1240 500 0 0 {name=RLLB W=1u L=37u model=ppolyf_u_1k spiceprefix=X m=1}
N 1240 530 1240 550 {lab=VSS}
C {devices/lab_pin.sym} 1240 550 0 0 {name=l26 sig_type=std_logic lab=VSS}
N 1240 470 1240 450 {lab=vlol}
C {devices/lab_pin.sym} 1240 450 0 0 {name=l27 sig_type=std_logic lab=vlol}
N 1220 500 1200 500 {lab=VSS}
C {devices/lab_pin.sym} 1200 500 0 0 {name=l28 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 1500 500 0 0 {name=CLOL W=50e-6 L=50e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 1500 470 1500 450 {lab=vlol}
C {devices/lab_pin.sym} 1500 450 0 0 {name=l29 sig_type=std_logic lab=vlol}
N 1500 530 1500 550 {lab=VSS}
C {devices/lab_pin.sym} 1500 550 0 0 {name=l30 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 200 700 0 0 {name=CACL1P W=31.6e-6 L=31.6e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 200 670 200 650 {lab=L1P}
C {devices/lab_pin.sym} 200 650 0 0 {name=l31 sig_type=std_logic lab=L1P}
N 200 730 200 750 {lab=gl1p}
C {devices/lab_pin.sym} 200 750 0 0 {name=l32 sig_type=std_logic lab=gl1p}
C {symbols/ppolyf_u_1k.sym} 460 700 0 0 {name=RACL1P W=1u L=20u model=ppolyf_u_1k spiceprefix=X m=1}
N 460 730 460 750 {lab=vlou}
C {devices/lab_pin.sym} 460 750 0 0 {name=l33 sig_type=std_logic lab=vlou}
N 460 670 460 650 {lab=gl1p}
C {devices/lab_pin.sym} 460 650 0 0 {name=l34 sig_type=std_logic lab=gl1p}
N 440 700 420 700 {lab=VSS}
C {devices/lab_pin.sym} 420 700 0 0 {name=l35 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 720 700 0 0 {name=CACL1N W=31.6e-6 L=31.6e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 720 670 720 650 {lab=L1N}
C {devices/lab_pin.sym} 720 650 0 0 {name=l36 sig_type=std_logic lab=L1N}
N 720 730 720 750 {lab=gl1n}
C {devices/lab_pin.sym} 720 750 0 0 {name=l37 sig_type=std_logic lab=gl1n}
C {symbols/ppolyf_u_1k.sym} 980 700 0 0 {name=RACL1N W=1u L=20u model=ppolyf_u_1k spiceprefix=X m=1}
N 980 730 980 750 {lab=vlou}
C {devices/lab_pin.sym} 980 750 0 0 {name=l38 sig_type=std_logic lab=vlou}
N 980 670 980 650 {lab=gl1n}
C {devices/lab_pin.sym} 980 650 0 0 {name=l39 sig_type=std_logic lab=gl1n}
N 960 700 940 700 {lab=VSS}
C {devices/lab_pin.sym} 940 700 0 0 {name=l40 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 1240 700 0 0 {name=CACL2P W=31.6e-6 L=31.6e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 1240 670 1240 650 {lab=L2P}
C {devices/lab_pin.sym} 1240 650 0 0 {name=l41 sig_type=std_logic lab=L2P}
N 1240 730 1240 750 {lab=gl2p}
C {devices/lab_pin.sym} 1240 750 0 0 {name=l42 sig_type=std_logic lab=gl2p}
C {symbols/ppolyf_u_1k.sym} 1500 700 0 0 {name=RACL2P W=1u L=20u model=ppolyf_u_1k spiceprefix=X m=1}
N 1500 730 1500 750 {lab=vlou}
C {devices/lab_pin.sym} 1500 750 0 0 {name=l43 sig_type=std_logic lab=vlou}
N 1500 670 1500 650 {lab=gl2p}
C {devices/lab_pin.sym} 1500 650 0 0 {name=l44 sig_type=std_logic lab=gl2p}
N 1480 700 1460 700 {lab=VSS}
C {devices/lab_pin.sym} 1460 700 0 0 {name=l45 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 200 900 0 0 {name=CACL2N W=31.6e-6 L=31.6e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 200 870 200 850 {lab=L2N}
C {devices/lab_pin.sym} 200 850 0 0 {name=l46 sig_type=std_logic lab=L2N}
N 200 930 200 950 {lab=gl2n}
C {devices/lab_pin.sym} 200 950 0 0 {name=l47 sig_type=std_logic lab=gl2n}
C {symbols/ppolyf_u_1k.sym} 460 900 0 0 {name=RACL2N W=1u L=20u model=ppolyf_u_1k spiceprefix=X m=1}
N 460 930 460 950 {lab=vlou}
C {devices/lab_pin.sym} 460 950 0 0 {name=l48 sig_type=std_logic lab=vlou}
N 460 870 460 850 {lab=gl2n}
C {devices/lab_pin.sym} 460 850 0 0 {name=l49 sig_type=std_logic lab=gl2n}
N 440 900 420 900 {lab=VSS}
C {devices/lab_pin.sym} 420 900 0 0 {name=l50 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 720 900 0 0 {name=CACL3P W=31.6e-6 L=31.6e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 720 870 720 850 {lab=L3P}
C {devices/lab_pin.sym} 720 850 0 0 {name=l51 sig_type=std_logic lab=L3P}
N 720 930 720 950 {lab=gl3p}
C {devices/lab_pin.sym} 720 950 0 0 {name=l52 sig_type=std_logic lab=gl3p}
C {symbols/ppolyf_u_1k.sym} 980 900 0 0 {name=RACL3P W=1u L=20u model=ppolyf_u_1k spiceprefix=X m=1}
N 980 930 980 950 {lab=vlol}
C {devices/lab_pin.sym} 980 950 0 0 {name=l53 sig_type=std_logic lab=vlol}
N 980 870 980 850 {lab=gl3p}
C {devices/lab_pin.sym} 980 850 0 0 {name=l54 sig_type=std_logic lab=gl3p}
N 960 900 940 900 {lab=VSS}
C {devices/lab_pin.sym} 940 900 0 0 {name=l55 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 1240 900 0 0 {name=CACL3N W=31.6e-6 L=31.6e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 1240 870 1240 850 {lab=L3N}
C {devices/lab_pin.sym} 1240 850 0 0 {name=l56 sig_type=std_logic lab=L3N}
N 1240 930 1240 950 {lab=gl3n}
C {devices/lab_pin.sym} 1240 950 0 0 {name=l57 sig_type=std_logic lab=gl3n}
C {symbols/ppolyf_u_1k.sym} 1500 900 0 0 {name=RACL3N W=1u L=20u model=ppolyf_u_1k spiceprefix=X m=1}
N 1500 930 1500 950 {lab=vlol}
C {devices/lab_pin.sym} 1500 950 0 0 {name=l58 sig_type=std_logic lab=vlol}
N 1500 870 1500 850 {lab=gl3n}
C {devices/lab_pin.sym} 1500 850 0 0 {name=l59 sig_type=std_logic lab=gl3n}
N 1480 900 1460 900 {lab=VSS}
C {devices/lab_pin.sym} 1460 900 0 0 {name=l60 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 200 1100 0 0 {name=CACL4P W=31.6e-6 L=31.6e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 200 1070 200 1050 {lab=L4P}
C {devices/lab_pin.sym} 200 1050 0 0 {name=l61 sig_type=std_logic lab=L4P}
N 200 1130 200 1150 {lab=gl4p}
C {devices/lab_pin.sym} 200 1150 0 0 {name=l62 sig_type=std_logic lab=gl4p}
C {symbols/ppolyf_u_1k.sym} 460 1100 0 0 {name=RACL4P W=1u L=20u model=ppolyf_u_1k spiceprefix=X m=1}
N 460 1130 460 1150 {lab=vlol}
C {devices/lab_pin.sym} 460 1150 0 0 {name=l63 sig_type=std_logic lab=vlol}
N 460 1070 460 1050 {lab=gl4p}
C {devices/lab_pin.sym} 460 1050 0 0 {name=l64 sig_type=std_logic lab=gl4p}
N 440 1100 420 1100 {lab=VSS}
C {devices/lab_pin.sym} 420 1100 0 0 {name=l65 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 720 1100 0 0 {name=CACL4N W=31.6e-6 L=31.6e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 720 1070 720 1050 {lab=L4N}
C {devices/lab_pin.sym} 720 1050 0 0 {name=l66 sig_type=std_logic lab=L4N}
N 720 1130 720 1150 {lab=gl4n}
C {devices/lab_pin.sym} 720 1150 0 0 {name=l67 sig_type=std_logic lab=gl4n}
C {symbols/ppolyf_u_1k.sym} 980 1100 0 0 {name=RACL4N W=1u L=20u model=ppolyf_u_1k spiceprefix=X m=1}
N 980 1130 980 1150 {lab=vlol}
C {devices/lab_pin.sym} 980 1150 0 0 {name=l68 sig_type=std_logic lab=vlol}
N 980 1070 980 1050 {lab=gl4n}
C {devices/lab_pin.sym} 980 1050 0 0 {name=l69 sig_type=std_logic lab=gl4n}
N 960 1100 940 1100 {lab=VSS}
C {devices/lab_pin.sym} 940 1100 0 0 {name=l70 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 200 1300 0 0 {name=MCTL1P L=2u W=4.96u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 1270 220 1250 {lab=VSS}
C {devices/lab_pin.sym} 220 1250 0 0 {name=l71 sig_type=std_logic lab=VSS}
N 180 1300 160 1300 {lab=gl1p}
C {devices/lab_pin.sym} 160 1300 0 0 {name=l72 sig_type=std_logic lab=gl1p}
N 220 1330 220 1350 {lab=VSS}
C {devices/lab_pin.sym} 220 1350 0 0 {name=l73 sig_type=std_logic lab=VSS}
N 220 1300 240 1300 {lab=VSS}
C {devices/lab_pin.sym} 240 1300 0 1 {name=l74 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 460 1300 0 0 {name=MCTL1N L=2u W=6.08u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 480 1270 480 1250 {lab=VSS}
C {devices/lab_pin.sym} 480 1250 0 0 {name=l75 sig_type=std_logic lab=VSS}
N 440 1300 420 1300 {lab=gl1n}
C {devices/lab_pin.sym} 420 1300 0 0 {name=l76 sig_type=std_logic lab=gl1n}
N 480 1330 480 1350 {lab=VSS}
C {devices/lab_pin.sym} 480 1350 0 0 {name=l77 sig_type=std_logic lab=VSS}
N 480 1300 500 1300 {lab=VSS}
C {devices/lab_pin.sym} 500 1300 0 1 {name=l78 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 720 1300 0 0 {name=MCTL2P L=2u W=3.97u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 740 1270 740 1250 {lab=VSS}
C {devices/lab_pin.sym} 740 1250 0 0 {name=l79 sig_type=std_logic lab=VSS}
N 700 1300 680 1300 {lab=gl2p}
C {devices/lab_pin.sym} 680 1300 0 0 {name=l80 sig_type=std_logic lab=gl2p}
N 740 1330 740 1350 {lab=VSS}
C {devices/lab_pin.sym} 740 1350 0 0 {name=l81 sig_type=std_logic lab=VSS}
N 740 1300 760 1300 {lab=VSS}
C {devices/lab_pin.sym} 760 1300 0 1 {name=l82 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 980 1300 0 0 {name=MCTL2N L=2u W=4.25u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 1000 1270 1000 1250 {lab=VSS}
C {devices/lab_pin.sym} 1000 1250 0 0 {name=l83 sig_type=std_logic lab=VSS}
N 960 1300 940 1300 {lab=gl2n}
C {devices/lab_pin.sym} 940 1300 0 0 {name=l84 sig_type=std_logic lab=gl2n}
N 1000 1330 1000 1350 {lab=VSS}
C {devices/lab_pin.sym} 1000 1350 0 0 {name=l85 sig_type=std_logic lab=VSS}
N 1000 1300 1020 1300 {lab=VSS}
C {devices/lab_pin.sym} 1020 1300 0 1 {name=l86 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 1240 1300 0 0 {name=MCTL3P L=2u W=0.83u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 1260 1270 1260 1250 {lab=VSS}
C {devices/lab_pin.sym} 1260 1250 0 0 {name=l87 sig_type=std_logic lab=VSS}
N 1220 1300 1200 1300 {lab=gl3p}
C {devices/lab_pin.sym} 1200 1300 0 0 {name=l88 sig_type=std_logic lab=gl3p}
N 1260 1330 1260 1350 {lab=VSS}
C {devices/lab_pin.sym} 1260 1350 0 0 {name=l89 sig_type=std_logic lab=VSS}
N 1260 1300 1280 1300 {lab=VSS}
C {devices/lab_pin.sym} 1280 1300 0 1 {name=l90 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 1500 1300 0 0 {name=MCTL3N L=2u W=0.8u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 1520 1270 1520 1250 {lab=VSS}
C {devices/lab_pin.sym} 1520 1250 0 0 {name=l91 sig_type=std_logic lab=VSS}
N 1480 1300 1460 1300 {lab=gl3n}
C {devices/lab_pin.sym} 1460 1300 0 0 {name=l92 sig_type=std_logic lab=gl3n}
N 1520 1330 1520 1350 {lab=VSS}
C {devices/lab_pin.sym} 1520 1350 0 0 {name=l93 sig_type=std_logic lab=VSS}
N 1520 1300 1540 1300 {lab=VSS}
C {devices/lab_pin.sym} 1540 1300 0 1 {name=l94 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 200 1500 0 0 {name=MCTL4P L=2u W=1.3u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 1470 220 1450 {lab=VSS}
C {devices/lab_pin.sym} 220 1450 0 0 {name=l95 sig_type=std_logic lab=VSS}
N 180 1500 160 1500 {lab=gl4p}
C {devices/lab_pin.sym} 160 1500 0 0 {name=l96 sig_type=std_logic lab=gl4p}
N 220 1530 220 1550 {lab=VSS}
C {devices/lab_pin.sym} 220 1550 0 0 {name=l97 sig_type=std_logic lab=VSS}
N 220 1500 240 1500 {lab=VSS}
C {devices/lab_pin.sym} 240 1500 0 1 {name=l98 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 460 1500 0 0 {name=MCTL4N L=2u W=1.65u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 480 1470 480 1450 {lab=VSS}
C {devices/lab_pin.sym} 480 1450 0 0 {name=l99 sig_type=std_logic lab=VSS}
N 440 1500 420 1500 {lab=gl4n}
C {devices/lab_pin.sym} 420 1500 0 0 {name=l100 sig_type=std_logic lab=gl4n}
N 480 1530 480 1550 {lab=VSS}
C {devices/lab_pin.sym} 480 1550 0 0 {name=l101 sig_type=std_logic lab=VSS}
N 480 1500 500 1500 {lab=VSS}
C {devices/lab_pin.sym} 500 1500 0 1 {name=l102 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 200 1700 0 0 {name=MTI L=2u W=40u nf=4 m=16 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 1670 220 1650 {lab=tI}
C {devices/lab_pin.sym} 220 1650 0 0 {name=l103 sig_type=std_logic lab=tI}
N 180 1700 160 1700 {lab=NB}
C {devices/lab_pin.sym} 160 1700 0 0 {name=l104 sig_type=std_logic lab=NB}
N 220 1730 220 1750 {lab=VSS}
C {devices/lab_pin.sym} 220 1750 0 0 {name=l105 sig_type=std_logic lab=VSS}
N 220 1700 240 1700 {lab=VSS}
C {devices/lab_pin.sym} 240 1700 0 1 {name=l106 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 460 1700 0 0 {name=MG1I L=0.28u W=80u nf=16 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 480 1670 480 1650 {lab=xpI}
C {devices/lab_pin.sym} 480 1650 0 0 {name=l107 sig_type=std_logic lab=xpI}
N 440 1700 420 1700 {lab=RFP}
C {devices/lab_pin.sym} 420 1700 0 0 {name=l108 sig_type=std_logic lab=RFP}
N 480 1730 480 1750 {lab=tI}
C {devices/lab_pin.sym} 480 1750 0 0 {name=l109 sig_type=std_logic lab=tI}
N 480 1700 500 1700 {lab=VSS}
C {devices/lab_pin.sym} 500 1700 0 1 {name=l110 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 720 1700 0 0 {name=MG2I L=0.28u W=80u nf=16 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 740 1670 740 1650 {lab=xnI}
C {devices/lab_pin.sym} 740 1650 0 0 {name=l111 sig_type=std_logic lab=xnI}
N 700 1700 680 1700 {lab=RFN}
C {devices/lab_pin.sym} 680 1700 0 0 {name=l112 sig_type=std_logic lab=RFN}
N 740 1730 740 1750 {lab=tI}
C {devices/lab_pin.sym} 740 1750 0 0 {name=l113 sig_type=std_logic lab=tI}
N 740 1700 760 1700 {lab=VSS}
C {devices/lab_pin.sym} 760 1700 0 1 {name=l114 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 980 1700 0 0 {name=MLApI L=0.28u W=40u nf=8 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 1000 1670 1000 1650 {lab=mpaI}
C {devices/lab_pin.sym} 1000 1650 0 0 {name=l115 sig_type=std_logic lab=mpaI}
N 960 1700 940 1700 {lab=gl3n}
C {devices/lab_pin.sym} 940 1700 0 0 {name=l116 sig_type=std_logic lab=gl3n}
N 1000 1730 1000 1750 {lab=xpI}
C {devices/lab_pin.sym} 1000 1750 0 0 {name=l117 sig_type=std_logic lab=xpI}
N 1000 1700 1020 1700 {lab=VSS}
C {devices/lab_pin.sym} 1020 1700 0 1 {name=l118 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 1240 1700 0 0 {name=MLBpI L=0.28u W=40u nf=8 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 1260 1670 1260 1650 {lab=mpbI}
C {devices/lab_pin.sym} 1260 1650 0 0 {name=l119 sig_type=std_logic lab=mpbI}
N 1220 1700 1200 1700 {lab=gl3p}
C {devices/lab_pin.sym} 1200 1700 0 0 {name=l120 sig_type=std_logic lab=gl3p}
N 1260 1730 1260 1750 {lab=xpI}
C {devices/lab_pin.sym} 1260 1750 0 0 {name=l121 sig_type=std_logic lab=xpI}
N 1260 1700 1280 1700 {lab=VSS}
C {devices/lab_pin.sym} 1280 1700 0 1 {name=l122 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 1500 1700 0 0 {name=MU1pI L=0.28u W=20u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 1520 1670 1520 1650 {lab=IFIP}
C {devices/lab_pin.sym} 1520 1650 0 0 {name=l123 sig_type=std_logic lab=IFIP}
N 1480 1700 1460 1700 {lab=gl1p}
C {devices/lab_pin.sym} 1460 1700 0 0 {name=l124 sig_type=std_logic lab=gl1p}
N 1520 1730 1520 1750 {lab=mpaI}
C {devices/lab_pin.sym} 1520 1750 0 0 {name=l125 sig_type=std_logic lab=mpaI}
N 1520 1700 1540 1700 {lab=VSS}
C {devices/lab_pin.sym} 1540 1700 0 1 {name=l126 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 200 1900 0 0 {name=MU2pI L=0.28u W=20u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 1870 220 1850 {lab=IFIN}
C {devices/lab_pin.sym} 220 1850 0 0 {name=l127 sig_type=std_logic lab=IFIN}
N 180 1900 160 1900 {lab=gl1n}
C {devices/lab_pin.sym} 160 1900 0 0 {name=l128 sig_type=std_logic lab=gl1n}
N 220 1930 220 1950 {lab=mpaI}
C {devices/lab_pin.sym} 220 1950 0 0 {name=l129 sig_type=std_logic lab=mpaI}
N 220 1900 240 1900 {lab=VSS}
C {devices/lab_pin.sym} 240 1900 0 1 {name=l130 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 460 1900 0 0 {name=MU3pI L=0.28u W=20u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 480 1870 480 1850 {lab=IFIN}
C {devices/lab_pin.sym} 480 1850 0 0 {name=l131 sig_type=std_logic lab=IFIN}
N 440 1900 420 1900 {lab=gl1p}
C {devices/lab_pin.sym} 420 1900 0 0 {name=l132 sig_type=std_logic lab=gl1p}
N 480 1930 480 1950 {lab=mpbI}
C {devices/lab_pin.sym} 480 1950 0 0 {name=l133 sig_type=std_logic lab=mpbI}
N 480 1900 500 1900 {lab=VSS}
C {devices/lab_pin.sym} 500 1900 0 1 {name=l134 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 720 1900 0 0 {name=MU4pI L=0.28u W=20u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 740 1870 740 1850 {lab=IFIP}
C {devices/lab_pin.sym} 740 1850 0 0 {name=l135 sig_type=std_logic lab=IFIP}
N 700 1900 680 1900 {lab=gl1n}
C {devices/lab_pin.sym} 680 1900 0 0 {name=l136 sig_type=std_logic lab=gl1n}
N 740 1930 740 1950 {lab=mpbI}
C {devices/lab_pin.sym} 740 1950 0 0 {name=l137 sig_type=std_logic lab=mpbI}
N 740 1900 760 1900 {lab=VSS}
C {devices/lab_pin.sym} 760 1900 0 1 {name=l138 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 980 1900 0 0 {name=MLAnI L=0.28u W=40u nf=8 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 1000 1870 1000 1850 {lab=mnaI}
C {devices/lab_pin.sym} 1000 1850 0 0 {name=l139 sig_type=std_logic lab=mnaI}
N 960 1900 940 1900 {lab=gl3n}
C {devices/lab_pin.sym} 940 1900 0 0 {name=l140 sig_type=std_logic lab=gl3n}
N 1000 1930 1000 1950 {lab=xnI}
C {devices/lab_pin.sym} 1000 1950 0 0 {name=l141 sig_type=std_logic lab=xnI}
N 1000 1900 1020 1900 {lab=VSS}
C {devices/lab_pin.sym} 1020 1900 0 1 {name=l142 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 1240 1900 0 0 {name=MLBnI L=0.28u W=40u nf=8 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 1260 1870 1260 1850 {lab=mnbI}
C {devices/lab_pin.sym} 1260 1850 0 0 {name=l143 sig_type=std_logic lab=mnbI}
N 1220 1900 1200 1900 {lab=gl3p}
C {devices/lab_pin.sym} 1200 1900 0 0 {name=l144 sig_type=std_logic lab=gl3p}
N 1260 1930 1260 1950 {lab=xnI}
C {devices/lab_pin.sym} 1260 1950 0 0 {name=l145 sig_type=std_logic lab=xnI}
N 1260 1900 1280 1900 {lab=VSS}
C {devices/lab_pin.sym} 1280 1900 0 1 {name=l146 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 1500 1900 0 0 {name=MU1nI L=0.28u W=20u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 1520 1870 1520 1850 {lab=IFIN}
C {devices/lab_pin.sym} 1520 1850 0 0 {name=l147 sig_type=std_logic lab=IFIN}
N 1480 1900 1460 1900 {lab=gl1p}
C {devices/lab_pin.sym} 1460 1900 0 0 {name=l148 sig_type=std_logic lab=gl1p}
N 1520 1930 1520 1950 {lab=mnaI}
C {devices/lab_pin.sym} 1520 1950 0 0 {name=l149 sig_type=std_logic lab=mnaI}
N 1520 1900 1540 1900 {lab=VSS}
C {devices/lab_pin.sym} 1540 1900 0 1 {name=l150 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 200 2100 0 0 {name=MU2nI L=0.28u W=20u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 2070 220 2050 {lab=IFIP}
C {devices/lab_pin.sym} 220 2050 0 0 {name=l151 sig_type=std_logic lab=IFIP}
N 180 2100 160 2100 {lab=gl1n}
C {devices/lab_pin.sym} 160 2100 0 0 {name=l152 sig_type=std_logic lab=gl1n}
N 220 2130 220 2150 {lab=mnaI}
C {devices/lab_pin.sym} 220 2150 0 0 {name=l153 sig_type=std_logic lab=mnaI}
N 220 2100 240 2100 {lab=VSS}
C {devices/lab_pin.sym} 240 2100 0 1 {name=l154 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 460 2100 0 0 {name=MU3nI L=0.28u W=20u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 480 2070 480 2050 {lab=IFIP}
C {devices/lab_pin.sym} 480 2050 0 0 {name=l155 sig_type=std_logic lab=IFIP}
N 440 2100 420 2100 {lab=gl1p}
C {devices/lab_pin.sym} 420 2100 0 0 {name=l156 sig_type=std_logic lab=gl1p}
N 480 2130 480 2150 {lab=mnbI}
C {devices/lab_pin.sym} 480 2150 0 0 {name=l157 sig_type=std_logic lab=mnbI}
N 480 2100 500 2100 {lab=VSS}
C {devices/lab_pin.sym} 500 2100 0 1 {name=l158 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 720 2100 0 0 {name=MU4nI L=0.28u W=20u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 740 2070 740 2050 {lab=IFIN}
C {devices/lab_pin.sym} 740 2050 0 0 {name=l159 sig_type=std_logic lab=IFIN}
N 700 2100 680 2100 {lab=gl1n}
C {devices/lab_pin.sym} 680 2100 0 0 {name=l160 sig_type=std_logic lab=gl1n}
N 740 2130 740 2150 {lab=mnbI}
C {devices/lab_pin.sym} 740 2150 0 0 {name=l161 sig_type=std_logic lab=mnbI}
N 740 2100 760 2100 {lab=VSS}
C {devices/lab_pin.sym} 760 2100 0 1 {name=l162 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 980 2100 0 0 {name=RL1I W=4u L=5u model=ppolyf_u_1k spiceprefix=X m=1}
N 980 2130 980 2150 {lab=IFIP}
C {devices/lab_pin.sym} 980 2150 0 0 {name=l163 sig_type=std_logic lab=IFIP}
N 980 2070 980 2050 {lab=VDD}
C {devices/lab_pin.sym} 980 2050 0 0 {name=l164 sig_type=std_logic lab=VDD}
N 960 2100 940 2100 {lab=VSS}
C {devices/lab_pin.sym} 940 2100 0 0 {name=l165 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 1240 2100 0 0 {name=RL2I W=4u L=5u model=ppolyf_u_1k spiceprefix=X m=1}
N 1240 2130 1240 2150 {lab=IFIN}
C {devices/lab_pin.sym} 1240 2150 0 0 {name=l166 sig_type=std_logic lab=IFIN}
N 1240 2070 1240 2050 {lab=VDD}
C {devices/lab_pin.sym} 1240 2050 0 0 {name=l167 sig_type=std_logic lab=VDD}
N 1220 2100 1200 2100 {lab=VSS}
C {devices/lab_pin.sym} 1200 2100 0 0 {name=l168 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 1500 2100 0 0 {name=CL1I W=45e-6 L=45e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 1500 2070 1500 2050 {lab=IFIP}
C {devices/lab_pin.sym} 1500 2050 0 0 {name=l169 sig_type=std_logic lab=IFIP}
N 1500 2130 1500 2150 {lab=VSS}
C {devices/lab_pin.sym} 1500 2150 0 0 {name=l170 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 200 2300 0 0 {name=CL2I W=45e-6 L=45e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 200 2270 200 2250 {lab=IFIN}
C {devices/lab_pin.sym} 200 2250 0 0 {name=l171 sig_type=std_logic lab=IFIN}
N 200 2330 200 2350 {lab=VSS}
C {devices/lab_pin.sym} 200 2350 0 0 {name=l172 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 200 2500 0 0 {name=MTQ L=2u W=40u nf=4 m=16 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 2470 220 2450 {lab=tQ}
C {devices/lab_pin.sym} 220 2450 0 0 {name=l173 sig_type=std_logic lab=tQ}
N 180 2500 160 2500 {lab=NB}
C {devices/lab_pin.sym} 160 2500 0 0 {name=l174 sig_type=std_logic lab=NB}
N 220 2530 220 2550 {lab=VSS}
C {devices/lab_pin.sym} 220 2550 0 0 {name=l175 sig_type=std_logic lab=VSS}
N 220 2500 240 2500 {lab=VSS}
C {devices/lab_pin.sym} 240 2500 0 1 {name=l176 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 460 2500 0 0 {name=MG1Q L=0.28u W=80u nf=16 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 480 2470 480 2450 {lab=xpQ}
C {devices/lab_pin.sym} 480 2450 0 0 {name=l177 sig_type=std_logic lab=xpQ}
N 440 2500 420 2500 {lab=RFP}
C {devices/lab_pin.sym} 420 2500 0 0 {name=l178 sig_type=std_logic lab=RFP}
N 480 2530 480 2550 {lab=tQ}
C {devices/lab_pin.sym} 480 2550 0 0 {name=l179 sig_type=std_logic lab=tQ}
N 480 2500 500 2500 {lab=VSS}
C {devices/lab_pin.sym} 500 2500 0 1 {name=l180 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 720 2500 0 0 {name=MG2Q L=0.28u W=80u nf=16 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 740 2470 740 2450 {lab=xnQ}
C {devices/lab_pin.sym} 740 2450 0 0 {name=l181 sig_type=std_logic lab=xnQ}
N 700 2500 680 2500 {lab=RFN}
C {devices/lab_pin.sym} 680 2500 0 0 {name=l182 sig_type=std_logic lab=RFN}
N 740 2530 740 2550 {lab=tQ}
C {devices/lab_pin.sym} 740 2550 0 0 {name=l183 sig_type=std_logic lab=tQ}
N 740 2500 760 2500 {lab=VSS}
C {devices/lab_pin.sym} 760 2500 0 1 {name=l184 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 980 2500 0 0 {name=MLApQ L=0.28u W=40u nf=8 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 1000 2470 1000 2450 {lab=mpaQ}
C {devices/lab_pin.sym} 1000 2450 0 0 {name=l185 sig_type=std_logic lab=mpaQ}
N 960 2500 940 2500 {lab=gl4n}
C {devices/lab_pin.sym} 940 2500 0 0 {name=l186 sig_type=std_logic lab=gl4n}
N 1000 2530 1000 2550 {lab=xpQ}
C {devices/lab_pin.sym} 1000 2550 0 0 {name=l187 sig_type=std_logic lab=xpQ}
N 1000 2500 1020 2500 {lab=VSS}
C {devices/lab_pin.sym} 1020 2500 0 1 {name=l188 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 1240 2500 0 0 {name=MLBpQ L=0.28u W=40u nf=8 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 1260 2470 1260 2450 {lab=mpbQ}
C {devices/lab_pin.sym} 1260 2450 0 0 {name=l189 sig_type=std_logic lab=mpbQ}
N 1220 2500 1200 2500 {lab=gl4p}
C {devices/lab_pin.sym} 1200 2500 0 0 {name=l190 sig_type=std_logic lab=gl4p}
N 1260 2530 1260 2550 {lab=xpQ}
C {devices/lab_pin.sym} 1260 2550 0 0 {name=l191 sig_type=std_logic lab=xpQ}
N 1260 2500 1280 2500 {lab=VSS}
C {devices/lab_pin.sym} 1280 2500 0 1 {name=l192 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 1500 2500 0 0 {name=MU1pQ L=0.28u W=20u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 1520 2470 1520 2450 {lab=IFQP}
C {devices/lab_pin.sym} 1520 2450 0 0 {name=l193 sig_type=std_logic lab=IFQP}
N 1480 2500 1460 2500 {lab=gl2p}
C {devices/lab_pin.sym} 1460 2500 0 0 {name=l194 sig_type=std_logic lab=gl2p}
N 1520 2530 1520 2550 {lab=mpaQ}
C {devices/lab_pin.sym} 1520 2550 0 0 {name=l195 sig_type=std_logic lab=mpaQ}
N 1520 2500 1540 2500 {lab=VSS}
C {devices/lab_pin.sym} 1540 2500 0 1 {name=l196 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 200 2700 0 0 {name=MU2pQ L=0.28u W=20u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 2670 220 2650 {lab=IFQN}
C {devices/lab_pin.sym} 220 2650 0 0 {name=l197 sig_type=std_logic lab=IFQN}
N 180 2700 160 2700 {lab=gl2n}
C {devices/lab_pin.sym} 160 2700 0 0 {name=l198 sig_type=std_logic lab=gl2n}
N 220 2730 220 2750 {lab=mpaQ}
C {devices/lab_pin.sym} 220 2750 0 0 {name=l199 sig_type=std_logic lab=mpaQ}
N 220 2700 240 2700 {lab=VSS}
C {devices/lab_pin.sym} 240 2700 0 1 {name=l200 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 460 2700 0 0 {name=MU3pQ L=0.28u W=20u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 480 2670 480 2650 {lab=IFQN}
C {devices/lab_pin.sym} 480 2650 0 0 {name=l201 sig_type=std_logic lab=IFQN}
N 440 2700 420 2700 {lab=gl2p}
C {devices/lab_pin.sym} 420 2700 0 0 {name=l202 sig_type=std_logic lab=gl2p}
N 480 2730 480 2750 {lab=mpbQ}
C {devices/lab_pin.sym} 480 2750 0 0 {name=l203 sig_type=std_logic lab=mpbQ}
N 480 2700 500 2700 {lab=VSS}
C {devices/lab_pin.sym} 500 2700 0 1 {name=l204 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 720 2700 0 0 {name=MU4pQ L=0.28u W=20u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 740 2670 740 2650 {lab=IFQP}
C {devices/lab_pin.sym} 740 2650 0 0 {name=l205 sig_type=std_logic lab=IFQP}
N 700 2700 680 2700 {lab=gl2n}
C {devices/lab_pin.sym} 680 2700 0 0 {name=l206 sig_type=std_logic lab=gl2n}
N 740 2730 740 2750 {lab=mpbQ}
C {devices/lab_pin.sym} 740 2750 0 0 {name=l207 sig_type=std_logic lab=mpbQ}
N 740 2700 760 2700 {lab=VSS}
C {devices/lab_pin.sym} 760 2700 0 1 {name=l208 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 980 2700 0 0 {name=MLAnQ L=0.28u W=40u nf=8 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 1000 2670 1000 2650 {lab=mnaQ}
C {devices/lab_pin.sym} 1000 2650 0 0 {name=l209 sig_type=std_logic lab=mnaQ}
N 960 2700 940 2700 {lab=gl4n}
C {devices/lab_pin.sym} 940 2700 0 0 {name=l210 sig_type=std_logic lab=gl4n}
N 1000 2730 1000 2750 {lab=xnQ}
C {devices/lab_pin.sym} 1000 2750 0 0 {name=l211 sig_type=std_logic lab=xnQ}
N 1000 2700 1020 2700 {lab=VSS}
C {devices/lab_pin.sym} 1020 2700 0 1 {name=l212 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 1240 2700 0 0 {name=MLBnQ L=0.28u W=40u nf=8 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 1260 2670 1260 2650 {lab=mnbQ}
C {devices/lab_pin.sym} 1260 2650 0 0 {name=l213 sig_type=std_logic lab=mnbQ}
N 1220 2700 1200 2700 {lab=gl4p}
C {devices/lab_pin.sym} 1200 2700 0 0 {name=l214 sig_type=std_logic lab=gl4p}
N 1260 2730 1260 2750 {lab=xnQ}
C {devices/lab_pin.sym} 1260 2750 0 0 {name=l215 sig_type=std_logic lab=xnQ}
N 1260 2700 1280 2700 {lab=VSS}
C {devices/lab_pin.sym} 1280 2700 0 1 {name=l216 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 1500 2700 0 0 {name=MU1nQ L=0.28u W=20u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 1520 2670 1520 2650 {lab=IFQN}
C {devices/lab_pin.sym} 1520 2650 0 0 {name=l217 sig_type=std_logic lab=IFQN}
N 1480 2700 1460 2700 {lab=gl2p}
C {devices/lab_pin.sym} 1460 2700 0 0 {name=l218 sig_type=std_logic lab=gl2p}
N 1520 2730 1520 2750 {lab=mnaQ}
C {devices/lab_pin.sym} 1520 2750 0 0 {name=l219 sig_type=std_logic lab=mnaQ}
N 1520 2700 1540 2700 {lab=VSS}
C {devices/lab_pin.sym} 1540 2700 0 1 {name=l220 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 200 2900 0 0 {name=MU2nQ L=0.28u W=20u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 2870 220 2850 {lab=IFQP}
C {devices/lab_pin.sym} 220 2850 0 0 {name=l221 sig_type=std_logic lab=IFQP}
N 180 2900 160 2900 {lab=gl2n}
C {devices/lab_pin.sym} 160 2900 0 0 {name=l222 sig_type=std_logic lab=gl2n}
N 220 2930 220 2950 {lab=mnaQ}
C {devices/lab_pin.sym} 220 2950 0 0 {name=l223 sig_type=std_logic lab=mnaQ}
N 220 2900 240 2900 {lab=VSS}
C {devices/lab_pin.sym} 240 2900 0 1 {name=l224 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 460 2900 0 0 {name=MU3nQ L=0.28u W=20u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 480 2870 480 2850 {lab=IFQP}
C {devices/lab_pin.sym} 480 2850 0 0 {name=l225 sig_type=std_logic lab=IFQP}
N 440 2900 420 2900 {lab=gl2p}
C {devices/lab_pin.sym} 420 2900 0 0 {name=l226 sig_type=std_logic lab=gl2p}
N 480 2930 480 2950 {lab=mnbQ}
C {devices/lab_pin.sym} 480 2950 0 0 {name=l227 sig_type=std_logic lab=mnbQ}
N 480 2900 500 2900 {lab=VSS}
C {devices/lab_pin.sym} 500 2900 0 1 {name=l228 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 720 2900 0 0 {name=MU4nQ L=0.28u W=20u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 740 2870 740 2850 {lab=IFQN}
C {devices/lab_pin.sym} 740 2850 0 0 {name=l229 sig_type=std_logic lab=IFQN}
N 700 2900 680 2900 {lab=gl2n}
C {devices/lab_pin.sym} 680 2900 0 0 {name=l230 sig_type=std_logic lab=gl2n}
N 740 2930 740 2950 {lab=mnbQ}
C {devices/lab_pin.sym} 740 2950 0 0 {name=l231 sig_type=std_logic lab=mnbQ}
N 740 2900 760 2900 {lab=VSS}
C {devices/lab_pin.sym} 760 2900 0 1 {name=l232 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 980 2900 0 0 {name=RL1Q W=4u L=5u model=ppolyf_u_1k spiceprefix=X m=1}
N 980 2930 980 2950 {lab=IFQP}
C {devices/lab_pin.sym} 980 2950 0 0 {name=l233 sig_type=std_logic lab=IFQP}
N 980 2870 980 2850 {lab=VDD}
C {devices/lab_pin.sym} 980 2850 0 0 {name=l234 sig_type=std_logic lab=VDD}
N 960 2900 940 2900 {lab=VSS}
C {devices/lab_pin.sym} 940 2900 0 0 {name=l235 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 1240 2900 0 0 {name=RL2Q W=4u L=5u model=ppolyf_u_1k spiceprefix=X m=1}
N 1240 2930 1240 2950 {lab=IFQN}
C {devices/lab_pin.sym} 1240 2950 0 0 {name=l236 sig_type=std_logic lab=IFQN}
N 1240 2870 1240 2850 {lab=VDD}
C {devices/lab_pin.sym} 1240 2850 0 0 {name=l237 sig_type=std_logic lab=VDD}
N 1220 2900 1200 2900 {lab=VSS}
C {devices/lab_pin.sym} 1200 2900 0 0 {name=l238 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 1500 2900 0 0 {name=CL1Q W=45e-6 L=45e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 1500 2870 1500 2850 {lab=IFQP}
C {devices/lab_pin.sym} 1500 2850 0 0 {name=l239 sig_type=std_logic lab=IFQP}
N 1500 2930 1500 2950 {lab=VSS}
C {devices/lab_pin.sym} 1500 2950 0 0 {name=l240 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 200 3100 0 0 {name=CL2Q W=45e-6 L=45e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 200 3070 200 3050 {lab=IFQN}
C {devices/lab_pin.sym} 200 3050 0 0 {name=l241 sig_type=std_logic lab=IFQN}
N 200 3130 200 3150 {lab=VSS}
C {devices/lab_pin.sym} 200 3150 0 0 {name=l242 sig_type=std_logic lab=VSS}
C {devices/title.sym} 160 3600 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
