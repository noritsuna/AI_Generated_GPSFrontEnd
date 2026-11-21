"""Module = one schematic cell laid out as one magic cell (devices/sub-modules + routing)."""
import os
from mag import Cell, snap, xform, SHORT
from devices import Dev
from router import Grid, Router, P, LAYERS

ROUTE_LAYERS = ("metal2", "metal3", "metal4")


def tx_rect(o, x, y, r):
    p1 = xform(o, r[0], r[1]); p2 = xform(o, r[2], r[3])
    return (min(p1[0], p2[0]) + x, min(p1[1], p2[1]) + y, max(p1[0], p2[0]) + x, max(p1[1], p2[1]) + y)


RAIL_H = 3000      # M4 supply rail height
RAIL_GAP = 1500    # rail to device outline
SPINE_W = 3000     # M3 supply spine width
CHAN = 5000        # routing channel between rows


class Module(Dev):
    def __init__(self, name, ports):
        super().__init__(name)
        self.supply_pins = []         # (net, layer, rect) of rails/spines: one terminal per net
        self.ports = ports            # list of (net, side) side in N S E W
        self.placed = []              # (dev, inst, x, y, orient, netmap)
        self.width_of = {}
        self.extra_obs = []
        self.extra_own = []
        self.tapped = set()

    def place(self, dev, inst, x, y, orient="N", netmap=None):
        """Place ``dev`` so that its outline lower-left lands on (x, y)."""
        b = dev.outline if hasattr(dev, "outline") else dev.bbox()
        bb = tx_rect(orient, 0, 0, b)
        # device origin on the routing grid so that its pin bars sit on grid rows
        ox, oy = -(-(x - bb[0]) // P) * P, -(-(y - bb[1]) // P) * P
        self.use(dev, inst, ox, oy, orient)
        self.placed.append((dev, inst, ox, oy, orient, netmap or {}))
        return tx_rect(orient, ox, oy, b)

    def floor(self, rows, gap=4000, chan=CHAN, vdd="VDD", vss="VSS", x0=None, top_rails=(), center=False, side=2000,
              row_vdd=None):
        """Row floorplan.  rows: bottom-to-top list of rows; a row is a list of
        (dev, inst[, orient[, netmap]]).  Each row gets a VSS rail below and a VDD rail
        above (M4); guard rings are tapped to them with M3 straps; M3 spines on the left
        (VSS) and right (VDD) edges join all rails."""
        # side: clearance between the supply spines and the devices (room for edge pins)
        # row_vdd: {row index: net} for a row on its own supply (rail above it; the VDD spine skips it)
        row_vdd = row_vdd or {}
        x0 = SPINE_W + side if x0 is None else x0
        # gap / chan may be per-row lists (chan[k]: channel above row k)
        gaps = gap if isinstance(gap, (list, tuple)) else [gap] * len(rows)
        chans = chan if isinstance(chan, (list, tuple)) else [chan] * len(rows)
        self.row_spans = []           # (y bottom of VSS rail, y top of VDD rail) per row
        y = 0
        rails = []
        placed_rows = []
        # a number in a row is a blank of that width (column alignment)
        wid = lambda it, gap: it if isinstance(it, (int, float)) else it[0].outline[2] - it[0].outline[0] + gap
        rw = [sum(wid(it, gp) for it in row) - gp for row, gp in zip(rows, gaps)]
        for kr, (row, w, gap, chan) in enumerate(zip(rows, rw, gaps, chans)):
            yr = y                                  # VSS rail
            yd = yr + RAIL_H + RAIL_GAP
            x = x0 + (snap((max(rw) - w) // 2) if center else 0)
            top = yd
            pr = []
            for it in row:
                if isinstance(it, (int, float)):
                    x += it
                    continue
                dev, inst = it[0], it[1]
                orient = it[2] if len(it) > 2 else "N"
                nmap = it[3] if len(it) > 3 else None
                r = self.place(dev, inst, x, yd, orient, nmap)
                pr.append(len(self.placed) - 1)
                x = r[2] + gap
                top = max(top, r[3])
            yv = top + RAIL_GAP                     # VDD rail
            rails.append((vss, yr)); rails.append((row_vdd.get(kr, vdd), yv))
            placed_rows.append((pr, yr, yv, row_vdd.get(kr, vdd)))
            self.row_spans.append((yr, yv + RAIL_H))
            y = yv + RAIL_H + chan
        # extra supply rails above the last row (landing bars for supply straps)
        ytr = rails[-1][1] + RAIL_H + RAIL_GAP
        for net in top_rails:
            rails.append((net, ytr)); ytr += RAIL_H + RAIL_GAP
        xr = max(self.outline_of(k)[2] for k in range(len(self.placed))) + side
        xl = x0 - side - SPINE_W
        self.xspan = (xl, xr + SPINE_W)
        self.dev_x = (x0, xr - side)        # device span
        for net, yy in rails:
            if net is None:
                continue
            r = (xl, yy, xr + SPINE_W, yy + RAIL_H)
            self.rect("m4", *r)
            self.supply_pins.append((net, "metal4", r))
        ytop = rails[-1][1] + RAIL_H
        self.spines = []
        for net, xx in ((vss, xl), (vdd, xr)):
            if net is None:
                continue
            r = (xx, rails[0][1], xx + SPINE_W, ytop)
            self.rect("m3", *r)
            self.supply_pins.append((net, "metal3", r))
            self.spines.append((net, r))
            for n2, yy in rails:
                if n2 == net:
                    self.rect("v3", xx + 100, yy + 100, xx + SPINE_W - 100, yy + RAIL_H - 100)
            self.label("m3", *r, net)
        # taps: ring bar -> rail (M3 straps every ~8 um)
        self.tapped = set()
        for pr, yr, yv, vdd in placed_rows:
            for k in pr:
              dev, inst, x, yy, o, nm = self.placed[k]
              rings = [(q, getattr(dev, q, None)) for q in ("ring", "ring2")]
              rbars = [rg.get(sd) for q, rg in rings if rg for sd in ("bot", "top")]
              for rk, ring in rings:
                if not ring or o != "N":
                    continue
                net = nm.get(ring["net"], ring["net"])
                if net == vss and "bot" in ring:
                    bar = tx_rect(o, x, yy, ring["bot"]); ry1, ry2 = yr, yr + RAIL_H
                elif net == vdd:
                    bar = tx_rect(o, x, yy, ring["top"]); ry1, ry2 = yv, yv + RAIL_H
                else:
                    continue
                self.tapped.add((k, ("bot" if net == vss else "top") + ("2" if rk == "ring2" else "")))
                # strap positions: both bar ends + every ~8 um, keeping clear of the
                # device's own pin columns (so the pins stay reachable from M3)
                pcols = [tx_rect(o, x, yy, r) for nn, lst in dev.pins.items() for (l, r) in lst
                         if r not in rbars]
                def clear(cx):
                    return all(cx + 500 + 1500 <= p[0] or cx - 500 - 1500 >= p[2] for p in pcols)
                cxs = [bar[0] + 500, bar[2] - 500]
                q = bar[0] + 8500
                while q < bar[2] - 8500:
                    for dq in range(0, 4000, 350):
                        if clear(q + dq):
                            cxs.append(q + dq); break
                    q += 8000
                for cx in sorted(set(cxs)):
                    sx1, sx2 = cx - 500, cx + 500
                    y1, y2 = min(bar[1], ry1), max(bar[3], ry2)
                    self.rect("m3", sx1, y1, sx2, y2)
                    self.rect("v2", sx1 + 100, bar[1] + 55, sx2 - 100, bar[3] - 55)
                    self.rect("m2", sx1, bar[1], sx2, bar[3])
                    self.rect("v3", sx1 + 100, ry1 + 100, sx2 - 100, ry2 - 100)
                    self.extra_own.append((net, "metal3", (snap(sx1), snap(y1), snap(sx2), snap(y2))))
            # sub-module supply spines -> parent rails
            for k in pr:
                dev, inst, x, yy, o, nm = self.placed[k]
                for snet, sr in getattr(dev, "spines", []):
                    net = nm.get(snet, snet)
                    r = tx_rect(o, x, yy, sr)
                    if net == vss:
                        e = (r[0], yr, r[2], r[1] + 1000)
                        self.rect("v3", r[0] + 100, yr + 100, r[2] - 100, yr + RAIL_H - 100)
                    elif net == vdd:
                        e = (r[0], r[3] - 1000, r[2], yv + RAIL_H)
                        self.rect("v3", r[0] + 100, yv + 100, r[2] - 100, yv + RAIL_H - 100)
                    else:
                        continue
                    self.rect("m3", *e)
                    self.extra_own.append((net, "metal3", tuple(snap(v) for v in e)))
                    self.tapped.add((k, "spine:" + snet))
            # bulk-net buses inside the device: M3 straps straight to the rail
            for k in pr:
                dev, inst, x, yy, o, nm = self.placed[k]
                ring = getattr(dev, "ring", None)
                if not ring or o != "N" or not getattr(dev, "bulk_bars", None):
                    continue
                net = nm.get(ring["net"], ring["net"])
                if net not in (vss, vdd):
                    continue
                ry1, ry2 = (yr, yr + RAIL_H) if net == vss else (yv, yv + RAIL_H)
                for bb in dev.bulk_bars:
                    bar = tx_rect(o, x, yy, bb)
                    if bar[2] - bar[0] < 6000:
                        continue          # small device: the guard-ring path is enough
                    n = max(1, (bar[2] - bar[0]) // 6000)
                    for q in range(n):
                        cx = bar[0] + 500 + (bar[2] - bar[0] - 1000) * (q + 0.5) / n
                        sx1, sx2 = cx - 500, cx + 500
                        y1, y2 = min(bar[1], ry1), max(bar[3], ry2)
                        self.rect("m3", sx1, y1, sx2, y2)
                        self.rect("v2", sx1 + 100, bar[1] + 55, sx2 - 100, bar[3] - 55)
                        self.rect("v3", sx1 + 100, ry1 + 100, sx2 - 100, ry2 - 100)
                        self.extra_own.append((net, "metal3", (snap(sx1), snap(y1), snap(sx2), snap(y2))))
        return placed_rows

    def outline_of(self, k):
        dev, inst, x, y, o, nm = self.placed[k]
        return tx_rect(o, x, y, dev.outline if hasattr(dev, "outline") else dev.bbox())

    # ------------------------------------------------------------ routing
    def _drop_vias_on_sub_vias(self):
        """A routed via landing on a sub-module's via of the same type (a pin reached on its
        own metal) may not abut/overlap it across the hierarchy (magic DRC); the metals on
        both layers already overlap the sub's via stack, so the top-level cut is redundant."""
        G = 10000
        sub = {}
        for dev, inst, x, y, o, nm in self.placed:
            for l, r in dev.flat({"via1", "via2", "via3", "via4"}):
                rr = tx_rect(o, x, y, r)
                for gx in range(rr[0] // G, rr[2] // G + 1):
                    for gy in range(rr[1] // G, rr[3] // G + 1):
                        sub.setdefault((l, gx, gy), []).append(rr)
        for l in ("via1", "via2", "via3", "via4"):
            keep = []
            for r in self.rects.get(l, []):
                hit = any(a[0] <= r[2] and r[0] <= a[2] and a[1] <= r[3] and r[1] <= a[3]
                          for gx in range(r[0] // G, r[2] // G + 1) for gy in range(r[1] // G, r[3] // G + 1)
                          for a in sub.get((l, gx, gy), ()))
                if not hit:
                    keep.append(r)
            if l in self.rects:
                self.rects[l] = keep

    def route(self, margin=6000, iters=40, widths=None, verbose=True, order=None):
        widths = widths or {}
        bb = None
        for k in range(len(self.placed)):
            r = self.outline_of(k)
            bb = r if bb is None else (min(bb[0], r[0]), min(bb[1], r[1]), max(bb[2], r[2]), max(bb[3], r[3]))
        own = Dev.bbox(self) if self.rects else None      # rails / spines / taps
        if own:
            bb = (min(bb[0], own[0]), min(bb[1], own[1]), max(bb[2], own[2]), max(bb[3], own[3]))
        x0, y0, x1, y1 = bb[0] - margin, bb[1] - margin, bb[2] + margin, bb[3] + margin
        g = Grid(x0, y0, x1, y1)
        rt = Router(g)
        for a in ("log", "patience", "max_exp", "hweight", "sep"):
            if hasattr(self, "rt_" + a):
                setattr(rt, a, getattr(self, "rt_" + a))
        self.router = rt
        rt.width.update(widths)
        rt.strict = set(getattr(self, "strict", ()))
        # obstacles
        pins = []
        for dev, inst, x, y, o, nm in self.placed:
            pinset = {}
            kk = [q for q in range(len(self.placed)) if self.placed[q][1] == inst][0]
            skip = set()
            ring = getattr(dev, "ring", None)
            if ring and ((kk, "bot") in self.tapped or (kk, "top") in self.tapped):
                skip.add(ring["bot"]); skip.add(ring["top"])
            ring2 = getattr(dev, "ring2", None)
            if ring2 and (kk, "top2") in self.tapped:
                skip.add(ring2["top"])
            for snet, sr in getattr(dev, "spines", []):
                if (kk, "spine:" + snet) in self.tapped:
                    skip.add(sr)
            for net, lst in dev.pins.items():
                for layer, r in lst:
                    pinset[(layer, r)] = nm.get(net, net)

            netof = getattr(dev, "netof", None)
            if netof is None and dev.uses:
                # sub-module built in this run: its routed wiring to a pin is that net's metal
                import magload
                netof = dev.netof = magload._nets_of(dev)
            netof = netof or {}
            shapes = list(dev.flat(set(ROUTE_LAYERS) | {"mimcap"}))
            mims = [r for l, r in shapes if l == "mimcap"]
            for layer, r in shapes:
                rr = tx_rect(o, x, y, r)
                if layer == "mimcap":
                    g.block("metal4", rr, None, bloat=600 + 1200 + 200)
                    continue
                if layer == "metal4" and mims and r[2] - r[0] >= 5000 and r[3] - r[1] >= 5000 and any(r[0] <= m[0] and r[1] <= m[1] and m[2] <= r[2] and m[3] <= r[3] for m in mims):
                    # MIM bottom plate (incl. its pin bar): 1.2 um to unrelated metal (MIMTM.1)
                    g.block("metal4", rr, None, bloat=1200 + 190 + 110)
                    continue
                net = pinset.get((layer, r))
                if net is None:
                    # geometry fully inside a pin shape of the same layer belongs to it
                    for (pl, pr), pn in pinset.items():
                        if pl == layer and pr[0] <= r[0] and pr[1] <= r[1] and r[2] <= pr[2] and r[3] <= pr[3]:
                            net = pn
                            break
                if net is None and (layer, r) in netof:
                    # wiring of a re-loaded sub-module that is connected to one of its pins
                    g.block(layer, rr, nm.get(netof[(layer, r)], netof[(layer, r)]))
                    continue
                if net is None:
                    g.block(layer, rr, None)
            for (layer, r), net in pinset.items():
                if layer in ROUTE_LAYERS:
                    if r in skip:
                        g.block(layer, tx_rect(o, x, y, r), net)
                        continue
                    pins.append((net, layer, tx_rect(o, x, y, r)))
        for layer, r in self.extra_obs:
            g.block(layer, r, None)
        for net, layer, r in self.extra_own:
            g.block(layer, r, net)
        for net, layer, r in self.supply_pins:
            g.block(layer, r, net)
        supply = set(n for n, l, r in self.supply_pins)
        # top-edge M2 pins at fixed x (dx from the left outline edge): landing pads for the
        # chip-level straps from the pad ring.  Supply pins run down to the topmost M4 rail
        # of their net (via2 + via3 array); signal pins are 4 um tall bars routed as pins.
        edge = set()
        for net, xa, xb in getattr(self, "edge_pins", []):
            X1 = max(snap(x0 + xa), x0 + 1000); X2 = min(snap(x0 + xb), x1 - 1000)
            if X2 - X1 < 1000:
                continue
            if net in supply:
                rail = max((r for n, l, r in self.supply_pins if n == net and l == "metal4"), key=lambda r: r[1])
                # the via stack must sit on the rail (V3.4: via3 enclosed by metal4)
                X1 = max(X1, snap(rail[0] + 500)); X2 = min(X2, snap(rail[2] - 500))
                if X2 - X1 < 1000:
                    continue
                bar = (X1, rail[1], X2, y1)
                via = (X1, rail[1], X2, rail[3])
                self.rect("m3", *via)
                self.rect("v2", via[0] + 100, via[1] + 100, via[2] - 100, via[3] - 100)
                self.rect("v3", via[0] + 100, via[1] + 100, via[2] - 100, via[3] - 100)
                g.block("metal3", via, net)
            else:
                bar = (X1, y1 - 4000, X2, y1)
                pins.append((net, "metal2", bar))
                edge.add(net)
            self.rect("m2", *bar)
            g.block("metal2", bar, net)
            self.label("m2", bar[0], y1 - 2000, bar[2], y1, net)
            self.pins.setdefault(net, []).append(("metal2", bar))
        # ports: M3 pads on N/S edges, M4 pads on E/W edges
        self.port_pads = []
        sides = {}
        for net, side in self.ports:
            if net not in edge:
                sides.setdefault(side, []).append(net)
        for side, nets in sides.items():
            nets = [q for q in nets if q not in supply]
            n = len(nets)
            for q, net in enumerate(nets):
                if side in "NS":
                    i = int(g.nx * (q + 1) / (n + 1))
                    j = g.ny - 2 if side == "N" else 1
                    lay = "metal3"
                else:
                    j = int(g.ny * (q + 1) / (n + 1))
                    i = g.nx - 2 if side == "E" else 1
                    lay = "metal4"
                k = widths.get(net, 1)
                xc, yc = g.xc(i), g.yc(j)
                r = (xc - 500, yc - 500, xc + 500 + (k - 1) * P, yc + 500 + (k - 1) * P)
                self.port_pads.append((net, lay, r))
                pins.append((net, lay, r))
        for net, layer, r in pins:
            rt.add_pin(net, layer, r, k=widths.get(net, 1))
        for net in supply:
            rt.add_supply(net, [(l, r) for n, l, r in self.supply_pins if n == net])
        ok, fails = rt.run(iters=iters, order=order)
        if verbose:
            print("route %s: %s %s  grid %dx%d nets %d" % (self.name, "OK" if ok else "FAIL", fails, g.nx, g.ny, len(rt.terms)))
        rt.emit(self)
        self._drop_vias_on_sub_vias()
        for net, lay, r in self.port_pads:
            self.rect(lay, *r)
            self.label(lay, *r, net)
            self.pins.setdefault(net, []).append((lay, r))
        for net, r in getattr(self, "spines", []):
            self.pins.setdefault(net, []).append(("metal3", r))
        self.outline = (x0, y0, x1, y1)
        self.router = rt
        return ok
