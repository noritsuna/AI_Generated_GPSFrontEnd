"""Static IR drop of the analog macro supply mesh (M4 rails + M5 stripes + via4), from the GDS.
Each supply net (VDDA / VDDV / VSS) is first traced from its pin label through the merged M5 /
via4 / M4 shapes, then rasterised alone on a GRID um grid (a cell is metal when its centre is
covered; touching cells are one square of sheet resistance, a via4 cell joins M4 and M5 with its
via count in parallel). Every block draws its
supply current (block_currents.json, schematic operating point) spread evenly over the M4 rail
cells of that net inside its outline; VSS returns the VDDA + VDDV current.
Not modelled: the M3 spines / M1 inside the blocks, the chip PDN and the bond wires.
usage: ir_drop.py [gds] [currents.json]"""
import os, sys, json, collections
import numpy as np
import klayout.db as db
from scipy.sparse import coo_matrix, diags
from scipy.sparse.linalg import spsolve
from scipy.sparse.csgraph import connected_components

HERE = os.path.dirname(os.path.abspath(__file__))
PROJ = os.path.abspath(os.path.join(HERE, "..", ".."))
GDS = sys.argv[1] if len(sys.argv) > 1 else os.path.join(PROJ, "layout", "gds", "gnss_afe_analog.gds")
CUR = sys.argv[2] if len(sys.argv) > 2 else os.path.join(PROJ, "layout", "block_currents.json")
GRID = float(os.environ.get("GRID", "2.0"))     # um
RSH = 0.09               # ohm/sq, metal4 / metal5 (gf180 3.3 V metal, typical)
RV4 = 4.5                # ohm per via4 (typical)
L = {"m4": (46, 0), "v4": (41, 0), "m5": (81, 0), "lab": (81, 10)}

ly = db.Layout(); ly.read(GDS)
top = ly.top_cell()
bb = top.bbox().to_dtype(ly.dbu)
nx, ny = int(np.ceil(bb.width() / GRID)), int(np.ceil(bb.height() / GRID))
N = nx * ny
reg = {k: db.Region(top.begin_shapes_rec(ly.find_layer(*L[k]))) for k in ("m4", "v4", "m5")}
reg["m4"].merge(); reg["m5"].merge()


def trace(pt):
    """M4 / M5 / via4 shapes connected to the M5 shape under pt"""
    s5 = reg["m5"].interacting(db.Region(db.Box(pt, pt + db.Vector(1, 1))))
    s4 = db.Region()
    while True:
        v = reg["v4"].interacting(s5)
        n4 = reg["m4"].interacting(v)
        v = reg["v4"].interacting(n4)
        n5 = reg["m5"].interacting(v)
        if n4.count() == s4.count() and n5.count() == s5.count():
            return s4, s5, reg["v4"].interacting(s4).interacting(s5)
        s4, s5 = n4, n5 | s5


def raster(r):
    g = np.zeros((nx, ny), dtype=bool)
    for poly in r.each():
        for tz in poly.decompose_trapezoids():
            b = tz.bbox().to_dtype(ly.dbu)
            i0 = int(np.ceil((b.left - bb.left) / GRID - 0.5)); i1 = int(np.floor((b.right - bb.left) / GRID - 0.5))
            j0 = int(np.ceil((b.bottom - bb.bottom) / GRID - 0.5)); j1 = int(np.floor((b.top - bb.bottom) / GRID - 0.5))
            if i1 >= i0 and j1 >= j0:
                g[max(i0, 0):i1 + 1, max(j0, 0):j1 + 1] = True
    return g


def vcount(r):
    g = np.zeros((nx, ny), dtype=np.int32)
    for poly in r.each():
        c = poly.bbox().to_dtype(ly.dbu).center()
        i = int((c.x - bb.left) / GRID); j = int((c.y - bb.bottom) / GRID)
        if 0 <= i < nx and 0 <= j < ny:
            g[i, j] += 1
    return g


labels = {}
for sh in top.shapes(ly.find_layer(*L["lab"])).each():
    if sh.is_text():
        labels.setdefault(sh.text_string, sh.text.trans.disp)
cur = {k: v for k, v in json.load(open(CUR)).items() if not k.startswith("_")}
blocks, seen = [], collections.Counter()
for inst in top.each_inst():
    seen[inst.cell.name] += 1
    blocks.append(("%s#%d" % (inst.cell.name, seen[inst.cell.name]), inst.bbox().to_dtype(ly.dbu)))
res = {}
for net, pt in sorted(labels.items()):
    supply = {"VDDV": "VDDV", "VDDA": "VDD"}.get(net)      # VSS returns both
    amp_of = lambda k: sum(cur.get(k, {}).values()) if supply is None else cur.get(k, {}).get(supply, 0.0)
    s4, s5, sv = trace(pt)
    m4, m5, v4 = raster(s4), raster(s5), vcount(sv)
    rows, cols, vals = [], [], []
    for k, g in enumerate((m4, m5)):
        for di, dj in ((1, 0), (0, 1)):
            ii, jj = np.nonzero(g[:nx - di, :ny - dj] & g[di:, dj:])
            rows.append(k * N + ii * ny + jj); cols.append(k * N + (ii + di) * ny + jj + dj)
            vals.append(np.full(len(ii), 1.0 / RSH))
    ii, jj = np.nonzero((v4 > 0) & m4 & m5)
    rows.append(ii * ny + jj); cols.append(N + ii * ny + jj); vals.append(v4[ii, jj] / RV4)
    r, c, v = np.concatenate(rows), np.concatenate(cols), np.concatenate(vals)
    A = coo_matrix((np.r_[v, v], (np.r_[r, c], np.r_[c, r])), shape=(2 * N, 2 * N)).tocsr()
    # 0 V: the M5 pin bar under the label; only the metal connected to it on the grid is solved
    # (the bar is cut where the other net's stripes pass: every M5 piece of the net in its y band)
    # (the merged bar is one polygon with its stripes: take the grid rows around the label where
    # the net covers most of the width)
    jl = int((pt.y * ly.dbu - bb.bottom) / GRID)
    full = lambda j: 0 <= j < ny and m5[:, j].mean() > 0.5
    jb0 = jb1 = jl
    while full(jb0 - 1): jb0 -= 1
    while full(jb1 + 1): jb1 += 1
    bar = np.zeros_like(m5); bar[:, jb0:jb1 + 1] = m5[:, jb0:jb1 + 1]
    fixed = N + np.nonzero(bar.ravel())[0]
    _, comp = connected_components(A, directed=False)
    used = np.nonzero(np.isin(comp, np.unique(comp[fixed])))[0]
    used = used[np.r_[m4.ravel(), m5.ravel()][used]]
    free = np.setdiff1d(used, fixed)
    I = np.zeros(2 * N); tot = 0.0
    sel_of = {}
    for key, b in blocks:
        amp = amp_of(key)
        if not amp:
            continue
        i0, i1 = int((b.left - bb.left) / GRID), int((b.right - bb.left) / GRID)
        j0, j1 = int((b.bottom - bb.bottom) / GRID), int((b.top - bb.bottom) / GRID)
        f4 = free[free < N]
        sel = f4[((f4 // ny) >= i0) & ((f4 // ny) <= i1) & ((f4 % ny) >= j0) & ((f4 % ny) <= j1)]
        if len(sel) == 0:
            print("  %s: no %s M4 cells (fed below M4)" % (key, net)); continue
        I[sel] += amp / len(sel); tot += amp; sel_of[key] = sel
    K = (diags(np.asarray(A[free].sum(axis=1)).ravel()) - A[free][:, free]).tocsc()
    V = np.zeros(2 * N); V[free] = spsolve(K, I[free])
    print("%s: %d M4 + %d M5 cells, %d via4; %.1f mA, max drop %.2f mV" % (
        net, m4.sum(), m5.sum(), v4.sum(), tot * 1e3, V.max() * 1e3))
    # current density (electromigration): the current through every grid edge is dV / RSH for a
    # GRID um wide strip -> mA/um; via4: dV / RV4 per via
    um = np.zeros(2 * N, dtype=bool); um[used] = True
    for k, (nm, g) in enumerate((("M4", m4), ("M5", m5))):
        Vk = V[k * N:(k + 1) * N].reshape(nx, ny); uk = um[k * N:(k + 1) * N].reshape(nx, ny)
        jx = np.where(uk[:-1] & uk[1:], abs(Vk[:-1] - Vk[1:]), 0) / RSH / GRID * 1e3
        jy = np.where(uk[:, :-1] & uk[:, 1:], abs(Vk[:, :-1] - Vk[:, 1:]), 0) / RSH / GRID * 1e3
        ix = np.unravel_index(jx.argmax(), jx.shape); iy = np.unravel_index(jy.argmax(), jy.shape)
        print("   EM %s: max %.3f mA/um (x, at %.0f,%.0f um) / %.3f mA/um (y, at %.0f,%.0f um); edges above 1.0 mA/um: %d, above 1.4: %d" % (
            nm, jx.max(), bb.left + ix[0] * GRID, bb.bottom + ix[1] * GRID, jy.max(), bb.left + iy[0] * GRID, bb.bottom + iy[1] * GRID,
            (jx > 1.0).sum() + (jy > 1.0).sum(), (jx > 1.4).sum() + (jy > 1.4).sum()))
        if jx.max() > 1.0:      # the metal around the x maximum (rows of the grid, '#': metal of this net)
            for j in range(ix[1] + 6, ix[1] - 7, -1):
                print("      y %6.0f  %s" % (bb.bottom + j * GRID, "".join(
                    ("%d" % min(9, int(jx[i, j] * 5)) if uk[i, j] else ".") for i in range(max(0, ix[0] - 30), min(nx - 1, ix[0] + 30)))))
        res.setdefault("_em", {})["%s_%s" % (net, nm)] = float(max(jx.max(), jy.max()))
    vv = (v4 > 0) & m4 & m5 & um[:N].reshape(nx, ny) & um[N:].reshape(nx, ny)
    iv = np.where(vv, abs(V[:N].reshape(nx, ny) - V[N:].reshape(nx, ny)), 0) / RV4 * 1e3
    print("   EM via4: max %.4f mA per via (%d vias on the net)" % (iv.max(), v4[vv].sum()))
    res["_em"]["%s_via4" % net] = float(iv.max())
    for key, sel in sel_of.items():
        print("   %-24s %6.2f mA  drop mean %6.2f / max %6.2f mV" % (key, amp_of(key) * 1e3, V[sel].mean() * 1e3, V[sel].max() * 1e3))
        res.setdefault(key, {})[net] = (V[sel].mean(), V[sel].max())
json.dump(res, open(os.path.join(PROJ, "layout", "ir_drop.json"), "w"), indent=1)
