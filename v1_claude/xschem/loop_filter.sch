v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {2nd-order passive loop filter: R=10k, C1=60p, C2=5p (on-chip MIM); VCO tap VT from C2 via 2k / 0.75p} 100 80 0 0 0.6 0.6 {}
C {devices/iopin.sym} -100 300 0 0 {name=p0 lab=VC}
C {devices/opin.sym} -100 330 0 0 {name=p1 lab=VT}
C {devices/iopin.sym} -100 360 0 0 {name=p2 lab=VSS}
C {symbols/ppolyf_u_1k.sym} 200 300 0 0 {name=RZ W=1u L=10u model=ppolyf_u_1k spiceprefix=X m=1}
N 200 330 200 350 {lab=z}
C {devices/lab_pin.sym} 200 350 0 0 {name=l1 sig_type=std_logic lab=z}
N 200 270 200 250 {lab=VC}
C {devices/lab_pin.sym} 200 250 0 0 {name=l2 sig_type=std_logic lab=VC}
N 180 300 160 300 {lab=VSS}
C {devices/lab_pin.sym} 160 300 0 0 {name=l3 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 460 300 0 0 {name=C1 W=77e-6 L=77e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=5}
N 460 270 460 250 {lab=z}
C {devices/lab_pin.sym} 460 250 0 0 {name=l4 sig_type=std_logic lab=z}
N 460 330 460 350 {lab=VSS}
C {devices/lab_pin.sym} 460 350 0 0 {name=l5 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 720 300 0 0 {name=C2 W=49.5e-6 L=49.5e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 720 270 720 250 {lab=VC}
C {devices/lab_pin.sym} 720 250 0 0 {name=l6 sig_type=std_logic lab=VC}
N 720 330 720 350 {lab=VSS}
C {devices/lab_pin.sym} 720 350 0 0 {name=l7 sig_type=std_logic lab=VSS}
C {symbols/ppolyf_u_1k.sym} 980 300 0 0 {name=RVT W=2u L=4u model=ppolyf_u_1k spiceprefix=X m=1}
N 980 330 980 350 {lab=VT}
C {devices/lab_pin.sym} 980 350 0 0 {name=l8 sig_type=std_logic lab=VT}
N 980 270 980 250 {lab=VC}
C {devices/lab_pin.sym} 980 250 0 0 {name=l9 sig_type=std_logic lab=VC}
N 960 300 940 300 {lab=VSS}
C {devices/lab_pin.sym} 940 300 0 0 {name=l10 sig_type=std_logic lab=VSS}
C {symbols/cap_mim_2f0fF.sym} 1240 300 0 0 {name=C3 W=19.45e-6 L=19.45e-6 model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=1}
N 1240 270 1240 250 {lab=VT}
C {devices/lab_pin.sym} 1240 250 0 0 {name=l11 sig_type=std_logic lab=VT}
N 1240 330 1240 350 {lab=VSS}
C {devices/lab_pin.sym} 1240 350 0 0 {name=l12 sig_type=std_logic lab=VSS}
C {devices/title.sym} 160 800 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
