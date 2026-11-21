"""Final check: mismatch Monte Carlo on the final schematics (sw_stat_mismatch=1, MOS only; seed 0 = nominal).
Uses the measurements of scripts/mc_mismatch.py, with one correction: a FET with m > 1 gets par = m, so that the
m parallel devices average their mismatch (the PDK model takes its area from W and par, not from m).
  adc    adc2b: SIGN / MAG thresholds from a slow differential ramp
  mixer  mixer_iq with an ideal 8-phase LO: IF I/Q gain / phase imbalance, DC offset
  cpdc   charge pump with both currents on (DC), bias_gen included: net output current at VCTRL 1.2 ... 2.2 V,
         ICP2 = 0 (a) and 1 (b); u, d = source and sink current alone (other instances, ICP2 = 0)
  pll    closed-loop PLL (tb_pll): lock voltage, static phase error, reference spurs of the LO
usage: final_mc.py adc|mixer|cpdc|pll [n=40] [jobs=2] [corner=tt] [first=0]   results: sim/mc/final_<kind>[_<corner>].txt"""
import os, re, sys
from concurrent.futures import ThreadPoolExecutor
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.dirname(HERE))
os.environ.setdefault("PDK", "gf180mcuD"); os.environ.setdefault("PDK_ROOT", os.path.expanduser("~/pdk"))
import run
import mc_mismatch as mc

_mm = mc.mm


def mm(text, seed):
    t, k = re.subn(r"\bm=(\d+) par=1\b", lambda m: "m=%s par=%s" % (m.group(1), m.group(1)), text)
    assert k > 0
    return _mm(t, seed)


mc.mm = mm
VO = (1.2, 1.5, 1.7, 1.9, 2.2)


def cpdc(seed, base, c):
    t, v = mc.corner(base, c)
    top = ("VDD vdd 0 %g\nVG g0 0 0\nXB nb pb vdd 0 bias_gen\nVO o 0 1.7\nVA oa o 0\nVB ob o 0\n"
           "XCPA g0 vdd g0 pb nb g0 oa vdd 0 cp\nXCPB g0 vdd g0 pb nb vdd ob vdd 0 cp\n"
           "VU ou o 0\nVD od o 0\nXCPU g0 g0 vdd pb nb g0 ou vdd 0 cp\nXCPD vdd vdd g0 pb nb g0 od vdd 0 cp\n" % v)
    t, k = re.subn(r"\A.*?^(\*\*\*\* begin user architecture code)", lambda m: "* cp dc\n" + top + m.group(1), t, flags=re.M | re.S)
    assert k == 1
    t = re.sub(r"^\.ic .*\n", "", t, flags=re.M)
    body = "".join("alter VO dc = %g\nop\nlet a = -i(VA)*1e6\nlet b = -i(VB)*1e6\nlet u = -i(VU)*1e6\nlet d = i(VD)*1e6\necho R%d $&a $&b $&u $&d\n" % (x, i) for i, x in enumerate(VO))
    out = mc.ng(mc.ctl(mm(t, seed), body), "cpdc_%s_%d" % (c, seed))
    r = {l.split()[0]: l.split()[1:] for l in out.splitlines() if re.match(r"R\d ", l)}
    assert len(r) == len(VO), out[-400:]
    return "seed=%d c=%s " % (seed, c) + " ".join("a%.1f=%.3f b%.1f=%.3f u%.1f=%.3f d%.1f=%.3f" % sum(((x, float(q)) for q in r["R%d" % i]), ())
                                                 for i, x in enumerate(VO))


def main():
    kind = sys.argv[1]
    a = dict(x.split("=", 1) for x in sys.argv[2:])
    n = int(a.get("n", 40)); jobs = int(a.get("jobs", 2)); c = a.get("corner", "tt")
    os.makedirs(mc.OUT, exist_ok=True)
    seeds = range(int(a.get("first", 0)), n + 1)
    if kind == "adc":
        base = open(run.netlist("tb_adc")).read(); f = lambda s: mc.adc(s, base); res = "final_adc.txt"
    elif kind == "mixer":
        base = open(run.netlist("tb_mixer")).read(); f = lambda s: mc.mixer(s, base); res = "final_mixer.txt"
    elif kind == "cpdc":
        base = open(run.netlist("tb_pll")).read(); f = lambda s: cpdc(s, base, c); res = "final_cpdc_%s.txt" % c
    else:
        base = open(run.netlist("tb_pll")).read(); f = lambda s: mc.pll(s, base, c); res = "final_pll_%s.txt" % c

    def safe(s):
        try:
            return f(s)
        except Exception as e:
            return "seed=%d FAILED %r" % (s, e)
    with ThreadPoolExecutor(jobs) as ex, open(os.path.join(mc.OUT, res), "a") as fo:
        for line in ex.map(safe, seeds):
            print(line, flush=True); fo.write(line + "\n"); fo.flush()


if __name__ == "__main__":
    main()
