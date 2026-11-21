# GF180MCU 用 GNSS AFE (Wafer.Space)

GPS L1 C/A + Galileo E1 受信機のアナログフロントエンドです (MAX2769 クラス、インダクタレス雑音キャンセル LNA 内蔵)。
用途は衛星軌道投入ロケット搭載の GNSS 受信機です。設計提案、xschem 回路図、ngspice の結果、レイアウトとチップ統合を含みます。
英語版: [README_EN.md](README_EN.md)

- 設計報告書: [doc/report.md](doc/report.md) (英語版 [doc/report_EN.md](doc/report_EN.md))
- 作業再開メモ: [RESUME.md](RESUME.md) (英語版 [RESUME_EN.md](RESUME_EN.md))
- 回路図 (xschem、ラベル接続): `xschem/` (最上位 `xschem/gnss_afe_top.sch`)、SVG は `doc/sch/`
- **線で接続した回路図 (PNG / SVG)**: `doc/sch_wired/` — 全セル、アナログマクロ最上位 (`gnss_afe_analog.png`)、
  チップ全体 (`chip_top.png`: パッドフレーム + デジタルコア + アナログマクロ)、パッド配置図 (`padframe.png`)。
  素子は PDK の素子 (nfet_03v3 / pfet_03v3 / ppolyf_u_1k / cap_mim_2f0fF) で、W / L / nf / m を記載しています (報告書 3.14 節)
- テストベンチ: `xschem/tb_*.sch`。実行は `python3 scripts/run.py tb_<名前>`
- 生成スクリプト (設計の一次ソース): `scripts/gen_cells.py`、`scripts/gen_tb.py`
- レイアウト: `scripts/layout/` (Python 生成)、成果物は `layout/`。チップ統合は `chip/` (wafer.space テンプレート、LibreLane、クオーターサイズ slot 0p5x0p5。旧 0p5x1 版は `archive/0p5x1/`)

必要なもの: `PDK_ROOT` / `PDK=gf180mcuD`、xschem 3.4 以上、ngspice 41 以上。
線で接続した回路図の生成には、さらに node (elkjs、`cd scripts/schem && npm install`) と python の cairosvg が必要です。
