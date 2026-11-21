"""Tiny xschem schematic/symbol generator.

Instances are placed on a grid and connected by net labels (lab_pin) on
short wire stubs, so the generated .sch is a real, editable xschem
schematic whose connectivity is defined purely by labels.
"""
import os
import re

PDK_SYM = os.path.expandvars("$PDK_ROOT/$PDK/libs.tech/xschem")
def _xschem_lib():
    """xschem system library: $XSCHEM_SHAREDIR, else <prefix>/share/xschem next to the xschem binary."""
    import shutil
    d = os.environ.get("XSCHEM_SHAREDIR")
    if not d:
        exe = shutil.which("xschem") or "/usr/local/bin/xschem"
        d = os.path.join(os.path.dirname(os.path.dirname(os.path.realpath(exe))), "share", "xschem")
    return os.path.join(d, "xschem_library")


XS_DEV = _xschem_lib()
HERE = os.path.dirname(os.path.abspath(__file__))
PROJ_SYM = os.path.join(os.path.dirname(HERE), "xschem")
LIBPATH = [PROJ_SYM, PDK_SYM, XS_DEV]

HEADER = "v {xschem version=3.4.5 file_version=1.2}\nG {}\nK {}\nV {}\nS {}\nE {}\n"

_pin_cache = {}


def sym_pins(sym):
    """Return list of (name, x, y) pin centers of a symbol."""
    if sym in _pin_cache:
        return _pin_cache[sym]
    for d in LIBPATH:
        p = os.path.join(d, sym)
        if os.path.exists(p):
            break
    else:
        raise FileNotFoundError(sym)
    pins = []
    for line in open(p):
        m = re.match(r"B 5 (\S+) (\S+) (\S+) (\S+) \{(.*)", line)
        if m:
            x1, y1, x2, y2 = map(float, m.groups()[:4])
            nm = re.search(r"name=(\S+)", m.group(5)).group(1).rstrip("}")
            pins.append((nm, (x1 + x2) / 2, (y1 + y2) / 2))
    _pin_cache[sym] = pins
    return pins


def fmt(v):
    return ("%g" % v) if isinstance(v, float) else str(v)


class Sch:
    """One schematic. ``pins`` = [(name, 'in'|'out'|'inout'), ...]."""

    def __init__(self, name, pins=(), title="", cols=6, dx=260, dy=200):
        self.name, self.pins, self.title = name, list(pins), title
        self.lines, self.n = [], 0
        self.cols, self.dx, self.dy = cols, dx, dy
        self.col = self.row = 0
        self.y = 300          # y of the current row
        self.row_h = 0        # tallest instance (pin extent) in the current row
        self.prev_bottom = -1e9   # lowest pin of the previous row
        self.row_bottom = -1e9
        self.lab = 0
        self.texts = []

    # ---------------- placement ----------------
    def _advance_row(self):
        self.prev_bottom = self.row_bottom
        self.y = max(self.y + self.dy, self.row_bottom + 80)
        self.col, self.row, self.row_h, self.row_bottom = 0, self.row + 1, 0, -1e9

    def _next_xy(self):
        if self.col >= self.cols:
            self._advance_row()
        x = 200 + self.col * self.dx
        self.col += 1
        return x, self.y

    def newrow(self, comment=None):
        if self.col:
            self._advance_row()
        if comment:
            self.texts.append((100, self.y - 110, comment))

    def inst(self, sym, props, nets, xy=None):
        """Place symbol ``sym`` with property string and pin->net dict."""
        x, y = xy or self._next_xy()
        hh = max(abs(py) for _, _, py in sym_pins(sym)) + 20
        if xy is None and y - hh - 40 < self.prev_bottom:   # tall symbol: keep clear of the row above
            y = self.prev_bottom + hh + 40
        self.row_h = max(self.row_h, 2 * hh)
        self.row_bottom = max(self.row_bottom, y + hh)
        self.lines.append("C {%s} %g %g 0 0 {%s}" % (sym, x, y, props))
        for pn, px, py in sym_pins(sym):
            if pn not in nets:
                raise KeyError("%s: pin %s unconnected" % (props.split()[0], pn))
            net = nets[pn]
            ax, ay = x + px, y + py
            # stub direction: away from symbol center (project box symbols: always sideways)
            if abs(px) >= abs(py) or "/" not in sym:
                sx, sy = (ax + 20, ay) if px > 0 else (ax - 20, ay)
                flip = 1 if px > 0 else 0
            else:
                sx, sy = (ax, ay - 20) if py < 0 else (ax, ay + 20)
                flip = 0
            self.lines.append("N %g %g %g %g {lab=%s}" % (ax, ay, sx, sy, net))
            self.lab += 1
            self.lines.append("C {devices/lab_pin.sym} %g %g 0 %d {name=l%d sig_type=std_logic lab=%s}"
                              % (sx, sy, flip, self.lab, net))

    # ---------------- primitives ----------------
    def _mos(self, model, name, d, g, s, b, W, L, nf, m):
        sym = "symbols/%s.sym" % model
        props = ("name=%s L=%s W=%s nf=%d m=%d ad=\"'int((nf+1)/2) * W/nf * 0.18u'\" "
                 "pd=\"'2*int((nf+1)/2) * (W/nf + 0.18u)'\" as=\"'int((nf+2)/2) * W/nf * 0.18u'\" "
                 "ps=\"'2*int((nf+2)/2) * (W/nf + 0.18u)'\" nrd=\"'0.18u / W'\" nrs=\"'0.18u / W'\" "
                 "sa=0 sb=0 sd=0 model=%s spiceprefix=X") % (name, L, W, nf, m, model)
        self.inst(sym, props, dict(D=d, G=g, S=s, B=b))

    def nmos(self, name, d, g, s, b="VSS", W="1u", L="0.28u", nf=1, m=1, model="nfet_03v3"):
        self._mos(model, name, d, g, s, b, W, L, nf, m)

    def pmos(self, name, d, g, s, b="VDD", W="1u", L="0.28u", nf=1, m=1, model="pfet_03v3"):
        self._mos(model, name, d, g, s, b, W, L, nf, m)

    def rpoly(self, name, p, m_, W="1u", L="10u", mult=1, b="VSS"):
        """High-R poly (ppolyf_u_1k, ~1 kohm/sq)."""
        self.inst("symbols/ppolyf_u_1k.sym",
                  "name=%s W=%s L=%s model=ppolyf_u_1k spiceprefix=X m=%d" % (name, W, L, mult),
                  dict(P=p, M=m_, B=b))

    def cmim(self, name, top, bot, W="10e-6", L="10e-6", mult=1):
        """MIM cap 2fF/um^2."""
        self.inst("symbols/cap_mim_2f0fF.sym",
                  "name=%s W=%s L=%s model=cap_mim_2f0_m4m5_noshield spiceprefix=X m=%d" % (name, W, L, mult),
                  dict(G=top, B=bot))

    def res(self, name, p, m_, value):
        self.inst("devices/res.sym", "name=%s value=%s footprint=1206 device=resistor m=1" % (name, value),
                  dict(P=p, M=m_))

    def cap(self, name, p, m_, value):
        self.inst("devices/capa.sym", "name=%s value=%s footprint=1206 device=capacitor m=1" % (name, value),
                  dict(p=p, m=m_))

    def ind(self, name, p, m_, value):
        self.inst("devices/ind.sym", "name=%s value=%s m=1" % (name, value), dict(p=p, m=m_))

    def vsrc(self, name, p, m_, value):
        self.inst("devices/vsource.sym", "name=%s value=\"%s\" savecurrent=false" % (name, value),
                  dict(p=p, m=m_))

    def isrc(self, name, p, m_, value):
        self.inst("devices/isource.sym", "name=%s value=\"%s\"" % (name, value), dict(p=p, m=m_))

    def vcvs(self, name, p, m_, cp, cm, gain):
        self.inst("devices/vcvs.sym", "name=%s value=%s" % (name, gain), dict(p=p, m=m_, cp=cp, cm=cm))

    def sub(self, cell, name, nets, extra=""):
        """Instance of a project subcircuit symbol ``cell.sym``."""
        self.inst("%s.sym" % cell, "name=%s %s" % (name, extra), nets)

    def code(self, name, text, toplevel=True):
        x = 200 + self.cols * self.dx + 100
        y = 300 + 400 * sum(1 for l in self.lines if "code_shown" in l)
        text = text.replace('"', '\\"')
        self.lines.append('C {devices/code_shown.sym} %g %g 0 0 {name=%s only_toplevel=%s value="%s"}'
                          % (x, y, name, "true" if toplevel else "false", text))

    def models(self, corner="typical"):
        self.code("MODELS", ".include $::180MCU_MODELS/design.ngspice\n"
                            ".lib $::180MCU_MODELS/sm141064.ngspice %s\n"
                            ".lib $::180MCU_MODELS/sm141064.ngspice res_typical\n"
                            ".lib $::180MCU_MODELS/sm141064.ngspice mimcap_typical" % corner)
        # value must be tcl-evaluated to expand $::180MCU_MODELS
        self.lines[-1] = self.lines[-1].replace("{name=MODELS", "{name=MODELS format=\"tcleval( @value )\"")

    # ---------------- output ----------------
    def save(self, path=None):
        path = path or os.path.join(PROJ_SYM, self.name + ".sch")
        out = [HEADER]
        if self.title:
            out.append("T {%s} 100 80 0 0 0.6 0.6 {}" % self.title)
        for x, y, t in self.texts:
            out.append("T {%s} %g %g 0 0 0.4 0.4 {layer=8}" % (t, x, y))
        # schematic I/O pins (left column)
        pin_sym = {"in": "ipin", "out": "opin", "inout": "iopin"}
        for i, (pn, d) in enumerate(self.pins):
            x, y = -100, 300 + 30 * i
            out.append("C {devices/%s.sym} %g %g 0 0 {name=p%d lab=%s}" % (pin_sym[d], x, y, i, pn))
        out += self.lines
        out.append("C {devices/title.sym} 160 %g 0 0 {name=l_title author=\"GNSS AFE / GF180MCU\"}"
                   % (self.y + self.row_h + 2 * self.dy))
        open(path, "w").write("\n".join(out) + "\n")
        return path

    def save_sym(self, path=None, label=None):
        """Box symbol: inputs on the left, outputs/inouts on the right."""
        path = path or os.path.join(PROJ_SYM, self.name + ".sym")
        left = [p for p in self.pins if p[1] == "in"]
        right = [p for p in self.pins if p[1] != "in"]
        h = 20 * max(len(left), len(right), 2) + 20
        w = 160
        o = ["v {xschem version=3.4.5 file_version=1.2}", "G {}",
             'K {type=subcircuit\nformat="@name @pinlist @symname"\ntemplate="name=x1"\n}',
             "V {}", "S {}", "E {}",
             "B 4 %g %g %g %g {}" % (-w / 2, -h / 2, w / 2, h / 2)]
        for side, plist, xs in (("L", left, -w / 2 - 20), ("R", right, w / 2 + 20)):
            for i, (pn, d) in enumerate(plist):
                y = -h / 2 + 20 + 20 * i
                xe = -w / 2 if side == "L" else w / 2
                o.append("L 4 %g %g %g %g {}" % (xs, y, xe, y))
                o.append("B 5 %g %g %g %g {name=%s dir=%s}" % (xs - 2.5, y - 2.5, xs + 2.5, y + 2.5, pn, d))
                if side == "L":
                    o.append("T {%s} %g %g 0 0 0.2 0.2 {}" % (pn, xe + 5, y - 6))
                else:
                    o.append("T {%s} %g %g 0 1 0.2 0.2 {}" % (pn, xe - 5, y - 6))
        o.append("T {@symname} 0 %g 0 0 0.25 0.25 {hcenter=true}" % (-h / 2 - 30))
        o.append("T {@name} 0 %g 0 0 0.25 0.25 {hcenter=true}" % (h / 2 + 5))
        # pin order for @pinlist follows B 5 order: rewrite so it matches self.pins
        boxes = {re.search(r"name=(\S+)", l).group(1): l for l in o if l.startswith("B 5")}
        rest = [l for l in o if not l.startswith("B 5")]
        hdr, body = rest[:7], rest[7:]
        o = hdr + [boxes[pn] for pn, _ in self.pins] + body
        open(path, "w").write("\n".join(o) + "\n")
        _pin_cache.pop(os.path.basename(path), None)
        return path
