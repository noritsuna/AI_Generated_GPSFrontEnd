"""Custom padring cells for an isolated analog VDD domain (derived from gf180mcu_fd_io).

gf180mcu_gnss_io__vdda       : copy of fd_io__dvdd whose pad / clamp M2 plane connects to the
                               VDD ring bands only (via2 on the DVDD bands removed) -> VDDA pad
                               with the same RC-triggered clamp (VDDA -> DVSS).
gf180mcu_gnss_io__fill1_novdd: copy of fd_io__fill1 without the VDD ring bands -> VDD ring break
                               (DVDD / DVSS / VSS rings continue).
"""
import klayout.db as db, os, re
FD = os.path.expanduser("~/pdk/gf180mcuD/libs.ref/gf180mcu_fd_io")
OUT = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "chip/ip/gf180mcu_gnss_io")
M2, V2, M3, V3, M4, V4, M5 = (36, 0), (38, 0), (42, 0), (40, 0), (46, 0), (41, 0), (81, 0)
UM = 1000
DVDD_BANDS = [(118, 125), (134, 197), (206, 229), (262, 285), (294, 301), (334, 341)]
VDD_BANDS = [(254, 261), (310, 317)]

src = db.Layout(); src.read(os.path.join(FD, "gds/gf180mcu_fd_io.gds"))


def copy_cell(name, new):
    """flattened copy of a library cell into a fresh layout"""
    ly = db.Layout(); ly.dbu = src.dbu
    c = ly.create_cell(new)
    sc = src.cell(name)
    for li in src.layer_indexes():
        info = src.get_info(li)
        t = ly.layer(info)
        for it in sc.begin_shapes_rec(li).each():
            sh = it.shape()
            if sh.is_text():
                continue                      # labels are rewritten below
            c.shapes(t).insert(sh.polygon.transformed(it.trans()) if not sh.is_box() else sh.box.transformed(it.trans()))
    return ly, c


def band_region(bands, x1, x2):
    r = db.Region()
    for y1, y2 in bands:
        r.insert(db.Box(x1, y1 * UM, x2, y2 * UM))
    return r


def label(ly, c, layer, x, y, text):
    c.shapes(ly.layer(layer[0], 10)).insert(db.Text(text, db.Trans(int(x * UM), int(y * UM))))


# ---------------------------------------------------------------- VDDA pad
ly, c = copy_cell("gf180mcu_fd_io__dvdd", "gf180mcu_gnss_io__vdda")
v2 = ly.layer(*V2); m2 = ly.layer(*M2)
plane = [p for p in db.Region(c.begin_shapes_rec(m2)).merged().each() if p.bbox().height() > 300 * UM]
plane = db.Region(plane)
dv = band_region(DVDD_BANDS, -1000, 76000)
vias = db.Region(c.shapes(v2))
kill = vias.interacting(plane) & dv
kill = vias.interacting(plane).interacting(dv)
n_before = vias.count()
keep = vias - kill
c.shapes(v2).clear(); c.shapes(v2).insert(keep)
print("vdda: via2 %d -> %d (removed %d on the DVDD bands)" % (n_before, keep.count(), kill.count()))
for (y1, y2) in DVDD_BANDS:
    for L in (M3, M4, M5):
        label(ly, c, L, 37.5, (y1 + y2) / 2, "DVDD")
for (y1, y2) in VDD_BANDS:
    for L in (M3, M4, M5):
        label(ly, c, L, 37.5, (y1 + y2) / 2, "VDD")
label(ly, c, M5, 37.5, 32, "VDD")
for net, bands in (("DVSS", [(70, 117), (126, 133), (198, 205), (230, 245), (286, 293), (302, 309), (326, 333), (342, 348)]),
                   ("VSS", [(246, 253), (318, 325)])):
    for (y1, y2) in bands:
        for L in (M3, M4, M5):
            label(ly, c, L, 37.5, (y1 + y2) / 2, net)
ly.write(os.path.join(OUT, "gds/gf180mcu_gnss_io__vdda.gds"))

# ---------------------------------------------------------------- VDD break filler
ly2, c2 = copy_cell("gf180mcu_fd_io__fill1", "gf180mcu_gnss_io__fill1_novdd")
vb = band_region(VDD_BANDS, -1000, 2000)
for L in (V2, M3, V3, M4, V4, M5):
    li = ly2.layer(*L)
    r = db.Region(c2.shapes(li))
    r2 = r - vb if L in (M3, M4, M5) else r.not_interacting(vb)
    c2.shapes(li).clear(); c2.shapes(li).insert(r2)
for net, bands in (("DVDD", DVDD_BANDS), ("VSS", [(246, 253), (318, 325)]),
                   ("DVSS", [(70, 117), (126, 133), (198, 205), (230, 245), (286, 293), (302, 309), (326, 333)])):
    for (y1, y2) in bands:
        for L in (M3, M4, M5):
            label(ly2, c2, L, 0.5, (y1 + y2) / 2, net)
ly2.write(os.path.join(OUT, "gds/gf180mcu_gnss_io__fill1_novdd.gds"))

# ---------------------------------------------------------------- LEF
def lef_rename(src_lef, old, new, edit):
    t = open(os.path.join(FD, "lef", src_lef)).read().replace(old, new)
    return edit(t)

def vdda_lef(t):
    # split the DVDD pin: pad (Metal5 2..62) + VDD bands -> VDD ; DVDD bands stay DVDD
    m = re.search(r"  PIN DVDD\n(.*?)  END DVDD\n", t, re.S)
    body = m.group(1)
    ports = re.findall(r"    PORT\n.*?    END\n", body, re.S)
    def is_vdd(p):
        # the pad, its M2 plane (core side) and the VDD bands are the VDDA net
        if "LAYER Metal2" in p:
            return True
        ys = [float(v) for v in re.findall(r"RECT\s+\S+\s+(\S+)", p)]
        return any(y < 70 or any(abs(y - a) < 0.5 for a, b in VDD_BANDS) for y in ys)
    head = body[:body.index("    PORT")]
    dv = "".join(p for p in ports if not is_vdd(p)); vd = "".join(p for p in ports if is_vdd(p))
    new = "  PIN DVDD\n" + head + dv + "  END DVDD\n" + "  PIN VDD\n" + head.replace("USE SIGNAL", "USE POWER") + vd + "  END VDD\n"
    return t[:m.start()] + new + t[m.end():]

open(os.path.join(OUT, "lef/gf180mcu_gnss_io__vdda.lef"), "w").write(
    lef_rename("gf180mcu_fd_io__dvdd.lef", "gf180mcu_fd_io__dvdd", "gf180mcu_gnss_io__vdda", vdda_lef))

def novdd_lef(t):
    m = re.search(r"  PIN VDD\n.*?  END VDD\n", t, re.S)
    return t[:m.start()] + t[m.end():]
open(os.path.join(OUT, "lef/gf180mcu_gnss_io__fill1_novdd.lef"), "w").write(
    lef_rename("gf180mcu_fd_io__fill1.lef", "gf180mcu_fd_io__fill1", "gf180mcu_gnss_io__fill1_novdd", novdd_lef))

# ---------------------------------------------------------------- SPICE / Verilog
sp = open(os.path.join(FD, "spice/gf180mcu_fd_io.spice")).read()
m = re.search(r"\.SUBCKT gf180mcu_fd_io__dvdd DVDD DVSS VSS\n(.*?)\.ENDS", sp, re.S)
body = re.sub(r"\bDVDD\b", "VDD", m.group(1))
open(os.path.join(OUT, "spice/gf180mcu_gnss_io.spice"), "w").write(
    "* custom gnss AFE padring cells (derived from gf180mcu_fd_io)\n"
    ".SUBCKT gf180mcu_gnss_io__vdda DVDD DVSS VDD VSS\n" + body + ".ENDS\n\n"
    ".SUBCKT gf180mcu_gnss_io__fill1_novdd DVDD DVSS VSS\n.ENDS\n")
open(os.path.join(OUT, "vh/gf180mcu_gnss_io.v"), "w").write(
    "(* blackbox *)\nmodule gf180mcu_gnss_io__vdda (inout DVDD, inout DVSS, inout VDD, inout VSS);\nendmodule\n"
    "(* blackbox *)\nmodule gf180mcu_gnss_io__fill1_novdd (inout DVDD, inout DVSS, inout VSS);\nendmodule\n")
print("written to", OUT)


# ---------------------------------------------------------------- analog pad block
# One padring "pad" holding the whole analog section, so that no padring filler (whose VDD
# pin would be globally tied to the digital VDD) ends up on the isolated supply bands:
#   [fill10_noVDD] VSS  dvdd(=VDDA)  VSS  RF(asig)  VSS [fill10_noVDD] dvdd(=VDDV) VSS [fill10_noVDD]
# fill10_noVDD (user supplied, ~/gds) cuts both the DVDD and the VDD bands, so inside the
# block DVDD and VDD are the analog supply VDDA and the foundry dvdd pad is the VDDA pad.
BLOCK = [("fill10_noVDD", 10.0, {"DVSS": "VSS", "VSS": "VSS"}),
         ("gf180mcu_fd_io__dvss", 75.0, {"DVDD": "VDDA", "DVSS": "VSS", "VDD": "VDDA"}),
         ("gf180mcu_fd_io__dvdd", 75.0, {"DVDD": "VDDA", "DVSS": "VSS", "VSS": "VSS"}),
         ("gf180mcu_fd_io__dvss", 75.0, {"DVDD": "VDDA", "DVSS": "VSS", "VDD": "VDDA"}),
         ("gf180mcu_fd_io__asig_5p0", 75.0, {"ASIG5V": "RF", "DVDD": "VDDA", "DVSS": "VSS", "VDD": "VDDA", "VSS": "VSS"}),
         ("gf180mcu_fd_io__dvss", 75.0, {"DVDD": "VDDA", "DVSS": "VSS", "VDD": "VDDA"}),
         ("fill10_noVDD", 10.0, {"DVSS": "VSS", "VSS": "VSS"}),
         # VCO supply VDDV: its own ring section (pushing ~45 MHz/V: kept off the shared VDDA)
         ("gf180mcu_fd_io__dvdd", 75.0, {"DVDD": "VDDV", "DVSS": "VSS", "VSS": "VSS"}),
         ("gf180mcu_fd_io__dvss", 75.0, {"DVDD": "VDDV", "DVSS": "VSS", "VDD": "VDDV"}),
         ("fill10_noVDD", 10.0, {"DVSS": "VSS", "VSS": "VSS"})]
BNAME = "gf180mcu_gnss_io__afe_rf"
WB = sum(w for _, w, _ in BLOCK)

ly = db.Layout(); ly.dbu = 0.001
ly.read(os.path.join(FD, "gds/gf180mcu_fd_io.gds"))
for f in ("fill10_noVDD",):
    ly.read(os.path.join(OUT, "gds/%s.gds" % f))
top = ly.create_cell(BNAME)
x = 0.0
for cn, w, _ in BLOCK:
    top.insert(db.CellInstArray(ly.cell(cn).cell_index(), db.Trans(int(round(x * UM)), 0)))
    x += w
for net, (lx, ly_) in (("RF", (235 + 37.5, 32)), ("VDDA", (85 + 37.5, 32)), ("VDDV", (395 + 37.5, 32))):
    top.shapes(ly.layer(81, 10)).insert(db.Text(net, db.Trans(int(lx * UM), int(ly_ * UM))))
opt = db.SaveLayoutOptions(); opt.add_cell(top.cell_index())
ly.write(os.path.join(OUT, "gds/%s.gds" % BNAME), opt)

def lef_pins(path):
    t = open(path).read()
    pins = {}
    for m in re.finditer(r"  PIN (\S+)\n(.*?)  END \1\n", t, re.S):
        pins[m.group(1)] = re.findall(r"    PORT\n(.*?)    END\n", m.group(2), re.S)
    obs = re.search(r"  OBS\n(.*?)  END\n", t, re.S)
    return pins, obs.group(1) if obs else ""

def shift(body, dx):
    return re.sub(r"RECT\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)",
                  lambda m: "RECT %.3f %s %.3f %s" % (float(m.group(1)) + dx, m.group(2), float(m.group(3)) + dx, m.group(4)), body)

# LEF of the ring break: fd_io__fill10 without the DVDD and VDD pins
t10 = open(os.path.join(FD, "lef/gf180mcu_fd_io__fill10.lef")).read().replace("gf180mcu_fd_io__fill10", "fill10_noVDD")
for pn in ("DVDD", "VDD"):
    m = re.search(r"  PIN %s\n.*?  END %s\n" % (pn, pn), t10, re.S)
    t10 = t10[:m.start()] + t10[m.end():]
open(os.path.join(OUT, "lef/fill10_noVDD.lef"), "w").write(t10)
lefsrc = {"fill10_noVDD": os.path.join(OUT, "lef/fill10_noVDD.lef"),
          "gf180mcu_fd_io__dvdd": os.path.join(FD, "lef/gf180mcu_fd_io__dvdd.lef"),
          "gf180mcu_fd_io__dvss": os.path.join(FD, "lef/gf180mcu_fd_io__dvss.lef"),
          "gf180mcu_fd_io__asig_5p0": os.path.join(FD, "lef/gf180mcu_fd_io__asig_5p0.lef")}
ports = {"RF": [], "VDDA": [], "VDDV": [], "VSS": []}
obs = []
x = 0.0
for cn, w, mp in BLOCK:
    pins, ob = lef_pins(lefsrc[cn])
    for pn, plist in pins.items():
        ports[mp[pn]] += [shift(p, x) for p in plist]
    obs.append(shift(ob, x))
    x += w
use = {"RF": "SIGNAL", "VDDA": "POWER", "VDDV": "POWER", "VSS": "GROUND"}
o = ["VERSION 5.7 ;", 'BUSBITCHARS "[]" ;', 'DIVIDERCHAR "/" ;', "MACRO %s" % BNAME, "  CLASS PAD INOUT ;",
     "  ORIGIN 0 0 ;", "  FOREIGN %s 0 0 ;" % BNAME, "  SIZE %.3f BY 350.000 ;" % WB, "  SYMMETRY X Y R90 ;",
     "  SITE GF_IO_Site ;"]
for pn, plist in ports.items():
    o += ["  PIN %s" % pn, "    DIRECTION INOUT ;", "    USE %s ;" % use[pn]]
    for p in plist:
        o += ["    PORT", p.rstrip("\n"), "    END"]
    o += ["  END %s" % pn]
o += ["  OBS"] + [b.rstrip("\n") for b in obs if b.strip()] + ["  END", "END %s" % BNAME, "END LIBRARY"]
open(os.path.join(OUT, "lef/%s.lef" % BNAME), "w").write("\n".join(o) + "\n")

sp = open(os.path.join(OUT, "spice/gf180mcu_gnss_io.spice")).read()
sp += ("\n.SUBCKT fill10_noVDD DVSS VSS\n.ENDS\n"
       "\n.SUBCKT %s RF VDDA VDDV VSS\n" % BNAME +
       "XBRK0 VSS VSS fill10_noVDD\n"
       "XVSS0 VDDA VSS VDDA gf180mcu_fd_io__dvss\n"
       "XVDDA VDDA VSS VSS gf180mcu_fd_io__dvdd\n"
       "XVSS1 VDDA VSS VDDA gf180mcu_fd_io__dvss\n"
       "XRF RF VDDA VSS VDDA VSS gf180mcu_fd_io__asig_5p0\n"
       "XVSS2 VDDA VSS VDDA gf180mcu_fd_io__dvss\n"
       "XBRK1 VSS VSS fill10_noVDD\n"
       "XVDDV VDDV VSS VSS gf180mcu_fd_io__dvdd\n"
       "XVSS3 VDDV VSS VDDV gf180mcu_fd_io__dvss\n"
       "XBRK2 VSS VSS fill10_noVDD\n.ENDS\n")
open(os.path.join(OUT, "spice/gf180mcu_gnss_io.spice"), "w").write(sp)
v = open(os.path.join(OUT, "vh/gf180mcu_gnss_io.v")).read()
v += ("(* blackbox *)\nmodule %s (inout RF, inout VDDA, inout VDDV, inout VSS);\nendmodule\n" % BNAME)
open(os.path.join(OUT, "vh/gf180mcu_gnss_io.v"), "w").write(v)
print("block", BNAME, "width", WB)
