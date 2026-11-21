v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {VGA: AC coupled, switched source degeneration (per stage ~2/6/10/11.5 dB)} 100 80 0 0 0.6 0.6 {}
T {AC coupling + input common mode (1.4 V)} 100 190 0 0 0.4 0.4 {layer=8}
T {diff pair, per-side tail (1 mA), loads 2 kohm (low Rout to drive the Sallen-Key)} 100 590 0 0 0.4 0.4 {layer=8}
T {degeneration network (s1-s2)} 100 790 0 0 0.4 0.4 {layer=8}
C {devices/ipin.sym} -100 300 0 0 {name=p0 lab=INP}
C {devices/ipin.sym} -100 330 0 0 {name=p1 lab=INN}
C {devices/ipin.sym} -100 360 0 0 {name=p2 lab=GA}
C {devices/ipin.sym} -100 390 0 0 {name=p3 lab=GB}
C {devices/ipin.sym} -100 420 0 0 {name=p4 lab=NB}
C {devices/opin.sym} -100 450 0 0 {name=p5 lab=OUTP}
C {devices/opin.sym} -100 480 0 0 {name=p6 lab=OUTN}
C {devices/iopin.sym} -100 510 0 0 {name=p7 lab=VDD}
C {devices/iopin.sym} -100 540 0 0 {name=p8 lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 200 300 0 0 {name=CC1 W=50e-6 L=50e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 200 270 200 250 {lab=INP}
C {devices/lab_pin.sym} 200 250 0 0 {name=l1 sig_type=std_logic lab=INP}
N 200 330 200 350 {lab=gp}
C {devices/lab_pin.sym} 200 350 0 0 {name=l2 sig_type=std_logic lab=gp}
C {symbols/cap_mim_2f0fF.sym} 460 300 0 0 {name=CC2 W=50e-6 L=50e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 460 270 460 250 {lab=INN}
C {devices/lab_pin.sym} 460 250 0 0 {name=l3 sig_type=std_logic lab=INN}
N 460 330 460 350 {lab=gn}
C {devices/lab_pin.sym} 460 350 0 0 {name=l4 sig_type=std_logic lab=gn}
C {symbols/ppolyf_u_1k.sym} 720 300 0 0 {name=RB1 W=1u L=100u model=ppolyf_u_1k spiceprefix=X m=1}
N 720 330 720 350 {lab=vcm}
C {devices/lab_pin.sym} 720 350 0 0 {name=l5 sig_type=std_logic lab=vcm}
N 720 270 720 250 {lab=gp}
C {devices/lab_pin.sym} 720 250 0 0 {name=l6 sig_type=std_logic lab=gp}
N 700 300 680 300 {lab=VSS}
C {devices/lab_pin.sym} 680 300 0 0 {name=l7 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 980 300 0 0 {name=RB2 W=1u L=100u model=ppolyf_u_1k spiceprefix=X m=1}
N 980 330 980 350 {lab=vcm}
C {devices/lab_pin.sym} 980 350 0 0 {name=l8 sig_type=std_logic lab=vcm}
N 980 270 980 250 {lab=gn}
C {devices/lab_pin.sym} 980 250 0 0 {name=l9 sig_type=std_logic lab=gn}
N 960 300 940 300 {lab=VSS}
C {devices/lab_pin.sym} 940 300 0 0 {name=l10 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 1240 300 0 0 {name=RCA W=1u L=34u model=ppolyf_u_1k spiceprefix=X m=1}
N 1240 330 1240 350 {lab=vcm}
C {devices/lab_pin.sym} 1240 350 0 0 {name=l11 sig_type=std_logic lab=vcm}
N 1240 270 1240 250 {lab=VDD}
C {devices/lab_pin.sym} 1240 250 0 0 {name=l12 sig_type=std_logic lab=VDD}
N 1220 300 1200 300 {lab=VSS}
C {devices/lab_pin.sym} 1200 300 0 0 {name=l13 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 1500 300 0 0 {name=RCB W=1u L=25u model=ppolyf_u_1k spiceprefix=X m=1}
N 1500 330 1500 350 {lab=VSS}
C {devices/lab_pin.sym} 1500 350 0 0 {name=l14 sig_type=std_logic lab=VSS}
N 1500 270 1500 250 {lab=vcm}
C {devices/lab_pin.sym} 1500 250 0 0 {name=l15 sig_type=std_logic lab=vcm}
N 1480 300 1460 300 {lab=VSS}
C {devices/lab_pin.sym} 1460 300 0 0 {name=l16 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 200 500 0 0 {name=CCM W=30e-6 L=30e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 200 470 200 450 {lab=vcm}
C {devices/lab_pin.sym} 200 450 0 0 {name=l17 sig_type=std_logic lab=vcm}
N 200 530 200 550 {lab=VSS}
C {devices/lab_pin.sym} 200 550 0 0 {name=l18 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 200 700 0 0 {name=M1 L=0.28u W=40u nf=8 m=2 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 670 220 650 {lab=OUTN}
C {devices/lab_pin.sym} 220 650 0 0 {name=l19 sig_type=std_logic lab=OUTN}
N 180 700 160 700 {lab=gp}
C {devices/lab_pin.sym} 160 700 0 0 {name=l20 sig_type=std_logic lab=gp}
N 220 730 220 750 {lab=s1}
C {devices/lab_pin.sym} 220 750 0 0 {name=l21 sig_type=std_logic lab=s1}
N 220 700 240 700 {lab=VSS}
C {devices/lab_pin.sym} 240 700 0 1 {name=l22 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 460 700 0 0 {name=M2 L=0.28u W=40u nf=8 m=2 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 480 670 480 650 {lab=OUTP}
C {devices/lab_pin.sym} 480 650 0 0 {name=l23 sig_type=std_logic lab=OUTP}
N 440 700 420 700 {lab=gn}
C {devices/lab_pin.sym} 420 700 0 0 {name=l24 sig_type=std_logic lab=gn}
N 480 730 480 750 {lab=s2}
C {devices/lab_pin.sym} 480 750 0 0 {name=l25 sig_type=std_logic lab=s2}
N 480 700 500 700 {lab=VSS}
C {devices/lab_pin.sym} 500 700 0 1 {name=l26 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 720 700 0 0 {name=MT1 L=2u W=40u nf=4 m=8 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 740 670 740 650 {lab=s1}
C {devices/lab_pin.sym} 740 650 0 0 {name=l27 sig_type=std_logic lab=s1}
N 700 700 680 700 {lab=NB}
C {devices/lab_pin.sym} 680 700 0 0 {name=l28 sig_type=std_logic lab=NB}
N 740 730 740 750 {lab=VSS}
C {devices/lab_pin.sym} 740 750 0 0 {name=l29 sig_type=std_logic lab=VSS}
N 740 700 760 700 {lab=VSS}
C {devices/lab_pin.sym} 760 700 0 1 {name=l30 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 980 700 0 0 {name=MT2 L=2u W=40u nf=4 m=8 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 1000 670 1000 650 {lab=s2}
C {devices/lab_pin.sym} 1000 650 0 0 {name=l31 sig_type=std_logic lab=s2}
N 960 700 940 700 {lab=NB}
C {devices/lab_pin.sym} 940 700 0 0 {name=l32 sig_type=std_logic lab=NB}
N 1000 730 1000 750 {lab=VSS}
C {devices/lab_pin.sym} 1000 750 0 0 {name=l33 sig_type=std_logic lab=VSS}
N 1000 700 1020 700 {lab=VSS}
C {devices/lab_pin.sym} 1020 700 0 1 {name=l34 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 1240 700 0 0 {name=RL1 W=2u L=4.23u model=ppolyf_u_1k spiceprefix=X m=1}
N 1240 730 1240 750 {lab=OUTN}
C {devices/lab_pin.sym} 1240 750 0 0 {name=l35 sig_type=std_logic lab=OUTN}
N 1240 670 1240 650 {lab=VDD}
C {devices/lab_pin.sym} 1240 650 0 0 {name=l36 sig_type=std_logic lab=VDD}
N 1220 700 1200 700 {lab=VSS}
C {devices/lab_pin.sym} 1200 700 0 0 {name=l37 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 1500 700 0 0 {name=RL2 W=2u L=4.23u model=ppolyf_u_1k spiceprefix=X m=1}
N 1500 730 1500 750 {lab=OUTP}
C {devices/lab_pin.sym} 1500 750 0 0 {name=l38 sig_type=std_logic lab=OUTP}
N 1500 670 1500 650 {lab=VDD}
C {devices/lab_pin.sym} 1500 650 0 0 {name=l39 sig_type=std_logic lab=VDD}
N 1480 700 1460 700 {lab=VSS}
C {devices/lab_pin.sym} 1460 700 0 0 {name=l40 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 200 900 0 0 {name=RD0 W=1u L=2u model=ppolyf_u_1k spiceprefix=X m=1}
N 200 930 200 950 {lab=s2}
C {devices/lab_pin.sym} 200 950 0 0 {name=l41 sig_type=std_logic lab=s2}
N 200 870 200 850 {lab=s1}
C {devices/lab_pin.sym} 200 850 0 0 {name=l42 sig_type=std_logic lab=s1}
N 180 900 160 900 {lab=VSS}
C {devices/lab_pin.sym} 160 900 0 0 {name=l43 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 460 900 0 0 {name=MSA L=0.28u W=20u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 480 870 480 850 {lab=s1}
C {devices/lab_pin.sym} 480 850 0 0 {name=l44 sig_type=std_logic lab=s1}
N 440 900 420 900 {lab=GA}
C {devices/lab_pin.sym} 420 900 0 0 {name=l45 sig_type=std_logic lab=GA}
N 480 930 480 950 {lab=da}
C {devices/lab_pin.sym} 480 950 0 0 {name=l46 sig_type=std_logic lab=da}
N 480 900 500 900 {lab=VSS}
C {devices/lab_pin.sym} 500 900 0 1 {name=l47 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 720 900 0 0 {name=RDA W=1u L=3u model=ppolyf_u_1k spiceprefix=X m=1}
N 720 930 720 950 {lab=s2}
C {devices/lab_pin.sym} 720 950 0 0 {name=l48 sig_type=std_logic lab=s2}
N 720 870 720 850 {lab=da}
C {devices/lab_pin.sym} 720 850 0 0 {name=l49 sig_type=std_logic lab=da}
N 700 900 680 900 {lab=VSS}
C {devices/lab_pin.sym} 680 900 0 0 {name=l50 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 980 900 0 0 {name=MSB L=0.28u W=40u nf=8 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 1000 870 1000 850 {lab=s1}
C {devices/lab_pin.sym} 1000 850 0 0 {name=l51 sig_type=std_logic lab=s1}
N 960 900 940 900 {lab=GB}
C {devices/lab_pin.sym} 940 900 0 0 {name=l52 sig_type=std_logic lab=GB}
N 1000 930 1000 950 {lab=db}
C {devices/lab_pin.sym} 1000 950 0 0 {name=l53 sig_type=std_logic lab=db}
N 1000 900 1020 900 {lab=VSS}
C {devices/lab_pin.sym} 1020 900 0 1 {name=l54 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 1240 900 0 0 {name=RDB W=2u L=1.8u model=ppolyf_u_1k spiceprefix=X m=1}
N 1240 930 1240 950 {lab=s2}
C {devices/lab_pin.sym} 1240 950 0 0 {name=l55 sig_type=std_logic lab=s2}
N 1240 870 1240 850 {lab=db}
C {devices/lab_pin.sym} 1240 850 0 0 {name=l56 sig_type=std_logic lab=db}
N 1220 900 1200 900 {lab=VSS}
C {devices/lab_pin.sym} 1200 900 0 0 {name=l57 sig_type=std_logic lab=VSS}
C {devices/title.sym} 160 1400 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
