"""RFIN input match with the pad and the bond wire (LNA PEX + mixer load, tb_lna, 1575.42 MHz):
the gf180mcu_fd_io__asig_5p0 pad (metal capacitance from a magic extraction of the pad cell,
0.54 pF to DVDD = VDDA and 0.70 pF to VSS, and its ESD diodes with the PDK models), the macro
RFIN wire (top_wires.json) and a series inductance LS (bond wire + external inductor) after the
10 pF coupling capacitor, optionally a shunt inductor or capacitor on the source side of that capacitor.
usage: rfin_match.py [corner=tt]"""
import os, sys, re, json
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
os.environ.setdefault("PDK", "gf180mcuD"); os.environ.setdefault("PDK_ROOT", os.path.expanduser("~/pdk"))
import pexsim
from pexsim import run

CPAD_VDD, CPAD_VSS = 0.54e-12, 0.70e-12        # asig_5p0 metal (magic, halo 2 um)
LS = [0, 1, 1.5, 2, 2.5, 3, 4, 5, 6, 7, 8]     # nH
LP = [0, 2.7, 3.3, 3.9, 4.7, 5.6, 6.8, 10, 15, -1.5, -2.2, -2.7, -3.3]   # shunt at the source: nH, 0 = none, negative = capacitor in pF
F0 = 1575.42e6


def deck(pad=True):
    w = json.load(open(os.environ.get("TOP_WIRES", os.path.join(pexsim.MAG, "top_wires.json"))))["RFIN"]   # TOP_WIRES: compare with another extraction
    t = open(run.netlist("tb_lna")).read()
    t = pexsim.swap(t, "lna_nc")
    net = "RS50 s0 s1 50\nLP s1 0 1\nCP s1 0 1a\nCIN s1 s2 10p\nLS s2 pad 1p\n"
    if pad:
        net += ("CPV pad vdd %g\nCPS pad 0 %g\n" % (CPAD_VDD, CPAD_VSS) +
                "".join("DN%d 0 pad diode_nd2ps_06v0 area=150e-12 pj=106e-6\nDP%d pad vdd diode_pd2nw_06v0 area=150e-12 pj=106e-6\n" % (i, i)
                        for i in range(4)))
    net += "RW pad rfin %g\nCW rfin 0 %g\n" % (max(w["r"], 1e-3), w["c"])
    t, k = re.subn(r"^RS50 s0 s1 50\nCIN s1 rfin 10p\n", lambda m: net, t, flags=re.M)
    assert k == 1
    t = t.replace("sm141064.ngspice mimcap_typical", "sm141064.ngspice mimcap_typical\n.lib %s/gf180mcuD/libs.tech/ngspice/sm141064.ngspice diode_typical"
                  % os.environ["PDK_ROOT"])
    body = "set num_threads=1\nop\necho RES op vpad=$&v(pad) idd=$&i(VDD)\n"
    for lp in LP:
        body += "alter LP = %g\nalter CP = %g\n" % (lp * 1e-9 if lp > 0 else 1.0, -lp * 1e-12 if lp < 0 else 1e-18)
        for ls in LS:
            body += ("alter LS = %g\nac lin 1 %g %g\nlet zin = v(s1)/(-i(VRF))\nlet s11 = db((zin-50)/(zin+50))\n"
                     "let gd = db((v(rfp)-v(rfn))/v(s0)*2)\nlet zr = real(zin)\nlet zi = imag(zin)\n"
                     "noise v(rfp,rfn) VRF lin 1 %g %g\nsetplot noise1\nlet nf = 10*log10(inoise_spectrum^2/(4*1.380649e-23*300*50))\n"
                     "echo RES lp=%g ls=%g zr=$&ac1.zr zi=$&ac1.zi s11=$&ac1.s11 gd=$&ac1.gd nf=$&nf\ndestroy all\n"
                     % (max(ls, 1e-3) * 1e-9, F0, F0, F0, F0, lp, ls))
    t, k = re.subn(r"^\.control.*?^\.endc", lambda m: ".control\n" + body + ".endc", t, flags=re.M | re.S)
    assert k == 1
    return t


def main():
    for pad in (False, True):
        out = run.ngspice(deck(pad), "rfin_%s" % ("pad" if pad else "nopad"), timeout=20000)
        print("== %s" % ("with the pad (metal C + ESD diodes)" if pad else "no pad (macro pin, as in tb_lna)"))
        rows = [dict(kv.split("=") for kv in l.split()[1:]) for l in out.splitlines() if l.startswith("RES lp")]
        print("\n".join(l for l in out.splitlines() if l.startswith("RES op") or "rror" in l))
        for lp in LP:
            print(" shunt at the source: %s" % ("none" if not lp else "L %g nH" % lp if lp > 0 else "C %g pF" % -lp))
            for r in rows:
                if float(r["lp"]) == lp:
                    print("   LS %4s nH  Zin %6.1f %+6.1fj  S11 %6.2f dB  gain %5.2f dB  NF %.2f dB" % (
                        r["ls"], float(r["zr"]), float(r["zi"]), float(r["s11"]), float(r["gd"]), float(r["nf"])))


if __name__ == "__main__":
    main()
