#!/bin/bash
# Full-chip transient (tb_full) with ngspice and/or Xyce, detached with nohup.
#   scripts/run_full.sh [ngspice|xyce|both] [stop_time]      e.g.  scripts/run_full.sh both 12u
#   scripts/run_full.sh ngspice 40n                           (short sanity run)
# Results: sim/tb_full_out (ngspice), sim/xyce/tb_full.cir.csv (Xyce); summaries in doc/full_<tool>_summary.json
set -e
TOOL=${1:-both}
STOP=${2:-12u}
ROOT=$(cd "$(dirname "$0")/.." && pwd)
: "${PDK_ROOT:?set PDK_ROOT}" "${PDK:=gf180mcuD}"
export PDK
cd "$ROOT"
python3 scripts/gen_cells.py >/dev/null
python3 scripts/gen_tb.py >/dev/null
python3 -c "import sys; sys.path.insert(0,'scripts'); import run; run.netlist('tb_full')"
sed -i "s/tran 5p 12u 0 5p uic/tran 5p $STOP 0 5p uic/" sim/netlist/tb_full.spice
mkdir -p sim/xyce
if [ "$TOOL" = ngspice ] || [ "$TOOL" = both ]; then
  rm -f sim/tb_full.end sim/tb_full_out
  (cd sim && nohup sh -c "date > tb_full.start; ngspice -b netlist/tb_full.spice > tb_full_run.log 2>&1; date > tb_full.end; cd .. && python3 scripts/full_analyze.py ngspice > sim/tb_full_analysis.txt 2>&1" > /dev/null 2>&1 &)
  echo "ngspice started: sim/tb_full_run.log (progress: tr '\\r' '\\n' < sim/tb_full_run.log | grep Reference | tail -1)"
fi
if [ "$TOOL" = xyce ] || [ "$TOOL" = both ]; then
  python3 scripts/to_xyce.py tb_full >/dev/null
  sed -i "s/^\.tran 5p 12u 0 5p uic/.tran 5p $STOP 0 5p uic/" sim/xyce/tb_full.cir
  rm -f sim/xyce/tb_full.xend sim/xyce/tb_full.cir.csv
  (cd sim/xyce && nohup sh -c "date > tb_full.xstart; Xyce tb_full.cir > tb_full.xlog 2>&1; date > tb_full.xend; cd ../.. && python3 scripts/full_analyze.py xyce > sim/xyce/tb_full_analysis.txt 2>&1" > /dev/null 2>&1 &)
  echo "Xyce started: sim/xyce/tb_full.xlog (progress: grep 'Percent complete' sim/xyce/tb_full.xlog | tail -1)"
fi
