v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {tb_bias: reference current vs temperature and VDD} 100 80 0 0 0.6 0.6 {}
T {probe mirrors (unit 16u/2u NMOS, 32u/2u PMOS)} 100 390 0 0 0.4 0.4 {layer=8}
C {devices/vsource.sym} 200 300 0 0 {name=VDD value="3.3" savecurrent=false}
N 200 270 200 250 {lab=vdd}
C {devices/lab_pin.sym} 200 250 0 0 {name=l1 sig_type=std_logic lab=vdd}
N 200 330 200 350 {lab=0}
C {devices/lab_pin.sym} 200 350 0 0 {name=l2 sig_type=std_logic lab=0}
C {bias_gen.sym} 460 300 0 0 {name=XB }
N 560 270 580 270 {lab=nb}
C {devices/lab_pin.sym} 580 270 0 1 {name=l3 sig_type=std_logic lab=nb}
N 560 290 580 290 {lab=pb}
C {devices/lab_pin.sym} 580 290 0 1 {name=l4 sig_type=std_logic lab=pb}
N 560 310 580 310 {lab=vdd}
C {devices/lab_pin.sym} 580 310 0 1 {name=l5 sig_type=std_logic lab=vdd}
N 560 330 580 330 {lab=0}
C {devices/lab_pin.sym} 580 330 0 1 {name=l6 sig_type=std_logic lab=0}
C {devices/vsource.sym} 200 500 0 0 {name=VPN value="1.65" savecurrent=false}
N 200 470 200 450 {lab=pn}
C {devices/lab_pin.sym} 200 450 0 0 {name=l7 sig_type=std_logic lab=pn}
N 200 530 200 550 {lab=0}
C {devices/lab_pin.sym} 200 550 0 0 {name=l8 sig_type=std_logic lab=0}
C {symbols/nfet_03v3.sym} 460 500 0 0 {name=MPRN L=2u W=16u nf=2 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=nfet_03v3 spiceprefix=X}
N 480 470 480 450 {lab=pn}
C {devices/lab_pin.sym} 480 450 0 0 {name=l9 sig_type=std_logic lab=pn}
N 440 500 420 500 {lab=nb}
C {devices/lab_pin.sym} 420 500 0 0 {name=l10 sig_type=std_logic lab=nb}
N 480 530 480 550 {lab=0}
C {devices/lab_pin.sym} 480 550 0 0 {name=l11 sig_type=std_logic lab=0}
N 480 500 500 500 {lab=0}
C {devices/lab_pin.sym} 500 500 0 1 {name=l12 sig_type=std_logic lab=0}
C {devices/vsource.sym} 720 500 0 0 {name=VPP value="1.65" savecurrent=false}
N 720 470 720 450 {lab=vdd}
C {devices/lab_pin.sym} 720 450 0 0 {name=l13 sig_type=std_logic lab=vdd}
N 720 530 720 550 {lab=pp}
C {devices/lab_pin.sym} 720 550 0 0 {name=l14 sig_type=std_logic lab=pp}
C {symbols/pfet_03v3.sym} 980 500 0 0 {name=MPRP L=2u W=32u nf=4 m=1 ad="'int((nf+1)/2) * W/nf * 0.18u'" pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'" as="'int((nf+2)/2) * W/nf * 0.18u'" ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'" nrd="'0.18u / W'" nrs="'0.18u / W'" sa=0 sb=0 sd=0 model=pfet_03v3 spiceprefix=X}
N 1000 530 1000 550 {lab=pp}
C {devices/lab_pin.sym} 1000 550 0 0 {name=l15 sig_type=std_logic lab=pp}
N 960 500 940 500 {lab=pb}
C {devices/lab_pin.sym} 940 500 0 0 {name=l16 sig_type=std_logic lab=pb}
N 1000 470 1000 450 {lab=vdd}
C {devices/lab_pin.sym} 1000 450 0 0 {name=l17 sig_type=std_logic lab=vdd}
N 1000 500 1020 500 {lab=vdd}
C {devices/lab_pin.sym} 1020 500 0 1 {name=l18 sig_type=std_logic lab=vdd}
C {devices/code_shown.sym} 1860 300 0 0 {name=MODELS format="tcleval( @value )" only_toplevel=true value=".include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice mimcap_typical"}
C {devices/code_shown.sym} 1860 700 0 0 {name=SIM only_toplevel=true value=".control
set num_threads=1
foreach tc -40 27 85 125
 set temp=$tc
 op
 echo RES temp=$tc in=$&@m.xmprn.m0[id] ip=$&@m.xmprp.m0[id] nb=$&v(nb) pb=$&v(pb)
end
set temp=27
dc VDD 2.8 3.6 0.2
print i(VPN)
.endc"}
C {devices/title.sym} 160 1000 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
