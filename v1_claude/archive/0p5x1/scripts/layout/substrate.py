"""Substrate coupling estimate.

The NMOS bodies, the ppolyf resistor wells and (in PEX netlists) the parasitic capacitances to VSS are
moved from VSS to a separate substrate node SUB (split()).  Victims are driven from SUB, aggressors
are measured as the current they push into SUB.  The block-to-block substrate transfer impedance comes
from a lumped tap / bulk-spreading model of the macro floorplan (zt()).

usage: substrate.py run [case ...] | substrate.py ana [case ...]
cases: if1 if3 (IF chain PEX, AC, gain code 1 / 3), rx_if rx_rf rx_ref (LNA + mixer PEX, tran),
       agg_pll (VCO + PLL, tran), agg_ifadc (IF chain + ADC with a 4.13 MHz tone, tran)."""
import os, re, sys, numpy as np
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.dirname(HERE)); sys.path.insert(0, HERE)
import run, pexsim
OUT = os.path.abspath(os.path.join(HERE, "..", "..", "sim", "substrate"))
os.makedirs(OUT, exist_ok=True)
PRIM = ("nfet_03v3", "pfet_03v3", "ppolyf_u_1k", "cap_mim_2f0_m4m5_noshield")
FIF = 4.092e6


def split(text):
    lines = []
    for l in text.split("\n"):                       # join "+" continuations
        if l.startswith("+") and lines:
            lines[-1] += " " + l[1:].strip()
        else:
            lines.append(l)
    subs = {m.lower() for m in re.findall(r"^\.subckt\s+(\S+)", text, re.M | re.I)}
    out, sub = [], "sub"
    for l in lines:
        t = l.split()
        if not t:
            out.append(l); continue
        k = t[0].lower()
        if k == ".subckt":
            out.append(l + " SUB"); sub = "SUB"; continue
        if k.startswith(".ends"):
            out.append(l); sub = "sub"; continue
        if k[0] == "x":
            i = next((j for j in range(1, len(t)) if t[j].lower() in subs or t[j] in PRIM), None)
            if i is not None:
                m = t[i]
                if m.lower() in subs:
                    t.insert(i, sub)
                elif m == "nfet_03v3":
                    t[4] = sub
                elif m == "ppolyf_u_1k":
                    t[3] = sub
                l = " ".join(t)
        elif k[0] == "c" and sub == "SUB" and len(t) >= 4 and "VSS" in t[1:3]:
            t[t.index("VSS", 1)] = sub                # PEX: parasitic C to the substrate
            l = " ".join(t)
        out.append(l)
    return "\n".join(out)


def build(tb, top, cells=()):
    hdr, models, subs = pexsim.tb_parts(tb)
    text = hdr + models + top + subs + "\n.end\n"
    for c in cells:
        text = pexsim.swap(text, c)
    return split(text)


IF_TOP = '''VDD vdd 0 3.3
XB nb pb vdd 0 bias_gen
VIP inp 0 dc 2.1 ac 0.5
VIN inn 0 dc 2.1 ac 0.5 180
VG1A g1a 0 %(a)g
VG1B g1b 0 %(b)g
VG2A g2a 0 %(a)g
VG2B g2b 0 %(b)g
VG3A g3a 0 %(a)g
VG3B g3b 0 %(b)g
VSUB sub 0 dc 0 ac 0
XIF inp inn g1a g1b g2a g2b g3a g3b pb outp outn vdd 0 if_chain
CLP outp 0 100f
CLN outn 0 100f
.option method=gear
.control
set num_threads=4
ac lin 1 %(f)g %(f)g
let gd = mag(v(outp)-v(outn))
echo RES sig gd=$&gd
alter @VIP[acmag] = 0
alter @VIN[acmag] = 0
alter @VSUB[acmag] = 1
ac lin 1 %(f)g %(f)g
let sd = mag(v(outp)-v(outn))
let sc = mag((v(outp)+v(outn))/2)
echo RES sub sd=$&sd sc=$&sc
.endc
'''

LO = '''VL1P l1p 0 pulse(0 2.0 0.000p 60p 60p 576.404p 1272.809p)
VL1N l1n 0 pulse(0 2.0 636.404p 60p 60p 576.404p 1272.809p)
VL2P l2p 0 pulse(0 2.0 159.101p 60p 60p 576.404p 1272.809p)
VL2N l2n 0 pulse(0 2.0 795.505p 60p 60p 576.404p 1272.809p)
VL3P l3p 0 pulse(0 2.0 318.202p 60p 60p 576.404p 1272.809p)
VL3N l3n 0 pulse(0 2.0 954.607p 60p 60p 576.404p 1272.809p)
VL4P l4p 0 pulse(0 2.0 477.303p 60p 60p 576.404p 1272.809p)
VL4N l4n 0 pulse(0 2.0 1113.708p 60p 60p 576.404p 1272.809p)
'''
RX_TOP = '''VDD vdd 0 3.3
XB nb pb vdd 0 bias_gen
''' + LO + '''VRF s0 0 sin(0 %(arf)g 1575.42e6)
RS50 s0 s1 50
CIN s1 rfin 10p
VSUB sub 0 dc 0 sin(0 %(asub)g %(fsub)g)
XLNA rfin pb rfp rfn vdd 0 lna_nc
XM rfp rfn l1p l1n l2p l2n l3p l3n l4p l4n nb ifip ifin ifqp ifqn vdd 0 mixer_iq
.option method=gear
.control
set num_threads=4
tran 5p 1.0u 0 5p
linearize v(ifip) v(ifin) v(ifqp) v(ifqn) v(rfin)
wrdata %(out)s v(ifip,ifin) v(ifqp,ifqn) v(ifip) v(rfin)
.endc
'''
# bodies tied to VSS through a 0 V source: its current is what the circuit injects into the substrate
PLL_TOP = '''VDD vdd 0 3.3
VDDV vddv 0 3.3
VSUBT sub 0 0
XB nb pb vdd 0 bias_gen
VREF refin 0 sin(1.65 0.4 16.368e6)
VB0 b0 0 0
VB1 b1 0 0
XVCO vctrl b0 b1 nb l1p l1n l2p l2n l3p l3n l4p l4n ckr vr vddv 0 vco_ring4
VICP2 icp2 0 0
XPLL refin ckr nb pb icp2 vctrl fs fb refck vdd 0 pll_core
CLl1p l1p 0 150f
CLl1n l1n 0 150f
CLl2p l2p 0 150f
CLl2n l2n 0 150f
CLl3p l3p 0 150f
CLl3n l3n 0 150f
CLl4p l4p 0 150f
CLl4n l4n 0 150f
CFS fs 0 300f
.option method=gear reltol=2e-4
.ic v(vctrl)=1.56 v(xpll.xlf.z)=1.56 v(xpll.vcp)=1.56 v(xvco.xcore.p4)=0 v(xvco.xcore.n4)=2
.control
set num_threads=1
save v(vctrl) i(VSUBT) i(VDD) i(VDDV)
tran 2p 2.5u 0 2p uic
wrdata %(out)s i(VSUBT) v(vctrl) i(VDD) i(VDDV)
.endc
'''
IFADC_TOP = '''VDD vdd 0 3.3
VSUBT sub 0 0
XB nb pb vdd 0 bias_gen
VTP inp 0 dc 2.0 sin(2.0 %(a)g 4.13e6)
VTN inn 0 dc 2.0 sin(2.0 %(a)g 4.13e6 0 0 180)
VG1A ig1a 0 3.3
VG1B ig1b 0 0
VG2A ig2a 0 3.3
VG2B ig2b 0 0
VG3A ig3a 0 3.3
VG3B ig3b 0 0
XIF inp inn ig1a ig1b ig2a ig2b ig3a ig3b pb aop aon vdd 0 if_chain
VCK clk 0 pulse(0 3.3 0 0.3n 0.3n 30.2474n 61.0948n)
XA aop aon clk sign mag vdd 0 adc2b
.option method=gear
.control
set num_threads=1
tran 0.1n 6u 0 0.1n
wrdata %(out)s i(VSUBT) v(aop,aon) v(sign) v(mag) i(VDD)
.endc
'''


def deck(name):
    if name in ("if1", "if3"):
        a, b = (3.3, 0) if name == "if1" else (3.3, 3.3)
        return build("tb_if", IF_TOP % dict(a=a, b=b, f=FIF), ["if_chain"])
    if name.startswith("rx_"):
        arf, asub, fsub = {"rx_if": (0, 1e-3, FIF), "rx_rf": (0, 1e-3, 1575.42e6), "rx_ref": (1e-3, 0, 1e6)}[name]
        return build("tb_rx", RX_TOP % dict(arf=arf, asub=asub, fsub=fsub, out=os.path.join(OUT, name)), ["lna_nc", "mixer_iq"])
    if name == "agg_pll":
        return build("tb_pll", PLL_TOP % dict(out=os.path.join(OUT, name)))
    if name == "agg_ifadc":
        return build("tb_ifadc", IFADC_TOP % dict(a=92e-6, out=os.path.join(OUT, name)), ["if_chain"])
    raise KeyError(name)


def tone(t, y, f, a, b):
    n = int((b - a) * f); b = a + n / f
    tu = np.arange(a, b, min(1 / f / 40, 1e-9)); x = np.interp(tu, t, y)
    return 2 * np.mean((x - x.mean()) * np.exp(-2j * np.pi * f * tu))


# ---------------------------------------------------------------- substrate network
# floorplan of the macro (um): x1, x2, y1, y2 (gnss_afe_analog.gds)
BLK = {"ifI": (22.3, 820.6, 380.5, 1198.8), "ifQ": (22.3, 820.6, 1214.2, 2032.5),
       "adcI": (22.3, 409.0, 11.6, 364.5), "adcQ": (415.0, 801.7, 11.6, 364.5),
       "pll": (22.3, 597.3, 2047.9, 2975.5), "vco": (250.3, 857.0, 2991.0, 3347.6),
       "lna": (22.3, 245.9, 3363.2, 3542.5), "mix": (251.9, 574.2, 3363.4, 3702.2)}


def zt(rho, aggr, vict, tap_pitch=20.0):
    """Transfer impedance (ohm) from current injected into the substrate under block aggr to the
    substrate voltage (vs local VSS) under block vict.  Each block: surface node tied to VSS by its taps
    (rows of taps every tap_pitch um) and to the bulk by the spreading resistance rho/(4a) of a disc
    of the same area; blocks see each other through the bulk with the mutual term rho/(2 pi d).
    rho in ohm*m."""
    names = list(BLK)
    n = len(names)
    cen = {k: ((v[0] + v[1]) / 2e6, (v[2] + v[3]) / 2e6) for k, v in BLK.items()}
    W = {k: (v[1] - v[0]) * 1e-6 for k, v in BLK.items()}; H = {k: (v[3] - v[2]) * 1e-6 for k, v in BLK.items()}
    # bulk impedance matrix between the blocks' footprints (half space)
    R = np.zeros((n, n))
    for i, a in enumerate(names):
        for j, b in enumerate(names):
            if i == j:
                R[i, j] = rho / (4 * np.sqrt(W[a] * H[a] / np.pi))
            else:
                d = np.hypot(cen[a][0] - cen[b][0], cen[a][1] - cen[b][1])
                R[i, j] = rho / (2 * np.pi * d)
    # taps: strips across the block width at tap_pitch, strip spreading ~ rho/(pi L) * ln(pitch/w)
    rt = np.array([3 * rho * tap_pitch * 1e-6 / (np.pi * W[k] * H[k]) for k in names])
    # surface node voltage v = R (i_inj - v/rt)  ->  (I + R/rt) v = R i_inj
    i_inj = np.zeros(n); i_inj[names.index(aggr)] = 1.0
    v = np.linalg.solve(np.eye(n) + R / rt[None, :], R @ i_inj)
    return v[names.index(vict)], v[names.index(aggr)]


def ana(name):
    if name in ("if1", "if3"):
        o = open(os.path.join(OUT, name + ".log")).read()
        g = float(re.search(r"RES sig gd=(\S+)", o).group(1)); sd, sc = map(float, re.search(r"RES sub sd=(\S+) sc=(\S+)", o).groups())
        return "%s @4.092 MHz: signal gain %.1f dB, SUB->diff out %.1f dB (input-referred %.2e V/V), SUB->CM out %.1f dB" % (
            name, 20 * np.log10(g), 20 * np.log10(sd), sd / g, 20 * np.log10(sc))
    if name.startswith("rx_"):
        d = np.loadtxt(os.path.join(OUT, name)); t = d[:, 0]
        a, b = 0.3e-6, 1.0e-6
        vi = abs(tone(t, d[:, 1], FIF, a, b)); vq = abs(tone(t, d[:, 3], FIF, a, b))
        return "%s: IF I / Q at 4.092 MHz %.3e / %.3e V" % (name, vi, vq)
    if name == "agg_pll":
        d = np.loadtxt(os.path.join(OUT, name)); t = d[:, 0]; i = d[:, 1]
        a, b = 1.0e-6, 2.5e-6
        r = "agg_pll: I(sub) dc %.1f uA, rms(ac) %.1f uA" % (1e6 * i[t > a].mean(), 1e6 * i[t > a].std())
        for f in (16.368e6, 32.736e6, 785.664e6, 1571.328e6, 3142.656e6, FIF):
            r += " | %.1f MHz %.2f uA" % (f / 1e6, 1e6 * abs(tone(t, i, f, a, b)))
        return r
    if name == "agg_ifadc":
        d = np.loadtxt(os.path.join(OUT, name)); t = d[:, 0]; i = d[:, 1]
        a, b = 2.0e-6, 6.0e-6
        r = "agg_ifadc: I(sub) dc %.1f uA, rms(ac) %.1f uA, IF out %.1f mVpk" % (
            1e6 * i[t > a].mean(), 1e6 * i[t > a].std(), 1e3 * abs(tone(t, d[:, 3], 4.13e6, a, b)))
        for f in (4.13e6, 8.26e6, 16.368e6, 16.368e6 - 4.13e6):
            r += " | %.2f MHz %.3f uA" % (f / 1e6, 1e6 * abs(tone(t, i, f, a, b)))
        return r


if __name__ == "__main__":
    cmd, names = sys.argv[1], sys.argv[2:] or ["if1", "if3", "rx_if", "rx_rf", "rx_ref", "agg_pll", "agg_ifadc"]
    if cmd == "run":
        decks = {n: deck(n) for n in names}          # netlists first (xschem is not thread safe)
        from concurrent.futures import ThreadPoolExecutor
        def go(n):
            o = run.ngspice(decks[n], "sub_" + n, timeout=10 * 3600)
            open(os.path.join(OUT, n + ".log"), "w").write(o)
            return n, [l for l in o.splitlines() if l.startswith("RES") or "rror" in l][:6]
        with ThreadPoolExecutor(len(names)) as ex:
            for n, r in ex.map(go, names):
                print(n, r, flush=True)
    if cmd == "zt":
        for rho in (0.01, 0.1, 0.5):
            for a, v in (("vco", "lna"), ("vco", "mix"), ("pll", "ifQ"), ("adcI", "ifI"), ("ifI", "ifI"), ("ifQ", "mix")):
                zv, za = zt(rho, a, v)
                print("rho %.0f ohm.cm  %s -> %s: %.3g ohm (self %.3g ohm)" % (rho * 100, a, v, zv, za))
        sys.exit()
    for n in names:
        try: print(ana(n), flush=True)
        except Exception as e: print(n, "ana failed:", e)
