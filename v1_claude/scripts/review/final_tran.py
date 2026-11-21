"""Final check, part 3: checks that need a transient run (schematic).
  mixer   tb_mixer with the LO high level of each corner (VR: tt 2.0, ss 2.85, ff 1.6 V): saturation margin
          |Vds| - |Vdsat| of the tail and Gm FETs while the switches run (average and minimum over 250-300 ns)
  stress  tb_full at ff, -20 C, VDD 3.63 V (3.3 V + 10 %): minimum / maximum of every node over 300-340 ns,
          nodes outside the rails, largest terminal-to-terminal voltage seen by any FET
  por     spi_regs alone with VDD ramps of 1 us .. 1 ms: reset pulse and the 19 outputs after the ramp
usage: final_tran.py mixer|stress|por   -> layout/review/final/<name>.log (stdout)"""
import os, sys, re, struct
from concurrent.futures import ThreadPoolExecutor
import numpy as np
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))
os.environ.setdefault("PDK", "gf180mcuD"); os.environ.setdefault("PDK_ROOT", os.path.expanduser("~/pdk"))
import run
from review.final_devices import subckts, LMIN

CORNERS = {"tt": ("typical", 27, 3.3, 2.0), "ss": ("ss", 85, 3.135, 2.85), "ff": ("ff", -20, 3.465, 1.6)}


def corner(t, lib, temp):
    if lib != "typical":
        t, k = re.subn(r"(sm141064\.ngspice) (res_|mimcap_)?typical", lambda m: "%s %s%s" % (m.group(1), m.group(2) or "", lib), t)
        assert k == 3
    return t.replace(".option method=gear", ".temp %g\n.option method=gear" % temp, 1)


def control(t, ctl):
    t, k = re.subn(r"^\.control.*?^\.endc", lambda m: ".control\nset num_threads=1\n" + ctl + ".endc", t, flags=re.M | re.S)
    assert k == 1
    return t


def mixer():
    text = open(run.netlist("tb_mixer")).read()
    dev = ["xmti", "xmg1i", "xmg2i", "xmtq", "xmg1q", "xmg2q", "xmlapi", "xmu1pi"]

    def one(c):
        lib, temp, v, vr = CORNERS[c]
        t = corner(text, lib, temp)
        t = re.sub(r"^VDD vdd 0 3\.3$", "VDD vdd 0 %g" % v, t, flags=re.M)
        t, k = re.subn(r"pulse\(0 2\.0 ", "pulse(0 %g " % vr, t); assert k == 8
        ctl = "save v(xm.ti) v(xm.xpi) v(xm.mpai) v(ifip) v(ifin) v(xm.gl1p) v(xm.gl3p) i(VDD) " + " ".join(
            "@m.xm.%s.m0[%s]" % (d, k) for d in dev for k in ("vds", "vdsat", "id", "vgs")) + "\ntran 5p 300n 0 5p\n"
        for d in dev:
            ctl += ("let mar = @m.xm.%s.m0[vds] - @m.xm.%s.m0[vdsat]\nmeas tran ma avg mar from=250n to=300n\nmeas tran mi min mar from=250n to=300n\n"
                    "meas tran ia avg @m.xm.%s.m0[id] from=250n to=300n\nmeas tran va avg @m.xm.%s.m0[vds] from=250n to=300n\n"
                    "meas tran sa avg @m.xm.%s.m0[vdsat] from=250n to=300n\necho DEV %s $&ma $&mi $&ia $&va $&sa\n" % (d, d, d, d, d, d))
        for n in ("xm.ti", "xm.xpi", "xm.mpai", "ifip", "xm.gl1p", "xm.gl3p"):
            ctl += "meas tran a avg v(%s) from=250n to=300n\nmeas tran lo min v(%s) from=250n to=300n\nmeas tran hi max v(%s) from=250n to=300n\necho NODE %s $&a $&lo $&hi\n" % (n, n, n, n)
        return run.ngspice(control(t, ctl), "final_mixer_" + c, timeout=40000)

    with ThreadPoolExecutor(3) as ex:
        logs = dict(zip(CORNERS, ex.map(one, CORNERS)))
    for c, log in logs.items():
        lib, temp, v, vr = CORNERS[c]
        print("== %s (%s, %g C, VDD %g V, LO high %g V)" % (c, lib, temp, v, vr))
        for l in log.splitlines():
            f = l.split()
            if l.startswith("DEV "):
                print("  %-8s margin avg %6.3f V, min %6.3f V   Id avg %7.1f uA  Vds avg %.3f V  Vdsat avg %.3f V" % (
                    f[1], float(f[2]), float(f[3]), float(f[4]) * 1e6, float(f[5]), float(f[6])))
            elif l.startswith("NODE "):
                print("  node %-8s avg %.3f V, min %.3f, max %.3f" % (f[1], float(f[2]), float(f[3]), float(f[4])))
        if "DEV " not in log:
            print("\n".join(log.splitlines()[-8:]))


def rawread(path):
    b = open(path, "rb").read()
    i = b.index(b"Binary:\n")
    head = b[:i].decode(errors="replace")
    nv = int(re.search(r"No\. Variables:\s*(\d+)", head).group(1)); npt = int(re.search(r"No\. Points:\s*(\d+)", head).group(1))
    names = [l.split()[1] for l in head[head.index("Variables:\n") + 11:].splitlines() if l.strip()][:nv]
    return names, np.frombuffer(b, dtype="<f8", count=nv * npt, offset=i + 8).reshape(npt, nv)


def flat(d, sc, path, nodes, out):
    for name, nd, kind, p in d[sc]:
        q = path + "." + name.lower()
        if kind in LMIN:
            out.append((q, kind, [nodes.get(x, path + "." + x.lower()) for x in nd[:4]]))
        elif kind in d:
            ports = TOPPORTS[kind]
            flat(d, kind, q, dict(zip(ports, [nodes.get(x, path + "." + x.lower()) for x in nd])), out)


TOPPORTS = {}


def stress(v=3.63, lib="ff", temp=-20, tag="final_stress"):
    text = open(run.netlist("tb_full")).read()
    t = corner(text, lib, temp)
    t = re.sub(r"^VDD vdd 0 3\.3$", "VDD vdd 0 %g" % v, t, flags=re.M)
    t = re.sub(r"^VRNP sp sp0 .*$", "VRNP sp sp0 dc 0", t, flags=re.M)
    t = t.replace("pwl(0 3.3 ", "pwl(0 %g " % v)
    raw = os.path.join(run.SIM, tag + ".raw")
    t = control(t, "save all\ntran 5p 340n 300n 5p uic\nwrite %s\n" % raw)
    log = run.ngspice(t, tag, timeout=80000)
    names, a = rawread(raw)
    names = [n.lower() for n in names]
    col = {(n[2:-1] if n.startswith("v(") else n): i for i, n in enumerate(names)}
    lo, hi = a.min(0), a.max(0)
    print("== tb_full, %s, %g C, VDD = VDDV = %g V, 300-340 ns (%d points, %d vectors)" % (lib, temp, v, a.shape[0], a.shape[1]))
    out = [(n, lo[i], hi[i]) for n, i in col.items() if not n.startswith(("i(", "time")) and "#" not in n and (lo[i] < -0.3 or hi[i] > v + 0.3)]
    print("== nodes outside -0.3 .. VDD + 0.3 V: %d" % len(out))
    for n, l, h in sorted(out, key=lambda x: x[1] - x[2])[:40]:
        print("  %-40s %7.3f .. %6.3f V" % (n, l, h))
    d = subckts(text)
    for l in text.replace("\n+", " ").splitlines():
        if l.lower().startswith(".subckt"):
            TOPPORTS[l.split()[1]] = l.split()[2:]
    fets = []
    flat(d, "gnss_afe_top", "xdut", dict(zip(TOPPORTS["gnss_afe_top"], "rfin refin sclk sdi csn isign imag qsign qmag clkout afcout vctrl vddv vdd 0".split())), fets)
    worst, miss = [], 0
    for q, kind, nd in fets:
        try:
            x = [a[:, col[n]] if n != "0" else np.zeros(a.shape[0]) for n in nd]
        except KeyError:
            miss += 1; continue
        dn, g, s, b = x
        m = {"gs": np.abs(g - s).max(), "gd": np.abs(g - dn).max(), "ds": np.abs(dn - s).max(), "gb": np.abs(g - b).max()}
        k = max(m, key=m.get)
        worst.append((m[k], k, q, kind))
    worst.sort(reverse=True)
    print("== FETs: %d checked (%d without node data); terminal pairs above VDD: %d; above VDD + 0.3 V: %d" % (
        len(worst), miss, sum(w[0] > v + 0.005 for w in worst), sum(w[0] > v + 0.3 for w in worst)))
    for w in worst[:25]:
        print("  %-44s %s  |V%s| max %.3f V" % (w[2], w[3], w[1], w[0]))
    print("== last log lines\n" + "\n".join(log.splitlines()[-3:])[:400])


def por():
    text = open(run.netlist("tb_full")).read()
    libs = "\n".join(l for l in text.splitlines() if l.strip().startswith((".include", ".lib")))
    body = text[text.index("* expanding   symbol:  gnss_afe_top.sym"):text.rindex(".end")]
    outs = "ig1a ig1b ig2a ig2b ig3a ig3b b0 b1 afc0 afc1 afc2 afc3 afc4 afc5 afc6 afc7 icp2 bww bwn".split()

    def one(tr):
        t = ("* POR with a VDD ramp of %g s\nVDD vdd 0 pwl(0 0 %g 3.3)\nESCLK sclk 0 vol='0'\nESDI sdi 0 vol='0'\nRCS csn vdd 1\n"
             "XSPI sclk sdi csn %s vdd 0 spi_regs\n%s\n.option method=gear\n" % (tr, tr, " ".join(outs), libs))
        tend = tr + 20e-6
        ctl = ".control\nset num_threads=1\ntran %g %g 0 %g\nmeas tran rmax max v(xspi.rst)\nmeas tran prend find v(xspi.pr) at=%g\n" % (tend / 4000, tend, tend / 4000, tr)
        ctl += "let hi = v(xspi.rst) gt (0.5*v(vdd)) and v(vdd) gt 1.0\nmeas tran thi integ hi\n"
        ctl += "echo POR rmax=$&rmax prend=$&prend thi=$&thi\n" + "".join("meas tran o%d find v(%s) at=%.6e\necho OUT %s $&o%d\n" % (i, o, tend * 0.999, o, i) for i, o in enumerate(outs)) + ".endc\n"
        return run.ngspice(t + ctl + body + ".end\n", "final_por_%g" % tr, timeout=20000)

    ramps = (1e-6, 10e-6, 100e-6, 1e-3)
    with ThreadPoolExecutor(2) as ex:
        logs = list(ex.map(one, ramps))
    for tr, log in zip(ramps, logs):
        m = re.search(r"POR rmax=(\S+) prend=(\S+) thi=(\S+)", log)
        o = {l.split()[1]: float(l.split()[2]) for l in log.splitlines() if l.startswith("OUT ")}
        if not m:
            print("ramp %g: failed\n%s" % (tr, "\n".join(log.splitlines()[-6:]))); continue
        exp = {x: (3.3 if x == "afc7" else 0.0) for x in outs}
        bad = [x for x in outs if abs(o[x] - exp[x]) > 0.3]
        print("VDD ramp %7.0f us: rst max %.2f V, time with rst high while VDD > 1 V %.2f us, pr at the end of the ramp %.2f V; "
              "outputs after the ramp: %s" % (tr * 1e6, float(m.group(1)), float(m.group(3)) * 1e6, float(m.group(2)),
                                              "all 19 at the reset value" if not bad else "NOT at the reset value: " + " ".join(bad)))


if __name__ == "__main__":
    {"mixer": mixer, "stress": stress, "stress_nom": lambda: stress(3.3, "typical", 27, "final_stress_nom"), "por": por}[sys.argv[1]]()
