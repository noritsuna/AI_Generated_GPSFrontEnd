# GNSS AFE for GF180MCU (Wafer.Space)

Analog front end for a GPS L1 C/A + Galileo E1 receiver (MAX2769 class, with an on-chip inductorless noise-cancelling LNA),
for a GNSS receiver on orbital launch vehicles. The repository holds the design proposal, the xschem schematics,
the ngspice results, the layout and the chip integration.
Japanese version: [README.md](README.md)

- Design report: [doc/report_EN.md](doc/report_EN.md) (Japanese [doc/report.md](doc/report.md))
- Resume notes: [RESUME_EN.md](RESUME_EN.md) (Japanese [RESUME.md](RESUME.md))
- Schematics (xschem, label connected): `xschem/` (top: `xschem/gnss_afe_top.sch`), SVG exports in `doc/sch/`
- **Wire-connected schematics (PNG / SVG)**: `doc/sch_wired/` — every cell, the analog macro top (`gnss_afe_analog.png`),
  the whole chip (`chip_top.png`: pad frame + digital core + analog macro) and the pad map (`padframe.png`).
  Devices are the PDK devices (nfet_03v3 / pfet_03v3 / ppolyf_u_1k / cap_mim_2f0fF) annotated with W / L / nf / m (report section 3.14)
- Testbenches: `xschem/tb_*.sch`, run with `python3 scripts/run.py tb_<name>`
- Generators (single source of the design): `scripts/gen_cells.py`, `scripts/gen_tb.py`
- Layout: `scripts/layout/` (Python generated), results in `layout/`. Chip integration in `chip/` (wafer.space template, LibreLane, quarter slot 0p5x0p5; the old 0p5x1 version is in `archive/0p5x1/`)

Requires `PDK_ROOT` / `PDK=gf180mcuD`, xschem >= 3.4 and ngspice >= 41.
The wire-connected schematics also need node (elkjs: `cd scripts/schem && npm install`) and the Python package cairosvg.
