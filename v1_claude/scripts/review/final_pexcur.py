"""Final check, part 7: are the PEX netlists (layout/mag/<block>.pex.spice, extracted 11-04 .. 11-13) still those of the
final layout?  The block cells of the final macro GDS are XORed against the macro GDS of 2026-11-13 23:43
(archive/padframe_v1/macro_and_final.tgz), which is the layout the last PEX netlists were extracted from.
usage: final_pexcur.py <old macro gds> -> layout/review/final/pexcur.log (stdout)"""
import os, sys
import klayout.db as db
ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
new = db.Layout(); new.read(os.path.join(ROOT, "layout/gds/gnss_afe_analog.gds"))
old = db.Layout(); old.read(sys.argv[1])
blocks = "lna_nc mixer_iq if_chain adc2b afc_dac vco_ring4 pll_core vmon_buf bias_gen refbuf decap gnss_afe_analog".split()
for b in blocks:
    n = b if b == "gnss_afe_analog" else "gnss_" + b
    cn, co = new.cell(n), old.cell(n)
    if cn is None or co is None:
        print("%-16s cell missing (new %s, old %s)" % (b, cn is not None, co is not None)); continue
    tot, lay = 0, []
    for li in new.layer_infos():
        a = db.Region(cn.begin_shapes_rec(new.layer(li))); o = db.Region(co.begin_shapes_rec(old.layer(li.layer, li.datatype)))
        x = (a ^ o).count()
        if x:
            tot += x; lay.append("%d/%d:%d" % (li.layer, li.datatype, x))
    print("%-16s bbox new %s old %s  XOR %d %s" % (b, cn.dbbox().to_s(), co.dbbox().to_s(), tot, " ".join(lay[:12])))
