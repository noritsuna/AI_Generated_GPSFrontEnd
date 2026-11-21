"""Review A-4 / A-5: LNA (PEX) with the RFIN pad, ESD diodes, bond wire and the board match.
  * S11 / gain / NF at 1575.42 MHz in the tt / ss / ff corners
  * source-side stability: Re(Zin) looking into the chip pin (bond wire included) and into the
    matched port, 1 MHz .. 20 GHz (Re(Zin) > 0 everywhere = stable for any passive source)
  * noise breakdown at 1575.42 MHz (tt): contribution of every device / extracted resistor
usage: lna_chk.py [--sch]"""
import os, sys, re, math
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "layout"))
os.environ.setdefault("PDK", "gf180mcuD"); os.environ.setdefault("PDK_ROOT", os.path.expanduser("~/pdk"))
import rfin_match
from pexsim import run

CORN = {"tt": ("typical", 27, 3.3), "ss": ("ss", 85, 3.135), "ff": ("ff", -20, 3.465),
        "tt85": ("typical", 85, 3.3), "ttm20": ("typical", -20, 3.3)}
MATCH = {"serL6n_shC2p7": (1.0, 2.7e-12, 6e-9), "shL3n3_w1n": (3.3e-9, 1e-18, 1e-9)}   # LP, CP, LS
F0 = 1575.42e6


def deck(corner, match, sch=False):
    lib, temp, v = CORN[corner]
    lp, cp, ls = MATCH[match]
    if sch:
        sw = rfin_match.pexsim.swap
        rfin_match.pexsim.swap = lambda t, c: t
    t = rfin_match.deck(True)
    if sch:
        rfin_match.pexsim.swap = sw
    t = t.replace("VDD vdd 0 3.3", "VDD vdd 0 %g" % v)
    assert "VDD vdd 0 %g" % v in t
    if lib != "typical":
        t, k = re.subn(r"(sm141064\.ngspice) (res_|mimcap_|diode_)?typical", lambda m: "%s %s%s" % (m.group(1), m.group(2) or "", lib), t)
        assert k == 4, k
    body = ("set num_threads=1\nalter LP = %g\nalter CP = %g\nalter LS = %g\nop\necho RES op idd=$&i(VDD) vpad=$&v(pad)\n" % (lp, cp, ls) +
            "ac lin 1 %g %g\nlet zin = v(s1)/(-i(VRF))\nlet s11 = db((zin-50)/(zin+50))\nlet gd = db((v(rfp)-v(rfn))/v(s0)*2)\n"
            "let gp = v(rfp)/v(s0)*2\nlet gn = v(rfn)/v(s0)*2\nlet bal = db(mag(gp)/mag(gn))\nlet ph = (cph(gp)-cph(gn))*180/pi\n"
            "echo RES f0 s11=$&s11 gd=$&gd bal=$&bal ph=$&ph\n" % (F0, F0) +
            "alter LP = 1\nalter CP = 1e-18\nalter LS = 1e-12\nac dec 40 1e6 2e10\nlet rs = real(v(s1)/(-i(VRF)))\n"
            "let gdb = db((v(rfp)-v(rfn))/v(s0)*2)\n"
            "meas ac rsmin min rs\nmeas ac frsmin min_at rs\nmeas ac gmax max gdb\nmeas ac fgmax max_at gdb\n"
            "echo RES stab rsmin=$&rsmin frsmin=$&frsmin gmax=$&gmax fgmax=$&fgmax\n"
            "alter LP = %g\nalter CP = %g\nalter LS = %g\ndestroy all\n"
            "noise v(rfp,rfn) VRF lin 2 %g %g 1\nsetplot noise1\nlet nf = 10*log10(inoise_spectrum^2/(4*1.380649e-23*300*50))\n"
            "let nf0 = nf[0]\necho RES nf=$&nf0\nsetplot noise2\nprint all\n" % (lp, cp, ls, F0, F0 + 1e6))
    t, k = re.subn(r"^\.control.*?^\.endc", lambda m: ".temp %g\n.control\n" % temp + body + ".endc", t, flags=re.M | re.S)
    assert k == 1
    return t


def main():
    sch = "--sch" in sys.argv
    for match in MATCH:
        for corner in CORN:
            out = run.ngspice(deck(corner, match, sch), "rev_lna_%s_%s" % (corner, match), timeout=20000)
            print("== %s %s %s" % ("sch" if sch else "pex", corner, match))
            print("\n".join(l for l in out.splitlines() if l.startswith("RES") or "rror" in l or "failed" in l))
            if corner == "tt":
                # integrated output noise (V rms in 1 MHz) per device -> power share relative to the 50 ohm source
                c = {}
                for l in out.splitlines():
                    m = re.match(r"onoise_total(\S*)\s*=\s*(\S+)", l)
                    if m:
                        c[m.group(1)] = float(m.group(2)) ** 2
                src = c["_rs50"]
                top = sorted(((v, k) for k, v in c.items() if re.search(r"(\.m0|\.r\d+|_rw|\.x\d+|\.xr\w+|_d[np]\d)$", k)), reverse=True)
                wire = sum(v for k, v in c.items() if re.search(r"xpex\.r\d+$", k))
                print("  F = %.3f (NF %.2f dB); extracted wire resistors together %.2f %% of the source noise" % (
                    c[""] / src, 10 * math.log10(c[""] / src), 100 * wire / src))
                for v, k in top[:12]:
                    print("   %6.2f %%  %s" % (100 * v / src, k.lstrip("._")))
            sys.stdout.flush()


if __name__ == "__main__":
    main()
