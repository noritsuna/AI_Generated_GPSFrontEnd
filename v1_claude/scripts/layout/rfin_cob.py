"""RFIN input match on the wafer.space run-2 0p5x0p5 chip-on-board PCB (LNA PEX + mixer load, 1575.42 MHz).
Path from the matching parts on the motherboard to the LNA:
  50 ohm source - shunt part (source side) - series part - shunt part (connector side) - mezzanine connector
  - COB trace /bidir_23 (0.1 mm wide, 4.79 mm on F.Cu + via + 4.30 mm on B.Cu, 0.196 mm above the GND planes,
  FR4 er 4.5, from 0p5x0p5-cob.kicad_pcb) - bond finger - bond wire - asig_5p0 pad + ESD - macro RFIN wire - LNA.
The chip ground reaches the board ground through LG (bond wires of the VSS pads in parallel).
Assumed, not taken from a datasheet or a measurement: connector 0.6 nH / 0.15 pF, via 0.4 nH / 0.1 pF,
bond wire 3.0 nH / 0.5 ohm (25 um gold, about 3.0 mm), LG 0.5 nH.
usage: rfin_cob.py            part search and sensitivity at TT -> layout/review/padframe/rfin_cob.log (stdout)
       rfin_cob.py corners    chosen parts at TT / SS / FF, bond wire 2.0 ... 4.0 nH, and all assumptions varied at random
                              -> layout/review/final/rfin_corners.log (stdout)
       rfin_cob.py search     part search at TT / SS / FF: best per corner and best for all three with the same parts;
                              process, temperature and supply separately -> layout/review/final/rfin_search.log (stdout)"""
import os, sys, re, json, math, random
from concurrent.futures import ThreadPoolExecutor
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
os.environ.setdefault("PDK", "gf180mcuD"); os.environ.setdefault("PDK_ROOT", os.path.expanduser("~/pdk"))
import pexsim
from pexsim import run
from rfin_match import CPAD_VDD, CPAD_VSS, F0

W, H, T, ER = 0.1, 0.196, 0.0175, 4.5          # trace width, height above the plane, copper thickness (mm), FR4
LEN = (4.79, 4.30)                             # mm on F.Cu, B.Cu
NSEC = 6                                       # LC sections per layer
NOM = dict(lw=3.0, lg=0.5, kt=1.0, lc=0.6, cc=0.15)     # wire nH, ground nH, trace L and C scale, connector nH / pF
E12 = [1.0, 1.2, 1.5, 1.8, 2.2, 2.7, 3.3, 3.9, 4.7, 5.6, 6.8, 8.2]
CORNER = {"tt": ("typical", 27, 3.3), "ss": ("ss", 85, 3.135), "ff": ("ff", -20, 3.465)}
SPLIT = {"ss process only": ("ss", 27, 3.3), "85 C only": ("typical", 85, 3.3), "3.135 V only": ("typical", 27, 3.135),
         "ff process only": ("ff", 27, 3.3), "-20 C only": ("typical", -20, 3.3), "3.465 V only": ("typical", 27, 3.465)}
ALLC = dict(CORNER, **SPLIT)


def microstrip():
    """Z0 (ohm), L (nH/mm), C (pF/mm), R (ohm/mm at F0) of the trace (Hammerstad, w/h < 1)."""
    u = W / H
    ee = (ER + 1) / 2 + (ER - 1) / 2 * ((1 + 12 / u) ** -0.5 + 0.04 * (1 - u) ** 2)
    z0 = 60 / math.sqrt(ee) * math.log(8 / u + u / 4)
    v = 2.998e8 / math.sqrt(ee)
    delta = math.sqrt(1.72e-8 / (math.pi * F0 * 4e-7 * math.pi))
    return z0, z0 / v * 1e6, 1 / (z0 * v) * 1e9, 1.72e-8 / (W * 1e-3 * delta) * 1e-3


_BASE = []


def base():
    """tb_lna with the extracted LNA; netlisted once (the threads below must not netlist at the same time)."""
    if not _BASE:
        _BASE.append(pexsim.swap(open(run.netlist("tb_lna")).read(), "lna_nc"))
        for c in ALLC:
            opset(c)
    return _BASE[0]


_OP = {}


def opset(c):
    """.nodeset lines of the operating point of corner c.  The extracted LNA does not reach its operating point by
    Newton iteration from zero: ngspice falls back to a "transient op" and takes a snapshot of it, which is not exact
    (rfp and rfn differ by up to 0.3 mV, differently in every run) and made single points come out wrong (e.g. gain
    11.6 dB instead of 13.3 dB).  With a saved solution as .nodeset only the first analysis of a deck (the op in front,
    whose result is not used) still falls back; every analysis after it converges by iteration, and the result is the
    same in every run and with both matrix solvers.  The operating point does not depend on the matching parts or on
    the inductances, so one set per corner is enough."""
    if c not in _OP:
        f = "rfin_op_%s.txt" % re.sub(r"\W", "", c).lower()
        ns = ""
        for i in range(3):
            t, k = re.subn(r"^\.control.*?^\.endc", lambda m: ".control\nset num_threads=1\nop\nop\nwrnodev %s\n.endc" % f, deck(NOM, c, ns), flags=re.M | re.S)
            assert k == 1
            out = run.ngspice(t, "rfin_cob_op", timeout=4000)
            assert not [l for l in out.splitlines() if "rror" in l], out[-300:]
            ns = "".join(l.replace(".ic", ".nodeset", 1) + "\n" for l in open(os.path.join(run.SIM, f)).read().splitlines() if l.startswith(".ic"))
            if i and out.count("Transient op started") == 1:
                break
        else:
            raise RuntimeError("operating point of %s does not converge from the saved solution" % c)
        _OP[c] = ns
    return _OP[c]


def deck(p, c="tt", ns=None):
    z0, l1, c1, r1 = microstrip()
    w = json.load(open(os.path.join(pexsim.MAG, "top_wires.json")))["RFIN"]
    t = base()
    # chip ground gc, board ground 0
    head, k = re.subn(r"^VDD vdd 0 3\.3\nXB nb pb vdd 0 bias_gen\n", "VDD vdd gc 3.3\nXB nb pb vdd gc bias_gen\nLG gc 0 %gn\n" % max(p["lg"], 1e-3), t, flags=re.M)
    assert k == 1
    head, k = re.subn(r"^XLNA rfin pb rfp rfn vdd 0 lna_nc$", "XLNA rfin pb rfp rfn vdd gc lna_nc", head, flags=re.M); assert k == 1
    head, k = re.subn(r"^(VL\d[PN] l\d[pn]) 0 ", r"\1 gc ", head, flags=re.M); assert k == 8
    head, k = re.subn(r"(ifip ifin ifqp ifqn vdd) 0 mixer_iq$", r"\1 gc mixer_iq", head, flags=re.M); assert k == 1
    # CB2: the shunt part at the connector must not short the DC bias of the LNA input (1.0 V), as the 1 H placeholder
    # LP2 did without it (wrong results at SS / FF)
    net = "RS50 s0 s1 50\nLP s1 0 1\nCP s1 0 1a\nLSER s1 s2 1p\nCSER s2 c0 10p\nLP2 c0 c0b 1\nCB2 c0b 0 1u\nCP2 c0 0 1a\n"
    net += "LCON c0 t0 %gn\nCCON t0 0 %gp\n" % (p["lc"], p["cc"])
    n = 0
    for li, ln in enumerate(LEN):
        for _ in range(NSEC):
            d = ln / NSEC
            net += "LT%d t%d u%d %gn\nRT%d u%d t%d %g\nCT%d t%d 0 %gp\n" % (n, n, n, l1 * d * p["kt"], n, n, n + 1, r1 * d, n, n + 1, c1 * d * p["kt"])
            n += 1
        if li == 0:
            net += "LVIA t%d t%d 0.4n\nCVIA t%d 0 0.1p\n" % (n, n + 1, n + 1); n += 1
    net += "CBF t%d 0 0.06p\nLW t%d w1 %gn\nRWB w1 pad 0.5\n" % (n, n, p["lw"])
    net += ("CPV pad vdd %g\nCPS pad gc %g\n" % (CPAD_VDD, CPAD_VSS) +
            "".join("DN%d gc pad diode_nd2ps_06v0 area=150e-12 pj=106e-6\nDP%d pad vdd diode_pd2nw_06v0 area=150e-12 pj=106e-6\n" % (i, i)
                    for i in range(4)))
    net += "RW pad rfin %g\nCW rfin gc %g\n" % (max(w["r"], 1e-3), w["c"])
    t, k = re.subn(r"^RS50 s0 s1 50\nCIN s1 rfin 10p\n", lambda m: net, head, flags=re.M)
    assert k == 1
    t = t.replace("sm141064.ngspice mimcap_typical", "sm141064.ngspice mimcap_typical\n.lib %s/gf180mcuD/libs.tech/ngspice/sm141064.ngspice diode_typical"
                  % os.environ["PDK_ROOT"])
    lib, temp, v = ALLC[c]
    if lib != "typical":
        t, k = re.subn(r"(sm141064\.ngspice) (res_|mimcap_|diode_)?typical", lambda m: "%s %s%s" % (m.group(1), m.group(2) or "", lib), t)
        assert k == 4
    t, k = re.subn(r"^VDD vdd gc 3\.3$", "VDD vdd gc %g" % v, t, flags=re.M); assert k == 1
    return t.replace(".control", ".temp %g\n%s.control" % (temp, opset(c) if ns is None else ns), 1)


def point(m, freqs=(F0,), tk=300.0):
    """m = (shunt at source, series, shunt at connector): nH > 0, pF < 0, 0 = none (series: 0 = 10 pF only).
    NF for a 300 K source: the 50 ohm source of the simulation is at tk, its own noise is replaced by that of 300 K."""
    lp, se, lp2 = m
    s = "alter LP = %g\nalter CP = %g\n" % (lp * 1e-9 if lp > 0 else 1.0, -lp * 1e-12 if lp < 0 else 1e-18)
    s += "alter LP2 = %g\nalter CP2 = %g\n" % (lp2 * 1e-9 if lp2 > 0 else 1.0, -lp2 * 1e-12 if lp2 < 0 else 1e-18)
    s += "alter LSER = %g\nalter CSER = %g\n" % (se * 1e-9 if se > 0 else 1e-12, -se * 1e-12 if se < 0 else 10e-12)
    for f in freqs:
        s += ("ac lin 1 %g %g\nlet zin = v(s1)/(-i(VRF))\nlet s11 = db((zin-50)/(zin+50))\n"
              "let gd = db((v(rfp)-v(rfn))/v(s0)*2)\nlet zr = real(zin)\nlet zi = imag(zin)\n"
              "noise v(rfp,rfn) VRF lin 1 %g %g\nsetplot noise1\nlet nf = 10*log10(1+(inoise_spectrum^2-4*1.380649e-23*%g*50)/(4*1.380649e-23*300*50))\n"
              "echo RES lp=%g se=%g lp2=%g f=%g zr=$&ac1.zr zi=$&ac1.zi s11=$&ac1.s11 gd=$&ac1.gd nf=$&nf\ndestroy all\n"
              % (f, f, f, f, tk, lp, se, lp2, f))
    return s


def sim(p, pts, tag, freqs=(F0,), c="tt"):
    body = "set num_threads=1\nop\n" + "".join(point(m, freqs, 300.0 if c == "tt" else ALLC[c][1] + 273.15) for m in pts)
    t, k = re.subn(r"^\.control.*?^\.endc", lambda m: ".control\n" + body + ".endc", deck(p, c), flags=re.M | re.S)
    assert k == 1
    out = run.ngspice(t, "rfin_cob_" + tag, timeout=40000)
    err = [l for l in out.splitlines() if "rror" in l]
    assert not err, err[:3]
    assert out.count("Transient op started") == 1, tag
    return [{k: float(v) for k, v in (kv.split("=") for kv in l.split()[1:])} for l in out.splitlines() if l.startswith("RES lp")]


def name(v, pos):
    return "none" if not v and pos != 1 else "C 10 pF" if not v else ("L %g nH" % v if v > 0 else "C %g pF" % -v)


def fmt(m):
    return "source shunt %-9s series %-9s connector shunt %-9s" % (name(m[0], 0), name(m[1], 1), name(m[2], 2))


PICK = [(-1.0, -1.8, 0), (6.8, -1.0, 0), (0, -1.0, 0)]      # recommended, alternative, one part only
TUNE = [(-1.0, -1.5, 0), (-1.0, -2.2, 0), (-1.2, -2.2, 0), (-0.82, -1.5, 0)]      # neighbouring values, to retune on the board


def corners():
    base()
    fr = (1.55e9, F0, 1.60e9)
    lws = (2.0, 2.5, 3.0, 3.5, 4.0)
    jobs = [(c, lw) for c in CORNER for lw in lws]
    with ThreadPoolExecutor(3) as ex:
        out = list(ex.map(lambda j: sim(dict(NOM, lw=j[1]), PICK + TUNE, "c%s%g" % j, fr, j[0]), jobs))
    for m in PICK + TUNE:
        print("== %s" % fmt(m))
        for (c, lw), rs in zip(jobs, out):
            q = [r for r in rs if (r["lp"], r["se"], r["lp2"]) == m]
            print("  %s wire %.1f nH  " % (c, lw) + " | ".join("%.0f MHz S11 %6.2f gain %5.2f NF %.2f" % (r["f"] / 1e6, r["s11"], r["gd"], r["nf"]) for r in q))
    print("== best of the retuning set at each corner and wire (1575.42 MHz, by S11)")
    for (c, lw), rs in zip(jobs, out):
        b = min((r for r in rs if r["f"] == F0), key=lambda r: r["s11"])
        print("  %s wire %.1f nH  %s S11 %6.2f gain %5.2f NF %.2f" % (c, lw, fmt((b["lp"], b["se"], b["lp2"])), b["s11"], b["gd"], b["nf"]))
    # all assumptions at once, uniform: wire 2.5 ... 3.5 nH, ground 0.25 ... 0.75 nH, trace +/-10 %, connector 0.3 ... 1.0 nH, 0.05 ... 0.3 pF
    rnd = random.Random(1)
    N = 100
    smp = [dict(lw=rnd.uniform(2.5, 3.5), lg=rnd.uniform(0.25, 0.75), kt=rnd.uniform(0.9, 1.1), lc=rnd.uniform(0.3, 1.0), cc=rnd.uniform(0.05, 0.3)) for _ in range(N)]
    jobs = [(c, i) for c in CORNER for i in range(N)]
    with ThreadPoolExecutor(3) as ex:
        out = list(ex.map(lambda j: sim(smp[j[1]], PICK, "r%s%d" % j, (F0,), j[0]), jobs))
    print("== %d random sets of the assumptions (wire 2.5-3.5 nH, ground 0.25-0.75 nH, trace +/-10 %%, connector 0.3-1.0 nH / 0.05-0.3 pF), 1575.42 MHz" % N)
    for m in PICK:
        print("  %s" % fmt(m))
        for c in CORNER:
            q = [r for (cc, _), rs in zip(jobs, out) if cc == c for r in rs if (r["lp"], r["se"], r["lp2"]) == m]
            s11 = sorted(r["s11"] for r in q); gd = sorted(r["gd"] for r in q); nf = sorted(r["nf"] for r in q)
            print("    %s S11 median %6.2f worst %6.2f (%d of %d above -10 dB) | gain %5.2f ... %5.2f | NF %.2f ... %.2f" % (
                c, s11[N // 2], s11[-1], sum(x > -10 for x in s11), N, gd[0], gd[-1], nf[0], nf[-1]))


def grid():
    vals = [d * v for d in (1, 10) for v in E12]
    shunt = [0] + [v for v in vals if 1.5 <= v <= 22] + [-v for v in vals if 0.5 <= v <= 10] + [-0.5, -0.68, -0.82]
    series = [0] + [v for v in vals if v <= 18] + [-v for v in vals if v <= 8.2] + [-0.5, -0.68, -0.82]
    return [(a, s, 0) for a in shunt for s in series] + [(0, s, b) for b in shunt[1:] for s in series]


def search():
    base()
    # the region where the TT search found its matches (series C, shunt at the source or a small C at the connector);
    # short decks: ngspice gets slower with every alter
    ser = [-0.5, -0.68, -0.82, -1.0, -1.2, -1.5, -1.8, -2.2, -2.7, -3.3]
    sh = [0, -0.5, -0.68, -0.82, -1.0, -1.2, -1.5, -1.8, -2.2, -2.7, -3.3, 3.3, 3.9, 4.7, 5.6, 6.8, 8.2, 10, 15]
    g = [(a, b, 0) for a in sh for b in ser] + [(0, b, c) for c in (-0.5, -0.68, -1.0, -1.5) for b in ser]; nj = 8
    res = {}
    for c in CORNER:
        with ThreadPoolExecutor(4) as ex:
            rs = sum(ex.map(lambda i: sim(NOM, g[i::nj], "s%s%d" % (c, i), (F0,), c), range(nj)), [])
        res[c] = {(r["lp"], r["se"], r["lp2"]): r for r in rs}
        print("== %s: best by NF among S11 < -10 dB (%d of %d)" % (c, sum(r["s11"] < -10 for r in rs), len(rs)))
        for r in sorted((r for r in rs if r["s11"] < -10), key=lambda r: r["nf"] - 0.02 * min(-r["s11"], 15))[:8]:
            print("  %s  Zin %5.1f %+6.1fj  S11 %6.2f dB  gain %5.2f dB  NF %.2f dB" % (fmt((r["lp"], r["se"], r["lp2"])), r["zr"], r["zi"], r["s11"], r["gd"], r["nf"]))
    print("== same parts at all three corners: best by the worst S11")
    ms = sorted(res["tt"], key=lambda m: max(res[c][m]["s11"] for c in CORNER))
    for m in ms[:12]:
        print("  %s  " % fmt(m) + " | ".join("%s S11 %6.2f gain %5.2f NF %.2f" % (c, res[c][m]["s11"], res[c][m]["gd"], res[c][m]["nf"]) for c in CORNER))
    print("== same parts at all three corners: best by the worst NF among worst S11 < -8 dB")
    for m in sorted((m for m in ms if max(res[c][m]["s11"] for c in CORNER) < -8), key=lambda m: max(res[c][m]["nf"] for c in CORNER))[:8]:
        print("  %s  " % fmt(m) + " | ".join("%s S11 %6.2f gain %5.2f NF %.2f" % (c, res[c][m]["s11"], res[c][m]["gd"], res[c][m]["nf"]) for c in CORNER))
    print("== no matching parts (10 pF only): impedance at the connector, and process / temperature / supply separately with the TT parts")
    for c in ALLC:
        r0, r1 = sim(NOM, [(0, 0, 0), PICK[0]], "p" + re.sub(r"\W", "", c), (F0,), c)
        print("  %-16s no parts Zin %5.1f %+6.1fj | %s: Zin %5.1f %+6.1fj S11 %6.2f gain %5.2f NF %.2f" % (
            c, r0["zr"], r0["zi"], fmt(PICK[0]).strip(), r1["zr"], r1["zi"], r1["s11"], r1["gd"], r1["nf"]))


def main():
    if sys.argv[1:] == ["corners"]:
        return corners()
    if sys.argv[1:] == ["search"]:
        return search()
    z0, l1, c1, r1 = microstrip()
    base()
    print("trace: Z0 %.0f ohm, %.3f nH/mm, %.4f pF/mm, %.3f ohm/mm -> total %.2f nH, %.2f pF, %.2f ohm" % (
        z0, l1, c1, r1, l1 * sum(LEN), c1 * sum(LEN), r1 * sum(LEN)))
    r = sim(NOM, [(0, 0, 0)], "z")[0]
    print("impedance at the connector (through 10 pF), no matching: %.1f %+.1fj ohm, S11 %.2f dB, gain %.2f dB, NF %.2f dB" % (
        r["zr"], r["zi"], r["s11"], r["gd"], r["nf"]))
    vals = [d * v for d in (1, 10) for v in E12]
    shunt = [0] + [v for v in vals if 1.5 <= v <= 22] + [-v for v in vals if 0.5 <= v <= 10] + [-0.5, -0.68, -0.82]
    series = [0] + [v for v in vals if v <= 18] + [-v for v in vals if v <= 8.2] + [-0.5, -0.68, -0.82]
    grid = [(a, s, 0) for a in shunt for s in series] + [(0, s, b) for b in shunt[1:] for s in series]
    nj = 12
    with ThreadPoolExecutor(nj) as ex:
        res = sum(ex.map(lambda i: sim(NOM, grid[i::nj], "g%d" % i), range(nj)), [])
    res.sort(key=lambda r: r["nf"] - 0.02 * min(-r["s11"], 15))
    good = [r for r in res if r["s11"] < -10]
    print("== nominal (%s), %d combinations, %d with S11 < -10 dB; best by NF:" % (NOM, len(res), len(good)))
    for r in good[:25]:
        print("  %s  Zin %5.1f %+6.1fj  S11 %6.2f dB  gain %5.2f dB  NF %.2f dB" % (fmt((r["lp"], r["se"], r["lp2"])), r["zr"], r["zi"], r["s11"], r["gd"], r["nf"]))
    # the best few with different parts: bandwidth and sensitivity to the assumptions
    pick = []
    for r in good:
        m = (r["lp"], r["se"], r["lp2"])
        if all(sum(a != b for a, b in zip(m, q)) == 3 - m.count(0) or (m[0] == 0) != (q[0] == 0) for q in pick) or not pick:
            pick.append(m)
        if len(pick) == 4:
            break
    var = [("nominal", {})] + [("%s=%g" % (k, v), {k: v}) for k, vs in (("lw", (2.5, 3.5)), ("lg", (0.0, 1.0)), ("kt", (0.8, 1.2)), ("lc", (0.3, 1.0)), ("cc", (0.05, 0.3)))
                               for v in vs]
    fr = (1.55e9, F0, 1.60e9)
    with ThreadPoolExecutor(len(var)) as ex:
        out = list(ex.map(lambda a: sim(dict(NOM, **a[1][1]), pick, "v%d" % a[0], fr), enumerate(var)))
    for m in pick:
        print("== %s" % fmt(m))
        for (vn, _), rs in zip(var, out):
            q = [r for r in rs if (r["lp"], r["se"], r["lp2"]) == m]
            print("  %-8s " % vn + " | ".join("%.0f MHz S11 %6.2f gain %5.2f NF %.2f" % (r["f"] / 1e6, r["s11"], r["gd"], r["nf"]) for r in q))


if __name__ == "__main__":
    main()
