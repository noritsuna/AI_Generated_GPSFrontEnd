"""Pictures of the final layouts for the report: doc/chip_quarter.png (whole chip) and doc/macro_quarter.png (analog macro).
usage: python3 scripts/layout/render_png.py"""
import os
import klayout.lay as lay
ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
LYP = os.path.expanduser("~/pdk/gf180mcuD/libs.tech/klayout/tech/gf180mcu.lyp")
for gds, out, w, h in (("chip/final/gds/chip_top.gds", "doc/chip_quarter.png", 1500, 1960),
                       ("layout/gds/gnss_afe_analog.gds", "doc/macro_quarter.png", 1300, 1960)):
    v = lay.LayoutView(); v.load_layout(os.path.join(ROOT, gds), True)
    v.load_layer_props(LYP)
    v.max_hier(); v.zoom_fit()
    v.set_config("background-color", "#ffffff"); v.set_config("grid-visible", "false")
    v.save_image(os.path.join(ROOT, out), w, h); print(out)
