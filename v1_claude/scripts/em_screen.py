"""Electromigration screen from the schematic: DC (time-average) current of every MOS of the full
chip (tb_full, 0.25-0.5 us, TT), summed per net -> the DC current each net carries between its
devices (larger of the MOS currents entering and leaving the net; the resistors carry the rest).
Nets above the limit of one routing track are listed with the cell they belong to: a 0.3 um
track carries 0.63 mA and one via 0.58 mA at 85 C junction temperature (0.30 / 0.28 mA at 110 C,
GF180MCU DRM 14.2).  The geometry of such a net is then checked with layout/em_net.py.
usage: em_screen.py run | em_screen.py ana"""
import os, re, sys, json, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))
OUT = os.path.join(ROOT, "sim", "em")
SUPPLY = {"0", "vdd", "vddv"}


def parse():
    t = open(os.path.join(ROOT, "sim", "netlist", "tb_full.spice")).read()
    t = re.sub(r"\n\+", " ", t)
    sub, cur = {}, None
    for l in t.split("\n"):
        w = l.split()
        if not w:
            continue
        if w[0] == ".subckt":
            cur = sub[w[1]] = dict(ports=[x for x in w[2:] if "=" not in x], inst=[])
        elif w[0] == ".ends":
            cur = None
        elif cur is not None and w[0][0] in "Xx":
            a = [x for x in w[1:] if "=" not in x and not x.startswith("'") and not re.match(r"^[+*/(\d]", x) or x == "0"]
            # tokens up to the first parameter
            a = []
            for x in w[1:]:
                if "=" in x:
                    break
                a.append(x)
            cur["inst"].append((w[0], a[:-1], a[-1]))
    return t, sub


def flatten(sub, cell, path, nmap, out):
    for name, nets, kind in sub[cell]["inst"]:
        g = [nmap.get(n, n if n == "0" or n.lower() in ("vdd", "vss") and False else path + "." + n) if n not in nmap else nmap[n] for n in nets]
        g = [nmap[n] if n in nmap else ("0" if n == "0" else path + "." + n) for n in nets]
        p = path + "." + name.lower()
        if kind in sub:
            flatten(sub, kind, p, dict(zip(sub[kind]["ports"], g)), out)
        else:
            out.append((p, kind, g, cell, nets))


def devices():
    t, sub = parse()
    out = []
    top = dict(zip(sub["gnss_afe_top"]["ports"], "rfin refin sclk sdi csn isign imag qsign qmag clkout afcout vctrl vddv vdd 0".split()))
    flatten(sub, "gnss_afe_top", "xdut", top, out)
    return t, out


def run():
    os.makedirs(OUT, exist_ok=True)
    t, dev = devices()
    mos = [d for d in dev if "fet" in d[1]]
    ctl = [".control", "set num_threads=4"]
    for k in range(0, len(mos), 20):
        ctl.append("save " + " ".join("@m.%s.m0[id]" % d[0] for d in mos[k:k + 20]))
    ctl.append("tran 5p 0.5u 0.25u 5p uic")
    for k, d in enumerate(mos):
        ctl.append("meas tran i%d avg @m.%s.m0[id] from=0.25u to=0.5u" % (k, d[0]))
    ctl.append(".endc")
    t = re.sub(r"^\.control.*?^\.endc", lambda m: "\n".join(ctl), t, flags=re.M | re.S)
    t = re.sub(r"^VRNP sp sp0 .*$", "VRNP sp sp0 dc 0", t, flags=re.M)
    open(os.path.join(OUT, "screen.spice"), "w").write(t)
    json.dump([d[0] for d in mos], open(os.path.join(OUT, "screen_mos.json"), "w"))
    print(len(mos), "MOS; run: cd sim/em && ngspice -b screen.spice > screen.log 2>&1")


def ana():
    t, dev = devices()
    mos = [d for d in dev if "fet" in d[1]]
    val = {}
    for l in open(os.path.join(OUT, "screen.log")):
        m = re.match(r"^i(\d+)\s+=\s+(\S+)", l)
        if m:
            val[int(m.group(1))] = float(m.group(2))
    assert len(val) == len(mos), (len(val), len(mos))
    inn, outn, where = collections.Counter(), collections.Counter(), {}
    for k, (p, kind, g, cell, nets) in enumerate(mos):
        i = abs(val[k]) * 1e3
        d, s = g[0], g[2]
        a, b = (d, s) if kind.startswith("nfet") else (s, d)       # current flows a -> b through the device
        outn[a] += i; inn[b] += i
        for n, ln in ((d, nets[0]), (s, nets[2])):
            # the highest cell of the net: shortest path
            if n not in where or n.count(".") < where[n][0].count("."):
                where[n] = (n, cell, ln)
            if n.count(".") == p.count(".") - 1 and n.rsplit(".", 1)[0] == p.rsplit(".", 1)[0]:
                where[n] = (n, cell, ln)
    rows = []
    for n in set(inn) | set(outn):
        if n in SUPPLY:
            continue
        thr = max(inn[n], outn[n])
        if thr > 0.28:
            rows.append((thr, n, where[n][1], where[n][2], inn[n], outn[n]))
    rows.sort(reverse=True)
    print("net (flattened)                          cell / net             DC through the net [mA]   (MOS in / out)   tracks needed at 85 C / 110 C")
    for thr, n, cell, ln, a, b in rows:
        print("%-40s %-22s %7.2f   (%.2f / %.2f)   %d / %d" % (n, cell + "/" + ln, thr, a, b, -(-thr // 0.58), -(-thr // 0.28)))
    json.dump([dict(net=n, cell=c, local=ln, mA=round(thr, 3)) for thr, n, c, ln, a, b in rows], open(os.path.join(OUT, "screen.json"), "w"), indent=1)


if __name__ == "__main__":
    run() if sys.argv[1] == "run" else ana()
