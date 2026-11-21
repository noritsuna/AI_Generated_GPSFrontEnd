"""Convert an xschem/ngspice testbench netlist to a Xyce deck.

- GF180 Xyce models define MOSFETs as binned .model cards -> X instances of
  nfet_*/pfet_* become M instances.
- '...' parameter expressions -> {...}.
- the ngspice .control block is replaced by Xyce analysis/print statements
  given per testbench (XYCE_ANALYSES).

Usage: python3 scripts/to_xyce.py tb_name   ->  sim/xyce/tb_name.cir
"""
import os, re, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
NET = os.path.join(ROOT, "sim", "netlist")
OUT = os.path.join(ROOT, "sim", "xyce")
XLIB = os.path.expandvars("$PDK_ROOT/$PDK/libs.tech/xyce")
MOS = ("nfet_03v3", "pfet_03v3", "nfet_06v0", "pfet_06v0")

FLO = 96 * 16.368e6
XYCE_ANALYSES = {
    "tb_vco": """.ic v(xvco.p4)=0 v(xvco.n4)=2
.tran 2p 12n 0 2p uic
.options timeint method=gear reltol=1e-4
.measure tran ta when v(loip)=v(loin) rise=4
.measure tran tb when v(loip)=v(loin) rise=12
.measure tran ivdd avg i(VDD) from=6n to=12n
.print tran format=csv v(loip) v(loin) v(loqp) v(vr)
""",
    "tb_if": """.ac dec 20 1e5 1e8
.print ac format=csv vdb(outp,outn)
.measure ac g4 find vdb(outp,outn) at=4.092e6
.measure ac g66 find vdb(outp,outn) at=6.6e6
.measure ac g112 find vdb(outp,outn) at=11.25e6
""",
    "tb_adc": """.tran 0.1n 10u
.measure tran ts when v(sign)=1.65 rise=1
.measure tran tm1 when v(mag)=1.65 fall=1
.measure tran tm2 when v(mag)=1.65 rise=1
.print tran format=csv v(inp,inn) v(sign) v(mag)
""",
    "tb_pll": """.ic v(vctrl)=1.7 v(xpll.xlf.z)=1.7 v(xpll.vcp)=1.7 v(xvco.p4)=0 v(xvco.n4)=2
.options timeint method=gear reltol=2e-4
.tran 5p 4u 0 5p uic
.measure tran vc_end avg v(vctrl) from=3.5u to=4u
.print tran format=csv v(vctrl)
""",
    "tb_full": """.ic v(vctrl)=1.7 v(xdut.xpll.xlf.z)=1.7 v(xdut.xpll.vcp)=1.7 v(xdut.xvco.p4)=0 v(xdut.xvco.n4)=1
.options timeint method=gear reltol=2e-4
.tran 5p 12u 0 5p uic
.measure tran vc_end avg v(vctrl) from=11u to=12u
.measure tran idd avg i(VDD) from=8u to=12u
.print tran format=csv v(vctrl) v(clkout) v(isign) v(imag) v(qsign) v(qmag) v(xdut.aip,xdut.ain) v(xdut.aqp,xdut.aqn) v(xdut.mip,xdut.min) v(xdut.mqp,xdut.mqn) v(rfin) v(xdut.rfp,xdut.rfn) i(VDD)
""",
}


def si(v):
    m = re.match(r"([-+0-9.eE]+)([a-zA-Z]*)", v)
    scale = {"": 1, "m": 1e-3, "u": 1e-6, "n": 1e-9, "p": 1e-12, "f": 1e-15}[m.group(2).lower()]
    return float(m.group(1)) * scale


def mos_geometry(line):
    """Xyce cannot use W/nf inside instance parameter expressions -> evaluate them."""
    W = si(re.search(r"\bW=(\S+)", line).group(1))
    nf = int(re.search(r"\bnf=(\d+)", line).group(1))
    e = 0.18e-6
    vals = dict(ad=int((nf + 1) / 2) * W / nf * e, AS=int((nf + 2) / 2) * W / nf * e,
                pd=2 * int((nf + 1) / 2) * (W / nf + e), ps=2 * int((nf + 2) / 2) * (W / nf + e),
                nrd=e / W, nrs=e / W)
    line = re.sub(r"\b(ad|as|pd|ps|nrd|nrs)='[^']*'", "", line)
    # newer PDK symbols add par=@m (mismatch scaling of the ngspice subckt wrapper); Xyce M cards reject it
    line = re.sub(r"\bpar=\S+", "", line)
    return line + " " + " ".join("%s=%.6g" % (k.lower(), v) for k, v in vals.items())


def noise_pwl(tb, name, rms, dt, tstop=13e-6, seed=1):
    import numpy as np
    n = int(tstop / dt) + 1
    v = np.random.default_rng(seed).normal(0, rms, n)
    v[0] = 0
    fn = "%s_%s_noise.csv" % (tb, name.lower())
    np.savetxt(os.path.join(OUT, fn), np.c_[np.arange(n) * dt, v], fmt="%.6e", delimiter=",")
    return fn


def convert(tb, corner="typical"):
    src = open(os.path.join(NET, tb + ".spice")).read()
    # join continuation lines
    src = re.sub(r"\n\+", " ", src)
    # drop ngspice control block and model includes
    src = re.sub(r"\.control.*?\.endc", "", src, flags=re.S)
    src = re.sub(r"^\s*\.(include|lib)\s.*$", "", src, flags=re.M)
    src = re.sub(r"^\s*\.option.*$", "", src, flags=re.M)
    src = re.sub(r"^\s*\.ic .*$", "", src, flags=re.M)
    out = []
    for line in src.splitlines():
        tok = line.split()
        if tok and tok[0][0] in "xX" and any(t in MOS for t in tok):
            line = "M" + line[1:]
            line = mos_geometry(line)
        line = re.sub(r"'([^']*)'", r"{\1}", line)
        if tok and tok[0].lower() == ".end":
            continue
        out.append(line)
    # Xyce has no ngspice-style trnoise: replace "dc 0 trnoise(rms dt 0 0)" sources by a PWL file of
    # Gaussian samples (same rms and sample spacing, linear interpolation as in ngspice)
    os.makedirs(OUT, exist_ok=True)
    for k, l in enumerate(out):
        m = re.match(r"^(\S+\s+\S+\s+\S+)\s+dc 0 trnoise\(\s*(\S+)\s+(\S+)\s+0\s+0\s*\)\s*$", l)
        if m:
            out[k] = '%s pwl file "%s"' % (m.group(1), noise_pwl(tb, m.group(1).split()[0], si(m.group(2)), si(m.group(3))))
        elif "trnoise" in l:
            out[k] = re.sub(r"trnoise\([^)]*\)\s*", "", l)
    hdr = ["* Xyce deck generated from %s.spice by scripts/to_xyce.py" % tb,
           ".include %s/design.xyce" % XLIB,
           ".lib %s/sm141064.xyce %s" % (XLIB, corner),
           ".lib %s/sm141064.xyce res_typical" % XLIB,
           ".lib %s/sm141064.xyce mimcap_typical" % XLIB]
    # Xyce hierarchical node separator is ':' (ngspice uses '.')
    ana = re.sub(r"\b(x[\w.]+)", lambda m: m.group(1).replace(".", ":"), XYCE_ANALYSES[tb])
    body = "\n".join(hdr + out[1:] + [ana, ".end"]) + "\n"
    os.makedirs(OUT, exist_ok=True)
    p = os.path.join(OUT, tb + ".cir")
    open(p, "w").write(body)
    return p


if __name__ == "__main__":
    for tb in sys.argv[1:]:
        print(convert(tb))
