# 作業再開メモ (別 PC で続きを実行するため)

最終更新: 2026-11-14。設計提案は `doc/report.md` (rev.3) にまとめています。英語版は `RESUME_EN.md`、`doc/report_EN.md` です (日本語版を更新したら英語版も合わせて更新してください)。

## 1. 現在の設計 (rev.3)
- GPS L1 C/A + Galileo E1 用 AFE、GF180MCU (`gf180mcuD`)、3.3 V ±5 %、−20…85 °C
- 雑音キャンセル LNA (インダクタなし、`lna_nc`) → I/Q サブハーモニックミキサ (LO は fLO/2 の 8 相) → IF (可変 VGA × 3 + 固定利得 × 2 + Sallen-Key × 2、0.8–7 MHz)
  → 2 bit I/Q ADC @ 16.368 MS/s
- LO はリング VCO + 整数 N PLL (16.368 MHz TCXO × 96 = 1571.328 MHz)
- 制御は SPI (24 bit、書き込み 3 線 + 読み出し SDO。11-04 に ICP2、11-13 に IF 帯域トリム BWW / BWN、11-14 に読み出しを追加) + POR、AFC 用 8 bit DAC。ピンは 16 本 (11-08 に VCO 専用電源 VDDV、11-14 に SDO を追加)
- SS コーナーのチップは選別で落とす前提です (11-08 決定)
- 設計の一次ソースは `scripts/gen_cells.py` (セル) と `scripts/gen_tb.py` (テストベンチ)。
  `xschem/*.sch` / `*.sym` はここから生成しているので、手で編集した場合も生成スクリプト側に反映してください

## 2. 検証済みの項目
ブロック単位はすべて ngspice で検証済みです。IF / ADC / VCO / PLL の 4 種類は Xyce でも一致を確認しています。
数値は `doc/report.md` の 3 章を参照してください。
- `tb_lna`, `tb_rx` (LNA、LNA + ミキサ)、`tb_mixer`、`tb_if`、`tb_adc`、`tb_vco` (+ コーナー)、`tb_div`、
  `tb_pfdcp`、`tb_pll` (閉ループ)、`tb_bias`、`tb_afc`、`tb_spi`、`tb_ifadc` (IF + ADC + SPI 通し、雑音入り)
- システム: `scripts/gnss_sysim.py` (捕捉、折り返し雑音、リンクバジェット)、`scripts/doppler.py`、`scripts/pll_design.py`

## 2.5 レイアウトと PEX (2026-11-06〜08、詳細は `doc/report.md` 3.12 節)
- レイアウトは `scripts/layout/` の Python 生成です (`build_all.py` → `top_build.py` → `top_wires.py`)。アナログマクロ `gnss_afe_analog` は 979.4 × 3681.5 µm、DRC 0、LVS 一致です。
  - 環境: `export PDK_ROOT=~/pdk PDK=gf180mcuD`。一部だけ作り直すときは `REUSE=vga,bias_if python3 build_all.py` のように指定します。
  - magic の PEX では flatten / `extract no all` を使わないでください。halo は 2 µm です。
- PEX で対策した 3 件:
  1. SK の MIM 容量を 80 % で指定 (単位セル化で +9.6 %) → PEX の IF fh 7.08–7.25 MHz
  2. ミキサの LO 負荷を NMOS ゲート容量でトリム (`LO_TRIM`) → 151.5–162.2 fF、LO の I/Q 誤差 +0.08°
  3. ルータの離隔コスト (`router.py` の `sep_map`、`auto.py` の `SEP`) → fs から mqn への結合 48.5 → 0.31 fF
- PLL 閉ループ PEX (`scripts/layout/pex_pllmix.py`、3 並列で 4 時間 13 分):
  - VCTRL は TT 2.184 V、FF 1.445 V でロックします。SS (B=11、ICP2=1) は 1.845 V に収束中です。
  - 開ループの同調特性は `pex_vcomix.py` の deck で求めます (SS B=11 の最高周波数 1683 MHz、+7.1 %)。
- VCTRL スパイクの対策 (11-07): `vcp` / `VC` を `NET_WIDTHS` で幅 3 に、VCO 側のピンを C2 から RVT 1 kΩ + C3 0.8 pF 経由で取るようにしました (`gen_cells.py` の `loop_filter`、`.ic` に `vcp` を追加)。
  - 結果: 3 コーナーとも整定しました (TT 2.1842、SS 1.8478、FF 1.4452 V)。VCTRL の p-p は 62 / 52 / 69 mV (修正前 259 / 438 / 331 mV) です。
  - (6) の時点では、基準スプリアス k=1 が TT −22.4、SS −29.6、FF −17.5 dBc に悪化していました。原因は、RVT の後ろで高インピーダンスになった VCTRL への FS / FB / REFCK の結合 (計約 14 fF) です。
  - 対策 (11-07〜08):
    - C3 を 4 pF (45 × 45 µm) にしました。
    - `SEP["pll_core"]` で FS / FB / REFCK / ck / up / dn を VCTRL から離しました。結合は約 0.15 fF です。
    - `ROW_WIDTH["pll_core"]=600000` で 552 × 940 µm に抑えました。
    - top の `SEP` に mqp / mqn → mip / min を追加しました (mqn ↔ mip 0.55 fF)。
    - top は 979.4 × 3717.9 µm、DRC 0、LVS 一致です。
  - 結果: 基準スプリアスは TT −46.0、SS −47.7、FF −36.7 dBc です (LO 側波帯の直接測定)。VCTRL の p-p は 2.6 / 3.7 / 5.2 mV です。
  - (7) の時点で FF が 3.3 dB 不足 → 原因は CP の静的オフセット (旧 CP はスイッチオフ中に pc / nc が振れ、オン時に 55–123 fC を OUT から引く)。RVT 3 kΩ 案は −2.2 dB しか効かず FF の位相余裕 43° になるため不採用。
  - **(8) 電流ステアリング CP (11-08)**: `cp` にダミースイッチ MPD / MND (vd へ逃がす) と vd を OUT に保つユニティゲインバッファを追加。MPD は `upd = inv(UPB)` で駆動 (出力スイッチより後に切り替え)。CP のピンは UPB / DN / DNB。
    - CP 単体のオフセット TT −0.022、SS +0.006、FF −0.006 ns (旧 −0.23 / −0.04 / −0.52)。例外: SS・ICP2=1・VCTRL ≥ 2.4 V で 0.19–0.42 ns (PMOS 電流源の余裕不足、旧 CP から同じ)。
    - `SEP["pll_core"]` は VCTRL 側からも双方向に設定 (ルータは先に配線済みのネットしか見ない)。FB → VCTRL 0.07 fF。
    - `cp` 134 × 202、`pll_core` 576 × 940、top 979.4 × 3717.9 µm、DRC 0、LVS 一致。
    - **PEX 閉ループの基準スプリアス: TT −60.5、SS −48.9、FF −67.5 dBc。3 コーナーとも −40 dBc を満たしました。** VCTRL p-p 1.0 / 2.2 / 0.5 mV、REF−FB −0.14 / −0.14 / −0.10 ns。
    - (8) の波形は `sim/pllmix_steer_4p/`、(7) の旧 CP の波形は `sim/pllmix_c3_4p/`。
  - **(9) C3 1.5 pF + CP の PMOS スイッチ拡大 (11-08)**:
    - C3 4 → 1.5 pF (27.5 × 27.5 µm)。離隔で結合が 0.2 fF 以下になったため。ループモデルで FF の位相余裕 +4〜5°。
    - MPS / MPD / MPS2 / MPD2 を 8 µm nf=2、MPE2 を 24 µm nf=4 に (4 µm ではスイッチ降下 0.4 V で SS 高 VCTRL の Iup が低下)。SS・ICP2=1 の 2.5 V オフセット 0.28 → 0.075 ns。12 µm はスイッチ電荷でオフセット増のため不採用。
    - top の `SEP` に vctrl を双方向で追加 (fs 4.2 fF、mqp 14.3 fF → ≤ 0.04 fF)。
    - **PEX 閉ループの基準スプリアス: TT −54.2、SS −51.7、FF −63.1 dBc (最悪 SS、余裕 11.7 dB)。** VCTRL p-p 2.5 / 4.1 / 1.2 mV、REF−FB −0.125 / −0.063 / −0.074 ns。
    - 波形は `sim/pllmix_{tt_b0_i0,ss_b3_i1,ff_b0_i0}`。
  - 解析: `scripts/layout/pll_spur.py tt_b0_i0 ss_b3_i1 ff_b0_i0` で、最後の 9 基準周期を Hann 窓で取り、VCTRL 成分と LO 側波帯を求めます。
    - 1.2 µs の計算 (`TSTOP=1.2e-6`) は整定しておらず、k=1 を過大に出すので使えません。
- 注意 (11-07):
  - `gen_cells.py` を変えたら `run.netlist('tb_full')` を実行してからレイアウトを作り直してください。レイアウトは `sim/netlist/tb_full.spice` を参照します。
  - `pex_vco.ring_ic` は `PYTHONHASHSEED` で結果が変わっていたので、ソートして決定的にしました。
- **VCO の電源対策 (11-08、report 3.13 節)**:
  - C: `vco_ring4` の RMIN (VDD→VR 2.5 kΩ) を NB からの定電流 MMIN に、PMOS ミラーを L 0.56 µm に → 電源感度 TT 184→42–50、FF 243→48 MHz/V (回路図)。`vco_ring4` にピン NB、内部ノード `ng`。
  - A: VCO 専用電源ピン VDDV。マクロは VCO 行のレールを VDDV (`auto.py` の `ROW_VDD`、`TOP_RAILS` = VDDV, VSS)、`power_mesh.py` で VDDV ストライプ 4 本。パッドブロックに VDDV パッド + VSS (幅 555 µm)。
- **チップ統合 (11-08、report 3.13 節 (4))**: `cd chip && nix-shell --run "make librelane PDK_ROOT=$HOME/pdk"` (約 35 分)。LVS 一致、magic DRC 0、KLayout は封止リングの隅 161 件のみ (テンプレート由来)。
  - 主な修正: マクロ位置 [468, 926] (11-09 に [468, 862.3])、PAD_X 418 / VCTRL・AFCOUT パッド 1225 / 1334 µm、SRAM とマクロの PDN グリッド削除、VDDA / VDDV は PDN 外 (ストラップのみ)、`PDN_OBSTRUCTIONS`、`FP_MACRO_VERTICAL_HALO: 40`、ストラップスクリプトの修正 (アナログパッド 3 本と RF ポートを追加)、MIM 下部電極の分割 (MIMTM.11)。
  - マクロを変えたら: `build_all.py <cells>` → `top_build.py` → `export_macro.py` → LibreLane。パッドリングが変わったらパッド位置を DEF で読み直して `auto.py` の `PAD_X` / `_SIG` を更新。
- IF チェーン PEX + ボンディングワイヤ (2–5 nH) で発振しないことを確認 (report 3.13 節 (5))。基板結合は未確認。
- `tb_full` 雑音入り 12 µs の回帰 (11-09 完了、report 3.13 節 (6)): CP / C3 変更後 VCTRL 1.3526 V、A + C 1.4307 V、どちらも 1 µs 以内にロック、CLKOUT 16.368 MHz、58.2 mA、IF rms 159–160 / 115 mV。結果は `sim/full_cp/`、`sim/full_ac/`。
- I/Q の符号 (11-09): `chip_core.sv` で Q_SIGN を反転 → パッドの I + jQ は +4.092 MHz (反転なし)。マクロ / 回路図の出力は反転前 (Q が 90° 進み)。RTL テスト `chip/tb/tb_spi_rtl.sv` で確認。
- 電源リップル / 基板結合 (11-09、report 3.13 節 (8)(9)): VDDV 1 mVp @1 MHz → −38 dBc (LDO 0.3 mVp で余裕 8 dB)。**VDD 20 mVp @1 MHz → −8 dBc (主因 `refbuf`、移すと −30.5 dBc、`pll_core` + `bias_gen` 全体を移すと影響なし)**。基板結合は LO 漏れ −123 dBm (DC)、IF 帰還 −89 dB で問題なし。
- **VDD 感度の対策 (11-09、report 3.13 節 (10))**: `refbuf` を `pll_core` から出してマクロのトップで VDDV に (VCO 行の右端)。`pll_core` の入力は REFCK、入口に 1 kΩ + タイ経由のクランプ (ドメイン間)。VDD デカップリング `decap` 126 pF (PLL 行の右)。VDD 20 mVp @1 MHz → −30.4 dBc (許容 6.6 mVp)、VDDV 0.85 mVp で −40 dBc。マクロ 979.4 × 3786.1 µm、配置 [468, 862.3]。チップ `RUN_2026-11-09_11-49-34`: LVS 一致、DRC は封止リングのみ。FF ロック・投入順序は `scripts/layout/pll_checks.py`。
  - クランプのゲートを電源レールに直結すると KLayout アンテナ (ANT.11) に当たります。タイ (MTX → MTHI → MTLO) から取ってください。
- `tb_full` の回帰 (`sim/full_rb/`): VCTRL 1.4307 V / CLKOUT 16.368017 MHz / IDD 58.22 mA で、修正前と一致 (完了)
- **線で接続した回路図 (11-09、report 3.14 節)**: `doc/sch_wired/*.png` / `.svg`。全セル + `chip_top` (パッドフレーム + コア + マクロ) + `padframe` (パッドの物理配置)。
  - 再生成: `python3 scripts/schem/wired.py [cell ...]` と `python3 scripts/schem/chip_top.py` (クオーター版のパッド構成に更新済み)。回路図 (`gen_cells.py`) を変えたら作り直してください。
  - 準備: node + elkjs (`nix shell nixpkgs#nodejs`、`cd scripts/schem && npm install`、node のパスは `NODE=`)、`pip install cairosvg`。
  - 描画後のチェック (各ネットの線がつながっていること、他ネットとの接触・重なりがないこと) が問題を出したら、PNG は出力されますが内容を確認してください。
- **クオーターサイズ (slot 0p5x0p5) への再設計 (11-09、report 3.15 節)**: マクロ 1024.8 × 1535.2 µm (旧 979.4 × 3786.1、電流密度対策の前は 1024.1 幅)、配置 [452, 522.2]。チップ `RUN_2026-11-13_07-15-30` (precheck `chip/precheck_q/runs/RUN_2026-11-13_07-42-38` 合格) で LVS 一致、magic / KLayout DRC 0、アンテナ 0。旧版一式は `archive/0p5x1/`。
  - 生成スクリプトの既定は `PACK=1` (棚詰め配置、小さな論理ゲートの展開、クオーター用の最上位配置、`MACRO_X` 452)、`MIM_MERGE=1` (`lib.MERGE` の容量だけ板に統合)。`PACK=0 MIM_MERGE=0` で旧配置。
  - 最上位: `CORE_H=1585000 SIDE=7000 python3 top_build.py` → `export_macro.py` → `cd chip && make librelane` (既定スロット 0p5x0p5)。
  - 回路変更: `vga_fix` (固定利得段 3 → 2 段)、ループフィルタ 2 倍インピーダンス + Icp 100 µA、VDD デカップリングを NMOS (13 × 16 フィンガー 30/5 µm)。
  - パッドは使う信号を南側に集め、bidir 6 本 / analog 3 本 (`slot_defines.svh`)。未使用 bidir を並べると tie セルが置けず DPL-0036 で落ちます。
  - PLL 閉ループ PEX: 3 コーナーともロック、基準スプリアス TT −46.7 / SS −47.9 / FF −46.7 dBc (目標 −40)。原因だった FS ↔ NB 22 fF は `SEP` で 0.074 fF に。`tb_full` 回帰も 0p5x1 版と同じ動作 (IDD 54.2 mA)。
  - テープアウト前の確認 (11-10〜11、report 3.15 節 (7)):
    - ADC 比較器は `sa_comp` モジュールで対称配置 (オフセット約 5 mV)。
    - ミキサは対称配置で、`LO_TRIM` を `scripts/layout/lo_trim.py` で合わせ直した (I/Q 0.09 dB、−88.9°)。
    - IF 出力 ↔ ミキサ出力の結合 (最大 17.6 fF) は top の `SEP` で 0.1 fF 未満。
    - LNA / AFC DAC の PEX、IR ドロップ (`ir_drop.py`、IF チェーンで最大約 85 mV、利得差 0.15 dB 以下)、PLL の帯域カバーと引き込み (3 µs 以内) は問題なし。
    - PLL 基準スプリアス再測定 (PEX、ミキサ変更後): TT −46.8 / SS −46.6 / FF −46.8 dBc (目標 −40、変更前とほぼ同じ)。
    - `tb_full` 回帰 (ミキサ変更後、雑音入り 12 µs): VCTRL 1.4441 V (LO_TRIM 増量で +13 mV)、CLKOUT 16.368 MHz、IDD 54.31 mA で問題なし。トップ回路図とパッドフレーム図も新寸法で再生成。
    - KLayout DRC 188 件は封止リングではなく抵抗セルの RESISTOR / SAB マーカーだった。`export_macro.py` で閉じる処理を入れて 0 件。
  - テープアウト前の追加確認 (11-12、report 3.15 節 (8)):
    - **電流密度 (対策済み、11-12、コンタクト / ビアの余裕を増やした版 11-13)**: `python3 scripts/layout/em_net.py layout/em/<cell>.spec.json` (網の一覧は `em_net.py list <cell>`、対策後の結果は `layout/em/<cell>.fixed.log`)。LNA / ミキサ / VCO / VGA / 分周バッファの大電流網を太線 + ビア配列にした (`auto.py` の `NET_WIDTHS` / `NONECK` / `RES_HEAVY`、素子側の引き出しは `cells.py` / `devices.py`)。全配線が 85 °C 上限以下、全ビア (0.28 mA) と全ポリコンタクト (0.21 mA) が 110 °C 上限以下。11-13 に負荷抵抗を幅広にした (LNA R2 30u × 2.17u で 0.206 mA、ミキサ RL 4u × 5u、VGA RL 2u × 4.23u)。残り: 110 °C 上限だけを超える配線 (LNA / ミキサ / VCO の一部)。ビアの最大はミキサ IFIP の via3 0.254 mA (配線混雑で増やせない)。 それ以外の網は `python3 scripts/em_screen.py run|ana` で確認 (対策前 0.52 mA 以下)。電源メッシュは 85 °C で OK (`layout/ir_drop_em.log`)。
      - **PLL 基準スプリアス (11-13 の版のレイアウト、PEX 閉ループ)**: TT −48.0、FF −43.8、SS (B=11、6 µs) は ICP2=1 で −43.8、ICP2=0 で −48.5 dBc。3 コーナーとも −40 dBc の目標を満たす (`layout/r2_pll_spur.log` / `r2_pll_spur_ss6.log`)。SS のロック電圧は 1.431 V で、ロック点から始めても整定に約 3 µs かかるので 6 µs で実行する: `cd scripts/layout && TAGSFX=_r2 TSTOP=6e-6 python3 pex_pllmix.py ss:3:1:1.432 ss:3:0:1.432 && python3 pll_spur.py ss_b3_i1_r2 ss_b3_i0_r2` (約 14 時間)。LO ピン負荷の差は 4.8 fF、`LO_TRIM` は未調整。
      - 葉ブロックを変えたら `python3 scripts/layout/build.py if_chain` / `pll_core` を先に作り直してから `top_build.py` (既存の .mag を再利用するため)。LibreLane は `cd chip && nix-shell --run "make librelane PDK_ROOT=$HOME/pdk"`。
      - `auto.FLOOR["pll_core"]` はクランプ素子を分周バッファの隣に集める指定。外すとゲートだけの 870 µm 配線ができて KLayout アンテナ (ANT.16) が 3 件出る。`SHAPE_W` の `div48` 112000 / `pll_core` 966000 はマクロ幅をコア幅 1052 µm に収めるため。
    - RFIN 整合 (パッド + ESD 込み、`layout/rfin_match.log`): 並列 L 3.3–3.9 nH + ワイヤ 1–1.5 nH、または直列 計 6 nH + 並列 C 2.7 pF。
    - デジタル出力 → RF (`scripts/layout/dig_couple.py run|ana`): 各出力ピンに直列 100–330 Ω、負荷 5 pF 程度。基板 (p サブ) 経由の分離は未確認。
    - ミスマッチ MC (`scripts/mc_mismatch.py adc|mixer|vcomix|pll`): ADC SIGN オフセット σ 13.7 mV、ミキサ I/Q 0.03 dB / 0.13°、PLL スプリアスの変動 1 dB 未満。
    - IF 安定性 (`scripts/layout/if_stab.py --nopex`) とコーナー全体回帰 (`scripts/corner_full.py run|ana tt ss ff`、`sim/full_corner/`) の結果は report 3.15 節 (8) を参照。
    - 最終 GDS `chip/final/gds/chip_top.gds` の SHA-256: `07a533e0c20816d2a228d3ee3e90fe539a73193e2e723985a5611b7620126ded` (85399268 バイト、11-13 07:42、コンタクト / ビア増強後)。
  - チップの確認:
    - SPI: `cd chip/cocotb && nix-shell ../shell.nix --run "PDK_ROOT=$HOME/pdk PDK=gf180mcuD SLOT=0p5x0p5 [GL=1] python3 gnss_spi_tb.py"`。GL は `chip/final/pnl` を使い、RTL・GL とも PASS。
    - wafer.space precheck 合格 (`chip/precheck_q/`、`nix-shell ~/tools/gf180mcu-precheck/shell.nix` 内で `precheck.py --input ../final/gds/chip_top.gds --slot 0p5x0p5`。chip 側の nix-shell だと qrcode モジュールがなく失敗)。
    - ボンディング図: `python3 scripts/schem/bond_diagram.py` → `doc/bonding_quarter.png/.csv`。
    - PSM 1935 件 (ストラップ前の数) と max cap 18 件 (パッド端子) は無視してよい項目。
    - LibreLane は PSM の遅延エラーで exit 2 になり、`chip/final` へのコピーは行われないので、run の `final/` を手でコピーする。
    - KLayout DRC は `workers: 4` (max だとデッドロック / SIGSEGV)。途中から再実行するときは `make librelane LIBRELANE_OPTS='--pdk gf180mcuD --pdk-root $HOME/pdk --manual-pdk --scl gf180mcu_fd_sc_mcu7t5v0 --pad gf180mcu_fd_io --last-run --from KLayout.DRC'` (`LIBRELANE_OPTS` を上書きするので PDK の指定も必要)。
- **再チェックによる変更 (11-13〜14、report 3.15 節 (9))** (チップは下の SPI 読み出し追加の版で置き換え済み。アナログマクロはこの版のまま):
  - 変更 3 件: (1) VCTRL ピンは `vmon_buf` (単位利得バッファ、VDDV) + 10 kΩ 経由の出力専用モニタ。ループ節点は `vctrl` (LVS 参照では `vctrl_i`) でマクロ内部。(2) IF 帯域トリム: SPI bit 17 BWW (C2 × 0.64、遅いチップ用)、bit 18 BWN (C2 × 1.6、速いチップ用)。マクロのピンは BWK (= ~BWW、`chip_core.sv` で反転) と BWN。ctl は 19 本。(3) AFC DAC の抵抗を W 2 µm × L 20.1 / 40 µm に (20 µm や 20.2 µm にすると 127 → 128 の DNL が PEX で ∓0.76 LSB になる。`scripts/review/afc_geom.py`)。
  - マクロ 1029.8 × 1539.4 µm、DRC 0、LVS 一致。チップ `chip/librelane/runs/RUN_2026-11-13_23-44-07` (LVS 一致、magic / KLayout DRC 0、アンテナ 0、XOR 0、セットアップ / ホールド 13.81 / 0.46 ns)。precheck `chip/precheck_q/runs/RUN_2026-11-14_00-26-59` 合格。RTL / GL cocotb PASS。
  - **最終 GDS `chip/final/gds/chip_top.gds` の SHA-256: `afbc447a8c6956a5ed01ec58c14ac16d0a26ac423a0aaa15584ff3f5aede10ec` (86099462 バイト)。** 上の 11-13 07:42 のハッシュは旧版です。このハッシュも、下の読み出し追加の版で置き換えました。
- **パッドフレームの作り直し (11-15、report 3.15 節 (12)) — これが現在の最終版**: 全 56 パッドをテンプレート (slot 0p5x0p5) の固定位置に置いた (中心 56 点が一致)。未使用 29 個は NC (`asig_5p0`、`nc_PAD[28:0]`) として残す。**パッドを消したり動かしたりしないこと (ボンディング設定が固定のため)。パッドセルの種類の変更は可。** マクロは上辺ピンを作り直し (DRC 0、LVS 一致、配置 FN)。チップ `chip/librelane/runs/RUN_2026-11-15_18-44-39` (LVS 一致、DRC 0、アンテナ 0、スルー違反 0、セットアップ / ホールド +3.51 / +0.41 ns、cocotb RTL / GL PASS、precheck 合格)。`config.yaml` で遅延セル `dly*` をバッファから除外 (これがないと ss でスルー違反)。**最終 GDS の SHA-256: `5dc43f34bc8e9d5964c2a791bb2c6bd7913a1ccf1866c3bbc3ef57630751c1c1` (86597382 バイト)。** 旧版は `archive/padframe_v1/`。新マクロでの PEX 確認 (11-15、ログ `layout/review/padframe/`): ブロックセルは XOR 0 でブロック PEX は有効、トップ配線は RFIN (23.9 fF、1.2 Ω) / REFIN / VCTRL モニタの 3 ネットだけ変化、IR ドロップは同じ、RFIN 整合は基板の値そのまま (NF +0.07–0.16 dB)、受信系全体 `rx_pex.py` は 3 コーナーとも利得 −0.1 dB だけの差 (TT 24.1 / 24.0 dB、SS 20.0 / 19.9 dB、FF 25.3 / 25.1 dB、I/Q と PLL は同じ、`layout/review/padframe/rx_pex.log`)。
  - run-2 COB 基板 (wafer-space/chip-on-board-wire-bonded-pcbs の `run-2/0p5x0p5-cob`) と照合済み (11-15): 固定の GND / VDD 8 本は `dvss` / `dvdd` セルと一致 (`scripts/schem/bond_diagram.py` が assert)。`doc/bonding_quarter.csv` に基板ネット名とコネクタのピン番号あり (RFIN = bidir_23 / 49 番、VDDA = bidir_25 / 47、VDDV = an_0 / 42)。VDD 4 本は同じ 3.3 V、VDDA / VDDV のデカップリングと RFIN 整合はマザーボード側、NC は開放。
  - COB 基板の経路込みの RFIN 整合 (11-16、`scripts/layout/rfin_cob.py`、`layout/review/padframe/rfin_cob.log`): 配線 94 Ω・5.0 nH / 0.57 pF (KiCad から)、ワイヤ 3.0 nH・コネクタ 0.6 nH / 0.15 pF・GND 0.5 nH は仮定。整合なしは S11 −3.6 dB。推奨は結合コンデンサを 1.8 pF にして信号源側に並列 1.0 pF (S11 −19.2 dB、利得 13.37 dB、NF 2.46 dB)。仮定を振ると S11 −10〜−22 dB なので、マザーボードに並列 – 直列 – 並列の部品位置を用意して実測で合わせる。
  - 同 SS / FF とワイヤ長 (11-16、report 3.16 節 (11)、`rfin_cob.py corners|search`、`layout/review/final/rfin_corners.log`、`rfin_search.log`): 推奨部品のままワイヤ 2.5–3.5 nH で S11 −12 dB 以下 (3 コーナー)、4.0 nH は −9.2…−9.9 dB (直列 1.0 pF だけに替えると戻る)。仮定 100 通りで −10 dB 超えは 2 / 2 / 7。NF は TT 2.4–2.9、SS 3.0–3.7、FF 2.1–2.4 dB。スクリプトの誤り 2 つを修正 (1 H の代用コイルが入力バイアスを短絡、動作点が過渡解析の途中の値 → `opset()` の `.nodeset`)。`rfin_cob.py` の各デッキは先頭の op だけ transient op になるのが正常。
- **最終チェック (11-16、report 3.16 節、`scripts/review/final_*.py`、`layout/review/final/`)**: GDS は変更なし。全素子の静的ルール違反 0、動作点 3 コーナー OK、GDS 内のマクロは単体マクロと XOR 0、GDS から抽出した LVS 一致、PEX ネットリストは最終レイアウトと同一形状。注意 2 点: (1) チップにパワーオンリセットはなく、RST_N (プルなし) を基板で駆動する。RST_N / SCLK / SDI は浮かせない。(2) 分周器と比較器の内部ノードが VDD を 0.3–0.4 V 超える (3.3 V で最大 3.68 V) ので、VDD / VDDV は 3.3 V 以下で使う。
- **ミスマッチ MC のやり直し (11-16、report 3.16 節 (10)、`scripts/review/final_mc.py adc|mixer|cpdc|pll`、`final_mc_stat.py`、`sim/mc/final_*.txt`、`layout/review/final/mc_*.log`)**: ADC 200 回 SIGN σ 15.1 mV (最大 43 mV)、MAG の幅 317.5 ± 24.4 mV。ミキサ 100 回 I/Q 0.031 dB / 89.34 ± 0.13°、オフセット σ 1.3 mV。チャージポンプ 300 回 × 3 コーナー: 吐き出しと吸い込みの差 σ 1.0–1.4 µA (電流 101–111 µA の 0.9–1.4 %、最悪 3.7 %)。PLL 閉ループ MC (`pll`、TT 8 / SS 5 / FF 5 回、`mc_pll.log`): 全 18 回ロック、静的位相誤差 TT −13…+28 / SS 50–75 / FF 25–45 ps、基準スプリアスの動きは 0.7 dB 以下 (回路図レベルで TT −60.4…−61.0 dBc)。
- **チップ全体 (アナログ + デジタル) のトランジスタレベル・シミュレーション (11-16、report 3.15 節 (13)、旧パッドフレーム、`scripts/layout/chip_spice.py`、`sim/chip/`、`layout/review/r4_chip_spice*.log`)**: 6 通りとも SPI の読み出し・制御出力・PLL ロックは期待どおり (PEX は 1 本約 27 時間)。**重要: I/Q と CLKOUT のパッドの切り替えが共有 VSS 経由で IF に回り込み、直列抵抗なしでは IF 出力に 170–385 mV rms (信号は約 55 mV)。** VSS 分離で 21–24 mV rms、基板の直列 330 Ω で 37–51 mV rms。→ マザーボードの I/Q・CLKOUT の直列抵抗 (330 Ω 以上) は必須。330 Ω での残りが熱雑音より小さいかは未確定 (評価区間 1 µs)。チップ側の対策 (VSS 分離) は GDS に入れていない。**長い実行 (10 µs、11-17 完了、`chip_long.py`、`r4_chip_spice_long.log`)**: IF の残り (5.2 µs 以降、I / Q) は 330 Ω 30.2 / 16.1、1 kΩ 26.4 / 14.9、VSS 分離 13.2 / 15.9 mV rms で定常 (起動の過渡ではない)。差は I 側の 8.18 MHz (MAG の切り替え)。信号の振幅も I / Q 44 / 68 (分離) → 78 / 51 mV (330 Ω) と変わる = 自分の ADC 出力が信号の数割の大きさで IF に戻る。1 kΩ にしても変わらない → **直列抵抗は 330 Ω で確定**。回り込みは残る (消せるのはチップ側の VSS 分離だけ) が、下の雑音入りの実行で感度の劣化は約 0.5 dB 以下と確認済み。**雑音入りの全体実行 6 本を 11-17 15:26 に開始** (`chip_spice.py run nz_ser ns_ser nz_iso ns_iso nz_ref ns_ref`、11 µs、1–3 日かかる見込み、進み具合は `sim/chip/noise_progress.txt`。`ns_ref` は 1.178 µs で「Timestep too small」で停止したので、最大ステップを 9.7 ps にして 11-18 01:45 に再実行 → 0.694 µs でまた停止。3 回目は全ノードに 10 aF (`cshunt`)、9.85 ps で 11-18 09:50 に開始。保険として雑音なしの `cw_ref` も同時に開始 (基準条件は回り込みがなく IF が線形なので、信号の応答は雑音なしでも同じ)。3 回目も 11-19 01:18 に 3.245 µs で停止 → `ns_ref` は諦め、基準の信号応答は `cw_ref` を使う。`ns_ser` も 11-19 08:11 に 9.412 µs で停止したが、評価区間 (4.5 µs 以降) は 4.9 µs あるのでそのまま使う): tb_full と同じ RF 雑音 (前段 LNA 込み、IF 出力で σ ≈ 152 mV)、nz = 雑音だけ、ns = 同じ雑音 + CW (差 ns − nz が信号の応答)、_ser = 直列 330 Ω、_iso = VSS 分離、_ref = VSS 分離 + アナログ電源のワイヤなし (基準)。**11-19 15:54 に全実行が終了、解析済み** (`scripts/layout/chip_noise.py` → `layout/review/r4_chip_spice_noise.log`、report 3.15 (13) の 11-19 の追記): 基準の C/N0 は 58.9 dB-Hz で信号源と同じ。雑音だけの実行を基準と比べると、新しい雑音は iso −20.4 dB / ser −9.7 dB → **C/N0 の劣化は VSS 分離 0.06 dB、今のチップ (直列 330 Ω) 0.47 dB (高めの見積もり)**。信号と帯域雑音から直接求めた差は iso −0.4 / ser +1.6 dB (不確かさ約 1 dB) で劣化は見えない。GDS の変更は不要。`nz_ser_out` は 5.93 µs 付近の 53 行が壊れていたので `load` が前後を除いて読む。なお report (13) (b) の「熱雑音 10–15 mV」はチップ単体の値で比較相手として誤り (訂正済み)。
- **SPI の読み出し (SDO) の追加 (11-14、report 3.15 節 (10)) — パッド配置と GDS は上の (12) で更新**:
  - パッド `bidir[5]` = SDO (下辺の右端。`inputs[3]` は右辺へ移動)。CS_N = Low の間、`{ID 10101, 制御ワード bit 18…0}` を MSB first で出す。値はいま有効な制御ワード (前回のフレームで書いた値)。SCLK の立ち下がりで変化、CS_N = High でハイインピーダンス (パッドのプルダウン)。読み出しは SCLK 5 MHz 以下 (SCLK 立ち下がり → SDO の遅延は 3.3 V 系の最悪で 24.1 ns = SS / 125 °C / 3.0 V / 30 pF、`scripts/layout/sdo_delay.py`、`sim/sdo/`。4.5 V SS のタイミング解析では 14.9 ns)。
  - 変更は `chip/src/chip_core.sv`、`chip/librelane/slots/slot_0p5x0p5.yaml`、`chip/librelane/chip_top.sdc` (SDO へのマルチサイクル)、`chip/cocotb/gnss_spi_tb.py`、`scripts/schem/bond_diagram.py`。アナログマクロは変更なし。未使用入力 `inputs[2]` / `inputs[3]` にプルダウンを追加。
  - チップ `chip/librelane/runs/RUN_2026-11-14_16-56-53` (LVS 一致、magic / KLayout DRC 0、アンテナ 0、XOR 0、スルー違反 0、セットアップ / ホールド 0.73 / 0.46 ns)。RTL / GL cocotb PASS。precheck 合格 (`chip/precheck_q/runs/RUN_2026-11-14_17-09-52`、`layout/review/precheck_r4.log`)。
  - **最終 GDS `chip/final/gds/chip_top.gds` の SHA-256: `1da43f4ea471dff0eb9df7805c477003da8d6b22f742445fa11dc426a16d7a8b` (86227586 バイト)。**
  - precheck は `cd chip/precheck_q && nix-shell ~/tools/gf180mcu-precheck/shell.nix --run "PDK_ROOT=$HOME/pdk PDK=gf180mcuD python3 ~/tools/gf180mcu-precheck/precheck.py --input ../final/gds/chip_top.gds --slot 0p5x0p5"` (PDK_ROOT / PDK を渡さないと「PDK が見つからない」で失敗。約 67 分)。
  - 追加シミュレーションは `scripts/review/*.py`、ログは `layout/review/*.log`。`gen_cells.py` を変えたら `run.netlist('tb_full')` を実行してからレイアウトを作り直す。リーフを変えたら `build.py` で `if_chain` / `pll_core` を作り直してから `top_build.py`。
  - ファームウェア: B=11 が必要なチップは BWW=1、ロック VCTRL が低い B=00 のチップは BWN=1、それ以外は両方 0。
  - **残っていた確認項目の実行 (11-14、report 3.15 節 (11)、GDS は変更なし)**: (a) デジタルコア全体のトランジスタレベル・シミュレーション (`scripts/layout/core_spice.py`、`sim/core/`、3 条件で書き込み・読み出しとも合格、SS 125 °C 3.0 V で SCLK 立下り → SDO 確定 23.2 ns)。(b) SDO → RF の結合 (`dig_couple.py` の `sdo*` ケース、データパッド 1 本の 0.6–0.7 倍、読み出し中だけ)。(c) IF 単体 PEX (`pex_blocks.py if`、利得 −0.6 dB、帯域 0.64–7.0 MHz、スレッドの競合を修正)。(d) EM 再計算 (`layout/review/em_r4/`、ブロック内は同じ、メッシュは VSS M4 1.770 mA/µm = 85 °C 上限の 85 %、接合温度の目安は約 90 °C)。残り: アナログ + デジタル一体のトランジスタレベル、SDO → IF の直接結合、実測。
  - **図の再生成 (11-15、report 3.14 節)**: `doc/sch_wired/` 42 枚 (`chip_top` / `padframe` に SDO を反映、`python3 scripts/schem/wired.py` と `chip_top.py`)、`doc/sch/` 56 枚 (`sh scripts/export_svg.sh`)、`doc/chip_quarter.png` / `doc/macro_quarter.png` (`python3 scripts/layout/render_png.py`)。`lo_comb`、`vco_cell`、`vco_cellk`、`inv_lod`、`aoi22` は使っていない旧セルで、`layout/mag_vco/` と一緒に `archive/legacy_cells/` へ移しました。
- 注意:
  - スレッド内で `pexsim.swap` をモンキーパッチすると、並列の sch / PEX 実行が混ざります (逐次で実行してください)。
  - VCO + ミキサの開ループ計算では fLO が数 µs かけてドリフトするので (60 ns と 0.4–1 µs で 17 MHz の差)、後半の窓で評価してください。

## 3. 未完了: チップ全体の過渡シミュレーション (`tb_full`)
内容: PLL ロック、SPI 書き込み、RF (雑音 + −95 dBm トーン) から 2 bit I/Q 出力まで、12 µs。

経緯と既知の問題:
- LNA なしの rev.2 では、Xyce で 12 µs 完走しました (17 時間)。PLL ロック、CLKOUT 16.368 MHz、SPI は正常でした。
  ただし、テストベンチで RF 入力に AC 結合を入れ忘れていたため、RF 経路は確認できていません (修正済み)。
- rev.3 (LNA 入り) の ngspice は、電源を 0 V からランプさせると 1.76 ns / 13.6 ns で
  "Timestep too small" になりました。
  そこで現在は VDD = 3.3 V 固定 + `uic` (全ノード 0 V から開始。POR は RC 充電で動作) にしています。
- その設定の ngspice は 40 ns 分でも 30 分以上かかり、非常に遅かったです (理由は未調査)。
  起動直後の LNA 周辺の時定数 (4 pF の結合容量など) で時間刻みが細かくなっている可能性があります。
- Xyce 版 (`scripts/to_xyce.py` で変換) は rev.3 で 1 ns の構文・実行確認まで済んでいます。
  Xyce は trnoise に非対応なので、RF 雑音は除いて CW トーンのみになります。
- ngspice-47 では大規模な過渡解析で `.option klu` を使わないでください (上記参照)。
- ngspice で trnoise を使う場合、雑音のサンプル点が PWL の角と数 fs 差で重なると止まります。
  対策として、サンプル間隔を割り切れない値 (49.7 ps) にし、`.option minbreak=1e-12` を入れています。

### 2026-11-01 の作業 (新 PC: ngspice-47 / Xyce 7.9 / open_pdks 792ef67)
- **ngspice の "Timestep too small" の原因は KLU ソルバでした。**
  `.option klu` のときだけ、数 ns で時間刻みが 6e-24 まで落ちて止まります (雑音あり 8.58 ns、なし 0.34 ns)。
  一方、SPARSE 1.3 (klu を指定しない) は 40 ns を問題なく完走し、同じ時刻でも刻みは 5 ps のままでした。
  - 失敗するノード名 (vcsn#branch) は、直列抵抗を入れると vsclk / vref に移るので、回路側の原因ではありません。
  - rshunt / gmin / trap / 雑音の有無では直りませんでした。`pivrel=0.1` では 15 ns を通過しても 25 ns で破綻し、
    `pivrel=1` では 40 ns を完走しました (86 s)。KLU が refactor で古いピボット順を使い回し、極小ピボットを掴むのが原因です。
  - 対策: `tb_full` から `klu` を削除しました (`gen_tb.py`)。40 ns の所要時間は ngspice SPARSE 105 s、Xyce 103 s です。
  - rev.3 で以前出ていた電源ランプ時の失敗 (1.76 / 13.6 ns) も、同じ原因の可能性が高いです (未確認)。
- 新しい PDK では MOS シンボルが `par=@m` を出力し、Xyce の M 素子では通りません → `to_xyce.py` で除去するようにしました。
- Xyce 用の RF 雑音: `to_xyce.py` が trnoise を、同じ rms・49.7 ps 間隔のガウス乱数 PWL ファイル
  (`sim/xyce/tb_full_vrnp_noise.csv`、seed=1) に置き換えるようにしました。これで Xyce でも雑音入りで回せます。
- Xyce の MPI 並列は効果なし (40 ns: 逐次 103 s、4 並列 120 s、8 並列 103 s)。逐次で回しています。
- **Xyce 12 µs 雑音入り 完走** (8 時間 24 分)。結果は ngspice と整合します (VCTRL 2.003 V、CLKOUT 16.368 MHz、59.5 mA)。
  詳細は `doc/report.md` 3.9 節と `scripts/full_detail.py`。
- 雑音なし 5 µs の検証 (両ツール): LO の Q−I は −90〜−91°、ミキサの Q−I は 87〜90° (Q/I +0.5 dB) で正常。
  IF の Q−I は 82〜86° で、SPI 書き込み後約 0.5 µs で整定します。
  - 手順: `sim/netlist/tb_full.spice` / `sim/xyce/tb_full.cir` から雑音源を `dc 0` にし、5 µs に短縮、LO ノードを出力に追加
- 新たに見つかった事項 (未対応):
  1. ミキサの変換利得が単体より 2–3 dB 低い → **原因特定済み** (report 3.9 節の表)。
     - 実 VCO の LO 波形 (基本波 2.27 V、理想矩形は 2.53 V) で −2.1 dB
     - `divbuf` が LOIP だけを負荷していて、I 側がさらに −0.35 dB (I/Q 差 +0.4 dB、直交誤差 2–3°)
     - IF 負荷とバイアス共有は無関係。切り分け用ネットリストは report の表どおり (作業用で、リポジトリ外)
     - **2026-11-02 対策済み**: `gen_cells.py` の `top()` で、LOIN / LOQP / LOQN にダミー `divbuf` (XDBD_*) を追加しました。
       `tb_full` 雑音なし 5 µs (ngspice) での結果は次のとおりです。
       - LO I/Q は 1.971 / 1.976 V、−90.2°
       - ミキサの Q/I は +0.12 dB、Q−I 89.5° (修正前 +1.42 dB、86.3°)
       - IF の Q/I は +0.06 dB、91.5°
       - VCTRL 1.998 V でロック、IDD 60.7 mA (+1.35 mA)
       代償として変換利得が 0.4–1 dB 下がり、チップで 25.4 dB → `gnss_sysim.py` の `G_RX_DB` を 25.4 に更新し、report 3.3 節の σ と AGC 余裕を更新しました。
       VCO のロック点は TT 約 2.0 V、SS 85 °C (B=11) 約 2.25 V で、範囲内です (report 3.5 節)。
       ダミーを付けた後の 12 µs 雑音入りは再計算していません (5 µs 雑音なしで確認済み)。
  2. SPI クロック送出中に IF へ同相で 70–175 mV の過渡が出る
  3. **2026-11-02 コーナー検証 (report 3.10 節) で見つかった問題 → 2026-11-03 に両方とも対策済み。**
     - **LO の AC 結合**: `mixer_iq` に CAC* 2 pF + RAC* 20 kΩ、バイアス 1.60 V (RLA/RLB 分圧 + CLOB 50 pF) を追加しました。
       実 VCO でのブロック計算の変換利得は TT 28.7、SS 25.3、FF 29.4 dB です。
       `tb_full` 雑音なし 5 µs (ngspice) でのチップの変換利得は 28.5 dB です。ほかに、VCTRL 2.176 V、LO −90.2°、IF Q/I +0.14 dB / 88.0°、IDD 61.2 mA。
       → `G_RX_DB` = 28.5。また `tb_lna` を再計算した値 (NF 1.46 dB、利得 14.4 dB) を `gnss_sysim.py` に入れました。
       `tb_lna` は静的 LO なので、AC 結合後は I/Q のスイッチがすべて 1.6 V で半分オンの状態になります。
     - **VCO の起動回路**: `vco_ring4` で、段 2 のダミーバッファから p2 = n2 を検出し (RC 約 5 ns)、張り付いたノードを NMOS 8u で 1 本引き下げます。
       キック付きセル `vco_cellk` (OP 側に同寸ダミー) は段 1・2 だけに使い、d2 + d3 = d1 + d4 で直交を保ちます。
       B1 の電流枝は m = 4 → 8 にしました。全コーナー・hi/lo の全点でラッチから脱出します。
       1571 MHz の VCTRL は TT 2.18 / SS 2.40 / FF 1.39 V、SS の最高周波数は 1610 MHz、I/Q は 0.3–0.55° です。
       不採用案 (フッタ方式、全段キック、4u キック) は report 3.10 節の表にあります。
     - PLL 閉ループ (起動回路追加後、VCTRL 0 V から) は、TT 2.179 V (3 µs)、FF 1.327 V (1.5 µs) です。
       SS は 2.85 V まで行き過ぎ、2.32 V まで振れ戻ってから約 10 µs で 2.427 V にロックしました (VCO 感度が約 120 MHz/V に下がるため)。
     - **B=11 で Icp を 2 倍 (2026-11-03 実装)**: `cp` に 2 組目の電流源 (MPE2/MNE2 で切り替え)、当初は `pll_core` で HI = B0·B1 (B=11 連動)。**11-04 に SPI bit 16 (ICP2) で独立制御に変更** (フレームは 24 bit、bit 23–17 予約)。閉ループで SS (ICP2=1) 2.4170 V、TT (ICP2=0) 2.1795 V と連動版に一致、TT で ICP2=1 でも 2.3 µs でロック。
       実効 Icp は SS 233 → 479 µA。SS の位相余裕 44° → 55° (R・C ばらつきで 49–58°)、fc 0.51 MHz、ロック 約 7 µs (2.417 V)。TT/FF (B=00) は変化なし (report 3.6 節)。
     - ループ特性 (2026-11-03): fc / 位相余裕は TT 0.95 MHz / 59°、FF 1.57 MHz / 56°、SS 0.31 MHz / 45° (R・C ばらつきで 38–51°)。積分位相雑音は 1.1–1.7° rms で問題なし (Icp 2 倍の前の値)。
     - 位相雑音 (起動回路込み、ノード雑音電流注入による過渡ジッタ): TT −108.1、SS −109.7 dBc/Hz @ 1 MHz (rev.1 −108.0 から変化なし)。
     - **追加検証 (2026-11-03〜04、report 3.11 節)**:
       - 電源立ち上げ 1 / 10 µs: TT・SS とも自動でロック (VDD 90 % から 2.1–2.6 / 5.9–6.1 µs)
       - バンド網羅: TT/FF は B=00 で全 PVT OK。SS は B=10 (低温) / B=11 (85 °C 3.135 V のみ必須)。低温 SS で B=11 + Icp 2 倍だと fc 2 MHz、PM 45–55° → バンド規則「VCTRL ≤ 2.5 V の最低バンド」と温度変化時の再選択が必要。→ 11-04 に ICP2 bit へ分離済み
       - ミスマッチ MC: IF オフセット σ 9 mV、ADC SIGN σ 13 mV、MAG 閾値 σ 16–17 mV、VCO は 120/120 起動、I/Q σ 0.5–0.7° (最大 1.8°)
       - **VCO の電源感度 TT 157 / SS 395 MHz/V。閉ループで 20 mVp @ 1 MHz → LO 位相 3 rad。−40 dBc には 0.13 mVp → VCO 電源の LDO が次の設計項目**
       - SS `tb_full` 雑音なし 14 µs (11-04 完了): PLL 2.4445 V ロック、CLKOUT 16.368 MHz、IDD 64.0 mA、LO −90.1°、ミキサ 25 dB・90.2° は OK。IF 利得が約 19 dB しかなかった (下記で対策済み)
       - **対策済み (11-04)**: IF のテール電流・SK フォロワ電流を比例バイアス `bias_if` (I = 0.288 VDD / 9 RL 単位) から供給し、VGA 出力の動作点を 0.363 VDD に固定。ADC ラダー中心も 0.363 VDD に変更し、`tb_ifadc` の入力レベルを rev.3 に合わせて 3.29 倍にした
         - `tb_if` PVT 18 点でコード 01 の利得は 47.7–54.3 dB、雑音は変更前と同じ
         - 変更後 `tb_full` 雑音なし: SS (12 µs) IF 利得 50.2 dB・Q/I −0.07 dB・90.2°、IDD 55.7 mA、VCTRL 2.4443 V / TT (8 µs) IF 利得 51.9 dB、IDD 59.6 mA、VCTRL 2.1761 V
         - SS のミキサ出力が変更前より 1.7 dB 小さい (VGA1 のミラー容量と推定、未切り分け)
     - 残り: SS の周波数余裕 +2.5 %。Icp 切り替え後の `tb_full` は未実行 (TT は B=00 で切り替え脚が OFF のため、結果は変わらない見込み)
     - 雑音入り 12 µs `tb_full` は 2026-11-03 に ngspice (7 h 15 min) / Xyce (10 h 18 min) とも完走: VCTRL 2.175 / 2.217 V、CLKOUT 16.368 MHz、61.2 / 61.4 mA、IF rms 165・144 / 167・163 mV (予測 152 mV)、MAG=1 比率 0.30・0.17 / 0.32・0.29 (report 3.9 節)
     - 以下は 11-02 時点の記述です。
     - FF (−20 °C 3.465 V) でミキサ利得が 12.5–13.7 dB に低下します (TT 25.6 dB)。
       LO の DC 結合で、VR (FF で 1.6 V) が低いと Gm 段が線形領域に入るためです。
       対策案は LO の AC 結合 (2 pF) + 20 kΩ で 1.6 V バイアスで、FF / TT / SS = 28.4 / 28.4 / 25.5 dB になります。
     - VCO の同相ラッチ: SS (VCTRL 全範囲) と TT (VCTRL ≥ 2.7 V) で、発振しない安定状態があります。
       ラッチ × 2 で解消しますが、SS の最高周波数が 1425 MHz に落ちるので、VCO の再調整が必要です。
     - PLL は SS 2.39 V、FF 1.217 V でロックします (閉ループ 4 µs)。
     - 作業用ネットリストはリポジトリ外です。コーナーの作り方: `.lib` を ss/ff、res_ss/res_ff、mimcap_ss/mimcap_ff に替え、`.temp` と VDD を替え、B0/B1 で帯域を選ぶ
     - 注意: 待機に `pgrep -f "ngspice -b X"` を使うと、自分自身のコマンド行に一致して終わりません (`pgrep -f "^ngspice"` を使う)
→ **3 章の `tb_full` は完了です。** 下の「次の手順 (案)」は 2026-10-30 時点のもので、項目 1〜4 は消化済みです。
- **ngspice SPARSE 12 µs 完走** (2026-11-01 23:55 → 11-02 05:08、5 時間 12 分、`doc/full_ngspice_summary.json`):
  - PLL: VCTRL 2.03 V (1 µs) → 1.948 V (3 µs) でロック。CLKOUT 16.368 MHz。IDD 59.4 mA (ブロック合算 58 mA)
  - トーン (4–12 µs、相関): mixI 0.125 mV (期待 0.14)、ifI 53 mV (期待 ≈ 50 mV、利得コード 01)。
    ただし帯域 125 kHz の雑音床が IF で約 20 mV もあり、I/Q の振幅比・位相は −95 dBm では判定できません (Q 側 29.5 mV、Q−I 128°)
  - ADC (130 サンプル): MAG=1 の比率は I 0.146 / Q 0.262 (IF rms 126 / 146 mV からのガウス期待値 0.21 / 0.28)。
    SIGN 平均 −0.015 / −0.046 → rev.2 で起きた「SIGN が 0 に固定」は雑音入りでは起きていません
  - IF 出力の 16.368 MHz 高調波は各 0.3–2.1 mV (I/Q 同値で、クロック結合とみられる)。MAG 閾値 157 mV に対して約 1 % で影響は小
  - I/Q 位相を確かめるには、雑音なし、または −75 dBm 程度の強いトーンでの再実行が必要です

### 次の手順 (案)
1. まず短時間で、速度と収束を確認します: `scripts/run_full.sh ngspice 40n` と `scripts/run_full.sh xyce 40n`。
   どちらが速いかを見て、本番は速い方で 12 µs を回します。
2. 遅すぎる場合の選択肢:
   - (a) 時間長を短くする (PLL ロック約 3 µs + IF 整定 → 8 µs 程度)
   - (b) LNA を等価な理想モデルにした版で全体を回す (LNA 自体は `tb_lna` / `tb_rx` で検証済み)
   - (c) Xyce の並列版 (MPI) を使う
3. 完了後は `python3 scripts/full_analyze.py ngspice|xyce` を実行します (`run_full.sh` が自動で実行します)。
   見る項目: VCTRL の推移、CLKOUT、各段のトーン振幅 / I/Q 位相、ADC 出力統計 (MAG=1 の比率)、消費電流。
4. rev.2 の Xyce 完走で観測した事項も確認します: IF 出力に 16.368 MHz の高調波 (150–250 MHz、3–5 mV) が乗り、
   RF なしで SIGN が 0 に固定されていました (ADC キックバック、またはデジタル部から共通バイアス線への結合が疑われます)。
   雑音入りの全体シミュレーションで、2 bit 統計への影響を評価してください。

## 4. 環境構築
```sh
# 必要: GF180MCU PDK, xschem >= 3.4, ngspice >= 41, python3 (numpy scipy matplotlib), 任意で Xyce 7.9
export PDK_ROOT=~/pdk PDK=gf180mcuD
python3 scripts/gen_cells.py && python3 scripts/gen_tb.py   # 回路図を再生成
python3 scripts/run.py tb_lna                                 # 例: ブロック単体のシミュレーション
scripts/run_full.sh both 12u                                  # チップ全体 (nohup で切り離して実行)
```
- ngspice は `set num_threads=1` を各テストベンチに入れています (OpenMP を有効にすると逆に遅くなるため)。
- Xyce のビルドには `~/src/xyce/build_xyce.sh` (このリポジトリ外) を使いました。
  依存パッケージ: `sudo apt install -y cmake gfortran libblas-dev liblapack-dev libsuitesparse-dev`
- `sim/` は再生成できるので持ち出していません。ネットリストには PDK の絶対パスが入るので、移行先で必ず再生成してください。

## 5. ツール使用上の注意 (今回ハマった点)
- PDK シンボル既定の MIM モデル名 `cap_mim_2f0fF` は存在しません。`cap_mim_2f0_m4m5_noshield` を使います (`xsch.py` で対応済み)。
- xschem のプロパティ値に `{...}` を書くとパースが壊れます。
- TSPC 分周器はクロックのエッジが鈍いと誤動作します (/3 段は軽負荷のノードで駆動しています)。
- ngspice の 1 つの電源に `trnoise(...)` と `sin(...)` を並べて書くと、sin しか効きません。直列の別電源にします。
- Xyce: MOS は M 素子にし、パラメータ式は数値に展開し、階層ノードの区切りは `:` にします (`to_xyce.py` で対応済み)。
