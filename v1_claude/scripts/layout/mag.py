"""Minimal magic (.mag) writer for gf180mcuD.

All coordinates are integers in nm.  The .mag files use ``magscale 1 10``
(1 internal unit = 5 nm), so every coordinate must be a multiple of 5 nm.
"""
import os

UNIT = 5  # nm per .mag internal unit

# Paint order: within one plane the metal is painted before the via/contact,
# and the MIM top plate after its M4 bottom plate (mimcap replaces m4).
ORDER = ["pwell", "nwell", "ndiff", "pdiff", "psubdiff", "nsubdiff", "nmos", "pmos",
         "polysilicon", "nhighres", "ndiffc", "pdiffc", "psubdiffcont", "nsubdiffcont",
         "polycontact", "metal1", "metal2", "metal3", "metal4", "mimcap", "metal5",
         "via1", "via2", "via3", "via4", "mimcapcontact", "comment"]
SHORT = {"m1": "metal1", "m2": "metal2", "m3": "metal3", "m4": "metal4", "m5": "metal5",
         "v1": "via1", "v2": "via2", "v3": "via3", "v4": "via4", "poly": "polysilicon",
         "pc": "polycontact", "ndc": "ndiffc", "pdc": "pdiffc", "psc": "psubdiffcont",
         "nsc": "nsubdiffcont", "psd": "psubdiff", "nsd": "nsubdiff", "hires": "nhighres",
         "mimcc": "mimcapcontact", "nw": "nwell", "pw": "pwell"}

# orientation -> (a, b, d, e) of magic "transform a b c d e f"
ORIENT = {"N": (1, 0, 0, 1), "S": (-1, 0, 0, -1), "FN": (-1, 0, 0, 1), "FS": (1, 0, 0, -1),
          "E": (0, 1, -1, 0), "W": (0, -1, 1, 0), "FE": (0, 1, 1, 0), "FW": (0, -1, -1, 0)}


def snap(v, g=UNIT):
    return int(round(v / g)) * g


def xform(o, x, y):
    a, b, d, e = ORIENT[o]
    return a * x + b * y, d * x + e * y


class Cell:
    def __init__(self, name):
        self.name = name
        self.rects = {}      # layer -> list of (x1,y1,x2,y2)
        self.labels = []     # (layer, rect, text, is_port, direction)
        self.uses = []       # (cell, inst, x, y, orient)
        self.props = {}

    # ---------------- drawing ----------------
    def rect(self, layer, x1, y1, x2, y2):
        layer = SHORT.get(layer, layer)
        if x1 > x2: x1, x2 = x2, x1
        if y1 > y2: y1, y2 = y2, y1
        r = tuple(snap(v) for v in (x1, y1, x2, y2))
        if r[0] == r[2] or r[1] == r[3]:
            return
        self.rects.setdefault(layer, []).append(r)
        return r

    def box(self, layer, cx, cy, w, h):
        return self.rect(layer, cx - w / 2, cy - h / 2, cx + w / 2, cy + h / 2)

    def label(self, layer, x1, y1, x2, y2, text, port=True, direction="bidirectional"):
        layer = SHORT.get(layer, layer)
        self.labels.append((layer, tuple(snap(v) for v in (x1, y1, x2, y2)), text, port, direction))

    def use(self, cell, inst, x=0, y=0, orient="N"):
        self.uses.append((cell, inst, snap(x), snap(y), orient))
        return self

    # ---------------- geometry ----------------
    def bbox(self, layers=None):
        xs = []
        for l, rs in self.rects.items():
            if layers and l not in layers:
                continue
            xs += rs
        for c, i, x, y, o in self.uses:
            b = c.bbox(layers)
            if b is None:
                continue
            for px, py in ((b[0], b[1]), (b[2], b[3])):
                pass
            corners = [xform(o, b[0], b[1]), xform(o, b[2], b[3])]
            x1 = min(p[0] for p in corners) + x; x2 = max(p[0] for p in corners) + x
            y1 = min(p[1] for p in corners) + y; y2 = max(p[1] for p in corners) + y
            xs.append((x1, y1, x2, y2))
        if not xs:
            return None
        return (min(r[0] for r in xs), min(r[1] for r in xs), max(r[2] for r in xs), max(r[3] for r in xs))

    def flat(self, layers=None, x0=0, y0=0, o="N", path=""):
        """Yield (layer, rect) of all geometry (recursively) in this cell's coordinates."""
        for l, rs in self.rects.items():
            if layers and l not in layers:
                continue
            for r in rs:
                p1 = xform(o, r[0], r[1]); p2 = xform(o, r[2], r[3])
                yield l, (min(p1[0], p2[0]) + x0, min(p1[1], p2[1]) + y0,
                          max(p1[0], p2[0]) + x0, max(p1[1], p2[1]) + y0)
        for c, i, x, y, oo in self.uses:
            # compose transforms: child point p -> oo -> +(x,y) -> o -> +(x0,y0)
            for l, r in c.flat(layers, 0, 0, oo):
                rr = (r[0] + x, r[1] + y, r[2] + x, r[3] + y)
                p1 = xform(o, rr[0], rr[1]); p2 = xform(o, rr[2], rr[3])
                yield l, (min(p1[0], p2[0]) + x0, min(p1[1], p2[1]) + y0,
                          max(p1[0], p2[0]) + x0, max(p1[1], p2[1]) + y0)

    def flattened(self, name=None, keep=lambda c: False):
        """New cell with the geometry of the hierarchy copied in (top labels kept).
        Sub-cells for which keep(cell) is true stay as instances."""
        f = Cell(name or self.name + "_flat")
        for l, rs in self.rects.items():
            f.rects.setdefault(l, []).extend(rs)
        for c, inst, x, y, o in self.uses:
            if keep(c):
                f.uses.append((c, inst, x, y, o))
                continue
            for l, r in c.flat(None, 0, 0, o):
                f.rects.setdefault(l, []).append((r[0] + x, r[1] + y, r[2] + x, r[3] + y))
            for cc, ii, xx, yy, oo in c.uses:
                if keep(cc):
                    raise NotImplementedError("kept cell below the first level")
        f.labels = list(self.labels)
        return f

    # ---------------- output ----------------
    def write(self, d, done=None):
        done = set() if done is None else done
        if self.name in done:
            return
        done.add(self.name)
        for c, *_ in self.uses:
            c.write(d, done)
        o = ["magic", "tech gf180mcuD", "magscale 1 10", "timestamp 0"]
        for l in ORDER + sorted(set(self.rects) - set(ORDER)):
            rs = self.rects.get(l)
            if not rs:
                continue
            o.append("<< %s >>" % l)
            for r in rs:
                o.append("rect %d %d %d %d" % tuple(v // UNIT for v in r))
        for c, inst, x, y, orient in self.uses:
            a, b, dd, e = ORIENT[orient]
            bb = c.bbox() or (0, 0, 0, 0)
            o += ["use %s %s" % (c.name, inst), "timestamp 0",
                  "transform %d %d %d %d %d %d" % (a, b, x // UNIT, dd, e, y // UNIT),
                  "box %d %d %d %d" % tuple(v // UNIT for v in bb)]
        if self.labels:
            o.append("<< labels >>")
            idx = {}
            for l, r, t, port, dirn in self.labels:
                o.append("flabel %s s %d %d %d %d 0 FreeSans 80 0 0 0 %s" % ((l,) + tuple(v // UNIT for v in r) + (t,)))
                if port:
                    idx.setdefault(t, len(idx) + 1)
                    o.append("port %d nsew signal %s" % (idx[t], dirn))
        if self.props:
            o.append("<< properties >>")
            for k, v in self.props.items():
                o.append("string %s %s" % (k, v))
        o.append("<< end >>")
        open(os.path.join(d, self.name + ".mag"), "w").write("\n".join(o) + "\n")
