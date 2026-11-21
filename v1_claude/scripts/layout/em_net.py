"""Electromigration check of the wiring inside one block, from the GDS (the supply mesh above the
blocks is in ir_drop.py).  The metal nets of the block cell are extracted with klayout (M1..M5 +
vias); the DC terminals of a net are its contacts on poly (resistor heads) and on the source /
drain diffusion of the MOS (diffusion crossed by poly), grouped by device sub-cell.  Each net
given in the spec is rasterised on a GRID um grid, every terminal group injects its DC current
spread evenly over its contacts ("M4": all M4 cells of the net held at 0 V, the supply rails), and
the resistor network is solved: current per um of drawn width in every metal, current per via.
GF180MCU limits (DRM 14.2, T0.1 > 100 kh): M1..M4 2.09 / 1.0 mA/um, top metal (11 kA) 4.5 / 2.2
mA/um, via and contact 0.58 / 0.28 mA at 85 / 110 C junction temperature.
usage: em_net.py list <cell>          (nets with their terminal groups)
       em_net.py <spec.json>          {"cell": ..., "nets": {name: {group: mA, ...}}}  (+ into the net)
       a group is "<sub-cell suffix>:<poly|sd|tap>[:<index>]" or "M4"."""
import os, sys, json, collections
import numpy as np
import klayout.db as db
from scipy.sparse import coo_matrix, diags
from scipy.sparse.linalg import spsolve

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
PROJ = os.path.abspath(os.path.join(HERE, "..", ".."))
GDS = os.path.join(PROJ, "layout", "gds", "gnss_afe_analog.gds")
GRID = float(os.environ.get("GRID", "0.1"))
MET = [("m1", (34, 0), 0.09), ("m2", (36, 0), 0.09), ("m3", (42, 0), 0.09), ("m4", (46, 0), 0.09), ("m5", (81, 0), 0.04)]
VIA = [("v1", (35, 0)), ("v2", (38, 0)), ("v3", (40, 0)), ("v4", (41, 0))]
RVIA = 4.5
LIM = {"m": (2.09, 1.0), "m5": (4.5, 2.2), "via": (0.58, 0.28)}


def load(cellname):
    src = db.Layout(); pfx = "gnss_"
    if os.environ.get("BLOCK"):         # the block as last built (layout/mag), before the macro is exported
        import lvs
        tmp = os.path.join(PROJ, "layout", "em", cellname + "_blk.gds")
        lvs.magic("load %s\nselect top cell\ngds write %s\nquit -noprompt\n" % (cellname, tmp), os.path.join(PROJ, "layout", "mag"))
        src.read(tmp); pfx = ""
    else:
        src.read(GDS)
    ly = db.Layout(); ly.dbu = src.dbu
    top = ly.create_cell(cellname)
    top.copy_tree(src.cell(pfx + cellname))
    inst = [(i.cell.name.replace("gnss_", "").replace("%s_" % cellname, ""), i.bbox()) for i in top.each_inst()]
    top.flatten(True)
    # via4 on a MIM top plate (75/0) connects M5 to that plate, not to the M4 below it
    v4 = ly.layer(41, 0); keep = db.Region(top.begin_shapes_rec(v4)) - db.Region(top.begin_shapes_rec(ly.layer(75, 0)))
    top.shapes(v4).clear(); top.shapes(v4).insert(keep)
    R = lambda l: db.Region(top.begin_shapes_rec(ly.layer(*l)))
    return ly, top, inst, R


def extract(ly, top, R):
    l2n = db.LayoutToNetlist(db.RecursiveShapeIterator(ly, top, []))
    lay = {}
    for n, l, *_ in MET + VIA + [("cont", (33, 0))]:
        lay[n] = l2n.make_layer(ly.layer(*l), n)
    for n in lay:
        l2n.connect(lay[n])
    order = ["cont", "m1", "v1", "m2", "v2", "m3", "v3", "m4", "v4", "m5"]
    for a, b in zip(order, order[1:]):
        l2n.connect(lay[a], lay[b])
    l2n.extract_netlist()
    return l2n, lay


def groups(net_cont, inst, R):
    """contacts of a net -> {group: Region}; sd: on a diffusion crossed by poly (MOS), tap: other diffusion"""
    poly, comp = R((30, 0)), R((22, 0)).merged()
    mos = comp.interacting(poly)
    g = collections.defaultdict(db.Region)
    for kind, reg in (("poly", net_cont & poly), ("sd", net_cont & mos), ("tap", net_cont & (comp - mos))):
        for p in reg.each():
            c = p.bbox().center()
            name = next((n for n, b in inst if b.contains(c)), "top")
            g["%s:%s" % (name, kind)].insert(p)
    return g


def main():
    if sys.argv[1] == "list":
        cell, spec = sys.argv[2], None
    else:
        spec = json.load(open(sys.argv[1])); cell = spec["cell"]
    ly, top, inst, R = load(cell)
    l2n, lay = extract(ly, top, R)
    circ = l2n.netlist().circuit_by_name(cell)
    nets = []
    for net in circ.each_net():
        cont = l2n.shapes_of_net(net, lay["cont"], True)
        if cont.is_empty():
            continue
        g = groups(cont, inst, R)
        key = dict(g)
        nets.append((net, key))
    # name a net by its terminal groups
    if spec is None:
        for net, key in sorted(nets, key=lambda x: -sum(r.count() for r in x[1].values())):
            if len([k for k in key if not k.endswith(":tap")]) >= 2:
                print("net %-6s %s" % (net.expanded_name(), "  ".join("%s x%d" % (k, r.count()) for k, r in sorted(key.items()))))
        return
    out = {}
    for name, cur in spec["nets"].items():
        want = set(k.split(":")[0] + ":" + k.split(":")[1] for k in cur if k != "M4")
        cand = [(net, key) for net, key in nets if want <= set(key)]
        if "pick" in spec.get("opts", {}).get(name, {}):
            cand = [c for c in cand if c[0].expanded_name() == spec["opts"][name]["pick"]]
        assert len(cand) == 1, (name, [(n.expanded_name(), sorted(k)) for n, k in cand])
        net, key = cand[0]
        # each net in a forked child, retried: SuperLU sometimes corrupts memory on the largest nets
        import multiprocessing as mp, io, contextlib
        def job(conn):
            buf = io.StringIO()
            with contextlib.redirect_stdout(buf):
                r = solve(name, l2n, lay, net, key, cur, ly)
            conn.send((r, buf.getvalue()))
        for attempt in range(4):
            a, b = mp.get_context("fork").Pipe()
            pr = mp.get_context("fork").Process(target=job, args=(b,)); pr.start(); b.close()
            try:
                out[name], txt = a.recv()
            except EOFError:
                txt = None
            pr.join()
            if txt is not None:
                print(txt, end=""); break
            print("   (solver failed for %s, retry %d)" % (name, attempt + 1))
        assert txt is not None, name
    json.dump(out, open(os.path.join(PROJ, "layout", "em", cell + ".json"), "w"), indent=1)


def solve(name, l2n, lay, net, key, cur, ly):
    dbu = ly.dbu
    regs = {n: l2n.shapes_of_net(net, lay[n], True).merged() for n in lay}
    bb = db.Box()
    for n, *_ in MET:
        bb += regs[n].bbox()
    x0, y0 = bb.left * dbu, bb.bottom * dbu
    nx, ny = int(np.ceil(bb.width() * dbu / GRID)) + 1, int(np.ceil(bb.height() * dbu / GRID)) + 1
    N = nx * ny

    def raster(r):
        g = np.zeros((nx, ny), dtype=bool)
        for poly in r.each():
            for tz in poly.decompose_trapezoids():
                b = tz.bbox()
                i0 = int(np.ceil((b.left * dbu - x0) / GRID - 0.5)); i1 = int(np.floor((b.right * dbu - x0) / GRID - 0.5))
                j0 = int(np.ceil((b.bottom * dbu - y0) / GRID - 0.5)); j1 = int(np.floor((b.top * dbu - y0) / GRID - 0.5))
                if i1 >= i0 and j1 >= j0:
                    g[max(i0, 0):i1 + 1, max(j0, 0):j1 + 1] = True
        return g

    def cells(r):
        """grid cell of the centre of every polygon"""
        c = [p.bbox().center() for p in r.each()]
        return (np.array([int((p.x * dbu - x0) / GRID) for p in c], dtype=int),
                np.array([int((p.y * dbu - y0) / GRID) for p in c], dtype=int))

    grid = [raster(regs[n]) for n, *_ in MET]
    rows, cols, vals = [], [], []
    for k, (n, _, rsh) in enumerate(MET):
        g = grid[k]
        for di, dj in ((1, 0), (0, 1)):
            ii, jj = np.nonzero(g[:nx - di, :ny - dj] & g[di:, dj:])
            rows.append(k * N + ii * ny + jj); cols.append(k * N + (ii + di) * ny + jj + dj); vals.append(np.full(len(ii), 1.0 / rsh))
    vedge = []
    for k, (n, _) in enumerate(VIA):
        ii, jj = cells(regs[n])
        ok = grid[k][ii, jj] & grid[k + 1][ii, jj]
        ii, jj = ii[ok], jj[ok]
        rows.append(k * N + ii * ny + jj); cols.append((k + 1) * N + ii * ny + jj); vals.append(np.full(len(ii), 1.0 / RVIA))
        vedge.append((k * N + ii * ny + jj, (k + 1) * N + ii * ny + jj))
    r, c, v = np.concatenate(rows), np.concatenate(cols), np.concatenate(vals)
    M = len(MET) * N
    A = coo_matrix((np.r_[v, v], (np.r_[r, c], np.r_[c, r])), shape=(M, M)).tocsr()
    I = np.zeros(M); fixed = np.zeros(M, dtype=bool); info = []
    for gname, ma in cur.items():
        if gname == "M4":
            fixed[3 * N:4 * N] = grid[3].ravel(); info.append("M4 rails 0 V"); continue
        p = gname.split(":")
        reg = key[p[0] + ":" + p[1]]
        if len(p) > 2:      # one terminal of a device cell with several: contacts clustered along x, index from the left
            reg = cluster(reg)[int(p[2])]
        ii, jj = cells(reg)
        ok = grid[0][ii, jj]
        assert ok.all(), (gname, "contacts off the M1 grid", (~ok).sum())
        np.add.at(I, ii * ny + jj, ma * 1e-3 / len(ii))
        info.append("%s %+.2f mA / %d contacts = %.3f mA each" % (gname, ma, len(ii), abs(ma) / len(ii)))
    used = np.asarray(A.sum(axis=1)).ravel() > 0
    # every piece of the net must be connected on the grid, or the solve is meaningless
    from scipy.sparse.csgraph import connected_components
    un = np.nonzero(used)[0]
    nc, lab = connected_components(A[un][:, un], directed=False)
    if nc > 1:
        big = np.bincount(lab).argmax()
        for q in range(nc):
            if q != big:
                idx = un[lab == q]; k0 = idx[0] // N; i0 = (idx[0] % N) // ny; j0 = (idx[0] % N) % ny
                msg = "   !! island of %d cells on %s at %.1f,%.1f um (current %.3f mA, fixed %d)" % (
                    len(idx), MET[k0][0], x0 + i0 * GRID, y0 + j0 * GRID, I[idx].sum() * 1e3, fixed[idx].sum())
                if len(idx) <= 2 and not I[idx].any() and not fixed[idx].any():
                    used[idx] = False       # raster crumb at the edge of a shape: carries nothing
                    continue
                print(msg); print(msg, file=sys.stderr)
    if not fixed.any():
        assert abs(I.sum()) < 1e-9, I.sum()
        fixed[np.nonzero(I)[0][0]] = True       # reference node (currents sum to zero)
    free = np.nonzero(used & ~fixed)[0]
    K = (diags(np.asarray(A[free].sum(axis=1)).ravel()) - A[free][:, free]).tocsc()
    rhs = I[free]; sol = spsolve(K, rhs)
    res_ = np.linalg.norm(K @ sol - rhs) / max(np.linalg.norm(rhs), 1e-30)
    assert res_ < 1e-6, (name, "residual", res_)        # (the direct solver has returned garbage on the largest nets)
    V = np.zeros(M); V[free] = sol
    print("== %s (klayout net %s): %s" % (name, net.expanded_name(), "; ".join(info)))
    res = {}
    for k, (n, _, rsh) in enumerate(MET):
        g = grid[k]
        if not g.any():
            continue
        Vk = V[k * N:(k + 1) * N].reshape(nx, ny)
        jx = np.where(g[:-1] & g[1:], abs(Vk[:-1] - Vk[1:]), 0) / rsh / GRID * 1e3     # mA/um
        jy = np.where(g[:, :-1] & g[:, 1:], abs(Vk[:, :-1] - Vk[:, 1:]), 0) / rsh / GRID * 1e3
        # current per um of drawn width, averaged over the cross-section of the wire (corner crowding on the
        # 0.1 um grid is not what the rule counts): mean of j over each run of metal across the flow
        best = (0, 0, 0, 0)
        for j_, axis in ((jx, 1), (jy, 0)):
            m = j_ > 0.2
            if not m.any():
                continue
            lab = runs(m, axis)
            s = np.bincount(lab.ravel(), weights=j_.ravel()); cnt = np.bincount(lab.ravel())
            mean = np.where(cnt > 0, s / np.maximum(cnt, 1), 0); mean[0] = 0
            t = mean.argmax(); pos = np.argwhere(lab == t)[0]
            if mean[t] > best[0]:
                best = (mean[t], cnt[t] * GRID, x0 + pos[0] * GRID, y0 + pos[1] * GRID)
        lim = LIM["m5" if n == "m5" else "m"]
        print("   %s: %.2f mA/um over a %.1f um wide wire (%.2f mA) at %.1f,%.1f um  [limit %.2f at 85 C / %.2f at 110 C] %s" % (
            n.upper(), best[0], best[1], best[0] * best[1], best[2], best[3], lim[0], lim[1],
            "OK" if best[0] <= lim[1] else ("over the 110 C limit" if best[0] <= lim[0] else "OVER the 85 C limit x%.1f" % (best[0] / lim[0]))))
        res[n] = dict(j=float(best[0]), w=float(best[1]), x=float(best[2]), y=float(best[3]))
    for k, (n, _) in enumerate(VIA):
        a, b = vedge[k]
        if len(a):
            iv = abs(V[a] - V[b]) / RVIA * 1e3
            q = int(np.asarray(a)[iv.argmax()]) % N
            print("   %s: %d vias, max %.3f mA per via at %.1f,%.1f um  [limit %.2f / %.2f] %s" % (
                n.upper(), len(a), iv.max(), x0 + q // ny * GRID, y0 + q % ny * GRID, *LIM["via"], "OK" if iv.max() <= LIM["via"][1] else ("over the 110 C limit" if iv.max() <= LIM["via"][0] else "OVER the 85 C limit x%.1f" % (iv.max() / LIM["via"][0]))))
            res[n] = float(iv.max())
    return res


def runs(m, axis):
    """label every run of True cells along the given axis"""
    d = np.diff(m.astype(np.int8), axis=axis, prepend=0)
    start = d == 1
    lab = np.cumsum(start.ravel() if axis == 1 else start.T.ravel())
    lab = lab.reshape(m.shape) if axis == 1 else lab.reshape(m.T.shape).T
    return np.where(m, lab, 0)


def cluster(reg, gap=2000):
    ps = sorted(reg.each(), key=lambda p: p.bbox().center().x)
    out = [db.Region()]; last = None
    for p in ps:
        x = p.bbox().center().x
        if last is not None and x - last > gap:
            out.append(db.Region())
        out[-1].insert(p); last = x
    return out


if __name__ == "__main__":
    main()
