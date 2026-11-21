"""Bonding diagram of the 0p5x0p5 chip: bond-pad openings (layer 37/0) of the final GDS, named by
the pad instance of the final DEF they belong to, plus a pad table (doc/bonding_quarter.png/.csv).
The table also gives the net and the 70-pin mezzanine connector pin of the wafer.space run-2 chip-on-board
PCB (github.com/wafer-space/chip-on-board-wire-bonded-pcbs, run-2/0p5x0p5-cob/0p5x0p5-cob.kicad_pcb, pad ring
U102 and connector U101); its GND / VDD pads are fixed and must be the dvss / dvdd cells.
usage: python3 bond_diagram.py [chip_dir]   (default ../../chip)"""
import csv
import re
import sys
from pathlib import Path

import klayout.db as db
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle

CHIP = Path(sys.argv[1] if len(sys.argv) > 1 else Path(__file__).resolve().parents[2] / "chip")
DOC = Path(__file__).resolve().parents[2] / "doc"

SIG = {"clk_pad": "SCLK", "rst_n_pad": "RST_N",
       "inputs[0]": "SDI", "inputs[1]": "CS_N",
       "bidir[0]": "I_SIGN", "bidir[1]": "I_MAG", "bidir[2]": "Q_SIGN", "bidir[3]": "Q_MAG",
       "bidir[4]": "CLKOUT 16.368 MHz", "bidir[5]": "SDO (SPI readback)",
       "analog[0]": "REFIN (TCXO, AC coupled)", "analog[1]": "AFCOUT (TCXO pull)", "analog[2]": "VCTRL monitor",
       "dvdd_pads[0]": "DVDD", "dvdd_pads[1]": "DVDD", "dvdd_pads[2]": "DVDD",
       "dvss_pads[0]": "DVSS", "dvss_pads[1]": "DVSS", "dvss_pads[2]": "DVSS",
       "vdd_pads[0]": "DVDD (core VDD)", "vss_pads[0]": "DVSS (core VSS)"}
AFE = ["VDDV", "VSS", "VDDA", "VSS", "RFIN", "VSS"]       # afe_rf block, west to east
# run-2 0p5x0p5 COB: wire-bond pad 1..56 counter-clockwise from the south-west (S west->east, E south->north,
# N east->west, W north->south), same order as the table below
COB = (["clk", "rst_n", "GND", "VDD_IO_3"] + ["bidir_%d" % i for i in range(7)] +
       ["bidir_%d" % i for i in range(7, 15)] + ["GND", "VDD_IO_1"] + ["bidir_%d" % i for i in range(15, 22)] +
       ["bidir_%d" % i for i in range(22, 27)] + ["an_0", "an_1", "VDD_IO_2", "GND", "an_2", "an_3"] +
       ["in_0", "in_1", "VDD_CORE_1", "GND", "in_2", "in_3"] + ["bidir_%d" % i for i in range(27, 38)])
CONN = {"bidir_5": "1", "bidir_4": "2", "bidir_3": "3", "bidir_2": "4", "bidir_1": "5", "bidir_0": "6", "rst_n": "7", "clk": "8",
        "VDD_IO_3": "9/11", "bidir_37": "12", "bidir_36": "13", "bidir_35": "14", "bidir_34": "15", "bidir_33": "16",
        "bidir_32": "17", "bidir_31": "20", "bidir_30": "21", "bidir_29": "22", "bidir_28": "23", "VDD_CORE_1": "24",
        "bidir_27": "26", "in_3": "27", "in_2": "28", "in_1": "29", "in_0": "30", "an_3": "31", "an_2": "40", "an_1": "41",
        "an_0": "42", "bidir_26": "43", "VDD_IO_2": "44/46", "bidir_25": "47", "bidir_24": "48", "bidir_23": "49",
        "bidir_22": "50", "bidir_21": "51", "bidir_20": "52", "VDD_IO_1": "54", "bidir_19": "55", "bidir_18": "56",
        "bidir_17": "57", "bidir_16": "58", "bidir_15": "59", "bidir_14": "60", "bidir_13": "63", "bidir_12": "64",
        "bidir_11": "65", "bidir_10": "66", "bidir_9": "67", "bidir_8": "68", "bidir_7": "69", "bidir_6": "70",
        "GND": "10/18/25/45/53/61"}
ORIENT = {"N": db.Trans.R0, "S": db.Trans.R180, "W": db.Trans.R90, "E": db.Trans.R270,
          "FN": db.Trans.M90, "FS": db.Trans.M0, "FW": db.Trans.M45, "FE": db.Trans.M135}


def main():
    t = (CHIP / "final/def/chip_top.def").read_text()
    unit = int(re.search(r"UNITS DISTANCE MICRONS (\d+)", t).group(1))
    die = [int(v) / unit for v in re.search(r"DIEAREA \( (\d+) (\d+) \) \( (\d+) (\d+) \)", t).groups()]
    comp = t[t.index("COMPONENTS"):t.index("END COMPONENTS")]
    ly = db.Layout(); ly.read(str(CHIP / "final/gds/chip_top.gds"))
    lpad = ly.find_layer(37, 0)
    pads, macro = [], None
    for m in re.finditer(r"- (\S+) (\S+)\s*\+ (?:FIXED|PLACED) \( (-?\d+) (-?\d+) \) (\w+)", comp):
        inst, cell, x, y, o = m.groups()
        x, y = int(x) / unit, int(y) / unit
        if cell == "gnss_afe_analog":
            bb = ly.cell(cell).dbbox()
            macro = (x, y, bb.width(), bb.height())
            continue
        if not ("fd_io__" in cell or "gnss_io__" in cell) or ly.cell(cell) is None:
            continue
        c = ly.cell(cell)
        tr = db.DCplxTrans(db.DTrans(ORIENT[o], db.DVector()))
        bb = tr * c.dbbox()
        tr = db.DCplxTrans(db.DVector(x - bb.left, y - bb.bottom)) * tr
        r = db.Region(c.begin_shapes_rec(lpad)).merged()
        ops = sorted((tr * p.bbox().to_dtype(ly.dbu) for p in r.each()), key=lambda b: (b.left, b.bottom))
        if not ops:
            continue
        name = inst.replace("\\", "").replace(".pad", "")
        sigs = AFE if cell.endswith("afe_rf") else ["NC (unused pad)" if name.startswith("nc[") else SIG.get(name, name)]
        assert len(sigs) == len(ops), (inst, len(ops))
        for s, b in zip(sigs, ops):
            pads.append((s, name, cell, b))
    # check against the flattened chip: every opening is a real 37/0 shape of the top cell
    top = db.Region(ly.top_cell().begin_shapes_rec(lpad)).merged()
    top = db.Region([p for p in top.each() if p.bbox().width() * ly.dbu < 100])   # drop the seal ring
    for s, n, c, b in pads:
        assert not (top & db.Region(db.DBox(b.center(), b.center()).enlarged(1, 1).to_itype(ly.dbu))).is_empty(), n
    assert len(pads) == top.count(), (len(pads), top.count())

    W, H = die[2], die[3]

    def side(b):
        d = {"S": b.bottom, "N": H - b.top, "W": b.left, "E": W - b.right}
        return min(d, key=d.get)

    fig, ax = plt.subplots(figsize=(9, 11.5))
    ax.add_patch(Rectangle((0, 0), W, H, fill=False, lw=1.5))
    if macro:
        ax.add_patch(Rectangle(macro[:2], macro[2], macro[3], fc="#dfe8f5", ec="#4a6fa5"))
        ax.text(macro[0] + macro[2] / 2, macro[1] + macro[3] / 2, "gnss_afe_analog\n%.1f x %.1f um" % macro[2:],
                ha="center", va="center", fontsize=10)
    rows = []
    for s, n, c, b in pads:
        sd = side(b)
        col = "#c0392b" if s.startswith(("VDD", "VSS", "DVDD", "DVSS")) else ("#7f8c8d" if s.startswith("NC") else "#1f6f3f")
        ax.add_patch(Rectangle((b.left, b.bottom), b.width(), b.height(), fc=col, ec="k", lw=0.5))
        cx, cy = b.center().x, b.center().y
        lab = s.split(" (")[0]
        if sd == "S":
            ax.text(cx, b.top + 15, lab, rotation=90, ha="center", va="bottom", fontsize=7)
        elif sd == "N":
            ax.text(cx, b.bottom - 15, lab, rotation=90, ha="center", va="top", fontsize=7)
        elif sd == "W":
            ax.text(b.right + 15, cy, lab, ha="left", va="center", fontsize=7)
        else:
            ax.text(b.left - 15, cy, lab, ha="right", va="center", fontsize=7)
        rows.append((sd, round(cx, 1), round(cy, 1), s, n, c))
    ax.set_xlim(-60, W + 60); ax.set_ylim(-60, H + 60); ax.set_aspect("equal")
    ax.set_title("GNSS AFE 0p5x0p5 bonding diagram (die %.0f x %.0f um, %d bond pads)" % (W, H, len(pads)), fontsize=11)
    ax.set_xlabel("um"); ax.set_ylabel("um")
    fig.tight_layout(); fig.savefig(DOC / "bonding_quarter.png", dpi=130)
    order = {"S": 0, "E": 1, "N": 2, "W": 3}
    rows.sort(key=lambda r: (order[r[0]], r[1] if r[0] == "S" else (r[2] if r[0] == "E" else (-r[1] if r[0] == "N" else -r[2]))))
    with open(DOC / "bonding_quarter.csv", "w", newline="") as f:
        w = csv.writer(f); w.writerow(["no", "side", "x_um", "y_um", "signal", "instance", "cell", "cob_net", "cob_connector_pin"])
        assert len(rows) == len(COB)
        for i, (r, net) in enumerate(zip(rows, COB), 1):
            # the fixed supply pads of the board must be the template supply cells, and nothing else may be on them
            fixed = "dvss" if net == "GND" else ("dvdd" if net.startswith("VDD") else None)
            assert (r[5].endswith("__" + fixed) and r[3].startswith(fixed.upper())) if fixed else not r[3].startswith(("DVDD", "DVSS")), (i, r, net)
            w.writerow([i, *r, net, CONN[net]])
    # bond-pad pitch per side (openings are 60 um wide)
    for sd in "SENW":
        v = sorted(r[1] if sd in "SN" else r[2] for r in rows if r[0] == sd)
        print(sd, len(v), "min pitch %.1f um" % min(b - a for a, b in zip(v, v[1:])) if len(v) > 1 else "")
    for r, net in zip(rows, COB):
        print(*r[:4], net, CONN[net], sep="\t")


if __name__ == "__main__":
    main()
