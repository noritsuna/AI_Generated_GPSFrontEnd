"""Grid maze router (negotiated congestion) on M2 (horizontal), M3 (vertical), M4 (horizontal).

Track pitch 700 nm, wire 300 nm, via pads 380 nm -> every grid move is DRC clean by
construction (spacing >= 320 nm between neighbouring tracks/pads).  Wide nets use a
k x k block of tracks (wire width (k-1)*700+300 nm, k x k via arrays -> many vias).
"""
import heapq, os, time, collections
DBG = os.environ.get("RTDBG")
import numpy as np

P = 700
WW = 300          # wire width
PAD = 380         # via pad
LAYERS = ["metal2", "metal3", "metal4"]
HORIZ = [True, False, True]
VIA = {0: "via2", 1: "via3"}     # via between layer l and l+1
BLOAT = 280 + PAD // 2 - 5       # node blocked if its pad would be closer than 280 nm


class Grid:
    def __init__(self, x0, y0, x1, y1):
        self.x0 = (x0 // P) * P; self.y0 = (y0 // P) * P
        self.nx = (x1 - self.x0) // P + 1; self.ny = (y1 - self.y0) // P + 1
        self.own = np.zeros((3, self.nx, self.ny), dtype=np.int32)   # 0 free, -1 blocked, >0 net
        # keep-out ring around pin shapes: no wire/via may come close to a pin shape
        # without being fully inside it (avoids notches and partial overlaps)
        self.ring = np.zeros((3, self.nx, self.ny), dtype=np.int32)
        self.occ = np.zeros((3, self.nx, self.ny), dtype=np.int16)
        self.hist = np.ones((3, self.nx, self.ny), dtype=np.float32)
        self.nets = {}      # name -> id
        self.names = {}

    def nid(self, net):
        if net not in self.nets:
            self.nets[net] = len(self.nets) + 1
            self.names[self.nets[net]] = net
        return self.nets[net]

    def xc(self, i): return self.x0 + i * P
    def yc(self, j): return self.y0 + j * P

    def irange(self, a, b):
        """grid indices with centre in [a, b]"""
        i1 = max(0, -(-(a - self.x0) // P)); i2 = min(self.nx - 1, (b - self.x0) // P)
        return i1, i2

    def jrange(self, a, b):
        j1 = max(0, -(-(a - self.y0) // P)); j2 = min(self.ny - 1, (b - self.y0) // P)
        return j1, j2

    def block(self, layer, r, net=None, bloat=BLOAT):
        if layer not in LAYERS:
            return
        L = LAYERS.index(layer)
        i1, i2 = self.irange(r[0] - bloat, r[2] + bloat)
        j1, j2 = self.jrange(r[1] - bloat, r[3] + bloat)
        if i1 > i2 or j1 > j2:
            return
        sub = self.own[L, i1:i2 + 1, j1:j2 + 1]
        if net is None:
            sub[...] = -1
            return
        n = self.nid(net)
        rg = self.ring[L, i1:i2 + 1, j1:j2 + 1]
        rg[(rg != 0) & (rg != n)] = -1
        rg[rg == 0] = n
        a1, a2 = self.irange(r[0] + PAD // 2, r[2] - PAD // 2)
        b1, b2 = self.jrange(r[1] + PAD // 2, r[3] - PAD // 2)
        if a1 <= a2 and b1 <= b2:
            inn = self.own[L, a1:a2 + 1, b1:b2 + 1]
            inn[(inn != 0) & (inn != n)] = -1
            inn[inn == 0] = n


class Router:
    def __init__(self, grid, via_cost=3.0):
        self.strict = set()      # wide nets that may neck down only next to their pins
        self.g = grid
        self.via_cost = via_cost
        self.terms = {}     # net -> list of terminals; terminal = list of (L,i,j, stub)
        self.width = {}     # net -> k
        self.paths = {}     # net -> list of node lists
        self.fixed = []     # extra geometry (stubs) per net: (net, layer, rect)
        self.fp_of = {}; self.cov = {}; self.wid = {}; self.stubs_of = {}; self.fp = {}

    # ------------------------------------------------------------ terminals
    def add_pin(self, net, layer, r, k=1):
        """Register a pin rectangle; candidate access nodes are generated here."""
        g = self.g
        n = g.nid(net)
        k = max(k, self.width.get(net, 1))
        cands = []
        span = 0          # pins are always entered with a single track (wide nets neck down)
        if layer in ("metal2", "metal3", "metal4"):
            L = LAYERS.index(layer)
            yc = (r[1] + r[3]) // 2; xcn = (r[0] + r[2]) // 2
            if layer == "metal3":
                # M3 pin: nodes inside, or nearest row with an M3 stub
                i1, i2 = g.irange(r[0] + WW // 2, r[2] - WW // 2 - span)
                j1, j2 = g.jrange(r[1] + WW // 2, r[3] - WW // 2 - span)
                if j1 > j2:
                    jn = int(round((yc - g.y0) / P)); jn = min(max(jn, 0), g.ny - 1)
                    j1 = j2 = jn
                for i in range(i1, i2 + 1):
                    for j in range(j1, j2 + 1):
                        stub = None
                        y = g.yc(j)
                        if not (r[1] <= y <= r[3]):
                            yy = min(max(y, r[1] + WW // 2), r[3] - WW // 2)
                            stub = [("metal3", (g.xc(i) - WW // 2, min(y, yy) - WW // 2,
                                                g.xc(i) + span + WW // 2, max(y, yy) + WW // 2))]
                        cands.append((1, i, j, stub))
            elif layer == "metal2":
                # M2 bar: via2 inside the bar, M3 stub to the nearest row.  Only a few
                # columns get access points (their stub regions are reserved for the net)
                # so that the other M3 tracks stay free to cross over the device.
                i1, i2 = g.irange(r[0] + PAD // 2, r[2] - PAD // 2 - span)
                if i1 > i2 and span:
                    i1, i2 = g.irange(r[0] + PAD // 2, r[2] - PAD // 2)
                ext = None
                if i1 > i2:
                    # no track over the bar: extend the bar on M2 to the nearest track
                    i1 = i2 = int(round((xcn - g.x0) / P))
                    xx = g.xc(i1)
                    ext = ("metal2", (min(r[0], xx - 190), r[1], max(r[2], xx + 190), r[3]))
                    r = ext[1]
                    g.block("metal2", r, net)
                cols = list(range(i1, i2 + 1))
                jf = (yc - g.y0) / P
                jn = int(round(jf)); jn = min(max(jn, 0), g.ny - 1)
                j2nd = jn + 1 if jf > jn else jn - 1
                y = g.yc(jn)
                inside = r[1] + PAD // 2 <= y <= r[3] - PAD // 2 - span
                if not inside:
                    # keep columns whose stub region is still free; spread up to 6 of them
                    def free(i):
                        x = g.xc(i)
                        lo, hi = min(r[1], y - PAD // 2), max(r[3], y + PAD // 2)
                        j1, j2 = g.jrange(lo - BLOAT, hi + BLOAT)
                        o = g.own[1, i, j1:j2 + 1]; rg = g.ring[1, i, j1:j2 + 1]
                        return bool(np.all(((o == 0) | (o == n)) & ((rg == 0) | (rg == n))))
                    cols = [i for i in cols if free(i)] or cols
                if len(cols) > 6:
                    step = (len(cols) - 1) / 5.0
                    cols = sorted(set(cols[int(round(q * step))] for q in range(6)))
                rows_try = [jn] if inside else [jn, j2nd]
                for i, jj in [(i, jj) for jj in rows_try for i in cols]:
                    if inside:
                        cands.append((0, i, jn, [ext] if ext else None))
                        continue
                    if not (0 <= jj < g.ny):
                        continue
                    y = g.yc(jj)
                    x = g.xc(i)
                    vx2 = min(x + span + 140, r[2] - 50)
                    vh = min(280 + span, r[3] - r[1] - 100)
                    vy1 = min(max(y - 140, r[1] + 50), r[3] - 50 - vh)
                    stub = [("via2", (x - 140, vy1, vx2, vy1 + vh)),
                            ("metal2", (x - 190, vy1 - 50, vx2 + 50, vy1 + vh + 50)),
                            ("metal3", (x - 190, min(vy1 - 50, y - PAD // 2), x + span + 190,
                                        max(vy1 + vh + 50, y + span + PAD // 2)))]
                    if ext:
                        stub.append(ext)
                    cands.append((1, i, jj, stub))
            else:
                i1, i2 = g.irange(r[0] + WW // 2, r[2] - WW // 2 - span)
                j1, j2 = g.jrange(r[1] + WW // 2, r[3] - WW // 2 - span)
                for i in range(i1, i2 + 1):
                    for j in range(j1, j2 + 1):
                        cands.append((2, i, j, None))
            if r[2] - r[0] <= 2 * P and r[3] - r[1] <= 2 * P:
                # small pad (e.g. a sub-module port, whose lower layer is taken by the
                # sub-module's own wire): exits on the pad layer across the keep-out ring
                cands += self._pad_exits(n, L, r, horizontal=(layer != "metal3"))
        if not cands:
            raise ValueError("pin of %s on %s %s has no access node" % (net, layer, r))
        self.terms.setdefault(net, []).append(cands)
        # pin shapes are owned by the net (stub regions too)
        g.block(layer, r, net)

    def _pad_exits(self, n, L, r, horizontal):
        g = self.g
        i = int(round(((r[0] + r[2]) // 2 - g.x0) / P)); j = int(round(((r[1] + r[3]) // 2 - g.y0) / P))
        out = []
        for d in (-2, 2):
            ii, jj = (i + d, j) if horizontal else (i, j + d)
            if not (0 <= ii < g.nx and 0 <= jj < g.ny):
                continue
            path = [(i + d // 2, j) if horizontal else (i, j + d // 2), (ii, jj)]
            if not all(int(g.own[L, a, b]) in (0, n) and int(g.ring[L, a, b]) in (0, n) for a, b in path):
                continue
            x1, x2 = sorted((g.xc(i), g.xc(ii))); y1, y2 = sorted((g.yc(j), g.yc(jj)))
            out.append((L, ii, jj, [(LAYERS[L], (x1 - WW // 2, y1 - WW // 2, x2 + WW // 2, y2 + WW // 2))]))
        return out

    def add_supply(self, net, shapes):
        """Rails/spines of a supply net form ONE terminal (they are already connected).
        Access nodes: every few tracks along the shapes."""
        g = self.g
        n = g.nid(net)
        cands = []
        for layer, r in shapes:
            L = LAYERS.index(layer)
            i1, i2 = g.irange(r[0] + PAD // 2, r[2] - PAD // 2)
            j1, j2 = g.jrange(r[1] + PAD // 2, r[3] - PAD // 2)
            for i in range(i1, i2 + 1):
                for j in range(j1, j2 + 1):
                    cands.append((L, i, j, None))
        if self.terms.get(net):
            # put the supply terminal first so every other pin connects to it
            self.terms[net].insert(0, cands)
        else:
            self.terms[net] = [cands]

    # ------------------------------------------------------------ search
    def ok(self, n, k, L, i, j):
        g = self.g
        if i < 0 or j < 0 or i + k > g.nx or j + k > g.ny:
            return False
        if k == 1:
            o = int(g.own[L, i, j]); rg = int(g.ring[L, i, j])
            return (o == n and (rg == 0 or rg == n)) or (o == 0 and rg == 0)
        o = g.own[L, i:i + k, j:j + k]; rg = g.ring[L, i:i + k, j:j + k]
        return bool(np.all(((o == n) & ((rg == 0) | (rg == n))) | ((o == 0) & (rg == 0))))

    def vmap(self, n, k):
        """boolean map: node usable by net n with a k x k footprint (static, cached)"""
        self._vm = getattr(self, "_vm", {})
        if (n, k) in self._vm:
            return self._vm[(n, k)]
        g = self.g
        o, rg = g.own, g.ring
        v = ((o == n) & ((rg == 0) | (rg == n))) | ((o == 0) & (rg == 0))
        if k > 1:
            bad = (~v).astype(np.int32)
            sat = np.zeros((3, g.nx + 1, g.ny + 1), dtype=np.int32)
            sat[:, 1:, 1:] = bad.cumsum(1).cumsum(2)
            vk = np.zeros_like(v)
            blk = sat[:, k:, k:] - sat[:, :-k, k:] - sat[:, k:, :-k] + sat[:, :-k, :-k]
            vk[:, :g.nx - k + 1, :g.ny - k + 1] = blk == 0
            v = vk
        self._vm[(n, k)] = v
        return v

    def sep_map(self, net):
        """extra step cost for an aggressor net (self.sep: net -> (victims, tracks, cost)) on
        and next to the victims' current routes: same layer within <tracks> grid steps, and
        the layers above / below the victim tracks (keeps a clock away from sensitive lines)"""
        sp = getattr(self, "sep", {}).get(net)
        if not sp:
            return None
        victims, d, pen = sp
        g = self.g
        m = np.zeros((3, g.nx, g.ny), dtype=bool)
        for v in victims:
            for (L, i, j) in getattr(self, "cov", {}).get(v, ()):
                m[L, i, j] = True
        if not m.any():
            return None
        dm = m.copy()
        for di in range(-d, d + 1):
            for dj in range(-d, d + 1):
                if di or dj:
                    dm |= np.roll(np.roll(m, di, 1), dj, 2)
        out = dm.copy()
        out[1:] |= m[:-1]; out[:-1] |= m[1:]
        return out.astype(np.float32) * pen

    def route_net(self, net, pres):
        g = self.g
        n = g.nid(net); k = self.width.get(net, 1)
        terms = self.terms[net]
        if len(terms) < 2:
            self.paths[net] = []
            self.wid = getattr(self, "wid", {})
            self.wid[net] = {}
            return True
        # valid-cache for this net
        cache = {}
        neck = set()
        if k > 1:
            for t in terms:
                for (L, i, j, stub) in t:
                    for di in range(-3, 4):
                        for dj in range(-3, 4):
                            neck.add((i + di, j + dj))
        wid = {}
        v1 = self.vmap(n, 1)
        vk = self.vmap(n, k) if k > 1 else None
        nx, ny = g.nx, g.ny
        hist = g.hist; occ = g.occ
        if k > 1:
            sat = np.zeros((3, nx + 1, ny + 1), dtype=np.float64)
            sat[:, 1:, 1:] = occ.cumsum(1).cumsum(2)
        def valid(L, i, j):
            key = (L, i, j)
            v = cache.get(key)
            if v is None:
                if i < 0 or j < 0 or i >= nx or j >= ny:
                    v = False
                elif vk is not None and vk[L, i, j]:
                    v = True; wid[key] = k
                elif v1[L, i, j] and (k == 1 or net not in self.strict or (i, j) in neck):
                    v = True; wid[key] = 1          # narrow section (penalised away from pins)
                else:
                    v = False
                cache[key] = v
            return v
        sep = self.sep_map(net)
        def cost(L, i, j):
            kk = wid.get((L, i, j), k)
            extra = sep[L, i, j] if sep is not None else 0.0
            if kk == 1:
                base = 1.0 if (k == 1 or (i, j) in neck) else 3.0
                return base + extra + hist[L, i, j] * (1.0 + pres * occ[L, i, j])
            o = sat[L, i + kk, j + kk] - sat[L, i, j + kk] - sat[L, i + kk, j] + sat[L, i, j]
            return 1.0 + extra + hist[L, i, j] * (1.0 + pres * o)
        tree = set()
        tstub = {}
        def fpcost(L, i, j, stub):
            f = self.fp.get((L, i, j, id(stub)))
            if not f:
                return 0.0
            return sum(float(g.occ[q]) for q in f) * pres * 4.0
        for (L, i, j, stub) in terms[0]:
            if valid(L, i, j):
                tree.add((L, i, j)); tstub[(L, i, j)] = stub
        if not tree:
            if DBG: print("DBG", net, "no tree")
            self.fail_why[net] = "no-tree"; self.fail_at[net] = [(g.xc(c[1]), g.yc(c[2])) for c in terms[0][:1]]
            return False
        used_stubs = []
        used_fp = []
        remaining = list(range(1, len(terms)))
        paths = []
        first_stub_used = False
        while remaining:
            targets = {}
            for ti in remaining:
                for (L, i, j, stub) in terms[ti]:
                    if valid(L, i, j):
                        targets[(L, i, j)] = (ti, stub)
            if not targets:
                if DBG: print("DBG", net, "no targets", remaining, len(paths))
                self.fail_why[net] = "no-target"; self.fail_at[net] = [(g.xc(c[1]), g.yc(c[2])) for ti in remaining for c in terms[ti][:1]]
                return False
            ti1 = min(a[1] for a in targets); ti2 = max(a[1] for a in targets)
            tj1 = min(a[2] for a in targets); tj2 = max(a[2] for a in targets)
            hw = getattr(self, "hweight", 2.0)     # > 2: weighted A* (faster, near-optimal)
            # distance to the nearest remaining terminal (its own bounding box): one box around
            # all of them makes h = 0 over a huge area for nets with far-apart terminals
            tb = collections.defaultdict(lambda: [1 << 30, -1, 1 << 30, -1])
            for (L_, i_, j_), (ti_, _) in targets.items():
                bx = tb[ti_]
                bx[0] = min(bx[0], i_); bx[1] = max(bx[1], i_); bx[2] = min(bx[2], j_); bx[3] = max(bx[3], j_)
            boxes = list(tb.values())
            def h(L, i, j):
                # every step costs >= 2 (1 + hist >= 1): 2 per grid step keeps A* admissible
                return min(max(0, b0 - i, i - b1) + max(0, b2 - j, j - b3) for b0, b1, b2, b3 in boxes) * hw
            openq = []
            came = {}
            gcost = {}
            for s in tree:
                c0 = fpcost(*s, tstub[s]) if s in tstub and not paths else 0.0
                gcost[s] = c0
                heapq.heappush(openq, (h(*s) + c0, -c0, s))
                came[s] = None
            found = None
            nexp = 0
            while openq:
                # ties in f are broken towards the larger g (deeper node): with the exact
                # Manhattan heuristic this avoids flooding the whole bounding box
                f, gc, cur = heapq.heappop(openq); gc = -gc
                if gc > gcost.get(cur, 1e18):
                    continue
                if cur in targets:
                    found = cur; break
                nexp += 1
                if nexp > getattr(self, "max_exp", 4000000):
                    self.exp_hit = getattr(self, "exp_hit", set()) | {net}
                    break
                L, i, j = cur
                nbrs = []
                if HORIZ[L]:
                    nbrs += [(L, i - 1, j), (L, i + 1, j)]
                else:
                    nbrs += [(L, i, j - 1), (L, i, j + 1)]
                if L > 0: nbrs.append((L - 1, i, j))
                if L < 2: nbrs.append((L + 1, i, j))
                for nb in nbrs:
                    if not valid(*nb):
                        continue
                    c = cost(*nb) + (self.via_cost if nb[0] != L else 0.0)
                    if nb in targets and targets[nb][1]:
                        c += fpcost(*nb, targets[nb][1])
                    ng = gc + c
                    if ng < gcost.get(nb, 1e18):
                        gcost[nb] = ng; came[nb] = cur
                        heapq.heappush(openq, (ng + h(*nb), -ng, nb))
            if found is None:
                if DBG: print("DBG", net, "not found", remaining, len(paths), nexp, len(tree))
                self.fail_why[net] = "exp-limit" if nexp > getattr(self, "max_exp", 4000000) else "no-path"
                self.fail_at[net] = [(g.xc((ti1 + ti2) // 2), g.yc((tj1 + tj2) // 2))] + \
                    [(g.xc(q[1]), g.yc(q[2])) for q in list(tree)[:1]]
                return False
            ti, stub = targets[found]
            p = [found]
            while came[p[-1]] is not None:
                p.append(came[p[-1]])
            start = p[-1]
            if tstub.get(start) and not paths:
                used_stubs.append(tstub[start])
                used_fp.extend(self.fp.get((start[0], start[1], start[2], id(tstub[start])), []))
            if stub:
                used_stubs.append(stub)
                used_fp.extend(self.fp.get((found[0], found[1], found[2], id(stub)), []))
            if not paths:
                # the other access candidates of the first terminal are not connected
                # (their stubs are not drawn): only the used one stays in the tree
                tree = set()
            paths.append(p)
            for q in p:
                tree.add(q)
            remaining.remove(ti)
        self.paths[net] = paths
        self.wid = getattr(self, "wid", {})
        self.wid[net] = {q: wid.get(q, k) for p in paths for q in p}
        self.stubs_of = getattr(self, "stubs_of", {})
        self.stubs_of[net] = used_stubs
        self.fp_of = getattr(self, "fp_of", {})
        self.fp_of[net] = used_fp
        return True

    def finalize(self):
        """Drop access candidates whose stub region collides with another net; record the
        grid footprint of every stub (it takes part in congestion negotiation)."""
        g = self.g
        self.fp = {}
        for net, terms in self.terms.items():
            n = g.nid(net)
            for t in terms:
                keep = []
                for c in t:
                    ok = True
                    for layer, r in (c[3] or []):
                        if layer != "metal3":      # M2 pads sit inside their own bar
                            continue
                        L = LAYERS.index(layer)
                        i1, i2 = g.irange(r[0] - BLOAT, r[2] + BLOAT)
                        j1, j2 = g.jrange(r[1] - BLOAT, r[3] + BLOAT)
                        o = g.own[L, i1:i2 + 1, j1:j2 + 1]; rg = g.ring[L, i1:i2 + 1, j1:j2 + 1]
                        if np.any(((o != 0) & (o != n)) | ((rg != 0) & (rg != n))):
                            ok = False; break
                    if ok:
                        keep.append(c)
                        fp = []
                        for layer, r in (c[3] or []):
                            if layer == "metal3":
                                i1, i2 = g.irange(r[0] - BLOAT, r[2] + BLOAT)
                                j1, j2 = g.jrange(r[1] - BLOAT, r[3] + BLOAT)
                                fp += [(1, a, b) for a in range(i1, i2 + 1) for b in range(j1, j2 + 1)]
                        if fp:
                            self.fp[(c[0], c[1], c[2], id(c[3]))] = fp
                t[:] = keep or t[:0]

    def _hot(self, pts, bin_=20000, n=6):
        """overlap / failure points clustered into bin_ squares: [(count, x_um, y_um)]"""
        c = collections.Counter((x // bin_, y // bin_) for x, y in pts)
        return [(k, (a + 0.5) * bin_ / 1e3, (b + 0.5) * bin_ / 1e3) for (a, b), k in c.most_common(n)]

    def run(self, order=None, iters=30):
        """negotiated congestion; progress per iteration goes to self.log (if set).  Stops early
        when the overlap count has not improved for self.patience iterations; self.hot then
        holds the remaining overlap points and self.fail_at the failed nets' locations."""
        g = self.g
        log = getattr(self, "log", None)
        patience = getattr(self, "patience", 0)
        best, it_best = None, 0
        self.fail_at = {}; self.fail_why = {}
        if not getattr(self, "_finalized", False):
            self.finalize(); self._finalized = True
        nets = order or sorted(self.terms, key=lambda n: -len(self.terms[n]))
        pres = 0.5
        for it in range(iters):
            g.occ[...] = 0
            fails = []
            self.fail_at = {}; self.fail_why = {}
            t_it = time.time(); slow = []
            for net in nets:
                t_n = time.time()
                ok = self.route_net(net, pres)
                slow.append((time.time() - t_n, net))
                if not ok:
                    fails.append(net)
                    continue
                wd = self.wid[net]
                cov = set()
                for p in self.paths[net]:
                    for q in p:
                        L, i, j = q
                        kk = wd.get(q, 1)
                        for di in range(kk):
                            for dj in range(kk):
                                cov.add((L, i + di, j + dj))
                cov.update(self.fp_of.get(net, []))
                self.cov = getattr(self, "cov", {})
                self.cov[net] = cov
                for (L, i, j) in cov:
                    g.occ[L, i, j] += 1
            over = np.argwhere(g.occ > 1)
            self.hot = [(g.xc(i), g.yc(j)) for (L, i, j) in over]
            if log:
                slow.sort(reverse=True)
                log("  it %2d %5.0fs  fails %d %s  overlaps %d  hot %s  slow %s" % (
                    it, time.time() - t_it, len(fails), fails[:5], len(over),
                    " ".join("%d@(%.0f,%.0f)" % h for h in self._hot(self.hot)),
                    " ".join("%s:%.0fs" % (nn, dt) for dt, nn in slow[:3])))
            if log and fails:
                for nn in fails:
                    log("    fail %-10s %-9s at %s" % (nn, self.fail_why.get(nn, "?"),
                        " ".join("(%.0f,%.0f)" % (x / 1e3, y / 1e3) for x, y in self.fail_at.get(nn, []))))
            if len(over) == 0 and not fails:
                return True, []
            if len(over) == 0 and it > 0 and sorted(fails) == sorted(getattr(self, "_pfails", [])):
                # no congestion left and the same nets fail again: blocked, not congested
                return False, fails + ["blocked"]
            self._pfails = list(fails)
            score = len(over) + 50 * len(fails)
            if best is None or score < best:
                best, it_best = score, it
            elif patience and it - it_best >= patience:
                return False, fails + ["overlap:%d" % len(over), "stagnated"]
            for (L, i, j) in over:
                g.hist[L, i, j] += 1.0
            pres *= 1.6
            if it == iters - 1 and not getattr(self, "_retry", False) and len(over):
                # last resort: the nets involved in the remaining overlaps go single-track
                bad = set()
                for (L, i, j) in over:
                    bad.update(n for n, cv in self.cov.items() if (L, i, j) in cv)
                for n in bad:
                    self.width[n] = 1
                self._retry = True
                print("  retry with single-track:", sorted(bad))
                return self.run(order, max(10, iters // 3))
            if it == iters - 1:
                info = []
                for (L, i, j) in over[:6]:
                    ns = [n for n, cv in self.cov.items() if (L, i, j) in cv]
                    fpn = [n for n in ns if (L, i, j) in set(self.fp_of.get(n, []))]
                    info.append("%s(%.1f,%.1f):%s fp:%s" % (LAYERS[L][-1], g.xc(i) / 1e3, g.yc(j) / 1e3, ns, fpn))
                return False, fails + ["overlap:%d" % len(over)] + info
        return False, []

    # ------------------------------------------------------------ geometry
    def emit(self, cell):
        g = self.g
        self.emitted = {}
        class Rec:
            def __init__(s2, c): s2.c = c; s2.net = None
            def rect(s2, l, *r):
                rr = s2.c.rect(l, *r)
                if rr: self.emitted.setdefault(s2.net, []).append((l, rr))
        rec = Rec(cell)
        cell = rec
        for net, paths in self.paths.items():
            rec.net = net
            wd = self.wid.get(net, {})
            for p in paths:
                for a, b in zip(p, p[1:]):
                    ka, kb = wd.get(a, 1), wd.get(b, 1)
                    if a[0] == b[0]:
                        L = a[0]
                        kk = min(ka, kb)
                        span = (kk - 1) * P
                        x1 = min(g.xc(a[1]), g.xc(b[1])); x2 = max(g.xc(a[1]), g.xc(b[1])) + span
                        y1 = min(g.yc(a[2]), g.yc(b[2])); y2 = max(g.yc(a[2]), g.yc(b[2])) + span
                        cell.rect(LAYERS[L], x1 - WW // 2, y1 - WW // 2, x2 + WW // 2, y2 + WW // 2)
                    else:
                        L = min(a[0], b[0])
                        kk = min(ka, kb)
                        span = (kk - 1) * P
                        x = g.xc(a[1]); y = g.yc(a[2])
                        for m in (L, L + 1):
                            cell.rect(LAYERS[m], x - PAD // 2, y - PAD // 2, x + span + PAD // 2, y + span + PAD // 2)
                        cell.rect(VIA[L], x - 140, y - 140, x + span + 140, y + span + 140)
                for q in p:
                    kq = wd.get(q, 1)
                    span = (kq - 1) * P
                    L, i, j = q
                    if kq > 1 or len(p) == 1:
                        cell.rect(LAYERS[L], g.xc(i) - WW // 2, g.yc(j) - WW // 2,
                                  g.xc(i) + span + WW // 2, g.yc(j) + span + WW // 2)
            for st in getattr(self, "stubs_of", {}).get(net, []):
                for layer, r in st:
                    cell.rect(layer, *r)
        # same-net notch fill: close gaps < spacing between shapes of one net on one layer
        SP = {"metal2": 280, "metal3": 280, "metal4": 280}
        for net, lst in list(self.emitted.items()):
            by = {}
            for l, r in lst:
                if l in SP:
                    by.setdefault(l, []).append(r)
            for l, rs in by.items():
                sp = SP[l]
                for a_ in range(len(rs)):
                    ra = rs[a_]
                    for b_ in range(a_ + 1, len(rs)):
                        rb = rs[b_]
                        ox = min(ra[2], rb[2]) - max(ra[0], rb[0])
                        oy = min(ra[3], rb[3]) - max(ra[1], rb[1])
                        if ox >= 280 and 0 < -oy < sp:          # vertical gap
                            y1, y2 = min(ra[3], rb[3]), max(ra[1], rb[1])
                            rec.net = net
                            rec.rect(l, max(ra[0], rb[0]), y1, min(ra[2], rb[2]), y2)
                        elif oy >= 280 and 0 < -ox < sp:        # horizontal gap
                            x1, x2 = min(ra[2], rb[2]), max(ra[0], rb[0])
                            rec.net = net
                            rec.rect(l, x1, max(ra[1], rb[1]), x2, min(ra[3], rb[3]))
