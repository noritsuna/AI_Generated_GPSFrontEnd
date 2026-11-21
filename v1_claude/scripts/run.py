"""Netlist an xschem testbench and run ngspice (batch). Returns log text."""
import os, re, subprocess, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
XS = os.path.join(ROOT, "xschem")
NET = os.path.join(ROOT, "sim", "netlist")
SIM = os.path.join(ROOT, "sim")


def netlist(tb):
    os.makedirs(NET, exist_ok=True)
    subprocess.run(["xschem", "-n", "-s", "-q", "-x", "--rcfile", os.path.join(XS, "xschemrc"),
                    "-o", NET, os.path.join(XS, tb + ".sch")],
                   cwd=XS, check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    return os.path.join(NET, tb + ".spice")


def patch(path, subs):
    """Return a copy of the netlist with text substitutions (corner/temperature)."""
    txt = open(path).read()
    for a, b in subs:
        txt = txt.replace(a, b)
    return txt


def ngspice(path_or_text, tag=None, timeout=3000):
    if not path_or_text.endswith(".spice"):
        p = os.path.join(NET, "%s.spice" % tag)
        open(p, "w").write(path_or_text)
    else:
        p = path_or_text
    r = subprocess.run(["ngspice", "-b", p], cwd=SIM, capture_output=True, text=True, timeout=timeout)
    out = (r.stdout + r.stderr).replace("\r", "\n")
    return "\n".join(l for l in out.splitlines()
                     if "Reference value" not in l and "arning" not in l)


def meas(log, name):
    m = re.findall(r"^%s\s*=\s*([-+0-9.eE]+)" % re.escape(name), log, re.M)
    return [float(x) for x in m]


if __name__ == "__main__":
    print(ngspice(netlist(sys.argv[1])))
