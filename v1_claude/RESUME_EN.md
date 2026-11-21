# Resume notes (to continue the work on another PC)

Last updated: 2026-11-14. The design proposal is in `doc/report_EN.md` (rev.3; Japanese original `doc/report.md`). Japanese version of these notes: `RESUME.md` (when the Japanese version is updated, update the English one as well).

## 1. Current design (rev.3)
- AFE for GPS L1 C/A + Galileo E1, GF180MCU (`gf180mcuD`), 3.3 V ±5 %, −20…85 °C
- Noise-cancelling LNA (no inductor, `lna_nc`) → I/Q sub-harmonic mixer (8-phase LO at fLO/2) → IF (variable VGA × 3 + fixed gain × 2 + Sallen-Key × 2, 0.8–7 MHz)
  → 2-bit I/Q ADC @ 16.368 MS/s
- LO: ring VCO + integer-N PLL (16.368 MHz TCXO × 96 = 1571.328 MHz)
- Control: SPI (24 bit, 3-wire write + SDO readback; ICP2 added on 11-04, IF bandwidth trim BWW / BWN on 11-13, readback on 11-14) + POR, 8-bit DAC for AFC. 16 pins (VCO supply VDDV added on 11-08, SDO on 11-14)
- Chips at the SS corner are assumed to be screened out (decided 11-08)
- The single source of the design is `scripts/gen_cells.py` (cells) and `scripts/gen_tb.py` (testbenches).
  `xschem/*.sch` / `*.sym` are generated from them, so if you edit them by hand, carry the change back into the generators

## 2. Verified items
Every block is verified in ngspice. IF / ADC / VCO / PLL were also confirmed to agree in Xyce.
For the numbers see chapter 3 of `doc/report_EN.md`.
- `tb_lna`, `tb_rx` (LNA, LNA + mixer), `tb_mixer`, `tb_if`, `tb_adc`, `tb_vco` (+ corners), `tb_div`,
  `tb_pfdcp`, `tb_pll` (closed loop), `tb_bias`, `tb_afc`, `tb_spi`, `tb_ifadc` (IF + ADC + SPI end to end, with noise)
- System: `scripts/gnss_sysim.py` (acquisition, aliased noise, link budget), `scripts/doppler.py`, `scripts/pll_design.py`

## 2.5 Layout and PEX (2026-11-06 to 08, details in section 3.12 of `doc/report_EN.md`)
- The layout is generated in Python in `scripts/layout/` (`build_all.py` → `top_build.py` → `top_wires.py`). The analog macro `gnss_afe_analog` is 979.4 × 3681.5 µm, DRC 0, LVS match.
  - Environment: `export PDK_ROOT=~/pdk PDK=gf180mcuD`. To rebuild only some cells, use e.g. `REUSE=vga,bias_if python3 build_all.py`.
  - Do not use flatten / `extract no all` for magic PEX. The halo is 2 µm.
- Three issues fixed after PEX:
  1. SK MIM capacitors specified at 80 % (unit-cell implementation adds +9.6 %) → PEX IF fh 7.08–7.25 MHz
  2. Mixer LO load trimmed with NMOS gate capacitance (`LO_TRIM`) → 151.5–162.2 fF, LO I/Q error +0.08°
  3. Router separation cost (`sep_map` in `router.py`, `SEP` in `auto.py`) → coupling fs to mqn 48.5 → 0.31 fF
- PLL closed-loop PEX (`scripts/layout/pex_pllmix.py`, 3 in parallel, 4 h 13 min):
  - VCTRL locks at TT 2.184 V and FF 1.445 V. SS (B=11, ICP2=1) is converging to 1.845 V.
  - The open-loop tuning curve comes from the `pex_vcomix.py` deck (SS B=11 maximum frequency 1683 MHz, +7.1 %).
- VCTRL spike fix (11-07): `vcp` / `VC` set to width 3 with `NET_WIDTHS`; the VCO-side pin is taken from C2 through RVT 1 kΩ + C3 0.8 pF (`loop_filter` in `gen_cells.py`, `vcp` added to `.ic`).
  - Result: all 3 corners settle (TT 2.1842, SS 1.8478, FF 1.4452 V). VCTRL p-p 62 / 52 / 69 mV (before the fix 259 / 438 / 331 mV).
  - At step (6) the reference spur k=1 had worsened to TT −22.4, SS −29.6, FF −17.5 dBc. Cause: coupling of FS / FB / REFCK (about 14 fF in total) into VCTRL, which had become high impedance behind RVT.
  - Fixes (11-07 to 08):
    - C3 to 4 pF (45 × 45 µm).
    - `SEP["pll_core"]` keeps FS / FB / REFCK / ck / up / dn away from VCTRL. Coupling about 0.15 fF.
    - `ROW_WIDTH["pll_core"]=600000` keeps it at 552 × 940 µm.
    - mqp / mqn → mip / min added to the top-level `SEP` (mqn ↔ mip 0.55 fF).
    - Top is 979.4 × 3717.9 µm, DRC 0, LVS match.
  - Result: reference spurs TT −46.0, SS −47.7, FF −36.7 dBc (direct measurement of the LO sidebands). VCTRL p-p 2.6 / 3.7 / 5.2 mV.
  - At step (7) FF was 3.3 dB short → cause: static offset of the CP (the old CP let pc / nc swing while the switch was off and pulled 55–123 fC from OUT when it turned on). An RVT 3 kΩ variant only gave −2.2 dB and left FF with 43° phase margin, so it was rejected.
  - **(8) Current-steering CP (11-08)**: dummy switches MPD / MND (dumping into vd) and a unity-gain buffer holding vd at OUT were added to `cp`. MPD is driven by `upd = inv(UPB)` (switches after the output switch). CP pins are UPB / DN / DNB.
    - CP-only offset TT −0.022, SS +0.006, FF −0.006 ns (old −0.23 / −0.04 / −0.52). Exception: SS, ICP2=1, VCTRL ≥ 2.4 V gives 0.19–0.42 ns (PMOS current source runs out of headroom, same as the old CP).
    - `SEP["pll_core"]` is also set from the VCTRL side, both ways (the router only sees nets that are already routed). FB → VCTRL 0.07 fF.
    - `cp` 134 × 202, `pll_core` 576 × 940, top 979.4 × 3717.9 µm, DRC 0, LVS match.
    - **Reference spurs of the PEX closed loop: TT −60.5, SS −48.9, FF −67.5 dBc. All 3 corners meet −40 dBc.** VCTRL p-p 1.0 / 2.2 / 0.5 mV, REF−FB −0.14 / −0.14 / −0.10 ns.
    - Waveforms of (8) in `sim/pllmix_steer_4p/`, of (7) with the old CP in `sim/pllmix_c3_4p/`.
  - **(9) C3 1.5 pF + larger CP PMOS switches (11-08)**:
    - C3 4 → 1.5 pF (27.5 × 27.5 µm), since the separation brought the coupling below 0.2 fF. In the loop model FF gains +4 to 5° of phase margin.
    - MPS / MPD / MPS2 / MPD2 to 8 µm nf=2, MPE2 to 24 µm nf=4 (with 4 µm the 0.4 V switch drop reduced Iup at high VCTRL in SS). SS, ICP2=1 offset at 2.5 V 0.28 → 0.075 ns. 12 µm was rejected because the switch charge increased the offset.
    - vctrl added to the top-level `SEP` both ways (fs 4.2 fF, mqp 14.3 fF → ≤ 0.04 fF).
    - **Reference spurs of the PEX closed loop: TT −54.2, SS −51.7, FF −63.1 dBc (worst SS, 11.7 dB margin).** VCTRL p-p 2.5 / 4.1 / 1.2 mV, REF−FB −0.125 / −0.063 / −0.074 ns.
    - Waveforms in `sim/pllmix_{tt_b0_i0,ss_b3_i1,ff_b0_i0}`.
  - Analysis: `scripts/layout/pll_spur.py tt_b0_i0 ss_b3_i1 ff_b0_i0` takes the last 9 reference periods with a Hann window and computes the VCTRL components and the LO sidebands.
    - A 1.2 µs run (`TSTOP=1.2e-6`) has not settled and overstates k=1, so it cannot be used.
- Notes (11-07):
  - After changing `gen_cells.py`, run `run.netlist('tb_full')` before rebuilding the layout. The layout reads `sim/netlist/tb_full.spice`.
  - `pex_vco.ring_ic` gave different results depending on `PYTHONHASHSEED`; it now sorts and is deterministic.
- **VCO supply fixes (11-08, report section 3.13)**:
  - C: RMIN in `vco_ring4` (VDD→VR 2.5 kΩ) replaced by the constant current MMIN from NB, PMOS mirror at L 0.56 µm → supply sensitivity TT 184→42–50, FF 243→48 MHz/V (schematic). `vco_ring4` gets pin NB and internal node `ng`.
  - A: dedicated VCO supply pin VDDV. In the macro the rails of the VCO row are VDDV (`ROW_VDD` in `auto.py`, `TOP_RAILS` = VDDV, VSS), 4 VDDV stripes in `power_mesh.py`. VDDV pad + VSS in the pad block (555 µm wide).
- **Chip integration (11-08, report section 3.13 (4))**: `cd chip && nix-shell --run "make librelane PDK_ROOT=$HOME/pdk"` (about 35 min). LVS match, magic DRC 0, KLayout only the 161 seal-ring corner errors (from the template).
  - Main changes: macro location [468, 926] ([468, 862.3] since 11-09), PAD_X 418 / VCTRL and AFCOUT pads at 1225 / 1334 µm, PDN grids of the SRAM and the macro removed, VDDA / VDDV outside the PDN (straps only), `PDN_OBSTRUCTIONS`, `FP_MACRO_VERTICAL_HALO: 40`, fixes to the strap script (3 analog pads and the RF port added), MIM bottom plate split (MIMTM.11).
  - When the macro changes: `build_all.py <cells>` → `top_build.py` → `export_macro.py` → LibreLane. When the pad ring changes, read the pad positions back from the DEF and update `PAD_X` / `_SIG` in `auto.py`.
- IF chain PEX + bond wires (2–5 nH) confirmed not to oscillate (report section 3.13 (5)). Substrate coupling not checked.
- `tb_full` regression with noise, 12 µs (finished 11-09, report section 3.13 (6)): after the CP / C3 change VCTRL 1.3526 V, with A + C 1.4307 V, both lock within 1 µs, CLKOUT 16.368 MHz, 58.2 mA, IF rms 159–160 / 115 mV. Results in `sim/full_cp/`, `sim/full_ac/`.
- I/Q sign (11-09): `chip_core.sv` inverts Q_SIGN → at the pads I + jQ is at +4.092 MHz (not inverted). The macro / schematic outputs are before the inversion (Q leads by 90°). Checked with the RTL test `chip/tb/tb_spi_rtl.sv`.
- Supply ripple / substrate coupling (11-09, report section 3.13 (8)(9)): VDDV 1 mVp @1 MHz → −38 dBc (8 dB margin with an LDO at 0.3 mVp). **VDD 20 mVp @1 MHz → −8 dBc (mainly `refbuf`; moving it gives −30.5 dBc, moving all of `pll_core` + `bias_gen` makes no further difference)**. Substrate coupling: LO leakage −123 dBm (DC), IF feedback −89 dB, no problem.
- **VDD sensitivity fix (11-09, report section 3.13 (10))**: `refbuf` moved out of `pll_core` to the macro top level on VDDV (right end of the VCO row). The `pll_core` input is REFCK, with 1 kΩ + clamps fed from tie cells at the entry (domain crossing). VDD decoupling `decap` 126 pF (right of the PLL row). VDD 20 mVp @1 MHz → −30.4 dBc (tolerance 6.6 mVp), VDDV 0.85 mVp gives −40 dBc. Macro 979.4 × 3786.1 µm, placed at [468, 862.3]. Chip `RUN_2026-11-09_11-49-34`: LVS match, DRC only the seal ring. FF lock and power-up order: `scripts/layout/pll_checks.py`.
  - Tying the clamp gates directly to a supply rail trips the KLayout antenna check (ANT.11). Take them from tie cells (MTX → MTHI → MTLO).
- `tb_full` regression (`sim/full_rb/`): VCTRL 1.4307 V / CLKOUT 16.368017 MHz / IDD 58.22 mA, identical to before the fix (done)
- **Wire-connected schematics (11-09, report section 3.14)**: `doc/sch_wired/*.png` / `.svg`. Every cell + `chip_top` (pad frame + core + macro) + `padframe` (physical pad placement).
  - Regenerate: `python3 scripts/schem/wired.py [cell ...]` and `python3 scripts/schem/chip_top.py` (updated for the quarter-slot pads). Regenerate them whenever the schematics (`gen_cells.py`) change.
  - Setup: node + elkjs (`nix shell nixpkgs#nodejs`, `cd scripts/schem && npm install`, node path via `NODE=`), `pip install cairosvg`.
  - If the post-drawing check (every net's wires connected, no contact or overlap with other nets) reports problems, the PNG is still written, but check its content.
- **Redesign for the quarter slot (slot 0p5x0p5) (11-09, report section 3.15)**: macro 1024.8 × 1535.2 µm (was 979.4 × 3786.1; 1024.1 wide before the current-density fix) at [452, 522.2]; chip `RUN_2026-11-13_07-15-30` (precheck `chip/precheck_q/runs/RUN_2026-11-13_07-42-38` passed): LVS match, magic / KLayout DRC 0, antenna 0. The old version is in `archive/0p5x1/`.
  - Generator defaults: `PACK=1` (shelf packing, small logic gates expanded, quarter top floorplan, `MACRO_X` 452), `MIM_MERGE=1` (only the caps in `lib.MERGE` merged into plates). `PACK=0 MIM_MERGE=0` gives the old placement.
  - Top level: `CORE_H=1585000 SIDE=7000 python3 top_build.py` → `export_macro.py` → `cd chip && make librelane` (default slot 0p5x0p5).
  - Circuit changes: `vga_fix` (fixed gain stages 3 → 2), loop filter at 2 × impedance + Icp 100 µA, VDD decoupling as NMOS (13 × 16 fingers 30/5 µm).
  - The used signal pads are on the south side; 6 bidir / 3 analog pads (`slot_defines.svh`). With the unused bidir pads in the ring their tie cells cannot be placed and the flow fails with DPL-0036.
  - PLL closed-loop PEX: locks at all 3 corners, reference spur TT −46.7 / SS −47.9 / FF −46.7 dBc (target −40). The cause, FS ↔ NB 22 fF, is down to 0.074 fF via `SEP`. The `tb_full` regression behaves as in the 0p5x1 version (IDD 54.2 mA).
  - Pre-tapeout checks (11-10 to 11, report section 3.15 (7)):
    - The ADC comparator is a symmetric `sa_comp` module (offset about 5 mV).
    - The mixer has a symmetric layout, with `LO_TRIM` retuned by `scripts/layout/lo_trim.py` (I/Q 0.09 dB, −88.9°).
    - IF-output ↔ mixer-output coupling (up to 17.6 fF) is below 0.1 fF via the top `SEP`.
    - LNA / AFC DAC PEX, IR drop (`ir_drop.py`, up to about 85 mV at the IF chains, gain change 0.15 dB or less), and PLL band coverage and acquisition (within 3 µs) are all fine.
    - PLL reference spur re-measured (PEX, after the mixer changes): TT −46.8 / SS −46.6 / FF −46.8 dBc (target −40, nearly unchanged).
    - `tb_full` regression (after the mixer changes, with noise, 12 µs): VCTRL 1.4441 V (+13 mV from the larger LO_TRIM), CLKOUT 16.368 MHz, IDD 54.31 mA; fine. The top schematic and padframe figure are regenerated with the new size.
    - The 188 KLayout DRC errors were not on the seal ring: they were RESISTOR / SAB markers in the resistor cells. `export_macro.py` now closes them: 0 errors.
  - Additional checks before tapeout (11-12, report section 3.15 (8)):
    - **Current density (fixed, 11-12; version with more contact / via margin, 11-13)**: `python3 scripts/layout/em_net.py layout/em/<cell>.spec.json` (list the nets with `em_net.py list <cell>`; results after the fix are in `layout/em/<cell>.fixed.log`). The high-current nets of the LNA / mixer / VCO / VGA / divider buffer now use wide wires + via arrays (`NET_WIDTHS` / `NONECK` / `RES_HEAVY` in `auto.py`, device-side leads in `cells.py` / `devices.py`). All wires are within the 85 °C limit, and all vias (0.28 mA) and all poly contacts (0.21 mA) within the 110 °C limit. On 11-13 the load resistors were made wider (LNA R2 30u × 2.17u at 0.206 mA, mixer RL 4u × 5u, VGA RL 2u × 4.23u). Remaining: wires that exceed only the 110 °C limit (parts of the LNA / mixer / VCO). The largest via current is 0.254 mA in the via3 of mixer IFIP (cannot be increased because of routing congestion). The other nets are checked with `python3 scripts/em_screen.py run|ana` (0.52 mA or less before the fix). The power mesh is OK at 85 °C (`layout/ir_drop_em.log`).
      - **PLL reference spur (layout of the 11-13 version, PEX closed loop)**: TT −48.0, FF −43.8, SS (B=11, 6 µs) −43.8 with ICP2=1 and −48.5 dBc with ICP2=0. All three corners meet the −40 dBc target (`layout/r2_pll_spur.log` / `r2_pll_spur_ss6.log`). The SS lock voltage is 1.431 V and settling takes about 3 µs even from the lock point, so run 6 µs: `cd scripts/layout && TAGSFX=_r2 TSTOP=6e-6 python3 pex_pllmix.py ss:3:1:1.432 ss:3:0:1.432 && python3 pll_spur.py ss_b3_i1_r2 ss_b3_i0_r2` (about 14 hours). The LO pin load spread is 4.8 fF; `LO_TRIM` has not been retuned.
      - After changing a leaf block, rebuild `python3 scripts/layout/build.py if_chain` / `pll_core` first and then run `top_build.py` (it reuses existing .mag files). LibreLane: `cd chip && nix-shell --run "make librelane PDK_ROOT=$HOME/pdk"`.
      - `auto.FLOOR["pll_core"]` keeps the clamp devices next to the divider buffer. Without it an 870 µm gate-only wire appears and KLayout reports 3 antenna errors (ANT.16). `SHAPE_W` `div48` 112000 / `pll_core` 966000 keep the macro inside the 1052 µm core width.
    - RFIN match (with pad + ESD, `layout/rfin_match.log`): shunt L 3.3–3.9 nH + wire 1–1.5 nH, or series 6 nH in total + shunt C 2.7 pF.
    - Digital outputs → RF (`scripts/layout/dig_couple.py run|ana`): series 100–330 Ω at each output pin, load about 5 pF. Isolation through the p-substrate is not checked.
    - Mismatch MC (`scripts/mc_mismatch.py adc|mixer|vcomix|pll`): ADC SIGN offset σ 13.7 mV, mixer I/Q 0.03 dB / 0.13°, PLL spur changes by less than 1 dB.
    - IF stability (`scripts/layout/if_stab.py --nopex`) and the full-chip corner regression (`scripts/corner_full.py run|ana tt ss ff`, `sim/full_corner/`): see report section 3.15 (8) for the results.
    - Final GDS `chip/final/gds/chip_top.gds` SHA-256: `07a533e0c20816d2a228d3ee3e90fe539a73193e2e723985a5611b7620126ded` (85399268 bytes, 11-13 07:42, after the contact / via increase).
  - Chip checks:
    - SPI: `cd chip/cocotb && nix-shell ../shell.nix --run "PDK_ROOT=$HOME/pdk PDK=gf180mcuD SLOT=0p5x0p5 [GL=1] python3 gnss_spi_tb.py"`. GL uses `chip/final/pnl`; both RTL and GL pass.
    - wafer.space precheck passed (`chip/precheck_q/`; inside `nix-shell ~/tools/gf180mcu-precheck/shell.nix` run `precheck.py --input ../final/gds/chip_top.gds --slot 0p5x0p5`; the chip nix-shell lacks the qrcode module).
    - Bonding diagram: `python3 scripts/schem/bond_diagram.py` → `doc/bonding_quarter.png/.csv`.
    - The 1935 PSM items (counted before the straps) and the 18 max-cap items (pad terminals) can be ignored.
    - LibreLane exits 2 on the deferred PSM error and does not copy to `chip/final`, so copy the run's `final/` by hand.
    - KLayout DRC uses `workers: 4` (max deadlocks or crashes with SIGSEGV). To resume from DRC: `make librelane LIBRELANE_OPTS='--pdk gf180mcuD --pdk-root $HOME/pdk --manual-pdk --scl gf180mcu_fd_sc_mcu7t5v0 --pad gf180mcu_fd_io --last-run --from KLayout.DRC'` (this overrides `LIBRELANE_OPTS`, so the PDK options must be given too).
- **Changes from the re-check (11-13 to 14, report section 3.15 (9))** (the chip was replaced by the SPI readback version below; the analog macro is still this version):
  - 3 changes: (1) The VCTRL pin is an output-only monitor through `vmon_buf` (unity-gain buffer, VDDV) + 10 kΩ. The loop node is `vctrl` (`vctrl_i` in the LVS reference), inside the macro. (2) IF bandwidth trim: SPI bit 17 BWW (C2 × 0.64, for slow chips), bit 18 BWN (C2 × 1.6, for fast chips). The macro pins are BWK (= ~BWW, inverted in `chip_core.sv`) and BWN. ctl has 19 lines. (3) AFC DAC resistors are W 2 µm × L 20.1 / 40 µm (with 20 µm or 20.2 µm the DNL at 127 → 128 is ∓0.76 LSB in PEX; `scripts/review/afc_geom.py`).
  - Macro 1029.8 × 1539.4 µm, DRC 0, LVS match. Chip `chip/librelane/runs/RUN_2026-11-13_23-44-07` (LVS match, magic / KLayout DRC 0, antenna 0, XOR 0, setup / hold 13.81 / 0.46 ns). precheck `chip/precheck_q/runs/RUN_2026-11-14_00-26-59` passed. RTL / GL cocotb pass.
  - **Final GDS `chip/final/gds/chip_top.gds` SHA-256: `afbc447a8c6956a5ed01ec58c14ac16d0a26ac423a0aaa15584ff3f5aede10ec` (86099462 bytes).** The hash of 11-13 07:42 above is the old version. This hash was also replaced by the readback version below.
- **Pad frame rebuilt (11-15, report section 3.15 (12)) — this is the current final version**: all 56 pads at the fixed template positions (slot 0p5x0p5; the 56 centres match). The 29 unused ones are kept as NC (`asig_5p0`, `nc_PAD[28:0]`). **Never remove or move pads (the bonding setup is fixed); changing the pad cell type is allowed.** Macro rebuilt with new top-edge pins (DRC 0, LVS match, placed FN). Chip `chip/librelane/runs/RUN_2026-11-15_18-44-39` (LVS match, DRC 0, antenna 0, slew violations 0, setup / hold +3.51 / +0.41 ns, cocotb RTL / GL PASS, precheck passed). `config.yaml` excludes the delay cells `dly*` from buffering (without it: slew violations at ss). **Final GDS SHA-256: `5dc43f34bc8e9d5964c2a791bb2c6bd7913a1ccf1866c3bbc3ef57630751c1c1` (86597382 bytes).** Old version in `archive/padframe_v1/`. PEX check with the new macro (11-15, logs in `layout/review/padframe/`): block cells XOR 0 so the block PEX stays valid, only 3 top wires changed (RFIN 23.9 fF, 1.2 Ω; REFIN; VCTRL monitor), IR drop the same, RFIN match keeps the board values (NF +0.07–0.16 dB), whole receive path `rx_pex.py`: only −0.1 dB of gain in all 3 corners (TT 24.1 / 24.0 dB, SS 20.0 / 19.9 dB, FF 25.3 / 25.1 dB; I/Q and PLL the same; `layout/review/padframe/rx_pex.log`).
  - Checked against the run-2 COB board (`run-2/0p5x0p5-cob` of wafer-space/chip-on-board-wire-bonded-pcbs) (11-15): the 8 fixed GND / VDD pads match the `dvss` / `dvdd` cells (`scripts/schem/bond_diagram.py` asserts it). `doc/bonding_quarter.csv` has the board net and the connector pin (RFIN = bidir_23 / pin 49, VDDA = bidir_25 / 47, VDDV = an_0 / 42). The 4 VDD nets get the same 3.3 V; decoupling of VDDA / VDDV and the RFIN match are on the motherboard; NC pads stay open.
  - RFIN match with the COB board path (11-16, `scripts/layout/rfin_cob.py`, `layout/review/padframe/rfin_cob.log`): trace 94 Ω, 5.0 nH / 0.57 pF (from KiCad); wire 3.0 nH, connector 0.6 nH / 0.15 pF, ground 0.5 nH are assumptions. Without matching S11 is −3.6 dB. Recommended: coupling capacitor 1.8 pF with 1.0 pF in shunt on the source side (S11 −19.2 dB, gain 13.37 dB, NF 2.46 dB). Varying the assumptions gives S11 −10 to −22 dB, so provide shunt – series – shunt part positions on the motherboard and tune by measurement.
  - The same in SS / FF and over wire length (11-16, report section 3.16 (11), `rfin_cob.py corners|search`, `layout/review/final/rfin_corners.log`, `rfin_search.log`): with the recommended parts S11 is below −12 dB for a wire of 2.5–3.5 nH (3 corners), −9.2…−9.9 dB at 4.0 nH (back with 1.0 pF in series only). Of 100 sets of assumptions 2 / 2 / 7 are above −10 dB. NF: TT 2.4–2.9, SS 3.0–3.7, FF 2.1–2.4 dB. Two script errors fixed (the 1 H placeholder shorted the input bias; the operating point was an intermediate value of a transient → `.nodeset` from `opset()`). In every `rfin_cob.py` deck only the op in front falls back to a transient op; that is normal.
- **Final check (11-16, report section 3.16, `scripts/review/final_*.py`, `layout/review/final/`)**: GDS unchanged. 0 static rule violations over all devices, operating points fine in 3 corners, the macro inside the GDS is XOR 0 against the stand-alone macro, LVS from the GDS matches, the PEX netlists have the same shapes as the final layout. Two notes: (1) the chip has no power-on reset; the board must drive RST_N (no pull). Never float RST_N / SCLK / SDI. (2) Internal nodes of the divider and the comparators go 0.3–0.4 V above VDD (up to 3.68 V at 3.3 V), so use VDD / VDDV at 3.3 V or below.
- **Mismatch MC repeated (11-16, report section 3.16 (10), `scripts/review/final_mc.py adc|mixer|cpdc|pll`, `final_mc_stat.py`, `sim/mc/final_*.txt`, `layout/review/final/mc_*.log`)**: ADC 200 runs, SIGN σ 15.1 mV (43 mV at most), MAG window 317.5 ± 24.4 mV. Mixer 100 runs, I/Q 0.031 dB / 89.34 ± 0.13°, offset σ 1.3 mV. Charge pump 300 runs × 3 corners: difference of source and sink σ 1.0–1.4 µA (0.9–1.4 % of the 101–111 µA, 3.7 % at worst). Closed-loop PLL MC (`pll`, 8 runs TT / 5 SS / 5 FF, `mc_pll.log`): all 18 runs lock, static phase error TT −13…+28 / SS 50–75 / FF 25–45 ps, mismatch moves the reference spur by 0.7 dB or less (schematic level, TT −60.4…−61.0 dBc).
- **Transistor-level simulation of the whole chip (analog + digital) (11-16, report section 3.15 (13), previous pad frame, `scripts/layout/chip_spice.py`, `sim/chip/`, `layout/review/r4_chip_spice*.log`)**: in all six runs the SPI read-back, the control outputs and the PLL lock are as expected (a PEX run takes about 27 hours). **Important: the switching of the I/Q and CLKOUT pads leaks into the IF through the shared VSS; without series resistors the IF output carries 170–385 mV rms (signal about 55 mV).** With separated VSS 21–24 mV rms, with 330 Ω in series on the board 37–51 mV rms. → Series resistors (330 Ω or more) on I/Q and CLKOUT on the motherboard are required. Whether the rest at 330 Ω is below thermal noise is not settled (1 µs interval). Measures on the chip (separating VSS) are not in the GDS. **Long runs (10 µs, finished 11-17, `chip_long.py`, `r4_chip_spice_long.log`)**: the rest of the IF (from 5.2 µs, I / Q) is 30.2 / 16.1 with 330 Ω, 26.4 / 14.9 with 1 kΩ and 13.2 / 15.9 mV rms with separated VSS, and it is steady (not the start-up transient). The difference is 8.18 MHz on the I side (switching of MAG). The signal amplitude also changes, I / Q 44 / 68 (separated) → 78 / 51 mV (330 Ω) = the chip's own ADC outputs return to the IF at some tens of percent of the signal. 1 kΩ makes no difference → **the series resistors are fixed at 330 Ω**. The leak remains (only separating VSS on the chip removes it), but the runs with noise below showed a sensitivity loss of about 0.5 dB or less. **Six whole-chip runs with noise were started on 11-17 at 15:26** (`chip_spice.py run nz_ser ns_ser nz_iso ns_iso nz_ref ns_ref`, 11 µs, expected to take 1–3 days, progress in `sim/chip/noise_progress.txt`; `ns_ref` stopped at 1.178 µs with "Timestep too small" and was restarted on 11-18 at 01:45 with a largest step of 9.7 ps → stopped again at 0.694 µs. The third try (10 aF on every node by `cshunt`, 9.85 ps) was started on 11-18 at 09:50, together with the noise-free `cw_ref` as a fallback (the reference has no leak and a linear IF, so the signal response is the same without noise). The third try also stopped, on 11-19 at 01:18 at 3.245 µs → `ns_ref` is given up and the signal response of the reference is taken from `cw_ref`. `ns_ser` also stopped on 11-19 at 08:11 at 9.412 µs, but 4.9 µs of the evaluated interval (from 4.5 µs) are there, so it is used as it is): the RF noise of tb_full (including the LNA in front, σ ≈ 152 mV at the IF output), nz = noise alone, ns = the same noise + CW (ns − nz is the response to the signal), _ser = 330 Ω in series, _iso = separated VSS, _ref = separated VSS + no wires in the analog supplies (reference). **All runs ended on 11-19 at 15:54 and are analysed** (`scripts/layout/chip_noise.py` → `layout/review/r4_chip_spice_noise.log`, addition of 11-19 in report 3.15 (13)): the C/N0 of the reference is 58.9 dB-Hz, the same as at the source. Comparing the noise-only runs with the reference, the new noise is iso −20.4 dB / ser −9.7 dB → **C/N0 loss 0.06 dB with separated VSS, 0.47 dB for the chip as it is (330 Ω in series; estimates on the high side)**. The difference taken directly from signal and band noise is iso −0.4 / ser +1.6 dB (uncertain by about 1 dB): no loss visible. The GDS needs no change. `nz_ser_out` had 53 damaged lines near 5.93 µs; `load` leaves out the stretch around them. Note: the "thermal noise 10–15 mV" of report (13) (b) is the chip alone and was the wrong value to compare with (corrected).
- **SPI readback (SDO) added (11-14, report section 3.15 (10)) — pad placement and GDS updated by (12) above**:
  - Pad `bidir[5]` = SDO (right end of the bottom side; `inputs[3]` moved to the right side). While CS_N = low it sends `{ID 10101, control word bits 18…0}`, MSB first. The value is the control word in use now (written by the previous frame). It changes on the falling edge of SCLK and is high impedance while CS_N = high (pad pull-down). Readback is for SCLK 5 MHz or below (the delay from the SCLK falling edge to SDO is 24.1 ns at worst on a 3.3 V supply = SS / 125 °C / 3.0 V / 30 pF, `scripts/layout/sdo_delay.py`, `sim/sdo/`; 14.9 ns in the 4.5 V SS timing analysis).
  - Changed files: `chip/src/chip_core.sv`, `chip/librelane/slots/slot_0p5x0p5.yaml`, `chip/librelane/chip_top.sdc` (multicycle path to SDO), `chip/cocotb/gnss_spi_tb.py`, `scripts/schem/bond_diagram.py`. The analog macro is unchanged. Pull-downs were added on the unused inputs `inputs[2]` / `inputs[3]`.
  - Chip `chip/librelane/runs/RUN_2026-11-14_16-56-53` (LVS match, magic / KLayout DRC 0, antenna 0, XOR 0, slew violations 0, setup / hold 0.73 / 0.46 ns). RTL / GL cocotb pass. precheck passed (`chip/precheck_q/runs/RUN_2026-11-14_17-09-52`, `layout/review/precheck_r4.log`).
  - **Final GDS `chip/final/gds/chip_top.gds` SHA-256: `1da43f4ea471dff0eb9df7805c477003da8d6b22f742445fa11dc426a16d7a8b` (86227586 bytes).**
  - precheck: `cd chip/precheck_q && nix-shell ~/tools/gf180mcu-precheck/shell.nix --run "PDK_ROOT=$HOME/pdk PDK=gf180mcuD python3 ~/tools/gf180mcu-precheck/precheck.py --input ../final/gds/chip_top.gds --slot 0p5x0p5"` (without PDK_ROOT / PDK it fails with "PDK not found"; about 67 minutes).
  - The additional simulations are `scripts/review/*.py`, the logs `layout/review/*.log`. After changing `gen_cells.py`, run `run.netlist('tb_full')` before rebuilding the layout. After changing a leaf cell, rebuild `if_chain` / `pll_core` with `build.py` before `top_build.py`.
  - Firmware: set BWW=1 on a chip that needs B=11, BWN=1 on a chip that locks at a low VCTRL with B=00, and both 0 otherwise.
  - **Remaining checks run (11-14, report section 3.15 (11), GDS unchanged)**: (a) transistor-level simulation of the whole digital core (`scripts/layout/core_spice.py`, `sim/core/`; write and readback pass in 3 conditions; SCLK fall → SDO valid 23.2 ns at SS 125 °C 3.0 V). (b) SDO → RF coupling (`sdo*` cases of `dig_couple.py`; 0.6–0.7 times one data pad, only during a readback). (c) Stand-alone IF PEX (`pex_blocks.py if`; gain −0.6 dB, band 0.64–7.0 MHz; a thread race was fixed). (d) EM recalculation (`layout/review/em_r4/`; in-block unchanged; mesh VSS M4 1.770 mA/µm = 85 % of the 85 °C limit; junction-temperature guideline about 90 °C). Left: analog + digital together at transistor level, direct SDO → IF coupling, measurements.
  - **Figures regenerated (11-15, report section 3.14)**: `doc/sch_wired/` 42 figures (`chip_top` / `padframe` now show SDO; `python3 scripts/schem/wired.py` and `chip_top.py`), `doc/sch/` 56 files (`sh scripts/export_svg.sh`), `doc/chip_quarter.png` / `doc/macro_quarter.png` (`python3 scripts/layout/render_png.py`). `lo_comb`, `vco_cell`, `vco_cellk`, `inv_lod` and `aoi22` are unused legacy cells and were moved to `archive/legacy_cells/` together with `layout/mag_vco/`.
- Notes:
  - Monkey-patching `pexsim.swap` inside threads mixes up parallel sch / PEX runs (run them sequentially).
  - In open-loop VCO + mixer runs fLO drifts over a few µs (17 MHz difference between 60 ns and 0.4–1 µs), so evaluate in a late window.

## 3. Not finished: whole-chip transient simulation (`tb_full`)
Content: PLL lock, SPI write, from RF (noise + −95 dBm tone) to the 2-bit I/Q outputs, 12 µs.

History and known problems:
- rev.2 without the LNA ran 12 µs to completion in Xyce (17 hours). PLL lock, CLKOUT 16.368 MHz and SPI were fine.
  However, the testbench was missing the AC coupling at the RF input, so the RF path was not verified (fixed).
- ngspice on rev.3 (with the LNA) failed with "Timestep too small" at 1.76 ns / 13.6 ns when the supply was ramped from 0 V.
  So VDD is now fixed at 3.3 V + `uic` (all nodes start at 0 V; the POR works from its RC charging).
- With that setting ngspice took more than 30 minutes even for 40 ns, which was very slow (reason not investigated).
  Possibly the time step is reduced by the time constants around the LNA right after start-up (4 pF coupling capacitors etc.).
- The Xyce version (converted with `scripts/to_xyce.py`) has been checked for syntax and a 1 ns run on rev.3.
  Xyce does not support trnoise, so RF noise is left out and only a CW tone is applied.
- With ngspice-47 do not use `.option klu` for large transients (see above).
- When using trnoise in ngspice, the run stops when a noise sample point coincides with a PWL corner to within a few fs.
  As a countermeasure the sample interval is a non-dividing value (49.7 ps) and `.option minbreak=1e-12` is set.

### Work on 2026-11-01 (new PC: ngspice-47 / Xyce 7.9 / open_pdks 792ef67)
- **The ngspice "Timestep too small" was caused by the KLU solver.**
  Only with `.option klu` the time step drops to 6e-24 within a few ns and the run stops (8.58 ns with noise, 0.34 ns without).
  SPARSE 1.3 (no klu) runs 40 ns without problems, with the step staying at 5 ps at the same time point.
  - The failing node name (vcsn#branch) moves to vsclk / vref when series resistors are added, so the cause is not in the circuit.
  - rshunt / gmin / trap / with or without noise did not help. With `pivrel=0.1` it passed 15 ns but failed at 25 ns;
    with `pivrel=1` it completed 40 ns (86 s). The cause is that KLU reuses an old pivot order on refactor and picks a tiny pivot.
  - Fix: `klu` removed from `tb_full` (`gen_tb.py`). 40 ns takes 105 s in ngspice SPARSE and 103 s in Xyce.
  - The earlier rev.3 failures during the supply ramp (1.76 / 13.6 ns) probably have the same cause (not confirmed).
- With the new PDK the MOS symbols emit `par=@m`, which Xyce M devices reject → `to_xyce.py` now removes it.
- RF noise for Xyce: `to_xyce.py` replaces trnoise with a PWL file of Gaussian random values with the same rms at 49.7 ps spacing
  (`sim/xyce/tb_full_vrnp_noise.csv`, seed=1). Xyce can now run with noise as well.
- Xyce MPI parallelism does not help (40 ns: serial 103 s, 4 ranks 120 s, 8 ranks 103 s). Running serially.
- **Xyce 12 µs with noise completed** (8 h 24 min). Results agree with ngspice (VCTRL 2.003 V, CLKOUT 16.368 MHz, 59.5 mA).
  Details in section 3.9 of `doc/report_EN.md` and `scripts/full_detail.py`.
- Check without noise, 5 µs (both tools): LO Q−I −90 to −91°, mixer Q−I 87 to 90° (Q/I +0.5 dB), normal.
  IF Q−I 82 to 86°, settling about 0.5 µs after the SPI write.
  - Procedure: in `sim/netlist/tb_full.spice` / `sim/xyce/tb_full.cir` set the noise sources to `dc 0`, shorten to 5 µs, add the LO nodes to the outputs
- Newly found items (open at that time):
  1. The mixer conversion gain is 2–3 dB lower than in the block test → **cause identified** (table in report section 3.9).
     - LO waveform of the real VCO (fundamental 2.27 V vs 2.53 V for an ideal square wave): −2.1 dB
     - `divbuf` loaded only LOIP, so the I side lost another −0.35 dB (I/Q difference +0.4 dB, quadrature error 2–3°)
     - IF loading and bias sharing are unrelated. The isolation netlists are as in the report table (work files, outside the repository)
     - **Fixed on 2026-11-02**: dummy `divbuf`s (XDBD_*) added to LOIN / LOQP / LOQN in `top()` of `gen_cells.py`.
       Results of `tb_full` without noise, 5 µs (ngspice):
       - LO I/Q 1.971 / 1.976 V, −90.2°
       - Mixer Q/I +0.12 dB, Q−I 89.5° (before the fix +1.42 dB, 86.3°)
       - IF Q/I +0.06 dB, 91.5°
       - Lock at VCTRL 1.998 V, IDD 60.7 mA (+1.35 mA)
       The price is 0.4–1 dB less conversion gain, 25.4 dB for the chip → `G_RX_DB` in `gnss_sysim.py` updated to 25.4, σ and AGC margins in report section 3.3 updated.
       The VCO lock point is about 2.0 V at TT and about 2.25 V at SS 85 °C (B=11), within range (report section 3.5).
       The 12 µs run with noise was not repeated after adding the dummies (checked with 5 µs without noise).
  2. A common-mode transient of 70–175 mV appears in the IF while the SPI clock is running
  3. **Issues found in the 2026-11-02 corner check (report section 3.10) → both fixed on 2026-11-03.**
     - **AC-coupled LO**: CAC* 2 pF + RAC* 20 kΩ and a 1.60 V bias (RLA/RLB divider + CLOB 50 pF) added to `mixer_iq`.
       Block-level conversion gain with the real VCO: TT 28.7, SS 25.3, FF 29.4 dB.
       Chip conversion gain in `tb_full` without noise, 5 µs (ngspice): 28.5 dB. Also VCTRL 2.176 V, LO −90.2°, IF Q/I +0.14 dB / 88.0°, IDD 61.2 mA.
       → `G_RX_DB` = 28.5. The recomputed `tb_lna` values (NF 1.46 dB, gain 14.4 dB) were also put into `gnss_sysim.py`.
       `tb_lna` uses a static LO, so after AC coupling all I/Q switches sit half on at the 1.6 V bias.
     - **VCO start-up circuit**: in `vco_ring4`, p2 = n2 is detected from the stage-2 dummy buffer (RC about 5 ns) and the stuck node is pulled down by one 8u NMOS.
       The kick cell `vco_cellk` (same-size dummy on the OP side) is used only in stages 1 and 2; d2 + d3 = d1 + d4 keeps the quadrature.
       The B1 current branch went from m = 4 to 8. The ring escapes the latch at every corner and every hi/lo starting point.
       VCTRL at 1571 MHz: TT 2.18 / SS 2.40 / FF 1.39 V, SS maximum frequency 1610 MHz, I/Q 0.3–0.55°.
       Rejected alternatives (footer, kick on every stage, 4u kick) are in the table of report section 3.10.
     - PLL closed loop (after adding the start-up circuit, from VCTRL 0 V): TT 2.179 V (3 µs), FF 1.327 V (1.5 µs).
       SS overshoots to 2.85 V, swings back to 2.32 V and locks at 2.427 V after about 10 µs (because the VCO gain drops to about 120 MHz/V).
     - **Icp doubled at B=11 (implemented 2026-11-03)**: second current-source set in `cp` (switched by MPE2/MNE2), at first HI = B0·B1 in `pll_core` (tied to B=11). **On 11-04 changed to independent control by SPI bit 16 (ICP2)** (frame 24 bit, bits 23–17 reserved). Closed loop SS (ICP2=1) 2.4170 V, TT (ICP2=0) 2.1795 V, identical to the tied version; TT with ICP2=1 also locks in 2.3 µs.
       Effective Icp at SS 233 → 479 µA. SS phase margin 44° → 55° (49–58° with R, C spread), fc 0.51 MHz, lock about 7 µs (2.417 V). TT/FF (B=00) unchanged (report section 3.6).
     - Loop characteristics (2026-11-03): fc / phase margin TT 0.95 MHz / 59°, FF 1.57 MHz / 56°, SS 0.31 MHz / 45° (38–51° with R, C spread). Integrated phase noise 1.1–1.7° rms, no problem (values before doubling Icp).
     - Phase noise (with the start-up circuit, transient jitter with injected node noise currents): TT −108.1, SS −109.7 dBc/Hz @ 1 MHz (unchanged from rev.1 −108.0).
     - **Additional checks (2026-11-03 to 04, report section 3.11)**:
       - Supply ramp 1 / 10 µs: TT and SS lock automatically (2.1–2.6 / 5.9–6.1 µs from VDD at 90 %)
       - Band coverage: TT/FF are fine with B=00 at every PVT point. SS needs B=10 (cold) / B=11 (only required at 85 °C 3.135 V). With B=11 + doubled Icp at cold SS, fc is 2 MHz and PM 45–55° → band rule "lowest band with VCTRL ≤ 2.5 V" and reselection on temperature change are required. → separated into the ICP2 bit on 11-04
       - Mismatch MC: IF offset σ 9 mV, ADC SIGN σ 13 mV, MAG threshold σ 16–17 mV, VCO starts 120/120, I/Q σ 0.5–0.7° (max 1.8°)
       - **VCO supply sensitivity TT 157 / SS 395 MHz/V. In closed loop 20 mVp @ 1 MHz → 3 rad of LO phase. −40 dBc needs 0.13 mVp → an LDO for the VCO supply is the next design item**
       - SS `tb_full` without noise, 14 µs (finished 11-04): PLL locks at 2.4445 V, CLKOUT 16.368 MHz, IDD 64.0 mA, LO −90.1°, mixer 25 dB and 90.2° OK. The IF gain was only about 19 dB (fixed below)
       - **Fixed (11-04)**: the IF tail currents and SK follower currents come from the proportional bias `bias_if` (I = 0.288 VDD / 9 RL units), fixing the VGA output operating point at 0.363 VDD. The ADC ladder center was also moved to 0.363 VDD and the `tb_ifadc` input level was scaled by 3.29 to match rev.3
         - `tb_if` over 18 PVT points: gain at code 01 47.7–54.3 dB, noise the same as before the change
         - `tb_full` without noise after the change: SS (12 µs) IF gain 50.2 dB, Q/I −0.07 dB, 90.2°, IDD 55.7 mA, VCTRL 2.4443 V / TT (8 µs) IF gain 51.9 dB, IDD 59.6 mA, VCTRL 2.1761 V
         - The SS mixer output is 1.7 dB smaller than before the change (presumably the Miller capacitance of VGA1, not isolated)
     - Remaining: SS frequency margin +2.5 %. `tb_full` after the Icp switch not run (TT has B=00 with the switched leg OFF, so no change is expected)
     - The 12 µs `tb_full` with noise completed on 2026-11-03 in both ngspice (7 h 15 min) and Xyce (10 h 18 min): VCTRL 2.175 / 2.217 V, CLKOUT 16.368 MHz, 61.2 / 61.4 mA, IF rms 165, 144 / 167, 163 mV (prediction 152 mV), MAG=1 ratio 0.30, 0.17 / 0.32, 0.29 (report section 3.9)
     - The following describes the state as of 11-02.
     - At FF (−20 °C 3.465 V) the mixer gain drops to 12.5–13.7 dB (TT 25.6 dB).
       With the DC-coupled LO, a low VR (1.6 V at FF) pushes the Gm stage into the linear region.
       Proposed fix: AC-coupled LO (2 pF) + 20 kΩ to a 1.6 V bias, giving FF / TT / SS = 28.4 / 28.4 / 25.5 dB.
     - VCO common-mode latch: at SS (whole VCTRL range) and TT (VCTRL ≥ 2.7 V) there is a stable non-oscillating state.
       Doubling the latch fixes it, but the SS maximum frequency drops to 1425 MHz, so the VCO needs retuning.
     - The PLL locks at SS 2.39 V and FF 1.217 V (closed loop 4 µs).
     - The work netlists are outside the repository. How to build a corner: switch `.lib` to ss/ff, res_ss/res_ff, mimcap_ss/mimcap_ff, change `.temp` and VDD, select the band with B0/B1
     - Note: waiting with `pgrep -f "ngspice -b X"` matches its own command line and never finishes (use `pgrep -f "^ngspice"`)
→ **The `tb_full` of chapter 3 is done.** The "Next steps (proposal)" below are as of 2026-10-30; items 1 to 4 have been dealt with.
- **ngspice SPARSE 12 µs completed** (2026-11-01 23:55 → 11-02 05:08, 5 h 12 min, `doc/full_ngspice_summary.json`):
  - PLL: VCTRL 2.03 V (1 µs) → locks at 1.948 V (3 µs). CLKOUT 16.368 MHz. IDD 59.4 mA (block sum 58 mA)
  - Tone (4–12 µs, correlation): mixI 0.125 mV (expected 0.14), ifI 53 mV (expected ≈ 50 mV, gain code 01).
    However, the noise floor in a 125 kHz bandwidth is about 20 mV at the IF, so the I/Q amplitude ratio and phase cannot be judged at −95 dBm (Q side 29.5 mV, Q−I 128°)
  - ADC (130 samples): MAG=1 ratio I 0.146 / Q 0.262 (Gaussian expectation from IF rms 126 / 146 mV: 0.21 / 0.28).
    SIGN mean −0.015 / −0.046 → the "SIGN stuck at 0" seen in rev.2 does not occur with noise
  - 16.368 MHz harmonics at the IF output 0.3–2.1 mV each (same on I and Q, presumably clock coupling). About 1 % of the 157 mV MAG threshold, small impact
  - To check the I/Q phase, a rerun without noise or with a strong tone of about −75 dBm is needed

### Next steps (proposal)
1. First check speed and convergence with short runs: `scripts/run_full.sh ngspice 40n` and `scripts/run_full.sh xyce 40n`.
   See which is faster and run the 12 µs production run with that one.
2. Options if it is too slow:
   - (a) Shorten the time span (PLL lock about 3 µs + IF settling → about 8 µs)
   - (b) Run the whole chip with the LNA replaced by an equivalent ideal model (the LNA itself is verified in `tb_lna` / `tb_rx`)
   - (c) Use the parallel (MPI) build of Xyce
3. When finished, run `python3 scripts/full_analyze.py ngspice|xyce` (`run_full.sh` does it automatically).
   Items to look at: VCTRL trajectory, CLKOUT, tone amplitude / I/Q phase per stage, ADC output statistics (MAG=1 ratio), supply current.
4. Also check what was observed in the rev.2 Xyce run: 16.368 MHz harmonics (150–250 MHz, 3–5 mV) on the IF output,
   and SIGN stuck at 0 without RF (suspected ADC kickback or coupling from the digital part into the common bias line).
   Evaluate the impact on the 2-bit statistics in the whole-chip simulation with noise.

## 4. Environment setup
```sh
# Needs: GF180MCU PDK, xschem >= 3.4, ngspice >= 41, python3 (numpy scipy matplotlib), optionally Xyce 7.9
export PDK_ROOT=~/pdk PDK=gf180mcuD
python3 scripts/gen_cells.py && python3 scripts/gen_tb.py   # regenerate the schematics
python3 scripts/run.py tb_lna                                 # example: block-level simulation
scripts/run_full.sh both 12u                                  # whole chip (detach with nohup)
```
- ngspice has `set num_threads=1` in every testbench (enabling OpenMP makes it slower).
- Xyce was built with `~/src/xyce/build_xyce.sh` (outside this repository).
  Dependencies: `sudo apt install -y cmake gfortran libblas-dev liblapack-dev libsuitesparse-dev`
- `sim/` can be regenerated and was not carried over. The netlists contain absolute PDK paths, so always regenerate them on the new machine.

## 5. Tool pitfalls (what bit us)
- The MIM model name `cap_mim_2f0fF` that the PDK symbol uses by default does not exist. Use `cap_mim_2f0_m4m5_noshield` (handled in `xsch.py`).
- Writing `{...}` in an xschem property value breaks the parser.
- The TSPC dividers malfunction with slow clock edges (the /3 stage is driven from a lightly loaded node).
- If one ngspice source has both `trnoise(...)` and `sin(...)`, only the sin takes effect. Use separate sources in series.
- Xyce: MOS as M devices, parameter expressions expanded to numbers, hierarchical node separator `:` (handled in `to_xyce.py`).
