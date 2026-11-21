"""Statistics of sim/mc/final_*.txt (first line = seed 0 = nominal, not counted).  usage: final_mc_stat.py file ..."""
import re, sys
import numpy as np
for f in sys.argv[1:]:
    rows = [dict((k, float(v)) for k, v in re.findall(r"(\w[\w.]*)=(-?[\d.eE+-]+)(?:\s|$)", l)) for l in open(f) if "FAILED" not in l]
    rows = sorted({r["seed"]: r for r in rows}.values(), key=lambda r: r["seed"])
    nom, mcr = rows[0], rows[1:]
    print("%s: %d runs" % (f, len(mcr)))
    for k in nom:
        if k == "seed":
            continue
        x = np.array([r[k] for r in mcr if k in r])
        print("  %-8s nom %9.3f  mean %9.3f  sd %8.3f  min %9.3f  max %9.3f" % (k, nom[k], x.mean(), x.std(ddof=1), x.min(), x.max()))
