"""Pre-layout vs post-layout (PEX) simulation helpers."""
import os, re, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.dirname(HERE))
import run
from lvs import PROJ

MAG = os.environ.get("MAGOUT") or os.path.join(PROJ, "layout", "mag")


def ports(text, cell):
    # the port list may continue on "+" lines
    m = re.search(r"^\.subckt\s+%s\s+(.*(?:\n\+.*)*)" % re.escape(cell), text, re.M | re.I)
    return m.group(1).replace("\n+", " ").split()


def swap(text, cell, pex=None, flat=None):
    """Replace the schematic .subckt <cell> in a netlist by the PEX netlist."""
    pex = pex or os.path.join(MAG, cell + ".pex.spice")
    sch_ports = ports(text, cell)
    text = re.sub(r"^\.subckt\s+%s\s.*?^\.ends.*?$" % re.escape(cell), "", text, flags=re.M | re.S | re.I)
    p = open(pex).read()
    p = re.sub(r"^\.end\s*$", "", p, flags=re.M)
    flat = flat or cell + "_flat"
    pex_ports = ports(p, flat)
    wrap = ".subckt %s %s\nXPEX %s %s\n.ends\n" % (cell, " ".join(sch_ports), " ".join(pex_ports), flat)
    missing = set(pex_ports) - set(sch_ports)
    if missing:
        raise ValueError("PEX ports not in schematic: %s" % missing)
    return text.replace(".end\n", "") .rstrip() + "\n" + p + "\n" + wrap + ".end\n"


def tb_parts(tb):
    """header (options/models) and the subcircuit section of a generated testbench netlist"""
    t = open(run.netlist(tb)).read()
    hdr = t[:t.index("**.subckt %s" % tb)]
    models = t[t.index("**** begin user architecture code"):t.index(".control")] if ".control" in t else ""
    subs = t[t.index("* expanding"):].replace(".end\n", "")
    return hdr, models, subs


def sim(top, tb="tb_if", cell=None, tag="pex", pex=None, flat=None):
    hdr, models, subs = tb_parts(tb)
    text = hdr + models + top + subs + "\n.end\n"
    if cell:
        text = swap(text, cell, pex, flat)
    return run.ngspice(text, tag)


VGA_TOP = '''
VDD vdd 0 3.3
XB nb pb vdd 0 bias_gen
XBIF pb nbif pbif vdd 0 bias_if
VIP inp 0 dc 1.2 ac 0.5
VIN inn 0 dc 1.2 ac 0.5 180
VGA ga 0 0
VGB gb 0 0
XV1 inp inn ga gb nbif a1p a1n vdd 0 vga
XF1 a1p a1n pbif f1p f1n vdd 0 sk_lpf1
.control
set num_threads=4
op
echo OP out=$&v(a1p) i=$&i(VDD)
foreach a 0 3.3
foreach b 0 3.3
alter VGA dc = $a
alter VGB dc = $b
ac dec 40 1e5 1e8
let g = db(v(a1p)-v(a1n))
meas ac g4 find g at=4e6
let gm = vecmax(g)
let g3 = gm - 3
meas ac fh when g=g3 fall=last
meas ac fl when g=g3 rise=1
echo CODE $a $b g4=$&g4 fl=$&fl fh=$&fh
end
end
.endc
'''

if __name__ == "__main__":
    for c in (None, "vga"):
        out = sim(VGA_TOP, cell=c, tag="vga_" + (c or "sch"))
        print("==", "PEX" if c else "schematic")
        print("\n".join(l for l in out.splitlines() if l.startswith(("OP", "CODE"))))
