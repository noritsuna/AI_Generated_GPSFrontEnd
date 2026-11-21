v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {sk_lpf1: Sallen-Key LPF, R1=1k (+2k VGA Rout), R2=3k, C1/C2 MIM side 42.6/45.8 um} 100 80 0 0 0.6 0.6 {}
T {side P} 100 190 0 0 0.4 0.4 {layer=8}
T {side N} 100 590 0 0 0.4 0.4 {layer=8}
C {devices/ipin.sym} -100 300 0 0 {name=p0 lab=INP}
C {devices/ipin.sym} -100 330 0 0 {name=p1 lab=INN}
C {devices/ipin.sym} -100 360 0 0 {name=p2 lab=PB}
C {devices/ipin.sym} -100 390 0 0 {name=p3 lab=TW}
C {devices/ipin.sym} -100 420 0 0 {name=p4 lab=TN}
C {devices/opin.sym} -100 450 0 0 {name=p5 lab=OUTP}
C {devices/opin.sym} -100 480 0 0 {name=p6 lab=OUTN}
C {devices/iopin.sym} -100 510 0 0 {name=p7 lab=VDD}
C {devices/iopin.sym} -100 540 0 0 {name=p8 lab=VSS}
C {symbols/ppolyf_u_1k.sym} 200 300 0 0 {name=R1P W=1u L=1u model=ppolyf_u_1k spiceprefix=X m=1}
N 200 330 200 350 {lab=xP}
C {devices/lab_pin.sym} 200 350 0 0 {name=l1 sig_type=std_logic lab=xP}
N 200 270 200 250 {lab=INP}
C {devices/lab_pin.sym} 200 250 0 0 {name=l2 sig_type=std_logic lab=INP}
N 180 300 160 300 {lab=VSS}
C {devices/lab_pin.sym} 160 300 0 0 {name=l3 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 460 300 0 0 {name=R2P W=1u L=3u model=ppolyf_u_1k spiceprefix=X m=1}
N 460 330 460 350 {lab=yP}
C {devices/lab_pin.sym} 460 350 0 0 {name=l4 sig_type=std_logic lab=yP}
N 460 270 460 250 {lab=xP}
C {devices/lab_pin.sym} 460 250 0 0 {name=l5 sig_type=std_logic lab=xP}
N 440 300 420 300 {lab=VSS}
C {devices/lab_pin.sym} 420 300 0 0 {name=l6 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 720 300 0 0 {name=C1P W=42.6e-6 L=42.6e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 720 270 720 250 {lab=xP}
C {devices/lab_pin.sym} 720 250 0 0 {name=l7 sig_type=std_logic lab=xP}
N 720 330 720 350 {lab=OUTP}
C {devices/lab_pin.sym} 720 350 0 0 {name=l8 sig_type=std_logic lab=OUTP}
C {symbols/cap_mim_2f0fF.sym} 980 300 0 0 {name=C2P W=36.64e-6 L=36.64e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 980 270 980 250 {lab=yP}
C {devices/lab_pin.sym} 980 250 0 0 {name=l9 sig_type=std_logic lab=yP}
N 980 330 980 350 {lab=VSS}
C {devices/lab_pin.sym} 980 350 0 0 {name=l10 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 1240 300 0 0 {name=C2WP W=27.48e-6 L=27.48e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 1240 270 1240 250 {lab=yP}
C {devices/lab_pin.sym} 1240 250 0 0 {name=l11 sig_type=std_logic lab=yP}
N 1240 330 1240 350 {lab=wP}
C {devices/lab_pin.sym} 1240 350 0 0 {name=l12 sig_type=std_logic lab=wP}
C {symbols/cap_mim_2f0fF.sym} 1500 300 0 0 {name=C2NP W=35.48e-6 L=35.48e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 1500 270 1500 250 {lab=yP}
C {devices/lab_pin.sym} 1500 250 0 0 {name=l13 sig_type=std_logic lab=yP}
N 1500 330 1500 350 {lab=nP}
C {devices/lab_pin.sym} 1500 350 0 0 {name=l14 sig_type=std_logic lab=nP}
C {symbols/nfet_03v3.sym} 200 500 0 0 {name=MSWP L=0.28u W=8u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 470 220 450 {lab=wP}
C {devices/lab_pin.sym} 220 450 0 0 {name=l15 sig_type=std_logic lab=wP}
N 180 500 160 500 {lab=TW}
C {devices/lab_pin.sym} 160 500 0 0 {name=l16 sig_type=std_logic lab=TW}
N 220 530 220 550 {lab=VSS}
C {devices/lab_pin.sym} 220 550 0 0 {name=l17 sig_type=std_logic lab=VSS}
N 220 500 240 500 {lab=VSS}
C {devices/lab_pin.sym} 240 500 0 1 {name=l18 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 460 500 0 0 {name=MSNP L=0.28u W=8u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 480 470 480 450 {lab=nP}
C {devices/lab_pin.sym} 480 450 0 0 {name=l19 sig_type=std_logic lab=nP}
N 440 500 420 500 {lab=TN}
C {devices/lab_pin.sym} 420 500 0 0 {name=l20 sig_type=std_logic lab=TN}
N 480 530 480 550 {lab=VSS}
C {devices/lab_pin.sym} 480 550 0 0 {name=l21 sig_type=std_logic lab=VSS}
N 480 500 500 500 {lab=VSS}
C {devices/lab_pin.sym} 500 500 0 1 {name=l22 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 720 500 0 0 {name=MFP L=0.28u W=40u nf=8 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 740 530 740 550 {lab=VSS}
C {devices/lab_pin.sym} 740 550 0 0 {name=l23 sig_type=std_logic lab=VSS}
N 700 500 680 500 {lab=yP}
C {devices/lab_pin.sym} 680 500 0 0 {name=l24 sig_type=std_logic lab=yP}
N 740 470 740 450 {lab=OUTP}
C {devices/lab_pin.sym} 740 450 0 0 {name=l25 sig_type=std_logic lab=OUTP}
N 740 500 760 500 {lab=OUTP}
C {devices/lab_pin.sym} 760 500 0 1 {name=l26 sig_type=std_logic lab=OUTP}
C {symbols/pfet_03v3.sym} 980 500 0 0 {name=MIP L=2u W=40u nf=4 m=16 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1000 530 1000 550 {lab=OUTP}
C {devices/lab_pin.sym} 1000 550 0 0 {name=l27 sig_type=std_logic lab=OUTP}
N 960 500 940 500 {lab=PB}
C {devices/lab_pin.sym} 940 500 0 0 {name=l28 sig_type=std_logic lab=PB}
N 1000 470 1000 450 {lab=VDD}
C {devices/lab_pin.sym} 1000 450 0 0 {name=l29 sig_type=std_logic lab=VDD}
N 1000 500 1020 500 {lab=VDD}
C {devices/lab_pin.sym} 1020 500 0 1 {name=l30 sig_type=std_logic lab=VDD}
C {symbols/ppolyf_u_1k.sym} 200 700 0 0 {name=R1N W=1u L=1u model=ppolyf_u_1k spiceprefix=X m=1}
N 200 730 200 750 {lab=xN}
C {devices/lab_pin.sym} 200 750 0 0 {name=l31 sig_type=std_logic lab=xN}
N 200 670 200 650 {lab=INN}
C {devices/lab_pin.sym} 200 650 0 0 {name=l32 sig_type=std_logic lab=INN}
N 180 700 160 700 {lab=VSS}
C {devices/lab_pin.sym} 160 700 0 0 {name=l33 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 460 700 0 0 {name=R2N W=1u L=3u model=ppolyf_u_1k spiceprefix=X m=1}
N 460 730 460 750 {lab=yN}
C {devices/lab_pin.sym} 460 750 0 0 {name=l34 sig_type=std_logic lab=yN}
N 460 670 460 650 {lab=xN}
C {devices/lab_pin.sym} 460 650 0 0 {name=l35 sig_type=std_logic lab=xN}
N 440 700 420 700 {lab=VSS}
C {devices/lab_pin.sym} 420 700 0 0 {name=l36 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 720 700 0 0 {name=C1N W=42.6e-6 L=42.6e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 720 670 720 650 {lab=xN}
C {devices/lab_pin.sym} 720 650 0 0 {name=l37 sig_type=std_logic lab=xN}
N 720 730 720 750 {lab=OUTN}
C {devices/lab_pin.sym} 720 750 0 0 {name=l38 sig_type=std_logic lab=OUTN}
C {symbols/cap_mim_2f0fF.sym} 980 700 0 0 {name=C2N W=36.64e-6 L=36.64e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 980 670 980 650 {lab=yN}
C {devices/lab_pin.sym} 980 650 0 0 {name=l39 sig_type=std_logic lab=yN}
N 980 730 980 750 {lab=VSS}
C {devices/lab_pin.sym} 980 750 0 0 {name=l40 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 1240 700 0 0 {name=C2WN W=27.48e-6 L=27.48e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 1240 670 1240 650 {lab=yN}
C {devices/lab_pin.sym} 1240 650 0 0 {name=l41 sig_type=std_logic lab=yN}
N 1240 730 1240 750 {lab=wN}
C {devices/lab_pin.sym} 1240 750 0 0 {name=l42 sig_type=std_logic lab=wN}
C {symbols/cap_mim_2f0fF.sym} 1500 700 0 0 {name=C2NN W=35.48e-6 L=35.48e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 1500 670 1500 650 {lab=yN}
C {devices/lab_pin.sym} 1500 650 0 0 {name=l43 sig_type=std_logic lab=yN}
N 1500 730 1500 750 {lab=nN}
C {devices/lab_pin.sym} 1500 750 0 0 {name=l44 sig_type=std_logic lab=nN}
C {symbols/nfet_03v3.sym} 200 900 0 0 {name=MSWN L=0.28u W=8u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 870 220 850 {lab=wN}
C {devices/lab_pin.sym} 220 850 0 0 {name=l45 sig_type=std_logic lab=wN}
N 180 900 160 900 {lab=TW}
C {devices/lab_pin.sym} 160 900 0 0 {name=l46 sig_type=std_logic lab=TW}
N 220 930 220 950 {lab=VSS}
C {devices/lab_pin.sym} 220 950 0 0 {name=l47 sig_type=std_logic lab=VSS}
N 220 900 240 900 {lab=VSS}
C {devices/lab_pin.sym} 240 900 0 1 {name=l48 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 460 900 0 0 {name=MSNN L=0.28u W=8u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 480 870 480 850 {lab=nN}
C {devices/lab_pin.sym} 480 850 0 0 {name=l49 sig_type=std_logic lab=nN}
N 440 900 420 900 {lab=TN}
C {devices/lab_pin.sym} 420 900 0 0 {name=l50 sig_type=std_logic lab=TN}
N 480 930 480 950 {lab=VSS}
C {devices/lab_pin.sym} 480 950 0 0 {name=l51 sig_type=std_logic lab=VSS}
N 480 900 500 900 {lab=VSS}
C {devices/lab_pin.sym} 500 900 0 1 {name=l52 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 720 900 0 0 {name=MFN L=0.28u W=40u nf=8 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 740 930 740 950 {lab=VSS}
C {devices/lab_pin.sym} 740 950 0 0 {name=l53 sig_type=std_logic lab=VSS}
N 700 900 680 900 {lab=yN}
C {devices/lab_pin.sym} 680 900 0 0 {name=l54 sig_type=std_logic lab=yN}
N 740 870 740 850 {lab=OUTN}
C {devices/lab_pin.sym} 740 850 0 0 {name=l55 sig_type=std_logic lab=OUTN}
N 740 900 760 900 {lab=OUTN}
C {devices/lab_pin.sym} 760 900 0 1 {name=l56 sig_type=std_logic lab=OUTN}
C {symbols/pfet_03v3.sym} 980 900 0 0 {name=MIN L=2u W=40u nf=4 m=16 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1000 930 1000 950 {lab=OUTN}
C {devices/lab_pin.sym} 1000 950 0 0 {name=l57 sig_type=std_logic lab=OUTN}
N 960 900 940 900 {lab=PB}
C {devices/lab_pin.sym} 940 900 0 0 {name=l58 sig_type=std_logic lab=PB}
N 1000 870 1000 850 {lab=VDD}
C {devices/lab_pin.sym} 1000 850 0 0 {name=l59 sig_type=std_logic lab=VDD}
N 1000 900 1020 900 {lab=VDD}
C {devices/lab_pin.sym} 1020 900 0 1 {name=l60 sig_type=std_logic lab=VDD}
C {devices/title.sym} 160 1400 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
