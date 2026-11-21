import sys, os, pickle
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import cells, build
name = sys.argv[1]
LAY = sys.argv[-1].split(",") if not sys.argv[-1][0].isdigit() else ["metal2","metal3","via2"]
if not sys.argv[-1][0].isdigit(): sys.argv = sys.argv[:-1]
pts = [(float(a)*5, float(b)*5) for a, b in zip(sys.argv[2::2], sys.argv[3::2])]   # magic units -> nm
m = cells.BUILD[name]()
m.route(widths=build.WIDTHS.get(name, {}), verbose=False)
own = [(l, r, "module") for l, rs in m.rects.items() for r in rs]
from module import tx_rect
for dev, inst, x, y, o, nm in m.placed:
    for l, r in dev.flat():
        own.append((l, tx_rect(o, x, y, r), inst))
for (px, py) in pts:
    print("== point %.2f %.2f um" % (px/1000, py/1000))
    for l, r, src in own:
        if l in LAY and r[0]-800 <= px <= r[2]+800 and r[1]-800 <= py <= r[3]+800:
            print("  %-7s %-8s %s" % (l, src, tuple(round(v/1000, 3) for v in r)))
