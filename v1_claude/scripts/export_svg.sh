#!/bin/sh
# Export every schematic in xschem/ to doc/sch/<name>.svg (headless)
export PDK_ROOT="${PDK_ROOT:-$HOME/pdk}" PDK="${PDK:-gf180mcuD}"
cd "$(dirname "$0")/../xschem"
mkdir -p ../doc/sch
for f in *.sch; do
  n=${f%.sch}
  timeout 60 xschem -q -x --rcfile xschemrc \
    --command "xschem zoom_full; xschem print svg [file normalize ../doc/sch/$n.svg]; xschem exit closewindow" "$f" >/dev/null 2>&1
done
ls ../doc/sch | wc -l
