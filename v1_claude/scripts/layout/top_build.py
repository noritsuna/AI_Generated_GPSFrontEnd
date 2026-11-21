"""Build the analog top macro gnss_afe_analog from the finished sub-modules (layout/mag),
route it, then DRC + LVS.  Log: layout/top_build.log

Routing runs in attempts: each attempt logs every negotiation iteration (time, failed nets,
overlap count, hotspot clusters) and stops early when it stagnates; the channels / row gaps
holding the remaining hotspots are then widened and the floor is re-placed and re-routed."""
import os, sys, time, math, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
os.environ.setdefault("REUSE", "bias_gen,vco_ring4,pll_core,divbuf,lna_nc,mixer_iq,if_chain,adc2b,inv_lo2,afc_dac")
import auto, lvs, build, power_mesh, module
TOP = "gnss_afe_analog"
CORE_H = int(os.environ.get("CORE_H", "4238000"))   # core height available (0p5x1: 442..4680 um; 0p5x0p5: 1647 um)
STEP = 6 * 700                    # widening step: 6 tracks
ATTEMPTS = int(os.environ.get("ATTEMPTS", "6"))
t = time.time()


def log(msg):
    print("[%6.0fs] %s" % (time.time() - t, msg), flush=True)


nrow = len(auto.FLOOR[TOP])
chans = [module.CHAN] * nrow
gaps = [4000] * nrow
side = [int(os.environ.get("SIDE", "12600"))]
auto.ROUTE_OPTS[TOP] = dict(log=log, patience=int(os.environ.get("PATIENCE", "5")),
                            max_exp=int(os.environ.get("MAX_EXP", "3000000")),
                            hweight=float(os.environ.get("HWEIGHT", "2.5")))
for att in range(ATTEMPTS):
    auto.FLOOR_CHAN[TOP] = list(chans); auto.FLOOR_GAP[TOP] = list(gaps); auto.FLOOR_SIDE[TOP] = side[0]
    auto._built.pop(TOP, None)
    log("attempt %d  chan %s  gap %s  side %.1f (um)" % (att, [c / 1e3 for c in chans], [g / 1e3 for g in gaps], side[0] / 1e3))
    m = auto.build(TOP)
    if m.route_ok:
        break
    rt = m.router
    spans = m.row_spans
    pts = [(p, 1) for p in rt.hot] + [(p, 50) for ps in rt.fail_at.values() for p in ps]
    dch, dgp = collections.Counter(), collections.Counter()
    xa, xb = m.dev_x; dside = 0
    for (x, y), w in pts:
        if x < xa + 10000 or x > xb - 10000:
            dside += w      # at a spine-side module edge
        for k, (a, b) in enumerate(spans):
            if a <= y <= b:
                dgp[k] += w; break
            if k + 1 < len(spans) and b < y < spans[k + 1][0]:
                dch[k] += w; break
    log("hotspots per channel %s  per row %s  side %d  failed %s" % (dict(dch), dict(dgp), dside, sorted(rt.fail_at)))
    if dside:
        side[0] += STEP * min(4, 1 + dside // 100)
    if not dch and not dgp and not dside:
        log("no hotspot in a channel or row gap: nothing to widen"); break
    for k, n in dch.items():
        chans[k] += STEP * min(4, 1 + n // 100)
    for k, n in dgp.items():
        if len([i for i in auto.FLOOR[TOP][k] if not isinstance(i, (int, float))]) > 1:
            gaps[k] += STEP * min(4, 1 + n // 100)
        else:
            # single-module row: congestion over the module -> open both neighbouring channels
            for kk in (k - 1, k):
                if 0 <= kk < nrow - 1:
                    chans[kk] += STEP
    h = spans[-1][1] - spans[0][0] + sum(chans) - sum(auto.FLOOR_CHAN[TOP])
    if h > CORE_H:
        log("height %.0f um would exceed the core (%.0f um): stop" % (h / 1e3, CORE_H / 1e3)); break
power_mesh.mesh(m)            # M5 VDD/VSS stripes over the macro + VDDA/VSS pin bars on top
# outline lower-left -> (0, 0): LEF origin = GDS origin = macro placement point
dx, dy = -m.outline[0], -m.outline[1]
for l in m.rects:
    m.rects[l] = [(r[0] + dx, r[1] + dy, r[2] + dx, r[3] + dy) for r in m.rects[l]]
m.labels = [(l, (r[0] + dx, r[1] + dy, r[2] + dx, r[3] + dy), t_, p, d) for l, r, t_, p, d in m.labels]
m.uses = [(c, i, x + dx, y + dy, o) for c, i, x, y, o in m.uses]
m.outline = (0, 0, m.outline[2] + dx, m.outline[3] + dy)
m.props["FIXED_BBOX"] = "%d %d %d %d" % tuple(v // 5 for v in m.outline)   # LEF size
m.write(build.OUT); m.flattened().write(build.OUT)
b = m.outline
log("route=%s size=%.1fx%.1fum" % (m.route_ok, (b[2]-b[0])/1e3, (b[3]-b[1])/1e3))
n, errs = lvs.drc(TOP, build.OUT)
log("DRC %s %s" % (n, errs[:10]))
ok, last, rpt = lvs.lvs(TOP, build.OUT)
log("LVS %s %s %s" % ("OK" if ok else "FAIL", last, rpt))
