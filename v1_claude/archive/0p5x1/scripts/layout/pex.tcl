# RC parasitic extraction (env CELL, DIR) -> <cell>.pex.spice
set cell $env(CELL)
cd $env(DIR)
load ${cell}_flat
select top cell
extract do capacitance
extract do coupling
extract halo 2um
extract do resistance
extract all
ext2sim labels on
ext2sim
extresist tolerance 10
extresist ignore VDD
extresist ignore VSS
extresist all
ext2spice lvs
ext2spice format ngspice
ext2spice cthresh 0.01
ext2spice rthresh 0.01
ext2spice extresist on
ext2spice subcircuit top on
ext2spice hierarchy off
ext2spice -o $cell.pex.spice
puts "PEXRTHRESH [ext2spice rthresh]"
quit -noprompt
