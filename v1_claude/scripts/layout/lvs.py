"""DRC / extraction / LVS / PEX drivers (magic + netgen)."""
import os, re, subprocess, sys
from lib import ncap, plates, merge_factor

HERE = os.path.dirname(os.path.abspath(__file__))
PROJ = os.path.dirname(os.path.dirname(HERE))
MAGIC = os.path.expanduser("~/opt/magic/bin/magic")
PDK = os.path.expanduser("~/pdk/gf180mcuD")
SETUP = PDK + "/libs.tech/netgen/gf180mcuD_setup.tcl"
SRC = PROJ + "/sim/netlist/tb_full.spice"
ENV = dict(os.environ, PDK_ROOT=os.path.expanduser("~/pdk"), PDK="gf180mcuD")


def subckts(path=SRC):
    txt = open(path).read().replace("\n+", " ")
    out = {}
    cur = None
    for l in txt.split("\n"):
        t = l.split()
        if not t:
            continue
        if t[0].lower() == ".subckt":
            cur = t[1]; out[cur] = [l]
        elif t[0].lower() == ".ends":
            if cur:
                out[cur].append(".ends"); cur = None
        elif cur and not l.startswith("*"):
            out[cur].append(l)
    if "gnss_afe_top" in out and "gnss_afe_analog" not in out:
        # analog hard macro = top level without the SPI registers (controls become ports)
        spi = [l for l in out["gnss_afe_top"] if l.split()[0] == "XSPI"]
        if spi:
            ctl = spi[0].split()[4:-3]
        else:
            ctl = []
        # (XBW: inverter BWW -> bwk of the digital side; the macro pin is BWK)
        ctl = ["BWK" if c == "BWW" else c for c in ctl]
        body = [" ".join("BWK" if w == "bwk" else w for w in l.split())
                for l in out["gnss_afe_top"][1:] if l.split()[0] not in ("XSPI", "XBW")]
        ports = out["gnss_afe_top"][0].split()[2:]
        ports = [p for p in ports if p not in ("SCLK", "SDI", "CS_N")]
        ports = ports[:2] + ctl + ports[2:]
        # VCTRL pin = monitor: unity buffer XMON + 10 kohm series resistor XRMON (both in the schematic)
        # (netgen is case-insensitive: the loop node vctrl must not merge with the pin VCTRL)
        body = [" ".join("vctrl_i" if w == "vctrl" else w for w in l.split()) for l in body]
        out["gnss_afe_analog"] = [".subckt gnss_afe_analog " + " ".join(ports)] + body
    return out


def clean(line, cell=None):
    """Reference netlist line: unit MIM caps, drop layout-dependent MOS params."""
    t = line.split()
    if "cap_mim_2f0_m4m5_noshield" in t:
        kv = dict(w.split("=", 1) for w in t if "=" in w)
        base = [w for w in t if "=" not in w]
        f = merge_factor(cell, t[0][1:]) if cell else None
        if f is not None:
            # same input as the layout (auto.parse sees the unit count): 5 um units x n x f
            n = ncap(float(kv["c_width"]), float(kv["c_length"]), int(kv.get("m", 1)))
            k, pw, ph = plates("5e-6", "5e-6", n, f)
            return " ".join(base + ["c_width=%ge-6" % (pw / 1e3), "c_length=%ge-6" % (ph / 1e3), "m=%d" % k])
        n = ncap(float(kv["c_width"]), float(kv["c_length"]), int(kv.get("m", 1)))
        return " ".join(base + ["c_width=5e-6", "c_length=5e-6", "m=%d" % n])
    if "nfet_03v3" in t or "pfet_03v3" in t:
        line = re.sub(r"\s(ad|as|pd|ps|nrd|nrs)='[^']*'", "", line)
        line = re.sub(r"\s(sa|sb|sd|par)=\S+", "", line)
        return line
    return line


def ref_netlist(cell, out, cells=None):
    cells = cells or subckts()
    need, stack = [], [cell]
    while stack:
        c = stack.pop()
        if c in need:
            continue
        need.append(c)
        for l in cells[c][1:]:
            t = l.split()
            if t and t[0][0] in "Xx":
                mdl = [w for w in t[1:] if "=" not in w][-1]
                if mdl in cells:
                    stack.append(mdl)
    with open(out, "w") as f:
        for c in reversed(need):
            for l in cells[c]:
                f.write(clean(l, c) + "\n")
    return out


def magic(script, cwd, env=None, timeout=3600):
    e = dict(ENV); e.update(env or {})
    r = subprocess.run([MAGIC, "-dnull", "-noconsole"], input=script, cwd=cwd, env=e,
                       capture_output=True, text=True, timeout=timeout)
    return r.stdout + r.stderr


def drc(cell, d):
    out = magic(open(HERE + "/drc.tcl").read(), d, dict(CELL=cell, DIR=d))
    errs = [l for l in out.split("\n") if l.startswith("DRCERR")]
    m = re.search(r"DRCCOUNT \S+ (\d+)", out)
    return (int(m.group(1)) if m else -1), errs


def extract(cell, d):
    magic(open(HERE + "/ext.tcl").read(), d, dict(CELL=cell, DIR=d))
    return os.path.join(d, cell + ".lvs.spice")


def lvs(cell, d):
    lay = extract(cell, d)
    ref = ref_netlist(cell, os.path.join(d, cell + ".ref.spice"))
    rpt = os.path.join(d, cell + ".lvs.rpt")
    r = subprocess.run(["netgen", "-batch", "lvs", "%s %s" % (lay, cell), "%s %s" % (ref, cell),
                        SETUP, rpt], cwd=d, capture_output=True, text=True, env=ENV, timeout=3600)
    txt = open(rpt).read() if os.path.exists(rpt) else r.stdout
    fin = [l for l in txt.split("\n") if l.startswith("Final result")]
    ok = bool(fin) and "match uniquely" in fin[-1] and "Property errors" not in txt
    last = [l for l in txt.split("\n") if "match" in l.lower()][-3:]
    return ok, last, rpt


if __name__ == "__main__":
    cell, d = sys.argv[1], sys.argv[2]
    print(drc(cell, d))
    print(lvs(cell, d))


def pex(cell, d):
    out = magic(open(HERE + "/pex.tcl").read(), d, dict(CELL=cell, DIR=d))
    return os.path.join(d, cell + ".pex.spice"), out
