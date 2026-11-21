v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {tb_ifadc: SPI -> IF chain (I) -> 2-bit ADC; 4.092 MHz tone + white noise at mixer-output level} 100 80 0 0 0.6 0.6 {}
T {IF chain + ADC (16.368 MHz clock)} 100 800 0 0 0.4 0.4 {layer=8}
C {devices/vsource.sym} 200 300 0 0 {name=VDD value="pwl(0 0 0.5137u 3.3)" savecurrent=false}
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
C {devices/vsource.sym} 720 300 0 0 {name=VTP value="dc 2.0 sin(2.0 92u 4.13e6)" savecurrent=false}
N 720 270 720 250 {lab=inp0}
C {devices/lab_pin.sym} 720 250 0 0 {name=l7 sig_type=std_logic lab=inp0}
N 720 330 720 350 {lab=0}
C {devices/lab_pin.sym} 720 350 0 0 {name=l8 sig_type=std_logic lab=0}
C {devices/vsource.sym} 980 300 0 0 {name=VNP value="dc 0 trnoise(0.56m 19.73n 0 0)" savecurrent=false}
N 980 270 980 250 {lab=inp}
C {devices/lab_pin.sym} 980 250 0 0 {name=l9 sig_type=std_logic lab=inp}
N 980 330 980 350 {lab=inp0}
C {devices/lab_pin.sym} 980 350 0 0 {name=l10 sig_type=std_logic lab=inp0}
C {devices/vsource.sym} 1240 300 0 0 {name=VTN value="dc 2.0 sin(2.0 92u 4.13e6 0 0 180)" savecurrent=false}
N 1240 270 1240 250 {lab=inn0}
C {devices/lab_pin.sym} 1240 250 0 0 {name=l11 sig_type=std_logic lab=inn0}
N 1240 330 1240 350 {lab=0}
C {devices/lab_pin.sym} 1240 350 0 0 {name=l12 sig_type=std_logic lab=0}
C {devices/vsource.sym} 1500 300 0 0 {name=VNN value="dc 0 trnoise(0.56m 19.73n 0 0)" savecurrent=false}
N 1500 270 1500 250 {lab=inn}
C {devices/lab_pin.sym} 1500 250 0 0 {name=l13 sig_type=std_logic lab=inn}
N 1500 330 1500 350 {lab=inn0}
C {devices/lab_pin.sym} 1500 350 0 0 {name=l14 sig_type=std_logic lab=inn0}
C {devices/vsource.sym} 200 500 0 0 {name=VSCLK value="pwl(0 0 4.1e-06 0 4.102e-06 3.3 4.15e-06 3.3 4.152e-06 0 4.2e-06 0 4.202e-06 3.3 4.25e-06 3.3 4.252e-06 0 4.3e-06 0 4.302e-06 3.3 4.35e-06 3.3 4.352e-06 0 4.4e-06 0 4.402e-06 3.3 4.45e-06 3.3 4.452e-06 0 4.5e-06 0 4.502e-06 3.3 4.55e-06 3.3 4.552e-06 0 4.6e-06 0 4.602e-06 3.3 4.65e-06 3.3 4.652e-06 0 4.7e-06 0 4.702e-06 3.3 4.75e-06 3.3 4.752e-06 0 4.8e-06 0 4.802e-06 3.3 4.85e-06 3.3 4.852e-06 0 4.9e-06 0 4.902e-06 3.3 4.95e-06 3.3 4.952e-06 0 5e-06 0 5.002e-06 3.3 5.05e-06 3.3 5.052e-06 0 5.1e-06 0 5.102e-06 3.3 5.15e-06 3.3 5.152e-06 0 5.2e-06 0 5.202e-06 3.3 5.25e-06 3.3 5.252e-06 0 5.3e-06 0 5.302e-06 3.3 5.35e-06 3.3 5.352e-06 0 5.4e-06 0 5.402e-06 3.3 5.45e-06 3.3 5.452e-06 0 5.5e-06 0 5.502e-06 3.3 5.55e-06 3.3 5.552e-06 0 5.6e-06 0 5.602e-06 3.3 5.65e-06 3.3 5.652e-06 0 5.7e-06 0 5.702e-06 3.3 5.75e-06 3.3 5.752e-06 0 5.8e-06 0 5.802e-06 3.3 5.85e-06 3.3 5.852e-06 0 5.9e-06 0 5.902e-06 3.3 5.95e-06 3.3 5.952e-06 0 6e-06 0 6.002e-06 3.3 6.05e-06 3.3 6.052e-06 0 6.1e-06 0 6.102e-06 3.3 6.15e-06 3.3 6.152e-06 0 6.2e-06 0 6.202e-06 3.3 6.25e-06 3.3 6.252e-06 0 6.3e-06 0 6.302e-06 3.3 6.35e-06 3.3 6.352e-06 0 6.4e-06 0 6.402e-06 3.3 6.45e-06 3.3 6.452e-06 0 4.01e-05 0 4.0102e-05 3.3 4.015e-05 3.3 4.0152e-05 0 4.02e-05 0 4.0202e-05 3.3 4.025e-05 3.3 4.0252e-05 0 4.03e-05 0 4.0302e-05 3.3 4.035e-05 3.3 4.0352e-05 0 4.04e-05 0 4.0402e-05 3.3 4.045e-05 3.3 4.0452e-05 0 4.05e-05 0 4.0502e-05 3.3 4.055e-05 3.3 4.0552e-05 0 4.06e-05 0 4.0602e-05 3.3 4.065e-05 3.3 4.0652e-05 0 4.07e-05 0 4.0702e-05 3.3 4.075e-05 3.3 4.0752e-05 0 4.08e-05 0 4.0802e-05 3.3 4.085e-05 3.3 4.0852e-05 0 4.09e-05 0 4.0902e-05 3.3 4.095e-05 3.3 4.0952e-05 0 4.1e-05 0 4.1002e-05 3.3 4.105e-05 3.3 4.1052e-05 0 4.11e-05 0 4.1102e-05 3.3 4.115e-05 3.3 4.1152e-05 0 4.12e-05 0 4.1202e-05 3.3 4.125e-05 3.3 4.1252e-05 0 4.13e-05 0 4.1302e-05 3.3 4.135e-05 3.3 4.1352e-05 0 4.14e-05 0 4.1402e-05 3.3 4.145e-05 3.3 4.1452e-05 0 4.15e-05 0 4.1502e-05 3.3 4.155e-05 3.3 4.1552e-05 0 4.16e-05 0 4.1602e-05 3.3 4.165e-05 3.3 4.1652e-05 0 4.17e-05 0 4.1702e-05 3.3 4.175e-05 3.3 4.1752e-05 0 4.18e-05 0 4.1802e-05 3.3 4.185e-05 3.3 4.1852e-05 0 4.19e-05 0 4.1902e-05 3.3 4.195e-05 3.3 4.1952e-05 0 4.2e-05 0 4.2002e-05 3.3 4.205e-05 3.3 4.2052e-05 0 4.21e-05 0 4.2102e-05 3.3 4.215e-05 3.3 4.2152e-05 0 4.22e-05 0 4.2202e-05 3.3 4.225e-05 3.3 4.2252e-05 0 4.23e-05 0 4.2302e-05 3.3 4.235e-05 3.3 4.2352e-05 0 4.24e-05 0 4.2402e-05 3.3 4.245e-05 3.3 4.2452e-05 0)" savecurrent=false}
N 200 470 200 450 {lab=sclk}
C {devices/lab_pin.sym} 200 450 0 0 {name=l15 sig_type=std_logic lab=sclk}
N 200 530 200 550 {lab=0}
C {devices/lab_pin.sym} 200 550 0 0 {name=l16 sig_type=std_logic lab=0}
C {devices/vsource.sym} 460 500 0 0 {name=VSDI value="pwl(0 0 4.05e-06 0 4.052e-06 0 4.15e-06 0 4.152e-06 0 4.25e-06 0 4.252e-06 0 4.35e-06 0 4.352e-06 0 4.45e-06 0 4.452e-06 0 4.55e-06 0 4.552e-06 0 4.65e-06 0 4.652e-06 0 4.75e-06 0 4.752e-06 0 4.85e-06 0 4.852e-06 0 4.95e-06 0 4.952e-06 0 5.05e-06 0 5.052e-06 0 5.15e-06 0 5.152e-06 0 5.25e-06 0 5.252e-06 0 5.35e-06 0 5.352e-06 0 5.45e-06 0 5.452e-06 0 5.55e-06 0 5.552e-06 0 5.65e-06 0 5.652e-06 0 5.75e-06 0 5.752e-06 0 5.85e-06 0 5.852e-06 0 5.95e-06 0 5.952e-06 3.3 6.05e-06 3.3 6.052e-06 0 6.15e-06 0 6.152e-06 3.3 6.25e-06 3.3 6.252e-06 0 6.35e-06 0 6.352e-06 3.3 4.005e-05 0 4.0052e-05 0 4.015e-05 0 4.0152e-05 0 4.025e-05 0 4.0252e-05 0 4.035e-05 0 4.0352e-05 0 4.045e-05 0 4.0452e-05 0 4.055e-05 0 4.0552e-05 0 4.065e-05 0 4.0652e-05 0 4.075e-05 0 4.0752e-05 0 4.085e-05 0 4.0852e-05 0 4.095e-05 0 4.0952e-05 0 4.105e-05 0 4.1052e-05 0 4.115e-05 0 4.1152e-05 0 4.125e-05 0 4.1252e-05 0 4.135e-05 0 4.1352e-05 0 4.145e-05 0 4.1452e-05 0 4.155e-05 0 4.1552e-05 0 4.165e-05 0 4.1652e-05 0 4.175e-05 0 4.1752e-05 0 4.185e-05 0 4.1852e-05 0 4.195e-05 0 4.1952e-05 0 4.205e-05 0 4.2052e-05 0 4.215e-05 0 4.2152e-05 0 4.225e-05 0 4.2252e-05 0 4.235e-05 0 4.2352e-05 0)" savecurrent=false}
N 460 470 460 450 {lab=sdi}
C {devices/lab_pin.sym} 460 450 0 0 {name=l17 sig_type=std_logic lab=sdi}
N 460 530 460 550 {lab=0}
C {devices/lab_pin.sym} 460 550 0 0 {name=l18 sig_type=std_logic lab=0}
C {devices/vsource.sym} 720 500 0 0 {name=VCSN value="pwl(0 3.3 4e-06 3.3 4.002e-06 0 6.5e-06 0 6.502e-06 3.3 4e-05 3.3 4.0002e-05 0 4.25e-05 0 4.2502e-05 3.3)" savecurrent=false}
N 720 470 720 450 {lab=csn}
C {devices/lab_pin.sym} 720 450 0 0 {name=l19 sig_type=std_logic lab=csn}
N 720 530 720 550 {lab=0}
C {devices/lab_pin.sym} 720 550 0 0 {name=l20 sig_type=std_logic lab=0}
C {spi_regs.sym} 980 610 0 0 {name=XS }
N 880 410 860 410 {lab=sclk}
C {devices/lab_pin.sym} 860 410 0 0 {name=l21 sig_type=std_logic lab=sclk}
N 880 430 860 430 {lab=sdi}
C {devices/lab_pin.sym} 860 430 0 0 {name=l22 sig_type=std_logic lab=sdi}
N 880 450 860 450 {lab=csn}
C {devices/lab_pin.sym} 860 450 0 0 {name=l23 sig_type=std_logic lab=csn}
N 1080 410 1100 410 {lab=ig1a}
C {devices/lab_pin.sym} 1100 410 0 1 {name=l24 sig_type=std_logic lab=ig1a}
N 1080 430 1100 430 {lab=ig1b}
C {devices/lab_pin.sym} 1100 430 0 1 {name=l25 sig_type=std_logic lab=ig1b}
N 1080 450 1100 450 {lab=ig2a}
C {devices/lab_pin.sym} 1100 450 0 1 {name=l26 sig_type=std_logic lab=ig2a}
N 1080 470 1100 470 {lab=ig2b}
C {devices/lab_pin.sym} 1100 470 0 1 {name=l27 sig_type=std_logic lab=ig2b}
N 1080 490 1100 490 {lab=ig3a}
C {devices/lab_pin.sym} 1100 490 0 1 {name=l28 sig_type=std_logic lab=ig3a}
N 1080 510 1100 510 {lab=ig3b}
C {devices/lab_pin.sym} 1100 510 0 1 {name=l29 sig_type=std_logic lab=ig3b}
N 1080 530 1100 530 {lab=b0}
C {devices/lab_pin.sym} 1100 530 0 1 {name=l30 sig_type=std_logic lab=b0}
N 1080 550 1100 550 {lab=b1}
C {devices/lab_pin.sym} 1100 550 0 1 {name=l31 sig_type=std_logic lab=b1}
N 1080 570 1100 570 {lab=afc0}
C {devices/lab_pin.sym} 1100 570 0 1 {name=l32 sig_type=std_logic lab=afc0}
N 1080 590 1100 590 {lab=afc1}
C {devices/lab_pin.sym} 1100 590 0 1 {name=l33 sig_type=std_logic lab=afc1}
N 1080 610 1100 610 {lab=afc2}
C {devices/lab_pin.sym} 1100 610 0 1 {name=l34 sig_type=std_logic lab=afc2}
N 1080 630 1100 630 {lab=afc3}
C {devices/lab_pin.sym} 1100 630 0 1 {name=l35 sig_type=std_logic lab=afc3}
N 1080 650 1100 650 {lab=afc4}
C {devices/lab_pin.sym} 1100 650 0 1 {name=l36 sig_type=std_logic lab=afc4}
N 1080 670 1100 670 {lab=afc5}
C {devices/lab_pin.sym} 1100 670 0 1 {name=l37 sig_type=std_logic lab=afc5}
N 1080 690 1100 690 {lab=afc6}
C {devices/lab_pin.sym} 1100 690 0 1 {name=l38 sig_type=std_logic lab=afc6}
N 1080 710 1100 710 {lab=afc7}
C {devices/lab_pin.sym} 1100 710 0 1 {name=l39 sig_type=std_logic lab=afc7}
N 1080 730 1100 730 {lab=icp2}
C {devices/lab_pin.sym} 1100 730 0 1 {name=l40 sig_type=std_logic lab=icp2}
N 1080 750 1100 750 {lab=bww}
C {devices/lab_pin.sym} 1100 750 0 1 {name=l41 sig_type=std_logic lab=bww}
N 1080 770 1100 770 {lab=bwn}
C {devices/lab_pin.sym} 1100 770 0 1 {name=l42 sig_type=std_logic lab=bwn}
N 1080 790 1100 790 {lab=vdd}
C {devices/lab_pin.sym} 1100 790 0 1 {name=l43 sig_type=std_logic lab=vdd}
N 1080 810 1100 810 {lab=0}
C {devices/lab_pin.sym} 1100 810 0 1 {name=l44 sig_type=std_logic lab=0}
C {inv_dig.sym} 200 910 0 0 {name=XBW }
N 100 890 80 890 {lab=bww}
C {devices/lab_pin.sym} 80 890 0 0 {name=l45 sig_type=std_logic lab=bww}
N 300 890 320 890 {lab=bwk}
C {devices/lab_pin.sym} 320 890 0 1 {name=l46 sig_type=std_logic lab=bwk}
N 300 910 320 910 {lab=vdd}
C {devices/lab_pin.sym} 320 910 0 1 {name=l47 sig_type=std_logic lab=vdd}
N 300 930 320 930 {lab=0}
C {devices/lab_pin.sym} 320 930 0 1 {name=l48 sig_type=std_logic lab=0}
C {if_chain.sym} 460 990 0 0 {name=XIF }
N 360 890 340 890 {lab=inp}
C {devices/lab_pin.sym} 340 890 0 0 {name=l49 sig_type=std_logic lab=inp}
N 360 910 340 910 {lab=inn}
C {devices/lab_pin.sym} 340 910 0 0 {name=l50 sig_type=std_logic lab=inn}
N 360 930 340 930 {lab=ig1a}
C {devices/lab_pin.sym} 340 930 0 0 {name=l51 sig_type=std_logic lab=ig1a}
N 360 950 340 950 {lab=ig1b}
C {devices/lab_pin.sym} 340 950 0 0 {name=l52 sig_type=std_logic lab=ig1b}
N 360 970 340 970 {lab=ig2a}
C {devices/lab_pin.sym} 340 970 0 0 {name=l53 sig_type=std_logic lab=ig2a}
N 360 990 340 990 {lab=ig2b}
C {devices/lab_pin.sym} 340 990 0 0 {name=l54 sig_type=std_logic lab=ig2b}
N 360 1010 340 1010 {lab=ig3a}
C {devices/lab_pin.sym} 340 1010 0 0 {name=l55 sig_type=std_logic lab=ig3a}
N 360 1030 340 1030 {lab=ig3b}
C {devices/lab_pin.sym} 340 1030 0 0 {name=l56 sig_type=std_logic lab=ig3b}
N 360 1050 340 1050 {lab=pb}
C {devices/lab_pin.sym} 340 1050 0 0 {name=l57 sig_type=std_logic lab=pb}
N 360 1070 340 1070 {lab=bwk}
C {devices/lab_pin.sym} 340 1070 0 0 {name=l58 sig_type=std_logic lab=bwk}
N 360 1090 340 1090 {lab=bwn}
C {devices/lab_pin.sym} 340 1090 0 0 {name=l59 sig_type=std_logic lab=bwn}
N 560 890 580 890 {lab=aop}
C {devices/lab_pin.sym} 580 890 0 1 {name=l60 sig_type=std_logic lab=aop}
N 560 910 580 910 {lab=aon}
C {devices/lab_pin.sym} 580 910 0 1 {name=l61 sig_type=std_logic lab=aon}
N 560 930 580 930 {lab=vdd}
C {devices/lab_pin.sym} 580 930 0 1 {name=l62 sig_type=std_logic lab=vdd}
N 560 950 580 950 {lab=0}
C {devices/lab_pin.sym} 580 950 0 1 {name=l63 sig_type=std_logic lab=0}
C {devices/vsource.sym} 720 920 0 0 {name=VCK value="pulse(0 3.3 0 0.3n 0.3n 30.2474n 61.0948n)" savecurrent=false}
N 720 890 720 870 {lab=clk}
C {devices/lab_pin.sym} 720 870 0 0 {name=l64 sig_type=std_logic lab=clk}
N 720 950 720 970 {lab=0}
C {devices/lab_pin.sym} 720 970 0 0 {name=l65 sig_type=std_logic lab=0}
C {adc2b.sym} 980 920 0 0 {name=XA }
N 880 890 860 890 {lab=aop}
C {devices/lab_pin.sym} 860 890 0 0 {name=l66 sig_type=std_logic lab=aop}
N 880 910 860 910 {lab=aon}
C {devices/lab_pin.sym} 860 910 0 0 {name=l67 sig_type=std_logic lab=aon}
N 880 930 860 930 {lab=clk}
C {devices/lab_pin.sym} 860 930 0 0 {name=l68 sig_type=std_logic lab=clk}
N 1080 890 1100 890 {lab=sign}
C {devices/lab_pin.sym} 1100 890 0 1 {name=l69 sig_type=std_logic lab=sign}
N 1080 910 1100 910 {lab=mag}
C {devices/lab_pin.sym} 1100 910 0 1 {name=l70 sig_type=std_logic lab=mag}
N 1080 930 1100 930 {lab=vdd}
C {devices/lab_pin.sym} 1100 930 0 1 {name=l71 sig_type=std_logic lab=vdd}
N 1080 950 1100 950 {lab=0}
C {devices/lab_pin.sym} 1100 950 0 1 {name=l72 sig_type=std_logic lab=0}
C {devices/code_shown.sym} 1860 300 0 0 {name=MODELS format="tcleval( @value )" only_toplevel=true value=".include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice mimcap_typical"}
C {devices/code_shown.sym} 1860 700 0 0 {name=SIM only_toplevel=true value=".option method=gear
.control
set num_threads=1
tran 2n 80u 0 2n
wrdata tb_ifadc_out v(clk) v(sign) v(mag) v(aop,aon) v(ig1a) v(ig1b)
.endc"}
C {devices/title.sym} 160 1550 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
