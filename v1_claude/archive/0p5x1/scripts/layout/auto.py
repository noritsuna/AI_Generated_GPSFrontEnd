"""Automatic module layout from the schematic netlist.

Device grouping (layout techniques):
  * MOS with the same model / L / finger width / gate / source / bulk  -> one common-centroid
    array (current mirrors, tail sources), drain strips interleaved symmetrically.
  * Two MOS with the same model / L / finger width / fingers / source / bulk but different
    gates -> common-centroid differential pair (gates strapped top / bottom).
  * Resistors of one width -> one array of unit segments; equal-value resistors interleaved.
  * Each MIM capacitor -> unit-cell array.
  * Sub-circuits -> sub-modules (built once, reused).
"""
import math, re, collections, os
from module import Module
from lib import mos, cc_multi, rchain, interleave, cap, nm, UM, seg
from devices import res_array, mos_rows
import lvs
MAGDIR = os.path.join(lvs.PROJ, "layout", "mag")

MOS = ("nfet_03v3", "pfet_03v3")
SUPPLY = ("VDD", "VSS", "VDDV")
_cells = None
_dirs = None


def netlist():
    global _cells, _dirs
    if _cells is None:
        _cells = lvs.subckts()
        _dirs = {}
        cur = None
        for l in open(lvs.SRC):
            t = l.split()
            if not t:
                continue
            if t[0].lower() == ".subckt":
                cur = t[1]; _dirs[cur] = {}
            elif cur and t[0] in ("*.ipin", "*.opin", "*.iopin"):
                _dirs[cur][t[1]] = t[0][2:]
    return _cells, _dirs


def parse(cell):
    cells, dirs = netlist()
    lines = cells[cell]
    ports = lines[0].split()[2:]
    devs = []
    for l in lines[1:]:
        t = lvs.clean(l).split()
        if not t or t[0][0] not in "Xx":
            continue
        pos = [w for w in t[1:] if "=" not in w]
        kv = dict(w.split("=", 1) for w in t[1:] if "=" in w)
        model = pos[-1]; nets = pos[:-1]
        devs.append(dict(name=t[0][1:], model=model, nets=nets, kv=kv))
    return ports, dirs.get(cell, {}), devs, cells


def _mos_info(d):
    kv = d["kv"]
    W = nm(kv["W"]); nf = int(kv.get("nf", 1)); m = int(kv.get("m", 1))
    return dict(dn=d["nets"][0], g=d["nets"][1], s=d["nets"][2], b=d["nets"][3],
                typ="n" if d["model"] == "nfet_03v3" else "p", L=kv["L"], Wf=W // nf, F=nf * m,
                name=d["name"], W=W, nf=nf, m=m)


# devices that must stay single (placed next to the node they load, not matched as a group)
NOGROUP = {"vco_core": {"MK%d" % k for k in range(1, 5)} | {"MKD%d" % k for k in range(1, 5)}}


def group_mos(cell, devs):
    infos = [_mos_info(d) for d in devs if d["model"] in MOS]
    used = set(NOGROUP.get(cell, ()))
    out = []
    # 1. mirrors: same gate+source
    key = collections.defaultdict(list)
    for i in infos:
        if i["name"] in used:
            continue
        key[(i["typ"], i["L"], i["Wf"], i["g"], i["s"], i["b"])].append(i)
    for k, lst in key.items():
        lst = [i for i in lst if i["dn"] != i["s"]]
        if len(lst) >= 2 and all(i["F"] % 2 == 0 for i in lst) and len(set(i["dn"] for i in lst)) == len(lst):
            rows = 2 if sum(i["F"] for i in lst) > 40 and all(i["F"] % 4 == 0 for i in lst) else 1
            nmn = "%s_%s" % (cell, "_".join(i["name"] for i in lst))[:60]
            dev = cc_multi(nmn, k[0], k[1], "%gu" % (k[2] / 1000.0), [(i["dn"], i["F"]) for i in lst], k[4], k[3], k[5], rows=rows)
            out.append((dev, "X" + "_".join(i["name"] for i in lst)[:40], k[0]))
            used.update(i["name"] for i in lst)
    # 2. differential pairs: same source, different gates
    key = collections.defaultdict(list)
    for i in infos:
        if i["name"] in used:
            continue
        key[(i["typ"], i["L"], i["Wf"], i["F"], i["s"], i["b"])].append(i)
    for k, lst in key.items():
        while len(lst) >= 2:
            a, b = lst[0], lst[1]
            lst = lst[2:]
            if a["g"] == b["g"] or a["F"] % 2 or a["dn"] == b["dn"] or a["s"] in (a["g"], b["g"]):
                continue
            nmn = "%s_%s_%s" % (cell, a["name"], b["name"])
            h = a["F"] // 2
            from lib import cc_seq
            sq = cc_seq(h, h)
            strips = [a["s"]]; gates = []
            for q in sq:
                dv = a if q == "A" else b
                strips += [dv["dn"], a["s"]]
                gates += [dv["g"], dv["g"]]
            dev = mos_rows(nmn, k[0], nm(k[1]), k[2], [dict(strips=strips, gates=gates, top=a["g"], bot=b["g"])], k[5])
            out.append((dev, "X%s_%s" % (a["name"], b["name"]), k[0]))
            used.update((a["name"], b["name"]))
    # 3. the rest
    used -= NOGROUP.get(cell, set())
    for i in infos:
        if i["name"] in used:
            continue
        dev = mos("%s_%s" % (cell, i["name"]), i["typ"], i["L"], "%gu" % (i["W"] / 1000.0),
                  i["nf"], i["m"], i["dn"], i["g"], i["s"], i["b"])
        out.append((dev, "X" + i["name"], i["typ"]))
    return out


def group_res(cell, devs):
    rs = [d for d in devs if d["model"] == "ppolyf_u_1k"]
    byw = collections.defaultdict(list)
    for d in rs:
        byw[d["kv"]["r_width"]].append(d)
    out = []
    for W, lst in byw.items():
        chains = []
        done = set()
        byL = collections.defaultdict(list)
        for d in lst:
            byL[d["kv"]["r_length"]].append(d)
        for L, ds in byL.items():
            while len(ds) >= 2:
                a, b = ds[0], ds[1]; ds = ds[2:]
                chains += interleave([rchain(a["nets"][0], a["nets"][1], L), rchain(b["nets"][0], b["nets"][1], L)])
            for d in ds:
                chains.append(rchain(d["nets"][0], d["nets"][1], L))
        # renumber slots so interleaved groups follow each other; split long arrays
        arrays, cur, nseg = [], [], 0
        for ch in chains:
            cur.append(ch); nseg += ch["n"]
        k = 0
        # keep interleaved pairs together
        i = 0
        groups = []
        while i < len(chains):
            if chains[i].get("slots") and i + 1 < len(chains) and chains[i + 1].get("slots"):
                groups.append([chains[i], chains[i + 1]]); i += 2
            else:
                groups.append([chains[i]]); i += 1
        arr, cnt = [], 0
        for g in groups:
            n = sum(c["n"] for c in g)
            if arr and cnt + n > 24:
                arrays.append(arr); arr, cnt = [], 0
            arr.append(g); cnt += n
        if arr:
            arrays.append(arr)
        for ai, arr in enumerate(arrays):
            base = 0
            chs = []
            for g in arr:
                if len(g) == 2:
                    n = g[0]["n"]
                    g[0]["slots"] = [base + 2 * q for q in range(n)]
                    g[1]["slots"] = [base + 2 * q + 1 for q in range(n)]
                    base += 2 * n
                else:
                    g[0]["slots"] = list(range(base, base + g[0]["n"])); base += g[0]["n"]
                chs += g
            dev = res_array("%s_R%s_%d" % (cell, W.replace(".", "p"), ai), nm(W), chs)
            out.append((dev, "XR%s_%d" % (W.replace(".", "p"), ai), "r"))
    return out


def group_cap(cell, devs):
    out = []
    for d in devs:
        if d["model"] != "cap_mim_2f0_m4m5_noshield":
            continue
        kv = d["kv"]
        dev = cap("%s_%s" % (cell, d["name"]), d["nets"][0], d["nets"][1], kv["c_width"], kv["c_length"],
                  int(kv.get("m", 1)))
        out.append((dev, "X" + d["name"], "c"))
    return out


_built = {}
# analog macro placement in the chip (chip/librelane/macros/macros_gnss.yaml) and the
# core-side M2 pins of the analog pad block gf180mcu_gnss_io__afe_rf (placed FS at x=418.0):
# the macro gets M2 landing pins right under them for straight chip-level straps
MACRO_X = 468.0
PAD_X = 418.0
_PAD_M2 = {
    "VDD": [(86.36, 95.86), (98.76, 109.01), (110.61, 120.86), (124.14, 134.39), (135.99, 146.24), (149.14, 158.64)],
    "VSS": [(11.36, 20.86), (23.76, 34.01), (35.61, 45.86), (49.14, 59.39), (60.99, 71.24), (74.14, 83.64),
            (161.36, 170.86), (173.76, 184.01), (185.61, 195.86), (199.14, 209.39), (210.99, 221.24), (224.14, 233.64),
            (311.36, 320.86), (323.76, 334.01), (335.61, 345.86), (349.14, 359.39), (360.99, 371.24), (374.14, 383.64),
            (471.36, 480.86), (483.76, 494.01), (495.61, 505.86), (509.14, 519.39), (520.99, 531.24), (534.14, 543.64)],
    "RFIN": [(250.34, 294.66)],
    # VCO supply pad (block x = 395, its own ring section)
    "VDDV": [(396.36, 405.86), (408.76, 419.01), (420.61, 430.86), (434.14, 444.39), (445.99, 456.24), (459.14, 468.64)],
}
# analog pads (asig_5p0, FS) at x = 1225 / 1334 / 1443: core pins at +25.3..+69.7 um;
# REFIN lies beyond the macro's right edge and gets the rightmost slot
_SIG = [("VCTRL", 1225.0 + 42.5), ("AFCOUT", 1334.0 + 42.5)]
EDGE_PINS = {"gnss_afe_analog": [(net, int(round((PAD_X + a - MACRO_X) * 1000)), int(round((PAD_X + b - MACRO_X) * 1000)))
                                 for net, segs in _PAD_M2.items() for a, b in segs] +
             [(net, int(round((c - 5 - MACRO_X) * 1000)), int(round((c + 5 - MACRO_X) * 1000))) for net, c in _SIG] +
             [("REFIN", 925000, 935000)]}
# NMOS devices of these cells get a double guard ring (outer n-well ring to the given net)
RING2_CELLS = {"lna_nc": "VDD"}
# RF / low-impedance nets routed with several parallel tracks (k x k footprint)
NET_WIDTHS = {
    "lna_nc": {"RFIN": 3, "OUTP": 3, "OUTN": 3, "op_i": 2, "on_i": 2, "g2": 3, "vb1": 3, "vb2": 2},
    "mixer_iq": dict({"RFP": 3, "RFN": 3, "xpI": 3, "xnI": 3, "xpQ": 3, "xnQ": 3},
                     **{"m%s%s%s" % (x, ab, ch): 2 for x in "pn" for ab in "ab" for ch in "IQ"}),
    # ring supply: ~15 mA from the mirror (bottom) to the core (top); 2 tracks dropped 0.4 V (SS PEX)
    "vco_ring4": {"VR": 4},
    # CP output -> loop filter: the CP current pulses dropped ~0.4 kohm of 1-track wiring (PEX)
    "pll_core": {"vcp": 3},
    "loop_filter": {"VC": 3},
    "gnss_afe_analog": {"RFIN": 4, "rfp": 3, "rfn": 3},
}
# finished sub-modules read back from layout/mag instead of being rebuilt
REUSE = set(os.environ.get("REUSE", "").split(",")) - {""}

# analog top macro: port sides / order (north = towards the analog pads, west -> east
# in the pad order RF, VCTRL, AFCOUT, REFIN) and a hand floorplan (rows bottom -> top)
_LOV = ("L1P", "L1N", "L4P", "L4N", "L2P", "L2N", "L3P", "L3N")     # VCO core column order
PORT_SIDES = {"vco_ring4": dict({n: "N" for n in _LOV}, VCTRL="S", B0="S", B1="S", NB="S", CK="S", VR="E"),
              # the mixer sits right above the VCO: LO phases enter from the south in the same order
              "mixer_iq": dict({n: "S" for n in _LOV}, RFP="W", RFN="W", NB="W",
                               IFIP="E", IFIN="E", IFQP="E", IFQN="E"),
              "vco_core": {"kh": "S", "p1": "S", "n1": "S", "kl": "S", "p2": "S", "n2": "S",
                            "p4": "N", "n4": "N", "p3": "N", "n3": "N"},
              "gnss_afe_analog": {"RFIN": "N", "VCTRL": "N", "AFCOUT": "N", "REFIN": "N"}}
PORT_ORDER = {"vco_ring4": list(_LOV), "mixer_iq": list(_LOV),
              "vco_core": ["kh", "p1", "n1", "kl", "p2", "n2", "p4", "n4", "p3", "n3"],
              "gnss_afe_analog": ["RFIN", "VCTRL", "AFCOUT", "REFIN"]}
TOP_RAILS = {"gnss_afe_analog": ("VDDV", "VSS")}   # top edge (upwards): VDD, VDDV, VSS rails for the pad straps
# rows on their own supply: the VCO (VDDV pin, separate low-noise supply: pushing ~45 MHz/V)
# and the reference buffer (its threshold moves with the supply: REFCK edge jitter)
ROW_VDD = {"gnss_afe_analog": {4: "VDDV"}}
# row wrap width (nm) instead of sqrt(2 x area): pll_core shares a top row with afc_dac inside the
# 1052 um core; the 4 pF C3 tipped the default wrap to 861 um wide
ROW_WIDTH = {"pll_core": 600000,
             # VDD decap: one cap per row, a tall column right of the AFC DAC
             "decap": 115000}
CENTER_ROWS = {"vco_ring4", "vco_core"}
FLOOR_GAP = {"vco_core": 5600}     # int, or a per-row list
FLOOR_CHAN = {}
FLOOR_SIDE = {}                    # clearance spine <-> devices (nm)                    # per-row routing channel above each row (nm)
ROUTE_OPTS = {}                    # cell -> Router settings (log, patience, max_exp)
# clock nets kept away from the mixer IF outputs (aggressor -> (victims, tracks, cost per step)):
# fs ran next to mqn for ~1 mm (48.5 fF, 16.368 MHz into the Q channel)
_MIXOUT = ("mip", "min", "mqp", "mqn")
_PLLDIG = ("FS", "FB", "REFCK", "refck_i", "ck", "up", "upb", "dn", "dnb")
# and the Q mixer outputs off the I ones (mqn ran beside mip: 38.6 fF I/Q crosstalk after the pll_core resize)
_TOPCK = ("fs", "fsb", "CLKOUT", "ckr", "REFIN", "refck")
# vctrl both ways (the cost only sees nets routed before the aggressor): fs ran 4.2 fF beside it
SEP = {"gnss_afe_analog": dict({a: (_MIXOUT + ("vctrl",), 3, 3.0) for a in _TOPCK},
                               **{a: (("mip", "min", "vctrl"), 3, 3.0) for a in ("mqp", "mqn")},
                               vctrl=(_TOPCK + _MIXOUT, 3, 3.0)),
       # VCO tuning pin (behind the 1 kohm tap of the loop filter): FS / FB / REFCK coupled ~14 fF
       # into it, a kick every half reference period (-22 dBc reference spur, PEX)
       # (both ways: the cost only sees nets routed before, so FB routed first still ran beside it, 14.9 fF)
       "pll_core": dict({a: (("VCTRL",), 3, 3.0) for a in _PLLDIG}, VCTRL=(_PLLDIG, 3, 3.0))}     # device spacing in a row: room for the 10-pin ring nets
# refck (refbuf in the VCO row -> pll_core) ran beside AFCOUT down the east side (32 fF, 16 MHz
# square wave onto the TCXO tuning pin); both ways
SEP["gnss_afe_analog"]["refck"] = (_MIXOUT + ("vctrl", "AFCOUT"), 3, 3.0)
SEP["gnss_afe_analog"]["AFCOUT"] = (("refck", "REFIN", "fs", "fsb", "CLKOUT"), 3, 3.0)
FLOOR = {
    # ring core (auto fallback; cells.vco_core is the custom layout in use): stages in the folded order 1 4 2 3 (every hop spans <= 2 stage pitches),
    # NMOS row below / PMOS row above
    "vco_core": [["XMK1", "XMNa1_MNb1", "XMNc1", "XMNd1", "XMKD1", "XMK4", "XMNa4_MNb4", "XMNc4", "XMNd4", "XMKD4",
                  "XMK2", "XMNa2_MNb2", "XMNc2", "XMNd2", "XMKD2", "XMK3", "XMNa3_MNb3", "XMNc3", "XMNd3", "XMKD3"],
                 ["XMPa1_MPb1", "XMPc1", "XMPd1", "XMPa4_MPb4", "XMPc4", "XMPd4",
                  "XMPa2_MPb2", "XMPc2", "XMPd2", "XMPa3_MPb3", "XMPc3", "XMPd3"]],
    "vco_ring4": [["XCVR", "XCSUA", "XCSUB", "XMVI", "XMMIN", "XR2u_0", "XR1u_0"],
                  ["XMPD_MPO_MPB0_MPB1", "XMSB0", "XMSB1", "XB0", "XB1"],
                  ["XSUA1", "XSUA2", "XSUB1", "XSUB2"],
                  ["XSUA", "XSUB", "XSUAD1", "XSUBD1", "XSUAD4", "XSUBD4", "XSUAD3", "XSUBD3"],
                  # core on top: the 8 phases leave straight north to the mixer above
                  ["XCORE"]],
    # LNA: output coupling caps right next to the M1/M2 drains and the east (output) ports
    "lna_nc": [["XCC2", "XCB1", "XCB2"],
               ["XM1", "XM2", "XM1R", "XM2R", "XCOP", "XCON"],
               ["XR10u_0", "XR1u_0", "XR15u_0", "XMP1_MP2"]],
    "gnss_afe_analog": [                       # bottom -> top, core width 1052 um
    ["XADI", "XADQ", "XCKO1", "XCKO2", "XBIAS"],
    ["XIFQ"],
    ["XIFI"],
    ["XPLL", "XAFC", "XDEC"],
    # VCO right below the mixer (blank = LNA width + gap): 8 short, equal LO phase wires;
    # the reference buffer (on VDDV like the VCO) right under the REFIN pin
    [228000, "XVCO", "XRB"],
    ["XLNA", "XMIX", "XR1u_0"],                # next to the RF pad
]}


def build(cell, widths=None, verbose=True):
    if cell in _built:
        return _built[cell]
    ports, dirs, devs, cells = parse(cell)
    items = []
    items += group_cap(cell, devs)
    import devices
    devices.RING2 = RING2_CELLS.get(cell)
    items += group_mos(cell, devs)
    devices.RING2 = None
    items += group_res(cell, devs)
    subs = []
    import cells as custom
    for d in devs:
        if d["model"] in cells:
            if d["model"] in custom.BUILD:
                if d["model"] not in _built:
                    cm = custom.BUILD[d["model"]]()
                    import build as B
                    cm.route_ok = cm.route(widths=B.WIDTHS.get(d["model"], {}), verbose=verbose)
                    _built[d["model"]] = cm
                sm = _built[d["model"]]
            elif d["model"] in REUSE and os.path.exists(os.path.join(MAGDIR, d["model"] + ".mag")):
                import magload
                sm = magload.load(d["model"], MAGDIR)
            else:
                sm = build(d["model"], verbose=verbose)
            sp = cells[d["model"]][0].split()[2:]
            subs.append((sm, "X" + d["name"], "s", dict(zip(sp, d["nets"]))))
    side = {"ipin": "W", "opin": "E", "iopin": "N"}
    if cell in PORT_SIDES:
        sides = PORT_SIDES[cell]
        plist = [(p, sides.get(p, "S")) for p in ports if p not in SUPPLY]
        order = {p: k for k, p in enumerate(PORT_ORDER.get(cell, []))}
        plist.sort(key=lambda t: order.get(t[0], 999))
        m = Module(cell, plist)
    else:
        m = Module(cell, [(p, side.get(dirs.get(p, "iopin"), "N")) for p in ports if p not in SUPPLY])
    # rows: caps | nmos | resistors | pmos | sub-modules, each wrapped to a target width
    def area(dv):
        b = dv.outline
        return (b[2] - b[0]) * (b[3] - b[1])
    allit = [(it[0], it[1], it[2], it[3] if len(it) > 3 else None) for it in items + subs]
    tot = sum(area(it[0]) for it in allit)
    wmax = max(it[0].outline[2] - it[0].outline[0] for it in allit)
    target = max(wmax, ROW_WIDTH.get(cell, int(math.sqrt(tot * 2.0))))
    rows = []
    if cell in FLOOR:
        byinst = {it[1]: (it[0], it[1], "N", it[3]) for it in allit}
        # a number in a FLOOR row is a blank of that width (nm)
        blank = lambda i: isinstance(i, (int, float))
        rows = [[i if blank(i) else byinst[i] for i in row if blank(i) or i in byinst] for row in FLOOR[cell]]
        left = [v for k, v in byinst.items() if not any(k in row for row in FLOOR[cell])]
        if left:
            rows.insert(0, left)
    for kind in (() if cell in FLOOR else ("c", "n", "r", "p", "s")):
        cur, w = [], 0
        for dv, inst, k, nmap in allit:
            if k != kind:
                continue
            dw = dv.outline[2] - dv.outline[0]
            if cur and w + dw > target:
                rows.append(cur); cur, w = [], 0
            cur.append((dv, inst, "N", nmap)); w += dw + 4000
        if cur:
            rows.append(cur)
    # supply rails: VDD if the cell has it, else the PMOS bulk net (e.g. VR), else none
    pb = collections.Counter(d["nets"][3] for d in devs if d["model"] == "pfet_03v3")
    vdd = "VDD" if "VDD" in ports else (pb.most_common(1)[0][0] if pb else None)
    vss = "VSS" if "VSS" in ports else None
    m.floor(rows, vdd=vdd, vss=vss, top_rails=TOP_RAILS.get(cell, ()), center=cell in CENTER_ROWS, row_vdd=ROW_VDD.get(cell),
            gap=FLOOR_GAP.get(cell, 4000), **({"chan": FLOOR_CHAN[cell]} if cell in FLOOR_CHAN else {}), side=FLOOR_SIDE.get(cell, 2000))
    if cell in SEP:
        m.rt_sep = SEP[cell]
    for a, v in ROUTE_OPTS.get(cell, {}).items():
        setattr(m, "rt_" + a, v)
    if ROUTE_OPTS.get(cell, {}).get("log"):
        ROUTE_OPTS[cell]["log"]("floor %s: rows %s" % (cell, " ".join("%.0f-%.0f" % (a / 1e3, b / 1e3) for a, b in m.row_spans)))
    wd = {"VDD": 2, "VSS": 2, "VR": 2}
    wd.update(NET_WIDTHS.get(cell, {}))
    wd.update(widths or {})
    m.strict = set(NET_WIDTHS.get(cell, {}))
    m.edge_pins = EDGE_PINS.get(cell, [])
    ok = m.route(widths=wd, verbose=verbose)
    m.route_ok = ok
    _built[cell] = m
    return m
