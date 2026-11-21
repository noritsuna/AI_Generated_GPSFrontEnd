"""Parasitics of the top-level wiring of gnss_afe_analog (the routed nets between the blocks).
Re-routes the top with the top_build settings, writes the routed metal of every signal net
(labelled with its net name, no sub-modules) as top_wires_flat, extracts C (ground +
net-to-net coupling) with magic and estimates the wire resistance from the geometry.
Output: layout/mag/top_wires.json  {net: {"c": F, "r": ohm, "cc": {net: F}}}"""
import os, sys, re, json, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
os.environ.setdefault("REUSE", "bias_gen,vco_ring4,pll_core,divbuf,lna_nc,mixer_iq,if_chain,adc2b,inv_lo2,afc_dac")
import auto, lvs, mag
TOP = "gnss_afe_analog"
D = os.path.join(lvs.PROJ, "layout", "mag")
RSH = {"metal2": 0.09, "metal3": 0.09, "metal4": 0.09}     # ohm/sq (gf180 3.3V metal, 0.09 typ)
SUPPLY = {"VDD", "VSS", "VR"}

auto.FLOOR_SIDE[TOP] = 12600
auto.ROUTE_OPTS[TOP] = dict(log=lambda s: print(s, flush=True), patience=5, max_exp=3000000, hweight=2.5)
m = auto.build(TOP)
assert m.route_ok
em = m.router.emitted
c = mag.Cell("top_wires_flat")
res = {}
for net, lst in em.items():
    if net is None or net in SUPPLY:
        continue
    r = 0.0
    for l, rr in lst:
        c.rect(l, *rr)
        if l in RSH:
            w, h = rr[2] - rr[0], rr[3] - rr[1]
            # a wire segment: length / width squares (vias / pads add ~0)
            r += RSH[l] * max(w, h) / max(1, min(w, h)) if max(w, h) > 2 * min(w, h) else 0.0
        c.label(l, *rr, net, port=False)
    res[net] = dict(r=r, c=0.0, cc={})
c.write(D)
tcl = """set cell $env(CELL)
cd $env(DIR)
load ${cell}_flat
select top cell
extract do capacitance
extract do coupling
extract halo 2um
extract all
ext2spice lvs
ext2spice format ngspice
ext2spice cthresh 0.001
ext2spice subcircuit top on
ext2spice hierarchy off
ext2spice -o $cell.c.spice
quit -noprompt
"""
lvs.magic(tcl, D, dict(CELL="top_wires", DIR=D), timeout=7200)
for l in open(os.path.join(D, "top_wires.c.spice")):
    p = l.split()
    if not p or p[0][0] != "C":
        continue
    a, b = p[1], p[2]
    v = float(re.sub(r"f$", "e-15", p[3].lower()).replace("p", "e-12")) if not re.match(r"^[\d.eE+-]+$", p[3]) else float(p[3])
    gnd = lambda n: n in ("0", "VSS", "GND", "VSUBS") or n.lower() in ("vsubs", "gnd", "0")
    if gnd(b) and a in res:
        res[a]["c"] += v
    elif gnd(a) and b in res:
        res[b]["c"] += v
    elif a in res and b in res:
        res[a]["cc"][b] = res[a]["cc"].get(b, 0) + v
        res[b]["cc"][a] = res[b]["cc"].get(a, 0) + v
json.dump(res, open(os.path.join(D, "top_wires.json"), "w"), indent=1)
for net in sorted(res, key=lambda n: -res[n]["c"])[:60]:
    q = res[net]
    top = sorted(q["cc"].items(), key=lambda kv: -kv[1])[:3]
    print("%-8s C %7.1f fF  R %6.1f ohm  cc %s" % (net, q["c"] * 1e15, q["r"],
          " ".join("%s:%.2f" % (k, v * 1e15) for k, v in top)))
