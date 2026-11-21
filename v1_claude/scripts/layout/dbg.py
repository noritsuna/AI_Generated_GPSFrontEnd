import sys, os, numpy as np
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import cells, router
import matplotlib; matplotlib.use("Agg"); import matplotlib.pyplot as plt
from build import WIDTHS
name = sys.argv[1]
m = cells.BUILD[name]()
# monkeypatch run to 1 iteration and keep the router
ok = m.route(widths=WIDTHS.get(name, {}), iters=int(sys.argv[2]) if len(sys.argv) > 2 else 1)
rt = m.router; g = rt.g
for net, terms in rt.terms.items():
    k = rt.width.get(net, 1); n = g.nets[net]
    bad = [ti for ti, t in enumerate(terms) if not any(rt.ok(n, k, L, i, j) for (L, i, j, s) in t)]
    if bad:
        print("net %s k=%d: %d/%d terminals with no valid node" % (net, k, len(bad), len(terms)))
fig, ax = plt.subplots(1, 3, figsize=(30, 10))
for L in range(3):
    o = g.own[L].T.astype(float)
    img = np.zeros(o.shape + (3,))
    img[o == -1] = (0.3, 0.3, 0.3)
    img[o > 0] = (0.6, 0.8, 1.0)
    img[(g.occ[L].T > 0)] = (1, 0.5, 0)
    img[(g.occ[L].T > 1)] = (1, 0, 0)
    ax[L].imshow(img, origin="lower", interpolation="nearest"); ax[L].set_title(router.LAYERS[L])
plt.tight_layout(); plt.savefig("/tmp/claude-1000/-home-noritsuna-GPS/c833b4ff-95cf-42fc-a46c-00da2a6a5752/scratchpad/grid_%s.png" % name, dpi=60)
for net, terms in rt.terms.items():
    k = rt.width.get(net, 1); n = g.nets[net]
    for ti, t in enumerate(terms):
        if not any(rt.ok(n, k, L, i, j) for (L, i, j, s) in t):
            L, i, j, s = t[0]
            print(net, "term", ti, "L", L, "x %.2f y %.2f" % (g.xc(i)/1000, g.yc(j)/1000), "ncand", len(t),
                  "own", g.own[L, max(0,i-1):i+2, max(0,j-1):j+2].T.tolist())
