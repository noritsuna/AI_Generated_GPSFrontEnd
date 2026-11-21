v {xschem version=3.4.5 file_version=1.2}
G {}
K {}
V {}
S {}
E {}

T {tb_spi: power-on reset defaults + one 24-bit SPI write (0x853A96, 10 MHz SCLK)} 100 80 0 0 0.6 0.6 {}
C {devices/vsource.sym} 200 300 0 0 {name=VDD value="pwl(0 0 1u 3.3)" savecurrent=false}
N 200 270 200 250 {lab=vdd}
C {devices/lab_pin.sym} 200 250 0 0 {name=l1 sig_type=std_logic lab=vdd}
N 200 330 200 350 {lab=0}
C {devices/lab_pin.sym} 200 350 0 0 {name=l2 sig_type=std_logic lab=0}
C {devices/vsource.sym} 460 300 0 0 {name=VSCLK value="pwl(0 0 3.01e-05 0 3.0102e-05 3.3 3.015e-05 3.3 3.0152e-05 0 3.02e-05 0 3.0202e-05 3.3 3.025e-05 3.3 3.0252e-05 0 3.03e-05 0 3.0302e-05 3.3 3.035e-05 3.3 3.0352e-05 0 3.04e-05 0 3.0402e-05 3.3 3.045e-05 3.3 3.0452e-05 0 3.05e-05 0 3.0502e-05 3.3 3.055e-05 3.3 3.0552e-05 0 3.06e-05 0 3.0602e-05 3.3 3.065e-05 3.3 3.0652e-05 0 3.07e-05 0 3.0702e-05 3.3 3.075e-05 3.3 3.0752e-05 0 3.08e-05 0 3.0802e-05 3.3 3.085e-05 3.3 3.0852e-05 0 3.09e-05 0 3.0902e-05 3.3 3.095e-05 3.3 3.0952e-05 0 3.1e-05 0 3.1002e-05 3.3 3.105e-05 3.3 3.1052e-05 0 3.11e-05 0 3.1102e-05 3.3 3.115e-05 3.3 3.1152e-05 0 3.12e-05 0 3.1202e-05 3.3 3.125e-05 3.3 3.1252e-05 0 3.13e-05 0 3.1302e-05 3.3 3.135e-05 3.3 3.1352e-05 0 3.14e-05 0 3.1402e-05 3.3 3.145e-05 3.3 3.1452e-05 0 3.15e-05 0 3.1502e-05 3.3 3.155e-05 3.3 3.1552e-05 0 3.16e-05 0 3.1602e-05 3.3 3.165e-05 3.3 3.1652e-05 0 3.17e-05 0 3.1702e-05 3.3 3.175e-05 3.3 3.1752e-05 0 3.18e-05 0 3.1802e-05 3.3 3.185e-05 3.3 3.1852e-05 0 3.19e-05 0 3.1902e-05 3.3 3.195e-05 3.3 3.1952e-05 0 3.2e-05 0 3.2002e-05 3.3 3.205e-05 3.3 3.2052e-05 0 3.21e-05 0 3.2102e-05 3.3 3.215e-05 3.3 3.2152e-05 0 3.22e-05 0 3.2202e-05 3.3 3.225e-05 3.3 3.2252e-05 0 3.23e-05 0 3.2302e-05 3.3 3.235e-05 3.3 3.2352e-05 0 3.24e-05 0 3.2402e-05 3.3 3.245e-05 3.3 3.2452e-05 0)" savecurrent=false}
N 460 270 460 250 {lab=sclk}
C {devices/lab_pin.sym} 460 250 0 0 {name=l3 sig_type=std_logic lab=sclk}
N 460 330 460 350 {lab=0}
C {devices/lab_pin.sym} 460 350 0 0 {name=l4 sig_type=std_logic lab=0}
C {devices/vsource.sym} 720 300 0 0 {name=VSDI value="pwl(0 0 3.005e-05 0 3.0052e-05 3.3 3.015e-05 3.3 3.0152e-05 0 3.025e-05 0 3.0252e-05 0 3.035e-05 0 3.0352e-05 0 3.045e-05 0 3.0452e-05 0 3.055e-05 0 3.0552e-05 3.3 3.065e-05 3.3 3.0652e-05 0 3.075e-05 0 3.0752e-05 3.3 3.085e-05 3.3 3.0852e-05 0 3.095e-05 0 3.0952e-05 0 3.105e-05 0 3.1052e-05 3.3 3.115e-05 3.3 3.1152e-05 3.3 3.125e-05 3.3 3.1252e-05 3.3 3.135e-05 3.3 3.1352e-05 0 3.145e-05 0 3.1452e-05 3.3 3.155e-05 3.3 3.1552e-05 0 3.165e-05 0 3.1652e-05 3.3 3.175e-05 3.3 3.1752e-05 0 3.185e-05 0 3.1852e-05 0 3.195e-05 0 3.1952e-05 3.3 3.205e-05 3.3 3.2052e-05 0 3.215e-05 0 3.2152e-05 3.3 3.225e-05 3.3 3.2252e-05 3.3 3.235e-05 3.3 3.2352e-05 0)" savecurrent=false}
N 720 270 720 250 {lab=sdi}
C {devices/lab_pin.sym} 720 250 0 0 {name=l5 sig_type=std_logic lab=sdi}
N 720 330 720 350 {lab=0}
C {devices/lab_pin.sym} 720 350 0 0 {name=l6 sig_type=std_logic lab=0}
C {devices/vsource.sym} 980 300 0 0 {name=VCSN value="pwl(0 3.3 3e-05 3.3 3.0002e-05 0 3.25e-05 0 3.2502e-05 3.3)" savecurrent=false}
N 980 270 980 250 {lab=csn}
C {devices/lab_pin.sym} 980 250 0 0 {name=l7 sig_type=std_logic lab=csn}
N 980 330 980 350 {lab=0}
C {devices/lab_pin.sym} 980 350 0 0 {name=l8 sig_type=std_logic lab=0}
C {spi_regs.sym} 1240 300 0 0 {name=XS }
N 1140 100 1120 100 {lab=sclk}
C {devices/lab_pin.sym} 1120 100 0 0 {name=l9 sig_type=std_logic lab=sclk}
N 1140 120 1120 120 {lab=sdi}
C {devices/lab_pin.sym} 1120 120 0 0 {name=l10 sig_type=std_logic lab=sdi}
N 1140 140 1120 140 {lab=csn}
C {devices/lab_pin.sym} 1120 140 0 0 {name=l11 sig_type=std_logic lab=csn}
N 1340 100 1360 100 {lab=ig1a}
C {devices/lab_pin.sym} 1360 100 0 1 {name=l12 sig_type=std_logic lab=ig1a}
N 1340 120 1360 120 {lab=ig1b}
C {devices/lab_pin.sym} 1360 120 0 1 {name=l13 sig_type=std_logic lab=ig1b}
N 1340 140 1360 140 {lab=ig2a}
C {devices/lab_pin.sym} 1360 140 0 1 {name=l14 sig_type=std_logic lab=ig2a}
N 1340 160 1360 160 {lab=ig2b}
C {devices/lab_pin.sym} 1360 160 0 1 {name=l15 sig_type=std_logic lab=ig2b}
N 1340 180 1360 180 {lab=ig3a}
C {devices/lab_pin.sym} 1360 180 0 1 {name=l16 sig_type=std_logic lab=ig3a}
N 1340 200 1360 200 {lab=ig3b}
C {devices/lab_pin.sym} 1360 200 0 1 {name=l17 sig_type=std_logic lab=ig3b}
N 1340 220 1360 220 {lab=b0}
C {devices/lab_pin.sym} 1360 220 0 1 {name=l18 sig_type=std_logic lab=b0}
N 1340 240 1360 240 {lab=b1}
C {devices/lab_pin.sym} 1360 240 0 1 {name=l19 sig_type=std_logic lab=b1}
N 1340 260 1360 260 {lab=afc0}
C {devices/lab_pin.sym} 1360 260 0 1 {name=l20 sig_type=std_logic lab=afc0}
N 1340 280 1360 280 {lab=afc1}
C {devices/lab_pin.sym} 1360 280 0 1 {name=l21 sig_type=std_logic lab=afc1}
N 1340 300 1360 300 {lab=afc2}
C {devices/lab_pin.sym} 1360 300 0 1 {name=l22 sig_type=std_logic lab=afc2}
N 1340 320 1360 320 {lab=afc3}
C {devices/lab_pin.sym} 1360 320 0 1 {name=l23 sig_type=std_logic lab=afc3}
N 1340 340 1360 340 {lab=afc4}
C {devices/lab_pin.sym} 1360 340 0 1 {name=l24 sig_type=std_logic lab=afc4}
N 1340 360 1360 360 {lab=afc5}
C {devices/lab_pin.sym} 1360 360 0 1 {name=l25 sig_type=std_logic lab=afc5}
N 1340 380 1360 380 {lab=afc6}
C {devices/lab_pin.sym} 1360 380 0 1 {name=l26 sig_type=std_logic lab=afc6}
N 1340 400 1360 400 {lab=afc7}
C {devices/lab_pin.sym} 1360 400 0 1 {name=l27 sig_type=std_logic lab=afc7}
N 1340 420 1360 420 {lab=icp2}
C {devices/lab_pin.sym} 1360 420 0 1 {name=l28 sig_type=std_logic lab=icp2}
N 1340 440 1360 440 {lab=bww}
C {devices/lab_pin.sym} 1360 440 0 1 {name=l29 sig_type=std_logic lab=bww}
N 1340 460 1360 460 {lab=bwn}
C {devices/lab_pin.sym} 1360 460 0 1 {name=l30 sig_type=std_logic lab=bwn}
N 1340 480 1360 480 {lab=vdd}
C {devices/lab_pin.sym} 1360 480 0 1 {name=l31 sig_type=std_logic lab=vdd}
N 1340 500 1360 500 {lab=0}
C {devices/lab_pin.sym} 1360 500 0 1 {name=l32 sig_type=std_logic lab=0}
C {devices/code_shown.sym} 1860 300 0 0 {name=MODELS format="tcleval( @value )" only_toplevel=true value=".include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice mimcap_typical"}
C {devices/code_shown.sym} 1860 700 0 0 {name=SIM only_toplevel=true value=".control
set num_threads=1
tran 2n 34.5u
meas tran por_ig1a find v(ig1a) at=2.9e-05
meas tran por_ig1b find v(ig1b) at=2.9e-05
meas tran por_ig2a find v(ig2a) at=2.9e-05
meas tran por_ig2b find v(ig2b) at=2.9e-05
meas tran por_ig3a find v(ig3a) at=2.9e-05
meas tran por_ig3b find v(ig3b) at=2.9e-05
meas tran por_b0 find v(b0) at=2.9e-05
meas tran por_b1 find v(b1) at=2.9e-05
meas tran por_afc0 find v(afc0) at=2.9e-05
meas tran por_afc1 find v(afc1) at=2.9e-05
meas tran por_afc2 find v(afc2) at=2.9e-05
meas tran por_afc3 find v(afc3) at=2.9e-05
meas tran por_afc4 find v(afc4) at=2.9e-05
meas tran por_afc5 find v(afc5) at=2.9e-05
meas tran por_afc6 find v(afc6) at=2.9e-05
meas tran por_afc7 find v(afc7) at=2.9e-05
meas tran por_icp2 find v(icp2) at=2.9e-05
meas tran por_bww find v(bww) at=2.9e-05
meas tran por_bwn find v(bwn) at=2.9e-05
echo RES por IG1A=$&por_ig1a IG1B=$&por_ig1b IG2A=$&por_ig2a IG2B=$&por_ig2b IG3A=$&por_ig3a IG3B=$&por_ig3b B0=$&por_b0 B1=$&por_b1 AFC0=$&por_afc0 AFC1=$&por_afc1 AFC2=$&por_afc2 AFC3=$&por_afc3 AFC4=$&por_afc4 AFC5=$&por_afc5 AFC6=$&por_afc6 AFC7=$&por_afc7 ICP2=$&por_icp2 BWW=$&por_bww BWN=$&por_bwn
meas tran write_ig1a find v(ig1a) at=3.4e-05
meas tran write_ig1b find v(ig1b) at=3.4e-05
meas tran write_ig2a find v(ig2a) at=3.4e-05
meas tran write_ig2b find v(ig2b) at=3.4e-05
meas tran write_ig3a find v(ig3a) at=3.4e-05
meas tran write_ig3b find v(ig3b) at=3.4e-05
meas tran write_b0 find v(b0) at=3.4e-05
meas tran write_b1 find v(b1) at=3.4e-05
meas tran write_afc0 find v(afc0) at=3.4e-05
meas tran write_afc1 find v(afc1) at=3.4e-05
meas tran write_afc2 find v(afc2) at=3.4e-05
meas tran write_afc3 find v(afc3) at=3.4e-05
meas tran write_afc4 find v(afc4) at=3.4e-05
meas tran write_afc5 find v(afc5) at=3.4e-05
meas tran write_afc6 find v(afc6) at=3.4e-05
meas tran write_afc7 find v(afc7) at=3.4e-05
meas tran write_icp2 find v(icp2) at=3.4e-05
meas tran write_bww find v(bww) at=3.4e-05
meas tran write_bwn find v(bwn) at=3.4e-05
echo RES write IG1A=$&write_ig1a IG1B=$&write_ig1b IG2A=$&write_ig2a IG2B=$&write_ig2b IG3A=$&write_ig3a IG3B=$&write_ig3b B0=$&write_b0 B1=$&write_b1 AFC0=$&write_afc0 AFC1=$&write_afc1 AFC2=$&write_afc2 AFC3=$&write_afc3 AFC4=$&write_afc4 AFC5=$&write_afc5 AFC6=$&write_afc6 AFC7=$&write_afc7 ICP2=$&write_icp2 BWW=$&write_bww BWN=$&write_bwn
meas tran rstw when v(xs.rst)=1.65 fall=1
echo RES por_release=$&rstw
.endc"}
C {devices/title.sym} 160 1140 0 0 {name=l_title author="GNSS AFE / GF180MCU"}
