"""Mixer schematic vs PEX: conversion gain / I-Q timing (tb_mixer transient)."""
import os, sys, re
from concurrent.futures import ThreadPoolExecutor
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
os.environ.setdefault("PDK", "gf180mcuD"); os.environ.setdefault("PDK_ROOT", os.path.expanduser("~/pdk"))
import pexsim, lvs
from pexsim import run
if "--nopex" not in sys.argv: lvs.pex("mixer_iq", pexsim.MAG)
t = open(run.netlist("tb_mixer")).read()
jobs = {"mix_sch": t, "mix_pex": pexsim.swap(t, "mixer_iq")}
jobs = {k: v.replace("wrdata tb_mixer_out vi vq", "wrdata %s_out vi vq vrf" % k) for k, v in jobs.items()}
with ThreadPoolExecutor(2) as ex:
    res = dict(zip(jobs, ex.map(lambda k: run.ngspice(jobs[k], k, timeout=20000), jobs)))
for k, out in res.items():
    print(k, " ".join(l for l in out.splitlines() if l.startswith("RES") or "rror" in l))

import numpy as np
def fit(t, y, f):
    A = np.column_stack([np.cos(2 * np.pi * f * t), np.sin(2 * np.pi * f * t), np.ones_like(t), t])
    c = np.linalg.lstsq(A, y, rcond=None)[0]
    return np.hypot(c[0], c[1]), np.degrees(np.arctan2(-c[1], c[0]))
for k in jobs:
    d = np.loadtxt(os.path.join(pexsim.PROJ, "sim", "%s_out" % k))
    t = d[:, 0]; m = t > 0.35e-6
    ai, pi_ = fit(t[m], d[m, 1], 4.092e6); aq, pq = fit(t[m], d[m, 3], 4.092e6)
    ar, _ = fit(t[m], d[m, 5], 1575.42e6)
    print("%s vrf=%.2fmV  I=%.2fmV Q=%.2fmV  CG_I=%.2fdB CG_Q=%.2fdB  dphi=%.1fdeg" % (
        k, ar * 1e3, ai * 1e3, aq * 1e3, 20 * np.log10(ai / ar), 20 * np.log10(aq / ar), (pi_ - pq + 180) % 360 - 180))
