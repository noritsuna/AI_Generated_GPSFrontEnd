"""Parameterised device generators for gf180mcuD (3.3 V devices), drawn in magic layers.

Every generator returns a ``Dev`` (a mag.Cell plus pin geometry).  Pins are given as
(layer, rect) in the cell's own coordinates; the router connects to them.

Layout techniques built in:
  * MOS rows: multi-finger devices sharing diffusion, interdigitated / common-centroid
    finger patterns, dummy poly at both row ends, gate straps on both ends of the fingers,
    full-coverage S/D contacts, via arrays on every strip, own guard ring per row group.
  * Resistors: unit-length hires segments, series-connected by metal jumpers, in a guard ring.
  * MIM: unit 5x5 um top plates on a shared M4 bottom plate (one capacitor = N units).
"""
from mag import Cell, snap, SHORT

# ---------------------------------------------------------------- rules (nm)
CT = 230          # diffusion / poly contact (magic contact type size)
CT_DIFF = 65      # diffusion enclosure of contact
CT_POLY_GATE = 150  # contact to gate poly
M1_END = 55       # M1 end extension beyond a contact
POLY_END = 300    # poly endcap beyond diffusion (rule 220)
POLY_DIFF = 100   # poly to unrelated diffusion
POLY_SP = 240
DUM_OFF = 300     # dummy poly to diffusion edge
V1 = 260; V1_ENC = 60
V2 = 280; V2_ENC = 50
M1_W = 230; M1_SP = 230
MX_W = 280; MX_SP = 280   # M2..M4
M5_W = 440; M5_SP = 460
RING_W = 520      # guard-ring diffusion width
RING_CT = 390     # guard-ring contact strip width
RING_GAP = 330    # guard ring to device diffusion
RING2 = None      # net of the outer n-well ring of NMOS devices (double guard ring), set per cell
RING2_GAP = 600   # p-well edge of the inner ring to the outer n-well
WELL_ENC = 120    # well enclosure of the guard ring
PIN_W = 400       # M2 pin bus width (minimum)

R_GAP = 1000      # hires segment spacing (HRES.2 0.4, hires-to-poly 0.6)
R_HEAD = 610      # hires head (poly) length, same as the PDK generator
R_PC_OFF = 315    # pc offset in head
R_RING = 700      # hires to guard-ring diffusion (0.6 rule)

CAP_U = 5000      # MIM unit top plate (um^2 = 25 -> ~50 fF)
CAP_GAP = 800     # top-plate spacing (0.6 rule)
CAP_BENC = 600    # bottom plate enclosure of top plate
CAP_CC = 390      # mimcc inset inside top plate
MIM_PLATE_MAX = 380   # units (25 um^2) per shared bottom plate: 9500 um^2 < 10000 (MIMTM.11)
MIM_PLATE_SP = 1500    # M4 space between split bottom plates


class Dev(Cell):
    def __init__(self, name):
        super().__init__(name)
        self.pins = {}     # net -> list of (layer, rect)

    def pin(self, net, layer, x1, y1, x2, y2, label=True):
        r = self.rect(layer, x1, y1, x2, y2)
        self.pins.setdefault(net, []).append((SHORT.get(layer, layer), r))
        if label:
            self.label(layer, *r, net)
        return r


def via1_bar(c, x1, y1, x2, y2):
    """M1+via1+M2 stack over a rectangle (via area inset by the enclosure)."""
    c.rect("m1", x1, y1, x2, y2); c.rect("m2", x1, y1, x2, y2)
    c.rect("v1", x1 + V1_ENC, y1 + V1_ENC, x2 - V1_ENC, y2 - V1_ENC)


def via_stack(c, lo, hi, x1, y1, x2, y2):
    """Vias from metal ``lo`` to metal ``hi`` (1..5) filling a rectangle."""
    for m in range(lo, hi):
        c.rect("m%d" % m, x1, y1, x2, y2); c.rect("m%d" % (m + 1), x1, y1, x2, y2)
        e = V1_ENC if m == 1 else V2_ENC
        c.rect("v%d" % m, x1 + e, y1 + e, x2 - e, y2 - e)


# ---------------------------------------------------------------- guard ring
def guard_ring(c, typ, x1, y1, x2, y2, net, outer=False):
    """Substrate (typ='n' device -> p+ ring) or well (typ='p' -> n+ ring) ring around the
    inner rectangle.  Returns the outer rectangle (including well enclosure).
    outer=True: second (n-well) ring outside an NMOS p+ ring -- the well is drawn as an
    annulus, only the top bar is a pin and the ring is recorded as c.ring2."""
    sd, sc = ("psd", "psc") if typ == "n" else ("nsd", "nsc")
    W = RING_W
    ox1, oy1, ox2, oy2 = x1 - W, y1 - W, x2 + W, y2 + W
    for r in ((ox1, oy1, ox2, y1), (ox1, y2, ox2, oy2), (ox1, y1, x1, y2), (x2, y1, ox2, y2)):
        c.rect(sd, *r)
    e = (W - RING_CT) // 2
    # contact strips: full length on left/right, shortened on top/bottom (CO spacing at corners)
    cl = (ox1 + e, oy1 + e + M1_END, ox1 + e + RING_CT, oy2 - e - M1_END)
    cr = (ox2 - e - RING_CT, oy1 + e + M1_END, ox2 - e, oy2 - e - M1_END)
    ct = (ox1 + e + RING_CT + 300, oy2 - e - RING_CT, ox2 - e - RING_CT - 300, oy2 - e)
    cb = (ox1 + e + RING_CT + 300, oy1 + e, ox2 - e - RING_CT - 300, oy1 + e + RING_CT)
    for r in (cl, cr, ct, cb):
        c.rect(sc, *r)
    # M1 ring over the contacts
    for r in ((ox1 + e, oy1 + e, ox2 - e, oy1 + e + RING_CT), (ox1 + e, oy2 - e - RING_CT, ox2 - e, oy2 - e),
              (ox1 + e, oy1 + e, ox1 + e + RING_CT, oy2 - e), (ox2 - e - RING_CT, oy1 + e, ox2 - e, oy2 - e)):
        c.rect("m1", *r)
    wx1, wy1, wx2, wy2 = ox1 - WELL_ENC, oy1 - WELL_ENC, ox2 + WELL_ENC, oy2 + WELL_ENC
    if outer:
        # annulus >= 0.86 um wide (NW.1a): 200 nm enclosure on both sides of the n+ ring
        wx1, wy1, wx2, wy2 = ox1 - 200, oy1 - 200, ox2 + 200, oy2 + 200
        ix1, iy1, ix2, iy2 = x1 + 200, y1 + 200, x2 - 200, y2 - 200
        for r in ((wx1, wy1, wx2, iy1), (wx1, iy2, wx2, wy2), (wx1, iy1, ix1, iy2), (ix2, iy1, wx2, iy2)):
            c.rect("nwell", *r)
        via1_bar(c, ox1 + e, oy1 + e, ox2 - e, oy1 + e + RING_CT)
        top = (snap(ox1 + e), snap(oy2 - e - RING_CT), snap(ox2 - e), snap(oy2 - e))
        via1_bar(c, *top)
        c.pins.setdefault(net, []).append(("metal2", top))
        c.label("m2", *top, net)
        c.ring2 = dict(net=net, top=top)
        return (wx1, wy1, wx2, wy2)
    c.rect("pwell" if typ == "n" else "nwell", wx1, wy1, wx2, wy2)
    # ring pin: M2 strap along the bottom edge (via1 array)
    via1_bar(c, ox1 + e, oy1 + e - 0, ox2 - e, oy1 + e + RING_CT)
    c.pins.setdefault(net, []).append(("metal2", (snap(ox1 + e), snap(oy1 + e), snap(ox2 - e), snap(oy1 + e + RING_CT))))
    c.pins[net].append(("metal2", (snap(ox1 + e), snap(oy2 - e - RING_CT), snap(ox2 - e), snap(oy2 - e))))
    via1_bar(c, ox1 + e, oy2 - e - RING_CT, ox2 - e, oy2 - e)
    c.label("m2", ox1 + e, oy1 + e, ox2 - e, oy1 + e + RING_CT, net)
    c.ring = dict(net=net, bot=(snap(ox1 + e), snap(oy1 + e), snap(ox2 - e), snap(oy1 + e + RING_CT)),
                  top=(snap(ox1 + e), snap(oy2 - e - RING_CT), snap(ox2 - e), snap(oy2 - e)))
    return (wx1, wy1, wx2, wy2)


# ---------------------------------------------------------------- MOS rows
GRID = 700        # routing grid pitch: pin bars are centred on multiples of it


def _up(v):
    return -(-v // GRID) * GRID


def mos_rows(name, typ, L, Wf, rows, bulk, ring=True):
    """Generate one or more stacked MOS rows inside one guard ring.

    rows: list of rows; a row is a list of islands (or a single island dict).  An island
    is one continuous diffusion:
        strips: nets of the nf+1 S/D strips;  gates: gate net of each of the nf fingers
        top / bot: gate net strapped above / below the island
    Islands in a row are separated by one dummy poly line; dummy poly also ends each row.
    S/D strips whose net equals ``bulk`` are tied to the guard ring with M2.
    """
    c = Dev(name)
    diff, ct, fet = ("ndiff", "ndc", "nmos") if typ == "n" else ("pdiff", "pdc", "pmos")
    L = snap(L); Wf = snap(Wf)
    end_s = CT_DIFF + CT + CT_POLY_GATE           # end strip width
    in_s = CT_POLY_GATE * 2 + CT                  # inner strip width
    bar_h = 380 + 2 * 65
    y0 = 0
    xmin, xmax = 0, 0
    row_h = []
    bulk_bus = []                                  # (y1, y2) of buses on the bulk net
    for row in rows:
        islands = row if isinstance(row, list) else [row]
        need_top = any(isl.get("top") in isl["gates"] for isl in islands)
        need_bot = any(isl.get("bot") in isl["gates"] for isl in islands)
        mixed = any(isl.get("top") in isl["gates"] and isl.get("bot") in isl["gates"] for isl in islands)
        bar_gap = (POLY_END + POLY_SP) if mixed else 250
        # every pin bar is centred on a routing-grid row (multiples of GRID)
        def nnets(isl):
            q = []
            for n in isl["strips"]:
                if n not in q:
                    q.append(n)
            return len(q)
        def bus_rows(yb_, nb):
            """aligned bus centres (and bar height) over the diffusion, or None"""
            r2 = list(range(_up(yb_ + 570), yb_ + Wf - 570 + 1, GRID))
            if len(r2) >= 2 * nb - 1:
                k0 = (len(r2) - (2 * nb - 1)) // 2
                return [r2[k0 + 2 * k] for k in range(nb)], 1120
            r1 = list(range(_up(yb_ + 220), yb_ + Wf - 220 + 1, GRID))
            if len(r1) >= nb:
                k0 = (len(r1) - nb) // 2
                return r1[k0:k0 + nb], 420
            return None
        if need_bot:
            yb = _up(y0 + 255) - 255 + bar_h + bar_gap
        else:
            yb = y0 + POLY_END
        nar = max([nnets(isl) for isl in islands if bus_rows(yb, nnets(isl)) is None] or [0])
        nar_rows = []
        if nar:
            assert not need_bot, (name, "narrow device with a bottom gate strap")
            r0 = _up(y0 + 310)
            nar_rows = [r0 + k * GRID for k in range(nar)]
            yb = nar_rows[-1] + 210 + POLY_END + 100
        yt = yb + Wf
        x = 0
        polys = [(-DUM_OFF - L, -DUM_OFF)]       # dummy poly x ranges
        for ii, isl in enumerate(islands):
            strips, gates = isl["strips"], isl["gates"]
            nf = len(gates)
            assert len(strips) == nf + 1, name
            top, bot = isl.get("top"), isl.get("bot")
            for gn in gates:
                assert gn in (top, bot), (name, gn, top, bot)
            x0i = x
            gx = []
            x = x0i + end_s
            for f in range(nf):
                gx.append(x); x += L
                x += in_s if f < nf - 1 else end_s
            xe = x
            c.rect(diff, x0i, yb, xe, yt)
            for f in range(nf):
                c.rect(fet, gx[f], yb, gx[f] + L, yt)
            cx = []
            for sI in range(nf + 1):
                if sI == 0:
                    c1 = x0i + CT_DIFF
                elif sI == nf:
                    c1 = xe - CT_DIFF - CT
                else:
                    c1 = gx[sI - 1] + L + CT_POLY_GATE
                cx.append(c1)
                c.rect(ct, c1, yb + CT_DIFF, c1 + CT, yt - CT_DIFF)
                c.rect("m1", c1, yb + CT_DIFF - M1_END, c1 + CT, yt - CT_DIFF + M1_END)
            nets = []
            for n in strips:
                if n not in nets:
                    nets.append(n)
            nb = len(nets)
            br = bus_rows(yb, nb)
            narrow = br is None
            if narrow:
                centres, hb = nar_rows[:nb], 420
            else:
                centres, hb = br
            for k, n in enumerate(nets):
                by1 = centres[k] - hb // 2; by2 = by1 + hb
                if narrow:
                    for q in range(nf + 1):
                        if strips[q] == n:
                            m_ = cx[q] + CT // 2
                            c.rect("m1", m_ - CT // 2, by1, m_ + CT // 2, yb + CT_DIFF)
                sx = [cx[q] for q in range(nf + 1) if strips[q] == n]
                bx1 = min(sx) + CT // 2 - 190; bx2 = max(sx) + CT // 2 + 190
                if n == bulk:
                    bulk_bus.append((by1, by2, bx1, bx2))
                else:
                    c.pin(n, "m2", bx1, by1, bx2, by2)
                for q in range(nf + 1):
                    if strips[q] == n:
                        m = cx[q] + CT // 2
                        c.rect("m1", m - 190, by1, m + 190, by2)
                        c.rect("v1", m - 130, by1 + V1_ENC, m + 130, by2 - V1_ENC)
            for side, net in (("top", top), ("bot", bot)):
                if net is None or net not in gates:
                    continue
                fs = [f for f in range(nf) if gates[f] == net]
                bx1 = gx[fs[0]] - 100; bx2 = gx[fs[-1]] + L + 100
                if bx2 - bx1 < 900:
                    m = (bx1 + bx2) // 2; bx1, bx2 = m - 450, m + 450
                if side == "top":
                    py1 = _up(yt + bar_gap + 255) - 255; py2 = py1 + bar_h
                    for f in fs:
                        c.rect("poly", gx[f], yt, gx[f] + L, py1)
                else:
                    py2 = yb - bar_gap; py1 = py2 - bar_h
                    for f in fs:
                        c.rect("poly", gx[f], py2, gx[f] + L, yb)
                c.rect("poly", bx1, py1, bx2, py2)
                c.rect("pc", bx1 + 65, py1 + 65, bx2 - 65, py2 - 65)
                c.rect("m1", bx1 + 65 - M1_END, py1 + 65, bx2 - 65 + M1_END, py2 - 65)
                c.rect("v1", bx1 + 65 + 60, py1 + 65 + 60, bx2 - 65 - 60, py2 - 65 - 60)
                c.pin(net, "m2", bx1 + 65, py1 + 65, bx2 - 65, py2 - 65)
            for f in range(nf):
                if not (gates[f] == top and need_top and top in gates):
                    c.rect("poly", gx[f], yt, gx[f] + L, yt + POLY_END)
                if not (gates[f] == bot and need_bot and bot in gates):
                    c.rect("poly", gx[f], yb - POLY_END, gx[f] + L, yb)
            # separating dummy poly / end dummy
            polys.append((xe + DUM_OFF, xe + DUM_OFF + L))
            x = xe + 2 * DUM_OFF + L
        for (p1, p2) in polys:
            c.rect("poly", p1, yb - POLY_END, p2, yt + POLY_END)
        xmin = min(xmin, polys[0][0]); xmax = max(xmax, polys[-1][1])
        ytop = (_up(yt + bar_gap + 255) - 255 + bar_h) if need_top else yt + POLY_END
        row_h.append((y0, ytop))
        y0 = ytop + POLY_SP + 60
    if ring:
        ix1 = xmin - 300; ix2 = xmax + 300
        iy1 = -300; iy2 = row_h[-1][1] + 300
        c.outline = guard_ring(c, typ, ix1, iy1, ix2, iy2, bulk)
        if typ == "n" and RING2:
            # double guard ring: n-well ring (to VDD) outside the p+ ring
            g = RING2_GAP + WELL_ENC
            b = c.outline
            c.outline = guard_ring(c, "p", b[0] - g, b[1] - g, b[2] + g, b[3] + g, RING2, outer=True)
        # bulk-net buses -> ring (M2 to M1 ring sides through via1 bars on the sides)
        e = (RING_W - RING_CT) // 2
        lx = ix1 - RING_W + e; rx = ix2 + e
        c.bulk_bars = [(bx1, by1, bx2, by2) for (by1, by2, bx1, bx2) in bulk_bus]
        for (by1, by2, bx1, bx2) in bulk_bus:
            c.rect("m2", lx, by1, rx + RING_CT, by2)
            for xx in (lx, rx):
                c.rect("v1", xx + 65, by1 + V1_ENC, xx + RING_CT - 65, by2 - V1_ENC)
    else:
        c.outline = (xmin, 0, xmax, row_h[-1][1])
        for (by1, by2, bx1, bx2) in bulk_bus:
            c.pin(bulk, "m2", bx1, by1, bx2, by2)
    return c


# ---------------------------------------------------------------- resistors
def res_array(name, W, chains, bulk="VSS", ring=True):
    """Unit hires segments of width W side by side (vertical bodies, bottoms aligned).

    chains: list of dicts  a, b: terminal nets;  n: number of equal series segments;
            L: segment body length (nm);  slots: optional slot index of each segment
            (interdigitation of matched chains).  Unused slots become no device.
    Series connections alternate top / bottom M1 jumpers between the segment heads.
    """
    c = Dev(name)
    W = snap(W)
    pitch = -(-(W + R_GAP) // GRID) * GRID
    slots = {}
    nslot = 0
    for ci, ch in enumerate(chains):
        order = ch.get("slots") or list(range(nslot, nslot + ch["n"]))
        assert len(order) == ch["n"], name
        nslot = max(nslot, max(order) + 1)
        for k, sl in enumerate(order):
            assert sl not in slots, (name, sl)
            slots[sl] = (ci, k)
    Lmax = max(snap(ch["L"]) for ch in chains)
    yb = R_PC_OFF + 115                  # bottom pad centre on y = 0 (a grid row)
    pc_h = 230
    # heavy (high-current) chains: tall M1 / M2 pads with two rows of via1 and via2 (the poly
    # contacts stay one row: HRES.7 fixes their distance to the resistor body)
    head = R_HEAD
    assert all(ch["n"] == 1 for ch in chains if ch.get("heavy")), name
    heads = {}
    for sl, (ci, k) in slots.items():
        Lu = snap(chains[ci]["L"])
        yt = yb + Lu
        x1 = sl * pitch - W // 2; x2 = x1 + W
        c.rect("hires", x1, yb, x2, yt)
        c.rect("poly", x1, yt, x2, yt + head)
        c.rect("poly", x1, yb - head, x2, yb)
        tp = (x1 + 65, yt + R_PC_OFF, x2 - 65, yt + R_PC_OFF + pc_h)
        bp = (x1 + 65, yb - R_PC_OFF - pc_h, x2 - 65, yb - R_PC_OFF)
        c.rect("pc", *tp); c.rect("pc", *bp)
        c.rect("m1", tp[0] - M1_END, tp[1], tp[2] + M1_END, tp[3])
        c.rect("m1", bp[0] - M1_END, bp[1], bp[2] + M1_END, bp[3])
        heads[sl] = (tp, bp)
    # interleaved chains cross each other: their jumpers leave the heads on separate
    # layers (even chain: M1 track, odd chain: M2 track) outside the head region
    inter = [ci for ci, ch in enumerate(chains) if ch.get("slots")]
    style = {}
    for q, ci in enumerate(inter):
        style[ci] = "m1" if q % 2 == 0 else "m2"
    for ci, ch in enumerate(chains):
        n = ch["n"]
        heavy = ch.get("heavy")
        seq = sorted([sl for sl, v in slots.items() if v[0] == ci], key=lambda sl: slots[sl][1])
        st = style.get(ci, "head")
        side = "b"
        for k, sl in enumerate(seq):
            tp, bp = heads[sl]
            inn = bp if side == "b" else tp
            out = tp if side == "b" else bp
            if k == 0:
                _res_pin(c, ch["a"], inn, heavy and (-1 if side == "b" else 1))
            if k < n - 1:
                tp2, bp2 = heads[seq[k + 1]]
                o2 = tp2 if side == "b" else bp2
                if out[1] != o2[1]:
                    raise ValueError("%s: jumper between unequal segments" % name)
                if st == "head":
                    c.rect("m1", min(out[0], o2[0]) - M1_END, out[1], max(out[2], o2[2]) + M1_END, out[3])
                else:
                    up = side == "b"           # jumper on the top heads
                    ty = out[3] + (R_HEAD - R_PC_OFF - 230) + 400 if up else out[1] - (R_HEAD - R_PC_OFF - 230) - 400
                    ty1, ty2 = (ty, ty + 300) if up else (ty - 300, ty)
                    for hd in (out, o2):
                        xc = (hd[0] + hd[2]) // 2
                        if st == "m1":
                            c.rect("m1", xc - 150, min(hd[1], ty1), xc + 150, max(hd[3], ty2))
                        else:
                            yc = (hd[1] + hd[3]) // 2
                            c.rect("m1", xc - 190, yc - 190, xc + 190, yc + 190)
                            c.rect("v1", xc - 130, yc - 130, xc + 130, yc + 130)
                            c.rect("m2", xc - 190, yc - 190, xc + 190, yc + 190)
                            c.rect("m2", xc - 150, min(yc, ty1), xc + 150, max(yc, ty2))
                    x1 = (out[0] + out[2]) // 2; x2 = (o2[0] + o2[2]) // 2
                    c.rect(st, min(x1, x2) - 150, ty1, max(x1, x2) + 150, ty2)
                side = "t" if side == "b" else "b"
            else:
                _res_pin(c, ch["b"], out, heavy and (1 if side == "b" else -1))
    xe = (nslot - 1) * pitch + W - W // 2
    if ring:
        ix1, iy1 = -W // 2 - R_RING, yb - head - 1500
        ix2, iy2 = xe + R_RING, yb + Lmax + head + 1500
        c.outline = guard_ring(c, "n", ix1, iy1, ix2, iy2, bulk)
    else:
        c.outline = (-W // 2, yb - head - 500, xe, yb + Lmax + head + 500)
    return c


def _res_pin(c, net, r, tall=0):
    """M2 pin pad (via1) centred on a resistor head contact, kept inside the head
    (tall = +1 / -1: 1.1 um high pad growing up / down from the contact strip -> two rows of
    via1 / via2)."""
    px1, px2 = r[0] - M1_END, r[2] + M1_END
    if px2 - px1 < 380:
        m = (px1 + px2) // 2; px1, px2 = m - 190, m + 190
    yc = (r[1] + r[3]) // 2
    py1, py2 = yc - 190, yc + 190
    if tall:
        py1, py2 = (r[1], r[1] + 1100) if tall > 0 else (r[3] - 1100, r[3])
    c.rect("m1", px1, py1, px2, py2)
    c.rect("v1", px1 + 60, py1 + 60, px2 - 60, py2 - 60)
    c.pin(net, "m2", px1, py1, px2, py2)


# ---------------------------------------------------------------- MIM capacitors
def mim_array(name, nx, ny, top, bot, n=None):
    """nx x ny unit (5x5 um) MIM caps on M4 bottom plates.

    Top plates are joined by M5 straps (one per column) to an M5 bus above the array,
    brought down to an M3 pin bar (via4 -> M4 island -> via3).  The bottom plate is
    brought down to an M3 pin bar below the array via a via3 array in a plate extension.
    A plate carries at most MIM_PLATE_MAX units (MIMTM.11: <= 10000 um^2 of MIM on one shared
    bottom plate); bigger arrays get one plate per group of columns, joined by the M3 bar.
    """
    c = Dev(name)
    if n is None:
        n = nx * ny
    ny = -(-n // nx)
    p = CAP_U + CAP_GAP
    gcols = nx if n <= MIM_PLATE_MAX else max(1, MIM_PLATE_MAX // ny)
    ex = MIM_PLATE_SP + 2 * CAP_BENC - CAP_GAP          # extra column gap between plates
    colx = [i * p + (i // gcols) * ex for i in range(nx)]
    W = colx[-1] + CAP_U; H = ny * p - CAP_GAP
    # bottom plates (with a 1.2 um extension at the bottom for the via3 array)
    ext = 1200
    yb1 = -CAP_BENC - ext + 100
    for g in range(0, nx, gcols):
        gx1, gx2 = colx[g], colx[min(g + gcols, nx) - 1] + CAP_U
        c.rect("m4", gx1 - CAP_BENC, -CAP_BENC - ext, gx2 + CAP_BENC, H + CAP_BENC)
        via_stack(c, 3, 4, gx1, yb1, gx2, yb1 + 900)
    for q in range(n):
        i, j = q % nx, q // nx
        x1, y1 = colx[i], j * p
        c.rect("mimcap", x1, y1, x1 + CAP_U, y1 + CAP_U)
        c.rect("mimcc", x1 + CAP_CC, y1 + CAP_CC, x1 + CAP_U - CAP_CC, y1 + CAP_U - CAP_CC)
    # top-plate M5 straps per column, bus above
    for i in range(nx):
        x1 = colx[i] + CAP_CC
        c.rect("m5", x1, CAP_CC, x1 + CAP_U - 2 * CAP_CC, H + CAP_BENC + 1800)
    ytb = H + CAP_BENC + 1300          # M4 island: >=1.2 um from mimcap, >=0.3 from plate
    c.rect("m5", 0, ytb, W, ytb + 1000)
    via_stack(c, 3, 5, 0, ytb, W, ytb + 1000)
    # M3 pin bars are 1.6 um tall so that a routing row always lies inside them
    c.rect("m3", 0, ytb, W, ytb + 1600)
    c.pin(top, "m3", 0, ytb, W, ytb + 1600)
    # bottom plate(s) -> M3
    c.rect("m3", 0, yb1 - 700, W, yb1 + 900)
    c.pin(bot, "m3", 0, yb1 - 700, W, yb1 + 900)
    c.outline = (-CAP_BENC, yb1 - 700, W + CAP_BENC, ytb + 1600)
    return c


# ---------------------------------------------------------------- merged MIM plates (quarter slot)
MIM_PLATE_UM2 = 9500.0   # one top plate per bottom plate, < 10000 um^2 (MIMTM.11)
MIM_STRAP_P = 5800       # M5 strap pitch over a plate (straps <= 4.2 um: no wide-metal slotting)


def mim_plates(name, k, pw, ph, top, bot):
    """``k`` solid pw x ph (nm) MIM plates in one row, each on its own M4 bottom plate (the
    unit array of mim_array without the 0.8 um gaps between 5 um units).  Top plates: M5 straps
    over mimcc strips to an M5 bus above, down to an M3 pin bar; bottom plates: via3 array in a
    1.2 um extension down to an M3 pin bar below (same pins as mim_array)."""
    c = Dev(name)
    step = pw + 2 * CAP_BENC + MIM_PLATE_SP
    W = (k - 1) * step + pw
    ext = 1200
    yb1 = -CAP_BENC - ext + 100
    for i in range(k):
        x = i * step
        c.rect("m4", x - CAP_BENC, -CAP_BENC - ext, x + pw + CAP_BENC, ph + CAP_BENC)
        via_stack(c, 3, 4, x, yb1, x + pw, yb1 + 900)
        c.rect("mimcap", x, 0, x + pw, ph)
        ns = max(1, (pw - 2 * CAP_CC + CAP_GAP) // MIM_STRAP_P)
        sw = snap(min(CAP_U - 2 * CAP_CC, (pw - 2 * CAP_CC) // ns - 200))
        pitch = (pw - 2 * CAP_CC - sw) // max(1, ns - 1) if ns > 1 else 0
        for j in range(ns):
            sx = snap(x + CAP_CC + j * pitch)
            c.rect("mimcc", sx, CAP_CC, sx + sw, ph - CAP_CC)
            c.rect("m5", sx, CAP_CC, sx + sw, ph + CAP_BENC + 1800)
    ytb = ph + CAP_BENC + 1300
    c.rect("m5", 0, ytb, W, ytb + 1000)
    via_stack(c, 3, 5, 0, ytb, W, ytb + 1000)
    c.rect("m3", 0, ytb, W, ytb + 1600)
    c.pin(top, "m3", 0, ytb, W, ytb + 1600)
    c.rect("m3", 0, yb1 - 700, W, yb1 + 900)
    c.pin(bot, "m3", 0, yb1 - 700, W, yb1 + 900)
    c.outline = (-CAP_BENC, yb1 - 700, W + CAP_BENC, ytb + 1600)
    return c
