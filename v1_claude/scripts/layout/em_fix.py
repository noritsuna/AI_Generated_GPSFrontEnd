"""Hand-made straps for the DC paths that carry more current than the router's k x k wires and
single-point pin entries can take (electromigration, GF180MCU DRM 14.2: M1-M4 2.09 mA/um and
0.58 mA per via at 85 C; 1.0 mA/um and 0.28 mA at 110 C).

A hook is called from Module.floor() once the devices, rails and spines are placed.  It draws M3 /
M4 straps with full via arrays over the device bars and resistor pads (Module.em_* helpers); the
pins it wires are not routed again and the straps of a signal net become one router terminal, so
the router only adds the remaining (AC / bias) branches.  Any M3 strap stays below 10 um width
(wide-metal spacing)."""

GAP = 400          # between straps of different nets


def _rails(m, net):
    return [r for n, l, r in m.supply_pins if n == net and l == "metal4"]


def _below(rails, y):
    return max((r for r in rails if r[3] <= y), key=lambda r: r[1])


def _above(rails, y):
    return min((r for r in rails if r[1] >= y), key=lambda r: r[1])


def _tx(m, inst, r):
    from module import tx_rect
    dev, _, x, y, o, nm = m.em_dev(inst)
    return tx_rect(o, x, y, r)


def lna_nc(m):
    """M1 (common gate, 3.1 mA): RS -> RFIN -> M1 -> op_i -> R1 -> VDD;
    M2 (common source, 13.2 mA): VSS -> M2 -> on_i -> R2 -> VDD."""
    vdd, vss = _rails(m, "VDD"), _rails(m, "VSS")
    # ---------------- M1 branch
    rf = m.em_pins("XM1", "RFIN")[0]; op = m.em_pins("XM1", "op_i")[0]
    rs_b = m.em_pins("XR10u_0", "RFIN")[0]; rs_t = m.em_pins("XR10u_0", "VSS")[-1]
    r1_b = m.em_pins("XR10u_0", "op_i")[0]; r1_t = m.em_pins("XR10u_0", "VDD")[0]
    assert rs_b[1] < rs_t[1] and r1_b[1] < r1_t[1]
    # RFIN: M3 strip doubling the source bar, one tooth at its west end up to the RS pad
    s = m.em_metal("RFIN", "m3", (rf[0], rf[1], rf[2], rf[3] - 60))
    m.em_via("v2", rf, s)
    m.em_metal("RFIN", "m3", (rf[0], rf[1], rf[0] + 2800, rs_b[3]))
    s = m.em_metal("RFIN", "m3", (rs_b[0], rs_b[1] - 1000, rs_b[2], rs_b[3]))
    m.em_via("v2", rs_b, s)
    # op_i: tooth over the east part of the drain bar up to the R1 pad (the gap between the
    # two teeth leaves the gate bar reachable)
    x2 = min(op[2], r1_b[2] - 200)
    s = m.em_metal("op_i", "m3", (x2 - 9800, op[1], x2, r1_b[3]))
    m.em_via("v2", op, s)
    s = m.em_metal("op_i", "m3", (r1_b[0], r1_b[1] - 1000, r1_b[2], r1_b[3]))
    m.em_via("v2", r1_b, s)
    # R1 top pad -> VDD rail above
    rl = _above(vdd, r1_t[3])
    s = m.em_metal("VDD", "m3", (r1_t[0] + 100, r1_t[1], r1_t[2] - 100, rl[3]), group=False)
    m.em_via("v2", r1_t, s)
    m.em_via("v3", s, rl, enc=100)
    # RS top pad -> M3 plate -> M4 strap down over the resistor to the VSS rail
    rl = _below(vss, rs_t[1])
    s = m.em_metal("VSS", "m3", (rs_t[0], rs_t[1], rs_t[2], rs_t[3] + 1500), group=False)
    m.em_via("v2", rs_t, s)
    s4 = m.em_metal("VSS", "m4", (rs_t[0], rl[1], rs_t[2], rs_t[3] + 1500), group=False)
    m.em_via("v3", s, s4, enc=100)
    # ---------------- M2 branch: comb of VSS teeth (from the rail below) and on_i teeth (to a
    # collector bar above the upper drain bar) over the two finger rows
    on = m.em_pins("XM2", "on_i")
    dev = m.em_dev("XM2")[0]
    bulk = sorted((_tx(m, "XM2", b) for b in dev.bulk_bars), key=lambda r: r[1])
    rbot = _tx(m, "XM2", dev.ring["bot"])
    assert len(on) == 2 and len(bulk) == 2 and bulk[0][1] < on[0][1] < bulk[1][1] < on[1][1]
    m.em_nobulk.add("XM2")
    r2_b = m.em_pins("XR30u_0", "on_i")[0]; r2_t = m.em_pins("XR30u_0", "VDD")[0]
    rl = _below(vss, rbot[1])
    X0 = on[0][0] + 2300                    # west end stays free: access to the gate bars
    X1 = on[0][2]
    n = 12
    w = ((X1 - X0) - (n - 1) * GAP) // n // 5 * 5
    col = (X0, on[1][1] + 60, X0 + n * w + (n - 1) * GAP, on[1][1] + 60 + 7000)
    # the VSS rail takes 13.2 mA here: widened over the device (M4)
    pt = m.em_rail("VSS", (X0 - 4000, rl[3], X1 + 9500, rl[3] + 6000))
    for q in range(n):
        x = X0 + q * (w + GAP)
        if q % 2 == 0:
            s = m.em_metal("on_i", "m3", (x, on[0][1], x + w, col[3]))
            m.em_via("v2", on[0], s)
        else:
            s = m.em_metal("VSS", "m3", (x, rl[1], x + w, bulk[1][3] - 60), group=False)
            for b in bulk + [rbot]:
                m.em_via("v2", b, s)
            m.em_via("v3", s, (pt[0], rl[1], pt[2], pt[3]), enc=100)
    s = m.em_metal("on_i", "m3", col)
    m.em_via("v2", on[1], s)
    # two link straps (< 10 um each) up to the R2 pad, and from its top pad to the VDD rail
    a, b = r2_b[0] + 200, r2_b[2] - 200
    ws = (b - a - 1000) // 2 // 5 * 5
    xs = [(a, a + ws), (b - ws, b)]
    rl = _above(vdd, r2_t[3])
    pt = m.em_rail("VDD", (a - 2000, rl[1] - 5000, b + 1200, rl[1]))
    for xa, xb in xs:
        m.em_metal("on_i", "m3", (xa, col[1], xb, r2_b[3]))
        s = m.em_metal("VDD", "m3", (xa, r2_t[1], xb, rl[3]), group=False)
        m.em_via("v3", s, (pt[0], pt[1], pt[2], rl[3]), enc=100)
    s = m.em_metal("on_i", "m3", (r2_b[0], r2_b[1], r2_b[2], r2_b[3]))
    m.em_via("v2", r2_b, s)
    s = m.em_metal("VDD", "m3", (r2_t[0], r2_t[1], r2_t[2], r2_t[3]), group=False)
    m.em_via("v2", r2_t, s)


def mixer_iq(m):
    """IF load resistors (1 mA each): VDD -> RL -> IFxx.  The four VDD pads go straight up to the VDD
    rail on their own M3 straps; every IF pad gets an M3 plate the router enters at full width."""
    vdd = _rails(m, "VDD")
    for p in sorted(m.em_pins("XR4u_0", "VDD")):
        rl = _above(vdd, p[3])
        s = m.em_metal("VDD", "m3", (p[0] + 100, p[1], p[2] - 100, rl[3]), group=False)
        m.em_via("v2", p, s)
        m.em_via("v3", s, rl, enc=100)
    for net in ("IFIP", "IFIN", "IFQP", "IFQN"):
        p = m.em_pins("XR4u_0", net)[0]
        # (the outer two stay 0.3 um clear of the ring tap straps at the bar ends)
        s = m.em_metal(net, "m3", (p[0] + 140 * (net == "IFIP"), p[3] - 2000, p[2] - 140 * (net == "IFQN"), p[3]))
        m.em_via("v2", p, s)


def vco_ring4(m):
    """Ring supply VR (3.5 mA): the two 0.42 um drain bars of the current source take it from
    390 um of fingers.  Six M3 teeth across both bars and an M4 collector over them split the bar
    current into 12 short sections; the router continues from the collector."""
    lo, hi = m.em_pins("XMPD_MPO_MPB0_MPB1", "VR")
    n, w = 10, 1500
    step = (lo[2] - lo[0]) // n
    xs = [(lo[0] + step // 2 + q * step - w // 2) // 5 * 5 for q in range(n)]
    ym = (lo[3] + hi[1]) // 2 // 5 * 5
    col = m.em_metal("VR", "m4", (xs[0], ym - 1800, xs[-1] + w, ym + 1800))
    for x in xs:
        s = m.em_metal("VR", "m3", (x, lo[1], x + w, hi[3]))
        m.em_via("v2", lo, s)
        m.em_via("v2", hi, s)
        m.em_via("v3", s, col, enc=100)


HOOK = {"lna_nc": lna_nc, "mixer_iq": mixer_iq, "vco_ring4": vco_ring4}
