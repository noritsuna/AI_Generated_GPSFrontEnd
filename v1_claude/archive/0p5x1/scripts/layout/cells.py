"""Module layouts (one function per schematic cell)."""
from module import Module
from lib import mos, cc_pair, cc_multi, cross_quad, rchain, interleave, cap, nm, UM
from devices import res_array, mos_rows

GAP = 4 * UM      # default spacing between placed devices (routing channel)


class Row:
    """Left-to-right placement helper."""
    def __init__(self, m, y, x=0, gap=GAP):
        self.m, self.y, self.x, self.gap = m, y, x, gap
        self.top = y

    def add(self, dev, inst, orient="N", netmap=None, dy=0):
        r = self.m.place(dev, inst, self.x, self.y + dy, orient, netmap)
        self.x = r[2] + self.gap
        self.top = max(self.top, r[3])
        return r


def vga(name="vga"):
    m = Module(name, [("INP", "W"), ("INN", "W"), ("GA", "S"), ("GB", "S"), ("NB", "S"),
                      ("OUTP", "E"), ("OUTN", "E"), ("VDD", "N"), ("VSS", "S")])
    p = name + "_"
    tail = cc_pair(p + "MT", "n", "2u", "10u", 32, 32, "VSS", "s1", "s2", "NB", "VSS", rows=2)
    dp = cross_quad(p + "MDP", "n", "0.28u", "5u", 16, ("s1", "OUTN", "gp"), ("s2", "OUTP", "gn"), "VSS")
    sw = mos_rows(p + "MSW", "n", nm("0.28u"), nm("5u"),
                  [dict(strips=["s1", "da", "s1", "da", "s1", "db", "s1", "db", "s1", "db", "s1", "db", "s1"],
                        gates=["GA"] * 4 + ["GB"] * 8, top="GA", bot="GB")], "VSS")
    rl = res_array(p + "RL", nm("1u"), interleave([rchain("OUTN", "VDD", "2u"), rchain("OUTP", "VDD", "2u")]))
    rd = res_array(p + "RD", nm("1u"), [rchain("s2", "s1", "2u"), rchain("s2", "da", "3u")])
    rdb = res_array(p + "RDB", nm("2u"), [rchain("s2", "db", "1.8u")])
    rb = res_array(p + "RB", nm("1u"), interleave([rchain("vcm", "gp", "100u"), rchain("vcm", "gn", "100u")])
                   + [rchain("vcm", "VDD", "34u"), rchain("VSS", "vcm", "25u")])
    cc1 = cap(p + "CC1", "INP", "gp", "50e-6", "50e-6")
    cc2 = cap(p + "CC2", "INN", "gn", "50e-6", "50e-6")
    ccm = cap(p + "CCM", "vcm", "VSS", "30e-6", "30e-6")
    m.floor([[(cc1, "XCC1"), (cc2, "XCC2"), (tail, "XMT")],
             [(dp, "XMDP"), (sw, "XMSW"), (rd, "XRD"), (rdb, "XRDB"), (rl, "XRL")],
             [(rb, "XRB"), (ccm, "XCCM")]])
    return m


def vco_core(name="vco_core", L="0.28u"):
    """Ring core, compact: per stage 4 devices (N main+kick, N latch, P main, P latch), each a
    single guard ring with one island per transistor; stages in the folded order 1 4 2 3 so every
    ring hop spans at most two stage pitches; NMOS row below, PMOS row above."""
    # driven phases all to the north, in column order
    ports = [("kh", "S"), ("kl", "S"), ("CK", "S")] + [("ckd" + n, "S") for n in ("n1", "p4", "n4", "p2", "n2", "p3", "n3")] + [("L" + n[1] + n[0].upper(), "N") for n in ("p1", "n1", "p4", "n4", "p2", "n2", "p3", "n3")]
    m = Module(name, ports)
    p = name + "_"
    Ln = nm(L)
    st = {"1": ("p4", "n4", "p1", "n1", "kh"), "2": ("p1", "n1", "p2", "n2", "kl"),
          "3": ("p2", "n2", "p3", "n3", None), "4": ("p3", "n3", "n4", "p4", None)}
    nrow, prow = {}, {}
    for k in "1234":
        ip, inn, op, on, fk = st[k]
        fk = fk or "VSS"
        isl = lambda d, g: dict(strips=["VSS", d, "VSS", d, "VSS"], gates=[g] * 4, top=g)
        nmain = mos_rows(p + "N" + k, "n", Ln, nm("4u"),
                         [[isl(on, ip), isl(op, inn), isl(on, fk), isl(op, "VSS")]], "VSS")
        # latch devices one per guard ring: a narrow island cannot carry two signal buses
        # next to its bulk bus (the bulk bar to the ring would cover the drain pin)
        nlc = mos(p + "NLc" + k, "n", L, "6u", 2, 1, on, op, "VSS", "VSS")
        nld = mos(p + "NLd" + k, "n", L, "6u", 2, 1, op, on, "VSS", "VSS")
        pisl = lambda d, g: dict(strips=["VR", d, "VR", d, "VR", d, "VR", d, "VR"], gates=[g] * 8, top=g)
        pmain = mos_rows(p + "P" + k, "p", Ln, nm("3u"), [[pisl(on, ip), pisl(op, inn)]], "VR")
        plc = mos(p + "PLc" + k, "p", L, "12u", 4, 1, on, op, "VR", "VR")
        pld = mos(p + "PLd" + k, "p", L, "12u", 4, 1, op, on, "VR", "VR")
        # tap buffers of this stage's two outputs, right next to it, and the phase drivers
        # (one device per type, one island per output) next to the taps
        bufs_n, bufs_p = [], []
        for o in (op, on):
            bufs_n.append((mos(p + "MBN" + o, "n", "0.28u", "2u", 1, 1, "a" + o, o, "VSS", "VSS"), "XMBN" + o))
            bufs_p.append((mos(p + "MBP" + o, "p", "0.28u", "4u", 1, 1, "a" + o, o, "VR", "VR"), "XMBP" + o))
        Lo = lambda o: "L" + o[1] + o[0].upper()
        disl = lambda o, f, b: dict(strips=[b] + [Lo(o), b] * (f // 2), gates=["a" + o] * f, top="a" + o)
        dn = mos_rows(p + "DN" + k, "n", nm("0.28u"), nm("3u"), [[disl(op, 4, "VSS"), disl(on, 4, "VSS")]], "VSS")
        dp = mos_rows(p + "DP" + k, "p", nm("0.28u"), nm("3u"), [[disl(op, 8, "VR"), disl(on, 8, "VR")]], "VR")
        # divider clock inverter (CK from L1P) / its dummies on the other phases
        ck = lambda o: "CK" if o == "p1" else "ckd" + o
        for o in (op, on):
            bufs_n.append((mos(p + "MCN" + o, "n", "0.28u", "2u", 1, 1, ck(o), Lo(o), "VSS", "VSS"), "XMCN" + o))
            bufs_p.append((mos(p + "MCP" + o, "p", "0.28u", "4u", 1, 1, ck(o), Lo(o), "VR", "VR"), "XMCP" + o))
        nrow[k] = [(nmain, "XN" + k), (nlc, "XNLc" + k), (nld, "XNLd" + k)] + bufs_n + [(dn, "XDN" + k)]
        prow[k] = [(pmain, "XP" + k), (plc, "XPLc" + k), (pld, "XPLd" + k)] + bufs_p + [(dp, "XDP" + k)]
    # one column per stage (N latch/tap row, N main, P main, P latch/tap row: every ring node stays
    # inside its column plus the hop to the next stage); columns in the folded order 1 4 2 3, so
    # every hop spans at most two column pitches
    GAPC = 3000
    seg = lambda items: sum(d.outline[2] - d.outline[0] for d, i in items) + GAPC * (len(items) - 1)
    rows = [[], [], [], []]
    for k in "1423":
        parts = [nrow[k][1:], nrow[k][:1], prow[k][:1], prow[k][1:]]
        w = max(seg(q) for q in parts)
        for r, q in zip(rows, parts):
            r += q + [w - seg(q) + GAPC]
    m.floor(rows, vdd="VR", vss="VSS", gap=GAPC)
    return m


BUILD = {"vga": vga, "vco_core": vco_core}
