"""Placeholder views of gnss_afe_analog (until the real macro is exported)."""
import os, klayout.db as db
P = "/home/noritsuna/GPS/layout"
W, H = 1000.0, 3200.0
sig_n = ["RFIN", "REFIN", "AFCOUT", "VCTRL"]           # north edge (towards the analog pads)
sig_s = ["IG1A", "IG1B", "IG2A", "IG2B", "IG3A", "IG3B", "B0", "B1"] + ["AFC%d" % i for i in range(8)] + \
        ["ICP2", "I_SIGN", "I_MAG", "Q_SIGN", "Q_MAG", "CLKOUT"]
dirs = {n: "INPUT" for n in sig_s}; dirs.update({n: "OUTPUT" for n in ("I_SIGN", "I_MAG", "Q_SIGN", "Q_MAG", "CLKOUT")})
o = ["VERSION 5.7 ;", "BUSBITCHARS \"[]\" ;", "DIVIDERCHAR \"/\" ;", "MACRO gnss_afe_analog",
     "  CLASS BLOCK ;", "  ORIGIN 0 0 ;", "  SIZE %.3f BY %.3f ;" % (W, H)]
def pin(n, d, layer, r, use="SIGNAL"):
    o.extend(["  PIN %s" % n, "    DIRECTION %s ;" % d, "    USE %s ;" % use, "    PORT",
              "      LAYER %s ;" % layer, "        RECT %.3f %.3f %.3f %.3f ;" % r, "    END", "  END %s" % n])
for k, n in enumerate(sig_n):
    x = 60 + k * 40; pin(n, "INOUT", "Metal3", (x, H - 2, x + 2, H))
for k, n in enumerate(sig_s):
    x = 200 + k * 20; pin(n, dirs[n], "Metal2", (x, 0, x + 0.5, 2))
pin("VDDA", "INOUT", "Metal5", (0, H - 60, 30, H - 10), "POWER")
pin("VSS", "INOUT", "Metal5", (0, H - 120, 30, H - 70), "GROUND")
o += ["  OBS", "    LAYER Metal1 ;", "      RECT 0 0 %.3f %.3f ;" % (W, H),
      "    LAYER Metal2 ;", "      RECT 0 3 %.3f %.3f ;" % (W, H - 3),
      "    LAYER Metal3 ;", "      RECT 0 3 %.3f %.3f ;" % (W, H - 3),
      "    LAYER Metal4 ;", "      RECT 0 0 %.3f %.3f ;" % (W, H),
      "  END", "END gnss_afe_analog", "END LIBRARY"]
open(P + "/lef/gnss_afe_analog.lef", "w").write("\n".join(o) + "\n")
ly = db.Layout(); ly.dbu = 0.001; c = ly.create_cell("gnss_afe_analog")
c.shapes(ly.layer(0, 0)).insert(db.Box(0, 0, int(W * 1000), int(H * 1000)))   # PR boundary
ly.write(P + "/gds/gnss_afe_analog.gds")
ports = ["RFIN", "REFIN"] + sig_s[:17] + ["I_SIGN", "I_MAG", "Q_SIGN", "Q_MAG", "CLKOUT", "AFCOUT", "VCTRL", "VDDA", "VSS"]
open(P + "/spice/gnss_afe_analog.spice", "w").write(".subckt gnss_afe_analog " + " ".join(ports) + "\n.ends\n")
print("stub written")
