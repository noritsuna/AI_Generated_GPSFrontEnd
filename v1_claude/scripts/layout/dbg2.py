import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import cells, build, router
name = sys.argv[1]; nets = sys.argv[2].split(",")
m = cells.BUILD[name]()
orig = router.Router.run
def run(self, order=None, iters=30):
    self.finalize()
    g = self.g
    for net in nets:
        n = g.nets[net]
        for ti, t in enumerate(self.terms[net]):
            v = [c for c in t if self.ok(n, 1, c[0], c[1], c[2])]
            print(net, ti, "cands", len(t), "valid", len(v), [ (c[0], round(g.xc(c[1])/1e3,2), round(g.yc(c[2])/1e3,2)) for c in t[:3]])
    return True, []
router.Router.run = run
m.route(widths=build.WIDTHS.get(name, {}), verbose=False)
