v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {tb_vco: tuning curve (fLO = 2 x ring), KVCO, quadrature error at fLO, supply current} 100 80 0 0 0.6 0.6 {}
T {mixer switch gate load per phase (2 pF AC coupling in series with ~150 fF of gates)} 100 400 0 0 0.4 0.4 {layer=8}
C {devices/vsource.sym} 200 300 0 0 {name=VDD value="3.3" savecurrent=false}
N 200 270 200 250 {lab=vdd}
C {devices/lab_pin.sym} 200 250 0 0 {name=l1 sig_type=std_logic lab=vdd}
N 200 330 200 350 {lab=0}
C {devices/lab_pin.sym} 200 350 0 0 {name=l2 sig_type=std_logic lab=0}
C {devices/vsource.sym} 460 300 0 0 {name=VC value="1.5" savecurrent=false}
N 460 270 460 250 {lab=vctrl}
C {devices/lab_pin.sym} 460 250 0 0 {name=l3 sig_type=std_logic lab=vctrl}
N 460 330 460 350 {lab=0}
C {devices/lab_pin.sym} 460 350 0 0 {name=l4 sig_type=std_logic lab=0}
C {devices/vsource.sym} 720 300 0 0 {name=VB0 value="0" savecurrent=false}
N 720 270 720 250 {lab=b0}
C {devices/lab_pin.sym} 720 250 0 0 {name=l5 sig_type=std_logic lab=b0}
N 720 330 720 350 {lab=0}
C {devices/lab_pin.sym} 720 350 0 0 {name=l6 sig_type=std_logic lab=0}
C {devices/vsource.sym} 980 300 0 0 {name=VB1 value="0" savecurrent=false}
N 980 270 980 250 {lab=b1}
C {devices/lab_pin.sym} 980 250 0 0 {name=l7 sig_type=std_logic lab=b1}
N 980 330 980 350 {lab=0}
C {devices/lab_pin.sym} 980 350 0 0 {name=l8 sig_type=std_logic lab=0}
C {bias_gen.sym} 1240 300 0 0 {name=XB }
N 1340 270 1360 270 {lab=nb}
C {devices/lab_pin.sym} 1360 270 0 1 {name=l9 sig_type=std_logic lab=nb}
N 1340 290 1360 290 {lab=pb}
C {devices/lab_pin.sym} 1360 290 0 1 {name=l10 sig_type=std_logic lab=pb}
N 1340 310 1360 310 {lab=vdd}
C {devices/lab_pin.sym} 1360 310 0 1 {name=l11 sig_type=std_logic lab=vdd}
N 1340 330 1360 330 {lab=0}
C {devices/lab_pin.sym} 1360 330 0 1 {name=l12 sig_type=std_logic lab=0}
C {vco_ring4.sym} 1500 300 0 0 {name=XVCO }
N 1400 190 1380 190 {lab=vctrl}
C {devices/lab_pin.sym} 1380 190 0 0 {name=l13 sig_type=std_logic lab=vctrl}
N 1400 210 1380 210 {lab=b0}
C {devices/lab_pin.sym} 1380 210 0 0 {name=l14 sig_type=std_logic lab=b0}
N 1400 230 1380 230 {lab=b1}
C {devices/lab_pin.sym} 1380 230 0 0 {name=l15 sig_type=std_logic lab=b1}
N 1400 250 1380 250 {lab=nb}
C {devices/lab_pin.sym} 1380 250 0 0 {name=l16 sig_type=std_logic lab=nb}
N 1600 190 1620 190 {lab=l1p}
C {devices/lab_pin.sym} 1620 190 0 1 {name=l17 sig_type=std_logic lab=l1p}
N 1600 210 1620 210 {lab=l1n}
C {devices/lab_pin.sym} 1620 210 0 1 {name=l18 sig_type=std_logic lab=l1n}
N 1600 230 1620 230 {lab=l2p}
C {devices/lab_pin.sym} 1620 230 0 1 {name=l19 sig_type=std_logic lab=l2p}
N 1600 250 1620 250 {lab=l2n}
C {devices/lab_pin.sym} 1620 250 0 1 {name=l20 sig_type=std_logic lab=l2n}
N 1600 270 1620 270 {lab=l3p}
C {devices/lab_pin.sym} 1620 270 0 1 {name=l21 sig_type=std_logic lab=l3p}
N 1600 290 1620 290 {lab=l3n}
C {devices/lab_pin.sym} 1620 290 0 1 {name=l22 sig_type=std_logic lab=l3n}
N 1600 310 1620 310 {lab=l4p}
C {devices/lab_pin.sym} 1620 310 0 1 {name=l23 sig_type=std_logic lab=l4p}
N 1600 330 1620 330 {lab=l4n}
C {devices/lab_pin.sym} 1620 330 0 1 {name=l24 sig_type=std_logic lab=l4n}
N 1600 350 1620 350 {lab=ckr}
C {devices/lab_pin.sym} 1620 350 0 1 {name=l25 sig_type=std_logic lab=ckr}
N 1600 370 1620 370 {lab=vr}
C {devices/lab_pin.sym} 1620 370 0 1 {name=l26 sig_type=std_logic lab=vr}
N 1600 390 1620 390 {lab=vdd}
C {devices/lab_pin.sym} 1620 390 0 1 {name=l27 sig_type=std_logic lab=vdd}
N 1600 410 1620 410 {lab=0}
C {devices/lab_pin.sym} 1620 410 0 1 {name=l28 sig_type=std_logic lab=0}
C {devices/capa.sym} 200 520 0 0 {name=CLl1p value=150f footprint=1206 device=capacitor m=1}
N 200 490 200 470 {lab=l1p}
C {devices/lab_pin.sym} 200 470 0 0 {name=l29 sig_type=std_logic lab=l1p}
N 200 550 200 570 {lab=0}
C {devices/lab_pin.sym} 200 570 0 0 {name=l30 sig_type=std_logic lab=0}
C {devices/capa.sym} 460 520 0 0 {name=CLl1n value=150f footprint=1206 device=capacitor m=1}
N 460 490 460 470 {lab=l1n}
C {devices/lab_pin.sym} 460 470 0 0 {name=l31 sig_type=std_logic lab=l1n}
N 460 550 460 570 {lab=0}
C {devices/lab_pin.sym} 460 570 0 0 {name=l32 sig_type=std_logic lab=0}
C {devices/capa.sym} 720 520 0 0 {name=CLl2p value=150f footprint=1206 device=capacitor m=1}
N 720 490 720 470 {lab=l2p}
C {devices/lab_pin.sym} 720 470 0 0 {name=l33 sig_type=std_logic lab=l2p}
N 720 550 720 570 {lab=0}
C {devices/lab_pin.sym} 720 570 0 0 {name=l34 sig_type=std_logic lab=0}
C {devices/capa.sym} 980 520 0 0 {name=CLl2n value=150f footprint=1206 device=capacitor m=1}
N 980 490 980 470 {lab=l2n}
C {devices/lab_pin.sym} 980 470 0 0 {name=l35 sig_type=std_logic lab=l2n}
N 980 550 980 570 {lab=0}
C {devices/lab_pin.sym} 980 570 0 0 {name=l36 sig_type=std_logic lab=0}
C {devices/capa.sym} 1240 520 0 0 {name=CLl3p value=150f footprint=1206 device=capacitor m=1}
N 1240 490 1240 470 {lab=l3p}
C {devices/lab_pin.sym} 1240 470 0 0 {name=l37 sig_type=std_logic lab=l3p}
N 1240 550 1240 570 {lab=0}
C {devices/lab_pin.sym} 1240 570 0 0 {name=l38 sig_type=std_logic lab=0}
C {devices/capa.sym} 1500 520 0 0 {name=CLl3n value=150f footprint=1206 device=capacitor m=1}
N 1500 490 1500 470 {lab=l3n}
C {devices/lab_pin.sym} 1500 470 0 0 {name=l39 sig_type=std_logic lab=l3n}
N 1500 550 1500 570 {lab=0}
C {devices/lab_pin.sym} 1500 570 0 0 {name=l40 sig_type=std_logic lab=0}
C {devices/capa.sym} 200 710 0 0 {name=CLl4p value=150f footprint=1206 device=capacitor m=1}
N 200 680 200 660 {lab=l4p}
C {devices/lab_pin.sym} 200 660 0 0 {name=l41 sig_type=std_logic lab=l4p}
N 200 740 200 760 {lab=0}
C {devices/lab_pin.sym} 200 760 0 0 {name=l42 sig_type=std_logic lab=0}
C {devices/capa.sym} 460 710 0 0 {name=CLl4n value=150f footprint=1206 device=capacitor m=1}
N 460 680 460 660 {lab=l4n}
C {devices/lab_pin.sym} 460 660 0 0 {name=l43 sig_type=std_logic lab=l4n}
N 460 740 460 760 {lab=0}
C {devices/lab_pin.sym} 460 760 0 0 {name=l44 sig_type=std_logic lab=0}
C {devices/code_shown.sym} 1860 300 0 0 {name=MODELS format="tcleval( @value )" only_toplevel=true value=".include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice mimcap_typical"}
C {devices/code_shown.sym} 1860 700 0 0 {name=SIM only_toplevel=true value=".option method=gear reltol=1e-4
.ic v(xvco.xcore.p4)=0 v(xvco.xcore.n4)=2
.control
set num_threads=1
let vlist = vector(9)*0.25+0.8
let k = 0
while k < 9
 let vv = vlist[k]
 alter VC dc = vv
 tran 2p 70n uic
 meas tran ta when v(l1p)=v(l1n) rise=1 td=55n
 meas tran tb when v(l1p)=v(l1n) rise=5 td=55n
 meas tran tq when v(l2p)=v(l2n) rise=1 td=55n
 meas tran ivdd avg i(VDD) from=55n to=70n
 meas tran vravg avg v(vr) from=55n to=70n
 let f = 8/(tb-ta)
 let qerr = ((tq-ta)*f/2 - floor((tq-ta)*f/2))*720 - 90
 echo RES vc=$&vv f=$&f qerr=$&qerr ivdd=$&ivdd vr=$&vravg
 let k = k + 1
end
.endc"}
C {devices/title.sym} 160 1210 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
