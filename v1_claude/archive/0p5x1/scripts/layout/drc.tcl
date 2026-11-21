# usage: magic -dnull -noconsole drc.tcl  (env CELL, DIR)
set cell $env(CELL)
cd $env(DIR)
load $cell
select top cell
drc style drc(full)
drc check
drc catchup
set why [drc listall why]
set n 0
foreach {msg boxes} $why {
  incr n [llength $boxes]
  puts "DRCERR [llength $boxes] :: $msg :: [lindex $boxes 0]"
}
puts "DRCCOUNT $cell $n"
quit -noprompt
