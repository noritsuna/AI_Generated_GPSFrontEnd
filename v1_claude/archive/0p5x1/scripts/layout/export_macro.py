"""Export the analog hard macro for the wafer.space chip: GDS (cell names prefixed),
LEF abstract and SPICE.  The VDD port is renamed VDDA (see chip/src/gnss_afe_analog.v)."""
import os, sys, re, subprocess
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import lvs
TOP = "gnss_afe_analog"
MAG = os.path.join(lvs.PROJ, "layout", "mag")
OUT = os.path.join(lvs.PROJ, "layout")
PFX = "gnss_"

def export():
    # 1. top-level port rename VDD -> VDDA (labels only; nets below are unchanged)
    p = os.path.join(MAG, TOP + ".mag")
    t = open(p).read()
    t = re.sub(r"(flabel \S+ s [-\d ]+ 0 FreeSans 80 0 0 0 )VDD\n", r"\1VDDA\n", t)
    # supply ports: USE POWER / GROUND in the LEF
    t = re.sub(r"(0 0 0 VDDA\nport \d+ nsew )signal", r"\1power", t)
    t = re.sub(r"(0 0 0 VSS\nport \d+ nsew )signal", r"\1ground", t)
    t = re.sub(r"(0 0 0 VDDV\nport \d+ nsew )signal", r"\1power", t)
    open(os.path.join(MAG, TOP + "_x.mag"), "w").write(t.replace("\n", "\n", 1))
    os.replace(os.path.join(MAG, TOP + "_x.mag"), p)
    # 2. GDS + LEF + extracted SPICE with magic
    script = """
load %(top)s
select top cell
gds write %(out)s/gds/%(top)s_raw.gds
lef write %(out)s/lef/%(top)s.lef -hide
extract all
ext2spice lvs
ext2spice -o %(out)s/spice/%(top)s.spice
quit -noprompt
""" % dict(top=TOP, out=OUT)
    print(lvs.magic(script, MAG)[-800:])
    # 3. prefix every sub-cell name in the GDS (avoids clashes when merged into the chip)
    import klayout.db as db
    ly = db.Layout(); ly.read(os.path.join(OUT, "gds/%s_raw.gds" % TOP))
    for c in ly.each_cell():
        if c.name != TOP and not c.name.startswith(PFX):
            c.name = PFX + c.name
    ly.write(os.path.join(OUT, "gds/%s.gds" % TOP))
    os.remove(os.path.join(OUT, "gds/%s_raw.gds" % TOP))
    sp = open(os.path.join(OUT, "spice/%s.spice" % TOP)).read()
    print("macro ports:", re.search(r"^\.subckt %s (.*)$" % TOP, sp, re.M).group(1))

if __name__ == "__main__":
    export()
