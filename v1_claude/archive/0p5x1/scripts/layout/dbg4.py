import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import auto, router, cells, build
name = sys.argv[1]
def run(self, order=None, iters=30):
    self.finalize()
    g = self.g
    for net, terms in self.terms.items():
        n = g.nets[net]
        for ti, t in enumerate(terms):
            v = [c for c in t if self.ok(n, 1, c[0], c[1], c[2])]
            if not v or len(sys.argv) > 2:
                print(net, ti, "cands", len(t), "valid", len(v), [(c[0], round(g.xc(c[1])/1e3,2), round(g.yc(c[2])/1e3,2)) for c in t[:3]])
    return orig(self, order, iters)
orig = router.Router.run
router.Router.run = run
m = cells.BUILD[name]() if name in cells.BUILD else None
if m: m.route(widths=build.WIDTHS.get(name, {}))
else: m = auto.build(name)
print("outline", m.outline, [ (p[1], p[4]) for p in m.placed])
