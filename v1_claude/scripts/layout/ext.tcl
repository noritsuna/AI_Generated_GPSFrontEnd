# extract a cell to SPICE for LVS (env CELL, DIR)
set cell $env(CELL)
cd $env(DIR)
load $cell
select top cell
extract no all
extract do local
extract all
ext2spice lvs
ext2spice -o $cell.lvs.spice
quit -noprompt
