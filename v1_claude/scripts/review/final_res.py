"""Final check, part 4: value of every distinct resistor / MIM size in the PDK model against the sheet estimate
(ppolyf_u_1k 1 kohm/sq x L/W, MIM 2 fF/um2), at the typical / ss / ff resistor and capacitor corners and -20 / 27 / 85 C.
Short resistors (below about 2 squares) deviate from the sheet estimate through the end resistance and the length
correction of the model.  usage: final_res.py -> layout/review/final/res.log (stdout)"""
import os, sys, re
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))
os.environ.setdefault("PDK", "gf180mcuD"); os.environ.setdefault("PDK_ROOT", os.path.expanduser("~/pdk"))
import run
from review.final_devices import subckts, num

text = open(os.path.join(run.NET, "tb_full.spice")).read()
libs = "\n".join(l for l in text.splitlines() if l.strip().startswith((".include", ".lib")))
d = subckts(text)
res, cap = {}, {}
for sc, devs in d.items():
    for name, nd, kind, p in devs:
        if kind == "ppolyf_u_1k":
            res.setdefault((num(p["r_width"]), num(p["r_length"])), []).append(sc + "." + name)
        elif kind.startswith("cap_mim"):
            cap.setdefault((num(p["c_width"]), num(p["c_length"])), []).append(sc + "." + name)
out = {}
for c in ("typical", "ss", "ff"):
    for temp in (-20, 27, 85):
        t = libs
        if c != "typical":
            t, k = re.subn(r"(sm141064\.ngspice) (res_|mimcap_)?typical", lambda m: "%s %s%s" % (m.group(1), m.group(2) or "", c), t); assert k == 3
        t = "* resistor and capacitor values\n" + t + "\n.temp %d\nVB b 0 1.65\n" % temp
        ctl = ".control\nop\n"
        for i, (w, l) in enumerate(sorted(res)):
            t += "V%d r%d 0 1.75\nVL%d q%d 0 1.55\nXR%d r%d q%d 0 ppolyf_u_1k r_width=%gu r_length=%gu m=1\n" % (i, i, i, i, i, i, i, w * 1e6, l * 1e6)
            ctl += "let r = 0.2/(-i(V%d))\necho R %g %g $&r\n" % (i, w * 1e6, l * 1e6)
        ctl += "ac lin 1 1e6 1e6\n"
        for i, (w, l) in enumerate(sorted(cap)):
            t += "VC%d c%d 0 dc 1.65 ac 1\nXC%d c%d 0 cap_mim_2f0_m4m5_noshield c_width=%gu c_length=%gu m=1\n" % (i, i, i, i, w * 1e6, l * 1e6)
            ctl += "let c = imag(-i(VC%d))/(2*pi*1e6)\necho C %g %g $&c\n" % (i, w * 1e6, l * 1e6)
        log = run.ngspice(t + ctl + ".endc\n.end\n", "final_res_%s_%d" % (c, temp), timeout=600)
        for l in log.splitlines():
            f = l.split()
            if f and f[0] in "RC" and len(f) == 4:
                out[(f[0], round(float(f[1]), 2), round(float(f[2]), 2), c, temp)] = float(f[3])
        if not any(k[3] == c and k[4] == temp for k in out):
            print("\n".join(log.splitlines()[-6:]))
print("resistors (ppolyf_u_1k): W, L (um), sheet estimate, model at typical 27 C (ratio), range over 3 corners x 3 temperatures, users")
for (w, l), u in sorted(res.items()):
    w, l = round(w * 1e6, 2), round(l * 1e6, 2)
    v = [out[k] for k in out if k[0] == "R" and abs(k[1] - w) < 1e-6 and abs(k[2] - l) < 1e-6]
    typ = out[("R", w, l, "typical", 27)]
    print("  W %5.2f L %6.2f  sheet %8.0f  model %9.1f ohm (x%.3f)  min %9.1f (%+5.1f %%) max %9.1f (%+5.1f %%)  %d: %s" % (
        w, l, 1000 * l / w, typ, typ / (1000 * l / w), min(v), (min(v) / typ - 1) * 100, max(v), (max(v) / typ - 1) * 100, len(u), " ".join(u[:4])))
print("MIM capacitors (cap_mim_2f0_m4m5_noshield)")
for (w, l), u in sorted(cap.items()):
    w, l = round(w * 1e6, 2), round(l * 1e6, 2)
    v = [out[k] for k in out if k[0] == "C" and abs(k[1] - w) < 1e-6 and abs(k[2] - l) < 1e-6]
    typ = out[("C", w, l, "typical", 27)]
    print("  %5.1f x %5.1f  sheet %7.3f pF  model %7.3f pF (x%.3f)  min %+5.1f %% max %+5.1f %%  %d: %s" % (
        w, l, 2e-3 * w * l, typ * 1e12, typ / (2e-15 * w * l), (min(v) / typ - 1) * 100, (max(v) / typ - 1) * 100, len(u), " ".join(u[:4])))
