"""Read back the .mag files written by mag.Cell so that a finished sub-module can be
re-used by a parent without rebuilding (and re-routing) it."""
import os
from mag import UNIT, ORIENT, snap
from devices import Dev
ROUTE_LAYERS = ("metal2", "metal3", "metal4")

_cache = {}
# same-cell connectivity of the routing metal (vias join adjacent layers)
_CONN = {"metal2": ("via1", "via2"), "metal3": ("via2", "via3"), "metal4": ("via3", "via4")}


def _nets_of(c):
    """{(layer, rect): net} for the cell's own wiring connected to a labelled pin, so the
    parent router treats it as that net's metal rather than an anonymous obstacle."""
    sh = [(l, r) for l in ("metal2", "metal3", "metal4", "via2", "via3") for r in c.rects.get(l, [])]
    par = list(range(len(sh)))

    def fd(i):
        while par[i] != i:
            par[i] = par[par[i]]; i = par[i]
        return i

    def touch(a, b):
        return a[0] <= b[2] and b[0] <= a[2] and a[1] <= b[3] and b[1] <= a[3]
    G = 10000
    buckets = {}
    for k, (l, r) in enumerate(sh):
        for gx in range(r[0] // G, r[2] // G + 1):
            for gy in range(r[1] // G, r[3] // G + 1):
                buckets.setdefault((gx, gy), []).append(k)
    for ks in buckets.values():
        for p in range(len(ks)):
            la, ra = sh[ks[p]]
            for q in ks[p + 1:]:
                lb, rb = sh[q]
                if (la == lb or lb in _CONN.get(la, ()) or la in _CONN.get(lb, ())) and touch(ra, rb):
                    a, b = fd(ks[p]), fd(q)
                    if a != b:
                        par[a] = b
    root = {}
    for net, lst in c.pins.items():
        for l, r in lst:
            for k, (sl, sr) in enumerate(sh):
                if sl == l and touch(sr, r):
                    root.setdefault(fd(k), set()).add(net)
    out = {}
    for k, (l, r) in enumerate(sh):
        ns = root.get(fd(k))
        if ns and len(ns) == 1 and not l.startswith("via"):
            out[(l, r)] = next(iter(ns))
    return out
INV = {v: k for k, v in ORIENT.items()}


def load(name, d):
    if name in _cache:
        return _cache[name]
    c = Dev(name)
    layer = None
    lines = open(os.path.join(d, name + ".mag")).read().split("\n")
    k = 0
    last_label = None
    while k < len(lines):
        t = lines[k].split()
        k += 1
        if not t:
            continue
        if t[0] == "<<":
            layer = t[1]
        elif t[0] == "rect" and layer not in ("labels", "properties", "end"):
            c.rects.setdefault(layer, []).append(tuple(int(v) * UNIT for v in t[1:5]))
        elif t[0] == "use":
            sub, inst = t[1], t[2]
            tr = lines[k + 1].split()
            assert tr[0] == "transform", (name, tr)
            a, b, x, dd, e, y = (int(v) for v in tr[1:7])
            c.uses.append((load(sub, d), inst, x * UNIT, y * UNIT, INV[(a, b, dd, e)]))
            k += 3
        elif t[0] == "flabel":
            r = tuple(int(v) * UNIT for v in t[3:7])
            c.labels.append((t[1], r, t[-1], False, None))
            last_label = len(c.labels) - 1
        elif t[0] == "port" and last_label is not None:
            l, r, txt, _, _ = c.labels[last_label]
            c.labels[last_label] = (l, r, txt, True, t[-1])
        elif t[0] == "string" and layer == "properties":
            c.props[t[1]] = " ".join(t[2:])
    # pins: labelled shapes on the routing layers; supply spines (tall M3 VDD/VSS bars)
    c.spines = []
    for l, r, txt, port, dirn in c.labels:
        if l not in ROUTE_LAYERS:
            continue
        c.pins.setdefault(txt, []).append((l, r))
        if l == "metal3" and txt in ("VDD", "VSS", "VR") and (r[3] - r[1]) > 10 * (r[2] - r[0]):
            c.spines.append((txt, r))
    c.netof = _nets_of(c)
    b = c.bbox()
    c.outline = (snap(b[0] - 700), snap(b[1] - 700), snap(b[2] + 700), snap(b[3] + 700))
    _cache[name] = c
    return c
