"""odbpy: straps afe_rf_pad (VDDA / VDDV / VSS / RF) -> i_chip_core.i_afe (VDDA / VDDV / VSS / RFIN) on Metal2."""
import odb
from reader import click_odb, click

PAD, MACRO = "afe_rf_pad", "i_chip_core.i_afe"
PAIRS = [("VDDA", "VDDA"), ("VDDV", "VDDV"), ("VSS", "VSS"), ("RF", "RFIN")]
SIGS = [("analog[2].pad", "VCTRL"), ("analog[1].pad", "AFCOUT"), ("analog[0].pad", "REFIN")]


def boxes(inst, pin, layer):
    t = inst.getTransform()
    out = []
    for mp in inst.getMaster().findMTerm(pin).getMPins():
        for b in mp.getGeometry():
            if b.getTechLayer().getName() != layer:
                continue
            # transform both corners as Points (this OpenROAD's dbTransform.apply rejects a Python-built Rect)
            p1, p2 = odb.Point(b.xMin(), b.yMin()), odb.Point(b.xMax(), b.yMax())
            t.apply(p1); t.apply(p2)
            out.append(odb.Rect(min(p1.x(), p2.x()), min(p1.y(), p2.y()), max(p1.x(), p2.x()), max(p1.y(), p2.y())))
    return out


@click.command()
@click_odb
def main(reader):
    block = reader.block
    m2 = reader.tech.findLayer("Metal2")
    pad = block.findInst(PAD)
    mac = block.findInst(MACRO)
    rows = list(block.getRows())
    y0 = min(r.getOrigin()[1] for r in rows)
    rh = rows[0].getSite().getHeight()

    def row_above(y):
        k = -(-(y - y0) // rh)
        return y0 + k * rh
    if pad is None or mac is None:
        raise SystemExit("[ERROR] %s or %s not found" % (PAD, MACRO))
    for ppin, mpin in PAIRS:
        net = pad.findITerm(ppin).getNet()
        if net is None or mac.findITerm(mpin).getNet() is None or \
                net.getName() != mac.findITerm(mpin).getNet().getName():
            raise SystemExit("[ERROR] %s/%s and %s/%s are not on one net" % (PAD, ppin, MACRO, mpin))
        pb = boxes(pad, ppin, "Metal2")
        ymin = min(r.yMin() for r in pb)
        pb = [r for r in pb if r.yMin() == ymin]          # core-facing edge of the pad
        mb = boxes(mac, mpin, "Metal2")
        if not net.isSpecial():
            net.setSpecial()
        sw = odb.dbSWire_create(net, "ROUTED")
        n = 0
        for p in pb:
            for q in mb:
                x1, x2 = max(p.xMin(), q.xMin()), min(p.xMax(), q.xMax())
                if x2 - x1 <= 0 or q.yMax() > p.yMin():
                    continue
                # detailed placement marks every placement-grid pixel a vertical special wire
                # touches as blocked (rounded outwards) and fails a macro under it (DPL-0010):
                # the vertical strap starts at the first row boundary above the macro, a short
                # box (wider than tall, i.e. horizontal) bridges the macro edge to it
                yb = row_above(q.yMax())
                odb.dbSBox_create(sw, m2, x1, yb, x2, p.yMax(), "STRIPE")
                if yb > q.yMax():
                    assert yb - q.yMax() < x2 - x1, "bridge would not be horizontal"
                    odb.dbSBox_create(sw, m2, x1, q.yMax(), x2, yb, "STRIPE")
                n += 1
        print("strap %s: %d Metal2 boxes (pad %d pins, macro %d pins)" % (net.getName(), n, len(pb), len(mb)))
        if n == 0:
            raise SystemExit("[ERROR] no strap for %s" % net.getName())
    # analog signal pads (asig_5p0) -> macro pins: the template keeps the analog pad nets special,
    # so the signal router leaves them alone; straight straps, or a dogleg when the pad lies
    # beyond the macro pin (REFIN: pad east of the macro's right edge)
    insts = {i.getName().replace("\\", ""): i for i in block.getInsts()}
    for pname, mpin in SIGS:
        ap = insts.get(pname)
        if ap is None:
            raise SystemExit("[ERROR] pad %s not found" % pname)
        net = ap.findITerm("ASIG5V").getNet()
        if net is None or mac.findITerm(mpin).getNet() is None or \
                net.getName() != mac.findITerm(mpin).getNet().getName():
            raise SystemExit("[ERROR] %s/ASIG5V and %s/%s are not on one net" % (pname, MACRO, mpin))
        pb = boxes(ap, "ASIG5V", "Metal2")
        ymin = min(r.yMin() for r in pb)
        pb = [r for r in pb if r.yMin() == ymin]
        q = boxes(mac, mpin, "Metal2")[0]
        if not net.isSpecial():
            net.setSpecial()
        sw = odb.dbSWire_create(net, "ROUTED")
        yb = row_above(q.yMax())
        over = [p for p in pb if min(p.xMax(), q.xMax()) - max(p.xMin(), q.xMin()) > 0]
        if over:
            x1, x2 = max(over[0].xMin(), q.xMin()), min(over[0].xMax(), q.xMax())
            odb.dbSBox_create(sw, m2, x1, yb, x2, over[0].yMax(), "STRIPE")
            odb.dbSBox_create(sw, m2, x1, q.yMax(), x2, yb, "STRIPE")
            print("strap %s: straight" % net.getName())
            continue
        # dogleg: horizontal leg (as tall as the pin is wide) just above the macro, then up
        p = min(pb, key=lambda r: abs((r.xMin() + r.xMax()) // 2 - (q.xMin() + q.xMax()) // 2))
        w = q.xMax() - q.xMin()
        yh = yb + 2 * rh
        odb.dbSBox_create(sw, m2, q.xMin(), q.yMax(), q.xMax(), yh, "STRIPE")        # wider than tall
        odb.dbSBox_create(sw, m2, min(q.xMin(), p.xMin()), yh, max(q.xMax(), p.xMax()), yh + w, "STRIPE")
        odb.dbSBox_create(sw, m2, p.xMin(), yh + w, p.xMax(), p.yMax(), "STRIPE")
        print("strap %s: dogleg (pad pin x %d..%d, macro pin x %d..%d)" % (net.getName(), p.xMin(), p.xMax(), q.xMin(), q.xMax()))
    # the top-level RF port: the padring step only places ports of the foundry pad cells, so pin
    # rf_PAD on the RF pad opening (Metal5 geometry of the block's RF pin)
    net = pad.findITerm("RF").getNet()
    m5 = reader.tech.findLayer("Metal5")
    for bt in net.getBTerms():
        if bt.getBPins():
            continue
        opening = max(boxes(pad, "RF", "Metal5"), key=lambda r: r.dx() * r.dy())
        bp = odb.dbBPin_create(bt)
        odb.dbBox_create(bp, m5, opening.xMin(), opening.yMin(), opening.xMax(), opening.yMax())
        bp.setPlacementStatus("FIRM")
        print("port %s placed on the RF pad opening %s" % (bt.getName(), opening))


if __name__ == "__main__":
    main()
