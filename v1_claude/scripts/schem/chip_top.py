"""Whole-chip schematic (chip_top: pad frame + digital core + analog macro), wire connected,
and a pad-frame map in physical order.

The connectivity follows chip/src/chip_top.sv, chip_core.sv (incl. the SPI readback pad SDO) and the pad order of
chip/librelane/slots/slot_0p5x0p5.yaml.  The SPI registers are synthesized standard cells (RTL in
chip_core.sv) and are drawn as one block; the analog macro is gnss_afe_analog (its own drawing
in doc/sch_wired/gnss_afe_analog.png).  Logic constants (pad controls) are drawn as tie-high /
tie-low supply symbols.

usage: python3 scripts/schem/chip_top.py   -> doc/sch_wired/chip_top.png/.svg, doc/sch_wired/padframe.png/.svg
"""
import os, re, sys, tempfile
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import wired

ROOT = wired.ROOT
SYM = tempfile.mkdtemp(prefix="chipsym")
wired.SYMDIRS.append(SYM)
SUP4 = dict(DVDD="DVDD", DVSS="DVSS", VDD="VDD", VSS="VSS")
CTL = ["IG1A", "IG1B", "IG2A", "IG2B", "IG3A", "IG3B", "B0", "B1"] + ["AFC%d" % k for k in range(8)] + ["ICP2", "BWK", "BWN"]


def mksym(name, left, right, lines):
    """Box symbol in the xsch.py format: pins (name, dir) on the left / right, text lines inside."""
    n = max(len(left), len(right), len(lines) + 1)
    wch = max([len(p) for p, _ in left + right] + [0])
    tw = max([len(t) for t in lines] + [0])
    hw = max(60, 5 * wch + 3.2 * tw / 2 + 25)
    hw = 10 * round(hw / 10)
    h = 20 * n + 10
    y0 = -10 * (n - 1)
    o = ["v {xschem version=3.4.5 file_version=1.2}", "G {}", 'K {type=subcircuit\nformat="@name @pinlist @symname"\n}',
         "V {}", "S {}", "E {}", "B 4 %d %d %d %d {}" % (-hw, -h / 2 - 5, hw, h / 2 - 5)]
    for side, pins in ((-1, left), (1, right)):
        for k, (p, d) in enumerate(pins):
            y = y0 + 20 * k
            x = side * (hw + 20)
            o.append("B 5 %g %g %g %g {name=%s dir=%s}" % (x - 2.5, y - 2.5, x + 2.5, y + 2.5, p, d))
            o.append("L 4 %g %g %g %g {}" % (x, y, side * hw, y))
            o.append("T {%s} %g %g 0 %d 0.2 0.2 {}" % (p, side * (hw - 5), y - 6, 1 if side > 0 else 0))
    for k, t in enumerate(lines):
        o.append("T {%s} %g %g 0 0 0.16 0.16 {}" % (t, -3.2 * len(t) / 2, y0 + 20 * k + 14))
    open(os.path.join(SYM, name + ".sym"), "w").write("\n".join(o) + "\n")
    return name + ".sym"


def build():
    insts, ports = [], []
    sup = [("DVDD", "inout"), ("DVSS", "inout"), ("VDD", "inout"), ("VSS", "inout")]
    s_in = mksym("pad_in_c", [("PAD", "inout")], [("Y", "out"), ("PU", "in"), ("PD", "in")] + sup,
                 ["gf180mcu_fd_io__in_c", "(CMOS input)"])
    s_ins = mksym("pad_in_s", [("PAD", "inout")], [("Y", "out"), ("PU", "in"), ("PD", "in")] + sup,
                  ["gf180mcu_fd_io__in_s", "(Schmitt input)"])
    s_bo = mksym("pad_bi_out", [("A", "in"), ("OE", "in"), ("SL", "in"), ("CS", "in"), ("IE", "in"), ("PU", "in"), ("PD", "in")],
                 [("PAD", "inout"), ("Y", "out")] + sup, ["gf180mcu_fd_io__bi_24t", "(used as output)"])
    s_bu = mksym("pad_bi_sdo", [("A", "in"), ("OE", "in"), ("SL", "in"), ("CS", "in"), ("IE", "in"), ("PU", "in"), ("PD", "in")],
                 [("PAD", "inout"), ("Y", "out")] + sup, ["gf180mcu_fd_io__bi_24t", "bidir[5] = SDO: driven while", "CS_N is low, else pull-down"])
    s_inv2 = mksym("inv_std2", [("A", "in")], [("Y", "out"), ("VDD", "inout"), ("VSS", "inout")], ["std-cell INV", "(sdo_oe = ~cs_n)"])
    s_as = mksym("pad_asig", [("ASIG5V", "inout")], sup, ["gf180mcu_fd_io__asig_5p0", "(analog, ESD only)"])
    s_dvdd = mksym("pad_dvdd", [], sup, ["gf180mcu_fd_io__dvdd x4", "I/O + core supply pads", "(VDD = DVDD)"])
    s_dvss = mksym("pad_dvss", [], sup, ["gf180mcu_fd_io__dvss x4", "I/O + core ground pads", "(VSS = DVSS)"])
    s_rf = mksym("pad_afe_rf", [("RF", "inout")], [("VDDA", "inout"), ("VDDV", "inout"), ("VSS", "inout")],
                 ["gf180mcu_gnss_io__afe_rf (project pad block)", "VSS VDDA VSS RF VSS | VDDV VSS", "VDDA, VDDV: own ring sections"])
    s_spi = mksym("spi_rtl", [("SCLK", "in"), ("SDI", "in"), ("CS_N", "in"), ("RST_N", "in")],
                  [(c, "out") for c in CTL] + [("SDO", "out"), ("VDD", "inout"), ("VSS", "inout")],
                  ["chip_core.sv: SPI registers", "(synthesized std cells)", "24-bit shift reg, mode 0", "19-bit latch on CS_N rise",
                   "reset: AFC7=1, others 0", "readback on SDO:", "ID 10101 + ctl[18:0],", "changes on SCLK fall"])
    s_inv = mksym("inv_std", [("A", "in")], [("Y", "out"), ("VDD", "inout"), ("VSS", "inout")], ["std-cell INV", "(~q_sign)"])

    def P(name, d):
        ports.append((name, d))
        return name

    insts.append(("clk_pad", s_ins, {}, dict(PAD=P("SCLK clk_PAD", "in"), Y="sclk", PU="VSS", PD="VSS", **SUP4)))
    insts.append(("rst_n_pad", s_in, {}, dict(PAD=P("RST_N rst_n_PAD", "in"), Y="rst_n", PU="VSS", PD="VSS", **SUP4)))
    insts.append(("inputs[0].pad", s_in, {}, dict(PAD=P("SDI input_PAD[0]", "in"), Y="sdi", PU="VSS", PD="VSS", **SUP4)))
    insts.append(("inputs[1].pad", s_in, {}, dict(PAD=P("CS_N input_PAD[1]", "in"), Y="cs_n", PU="VDD", PD="VSS", **SUP4)))
    outs = [("i_sign", "I_SIGN"), ("i_mag", "I_MAG"), ("q_sign_n", "Q_SIGN"), ("q_mag", "Q_MAG"), ("clkout", "CLKOUT")]
    for k, (net, nm) in enumerate(outs):
        insts.append(("bidir[%d].pad" % k, s_bo, {}, dict(A=net, OE="VDD", SL="VDD", CS="VSS", IE="VSS", PU="VSS", PD="VSS",
                                                         PAD=P("%s bidir_PAD[%d]" % (nm, k), "out"), Y="bidir%d_y" % k, **SUP4)))
    insts.append(("bidir[5].pad", s_bu, {}, dict(A="sdo", OE="sdo_oe", SL="VDD", CS="VSS", IE="VSS", PU="VSS", PD="VDD",
                                                PAD=P("SDO bidir_PAD[5]", "out"), Y="bidir5_y", **SUP4)))
    insts.append(("i_oeinv", s_inv2, {}, dict(A="cs_n", Y="sdo_oe", VDD="VDD", VSS="VSS")))
    for k, (nm, d) in enumerate((("REFIN", "in"), ("AFCOUT", "out"), ("VCTRL", "out"))):
        insts.append(("analog[%d].pad" % k, s_as, {}, dict(ASIG5V=P("%s analog_PAD[%d]" % (nm, k), d), **SUP4)))
    insts.append(("nc[28:0].pad", s_as, {}, dict(ASIG5V=P("NC nc_PAD[28:0] (unused pads)", "in"), **SUP4)))
    insts.append(("afe_rf_pad", s_rf, {}, dict(RF=P("RFIN rf_PAD", "in"), VDDA="VDDA", VDDV="VDDV", VSS="VSS")))
    insts.append(("dvdd_pads[2:0]+vdd_pads[0]", s_dvdd, {}, dict(**SUP4)))
    insts.append(("dvss_pads[2:0]+vss_pads[0]", s_dvss, {}, dict(**SUP4)))
    insts.append(("i_spi", s_spi, {}, dict(SCLK="sclk", SDI="sdi", CS_N="cs_n", RST_N="rst_n", SDO="sdo", VDD="VDD", VSS="VSS",
                                         **{c: "ctl_" + c for c in CTL})))
    insts.append(("i_qinv", s_inv, {}, dict(A="q_sign", Y="q_sign_n", VDD="VDD", VSS="VSS")))
    afe = dict(RFIN="RFIN rf_PAD", REFIN="REFIN analog_PAD[0]", I_SIGN="i_sign", I_MAG="i_mag", Q_SIGN="q_sign",
               Q_MAG="q_mag", CLKOUT="clkout", AFCOUT="AFCOUT analog_PAD[1]", VCTRL="VCTRL analog_PAD[2]",
               VDD="VDDA", VDDV="VDDV", VSS="VSS", **{c: "ctl_" + c for c in CTL})
    insts.append(("i_afe", "gnss_afe_analog.sym", {}, afe))
    return insts, ports


def padframe():
    """Physical pad order (slot_0p5x0p5.yaml) drawn as the ring around the die."""
    y = open(os.path.join(ROOT, "chip", "librelane", "slots", "slot_0p5x0p5.yaml")).read()
    sides = {}
    for side in ("SOUTH", "EAST", "NORTH", "WEST"):
        body = re.search(r"PAD_%s: \[(.*?)\n\]" % side, y, re.S).group(1)
        sides[side] = [s.strip().strip('"').replace("\\\\", "").replace(".pad", "") for s in body.split(",") if s.strip()]
    fn = {"clk_pad": ("SCLK", "in_s"), "rst_n_pad": ("RST_N", "in_c"), "inputs[0]": ("SDI", "in_c"), "inputs[1]": ("CS_N", "in_c"),
          "bidir[0]": ("I_SIGN", "bi_24t"),
          "bidir[1]": ("I_MAG", "bi_24t"), "bidir[2]": ("Q_SIGN", "bi_24t"), "bidir[3]": ("Q_MAG", "bi_24t"),
          "bidir[4]": ("CLKOUT", "bi_24t"), "bidir[5]": ("SDO", "bi_24t"), "analog[0]": ("REFIN", "asig_5p0"), "analog[1]": ("AFCOUT", "asig_5p0"),
          "analog[2]": ("VCTRL", "asig_5p0"), "afe_rf.VDDV": ("VDDV", "afe_rf"), "afe_rf.VDDA": ("VDDA", "afe_rf"),
          "afe_rf.RF": ("RFIN", "afe_rf"), "afe_rf.VSS": ("VSS", "afe_rf")}
    k = sides["NORTH"].index("afe_rf_pad")          # the block holds six pads on the frame pitch
    sides["NORTH"][k:k + 1] = ["afe_rf." + n for n in ("VDDV", "VSS", "VDDA", "VSS", "RF", "VSS")]

    def info(p):
        if p in fn:
            return fn[p]
        if p.startswith("nc["):
            return ("NC", "asig_5p0")
        if p.startswith(("dvdd", "vdd")):
            return ("DVDD", "dvdd")
        return ("DVSS", "dvss")
    col = {"in_s": "#2e86c1", "in_c": "#2e86c1", "bi_24t": "#28b463", "asig_5p0": "#ca6f1e", "afe_rf": "#c0392b",
           "dvdd": "#7d3c98", "dvss": "#566573"}
    Wd, Hd = 1936, 2531                      # die (um); drawing scale 0.5 unit/um
    s = 0.5
    PW, PH = 75 * s * 2.2, 350 * s * 0.5     # pad cell outline in the drawing (not to scale across)
    o = ['<svg xmlns="http://www.w3.org/2000/svg" width="%d" height="%d" font-family="DejaVu Sans, Arial, sans-serif">'
         % (Wd * s + 700, Hd * s + 260), '<rect width="100%" height="100%" fill="white"/>',
         '<text x="20" y="34" font-size="24" font-weight="bold">chip_top pad frame (slot 0p5x0p5, 1936 x 2531 um, physical order)</text>',
         '<text x="20" y="56" font-size="12" fill="#444">Ring: DVDD / DVSS (I/O), VDD = DVDD, VSS = DVSS (core); the afe_rf block breaks '
         'the DVDD and VDD rings so that VDDA and VDDV get their own sections.</text>',
         '<text x="20" y="72" font-size="12" fill="#444">Corners: gf180mcu_fd_io__cor x4; gaps: fill1/5/10/nc. '
         'NC = unused pad (asig_5p0 cell, no core connection); all 56 pads sit at the template bond positions.</text>']
    X0, Y0 = 350, 120
    o.append('<rect x="%g" y="%g" width="%g" height="%g" fill="#fbfbfb" stroke="#333" stroke-width="2"/>' % (X0, Y0, Wd * s, Hd * s))
    cx0, cy0, cx1, cy1 = 442 * s + X0, (Hd - 2089) * s + Y0, 1494 * s + X0, (Hd - 442) * s + Y0
    o.append('<rect x="%g" y="%g" width="%g" height="%g" fill="#f4f7fc" stroke="#1f3a93" stroke-dasharray="6 4"/>' % (cx0, cy0, cx1 - cx0, cy1 - cy0))
    MW, MH = 1029.8, 1539.4
    mx0, my0 = X0 + 452 * s, Y0 + (Hd - 522.2 - MH) * s
    o.append('<rect x="%g" y="%g" width="%g" height="%g" fill="#eaf2e3" stroke="#1e7b34" stroke-width="1.5"/>' % (mx0, my0, MW * s, MH * s))
    o.append('<text x="%g" y="%g" font-size="16" text-anchor="middle" fill="#1e7b34" font-weight="bold">gnss_afe_analog</text>' % (mx0 + MW * s / 2, my0 + 30))
    o.append('<text x="%g" y="%g" font-size="12" text-anchor="middle" fill="#1e7b34">%.1f x %.1f um</text>' % (mx0 + MW * s / 2, my0 + 48, MW, MH))
    o.append('<text x="%g" y="%g" font-size="13" text-anchor="middle" fill="#1f3a93">core: SPI registers (std cells)</text>' % ((cx0 + cx1) / 2, my0 + MH * s + 25))
    d = 70                                   # ring band
    for side, pads in sides.items():
        n = len(pads)
        for k, p in enumerate(pads):
            f, t = info(p)
            c = col[t]
            if side in ("SOUTH", "NORTH"):
                span = Wd * s - 2 * d
                x = X0 + d + span * (k + 0.5) / n if side == "SOUTH" else X0 + d + span * (k + 0.5) / n
                yb = Y0 + Hd * s - d if side == "SOUTH" else Y0
                w = min(span / n * 0.9, 60)
                o.append('<rect x="%g" y="%g" width="%g" height="%g" fill="%s" fill-opacity="0.25" stroke="%s"/>' % (x - w / 2, yb, w, d, c, c))
                ty = yb + d + 16 if side == "SOUTH" else yb - 8
                o.append('<text x="%g" y="%g" font-size="11" text-anchor="middle" fill="%s" font-weight="bold">%s</text>' % (x, ty, c, f))
                o.append('<text x="%g" y="%g" font-size="9" text-anchor="middle" fill="#333">%s</text>' % (x, ty + (12 if side == "SOUTH" else -13), p))
            else:
                span = Hd * s - 2 * d
                yy = Y0 + Hd * s - d - span * (k + 0.5) / n          # both lists run south to north
                xb = X0 + Wd * s - d if side == "EAST" else X0
                h = min(span / n * 0.9, 40)
                o.append('<rect x="%g" y="%g" width="%g" height="%g" fill="%s" fill-opacity="0.25" stroke="%s"/>' % (xb, yy - h / 2, d, h, c, c))
                if side == "EAST":
                    o.append('<text x="%g" y="%g" font-size="11" fill="%s" font-weight="bold">%s</text>' % (xb + d + 8, yy + 4, c, f))
                    o.append('<text x="%g" y="%g" font-size="9" fill="#333">%s</text>' % (xb + d + 70, yy + 4, p))
                else:
                    o.append('<text x="%g" y="%g" font-size="11" text-anchor="end" fill="%s" font-weight="bold">%s</text>' % (xb - 8, yy + 4, c, f))
                    o.append('<text x="%g" y="%g" font-size="9" text-anchor="end" fill="#333">%s</text>' % (xb - 60, yy + 4, p))
    for x, yv in ((X0, Y0), (X0 + Wd * s - d, Y0), (X0, Y0 + Hd * s - d), (X0 + Wd * s - d, Y0 + Hd * s - d)):
        o.append('<rect x="%g" y="%g" width="%g" height="%g" fill="#999" fill-opacity="0.4" stroke="#555"/>' % (x, yv, d, d))
    ly = Y0 + Hd * s + 60
    for k, (t, c) in enumerate(col.items()):
        o.append('<rect x="%g" y="%g" width="16" height="12" fill="%s" fill-opacity="0.25" stroke="%s"/>' % (40 + 150 * k, ly, c, c))
        o.append('<text x="%g" y="%g" font-size="12">%s</text>' % (62 + 150 * k, ly + 11, t))
    o.append("</svg>")
    svg = "\n".join(o)
    open(os.path.join(wired.OUT, "padframe.svg"), "w").write(svg)
    import cairosvg
    cairosvg.svg2png(bytestring=svg.encode(), write_to=os.path.join(wired.OUT, "padframe.png"), scale=1.5, background_color="white")


if __name__ == "__main__":
    insts, ports = build()
    bad, n, W, H = wired.render(
        "chip_top", "GNSS AFE chip_top: pad frame + digital core (SPI) + analog macro gnss_afe_analog", ports, insts,
        notes=["Pads: gf180mcu_fd_io (wafer.space slot 0p5x0p5) + project pad block gf180mcu_gnss_io__afe_rf; "
               "pad order: doc/sch_wired/padframe.png. Tie-high / tie-low = logic 1 / 0 from the core.",
               "Chip pins are named <function> <chip_top port>. The analog macro is drawn in gnss_afe_analog.png and below it every cell."],
        opts={"elk.direction": "RIGHT"})
    print("chip_top", n, W, H, "OK" if not bad else bad[:5])
    padframe()
