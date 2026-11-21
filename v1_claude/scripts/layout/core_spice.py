"""Transistor-level simulation of the whole digital core of the chip (SPI write + readback) at 3.3 V.
The placed-and-routed netlist chip/final/pnl/chip_top.pnl.v is converted to SPICE with the PDK netlists of
the standard cells and the pads (fill / tap / decap cells, supply pads and the analog macro are left out),
and every net gets its total wire capacitance from chip/final/spef/max.  The macro inputs are loaded with
CMAC, its outputs (I/Q bits, CLKOUT) are driven by sources so that the data pads switch during the frames.
Three SPI frames: W1, W2, W2.  SDO must read the reset value, then W1, then W2 (ID in the upper 5 bits).
  case: (model corner, temperature, supply, SCLK frequency)
usage: core_spice.py run [case ...] | core_spice.py ana [case ...]"""
import os, re, sys, subprocess
import numpy as np
ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
OUT = os.path.join(ROOT, "sim", "core")
PDK = os.path.expanduser("~/pdk/gf180mcuD")
FIN = os.path.join(ROOT, "chip", "final")
CASES = {"ss125_3v0_10M": ("ss", 125, 3.0, 10e6),
         "tt27_3v3_10M": ("typical", 27, 3.3, 10e6), "ff_m40_3v465_10M": ("ff", -40, 3.465, 10e6)}
W1 = 0x52A5A5 & 0x7FFFF | (0x0A << 19)      # reserved bits 23..19 are not stored
W2 = 0x2D5A5A & 0x7FFFF | (0x15 << 19)
RST = 0x08000      # value of the control register after reset (AFC7 = 1)
ID = 0b10101
CLOAD = 30e-12; CMAC = 30e-15; TR = 2e-9; DT = 50e-12
SKIP = re.compile(r"fill|endcap|__cor$|__dvdd$|__dvss$|asig_5p0|ws_ip|afe_rf|gnss_afe_analog")
MAC_OUT = {"I_SIGN": 1.3e6, "I_MAG": 0.9e6, "Q_SIGN": 1.7e6, "Q_MAG": 0.7e6, "CLKOUT": 16.368e6}


def subckts():
    p = {}
    for f in ("gf180mcu_fd_sc_mcu7t5v0/spice/gf180mcu_fd_sc_mcu7t5v0.spice", "gf180mcu_fd_io/spice/gf180mcu_fd_io.spice"):
        for m in re.finditer(r"^\.subckt\s+(\S+)\s+(.*(?:\n\+.*)*)", open(PDK + "/libs.ref/" + f).read(), re.M | re.I):
            p[m.group(1)] = m.group(2).replace("\n+", " ").split()
    return p


def netname(s):
    return s.strip().lstrip("\\").strip()


def convert(vdd="vdd", vss="0"):
    """-> (spice lines, {verilog net: spice node}, macro pin -> net); vdd / vss: nodes of the VDD / VSS nets"""
    v = open(FIN + "/pnl/chip_top.pnl.v").read()
    sub = subckts(); node = {"VDD": vdd, "VSS": vss}; lines = []; mac = {}

    def nd(n):
        n = netname(n)
        return node.setdefault(n, "n%d" % len(node))
    for m in re.finditer(r"^\s*(\S+)\s+(\\\S+\s|\S+)\s*\((.*?)\);", v[v.index(";", v.index("module")):], re.M | re.S):
        typ, name, body = m.group(1), netname(m.group(2)), m.group(3)
        if typ in ("inout", "wire", "input", "output"):
            continue
        pins = dict((a, b) for a, b in re.findall(r"\.(\w+)\(\s*(.*?)\s*\)\s*(?:,|$)", body, re.S))
        if typ == "gnss_afe_analog":
            mac = {k: netname(n) for k, n in pins.items()}
        if SKIP.search(typ):
            continue
        # an output that is not connected in the netlist gets a node of its own
        lines.append("X%d %s %s" % (len(lines), " ".join(nd(pins[p]) if p in pins and pins[p].strip() else "nc%d_%s" % (len(lines), p)
                                                         for p in sub[typ]), typ))
    # wire capacitance
    spef = open([os.path.join(FIN, "spef", "max", f) for f in os.listdir(FIN + "/spef/max")][0]).read()
    nm = dict(re.findall(r"^(\*\d+) (\S+)$", spef, re.M))
    for k, c in re.findall(r"^\*D_NET (\S+) (\S+)$", spef, re.M):
        n = nm.get(k, k).replace("\\", "")
        if n in node and node[n] not in (vss, vdd):
            lines.append("CW%d %s %s %sp" % (len(lines), node[n], vss, c))
    return lines, node, mac


def stim(vdd, f):
    """PWL of SCLK, SDI, CS_N for the three frames; -> (text, [(t of rising edges, word sent)], tend)"""
    T = 1 / f; t = 200e-9; ck = [(0, 0)]; di = [(0, 0)]; cs = [(0, 1)]; fr = []
    for w in (W1, W2, W2):
        cs += [(t, 1), (t + TR, 0)]; edges = []
        for k in range(24):
            b = (w >> (23 - k)) & 1
            di += [(t + k * T, di[-1][1]), (t + k * T + TR, b)]
            tr = t + k * T + T / 2
            ck += [(tr, 0), (tr + TR, 1), (tr + T / 2, 1), (tr + T / 2 + TR, 0)]
            edges.append(tr + TR / 2)
        te = t + 24 * T + T / 2
        cs += [(te, 0), (te + TR, 1)]
        fr.append((edges, w, t + TR / 2, te + TR / 2)); t = te + 300e-9

    def pwl(p):
        return "pwl(" + " ".join("%.5e %g" % (a, b * vdd) for a, b in p) + ")"
    return pwl(ck), pwl(di), pwl(cs), fr, t


def deck(case):
    lib, temp, vdd, f = CASES[case]
    lines, node, mac = convert()
    io = re.sub(r"(ppolyf_u[^\n]*?) m=1\.0 r=\S+", r"\1", open(PDK + "/libs.ref/gf180mcu_fd_io/spice/gf180mcu_fd_io.spice").read())
    ck, di, cs, fr, tend = stim(vdd, f)
    x = ["VD vdd 0 %g" % vdd, "VCK %s 0 %s" % (node["clk_PAD"], ck), "VDI %s 0 %s" % (node["input_PAD[0]"], di),
         "VCS %s 0 %s" % (node["input_PAD[1]"], cs), "VRST %s 0 pwl(0 0 50n 0 52n %g)" % (node["rst_n_PAD"], vdd)]
    for p, fo in MAC_OUT.items():
        x.append("VM%s %s 0 pulse(0 %g 30n 0.3n 0.3n %.5e %.5e)" % (p, node[mac[p]], vdd, 0.5 / fo - 0.3e-9, 1 / fo))
    for p, n in mac.items():
        if p not in MAC_OUT and n in node and node[n] not in ("0", "vdd") and not n.endswith("_PAD[0]") \
                and "analog_PAD" not in n and n != "rf_PAD":
            x.append("CM%s %s 0 %g" % (p, node[n], CMAC))
    for k in range(6):                     # bond wire + load on every output pad
        n = node["bidir_PAD[%d]" % k]
        x += ["LB%d %s pb%d 1.5n" % (k, n, k), "RPB%d %s pb%d 300" % (k, n, k), "RB%d pb%d out%d 0.15" % (k, k, k), "CL%d out%d 0 %g" % (k, k, CLOAD)]
    ctl = [node[mac[p]] for p in ("IG1A IG1B IG2A IG2B IG3A IG3B B0 B1 AFC0 AFC1 AFC2 AFC3 AFC4 AFC5 AFC6 AFC7 ICP2 BWK BWN").split()]
    sv = " ".join("v(%s)" % n for n in [node["clk_PAD"], node["input_PAD[1]"], "out5", node["bidir_PAD[5]"]] + ctl)
    return """* digital core + pads, %s
.include %s/libs.tech/ngspice/design.ngspice
.lib %s/libs.tech/ngspice/sm141064.ngspice %s
.lib %s/libs.tech/ngspice/sm141064.ngspice res_typical
.lib %s/libs.tech/ngspice/sm141064.ngspice diode_typical
.lib %s/libs.tech/ngspice/sm141064.ngspice moscap_typical
.include %s/libs.ref/gf180mcu_fd_sc_mcu7t5v0/spice/gf180mcu_fd_sc_mcu7t5v0.spice
%s
.temp %g
%s
%s
.option method=gear reltol=1e-3
.control
set num_threads=5
save %s
tran %g %g 0 %g
rusage time
linearize
wrdata %s_out %s
.endc
.end
""" % (case, PDK, PDK, lib, PDK, PDK, PDK, PDK, io, temp, "\n".join(x), "\n".join(lines), sv, DT, tend, 10 * DT, case, sv)


def run(cases):
    for c in cases:
        open(os.path.join(OUT, c + ".spice"), "w").write(deck(c))
        for f in (c + ".end", c + "_out"):
            if os.path.exists(os.path.join(OUT, f)):
                os.remove(os.path.join(OUT, f))
        subprocess.Popen(["nohup", "sh", "-c", "ngspice -b %s.spice > %s.log 2>&1; date > %s.end" % ((c,) * 3)], cwd=OUT,
                         stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, start_new_session=True)
        print("started", c)


def ana(cases):
    for c in cases:
        lib, temp, vdd, f = CASES[c]
        d = np.loadtxt(os.path.join(OUT, c + "_out")); t = d[:, 0]
        ck, cs, sdo, pad = (d[:, 2 * k + 1] for k in range(4)); ctl = [d[:, 2 * k + 1] for k in range(4, 23)]
        fr = stim(vdd, f)[3]; T = 1 / f; hi, lo = 0.7 * vdd, 0.3 * vdd
        at = lambda s, x: s[min(np.searchsorted(t, x), len(t) - 1)]
        ok = True; print("== %s  (SCLK %g MHz, half period %.0f ns)" % (c, f / 1e6, T / 2e9 * 1e18))
        exp_ctl = RST
        for i, (edges, w, t0, t1) in enumerate(fr):
            exp = (ID << 19) | exp_ctl; got = 0; marg = []
            for k, te in enumerate(edges):
                b = (exp >> (23 - k)) & 1; v = at(sdo, te); got = (got << 1) | (1 if v > vdd / 2 else 0)
                # SDO must be at a valid level from tv until the rising edge: time of the last crossing of the threshold
                tb = t0 if k == 0 else edges[k - 1] + T / 2
                m = (t >= tb) & (t <= te); bad = np.where(m & ((sdo < hi) if b else (sdo > lo)))[0]
                marg.append((te - (t[bad[-1]] if len(bad) else tb)) * 1e9)
                if len(bad) and t[bad[-1]] >= te - 2 * DT:
                    ok = False
            dly = [T / 2 * 1e9 - x for x in marg[1:]]
            print("  frame %d: sent %06X, SDO read %06X (expected %06X) %s; SCLK fall -> SDO valid max %.1f ns; CS_N fall -> first bit valid %.1f ns;"
                  " least margin before the rising edge %.1f ns" % (i + 1, w, got, exp, "OK" if got == exp else "MISMATCH",
                                                                 max(dly), (edges[0] - t0) * 1e9 - marg[0], min(marg)))
            ok &= got == exp
            exp_ctl = w & 0x7FFFF
            tc = t1 + 100e-9
            val = sum((1 if at(s, tc) > vdd / 2 else 0) << k for k, s in enumerate(ctl)) ^ (1 << 17)      # BWK = ~ctl[17]
            lv = all(at(s, tc) > 0.9 * vdd or at(s, tc) < 0.1 * vdd for s in ctl)
            print("           control outputs 100 ns after CS_N rises: %05X (expected %05X) %s, full swing %s; SDO %.2f V 250 ns after CS_N rises"
                  % (val, exp_ctl, "OK" if val == exp_ctl else "MISMATCH", lv, at(sdo, t1 + 250e-9)))
            ok &= val == exp_ctl and lv
        print("  ->", "PASS" if ok else "FAIL")


if __name__ == "__main__":
    os.makedirs(OUT, exist_ok=True)
    cs = sys.argv[2:] or list(CASES)
    run(cs) if sys.argv[1] == "run" else ana(cs)
