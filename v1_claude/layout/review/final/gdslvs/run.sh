#!/bin/bash
# GDS-based LVS of the analog macro cut out of the final chip GDS (see scripts/review/final_gds.py)
cd /home/noritsuna/GPS/layout/review/final/gdslvs
export PDK_ROOT=$HOME/pdk PDK=gf180mcuD
date
$HOME/opt/magic/bin/magic -dnull -noconsole > magic.log 2>&1 <<'T'
gds read macro_from_chip.gds
load gnss_afe_analog
select top cell
extract no all
extract do local
extract all
ext2spice lvs
ext2spice -o gds.lvs.spice
quit -noprompt
T
date
cd /home/noritsuna/GPS/scripts/layout && python3 - <<'P'
import lvs, re
d = "/home/noritsuna/GPS/layout/review/final/gdslvs"
ref = lvs.ref_netlist("gnss_afe_analog", d + "/ref.spice")
print(open(ref).read().count("\n"), "reference lines")
P
cd /home/noritsuna/GPS/layout/review/final/gdslvs
netgen -batch lvs "gds.lvs.spice gnss_afe_analog" "ref.spice gnss_afe_analog" $PDK_ROOT/$PDK/libs.tech/netgen/gf180mcuD_setup.tcl lvs.rpt > netgen.log 2>&1
date
grep -n "Final result\|Property errors\|match uniquely\|Number of devices\|Number of nets" lvs.rpt | tail -8
