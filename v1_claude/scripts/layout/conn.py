"""Geometric short finder for a routed module (M2/M3/M4 + via2/via3, device pins as labels)."""
import sys, os, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from module import tx_rect

def check(m):
    shapes = []   # (layer, rect, net or None)
    for l, rs in m.rects.items():
        if l in ("metal2", "metal3", "metal4", "via2", "via3"):
            for r in rs: shapes.append((l, r, None))
    for dev, inst, x, y, o, nm in m.placed:
        for net, lst in dev.pins.items():
            for l, r in lst:
                if l in ("metal2", "metal3", "metal4"):
                    shapes.append((l, tx_rect(o, x, y, r), nm.get(net, net)))
        for l, r in dev.flat(("metal2", "metal3", "metal4", "via2", "via3")):
            shapes.append((l, tx_rect(o, x, y, r), None))
    for net, l, r in m.supply_pins:
        shapes.append((l, r, net))
    par = list(range(len(shapes)))
    def f(a):
        while par[a] != a:
            par[a] = par[par[a]]; a = par[a]
        return a
    def u(a, b): par[f(a)] = f(b)
    B = 5000
    buck = collections.defaultdict(list)
    for k, (l, r, n) in enumerate(shapes):
        for bx in range(r[0] // B, r[2] // B + 1):
            for by in range(r[1] // B, r[3] // B + 1):
                buck[(bx, by)].append(k)
    conn = {"metal2": {"metal2", "via2"}, "metal3": {"metal3", "via2", "via3"}, "metal4": {"metal4", "via3"},
            "via2": {"metal2", "metal3", "via2"}, "via3": {"metal3", "metal4", "via3"}}
    for ks in buck.values():
        for a in range(len(ks)):
            la, ra, _ = shapes[ks[a]]
            for b in range(a + 1, len(ks)):
                lb, rb, _ = shapes[ks[b]]
                if lb in conn[la] and ra[0] < rb[2] and rb[0] < ra[2] and ra[1] < rb[3] and rb[1] < ra[3]:
                    u(ks[a], ks[b])
    adj = collections.defaultdict(set)
    for ks in buck.values():
        for a in range(len(ks)):
            la, ra, _ = shapes[ks[a]]
            for b in range(a + 1, len(ks)):
                lb, rb, _ = shapes[ks[b]]
                if lb in conn[la] and ra[0] < rb[2] and rb[0] < ra[2] and ra[1] < rb[3] and rb[1] < ra[3]:
                    adj[ks[a]].add(ks[b]); adj[ks[b]].add(ks[a])
    m._adj = adj; m._shapes = shapes
    nets = collections.defaultdict(set)
    where = collections.defaultdict(list)
    for k, (l, r, n) in enumerate(shapes):
        if n:
            nets[f(k)].add(n); where[f(k)].append((n, l, r))
    for root, ns in nets.items():
        if len(ns) > 1:
            print("SHORT:", sorted(ns))
            # find the bridging region: shapes of the group closest between two nets
            byn = collections.defaultdict(list)
            for n, l, r in where[root]: byn[n].append((l, r))
            print("   ", {n: v[:2] for n, v in byn.items()})
    return nets


def pairwise(m):
    em = m.router.emitted
    items = []
    for net, lst in em.items():
        for l, r in lst: items.append((l, r, net))
    for dev, inst, x, y, o, nm in m.placed:
        for net, lst in dev.pins.items():
            for l, r in lst:
                items.append((l, tx_rect(o, x, y, r), nm.get(net, net)))
    conn = {"metal2": {"metal2", "via2"}, "metal3": {"metal3", "via2", "via3"}, "metal4": {"metal4", "via3"},
            "via2": {"metal2", "metal3", "via2"}, "via3": {"metal3", "metal4", "via3"}}
    B = 5000; buck = collections.defaultdict(list)
    for k, (l, r, n) in enumerate(items):
        for bx in range(r[0] // B, r[2] // B + 1):
            for by in range(r[1] // B, r[3] // B + 1):
                buck[(bx, by)].append(k)
    seen = set()
    for ks in buck.values():
        for a in range(len(ks)):
            la, ra, na = items[ks[a]]
            for b in range(a + 1, len(ks)):
                lb, rb, nb = items[ks[b]]
                if na != nb and lb in conn[la] and ra[0] < rb[2] and rb[0] < ra[2] and ra[1] < rb[3] and rb[1] < ra[3]:
                    key = (min(ks[a], ks[b]), max(ks[a], ks[b]))
                    if key not in seen:
                        seen.add(key); print("OVERLAP", na, la, ra, "|", nb, lb, rb)

def internal(m):
    em = m.router.emitted
    conn = {"metal2": {"metal2", "via2"}, "metal3": {"metal3", "via2", "via3"}, "metal4": {"metal4", "via3"},
            "via2": {"metal2", "metal3", "via2"}, "via3": {"metal3", "metal4", "via3"}}
    devs = []
    for dev, inst, x, y, o, nm in m.placed:
        pins = set((l, r) for n, lst in dev.pins.items() for l, r in lst)
        for l, r in dev.flat(("metal2", "metal3", "metal4", "via2", "via3")):
            if (l, r) in pins: continue
            devs.append((l, tx_rect(o, x, y, r), inst))
    for net, l, r in m.extra_own:
        devs.append((l, r, "tap:" + net))
    for net, lst in em.items():
        for l, r in lst:
            for (dl, dr, inst) in devs:
                if dl in conn[l] and r[0] < dr[2] and dr[0] < r[2] and r[1] < dr[3] and dr[1] < r[3]:
                    if inst != "tap:" + str(net):
                        print("TOUCH", net, l, r, "|", inst, dl, dr)


def path(m, n1, n2):
    sh = m._shapes; adj = m._adj
    src = [k for k, s_ in enumerate(sh) if s_[2] == n1]
    dst = set(k for k, s_ in enumerate(sh) if s_[2] == n2)
    prev = {k: None for k in src}; q = list(src)
    while q:
        k = q.pop(0)
        if k in dst:
            p = []
            while k is not None: p.append(k); k = prev[k]
            for k in p: print("  ", sh[k][0], tuple(round(v/1000., 3) for v in sh[k][1]), sh[k][2])
            return
        for j in adj[k]:
            if j not in prev: prev[j] = k; q.append(j)

if __name__ == "__main__":
    import cells, build
    name = sys.argv[1]
    if name in cells.BUILD:
        m = cells.BUILD[name]()
        m.route(widths=build.WIDTHS.get(name, {}), verbose=False)
    else:
        import auto
        m = auto.build(name, verbose=False)
    check(m)
    if len(sys.argv) > 3: path(m, sys.argv[2], sys.argv[3])
