"""Final check, part 6: device totals of the macro, layout (magic extraction of the macro cut out of the final chip GDS,
layout/review/final/gdslvs/gds.lvs.spice) against the schematic (ref.spice, same directory), flattened.
FETs: total gate width per (type, L); resistors: total squares per width; MIM: total area.
usage: final_lvsum.py -> layout/review/final/lvsum.log (stdout)"""
import os, re, collections
D = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))), "layout/review/final/gdslvs")
U = {"u": 1e-6, "n": 1e-9, "p": 1e-12, "m": 1e-3, "f": 1e-15}


def num(s):
    s = s.strip("'")
    m = re.match(r"^([-+0-9.eE]+)([a-zA-Z]?)$", s)
    return float(m.group(1)) * U.get(m.group(2).lower(), 1.0)


def total(path, top):
    sc, cur = {}, None
    for l in open(path).read().replace("\n+", " ").split("\n"):
        t = l.split()
        if not t:
            continue
        if t[0].lower() == ".subckt":
            cur = t[1]; sc[cur] = []
        elif t[0].lower() == ".ends":
            cur = None
        elif cur and t[0][0] in "Xx":
            par = dict(x.lower().split("=", 1) for x in t if "=" in x)
            sc[cur].append(([x for x in t if "=" not in x][-1], par))
    tot = collections.Counter(); cnt = collections.Counter()

    def walk(c, mult):
        for kind, p in sc[c]:
            m = mult * int(float(p.get("m", 1)))
            if kind in sc:
                walk(kind, mult)
            elif "fet" in kind:
                k = (kind, "L %.2f" % (num(p["l"]) * 1e6)); tot[k] += num(p["w"]) * 1e6 * m; cnt[k] += m * int(float(p.get("nf", 1)))
            elif kind.startswith("ppolyf"):
                k = (kind, "W %.2f" % (num(p["r_width"]) * 1e6)); tot[k] += num(p["r_length"]) / num(p["r_width"]) * m; cnt[k] += m
            elif kind.startswith("cap_mim"):
                k = (kind, "area"); tot[k] += num(p["c_width"]) * num(p["c_length"]) * 1e12 * m; cnt[k] += m
    walk(top, 1)
    return tot, cnt


lay, lc = total(os.path.join(D, "gds.lvs.spice"), "gnss_afe_analog")
ref, rc = total(os.path.join(D, "ref.spice"), "gnss_afe_analog")
bad = 0
print("%-28s %-8s %14s %14s %9s   fingers / pieces (layout, schematic)" % ("device", "", "layout", "schematic", "diff %"))
for k in sorted(set(lay) | set(ref)):
    a, b = lay.get(k, 0), ref.get(k, 0)
    e = (a / b - 1) * 100 if b else float("inf")
    bad += abs(e) > 0.5
    print("%-28s %-8s %14.2f %14.2f %+9.3f   %d, %d" % (k[0], k[1], a, b, e, lc.get(k, 0), rc.get(k, 0)))
print("units: FET total width um, resistor total squares (series pieces of one resistor add), MIM total area um2")
print("groups differing by more than 0.5 %%: %d" % bad)
