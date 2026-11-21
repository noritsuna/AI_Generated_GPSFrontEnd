import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import cells, build, router, auto
from module import tx_rect
name = sys.argv[1]; net = sys.argv[2]
m = cells.BUILD[name]() if name in cells.BUILD else None
orig = router.Router.add_pin
log = []
def add_pin(self, n, layer, r, k=1):
    if n == net: log.append((layer, r))
    return orig(self, n, layer, r, k)
router.Router.add_pin = add_pin
def run(self, order=None, iters=30):
    g = self.g
    for layer, r in log:
        print(layer, tuple(v/1e3 for v in r))
        i1, i2 = g.irange(r[0], r[2]); jc = int(round(((r[1]+r[3])//2 - g.y0)/router.P))
        for j in range(jc+2, jc-3, -1):
            print("  row %.2f own " % (g.yc(j)/1e3), [int(g.own[1,i,j]) for i in range(i1, min(i2+1, i1+14))], " ring", [int(g.ring[1,i,j]) for i in range(i1, min(i2+1,i1+14))])
    print(g.nets)
    return True, []
router.Router.run = run
(m.route(widths=build.WIDTHS.get(name, {}), verbose=False) if m else auto.build(name, verbose=False))
