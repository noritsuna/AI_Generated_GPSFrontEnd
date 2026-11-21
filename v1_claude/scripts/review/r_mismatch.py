"""Review A-7: resistor mismatch (the PDK has no resistor mismatch model -> Pelgrom estimate,
sigma(dR/R) = AR / sqrt(W L), AR assumed 2 % um (typical poly; 1 % and 4 % shown as a range)).
  - AFC DAC: systematic INL / DNL from ngspice (tb_afc, includes the resistor end effects and the
    driver Ron) + Monte Carlo on the R-2R ladder
  - ADC threshold ladder: spread of the +-0.15 V thresholds"""
import os, sys, re
import numpy as np
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))
os.environ.setdefault("PDK", "gf180mcuD"); os.environ.setdefault("PDK_ROOT", os.path.expanduser("~/pdk"))
import run


def lin(v):
    c = np.arange(len(v)); lsb = (v[-1] - v[0]) / (len(v) - 1)
    inl = (v - (v[0] + c * lsb)) / lsb; dnl = np.diff(v) / lsb - 1
    return lsb, inl, dnl


def dac_sim():
    out = run.ngspice(open(run.netlist("tb_afc")).read(), "rev_afc", timeout=3000)
    v = np.array([float(l.split()[2]) for l in out.splitlines() if l.startswith("DAC ")])
    assert len(v) == 256
    lsb, inl, dnl = lin(v)
    print("AFC DAC nominal (ngspice, 100 kohm load): %.4f..%.4f V, LSB %.2f mV, INL %+.2f/%+.2f LSB, DNL %+.2f/%+.2f LSB (worst at code %d)" % (
        v[0], v[-1], lsb * 1e3, inl.min(), inl.max(), dnl.min(), dnl.max(), int(np.argmax(abs(dnl))) + 1))
    return v


def dac_mc(ar, n=2000, rload=100e3, seed=1):
    """R-2R: RT (2R) n0-gnd, R2_i (2R) driver i -> node i, R1_i (R) node i -> node i+1; out = node 7."""
    rng = np.random.default_rng(seed)
    R = 10e3; s1 = ar / np.sqrt(10.0); s2 = ar / np.sqrt(20.0)
    codes = np.arange(256); bits = ((codes[:, None] >> np.arange(8)) & 1).astype(float)
    dn, il, mono = [], [], 0
    for _ in range(n):
        rt = 2 * R * (1 + s2 * rng.standard_normal()); r2 = 2 * R * (1 + s2 * rng.standard_normal(8)); r1 = R * (1 + s1 * rng.standard_normal(7))
        G = np.zeros((8, 8)); B = np.zeros((8, 8))
        G[0, 0] += 1 / rt; G[7, 7] += 1 / rload
        for i in range(8):
            G[i, i] += 1 / r2[i]; B[i, i] = 1 / r2[i]
        for i in range(7):
            G[i, i] += 1 / r1[i]; G[i + 1, i + 1] += 1 / r1[i]; G[i, i + 1] -= 1 / r1[i]; G[i + 1, i] -= 1 / r1[i]
        v = (np.linalg.solve(G, B) @ bits.T)[7]
        lsb, inl, dnl = lin(v)
        dn.append(dnl); il.append(abs(inl).max()); mono += dnl.min() > -1
    dn = np.array(dn)
    print("  AR %.0f %% um (sigma R 1x10u %.2f %%, 2R 1x20u %.2f %%): DNL at 127->128 sigma %.2f LSB, worst |DNL| median %.2f / 99 %% %.2f LSB, "
          "|INL| median %.2f / 99 %% %.2f LSB, monotonic %.1f %%" % (ar * 100, s1 * 100, s2 * 100, dn[:, 127].std(), np.median(abs(dn).max(1)),
          np.percentile(abs(dn).max(1), 99), np.median(il), np.percentile(il, 99), 100 * mono / n))


def adc_ladder(ar, n=20000, seed=2):
    rng = np.random.default_rng(seed)
    L = np.array([40.1, 1.4, 1.4, 22.3]); W = 10.0
    r = L * (1 + ar / np.sqrt(W * L) * rng.standard_normal((n, 4)))
    tot = r.sum(1); thp = (r[:, 1:].sum(1)) / tot; thm = r[:, 2:].sum(1) / tot; thn = r[:, 3] / tot
    d1 = (thp - thm) * 3.3; d2 = (thm - thn) * 3.3
    print("  AR %.0f %% um: threshold step %.1f mV, sigma %.2f mV (%.2f %%), +/- asymmetry sigma %.2f mV, VCM sigma %.2f mV" % (
        ar * 100, d1.mean() * 1e3, d1.std() * 1e3, 100 * d1.std() / d1.mean(), (d1 - d2).std() * 1e3, thm.std() * 3.3e3))


if __name__ == "__main__":
    dac_sim()
    print("AFC DAC Monte Carlo (ladder resistors only, ideal drivers):")
    for ar in (0.01, 0.02, 0.04):
        dac_mc(ar)
    print("ADC threshold ladder (RL1 / RL2 = 10u x 1.4u):")
    for ar in (0.01, 0.02, 0.04):
        adc_ladder(ar)
