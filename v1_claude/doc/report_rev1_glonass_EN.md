# GNSS Analog Front End (GPS L1 / Galileo E1 / GLONASS L1) — GF180MCU Design Proposal

Target: Wafer.Space shuttle (GlobalFoundries GF180MCU, `gf180mcuD`, 3.3 V devices)
Reference: functions equivalent to the MAX2769 (without the LNA)
Application: GNSS receiver on orbital launch vehicles (Falcon 9 / H-IIA / H3 class)
(English translation of `doc/report_rev1_glonass.md`, the rev.1 GLONASS version. The current design is described in `doc/report_EN.md`.)

Unless stated otherwise, the numbers in this document are ngspice-47 simulations of netlists generated from the xschem schematics, with the official GF180MCU models (typical, 27 °C).
Values marked "estimate" are based on analytic formulas or literature values, not on transistor simulation.

---

## 1. Conclusion (proposed architecture)

| Item | Proposal | Main reasons (simulation results) |
|---|---|---|
| LNA | **Not on chip.** An active antenna (G ≥ 25 dB) + SAW is assumed | Even with NF ≈ 16 dB (estimate) at the direct mixer input, 25 dB of external gain degrades the system NF by only ≈ 0.3 dB |
| LO generation | **On-chip ring VCO + integer-N PLL (N = 96 fixed, 16.368 MHz TCXO)** | 1.571 GHz is covered over all PVT (AVDD 3.3 V ±5 %) with 2-bit band switching. A loop bandwidth of ≈ 1.1 MHz suppresses the ring VCO phase noise; integrated phase error ≈ 1.2° rms (correlation loss < 0.01 dB) |
| VCO options | LC-VCO (external L) and external LO rejected | External L / bond wires change inductance under launch vibration (microphonics), putting FM on the LO. A ring VCO + wideband PLL performs well enough, so there is no reason to add external parts and vibration risk. An external LO needs an extra synthesizer and 90° generation |
| Frequency plan | LO = 1571.328 MHz. GPS/Galileo → IF **+4.092 MHz**, GLONASS (k = −7…+6) → IF **+26.7…+34.6 MHz** | The GPS IF is identical to the MAX2769 (compatible with existing software receivers). The division ratio is 2⁵×3, so TSPC prescalers alone suffice, with no odd division at 1.57 GHz |
| IF / ADC | Complex (I/Q) low IF, 2 bit each (sign/magnitude), **fs = fLO/16 = 98.208 MS/s** | All 3 systems received simultaneously in one channel. IF bandwidth 0.67–36.6 MHz, 2-bit quantization loss 0.5 dB (system sim) |
| Doppler handling | Ample margin in the IF band + ±60 kHz search in the baseband / FLL-assisted PLL + **AFC DAC (VCTCXO control)** + low-g-sensitivity TCXO | On a launch trajectory the maximum Doppler is ≈ ±41 kHz and the rate ≈ 160 Hz/s (≈ 260 Hz/s for 5 g during acceleration). For the front-end bandwidth this is a 0.15 % spread, no problem. The real constraints are (1) acquisition search range (2) tracking loop dynamics (3) TCXO vibration (g sensitivity) |

Block diagram:

```
            ext. active antenna + SAW (G>=25 dB)
                         |
 RFP/RFN (100 ohm diff) -+--> [mixer_iq: Gilbert x2] --I--> [VGA1]-[SK LPF]-[VGA2]-[SK LPF]-[VGA3]-[VGA4] --> [adc2b] --> I_SIGN/I_MAG
                         |              ^          --Q--> (same if_chain)                                   --> [adc2b] --> Q_SIGN/Q_MAG
                         |              | LO I/Q (0/90/180/270)                                                   ^ FS 98.208 MHz
 REFIN 16.368 MHz --> [refbuf]-->[PFD]-[CP]-[LF]--VCTRL-->[vco_ring4 1571.328 MHz]--+--> [divbuf]-[/2/2/2/2]--FS--+--> CLKOUT
                                   ^                                                                  |
                                   +----------------------------FB 16.368 MHz----[/3]-[/2]------------+
 AFC[7:0] --> [afc_dac R-2R 8bit] --> AFCOUT (to VCTCXO Vc)          [bias_gen constant-gm]
```

---

## 2. Assumptions and frequency plan

| Signal | RF band (including Doppler) | IF (LO = 1571.328 MHz) |
|---|---|---|
| GPS L1 C/A | 1575.42 ± 1.023 MHz ± 0.05 | +3.02 … +5.17 MHz |
| Galileo E1 (BOC(1,1) main lobe) | 1575.42 ± 2.5 MHz ± 0.05 | +1.54 … +6.64 MHz |
| GLONASS L1OF (k = −7…+6) | 1598.06 … 1605.38 ± 0.511 MHz ± 0.05 | +26.17 … +34.61 MHz |

- The negative IF side (−36…0 MHz) is the image band (1535–1571 MHz), removed by treating I/Q as complex. The IRR is set by the I/Q phase error;
  with the VCO quadrature error of 3° (sim) it is ≈ 31 dB. GNSS signals are below the noise and the noise in the image band is also limited by the SAW, so this is sufficient.
  Inmarsat downlink (1525–1559 MHz) falls partly into the image band, so a SAW with ≥ 30 dB rejection below 1560 MHz is recommended.
- fs = 98.208 MS/s (complex), Nyquist ±49.1 MHz. At the aliasing edge (98.2 − 34.6 = 63.6 MHz) the IF response is −16 dB relative to the passband.
- Output data: I/Q × (sign, mag) = 4 bit @ 98.208 MHz (LVCMOS 3.3 V) + CLKOUT.
  When only GPS/Galileo are used, a 1/6 decimation in the FPGA (16.368 MS/s) gives the same format as the MAX2769.

---

## 3. Block design and simulation results

Everything is in `xschem/*.sch` (transistor level, GF180 `nfet_03v3/pfet_03v3`, `ppolyf_u_1k`, MIM 2 fF/µm²) with the testbenches `xschem/tb_*.sch`.

### 3.1 Bias (`bias_gen`, `tb_bias`)
Constant gm (β multiplier) + start-up. Distribution through low-Vov diodes (NMOS 16u/2u, PMOS 32u/2u at 50 µA).

| Condition | Unit current |
|---|---|
| 27 °C, 3.3 V | 50.8 µA |
| −40 / 85 / 125 °C | 28.6 / 77.7 / 97.8 µA |
| VDD 2.8 → 3.6 V | 49.9 → 51.3 µA (±1.5 %) |

With constant gm, gm·R (= amplifier gain) stays constant over temperature, but the current itself changes a lot with temperature (improvement item below).

### 3.2 Mixer (`mixer_iq`, `tb_mixer`, `tb_mixer_zin`)
I/Q double-balanced Gilbert cells. Gm pair 80u/0.28u, switches 40u, tail 2 mA × 2, load 1.3 kΩ ∥ 1 pF, input terminated with 2 × 50 Ω.

| Item | Result |
|---|---|
| Input impedance (differential) | 113 − j17 Ω @ 1.575 GHz (S11 ≈ −20 dB, 100 Ω reference) |
| Conversion gain (differential voltage) | **15.0 dB** |
| I/Q amplitude / phase difference (ideal LO) | 0.04 dB / 90.09° |
| Compression | 0.3 dB at −9.5 dBm input (P1dB > −9 dBm) |
| NF (estimate) | ≈ 16 dB (analytic formula for the Gilbert cell; ngspice has no PSS/PNOISE) |

### 3.3 IF chain (`if_chain` = `vga` ×4 + `sk_lpf1/2`, `tb_if`)
Every stage is AC coupled (HPF ≈ 0.3 MHz per stage): with the GPS IF at 4.092 MHz, DC offset and 1/f noise are removed by construction, and no DC offset cancellation loop is needed.
The SK LPF uses PMOS source followers (bulk = source), with the capacitors numerically optimized for a 4th-order Butterworth (f0 = 40 MHz).

| Gain code (G1=G2=G3) | 4.092 MHz | 34.6 MHz | 63.6 MHz | −3 dB bandwidth |
|---|---|---|---|---|
| 00 | 19.4 dB | 17.0 dB | 3.1 dB | 0.68 – 36.6 MHz |
| 01 | 29.8 dB | 27.5 dB | 13.6 dB | 0.68 – 36.8 MHz |
| 10 | 41.1 dB | 38.9 dB | 25.4 dB | 0.67 – 37.4 MHz |
| 11 | 44.1 dB | 42.0 dB | 28.6 dB | 0.67 – 37.6 MHz |

- Each stage has its own 2 bits (≈ 3/6/10/11 dB), giving 64 settings in ≈ 3.5 dB steps and an overall range of 19–44 dB.
- Input-referred noise (4 MHz): 7.5 nV/√Hz (maximum gain) – 26 nV/√Hz (minimum gain). Divided by the mixer gain this is 1.3 nV/√Hz referred to RF, small compared with the mixer noise.
- The total gain from RF input to ADC input is 34–59 dB. The AGC target that puts the ADC threshold ±0.157 V at 1σ corresponds to 25–40 dB of external gain.

### 3.4 2-bit ADC (`adc2b` = `sa_comp` ×3, `tb_adc`)
A 4-input StrongARM (signal pair + reference pair) decides (v − Vth) directly → isolation inverters → NOR SR latch. MAG = (v > +Vth) OR (v < −Vth).

| Item | Result (98.208 MS/s, ramp input) |
|---|---|
| SIGN threshold | +3.5 mV (within one ramp step) |
| MAG thresholds | −155 mV / +158 mV (design ±157 mV) |
| Supply current | 0.56 mA (including 0.5 mA for the threshold ladder) |

In the first design the Miller capacitance at the SR latch input depended on its state and caused 33 mV of hysteresis. This was fixed by inserting the isolation inverters.

### 3.5 VCO (`vco_ring4`, `vco_cell`, `tb_vco`)
4-stage ring of pseudo-differential inverters + weak cross-coupled latches (45° per stage → 0°/90°/180°/270° directly).
VCTRL → NMOS V/I (source degenerated) → PMOS mirror drives the ring supply VR with a current. B1/B0 add coarse-tuning currents (+2×, +4×).

| Corner | Band / VCTRL at 1571.328 MHz | KVCO there |
|---|---|---|
| TT 27 °C 3.3 V | B=00 / 1.94 V | 560 MHz/V |
| FF −40 °C 3.6 V | B=00 / 1.17 V | 1.1 GHz/V |
| SS 85 °C 3.135 V | B=11 / 2.38 V | 0.4 GHz/V |
| SS 85 °C 3.0 V | **Not covered** (B=11 reaches at most 1.58 GHz @ 2.75 V) | — |

→ AVDD is specified as **3.3 V ±5 %** (external LDO). The I/Q quadrature error is ≈ 3° at TT, and the VCO + LO buffer current is ≈ 3.5 mA.
The band is chosen by calibration at start-up (the host or a simple FSM selects the lowest band for which VCTRL falls inside the window).

Phase noise: from the period jitter in an ngspice transient with noise (current sources equivalent to transistor thermal noise injected at each ring node),
**−108 dBc/Hz @ 1 MHz** (f0 = 1.562 GHz, σT = 64 fs, 1561 periods; the numerical jitter floor of 1.6 fs is subtracted).
The analytic formula (Hajimiri, +6 dB margin) gives −104 dBc/Hz, so the PLL budget uses the conservative −104 dBc/Hz.
The transient noise does not include 1/f noise (the close-in 1/f³ region), so inside the PLL bandwidth (≈ 1 MHz) the PLL is assumed to suppress it.

### 3.6 PLL (`pll_core` = `refbuf`, `pfd`/`dff_r`, `cp`, `loop_filter`, `divbuf`, `div96`; `tb_pfdcp`, `tb_div`, `tb_pll`)
- Divider: an AC-coupled self-biased inverter restores the LO (0–VR) to 3.3 V swing → TSPC /2 × 4 (→ **FS = 98.208 MHz**) → /3 → /2 (→ FB 16.368 MHz).
  - FS: 98.204 MHz for a 1571.328 MHz input at TT (LO/16 within the measurement-window error). The prescaler still works with a 2.0 GHz input (125.0 MHz), a margin of more than 27 %.
  - FB: **16.368 MHz (/96)** at both TT and SS/85 °C/3.135 V. The divider draws 0.70 mA.
  - History: at first the /3 stage was driven from the heavily loaded FS node (ADC clock); the slow edges made the TSPC malfunction and divide by 2.
    It was fixed by driving the /3 stage from the lightly loaded internal node c16 and providing FS from a dedicated buffer.
- PFD: two 7474-type 6-NAND DFFs + reset delay (4 inverter stages). CP: 200 µA (203/204 µA at DC).
  - Phase detector gain 4.2 µA/ns (effective Icp ≈ 250 µA, including the switch charge sharing). No dead zone down to ±0.1 ns. Static phase offset ≈ 0.3 ns.
- Loop filter (on chip): R = 5.2 kΩ, C1 = 119 pF, C2 = 9.8 pF.
- Loop analysis (`scripts/pll_design.py`, with the simulated Icp and KVCO):

| Corner | Icp | KVCO | fc | Phase margin |
|---|---|---|---|---|
| TT | 250 µA | 560 MHz/V | 1.09 MHz | 59° |
| FF −40 °C | 143 µA | 1.14 GHz/V | 1.24 MHz | 58° |
| SS 85 °C | 380 µA | 360 MHz/V | 1.07 MHz | 59° |

  The temperature coefficient of Icp from the constant-gm bias and the corner dependence of KVCO cancel each other, keeping the bandwidth at 1.07–1.24 MHz.
- Phase noise budget (`doc/pll_phase_noise.png`): integrated phase error 1.15° rms (1 kHz–50 MHz) → correlation loss 0.002 dB.
- Transistor-level closed loop (`tb_pll`: bias + VCO + whole PLL, VCTRL initial value 1.7 V, `doc/pll_lock.png`):
  - After the transient right after the ring starts, it **locks in about 2 µs**. VCTRL = 1.935 V (agrees with 1.94 V of tb_vco), LO = 1.5714 GHz (1571.328 MHz within the resolution of the measurement window).
  - The steady-state REF–FB phase difference is −0.27 ns, matching the offset from CP mismatch in tb_pfdcp.
  - Reference spur from the VCTRL ripple: **−47 dBc @ ±16.368 MHz** (2nd −52 dBc).
    Without strong interferers in the GNSS band the reciprocal mixing is negligible, but it is listed as an improvement item.

### 3.7 AFC DAC (`afc_dac`, `tb_afc`)
8-bit R-2R (R = 10 kΩ poly). 0–2.98 V into a 100 kΩ load (VCTCXO Vc), 1 LSB = 11.7 mV, DNL 0.69 LSB, INL 0.35 LSB.
With a VCTCXO pull of about ±10 ppm / 2 V, 1 LSB ≈ 0.06 ppm ≈ 92 Hz (L1).

### 3.8 Top (`gnss_afe_top`, `tb_top`)
The netlist of the top schematic is generated by xschem without errors, and the connections of all 28 subcells were checked.
However, the DC operating point of the whole chip (about 820 transistors after m expansion, including the ring oscillator) did not converge in ngspice within 25 minutes (same with the KLU solver).
The supply current is estimated as the sum of the block simulation values:

| Block | Current |
|---|---|
| VCO + LO buffers | 3.7 mA |
| Mixer I/Q | 4.0 mA |
| IF chain × 2 (4 VGA stages + 2 SK stages) | 24 mA |
| ADC × 2 | 1.1 mA |
| Divider + CP + reference buffer | 1.0 mA |
| CLKOUT (2 pF @ 98 MHz) + bias + AFC DAC | 1.2 mA |
| **Total** | **≈ 35 mA (≈ 115 mW @ 3.3 V)** |

Most of the power goes to the IF chain (low power was not a requirement, so bandwidth and linearity took priority).

---

## 4. Doppler handling on a launch vehicle

### 4.1 Doppler range (`scripts/doppler.py`, `doc/doppler_profile.png`)
Results with a simplified launch trajectory (28.5°N eastward, 200 km altitude / 7.79 km/s at T+540 s, then LEO coasting) and a Walker constellation model:

| System | Maximum Doppler | Maximum rate (model) |
|---|---|---|
| GPS L1 | ±38.4 kHz | 153 Hz/s |
| Galileo E1 | ±39.9 kHz | 154 Hz/s |
| GLONASS L1 | ±41.4 kHz | 160 Hz/s |
| TCXO ±2.5 ppm | ±3.9 kHz | — |

Considering the real maximum acceleration (4–5 g just before second-stage cut-off), the rate reaches ≈ 260 Hz/s, and the jerk is large at stage separation and engine cut-off.

### 4.2 Front-end measures (implemented in this design)
1. **IF band margin**: a ±50 kHz Doppler is small compared with the IF band (0.67–36.6 MHz), and even the worst case GLONASS k=+6 (34.61 MHz) is inside the passband (−2.4 dB relative to 4 MHz).
   The lower BOC lobe of Galileo E1 (1.54 MHz) is also above the HPF (0.67 MHz). What helps here is less "widening the band" than **a low-IF plan that keeps the signal away from DC**.
2. **AFC DAC (8 bit)**: the receiver clock drift estimated by the baseband (the component common to all satellites) pulls the VCTCXO,
   correcting the center of the Doppler search window. The per-satellite Doppler cannot be cancelled this way and is handled by the baseband NCO.
3. **2-bit / 98 MS/s output**: the baseband can build digital filters / NCOs with any bandwidth and center frequency (band extension, per-system processing).

### 4.3 Required baseband measures (proposal)
- Acquisition: Doppler search **±60 kHz** (500 Hz bins, 1 ms coherent × 4 non-coherent).
  In `scripts/gnss_sysim.py`, GPS (+38 kHz) and GLONASS k=+6 (−41 kHz) passed through the simulated IF response + 2-bit ADC were acquired at 44 dB-Hz,
  with peak/mean 12.7 / 13.2 dB in the correct bins (`doc/acquisition.png`).
- Tracking: **FLL-assisted 3rd-order PLL** (FLL bandwidth ≈ 10 Hz, PLL bandwidth 15–20 Hz). A 3rd-order loop has zero steady-state error under constant acceleration (constant Doppler rate).
  During high-jerk stage separation switch to FLL only, and use a carrier-aided DLL.
- Inertial / trajectory aiding: predicting the Doppler and its rate from the flight-plan trajectory or the IMU and feeding them to the NCO narrows the search to ±a few kHz and speeds up (re)acquisition.

### 4.4 Vibration (g sensitivity) — the most important point outside the front end
The acceleration sensitivity Γ of the TCXO phase-modulates the LO. Peak phase deviation = Γ·a·f_L1 / f_vib (for a = 10 g):

| Γ | 20 Hz | 100 Hz | 500 Hz |
|---|---|---|---|
| 1 ppb/g (typical TCXO) | 45° | 9.0° | 1.8° |
| 0.1 ppb/g (low-g part) | 4.5° | 0.9° | 0.18° |

The PLL (1 MHz bandwidth) passes the reference modulation straight to the LO, so it cannot be removed on chip. **A low-g-sensitivity (≤ 0.1 ppb/g) TCXO/OCXO and a vibration-isolated mount** are recommended.
For the same reason, an LC-VCO with external inductors would get FM from vibration-induced inductance changes, so a ring VCO was chosen.

---

## 5. External parts and pins (proposal)

| Pin | Description |
|---|---|
| RFP, RFN | Differential RF input (100 Ω). For single-ended use, a balun or RFN AC grounded |
| REFIN | 16.368 MHz TCXO/VCTCXO (clipped sine 0.8 Vpp, AC coupled) |
| AFCOUT | To the VCTCXO Vc |
| B0, B1 | VCO band |
| IG1A/B, IG2A/B, IG3A/B | IF gain (shared by I/Q, AGC from the baseband) |
| AFC[7:0] | AFC DAC code |
| I_SIGN, I_MAG, Q_SIGN, Q_MAG, CLKOUT | 2-bit I/Q data + 98.208 MHz clock |
| VCTRL | For test (loop filter observation) |
| VDD, VSS | 3.3 V ±5 % (separate RF/VCO/IF/digital supplies recommended in the implementation) |

If the pad count is tight, the control pins (16 for B, G and AFC) are replaced by an SPI register (standard cells).

---

## 6. Open items, risks and next steps

- **No layout yet**: everything is pre-layout simulation. The parasitic capacitance of the LO wiring (1.57 GHz, 4 phases) directly lowers the ring frequency, so the frequency margin at the SS corner must be rechecked after PEX.
- **Mixer NF / VCO phase noise**: ngspice has no PSS/PNOISE, so these are estimates from analytic formulas and transient noise. Confirmation with Xyce HB / Spectre RF etc. is recommended.
- **Temperature coefficient of Icp / bias**: the constant-gm bias changes by 3.4 × from −40 to 125 °C. The loop bandwidth stays at 1.07–1.24 MHz thanks to cancellation with KVCO, but a bandgap-referenced CP current is possible.
- **CP mismatch**: static phase offset 0.3 ns, reference spur −47 dBc. A current-steering CP with a unity-gain buffer would improve it.
- **VCO headroom**: at AVDD 3.0 V, SS/85 °C does not reach 1.571 GHz (covered at 3.135 V). More margin needs a lighter LO buffer load or a dedicated VCO LDO.
- **ESD / pads**: the ESD capacitance of the RF input pad (≈ 0.3–1 pF) shifts the match, so re-match once the pad library is fixed.
- **Radiation**: for the short time until LEO insertion, TID is no problem, but SEL measures (guard rings, current limiting) must be considered in the implementation.
- **Export control**: a GNSS receiver operating above 515 m/s and 18 km is subject to COCOM / export control. This is mainly a baseband / firmware matter, but check beforehand.

---

## 7. File layout and how to reproduce

```
xschem/            schematics (.sch) and symbols (.sym), xschemrc
  gnss_afe_top.sch       top
  vco_ring4, vco_cell    ring VCO
  pll_core, pfd, dff_r, cp, loop_filter, refbuf, divbuf, div96, div2, div3, tspc_dff
  mixer_iq, if_chain, vga, sk_lpf1, sk_lpf2, adc2b, sa_comp, bias_gen, afc_dac
  inv_*, nand2, nand3, nor2
  tb_*.sch               testbenches (with ngspice control blocks)
scripts/
  gen_cells.py / gen_tb.py / xsch.py   schematic generators (single source of the design parameters)
  run.py                 netlist with xschem → ngspice batch run
  tune_sk.py             Sallen-Key capacitor optimization
  doppler.py             Doppler analysis of the launch trajectory
  pll_design.py          PLL loop / phase noise / vibration analysis
  gnss_sysim.py          system sim (IF response + 2-bit ADC + acquisition)
  vco_pn.py, plots.py, export_svg.sh
sim/               netlists and simulation results
doc/               this document, figures (png), schematic SVGs (doc/sch/)
```

```sh
export PDK_ROOT=~/pdk PDK=gf180mcuD
python3 scripts/gen_cells.py && python3 scripts/gen_tb.py   # regenerate the schematics
python3 scripts/run.py tb_if                                 # example: IF chain simulation
xschem --rcfile xschem/xschemrc xschem/gnss_afe_top.sch      # open in the GUI
```

---

## 8. Questions for you

1. **External RF configuration**: gain of the active antenna / external LNA and the SAW bandwidth. This design assumes G ≥ 25 dB and a 1560–1610 MHz passband.
2. **Baseband**: can the FPGA receive 98.208 MHz × 4-bit LVCMOS? If not, options are a decimation filter on chip or lowering fs to 65.472 MHz (giving up part of GLONASS).
3. **Reference oscillator**: is a 16.368 MHz VCTCXO acceptable (if a 10 MHz family is mandatory, the PLL division ratio will be changed)? g-sensitivity specification.
4. **Supply**: is 3.3 V ±5 % (LDO) acceptable?
5. **Package / pad count**: I/O count limits of Wafer.Space. Whether to move the control to SPI.
6. **Temperature range**: is −40…+85 °C acceptable?
7. **Additional bands**: will L2/L5 (a second channel) be needed in the future?
