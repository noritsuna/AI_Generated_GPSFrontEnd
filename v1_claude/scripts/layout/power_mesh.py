"""M5 supply mesh over a finished (routed) module.

The row floorplan gives every module M4 supply rails (one VSS rail below and one VDD
rail above each row) tied to thin M3 spines.  For a large macro the spines alone are far
too resistive (3 um x 3 mm of 90 mohm/sq metal is ~100 ohm), so vertical M5 stripes,
alternating VDD / VSS, are laid over the whole cell.  Each stripe drops via4 arrays onto
every M4 rail of its net that it crosses, at every hierarchy level, which turns the rails
of all sub-modules into one mesh.  Stripes are cut around M5 and MIM geometry (the MIM
top plates use M5).

Optionally the two top rails get M5 pin bars (the VSS bar on top, the VDD bar below it is
interrupted where the VSS stripes pass through)."""
import auto
from mag import snap, xform
from module import RAIL_H

M5_SP = 460
MIM_KEEP = 1200          # M5 stripes keep this far from MIM top plates
V4_IN = 300              # via4 inset inside the stripe / rail crossing
NETS = ("VDD", "VSS", "VDDV")
# VDDV (separate VCO supply): every VDD stripe over the VCO that reaches both the VCO's rails and
# the VDDV top rail in one piece is taken for VDDV instead (every second one, the rest stay VDD)


def _tx(o, x, y, r):
    p1 = xform(o, r[0], r[1]); p2 = xform(o, r[2], r[3])
    return (min(p1[0], p2[0]) + x, min(p1[1], p2[1]) + y, max(p1[0], p2[0]) + x, max(p1[1], p2[1]) + y)


def _rails_of(cell):
    """(local net, rect) of the M4 supply rails of a module cell (rails span both spines)."""
    if hasattr(cell, "supply_pins") and cell.supply_pins:
        return [(n, r) for n, l, r in cell.supply_pins if l == "metal4"]
    sp = getattr(cell, "spines", [])
    if not sp:
        return []
    xl = min(r[0] for n, r in sp); xr = max(r[2] for n, r in sp)
    v3 = cell.rects.get("via3", [])
    out = []
    for r in cell.rects.get("metal4", []):
        if r[3] - r[1] != RAIL_H or r[0] != xl or r[2] != xr:
            continue
        for n, s in sp:
            if any(v[0] >= s[0] and v[2] <= s[2] and v[1] >= r[1] and v[3] <= r[3] for v in v3):
                out.append((n, r)); break
    return out


def rails(top, top_name=None):
    """All supply rails of the hierarchy in top coordinates, with global net names."""
    _, _, _, cells = auto.parse(top_name or top.name)
    out = []

    def walk(cell, x, y, o, gmap):
        for n, r in _rails_of(cell):
            g = gmap(n)
            if g in NETS:
                out.append((g, _tx(o, x, y, r)))
        if not any(getattr(c, "spines", None) for c, *_ in cell.uses):
            return
        try:
            _, _, devs, _ = auto.parse(cell.name)
        except KeyError:
            return
        by = {"X" + d["name"]: d for d in devs}
        for c, inst, cx, cy, co in cell.uses:
            if not getattr(c, "spines", None) or inst not in by or c.name not in cells:
                continue
            ports = cells[c.name][0].split()[2:]
            m = dict(zip(ports, by[inst]["nets"]))
            # child transform composed with ours (orientation N only below the top)
            px, py = xform(o, cx, cy)
            walk(c, x + px, y + py, co if o == "N" else o,
                 lambda n, m=m, gmap=gmap: gmap(m[n]) if n in m else None)
    walk(top, 0, 0, "N", lambda n: n)
    return out


def _subtract(lo, hi, cuts):
    segs = [(lo, hi)]
    for a, b in sorted(cuts):
        nxt = []
        for s, e in segs:
            if b <= s or a >= e:
                nxt.append((s, e)); continue
            if a > s:
                nxt.append((s, a))
            if b < e:
                nxt.append((b, e))
        segs = nxt
    return segs


def mesh(top, width=10000, pitch=40000, pins=True, verbose=True):
    rl = rails(top)
    obs = [(r, M5_SP) for l, r in top.flat(["metal5"])] + [(r, MIM_KEEP) for l, r in top.flat(["mimcap"])]
    b = top.bbox()
    sp = [r for n, r in top.spines]
    x_lo = min(r[0] for r in sp); x_hi = max(r[2] for r in sp)
    y_lo = min(r[1] for n, r in rl); y_hi = max(r[3] for n, r in rl)
    # pin bars over the top two rails
    tops = sorted([(r[1], n, r) for n, r in rl if r[1] >= y_hi - 4 * RAIL_H - 6000], reverse=True)
    bar_vss = bar_vdd = bar_vddv = None
    if pins:
        for y, n, r in tops:
            if n == "VSS" and bar_vss is None:
                bar_vss = r
            elif n == "VDDV" and bar_vddv is None and bar_vss is not None:
                bar_vddv = r
            elif n == "VDD" and bar_vdd is None and bar_vss is not None:
                bar_vdd = r
        y_stop = {"VDD": bar_vdd[1], "VSS": bar_vss[1]} if bar_vdd and bar_vss else {}
    # x span of the VDDV rails below the top rail (the VCO's own rails)
    vr = [r for n, r in rl if n == "VDDV" and (bar_vddv is None or r[1] < bar_vddv[1]) and r[2] - r[0] < x_hi - x_lo - 20000]
    vx = (min(r[0] for r in vr), max(r[2] for r in vr)) if vr else None
    nvddv = 0
    nv = 0; stripes = []
    x = x_lo + 2 * pitch // 4
    k = 0
    while x + width <= x_hi - pitch // 4:
        net = "VDD" if k % 2 == 0 else "VSS"
        sx1, sx2 = snap(x), snap(x + width)
        cuts = []
        for r, s in obs:
            if r[2] + s > sx1 and r[0] - s < sx2:
                cuts.append((r[1] - s, r[3] + s))
        if net == "VDD" and vx and bar_vddv and vx[0] <= sx1 and sx2 <= vx[1] and (k // 2) % 2 == 0:
            ok = False
            for s, e in _subtract(y_lo, bar_vddv[3], cuts):
                vv = [r for n, r in rl if n == "VDDV" and r[0] <= sx1 and r[2] >= sx2 and r[1] >= s and r[3] <= e]
                if any(r == bar_vddv for r in vv) and any(r[1] < bar_vdd[1] for r in vv):
                    ok = True
            if ok:
                net = "VDDV"; nvddv += 1
        hi = y_stop.get(net, y_hi) if pins else y_hi
        if pins and net == "VSS":
            hi = bar_vss[3]
        if pins and net == "VDD":
            hi = bar_vdd[3]
        if pins and net == "VDDV":
            hi = bar_vddv[3]
        for s, e in _subtract(y_lo, hi, cuts):
            vias = [r for n, r in rl if n == net and r[0] <= sx1 and r[2] >= sx2 and r[1] >= s and r[3] <= e]
            if not vias:
                continue
            s2 = max(s, min(v[1] for v in vias)); e2 = min(e, max(v[3] for v in vias))
            top.rect("m5", sx1, s2, sx2, e2)
            for v in vias:
                top.rect("v4", sx1 + V4_IN, v[1] + V4_IN, sx2 - V4_IN, v[3] - V4_IN)
                nv += 1
            stripes.append((net, (sx1, s2, sx2, e2)))
        x += pitch // 2
        k += 1
    if pins and bar_vss:
        # VSS bar: whole width; VDD bar: cut where the VSS stripes cross it
        r = bar_vss
        top.rect("m5", *r); top.label("m5", *r, "VSS", port=True)
        for xx in range(r[0] + 2000, r[2] - 2000, 20000):
            top.rect("v4", xx, r[1] + V4_IN, min(xx + 15000, r[2] - 2000), r[3] - V4_IN)
        # VDD / VDDV bars: cut where the stripes of the nets above them pass through
        for bnet, r, through in (("VDD", bar_vdd, ("VSS", "VDDV")), ("VDDV", bar_vddv, ("VSS",))):
            if r is None:
                continue
            cuts = [(s[0] - M5_SP - 40, s[2] + M5_SP + 40) for n, s in stripes if n in through and s[3] > r[1]]
            for a, e in _subtract(r[0], r[2], cuts):
                if e - a < 2000:
                    continue
                top.rect("m5", a, r[1], e, r[3]); top.label("m5", a, r[1], e, r[3], bnet, port=True)
                top.rect("v4", a + V4_IN, r[1] + V4_IN, e - V4_IN, r[3] - V4_IN)
    if verbose:
        print("mesh %s: %d rails, %d stripe segments (%d VDDV stripes), %d via4 arrays" % (top.name, len(rl), len(stripes), nvddv, nv))
    if bar_vddv is not None and not nvddv:
        raise RuntimeError("no VDDV stripe reaches both the VCO rails and the VDDV top rail")
    return stripes
