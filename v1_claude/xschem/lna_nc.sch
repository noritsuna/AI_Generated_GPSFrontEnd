v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {Noise-cancelling CG-CS balun LNA (no inductor): 50 ohm SE in, differential out} 100 80 0 0 0.6 0.6 {}
T {CG matching device M1 + source resistor RS (300 ohm) + load R1 (200 ohm)} 100 190 0 0 0.4 0.4 {layer=8}
T {CS noise-cancelling device M2 (AC-coupled gate) + load R2 = R1/n} 100 390 0 0 0.4 0.4 {layer=8}
T {replica bias: M1r = M1/10 with RS*10, M2r = M2/40 (PB mirrors 300 uA / 250 uA)} 100 590 0 0 0.4 0.4 {layer=8}
T {bias decoupling + output AC coupling to the mixer} 100 790 0 0 0.4 0.4 {layer=8}
C {devices/ipin.sym} -100 300 0 0 {name=p0 lab=RFIN}
C {devices/ipin.sym} -100 330 0 0 {name=p1 lab=PB}
C {devices/opin.sym} -100 360 0 0 {name=p2 lab=OUTP}
C {devices/opin.sym} -100 390 0 0 {name=p3 lab=OUTN}
C {devices/iopin.sym} -100 420 0 0 {name=p4 lab=VDD}
C {devices/iopin.sym} -100 450 0 0 {name=p5 lab=VSS}
C {symbols/nfet_03v3.sym} 200 300 0 0 {name=M1 L=0.28u W=40u nf=8 m=3 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 220 270 220 250 {lab=op_i}
C {devices/lab_pin.sym} 220 250 0 0 {name=l1 sig_type=std_logic lab=op_i}
N 180 300 160 300 {lab=vb1}
C {devices/lab_pin.sym} 160 300 0 0 {name=l2 sig_type=std_logic lab=vb1}
N 220 330 220 350 {lab=RFIN}
C {devices/lab_pin.sym} 220 350 0 0 {name=l3 sig_type=std_logic lab=RFIN}
N 220 300 240 300 {lab=VSS}
C {devices/lab_pin.sym} 240 300 0 1 {name=l4 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 480 300 0 0 {name=RS W=10u L=3u model=ppolyf_u_1k spiceprefix=X m=1}
N 480 330 480 350 {lab=VSS}
C {devices/lab_pin.sym} 480 350 0 0 {name=l5 sig_type=std_logic lab=VSS}
N 480 270 480 250 {lab=RFIN}
C {devices/lab_pin.sym} 480 250 0 0 {name=l6 sig_type=std_logic lab=RFIN}
N 460 300 440 300 {lab=VSS}
C {devices/lab_pin.sym} 440 300 0 0 {name=l7 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 760 300 0 0 {name=R1 W=10u L=2u model=ppolyf_u_1k spiceprefix=X m=1}
N 760 330 760 350 {lab=op_i}
C {devices/lab_pin.sym} 760 350 0 0 {name=l8 sig_type=std_logic lab=op_i}
N 760 270 760 250 {lab=VDD}
C {devices/lab_pin.sym} 760 250 0 0 {name=l9 sig_type=std_logic lab=VDD}
N 740 300 720 300 {lab=VSS}
C {devices/lab_pin.sym} 720 300 0 0 {name=l10 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 200 500 0 0 {name=CC2 W=45e-6 L=45e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 200 470 200 450 {lab=RFIN}
C {devices/lab_pin.sym} 200 450 0 0 {name=l11 sig_type=std_logic lab=RFIN}
N 200 530 200 550 {lab=g2}
C {devices/lab_pin.sym} 200 550 0 0 {name=l12 sig_type=std_logic lab=g2}
C {symbols/ppolyf_u_1k.sym} 480 500 0 0 {name=RB2 W=1u L=10u model=ppolyf_u_1k spiceprefix=X m=1}
N 480 530 480 550 {lab=vb2}
C {devices/lab_pin.sym} 480 550 0 0 {name=l13 sig_type=std_logic lab=vb2}
N 480 470 480 450 {lab=g2}
C {devices/lab_pin.sym} 480 450 0 0 {name=l14 sig_type=std_logic lab=g2}
N 460 500 440 500 {lab=VSS}
C {devices/lab_pin.sym} 440 500 0 0 {name=l15 sig_type=std_logic lab=VSS}
C {symbols/nfet_03v3.sym} 760 500 0 0 {name=M2 L=0.28u W=40u nf=8 m=8 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 780 470 780 450 {lab=on_i}
C {devices/lab_pin.sym} 780 450 0 0 {name=l16 sig_type=std_logic lab=on_i}
N 740 500 720 500 {lab=g2}
C {devices/lab_pin.sym} 720 500 0 0 {name=l17 sig_type=std_logic lab=g2}
N 780 530 780 550 {lab=VSS}
C {devices/lab_pin.sym} 780 550 0 0 {name=l18 sig_type=std_logic lab=VSS}
N 780 500 800 500 {lab=VSS}
C {devices/lab_pin.sym} 800 500 0 1 {name=l19 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 1040 500 0 0 {name=R2 W=30u L=2.17u model=ppolyf_u_1k spiceprefix=X m=1}
N 1040 530 1040 550 {lab=on_i}
C {devices/lab_pin.sym} 1040 550 0 0 {name=l20 sig_type=std_logic lab=on_i}
N 1040 470 1040 450 {lab=VDD}
C {devices/lab_pin.sym} 1040 450 0 0 {name=l21 sig_type=std_logic lab=VDD}
N 1020 500 1000 500 {lab=VSS}
C {devices/lab_pin.sym} 1000 500 0 0 {name=l22 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 200 700 0 0 {name=MP1 L=2u W=32u nf=4 m=6 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 220 730 220 750 {lab=vb1}
C {devices/lab_pin.sym} 220 750 0 0 {name=l23 sig_type=std_logic lab=vb1}
N 180 700 160 700 {lab=PB}
C {devices/lab_pin.sym} 160 700 0 0 {name=l24 sig_type=std_logic lab=PB}
N 220 670 220 650 {lab=VDD}
C {devices/lab_pin.sym} 220 650 0 0 {name=l25 sig_type=std_logic lab=VDD}
N 220 700 240 700 {lab=VDD}
C {devices/lab_pin.sym} 240 700 0 1 {name=l26 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 480 700 0 0 {name=M1R L=0.28u W=12u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 500 670 500 650 {lab=vb1}
C {devices/lab_pin.sym} 500 650 0 0 {name=l27 sig_type=std_logic lab=vb1}
N 460 700 440 700 {lab=vb1}
C {devices/lab_pin.sym} 440 700 0 0 {name=l28 sig_type=std_logic lab=vb1}
N 500 730 500 750 {lab=s1r}
C {devices/lab_pin.sym} 500 750 0 0 {name=l29 sig_type=std_logic lab=s1r}
N 500 700 520 700 {lab=VSS}
C {devices/lab_pin.sym} 520 700 0 1 {name=l30 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 760 700 0 0 {name=RSR W=1u L=3u model=ppolyf_u_1k spiceprefix=X m=1}
N 760 730 760 750 {lab=VSS}
C {devices/lab_pin.sym} 760 750 0 0 {name=l31 sig_type=std_logic lab=VSS}
N 760 670 760 650 {lab=s1r}
C {devices/lab_pin.sym} 760 650 0 0 {name=l32 sig_type=std_logic lab=s1r}
N 740 700 720 700 {lab=VSS}
C {devices/lab_pin.sym} 720 700 0 0 {name=l33 sig_type=std_logic lab=VSS}
C {symbols/pfet_03v3.sym} 1040 700 0 0 {name=MP2 L=2u W=32u nf=4 m=5 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1060 730 1060 750 {lab=vb2}
C {devices/lab_pin.sym} 1060 750 0 0 {name=l34 sig_type=std_logic lab=vb2}
N 1020 700 1000 700 {lab=PB}
C {devices/lab_pin.sym} 1000 700 0 0 {name=l35 sig_type=std_logic lab=PB}
N 1060 670 1060 650 {lab=VDD}
C {devices/lab_pin.sym} 1060 650 0 0 {name=l36 sig_type=std_logic lab=VDD}
N 1060 700 1080 700 {lab=VDD}
C {devices/lab_pin.sym} 1080 700 0 1 {name=l37 sig_type=std_logic lab=VDD}
C {symbols/nfet_03v3.sym} 1320 700 0 0 {name=M2R L=0.28u W=8u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 1340 670 1340 650 {lab=vb2}
C {devices/lab_pin.sym} 1340 650 0 0 {name=l38 sig_type=std_logic lab=vb2}
N 1300 700 1280 700 {lab=vb2}
C {devices/lab_pin.sym} 1280 700 0 0 {name=l39 sig_type=std_logic lab=vb2}
N 1340 730 1340 750 {lab=VSS}
C {devices/lab_pin.sym} 1340 750 0 0 {name=l40 sig_type=std_logic lab=VSS}
N 1340 700 1360 700 {lab=VSS}
C {devices/lab_pin.sym} 1360 700 0 1 {name=l41 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 200 900 0 0 {name=CB1 W=50e-6 L=50e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 200 870 200 850 {lab=vb1}
C {devices/lab_pin.sym} 200 850 0 0 {name=l42 sig_type=std_logic lab=vb1}
N 200 930 200 950 {lab=VSS}
C {devices/lab_pin.sym} 200 950 0 0 {name=l43 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 480 900 0 0 {name=CB2 W=50e-6 L=50e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 480 870 480 850 {lab=vb2}
C {devices/lab_pin.sym} 480 850 0 0 {name=l44 sig_type=std_logic lab=vb2}
N 480 930 480 950 {lab=VSS}
C {devices/lab_pin.sym} 480 950 0 0 {name=l45 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 760 900 0 0 {name=COP W=45e-6 L=45e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 760 870 760 850 {lab=op_i}
C {devices/lab_pin.sym} 760 850 0 0 {name=l46 sig_type=std_logic lab=op_i}
N 760 930 760 950 {lab=OUTP}
C {devices/lab_pin.sym} 760 950 0 0 {name=l47 sig_type=std_logic lab=OUTP}
C {symbols/cap_mim_2f0fF.sym} 1040 900 0 0 {name=CON W=45e-6 L=45e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 1040 870 1040 850 {lab=on_i}
C {devices/lab_pin.sym} 1040 850 0 0 {name=l48 sig_type=std_logic lab=on_i}
N 1040 930 1040 950 {lab=OUTN}
C {devices/lab_pin.sym} 1040 950 0 0 {name=l49 sig_type=std_logic lab=OUTN}
C {devices/title.sym} 160 1400 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
