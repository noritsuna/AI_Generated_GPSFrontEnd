"""Build module layouts: python3 build.py <cell> [...]  -> layout/mag/<cell>.mag (+DRC/LVS)"""
import os, sys, time
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import cells, lvs

OUT = os.environ.get("MAGOUT") or os.path.join(lvs.PROJ, "layout", "mag")
WIDTHS = {"vga": {"VDD": 2, "VSS": 2, "OUTP": 2, "OUTN": 2, "s1": 2, "s2": 2},
          "vco_core": {"VR": 4, "VSS": 4}}


def build(name, check=True):
    os.makedirs(OUT, exist_ok=True)
    t = time.time()
    if name in cells.BUILD:
        m = cells.BUILD[name]()
        import auto
        m.strict = set(auto.NET_WIDTHS.get(name, {}))
        m.noneck = auto.NONECK.get(name, set())
        ok = m.route(widths=WIDTHS.get(name, {}))
        m.route_ok = ok
        auto._built[name] = m
    else:
        import auto
        m = auto.build(name)
        ok = m.route_ok
    m.write(OUT)
    m.flattened().write(OUT)
    print("%s: routed=%s %.1fs" % (name, ok, time.time() - t))
    if check:
        n, errs = lvs.drc(name, OUT)
        print("  DRC %d" % n)
        for e in errs[:15]:
            print("   ", e)
        okl, last, rpt = lvs.lvs(name, OUT)
        print("  LVS %s %s" % ("OK" if okl else "FAIL", last))
    return m


if __name__ == "__main__":
    for c in sys.argv[1:]:
        build(c)
