v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {tb_pll: closed-loop transistor-level PLL lock (TCXO 16.368 MHz clipped sine)} 100 80 0 0 0.6 0.6 {}
T {mixer LO load + ADC clock load} 100 600 0 0 0.4 0.4 {layer=8}
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
C {devices/vsource.sym} 720 300 0 0 {name=VREF value="sin(1.65 0.4 16.368e6)" savecurrent=false}
N 720 270 720 250 {lab=refin}
C {devices/lab_pin.sym} 720 250 0 0 {name=l7 sig_type=std_logic lab=refin}
N 720 330 720 350 {lab=0}
C {devices/lab_pin.sym} 720 350 0 0 {name=l8 sig_type=std_logic lab=0}
C {devices/vsource.sym} 980 300 0 0 {name=VB0 value="0" savecurrent=false}
N 980 270 980 250 {lab=b0}
C {devices/lab_pin.sym} 980 250 0 0 {name=l9 sig_type=std_logic lab=b0}
N 980 330 980 350 {lab=0}
C {devices/lab_pin.sym} 980 350 0 0 {name=l10 sig_type=std_logic lab=0}
C {devices/vsource.sym} 1240 300 0 0 {name=VB1 value="0" savecurrent=false}
N 1240 270 1240 250 {lab=b1}
C {devices/lab_pin.sym} 1240 250 0 0 {name=l11 sig_type=std_logic lab=b1}
N 1240 330 1240 350 {lab=0}
C {devices/lab_pin.sym} 1240 350 0 0 {name=l12 sig_type=std_logic lab=0}
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
C {devices/vsource.sym} 200 520 0 0 {name=VICP2 value="0" savecurrent=false}
N 200 490 200 470 {lab=icp2}
C {devices/lab_pin.sym} 200 470 0 0 {name=l29 sig_type=std_logic lab=icp2}
N 200 550 200 570 {lab=0}
C {devices/lab_pin.sym} 200 570 0 0 {name=l30 sig_type=std_logic lab=0}
C {refbuf.sym} 460 510 0 0 {name=XRB }
N 360 490 340 490 {lab=refin}
C {devices/lab_pin.sym} 340 490 0 0 {name=l31 sig_type=std_logic lab=refin}
N 560 490 580 490 {lab=refck}
C {devices/lab_pin.sym} 580 490 0 1 {name=l32 sig_type=std_logic lab=refck}
N 560 510 580 510 {lab=vdd}
C {devices/lab_pin.sym} 580 510 0 1 {name=l33 sig_type=std_logic lab=vdd}
N 560 530 580 530 {lab=0}
C {devices/lab_pin.sym} 580 530 0 1 {name=l34 sig_type=std_logic lab=0}
C {pll_core.sym} 720 530 0 0 {name=XPLL }
N 620 490 600 490 {lab=refck}
C {devices/lab_pin.sym} 600 490 0 0 {name=l35 sig_type=std_logic lab=refck}
N 620 510 600 510 {lab=ckr}
C {devices/lab_pin.sym} 600 510 0 0 {name=l36 sig_type=std_logic lab=ckr}
N 620 530 600 530 {lab=nb}
C {devices/lab_pin.sym} 600 530 0 0 {name=l37 sig_type=std_logic lab=nb}
N 620 550 600 550 {lab=pb}
C {devices/lab_pin.sym} 600 550 0 0 {name=l38 sig_type=std_logic lab=pb}
N 620 570 600 570 {lab=icp2}
C {devices/lab_pin.sym} 600 570 0 0 {name=l39 sig_type=std_logic lab=icp2}
N 820 490 840 490 {lab=vctrl}
C {devices/lab_pin.sym} 840 490 0 1 {name=l40 sig_type=std_logic lab=vctrl}
N 820 510 840 510 {lab=fs}
C {devices/lab_pin.sym} 840 510 0 1 {name=l41 sig_type=std_logic lab=fs}
N 820 530 840 530 {lab=fb}
C {devices/lab_pin.sym} 840 530 0 1 {name=l42 sig_type=std_logic lab=fb}
N 820 550 840 550 {lab=vdd}
C {devices/lab_pin.sym} 840 550 0 1 {name=l43 sig_type=std_logic lab=vdd}
N 820 570 840 570 {lab=0}
C {devices/lab_pin.sym} 840 570 0 1 {name=l44 sig_type=std_logic lab=0}
C {devices/capa.sym} 200 710 0 0 {name=CLl1p value=150f footprint=1206 device=capacitor m=1}
N 200 680 200 660 {lab=l1p}
C {devices/lab_pin.sym} 200 660 0 0 {name=l45 sig_type=std_logic lab=l1p}
N 200 740 200 760 {lab=0}
C {devices/lab_pin.sym} 200 760 0 0 {name=l46 sig_type=std_logic lab=0}
C {devices/capa.sym} 460 710 0 0 {name=CLl1n value=150f footprint=1206 device=capacitor m=1}
N 460 680 460 660 {lab=l1n}
C {devices/lab_pin.sym} 460 660 0 0 {name=l47 sig_type=std_logic lab=l1n}
N 460 740 460 760 {lab=0}
C {devices/lab_pin.sym} 460 760 0 0 {name=l48 sig_type=std_logic lab=0}
C {devices/capa.sym} 720 710 0 0 {name=CLl2p value=150f footprint=1206 device=capacitor m=1}
N 720 680 720 660 {lab=l2p}
C {devices/lab_pin.sym} 720 660 0 0 {name=l49 sig_type=std_logic lab=l2p}
N 720 740 720 760 {lab=0}
C {devices/lab_pin.sym} 720 760 0 0 {name=l50 sig_type=std_logic lab=0}
C {devices/capa.sym} 980 710 0 0 {name=CLl2n value=150f footprint=1206 device=capacitor m=1}
N 980 680 980 660 {lab=l2n}
C {devices/lab_pin.sym} 980 660 0 0 {name=l51 sig_type=std_logic lab=l2n}
N 980 740 980 760 {lab=0}
C {devices/lab_pin.sym} 980 760 0 0 {name=l52 sig_type=std_logic lab=0}
C {devices/capa.sym} 1240 710 0 0 {name=CLl3p value=150f footprint=1206 device=capacitor m=1}
N 1240 680 1240 660 {lab=l3p}
C {devices/lab_pin.sym} 1240 660 0 0 {name=l53 sig_type=std_logic lab=l3p}
N 1240 740 1240 760 {lab=0}
C {devices/lab_pin.sym} 1240 760 0 0 {name=l54 sig_type=std_logic lab=0}
C {devices/capa.sym} 1500 710 0 0 {name=CLl3n value=150f footprint=1206 device=capacitor m=1}
N 1500 680 1500 660 {lab=l3n}
C {devices/lab_pin.sym} 1500 660 0 0 {name=l55 sig_type=std_logic lab=l3n}
N 1500 740 1500 760 {lab=0}
C {devices/lab_pin.sym} 1500 760 0 0 {name=l56 sig_type=std_logic lab=0}
C {devices/capa.sym} 200 910 0 0 {name=CLl4p value=150f footprint=1206 device=capacitor m=1}
N 200 880 200 860 {lab=l4p}
C {devices/lab_pin.sym} 200 860 0 0 {name=l57 sig_type=std_logic lab=l4p}
N 200 940 200 960 {lab=0}
C {devices/lab_pin.sym} 200 960 0 0 {name=l58 sig_type=std_logic lab=0}
C {devices/capa.sym} 460 910 0 0 {name=CLl4n value=150f footprint=1206 device=capacitor m=1}
N 460 880 460 860 {lab=l4n}
C {devices/lab_pin.sym} 460 860 0 0 {name=l59 sig_type=std_logic lab=l4n}
N 460 940 460 960 {lab=0}
C {devices/lab_pin.sym} 460 960 0 0 {name=l60 sig_type=std_logic lab=0}
C {devices/capa.sym} 720 910 0 0 {name=CFS value=300f footprint=1206 device=capacitor m=1}
N 720 880 720 860 {lab=fs}
C {devices/lab_pin.sym} 720 860 0 0 {name=l61 sig_type=std_logic lab=fs}
N 720 940 720 960 {lab=0}
C {devices/lab_pin.sym} 720 960 0 0 {name=l62 sig_type=std_logic lab=0}
C {devices/code_shown.sym} 1860 300 0 0 {name=MODELS format="tcleval( @value )" only_toplevel=true value=".include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice mimcap_typical"}
C {devices/code_shown.sym} 1860 700 0 0 {name=SIM only_toplevel=true value=".option method=gear reltol=2e-4
.ic v(vctrl)=1.7 v(xpll.xlf.z)=1.7 v(xpll.vcp)=1.7 v(xvco.xcore.p4)=0 v(xvco.xcore.n4)=2
.control
set num_threads=1
save v(vctrl) v(fb) v(refck) v(fs) v(l1p)
tran 5p 4u 0 5p uic
wrdata tb_pll_vctrl v(vctrl)
meas tran vc_end avg v(vctrl) from=3.5u to=4u
meas tran vc_pp pp v(vctrl) from=3.5u to=4u
meas tran t1 when v(fs)=1.65 rise=25
meas tran t2 when v(fs)=1.65 rise=55
let ffs = 30/(t2-t1)
let flo = ffs*96
meas tran r1 when v(refck)=1.65 rise=60
meas tran b1 when v(fb)=1.65 rise=60
let tpe = b1-r1
echo RES vc_end=$&vc_end vc_pp=$&vc_pp flo=$&flo phase_err_s=$&tpe
.endc"}
C {devices/title.sym} 160 1410 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
