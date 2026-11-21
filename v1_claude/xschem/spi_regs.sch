v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {SPI register: 24 bit, mode 0, MSB first; POR defaults: gain min, band 00, AFC mid scale, Icp x1} 100 80 0 0 0.6 0.6 {}
T {CS_N pull-up, clock gating, power-on reset (RC 200k x 10p)} 100 190 0 0 0.4 0.4 {layer=8}
T {shift register stages 0-3} 100 590 0 0 0.4 0.4 {layer=8}
T {shift register stages 4-7} 100 790 0 0 0.4 0.4 {layer=8}
T {shift register stages 8-11} 100 990 0 0 0.4 0.4 {layer=8}
T {shift register stages 12-15} 100 1190 0 0 0.4 0.4 {layer=8}
T {shift register stages 16-19} 100 1390 0 0 0.4 0.4 {layer=8}
T {shift register stages 20-23} 100 1590 0 0 0.4 0.4 {layer=8}
T {output latches (after 16 clocks shift stage i holds frame bit i; MSB sent first)} 100 1790 0 0 0.4 0.4 {layer=8}
C {devices/ipin.sym} -100 300 0 0 {name=p0 lab=SCLK}
C {devices/ipin.sym} -100 330 0 0 {name=p1 lab=SDI}
C {devices/ipin.sym} -100 360 0 0 {name=p2 lab=CS_N}
C {devices/opin.sym} -100 390 0 0 {name=p3 lab=IG1A}
C {devices/opin.sym} -100 420 0 0 {name=p4 lab=IG1B}
C {devices/opin.sym} -100 450 0 0 {name=p5 lab=IG2A}
C {devices/opin.sym} -100 480 0 0 {name=p6 lab=IG2B}
C {devices/opin.sym} -100 510 0 0 {name=p7 lab=IG3A}
C {devices/opin.sym} -100 540 0 0 {name=p8 lab=IG3B}
C {devices/opin.sym} -100 570 0 0 {name=p9 lab=B0}
C {devices/opin.sym} -100 600 0 0 {name=p10 lab=B1}
C {devices/opin.sym} -100 630 0 0 {name=p11 lab=AFC0}
C {devices/opin.sym} -100 660 0 0 {name=p12 lab=AFC1}
C {devices/opin.sym} -100 690 0 0 {name=p13 lab=AFC2}
C {devices/opin.sym} -100 720 0 0 {name=p14 lab=AFC3}
C {devices/opin.sym} -100 750 0 0 {name=p15 lab=AFC4}
C {devices/opin.sym} -100 780 0 0 {name=p16 lab=AFC5}
C {devices/opin.sym} -100 810 0 0 {name=p17 lab=AFC6}
C {devices/opin.sym} -100 840 0 0 {name=p18 lab=AFC7}
C {devices/opin.sym} -100 870 0 0 {name=p19 lab=ICP2}
C {devices/opin.sym} -100 900 0 0 {name=p20 lab=BWW}
C {devices/opin.sym} -100 930 0 0 {name=p21 lab=BWN}
C {devices/iopin.sym} -100 960 0 0 {name=p22 lab=VDD}
C {devices/iopin.sym} -100 990 0 0 {name=p23 lab=VSS}
C {symbols/ppolyf_u_1k.sym} 200 300 0 0 {name=RPU W=1u L=100u model=ppolyf_u_1k spiceprefix=X m=1}
N 200 330 200 350 {lab=CS_N}
C {devices/lab_pin.sym} 200 350 0 0 {name=l1 sig_type=std_logic lab=CS_N}
N 200 270 200 250 {lab=VDD}
C {devices/lab_pin.sym} 200 250 0 0 {name=l2 sig_type=std_logic lab=VDD}
N 180 300 160 300 {lab=VSS}
C {devices/lab_pin.sym} 160 300 0 0 {name=l3 sig_type=std_logic lab=VSS}
C {inv_dig.sym} 500 300 0 0 {name=XSCB }
N 400 280 380 280 {lab=SCLK}
C {devices/lab_pin.sym} 380 280 0 0 {name=l4 sig_type=std_logic lab=SCLK}
N 600 280 620 280 {lab=sclkb}
C {devices/lab_pin.sym} 620 280 0 1 {name=l5 sig_type=std_logic lab=sclkb}
N 600 300 620 300 {lab=VDD}
C {devices/lab_pin.sym} 620 300 0 1 {name=l6 sig_type=std_logic lab=VDD}
N 600 320 620 320 {lab=VSS}
C {devices/lab_pin.sym} 620 320 0 1 {name=l7 sig_type=std_logic lab=VSS}
C {nor2.sym} 800 300 0 0 {name=XSCG }
N 700 280 680 280 {lab=CS_N}
C {devices/lab_pin.sym} 680 280 0 0 {name=l8 sig_type=std_logic lab=CS_N}
N 700 300 680 300 {lab=sclkb}
C {devices/lab_pin.sym} 680 300 0 0 {name=l9 sig_type=std_logic lab=sclkb}
N 900 280 920 280 {lab=sck}
C {devices/lab_pin.sym} 920 280 0 1 {name=l10 sig_type=std_logic lab=sck}
N 900 300 920 300 {lab=VDD}
C {devices/lab_pin.sym} 920 300 0 1 {name=l11 sig_type=std_logic lab=VDD}
N 900 320 920 320 {lab=VSS}
C {devices/lab_pin.sym} 920 320 0 1 {name=l12 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 1100 300 0 0 {name=RPOR W=1u L=200u model=ppolyf_u_1k spiceprefix=X m=1}
N 1100 330 1100 350 {lab=pr}
C {devices/lab_pin.sym} 1100 350 0 0 {name=l13 sig_type=std_logic lab=pr}
N 1100 270 1100 250 {lab=VDD}
C {devices/lab_pin.sym} 1100 250 0 0 {name=l14 sig_type=std_logic lab=VDD}
N 1080 300 1060 300 {lab=VSS}
C {devices/lab_pin.sym} 1060 300 0 0 {name=l15 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 200 500 0 0 {name=CPOR W=70e-6 L=70e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 200 470 200 450 {lab=pr}
C {devices/lab_pin.sym} 200 450 0 0 {name=l16 sig_type=std_logic lab=pr}
N 200 530 200 550 {lab=VSS}
C {devices/lab_pin.sym} 200 550 0 0 {name=l17 sig_type=std_logic lab=VSS}
C {inv_dig.sym} 500 500 0 0 {name=XP1 }
N 400 480 380 480 {lab=pr}
C {devices/lab_pin.sym} 380 480 0 0 {name=l18 sig_type=std_logic lab=pr}
N 600 480 620 480 {lab=por1}
C {devices/lab_pin.sym} 620 480 0 1 {name=l19 sig_type=std_logic lab=por1}
N 600 500 620 500 {lab=VDD}
C {devices/lab_pin.sym} 620 500 0 1 {name=l20 sig_type=std_logic lab=VDD}
N 600 520 620 520 {lab=VSS}
C {devices/lab_pin.sym} 620 520 0 1 {name=l21 sig_type=std_logic lab=VSS}
C {inv_dig.sym} 800 500 0 0 {name=XP2 }
N 700 480 680 480 {lab=por1}
C {devices/lab_pin.sym} 680 480 0 0 {name=l22 sig_type=std_logic lab=por1}
N 900 480 920 480 {lab=por2}
C {devices/lab_pin.sym} 920 480 0 1 {name=l23 sig_type=std_logic lab=por2}
N 900 500 920 500 {lab=VDD}
C {devices/lab_pin.sym} 920 500 0 1 {name=l24 sig_type=std_logic lab=VDD}
N 900 520 920 520 {lab=VSS}
C {devices/lab_pin.sym} 920 520 0 1 {name=l25 sig_type=std_logic lab=VSS}
C {inv_dig.sym} 1100 500 0 0 {name=XP3 }
N 1000 480 980 480 {lab=por2}
C {devices/lab_pin.sym} 980 480 0 0 {name=l26 sig_type=std_logic lab=por2}
N 1200 480 1220 480 {lab=rst}
C {devices/lab_pin.sym} 1220 480 0 1 {name=l27 sig_type=std_logic lab=rst}
N 1200 500 1220 500 {lab=VDD}
C {devices/lab_pin.sym} 1220 500 0 1 {name=l28 sig_type=std_logic lab=VDD}
N 1200 520 1220 520 {lab=VSS}
C {devices/lab_pin.sym} 1220 520 0 1 {name=l29 sig_type=std_logic lab=VSS}
C {dffr_s.sym} 200 700 0 0 {name=XR0 }
N 100 680 80 680 {lab=SDI}
C {devices/lab_pin.sym} 80 680 0 0 {name=l30 sig_type=std_logic lab=SDI}
N 100 700 80 700 {lab=sck}
C {devices/lab_pin.sym} 80 700 0 0 {name=l31 sig_type=std_logic lab=sck}
N 100 720 80 720 {lab=rst}
C {devices/lab_pin.sym} 80 720 0 0 {name=l32 sig_type=std_logic lab=rst}
N 300 680 320 680 {lab=r0}
C {devices/lab_pin.sym} 320 680 0 1 {name=l33 sig_type=std_logic lab=r0}
N 300 700 320 700 {lab=VDD}
C {devices/lab_pin.sym} 320 700 0 1 {name=l34 sig_type=std_logic lab=VDD}
N 300 720 320 720 {lab=VSS}
C {devices/lab_pin.sym} 320 720 0 1 {name=l35 sig_type=std_logic lab=VSS}
C {dffr_s.sym} 500 700 0 0 {name=XR1 }
N 400 680 380 680 {lab=r0}
C {devices/lab_pin.sym} 380 680 0 0 {name=l36 sig_type=std_logic lab=r0}
N 400 700 380 700 {lab=sck}
C {devices/lab_pin.sym} 380 700 0 0 {name=l37 sig_type=std_logic lab=sck}
N 400 720 380 720 {lab=rst}
C {devices/lab_pin.sym} 380 720 0 0 {name=l38 sig_type=std_logic lab=rst}
N 600 680 620 680 {lab=r1}
C {devices/lab_pin.sym} 620 680 0 1 {name=l39 sig_type=std_logic lab=r1}
N 600 700 620 700 {lab=VDD}
C {devices/lab_pin.sym} 620 700 0 1 {name=l40 sig_type=std_logic lab=VDD}
N 600 720 620 720 {lab=VSS}
C {devices/lab_pin.sym} 620 720 0 1 {name=l41 sig_type=std_logic lab=VSS}
C {dffr_s.sym} 800 700 0 0 {name=XR2 }
N 700 680 680 680 {lab=r1}
C {devices/lab_pin.sym} 680 680 0 0 {name=l42 sig_type=std_logic lab=r1}
N 700 700 680 700 {lab=sck}
C {devices/lab_pin.sym} 680 700 0 0 {name=l43 sig_type=std_logic lab=sck}
N 700 720 680 720 {lab=rst}
C {devices/lab_pin.sym} 680 720 0 0 {name=l44 sig_type=std_logic lab=rst}
N 900 680 920 680 {lab=r2}
C {devices/lab_pin.sym} 920 680 0 1 {name=l45 sig_type=std_logic lab=r2}
N 900 700 920 700 {lab=VDD}
C {devices/lab_pin.sym} 920 700 0 1 {name=l46 sig_type=std_logic lab=VDD}
N 900 720 920 720 {lab=VSS}
C {devices/lab_pin.sym} 920 720 0 1 {name=l47 sig_type=std_logic lab=VSS}
C {dffr_s.sym} 1100 700 0 0 {name=XR3 }
N 1000 680 980 680 {lab=r2}
C {devices/lab_pin.sym} 980 680 0 0 {name=l48 sig_type=std_logic lab=r2}
N 1000 700 980 700 {lab=sck}
C {devices/lab_pin.sym} 980 700 0 0 {name=l49 sig_type=std_logic lab=sck}
N 1000 720 980 720 {lab=rst}
C {devices/lab_pin.sym} 980 720 0 0 {name=l50 sig_type=std_logic lab=rst}
N 1200 680 1220 680 {lab=r3}
C {devices/lab_pin.sym} 1220 680 0 1 {name=l51 sig_type=std_logic lab=r3}
N 1200 700 1220 700 {lab=VDD}
C {devices/lab_pin.sym} 1220 700 0 1 {name=l52 sig_type=std_logic lab=VDD}
N 1200 720 1220 720 {lab=VSS}
C {devices/lab_pin.sym} 1220 720 0 1 {name=l53 sig_type=std_logic lab=VSS}
C {dffr_s.sym} 200 900 0 0 {name=XR4 }
N 100 880 80 880 {lab=r3}
C {devices/lab_pin.sym} 80 880 0 0 {name=l54 sig_type=std_logic lab=r3}
N 100 900 80 900 {lab=sck}
C {devices/lab_pin.sym} 80 900 0 0 {name=l55 sig_type=std_logic lab=sck}
N 100 920 80 920 {lab=rst}
C {devices/lab_pin.sym} 80 920 0 0 {name=l56 sig_type=std_logic lab=rst}
N 300 880 320 880 {lab=r4}
C {devices/lab_pin.sym} 320 880 0 1 {name=l57 sig_type=std_logic lab=r4}
N 300 900 320 900 {lab=VDD}
C {devices/lab_pin.sym} 320 900 0 1 {name=l58 sig_type=std_logic lab=VDD}
N 300 920 320 920 {lab=VSS}
C {devices/lab_pin.sym} 320 920 0 1 {name=l59 sig_type=std_logic lab=VSS}
C {dffr_s.sym} 500 900 0 0 {name=XR5 }
N 400 880 380 880 {lab=r4}
C {devices/lab_pin.sym} 380 880 0 0 {name=l60 sig_type=std_logic lab=r4}
N 400 900 380 900 {lab=sck}
C {devices/lab_pin.sym} 380 900 0 0 {name=l61 sig_type=std_logic lab=sck}
N 400 920 380 920 {lab=rst}
C {devices/lab_pin.sym} 380 920 0 0 {name=l62 sig_type=std_logic lab=rst}
N 600 880 620 880 {lab=r5}
C {devices/lab_pin.sym} 620 880 0 1 {name=l63 sig_type=std_logic lab=r5}
N 600 900 620 900 {lab=VDD}
C {devices/lab_pin.sym} 620 900 0 1 {name=l64 sig_type=std_logic lab=VDD}
N 600 920 620 920 {lab=VSS}
C {devices/lab_pin.sym} 620 920 0 1 {name=l65 sig_type=std_logic lab=VSS}
C {dffr_s.sym} 800 900 0 0 {name=XR6 }
N 700 880 680 880 {lab=r5}
C {devices/lab_pin.sym} 680 880 0 0 {name=l66 sig_type=std_logic lab=r5}
N 700 900 680 900 {lab=sck}
C {devices/lab_pin.sym} 680 900 0 0 {name=l67 sig_type=std_logic lab=sck}
N 700 920 680 920 {lab=rst}
C {devices/lab_pin.sym} 680 920 0 0 {name=l68 sig_type=std_logic lab=rst}
N 900 880 920 880 {lab=r6}
C {devices/lab_pin.sym} 920 880 0 1 {name=l69 sig_type=std_logic lab=r6}
N 900 900 920 900 {lab=VDD}
C {devices/lab_pin.sym} 920 900 0 1 {name=l70 sig_type=std_logic lab=VDD}
N 900 920 920 920 {lab=VSS}
C {devices/lab_pin.sym} 920 920 0 1 {name=l71 sig_type=std_logic lab=VSS}
C {dffr_s.sym} 1100 900 0 0 {name=XR7 }
N 1000 880 980 880 {lab=r6}
C {devices/lab_pin.sym} 980 880 0 0 {name=l72 sig_type=std_logic lab=r6}
N 1000 900 980 900 {lab=sck}
C {devices/lab_pin.sym} 980 900 0 0 {name=l73 sig_type=std_logic lab=sck}
N 1000 920 980 920 {lab=rst}
C {devices/lab_pin.sym} 980 920 0 0 {name=l74 sig_type=std_logic lab=rst}
N 1200 880 1220 880 {lab=r7}
C {devices/lab_pin.sym} 1220 880 0 1 {name=l75 sig_type=std_logic lab=r7}
N 1200 900 1220 900 {lab=VDD}
C {devices/lab_pin.sym} 1220 900 0 1 {name=l76 sig_type=std_logic lab=VDD}
N 1200 920 1220 920 {lab=VSS}
C {devices/lab_pin.sym} 1220 920 0 1 {name=l77 sig_type=std_logic lab=VSS}
C {dffr_s.sym} 200 1100 0 0 {name=XR8 }
N 100 1080 80 1080 {lab=r7}
C {devices/lab_pin.sym} 80 1080 0 0 {name=l78 sig_type=std_logic lab=r7}
N 100 1100 80 1100 {lab=sck}
C {devices/lab_pin.sym} 80 1100 0 0 {name=l79 sig_type=std_logic lab=sck}
N 100 1120 80 1120 {lab=rst}
C {devices/lab_pin.sym} 80 1120 0 0 {name=l80 sig_type=std_logic lab=rst}
N 300 1080 320 1080 {lab=r8}
C {devices/lab_pin.sym} 320 1080 0 1 {name=l81 sig_type=std_logic lab=r8}
N 300 1100 320 1100 {lab=VDD}
C {devices/lab_pin.sym} 320 1100 0 1 {name=l82 sig_type=std_logic lab=VDD}
N 300 1120 320 1120 {lab=VSS}
C {devices/lab_pin.sym} 320 1120 0 1 {name=l83 sig_type=std_logic lab=VSS}
C {dffr_s.sym} 500 1100 0 0 {name=XR9 }
N 400 1080 380 1080 {lab=r8}
C {devices/lab_pin.sym} 380 1080 0 0 {name=l84 sig_type=std_logic lab=r8}
N 400 1100 380 1100 {lab=sck}
C {devices/lab_pin.sym} 380 1100 0 0 {name=l85 sig_type=std_logic lab=sck}
N 400 1120 380 1120 {lab=rst}
C {devices/lab_pin.sym} 380 1120 0 0 {name=l86 sig_type=std_logic lab=rst}
N 600 1080 620 1080 {lab=r9}
C {devices/lab_pin.sym} 620 1080 0 1 {name=l87 sig_type=std_logic lab=r9}
N 600 1100 620 1100 {lab=VDD}
C {devices/lab_pin.sym} 620 1100 0 1 {name=l88 sig_type=std_logic lab=VDD}
N 600 1120 620 1120 {lab=VSS}
C {devices/lab_pin.sym} 620 1120 0 1 {name=l89 sig_type=std_logic lab=VSS}
C {dffr_s.sym} 800 1100 0 0 {name=XR10 }
N 700 1080 680 1080 {lab=r9}
C {devices/lab_pin.sym} 680 1080 0 0 {name=l90 sig_type=std_logic lab=r9}
N 700 1100 680 1100 {lab=sck}
C {devices/lab_pin.sym} 680 1100 0 0 {name=l91 sig_type=std_logic lab=sck}
N 700 1120 680 1120 {lab=rst}
C {devices/lab_pin.sym} 680 1120 0 0 {name=l92 sig_type=std_logic lab=rst}
N 900 1080 920 1080 {lab=r10}
C {devices/lab_pin.sym} 920 1080 0 1 {name=l93 sig_type=std_logic lab=r10}
N 900 1100 920 1100 {lab=VDD}
C {devices/lab_pin.sym} 920 1100 0 1 {name=l94 sig_type=std_logic lab=VDD}
N 900 1120 920 1120 {lab=VSS}
C {devices/lab_pin.sym} 920 1120 0 1 {name=l95 sig_type=std_logic lab=VSS}
C {dffr_s.sym} 1100 1100 0 0 {name=XR11 }
N 1000 1080 980 1080 {lab=r10}
C {devices/lab_pin.sym} 980 1080 0 0 {name=l96 sig_type=std_logic lab=r10}
N 1000 1100 980 1100 {lab=sck}
C {devices/lab_pin.sym} 980 1100 0 0 {name=l97 sig_type=std_logic lab=sck}
N 1000 1120 980 1120 {lab=rst}
C {devices/lab_pin.sym} 980 1120 0 0 {name=l98 sig_type=std_logic lab=rst}
N 1200 1080 1220 1080 {lab=r11}
C {devices/lab_pin.sym} 1220 1080 0 1 {name=l99 sig_type=std_logic lab=r11}
N 1200 1100 1220 1100 {lab=VDD}
C {devices/lab_pin.sym} 1220 1100 0 1 {name=l100 sig_type=std_logic lab=VDD}
N 1200 1120 1220 1120 {lab=VSS}
C {devices/lab_pin.sym} 1220 1120 0 1 {name=l101 sig_type=std_logic lab=VSS}
C {dffr_s.sym} 200 1300 0 0 {name=XR12 }
N 100 1280 80 1280 {lab=r11}
C {devices/lab_pin.sym} 80 1280 0 0 {name=l102 sig_type=std_logic lab=r11}
N 100 1300 80 1300 {lab=sck}
C {devices/lab_pin.sym} 80 1300 0 0 {name=l103 sig_type=std_logic lab=sck}
N 100 1320 80 1320 {lab=rst}
C {devices/lab_pin.sym} 80 1320 0 0 {name=l104 sig_type=std_logic lab=rst}
N 300 1280 320 1280 {lab=r12}
C {devices/lab_pin.sym} 320 1280 0 1 {name=l105 sig_type=std_logic lab=r12}
N 300 1300 320 1300 {lab=VDD}
C {devices/lab_pin.sym} 320 1300 0 1 {name=l106 sig_type=std_logic lab=VDD}
N 300 1320 320 1320 {lab=VSS}
C {devices/lab_pin.sym} 320 1320 0 1 {name=l107 sig_type=std_logic lab=VSS}
C {dffr_s.sym} 500 1300 0 0 {name=XR13 }
N 400 1280 380 1280 {lab=r12}
C {devices/lab_pin.sym} 380 1280 0 0 {name=l108 sig_type=std_logic lab=r12}
N 400 1300 380 1300 {lab=sck}
C {devices/lab_pin.sym} 380 1300 0 0 {name=l109 sig_type=std_logic lab=sck}
N 400 1320 380 1320 {lab=rst}
C {devices/lab_pin.sym} 380 1320 0 0 {name=l110 sig_type=std_logic lab=rst}
N 600 1280 620 1280 {lab=r13}
C {devices/lab_pin.sym} 620 1280 0 1 {name=l111 sig_type=std_logic lab=r13}
N 600 1300 620 1300 {lab=VDD}
C {devices/lab_pin.sym} 620 1300 0 1 {name=l112 sig_type=std_logic lab=VDD}
N 600 1320 620 1320 {lab=VSS}
C {devices/lab_pin.sym} 620 1320 0 1 {name=l113 sig_type=std_logic lab=VSS}
C {dffr_s.sym} 800 1300 0 0 {name=XR14 }
N 700 1280 680 1280 {lab=r13}
C {devices/lab_pin.sym} 680 1280 0 0 {name=l114 sig_type=std_logic lab=r13}
N 700 1300 680 1300 {lab=sck}
C {devices/lab_pin.sym} 680 1300 0 0 {name=l115 sig_type=std_logic lab=sck}
N 700 1320 680 1320 {lab=rst}
C {devices/lab_pin.sym} 680 1320 0 0 {name=l116 sig_type=std_logic lab=rst}
N 900 1280 920 1280 {lab=r14}
C {devices/lab_pin.sym} 920 1280 0 1 {name=l117 sig_type=std_logic lab=r14}
N 900 1300 920 1300 {lab=VDD}
C {devices/lab_pin.sym} 920 1300 0 1 {name=l118 sig_type=std_logic lab=VDD}
N 900 1320 920 1320 {lab=VSS}
C {devices/lab_pin.sym} 920 1320 0 1 {name=l119 sig_type=std_logic lab=VSS}
C {dffr_s.sym} 1100 1300 0 0 {name=XR15 }
N 1000 1280 980 1280 {lab=r14}
C {devices/lab_pin.sym} 980 1280 0 0 {name=l120 sig_type=std_logic lab=r14}
N 1000 1300 980 1300 {lab=sck}
C {devices/lab_pin.sym} 980 1300 0 0 {name=l121 sig_type=std_logic lab=sck}
N 1000 1320 980 1320 {lab=rst}
C {devices/lab_pin.sym} 980 1320 0 0 {name=l122 sig_type=std_logic lab=rst}
N 1200 1280 1220 1280 {lab=r15}
C {devices/lab_pin.sym} 1220 1280 0 1 {name=l123 sig_type=std_logic lab=r15}
N 1200 1300 1220 1300 {lab=VDD}
C {devices/lab_pin.sym} 1220 1300 0 1 {name=l124 sig_type=std_logic lab=VDD}
N 1200 1320 1220 1320 {lab=VSS}
C {devices/lab_pin.sym} 1220 1320 0 1 {name=l125 sig_type=std_logic lab=VSS}
C {dffr_s.sym} 200 1500 0 0 {name=XR16 }
N 100 1480 80 1480 {lab=r15}
C {devices/lab_pin.sym} 80 1480 0 0 {name=l126 sig_type=std_logic lab=r15}
N 100 1500 80 1500 {lab=sck}
C {devices/lab_pin.sym} 80 1500 0 0 {name=l127 sig_type=std_logic lab=sck}
N 100 1520 80 1520 {lab=rst}
C {devices/lab_pin.sym} 80 1520 0 0 {name=l128 sig_type=std_logic lab=rst}
N 300 1480 320 1480 {lab=r16}
C {devices/lab_pin.sym} 320 1480 0 1 {name=l129 sig_type=std_logic lab=r16}
N 300 1500 320 1500 {lab=VDD}
C {devices/lab_pin.sym} 320 1500 0 1 {name=l130 sig_type=std_logic lab=VDD}
N 300 1520 320 1520 {lab=VSS}
C {devices/lab_pin.sym} 320 1520 0 1 {name=l131 sig_type=std_logic lab=VSS}
C {dffr_s.sym} 500 1500 0 0 {name=XR17 }
N 400 1480 380 1480 {lab=r16}
C {devices/lab_pin.sym} 380 1480 0 0 {name=l132 sig_type=std_logic lab=r16}
N 400 1500 380 1500 {lab=sck}
C {devices/lab_pin.sym} 380 1500 0 0 {name=l133 sig_type=std_logic lab=sck}
N 400 1520 380 1520 {lab=rst}
C {devices/lab_pin.sym} 380 1520 0 0 {name=l134 sig_type=std_logic lab=rst}
N 600 1480 620 1480 {lab=r17}
C {devices/lab_pin.sym} 620 1480 0 1 {name=l135 sig_type=std_logic lab=r17}
N 600 1500 620 1500 {lab=VDD}
C {devices/lab_pin.sym} 620 1500 0 1 {name=l136 sig_type=std_logic lab=VDD}
N 600 1520 620 1520 {lab=VSS}
C {devices/lab_pin.sym} 620 1520 0 1 {name=l137 sig_type=std_logic lab=VSS}
C {dffr_s.sym} 800 1500 0 0 {name=XR18 }
N 700 1480 680 1480 {lab=r17}
C {devices/lab_pin.sym} 680 1480 0 0 {name=l138 sig_type=std_logic lab=r17}
N 700 1500 680 1500 {lab=sck}
C {devices/lab_pin.sym} 680 1500 0 0 {name=l139 sig_type=std_logic lab=sck}
N 700 1520 680 1520 {lab=rst}
C {devices/lab_pin.sym} 680 1520 0 0 {name=l140 sig_type=std_logic lab=rst}
N 900 1480 920 1480 {lab=r18}
C {devices/lab_pin.sym} 920 1480 0 1 {name=l141 sig_type=std_logic lab=r18}
N 900 1500 920 1500 {lab=VDD}
C {devices/lab_pin.sym} 920 1500 0 1 {name=l142 sig_type=std_logic lab=VDD}
N 900 1520 920 1520 {lab=VSS}
C {devices/lab_pin.sym} 920 1520 0 1 {name=l143 sig_type=std_logic lab=VSS}
C {dffr_s.sym} 1100 1500 0 0 {name=XR19 }
N 1000 1480 980 1480 {lab=r18}
C {devices/lab_pin.sym} 980 1480 0 0 {name=l144 sig_type=std_logic lab=r18}
N 1000 1500 980 1500 {lab=sck}
C {devices/lab_pin.sym} 980 1500 0 0 {name=l145 sig_type=std_logic lab=sck}
N 1000 1520 980 1520 {lab=rst}
C {devices/lab_pin.sym} 980 1520 0 0 {name=l146 sig_type=std_logic lab=rst}
N 1200 1480 1220 1480 {lab=r19}
C {devices/lab_pin.sym} 1220 1480 0 1 {name=l147 sig_type=std_logic lab=r19}
N 1200 1500 1220 1500 {lab=VDD}
C {devices/lab_pin.sym} 1220 1500 0 1 {name=l148 sig_type=std_logic lab=VDD}
N 1200 1520 1220 1520 {lab=VSS}
C {devices/lab_pin.sym} 1220 1520 0 1 {name=l149 sig_type=std_logic lab=VSS}
C {dffr_s.sym} 200 1700 0 0 {name=XR20 }
N 100 1680 80 1680 {lab=r19}
C {devices/lab_pin.sym} 80 1680 0 0 {name=l150 sig_type=std_logic lab=r19}
N 100 1700 80 1700 {lab=sck}
C {devices/lab_pin.sym} 80 1700 0 0 {name=l151 sig_type=std_logic lab=sck}
N 100 1720 80 1720 {lab=rst}
C {devices/lab_pin.sym} 80 1720 0 0 {name=l152 sig_type=std_logic lab=rst}
N 300 1680 320 1680 {lab=r20}
C {devices/lab_pin.sym} 320 1680 0 1 {name=l153 sig_type=std_logic lab=r20}
N 300 1700 320 1700 {lab=VDD}
C {devices/lab_pin.sym} 320 1700 0 1 {name=l154 sig_type=std_logic lab=VDD}
N 300 1720 320 1720 {lab=VSS}
C {devices/lab_pin.sym} 320 1720 0 1 {name=l155 sig_type=std_logic lab=VSS}
C {dffr_s.sym} 500 1700 0 0 {name=XR21 }
N 400 1680 380 1680 {lab=r20}
C {devices/lab_pin.sym} 380 1680 0 0 {name=l156 sig_type=std_logic lab=r20}
N 400 1700 380 1700 {lab=sck}
C {devices/lab_pin.sym} 380 1700 0 0 {name=l157 sig_type=std_logic lab=sck}
N 400 1720 380 1720 {lab=rst}
C {devices/lab_pin.sym} 380 1720 0 0 {name=l158 sig_type=std_logic lab=rst}
N 600 1680 620 1680 {lab=r21}
C {devices/lab_pin.sym} 620 1680 0 1 {name=l159 sig_type=std_logic lab=r21}
N 600 1700 620 1700 {lab=VDD}
C {devices/lab_pin.sym} 620 1700 0 1 {name=l160 sig_type=std_logic lab=VDD}
N 600 1720 620 1720 {lab=VSS}
C {devices/lab_pin.sym} 620 1720 0 1 {name=l161 sig_type=std_logic lab=VSS}
C {dffr_s.sym} 800 1700 0 0 {name=XR22 }
N 700 1680 680 1680 {lab=r21}
C {devices/lab_pin.sym} 680 1680 0 0 {name=l162 sig_type=std_logic lab=r21}
N 700 1700 680 1700 {lab=sck}
C {devices/lab_pin.sym} 680 1700 0 0 {name=l163 sig_type=std_logic lab=sck}
N 700 1720 680 1720 {lab=rst}
C {devices/lab_pin.sym} 680 1720 0 0 {name=l164 sig_type=std_logic lab=rst}
N 900 1680 920 1680 {lab=r22}
C {devices/lab_pin.sym} 920 1680 0 1 {name=l165 sig_type=std_logic lab=r22}
N 900 1700 920 1700 {lab=VDD}
C {devices/lab_pin.sym} 920 1700 0 1 {name=l166 sig_type=std_logic lab=VDD}
N 900 1720 920 1720 {lab=VSS}
C {devices/lab_pin.sym} 920 1720 0 1 {name=l167 sig_type=std_logic lab=VSS}
C {dffr_s.sym} 1100 1700 0 0 {name=XR23 }
N 1000 1680 980 1680 {lab=r22}
C {devices/lab_pin.sym} 980 1680 0 0 {name=l168 sig_type=std_logic lab=r22}
N 1000 1700 980 1700 {lab=sck}
C {devices/lab_pin.sym} 980 1700 0 0 {name=l169 sig_type=std_logic lab=sck}
N 1000 1720 980 1720 {lab=rst}
C {devices/lab_pin.sym} 980 1720 0 0 {name=l170 sig_type=std_logic lab=rst}
N 1200 1680 1220 1680 {lab=r23}
C {devices/lab_pin.sym} 1220 1680 0 1 {name=l171 sig_type=std_logic lab=r23}
N 1200 1700 1220 1700 {lab=VDD}
C {devices/lab_pin.sym} 1220 1700 0 1 {name=l172 sig_type=std_logic lab=VDD}
N 1200 1720 1220 1720 {lab=VSS}
C {devices/lab_pin.sym} 1220 1720 0 1 {name=l173 sig_type=std_logic lab=VSS}
C {latch_s.sym} 200 1900 0 0 {name=XL0 }
N 100 1880 80 1880 {lab=r0}
C {devices/lab_pin.sym} 80 1880 0 0 {name=l174 sig_type=std_logic lab=r0}
N 100 1900 80 1900 {lab=CS_N}
C {devices/lab_pin.sym} 80 1900 0 0 {name=l175 sig_type=std_logic lab=CS_N}
N 300 1880 320 1880 {lab=IG1A}
C {devices/lab_pin.sym} 320 1880 0 1 {name=l176 sig_type=std_logic lab=IG1A}
N 300 1900 320 1900 {lab=VDD}
C {devices/lab_pin.sym} 320 1900 0 1 {name=l177 sig_type=std_logic lab=VDD}
N 300 1920 320 1920 {lab=VSS}
C {devices/lab_pin.sym} 320 1920 0 1 {name=l178 sig_type=std_logic lab=VSS}
C {latch_s.sym} 500 1900 0 0 {name=XL1 }
N 400 1880 380 1880 {lab=r1}
C {devices/lab_pin.sym} 380 1880 0 0 {name=l179 sig_type=std_logic lab=r1}
N 400 1900 380 1900 {lab=CS_N}
C {devices/lab_pin.sym} 380 1900 0 0 {name=l180 sig_type=std_logic lab=CS_N}
N 600 1880 620 1880 {lab=IG1B}
C {devices/lab_pin.sym} 620 1880 0 1 {name=l181 sig_type=std_logic lab=IG1B}
N 600 1900 620 1900 {lab=VDD}
C {devices/lab_pin.sym} 620 1900 0 1 {name=l182 sig_type=std_logic lab=VDD}
N 600 1920 620 1920 {lab=VSS}
C {devices/lab_pin.sym} 620 1920 0 1 {name=l183 sig_type=std_logic lab=VSS}
C {latch_s.sym} 800 1900 0 0 {name=XL2 }
N 700 1880 680 1880 {lab=r2}
C {devices/lab_pin.sym} 680 1880 0 0 {name=l184 sig_type=std_logic lab=r2}
N 700 1900 680 1900 {lab=CS_N}
C {devices/lab_pin.sym} 680 1900 0 0 {name=l185 sig_type=std_logic lab=CS_N}
N 900 1880 920 1880 {lab=IG2A}
C {devices/lab_pin.sym} 920 1880 0 1 {name=l186 sig_type=std_logic lab=IG2A}
N 900 1900 920 1900 {lab=VDD}
C {devices/lab_pin.sym} 920 1900 0 1 {name=l187 sig_type=std_logic lab=VDD}
N 900 1920 920 1920 {lab=VSS}
C {devices/lab_pin.sym} 920 1920 0 1 {name=l188 sig_type=std_logic lab=VSS}
C {latch_s.sym} 1100 1900 0 0 {name=XL3 }
N 1000 1880 980 1880 {lab=r3}
C {devices/lab_pin.sym} 980 1880 0 0 {name=l189 sig_type=std_logic lab=r3}
N 1000 1900 980 1900 {lab=CS_N}
C {devices/lab_pin.sym} 980 1900 0 0 {name=l190 sig_type=std_logic lab=CS_N}
N 1200 1880 1220 1880 {lab=IG2B}
C {devices/lab_pin.sym} 1220 1880 0 1 {name=l191 sig_type=std_logic lab=IG2B}
N 1200 1900 1220 1900 {lab=VDD}
C {devices/lab_pin.sym} 1220 1900 0 1 {name=l192 sig_type=std_logic lab=VDD}
N 1200 1920 1220 1920 {lab=VSS}
C {devices/lab_pin.sym} 1220 1920 0 1 {name=l193 sig_type=std_logic lab=VSS}
C {latch_s.sym} 200 2100 0 0 {name=XL4 }
N 100 2080 80 2080 {lab=r4}
C {devices/lab_pin.sym} 80 2080 0 0 {name=l194 sig_type=std_logic lab=r4}
N 100 2100 80 2100 {lab=CS_N}
C {devices/lab_pin.sym} 80 2100 0 0 {name=l195 sig_type=std_logic lab=CS_N}
N 300 2080 320 2080 {lab=IG3A}
C {devices/lab_pin.sym} 320 2080 0 1 {name=l196 sig_type=std_logic lab=IG3A}
N 300 2100 320 2100 {lab=VDD}
C {devices/lab_pin.sym} 320 2100 0 1 {name=l197 sig_type=std_logic lab=VDD}
N 300 2120 320 2120 {lab=VSS}
C {devices/lab_pin.sym} 320 2120 0 1 {name=l198 sig_type=std_logic lab=VSS}
C {latch_s.sym} 500 2100 0 0 {name=XL5 }
N 400 2080 380 2080 {lab=r5}
C {devices/lab_pin.sym} 380 2080 0 0 {name=l199 sig_type=std_logic lab=r5}
N 400 2100 380 2100 {lab=CS_N}
C {devices/lab_pin.sym} 380 2100 0 0 {name=l200 sig_type=std_logic lab=CS_N}
N 600 2080 620 2080 {lab=IG3B}
C {devices/lab_pin.sym} 620 2080 0 1 {name=l201 sig_type=std_logic lab=IG3B}
N 600 2100 620 2100 {lab=VDD}
C {devices/lab_pin.sym} 620 2100 0 1 {name=l202 sig_type=std_logic lab=VDD}
N 600 2120 620 2120 {lab=VSS}
C {devices/lab_pin.sym} 620 2120 0 1 {name=l203 sig_type=std_logic lab=VSS}
C {latch_s.sym} 800 2100 0 0 {name=XL6 }
N 700 2080 680 2080 {lab=r6}
C {devices/lab_pin.sym} 680 2080 0 0 {name=l204 sig_type=std_logic lab=r6}
N 700 2100 680 2100 {lab=CS_N}
C {devices/lab_pin.sym} 680 2100 0 0 {name=l205 sig_type=std_logic lab=CS_N}
N 900 2080 920 2080 {lab=B0}
C {devices/lab_pin.sym} 920 2080 0 1 {name=l206 sig_type=std_logic lab=B0}
N 900 2100 920 2100 {lab=VDD}
C {devices/lab_pin.sym} 920 2100 0 1 {name=l207 sig_type=std_logic lab=VDD}
N 900 2120 920 2120 {lab=VSS}
C {devices/lab_pin.sym} 920 2120 0 1 {name=l208 sig_type=std_logic lab=VSS}
C {latch_s.sym} 1100 2100 0 0 {name=XL7 }
N 1000 2080 980 2080 {lab=r7}
C {devices/lab_pin.sym} 980 2080 0 0 {name=l209 sig_type=std_logic lab=r7}
N 1000 2100 980 2100 {lab=CS_N}
C {devices/lab_pin.sym} 980 2100 0 0 {name=l210 sig_type=std_logic lab=CS_N}
N 1200 2080 1220 2080 {lab=B1}
C {devices/lab_pin.sym} 1220 2080 0 1 {name=l211 sig_type=std_logic lab=B1}
N 1200 2100 1220 2100 {lab=VDD}
C {devices/lab_pin.sym} 1220 2100 0 1 {name=l212 sig_type=std_logic lab=VDD}
N 1200 2120 1220 2120 {lab=VSS}
C {devices/lab_pin.sym} 1220 2120 0 1 {name=l213 sig_type=std_logic lab=VSS}
C {latch_s.sym} 200 2300 0 0 {name=XL8 }
N 100 2280 80 2280 {lab=r8}
C {devices/lab_pin.sym} 80 2280 0 0 {name=l214 sig_type=std_logic lab=r8}
N 100 2300 80 2300 {lab=CS_N}
C {devices/lab_pin.sym} 80 2300 0 0 {name=l215 sig_type=std_logic lab=CS_N}
N 300 2280 320 2280 {lab=AFC0}
C {devices/lab_pin.sym} 320 2280 0 1 {name=l216 sig_type=std_logic lab=AFC0}
N 300 2300 320 2300 {lab=VDD}
C {devices/lab_pin.sym} 320 2300 0 1 {name=l217 sig_type=std_logic lab=VDD}
N 300 2320 320 2320 {lab=VSS}
C {devices/lab_pin.sym} 320 2320 0 1 {name=l218 sig_type=std_logic lab=VSS}
C {latch_s.sym} 500 2300 0 0 {name=XL9 }
N 400 2280 380 2280 {lab=r9}
C {devices/lab_pin.sym} 380 2280 0 0 {name=l219 sig_type=std_logic lab=r9}
N 400 2300 380 2300 {lab=CS_N}
C {devices/lab_pin.sym} 380 2300 0 0 {name=l220 sig_type=std_logic lab=CS_N}
N 600 2280 620 2280 {lab=AFC1}
C {devices/lab_pin.sym} 620 2280 0 1 {name=l221 sig_type=std_logic lab=AFC1}
N 600 2300 620 2300 {lab=VDD}
C {devices/lab_pin.sym} 620 2300 0 1 {name=l222 sig_type=std_logic lab=VDD}
N 600 2320 620 2320 {lab=VSS}
C {devices/lab_pin.sym} 620 2320 0 1 {name=l223 sig_type=std_logic lab=VSS}
C {latch_s.sym} 800 2300 0 0 {name=XL10 }
N 700 2280 680 2280 {lab=r10}
C {devices/lab_pin.sym} 680 2280 0 0 {name=l224 sig_type=std_logic lab=r10}
N 700 2300 680 2300 {lab=CS_N}
C {devices/lab_pin.sym} 680 2300 0 0 {name=l225 sig_type=std_logic lab=CS_N}
N 900 2280 920 2280 {lab=AFC2}
C {devices/lab_pin.sym} 920 2280 0 1 {name=l226 sig_type=std_logic lab=AFC2}
N 900 2300 920 2300 {lab=VDD}
C {devices/lab_pin.sym} 920 2300 0 1 {name=l227 sig_type=std_logic lab=VDD}
N 900 2320 920 2320 {lab=VSS}
C {devices/lab_pin.sym} 920 2320 0 1 {name=l228 sig_type=std_logic lab=VSS}
C {latch_s.sym} 1100 2300 0 0 {name=XL11 }
N 1000 2280 980 2280 {lab=r11}
C {devices/lab_pin.sym} 980 2280 0 0 {name=l229 sig_type=std_logic lab=r11}
N 1000 2300 980 2300 {lab=CS_N}
C {devices/lab_pin.sym} 980 2300 0 0 {name=l230 sig_type=std_logic lab=CS_N}
N 1200 2280 1220 2280 {lab=AFC3}
C {devices/lab_pin.sym} 1220 2280 0 1 {name=l231 sig_type=std_logic lab=AFC3}
N 1200 2300 1220 2300 {lab=VDD}
C {devices/lab_pin.sym} 1220 2300 0 1 {name=l232 sig_type=std_logic lab=VDD}
N 1200 2320 1220 2320 {lab=VSS}
C {devices/lab_pin.sym} 1220 2320 0 1 {name=l233 sig_type=std_logic lab=VSS}
C {latch_s.sym} 200 2500 0 0 {name=XL12 }
N 100 2480 80 2480 {lab=r12}
C {devices/lab_pin.sym} 80 2480 0 0 {name=l234 sig_type=std_logic lab=r12}
N 100 2500 80 2500 {lab=CS_N}
C {devices/lab_pin.sym} 80 2500 0 0 {name=l235 sig_type=std_logic lab=CS_N}
N 300 2480 320 2480 {lab=AFC4}
C {devices/lab_pin.sym} 320 2480 0 1 {name=l236 sig_type=std_logic lab=AFC4}
N 300 2500 320 2500 {lab=VDD}
C {devices/lab_pin.sym} 320 2500 0 1 {name=l237 sig_type=std_logic lab=VDD}
N 300 2520 320 2520 {lab=VSS}
C {devices/lab_pin.sym} 320 2520 0 1 {name=l238 sig_type=std_logic lab=VSS}
C {latch_s.sym} 500 2500 0 0 {name=XL13 }
N 400 2480 380 2480 {lab=r13}
C {devices/lab_pin.sym} 380 2480 0 0 {name=l239 sig_type=std_logic lab=r13}
N 400 2500 380 2500 {lab=CS_N}
C {devices/lab_pin.sym} 380 2500 0 0 {name=l240 sig_type=std_logic lab=CS_N}
N 600 2480 620 2480 {lab=AFC5}
C {devices/lab_pin.sym} 620 2480 0 1 {name=l241 sig_type=std_logic lab=AFC5}
N 600 2500 620 2500 {lab=VDD}
C {devices/lab_pin.sym} 620 2500 0 1 {name=l242 sig_type=std_logic lab=VDD}
N 600 2520 620 2520 {lab=VSS}
C {devices/lab_pin.sym} 620 2520 0 1 {name=l243 sig_type=std_logic lab=VSS}
C {latch_s.sym} 800 2500 0 0 {name=XL14 }
N 700 2480 680 2480 {lab=r14}
C {devices/lab_pin.sym} 680 2480 0 0 {name=l244 sig_type=std_logic lab=r14}
N 700 2500 680 2500 {lab=CS_N}
C {devices/lab_pin.sym} 680 2500 0 0 {name=l245 sig_type=std_logic lab=CS_N}
N 900 2480 920 2480 {lab=AFC6}
C {devices/lab_pin.sym} 920 2480 0 1 {name=l246 sig_type=std_logic lab=AFC6}
N 900 2500 920 2500 {lab=VDD}
C {devices/lab_pin.sym} 920 2500 0 1 {name=l247 sig_type=std_logic lab=VDD}
N 900 2520 920 2520 {lab=VSS}
C {devices/lab_pin.sym} 920 2520 0 1 {name=l248 sig_type=std_logic lab=VSS}
C {latch_s.sym} 1100 2500 0 0 {name=XL15 }
N 1000 2480 980 2480 {lab=r15}
C {devices/lab_pin.sym} 980 2480 0 0 {name=l249 sig_type=std_logic lab=r15}
N 1000 2500 980 2500 {lab=CS_N}
C {devices/lab_pin.sym} 980 2500 0 0 {name=l250 sig_type=std_logic lab=CS_N}
N 1200 2480 1220 2480 {lab=afc7n}
C {devices/lab_pin.sym} 1220 2480 0 1 {name=l251 sig_type=std_logic lab=afc7n}
N 1200 2500 1220 2500 {lab=VDD}
C {devices/lab_pin.sym} 1220 2500 0 1 {name=l252 sig_type=std_logic lab=VDD}
N 1200 2520 1220 2520 {lab=VSS}
C {devices/lab_pin.sym} 1220 2520 0 1 {name=l253 sig_type=std_logic lab=VSS}
C {inv_dig.sym} 200 2700 0 0 {name=XAFC7 }
N 100 2680 80 2680 {lab=afc7n}
C {devices/lab_pin.sym} 80 2680 0 0 {name=l254 sig_type=std_logic lab=afc7n}
N 300 2680 320 2680 {lab=AFC7}
C {devices/lab_pin.sym} 320 2680 0 1 {name=l255 sig_type=std_logic lab=AFC7}
N 300 2700 320 2700 {lab=VDD}
C {devices/lab_pin.sym} 320 2700 0 1 {name=l256 sig_type=std_logic lab=VDD}
N 300 2720 320 2720 {lab=VSS}
C {devices/lab_pin.sym} 320 2720 0 1 {name=l257 sig_type=std_logic lab=VSS}
C {latch_s.sym} 500 2700 0 0 {name=XL16 }
N 400 2680 380 2680 {lab=r16}
C {devices/lab_pin.sym} 380 2680 0 0 {name=l258 sig_type=std_logic lab=r16}
N 400 2700 380 2700 {lab=CS_N}
C {devices/lab_pin.sym} 380 2700 0 0 {name=l259 sig_type=std_logic lab=CS_N}
N 600 2680 620 2680 {lab=ICP2}
C {devices/lab_pin.sym} 620 2680 0 1 {name=l260 sig_type=std_logic lab=ICP2}
N 600 2700 620 2700 {lab=VDD}
C {devices/lab_pin.sym} 620 2700 0 1 {name=l261 sig_type=std_logic lab=VDD}
N 600 2720 620 2720 {lab=VSS}
C {devices/lab_pin.sym} 620 2720 0 1 {name=l262 sig_type=std_logic lab=VSS}
C {latch_s.sym} 800 2700 0 0 {name=XL17 }
N 700 2680 680 2680 {lab=r17}
C {devices/lab_pin.sym} 680 2680 0 0 {name=l263 sig_type=std_logic lab=r17}
N 700 2700 680 2700 {lab=CS_N}
C {devices/lab_pin.sym} 680 2700 0 0 {name=l264 sig_type=std_logic lab=CS_N}
N 900 2680 920 2680 {lab=BWW}
C {devices/lab_pin.sym} 920 2680 0 1 {name=l265 sig_type=std_logic lab=BWW}
N 900 2700 920 2700 {lab=VDD}
C {devices/lab_pin.sym} 920 2700 0 1 {name=l266 sig_type=std_logic lab=VDD}
N 900 2720 920 2720 {lab=VSS}
C {devices/lab_pin.sym} 920 2720 0 1 {name=l267 sig_type=std_logic lab=VSS}
C {latch_s.sym} 1100 2700 0 0 {name=XL18 }
N 1000 2680 980 2680 {lab=r18}
C {devices/lab_pin.sym} 980 2680 0 0 {name=l268 sig_type=std_logic lab=r18}
N 1000 2700 980 2700 {lab=CS_N}
C {devices/lab_pin.sym} 980 2700 0 0 {name=l269 sig_type=std_logic lab=CS_N}
N 1200 2680 1220 2680 {lab=BWN}
C {devices/lab_pin.sym} 1220 2680 0 1 {name=l270 sig_type=std_logic lab=BWN}
N 1200 2700 1220 2700 {lab=VDD}
C {devices/lab_pin.sym} 1220 2700 0 1 {name=l271 sig_type=std_logic lab=VDD}
N 1200 2720 1220 2720 {lab=VSS}
C {devices/lab_pin.sym} 1220 2720 0 1 {name=l272 sig_type=std_logic lab=VSS}
C {devices/title.sym} 160 3180 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
