import sys, os
sys.path.insert(0, os.path.dirname(__file__))
from devices import *
out = sys.argv[1]
d = []
d.append(mos_rows("t_nmir", "n", 2000, 5000, [dict(strips=["VSS","A","VSS","B","VSS","B","VSS","A","VSS"], gates=["G"]*8, top="G")], "VSS"))
d.append(mos_rows("t_ndp", "n", 280, 5000, [[dict(strips=["S1","DA","S1"], gates=["GA","GA"], top="GA"), dict(strips=["S2","DB","S2"], gates=["GB","GB"], bot="GB")],
                                           [dict(strips=["S2","DB","S2"], gates=["GB","GB"], bot="GB"), dict(strips=["S1","DA","S1"], gates=["GA","GA"], top="GA")]], "VSS"))
d.append(mos_rows("t_p1", "p", 280, 2000, [dict(strips=["D","VDD"], gates=["G"], top="G")], "VDD"))
top = Cell("t_all"); x = 0
for c in d:
    b = c.bbox(); top.use(c, c.name, x - b[0], -b[1]); x += b[2]-b[0] + 3000
for c in d: c.write(out)
top.write(out)
