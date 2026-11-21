"""Final check, part 2: DC operating point of every FET of the static analog blocks (subcircuits of the tb_full netlist, schematic) at three corners:
Vgs, Vds, Vdsat, Id, gm, saturation margin |Vds| - |Vdsat|, gm/Id, current density, and the DC node voltages.
The oscillating / clocked blocks (VCO core, dividers, PFD, comparators, logic) are checked by final_stress.py.
  tt  typical 27 C 3.3 V     ss  ss 85 C 3.135 V     ff  ff -20 C 3.465 V
The blocks are instantiated at the top of an own deck (see deck()).
usage: final_op.py  -> layout/review/final/op.log (stdout)"""
import os, sys, re
from concurrent.futures import ThreadPoolExecutor
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))
os.environ.setdefault("PDK", "gf180mcuD"); os.environ.setdefault("PDK_ROOT", os.path.expanduser("~/pdk"))
import run
from review.final_devices import subckts, LMIN, num

CORNERS = {"tt": ("typical", 27, 3.3), "ss": ("ss", 85, 3.135), "ff": ("ff", -20, 3.465)}
SKIP = ("decap", "spi_regs", "afc_dac", "adc2b", "refbuf", "vco_core", "div48", "divbuf", "pfd", "inv_dig", "nand2", "nor2", "inv_lo1", "inv_lo2")
# devices that are switches / MOS capacitors / start-up devices by design: listed, not judged for saturation
SWITCH = re.compile(r"\.(xmctl\w+|xmsa|xmsb|xmsw[pn]|xmsn[pn]|xmsp|xmsn|xmsu|xmps2?|xmpd2?|xmns2?|xmnd2?|xmpe2|xmne2|xmsb[01]|xml[ab][pn][iq]|xmu\d[pn][iq])$")


def flatten(d, sc, path, out):
    for name, nodes, kind, p in d[sc]:
        q = path + "." + name.lower()
        if kind in LMIN:
            out.append((q, sc, kind, num(p["W"]) * 1e6 * int(float(p.get("m", 1))), num(p["L"]) * 1e6))
        elif kind in d and kind not in SKIP:
            flatten(d, kind, q, out)


def deck(text, corner, fets):
    """Static blocks only (the whole chip has no DC solution: ring oscillator and latches). LO pins at 0 V (AC coupled
    inside the mixer, so the switch gates sit at their bias); the charge pump three times with both currents on, ICP2 = 1,
    and its output forced to 0.6 / 1.7 / 2.6 V (xcpa..c), and three times idle (both currents steered to the replica node vd)
    with the output at 1.2 / 1.7 / 2.5 V (xcpd..f: vd must follow the output)."""
    lib, temp, v = CORNERS[corner]
    libs = "\n".join(l for l in text.splitlines() if l.strip().startswith((".include", ".lib")))
    if lib != "typical":
        libs, k = re.subn(r"(sm141064\.ngspice) (res_|mimcap_)?typical", lambda m: "%s %s%s" % (m.group(1), m.group(2) or "", lib), libs)
        assert k == 3
    body = text[text.index("* expanding   symbol:  gnss_afe_top.sym"):text.rindex(".end")]
    t = """* final check: DC operating point of the static analog blocks
VDD vdd 0 %g
VLO lo 0 0
VG0 g0 0 0
VCT vct 0 1.7
XBIAS nb pb vdd 0 bias_gen
XLNA rfin pb rfp rfn vdd 0 lna_nc
XMIX rfp rfn lo lo lo lo lo lo lo lo nb mip min mqp mqn vdd 0 mixer_iq
XIFI mip min g0 g0 g0 g0 g0 g0 pb vdd g0 aip ain vdd 0 if_chain
XMON vct nb vmon vdd 0 vmon_buf
VCA oa 0 0.6
VCB ob 0 1.7
VCC oc 0 2.6
XCPA g0 vdd g0 pb nb vdd oa vdd 0 cp
XCPB g0 vdd g0 pb nb vdd ob vdd 0 cp
XCPC g0 vdd g0 pb nb vdd oc vdd 0 cp
VCD od 0 1.2
VCE oe 0 1.7
VCF of 0 2.5
XCPD vdd g0 vdd pb nb vdd od vdd 0 cp
XCPE vdd g0 vdd pb nb vdd oe vdd 0 cp
XCPF vdd g0 vdd pb nb vdd of vdd 0 cp
%s
.temp %g
.option gmin=1e-12
""" % (v, libs, temp)
    ctl = ".control\nset num_threads=1\nop\n"
    for q, *_ in fets:
        ctl += "echo FET %s $&@m.%s.m0[vgs] $&@m.%s.m0[vds] $&@m.%s.m0[vdsat] $&@m.%s.m0[id] $&@m.%s.m0[gm] $&@m.%s.m0[vth]\n" % ((q,) + (q,) * 6)
    for n in NODES:
        ctl += "echo NODE %s $&v(%s)\n" % (n, n)
    ctl += "let itot = -i(VDD)\necho NODE i(VDD) $&itot\nlet ia = i(VCA)\nlet ib = i(VCB)\nlet ic = i(VCC)\n"
    ctl += "echo NODE icp_net_0.6V $&ia\necho NODE icp_net_1.7V $&ib\necho NODE icp_net_2.6V $&ic\n.endc\n"
    return t + ctl + body + ".end\n"


NODES = ["vdd", "nb", "pb", "rfin", "xlna.vb1", "xlna.vb2", "xlna.g2", "xlna.op_i", "xlna.on_i", "xmix.vbrf", "xmix.vlou", "xmix.vlol", "xmix.ti",
         "xmix.xpi", "xmix.mpai", "mip", "min", "mqp", "xifi.nbif", "xifi.pbif", "xifi.xbif.vdiv", "xifi.xbif.x", "xifi.xbif.og", "xifi.xv1.vcm",
         "xifi.xv1.s1", "xifi.a1p", "xifi.a1n", "xifi.f1p", "xifi.a2p", "xifi.f2p", "xifi.a3p", "xifi.a4p", "aip", "ain", "vmon",
         "xcpa.pc", "xcpa.nc", "xcpa.vd", "xcpb.pc", "xcpb.nc", "xcpb.vd", "xcpc.pc", "xcpc.nc", "xcpc.vd",
         "xcpd.vd", "xcpd.pc", "xcpd.nc", "xcpe.vd", "xcpe.pc", "xcpe.nc", "xcpf.vd", "xcpf.pc", "xcpf.nc"]
TOP = (("xbias", "bias_gen"), ("xlna", "lna_nc"), ("xmix", "mixer_iq"), ("xifi", "if_chain"), ("xmon", "vmon_buf"),
       ("xcpa", "cp"), ("xcpb", "cp"), ("xcpc", "cp"), ("xcpd", "cp"), ("xcpe", "cp"), ("xcpf", "cp"))


def main():
    text = open(run.netlist("tb_full")).read()
    d = subckts(text)
    fets = []
    for inst, sc in TOP:
        flatten(d, sc, inst, fets)
    with ThreadPoolExecutor(3) as ex:
        logs = dict(zip(CORNERS, ex.map(lambda c: run.ngspice(deck(text, c, fets), "final_op_" + c, timeout=20000), CORNERS)))
    res, nodes = {}, {}
    for c, log in logs.items():
        res[c] = {l.split()[1]: [float(x) for x in l.split()[2:]] for l in log.splitlines() if l.startswith("FET ")}
        nodes[c] = {l.split()[1]: float(l.split()[2]) for l in log.splitlines() if l.startswith("NODE ")}
        if len(res[c]) != len(fets):
            print("!! %s: %d of %d FETs read; last lines:\n%s" % (c, len(res[c]), len(fets), "\n".join(log.splitlines()[-8:])))
    print("== DC node voltages (V; i(VDD) in A)  tt / ss / ff")
    for n in nodes["tt"]:
        print("  %-22s %s" % (n, "  ".join("%9.4g" % nodes[c].get(n, float("nan")) for c in CORNERS)))
    print("== FETs: per corner Vgs Vds Vdsat (V), Id (uA), gm/Id (1/V), margin |Vds|-|Vdsat| (V); * = switch / MOS cap / start-up (not judged)")
    flag = []
    for q, sc, kind, w, l in fets:
        sw = bool(SWITCH.search(q))
        s = "  %-28s %s %6.1f/%-4.2f%s" % (q, kind[0], w, l, "*" if sw else " ")
        for c in CORNERS:
            vgs, vds, vdsat, i, gm, vth = res[c].get(q, [float("nan")] * 6)
            mar = abs(vds) - abs(vdsat)
            s += " | %5.2f %5.2f %4.2f %8.1f %4.1f %5.2f" % (vgs, vds, vdsat, abs(i) * 1e6, gm / abs(i) if abs(i) > 1e-9 else 0, mar)
            if not sw and abs(i) > 1e-7 and mar < 0.1:
                flag.append((q, c, mar, abs(i) * 1e6))
            if max(abs(vgs), abs(vds), abs(vgs - vds)) > CORNERS[c][2] * 1.0 + 0.01:
                flag.append((q, c, "over-voltage", max(abs(vgs), abs(vds), abs(vgs - vds))))
        print(s)
    print("== conducting bias / signal FETs with saturation margin below 0.1 V, or a terminal pair above VDD: %d" % len(flag))
    for f in flag:
        print("  %-28s %s %s %s" % (f[0], f[1], "margin %.3f V" % f[2] if not isinstance(f[2], str) else f[2], "%.4g" % f[3]))


if __name__ == "__main__":
    main()
