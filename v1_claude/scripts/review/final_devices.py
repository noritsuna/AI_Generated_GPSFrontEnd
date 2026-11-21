"""Final check, part 1: table of every device of every subcircuit of gnss_afe_top (from the tb_full netlist)
and the static rules (minimum L / W of the device class, resistor and capacitor size limits, values).
usage: final_devices.py  -> layout/review/final/devices.log (stdout)"""
import os, sys, re, collections
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))
os.environ.setdefault("PDK", "gf180mcuD"); os.environ.setdefault("PDK_ROOT", os.path.expanduser("~/pdk"))
import run

LMIN = {"nfet_03v3": 0.28, "pfet_03v3": 0.28, "nfet_06v0": 0.70, "pfet_06v0": 0.50, "nfet_05v0": 0.60, "pfet_05v0": 0.50}
WMIN = {"nfet_03v3": 0.22, "pfet_03v3": 0.22, "nfet_06v0": 0.30, "pfet_06v0": 0.30}
RSH = {"ppolyf_u_1k": 1000.0, "ppolyf_u": 315.0, "npolyf_u": 310.0, "nplus_u": 85.0, "pplus_u": 280.0}
CMIM = 2.0e-15   # F/um2


def num(v):
    v = v.strip("'")
    m = re.match(r"^([-+0-9.eE]+)(u|n|p|f|k|meg|m)?$", v)
    k = {"u": 1e-6, "n": 1e-9, "p": 1e-12, "f": 1e-15, "k": 1e3, "meg": 1e6, "m": 1e-3, None: 1.0}[m.group(2)]
    return float(m.group(1)) * k


def subckts(text):
    text = text.replace("\n+", " ")
    d, cur = collections.OrderedDict(), None
    for l in text.split("\n"):
        if l.lower().startswith(".subckt"):
            cur = l.split()[1]; d[cur] = []
        elif l.lower().startswith(".ends"):
            cur = None
        elif cur and l[:1] in "XxMRCD":
            t = l.split("*")[0].split() + re.findall(r"\b(?:m|nf)=\S+", l)
            par = dict(x.split("=", 1) for x in t if "=" in x)
            pos = [x for x in t if "=" not in x]
            d[cur].append((pos[0], pos[1:-1], pos[-1], par))
    return d


def main():
    d = subckts(open(run.netlist("tb_full")).read())
    bad = 0
    tot = collections.Counter()
    for sc, devs in d.items():
        print("## %s" % sc)
        for name, nodes, kind, p in devs:
            note = ""
            if kind in LMIN:
                w, l, nf, m = num(p["W"]) * 1e6, num(p["L"]) * 1e6, int(float(p.get("nf", 1))), int(float(p.get("m", 1)))
                if l < LMIN[kind] - 1e-9 or w / nf < WMIN.get(kind, 0.22) - 1e-9:
                    note = "  <-- below minimum"; bad += 1
                if w / nf > 100:
                    note = "  <-- finger wider than 100 um"; bad += 1
                tot[kind] += nf * m
                print("  %-7s %-10s W %6.2f L %5.2f nf %2d m %2d  Wtot %7.1f  W/L %7.1f  finger %5.2f  D=%s G=%s S=%s B=%s%s" % (
                    name, kind, w, l, nf, m, w * m, w * m / l, w / nf, *nodes[:4], note))
            elif kind in RSH:
                w, l = num(p["r_width"]) * 1e6, num(p["r_length"]) * 1e6
                m = int(float(p.get("m", 1)))
                if w < 0.8 - 1e-9 or l < 1.0 - 1e-9:
                    note = "  <-- below minimum"; bad += 1
                tot[kind] += 1
                print("  %-7s %-10s W %6.2f L %6.2f m %d  R %9.0f ohm (sheet only)  squares %6.2f  %s-%s B=%s%s" % (
                    name, kind, w, l, m, RSH[kind] * l / w / m, l / w, *nodes[:3], note))
            elif kind.startswith("cap_mim"):
                w, l = num(p["c_width"]) * 1e6, num(p["c_length"]) * 1e6
                m = int(float(p.get("m", 1)))
                if min(w, l) < 5 - 1e-9 or max(w, l) > 100 + 1e-9:
                    note = "  <-- outside 5..100 um"; bad += 1
                tot[kind] += 1
                print("  %-7s %-10s %5.1f x %5.1f um m %d  C %7.3f pF  %s-%s%s" % (name, "mim 2fF", w, l, m, CMIM * w * l * m * 1e12, *nodes[:2], note))
            else:
                print("  %-7s -> %-10s %s  %s" % (name, kind, " ".join(nodes), " ".join("%s=%s" % kv for kv in p.items())))
    print("== device classes used (fingers x m for FETs): %s" % dict(tot))
    print("== static rule violations: %d" % bad)


if __name__ == "__main__":
    main()
