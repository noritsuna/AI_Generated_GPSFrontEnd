"""Final check, part 5: the analog macro inside the final chip GDS.
  1. cut the cell gnss_afe_analog out of chip/final/gds/chip_top.gds and XOR it, layer by layer, against
     layout/gds/gnss_afe_analog.gds (the verified macro)
  2. list the layers / datatypes and cell count of the macro, and its placement in chip_top
The cut-out macro is written to layout/review/final/gdslvs/macro_from_chip.gds (input of the GDS-based LVS).
usage: final_gds.py -> layout/review/final/gds.log (stdout)"""
import os, hashlib
import klayout.db as db
ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
CHIP = os.path.join(ROOT, "chip/final/gds/chip_top.gds")
MAC = os.path.join(ROOT, "layout/gds/gnss_afe_analog.gds")
OUT = os.path.join(ROOT, "layout/review/final/gdslvs/macro_from_chip.gds")
TOP = "gnss_afe_analog"

h = hashlib.sha256(open(CHIP, "rb").read()).hexdigest()
print("chip_top.gds: %d bytes, SHA-256 %s" % (os.path.getsize(CHIP), h))
ly = db.Layout(); ly.read(CHIP)
tops = [c.name for c in ly.top_cells()]
print("top cells: %s, cells %d, dbu %g" % (tops, ly.cells(), ly.dbu))
mc = ly.cell(TOP)
inst = [(i.parent_cell.name, i.dtrans.to_s()) for c in ly.each_cell() for i in c.each_inst() if i.cell.name == TOP]
print("macro instances: %s, macro bbox %s um" % (inst, mc.dbbox().to_s()))
# cut out
l2 = db.Layout(); l2.dbu = ly.dbu
t2 = l2.create_cell(TOP)
t2.copy_tree(mc)
l2.write(OUT)
ref = db.Layout(); ref.read(MAC)
rc = ref.cell(TOP)
print("reference macro: cells %d, bbox %s um; cut-out: cells %d" % (ref.cells(), rc.dbbox().to_s(), l2.cells()))
layers = sorted({(i.layer, i.datatype) for i in ref.layer_infos()} | {(i.layer, i.datatype) for i in l2.layer_infos()})
diff = 0
for l, d in layers:
    a = db.Region(t2.begin_shapes_rec(l2.layer(l, d))); b = db.Region(rc.begin_shapes_rec(ref.layer(l, d)))
    x = a ^ b
    n = x.count()
    diff += n
    print("  layer %3d/%-2d  chip %9d  macro %9d shapes (merged area %12.1f / %12.1f um2)  XOR %d" % (
        l, d, a.count(), b.count(), a.area() * ly.dbu ** 2, b.area() * ly.dbu ** 2, n))
    # labels
    ta = sorted((s.text.string, s.text.x, s.text.y) for s in t2.begin_shapes_rec(l2.layer(l, d)).each() if s.shape().is_text()) if False else None
print("XOR total: %d polygons -> %s" % (diff, "IDENTICAL geometry" if diff == 0 else "DIFFERENT"))
