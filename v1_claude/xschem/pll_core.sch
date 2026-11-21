v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {Integer-N PLL core: fREF = 16.368 MHz (TCXO), ring 785.664 MHz / 48 (LO = 2 x ring = 1571.328 MHz)} 100 80 0 0 0.6 0.6 {}
C {devices/ipin.sym} -100 300 0 0 {name=p0 lab=REFCK}
C {devices/ipin.sym} -100 330 0 0 {name=p1 lab=LO}
C {devices/ipin.sym} -100 360 0 0 {name=p2 lab=NB}
C {devices/ipin.sym} -100 390 0 0 {name=p3 lab=PB}
C {devices/ipin.sym} -100 420 0 0 {name=p4 lab=ICP2}
C {devices/opin.sym} -100 450 0 0 {name=p5 lab=VCTRL}
C {devices/opin.sym} -100 480 0 0 {name=p6 lab=FS}
C {devices/opin.sym} -100 510 0 0 {name=p7 lab=FB}
C {devices/iopin.sym} -100 540 0 0 {name=p8 lab=VDD}
C {devices/iopin.sym} -100 570 0 0 {name=p9 lab=VSS}
C {divbuf.sym} 200 300 0 0 {name=XDB }
N 100 280 80 280 {lab=LO}
C {devices/lab_pin.sym} 80 280 0 0 {name=l1 sig_type=std_logic lab=LO}
N 300 280 320 280 {lab=ck}
C {devices/lab_pin.sym} 320 280 0 1 {name=l2 sig_type=std_logic lab=ck}
N 300 300 320 300 {lab=VDD}
C {devices/lab_pin.sym} 320 300 0 1 {name=l3 sig_type=std_logic lab=VDD}
N 300 320 320 320 {lab=VSS}
C {devices/lab_pin.sym} 320 320 0 1 {name=l4 sig_type=std_logic lab=VSS}
C {div48.sym} 500 300 0 0 {name=XDIV }
N 400 270 380 270 {lab=ck}
C {devices/lab_pin.sym} 380 270 0 0 {name=l5 sig_type=std_logic lab=ck}
N 600 270 620 270 {lab=FS}
C {devices/lab_pin.sym} 620 270 0 1 {name=l6 sig_type=std_logic lab=FS}
N 600 290 620 290 {lab=FB}
C {devices/lab_pin.sym} 620 290 0 1 {name=l7 sig_type=std_logic lab=FB}
N 600 310 620 310 {lab=VDD}
C {devices/lab_pin.sym} 620 310 0 1 {name=l8 sig_type=std_logic lab=VDD}
N 600 330 620 330 {lab=VSS}
C {devices/lab_pin.sym} 620 330 0 1 {name=l9 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 800 300 0 0 {name=RREF W=2u L=2u model=ppolyf_u_1k spiceprefix=X m=1}
N 800 330 800 350 {lab=refck_i}
C {devices/lab_pin.sym} 800 350 0 0 {name=l10 sig_type=std_logic lab=refck_i}
N 800 270 800 250 {lab=REFCK}
C {devices/lab_pin.sym} 800 250 0 0 {name=l11 sig_type=std_logic lab=REFCK}
N 780 300 760 300 {lab=VSS}
C {devices/lab_pin.sym} 760 300 0 0 {name=l12 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 1100 300 0 0 {name=MCLN L=0.28u W=2u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 1120 270 1120 250 {lab=refck_i}
C {devices/lab_pin.sym} 1120 250 0 0 {name=l13 sig_type=std_logic lab=refck_i}
N 1080 300 1060 300 {lab=tlo}
C {devices/lab_pin.sym} 1060 300 0 0 {name=l14 sig_type=std_logic lab=tlo}
N 1120 330 1120 350 {lab=VSS}
C {devices/lab_pin.sym} 1120 350 0 0 {name=l15 sig_type=std_logic lab=VSS}
N 1120 300 1140 300 {lab=VSS}
C {devices/lab_pin.sym} 1140 300 0 1 {name=l16 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 200 500 0 0 {name=MCLP L=0.28u W=2u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 220 530 220 550 {lab=refck_i}
C {devices/lab_pin.sym} 220 550 0 0 {name=l17 sig_type=std_logic lab=refck_i}
N 180 500 160 500 {lab=thi}
C {devices/lab_pin.sym} 160 500 0 0 {name=l18 sig_type=std_logic lab=thi}
N 220 470 220 450 {lab=VDD}
C {devices/lab_pin.sym} 220 450 0 0 {name=l19 sig_type=std_logic lab=VDD}
N 220 500 240 500 {lab=VDD}
C {devices/lab_pin.sym} 240 500 0 1 {name=l20 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 500 500 0 0 {name=MTX L=0.28u W=1u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 520 470 520 450 {lab=tx}
C {devices/lab_pin.sym} 520 450 0 0 {name=l21 sig_type=std_logic lab=tx}
N 480 500 460 500 {lab=tx}
C {devices/lab_pin.sym} 460 500 0 0 {name=l22 sig_type=std_logic lab=tx}
N 520 530 520 550 {lab=VSS}
C {devices/lab_pin.sym} 520 550 0 0 {name=l23 sig_type=std_logic lab=VSS}
N 520 500 540 500 {lab=VSS}
C {devices/lab_pin.sym} 540 500 0 1 {name=l24 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 800 500 0 0 {name=MTHI L=0.28u W=1u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 820 530 820 550 {lab=thi}
C {devices/lab_pin.sym} 820 550 0 0 {name=l25 sig_type=std_logic lab=thi}
N 780 500 760 500 {lab=tx}
C {devices/lab_pin.sym} 760 500 0 0 {name=l26 sig_type=std_logic lab=tx}
N 820 470 820 450 {lab=VDD}
C {devices/lab_pin.sym} 820 450 0 0 {name=l27 sig_type=std_logic lab=VDD}
N 820 500 840 500 {lab=VDD}
C {devices/lab_pin.sym} 840 500 0 1 {name=l28 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 1100 500 0 0 {name=MTLO L=0.28u W=1u nf=1 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 1120 470 1120 450 {lab=tlo}
C {devices/lab_pin.sym} 1120 450 0 0 {name=l29 sig_type=std_logic lab=tlo}
N 1080 500 1060 500 {lab=thi}
C {devices/lab_pin.sym} 1060 500 0 0 {name=l30 sig_type=std_logic lab=thi}
N 1120 530 1120 550 {lab=VSS}
C {devices/lab_pin.sym} 1120 550 0 0 {name=l31 sig_type=std_logic lab=VSS}
N 1120 500 1140 500 {lab=VSS}
C {devices/lab_pin.sym} 1140 500 0 1 {name=l32 sig_type=std_logic lab=VSS}
C {pfd.sym} 200 700 0 0 {name=XPFD }
N 100 650 80 650 {lab=refck_i}
C {devices/lab_pin.sym} 80 650 0 0 {name=l33 sig_type=std_logic lab=refck_i}
N 100 670 80 670 {lab=FB}
C {devices/lab_pin.sym} 80 670 0 0 {name=l34 sig_type=std_logic lab=FB}
N 300 650 320 650 {lab=up}
C {devices/lab_pin.sym} 320 650 0 1 {name=l35 sig_type=std_logic lab=up}
N 300 670 320 670 {lab=upb}
C {devices/lab_pin.sym} 320 670 0 1 {name=l36 sig_type=std_logic lab=upb}
N 300 690 320 690 {lab=dn}
C {devices/lab_pin.sym} 320 690 0 1 {name=l37 sig_type=std_logic lab=dn}
N 300 710 320 710 {lab=dnb}
C {devices/lab_pin.sym} 320 710 0 1 {name=l38 sig_type=std_logic lab=dnb}
N 300 730 320 730 {lab=VDD}
C {devices/lab_pin.sym} 320 730 0 1 {name=l39 sig_type=std_logic lab=VDD}
N 300 750 320 750 {lab=VSS}
C {devices/lab_pin.sym} 320 750 0 1 {name=l40 sig_type=std_logic lab=VSS}
C {cp.sym} 500 700 0 0 {name=XCP }
N 400 650 380 650 {lab=upb}
C {devices/lab_pin.sym} 380 650 0 0 {name=l41 sig_type=std_logic lab=upb}
N 400 670 380 670 {lab=dn}
C {devices/lab_pin.sym} 380 670 0 0 {name=l42 sig_type=std_logic lab=dn}
N 400 690 380 690 {lab=dnb}
C {devices/lab_pin.sym} 380 690 0 0 {name=l43 sig_type=std_logic lab=dnb}
N 400 710 380 710 {lab=PB}
C {devices/lab_pin.sym} 380 710 0 0 {name=l44 sig_type=std_logic lab=PB}
N 400 730 380 730 {lab=NB}
C {devices/lab_pin.sym} 380 730 0 0 {name=l45 sig_type=std_logic lab=NB}
N 400 750 380 750 {lab=ICP2}
C {devices/lab_pin.sym} 380 750 0 0 {name=l46 sig_type=std_logic lab=ICP2}
N 600 650 620 650 {lab=vcp}
C {devices/lab_pin.sym} 620 650 0 1 {name=l47 sig_type=std_logic lab=vcp}
N 600 670 620 670 {lab=VDD}
C {devices/lab_pin.sym} 620 670 0 1 {name=l48 sig_type=std_logic lab=VDD}
N 600 690 620 690 {lab=VSS}
C {devices/lab_pin.sym} 620 690 0 1 {name=l49 sig_type=std_logic lab=VSS}
C {loop_filter.sym} 800 700 0 0 {name=XLF }
N 900 680 920 680 {lab=vcp}
C {devices/lab_pin.sym} 920 680 0 1 {name=l50 sig_type=std_logic lab=vcp}
N 900 700 920 700 {lab=VCTRL}
C {devices/lab_pin.sym} 920 700 0 1 {name=l51 sig_type=std_logic lab=VCTRL}
N 900 720 920 720 {lab=VSS}
C {devices/lab_pin.sym} 920 720 0 1 {name=l52 sig_type=std_logic lab=VSS}
C {devices/title.sym} 160 1240 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
