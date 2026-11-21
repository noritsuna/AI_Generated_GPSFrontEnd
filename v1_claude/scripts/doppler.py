"""Doppler / Doppler-rate envelope for a GNSS receiver on an orbital launcher.

Trajectory: simplified Falcon 9 / H3 class ascent to a 200 km LEO
(burn-out ~ 7.8 km/s inertial at ~T+540 s) followed by coast in orbit.
Constellations: GPS (Walker 24/6/55deg, a=26560 km), Galileo (24/3/56deg,
a=29600 km), GLONASS (24/3/64.8deg, a=25510 km).
The receiver antenna is assumed hemispherical about the local zenith
(launcher pitches over, so +-10 deg below horizon is also counted).
"""
import json
import os
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

C = 299792458.0
MU = 3.986004418e14
RE = 6378137.0
WE = 7.2921151467e-5
OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "doc")

F_L1 = 1575.42e6
F_GLO = lambda k: 1602e6 + k * 0.5625e6


def walker(n_planes, per_plane, inc_deg, a, phase=1):
    sats = []
    for p in range(n_planes):
        raan = 2 * np.pi * p / n_planes
        for s in range(per_plane):
            u0 = 2 * np.pi * s / per_plane + 2 * np.pi * phase * p / (n_planes * per_plane)
            sats.append((raan, u0))
    inc = np.radians(inc_deg)
    n = np.sqrt(MU / a ** 3)

    def pos_vel(t):
        P, V = [], []
        for raan, u0 in sats:
            u = u0 + n * t
            r_orb = a * np.array([np.cos(u), np.sin(u), 0.0])
            v_orb = a * n * np.array([-np.sin(u), np.cos(u), 0.0])
            Ri = np.array([[1, 0, 0], [0, np.cos(inc), -np.sin(inc)], [0, np.sin(inc), np.cos(inc)]])
            Rr = np.array([[np.cos(raan), -np.sin(raan), 0], [np.sin(raan), np.cos(raan), 0], [0, 0, 1]])
            R = Rr @ Ri
            P.append(R @ r_orb)
            V.append(R @ v_orb)
        return np.array(P), np.array(V)
    return pos_vel


def rocket(t, lat0=np.radians(28.5), az=np.radians(90.0)):
    """Inertial position/velocity of launcher (ECI, t=0 at launch)."""
    t_bo, v_bo, h_orb = 540.0, 7790.0, 200e3
    # pad velocity from Earth rotation
    v_pad = WE * RE * np.cos(lat0)
    if t < t_bo:
        s = t / t_bo
        v_h = v_pad + (v_bo - v_pad) * s ** 2.2  # horizontal (along track) speed
        h = h_orb * (1 - (1 - s) ** 2.0)          # altitude
        v_v = h_orb * 2.0 * (1 - s) / t_bo        # vertical speed
    else:
        v_h, h, v_v = v_bo, h_orb, 0.0
    # integrate downrange angle numerically
    ts = np.linspace(0, t, 400)
    vh = [v_pad + (v_bo - v_pad) * min(x / t_bo, 1) ** 2.2 for x in ts]
    hh = [h_orb * (1 - (1 - min(x / t_bo, 1)) ** 2) for x in ts]
    theta = np.trapezoid(np.array(vh) / (RE + np.array(hh)), ts) if t > 0 else 0.0
    # great circle from launch site heading east-ish
    r0 = np.array([np.cos(lat0), 0.0, np.sin(lat0)])
    east = np.array([0.0, 1.0, 0.0])
    north = np.array([-np.sin(lat0), 0.0, np.cos(lat0)])
    d = np.sin(az) * east + np.cos(az) * north
    up = np.cos(theta) * r0 + np.sin(theta) * d
    fwd = -np.sin(theta) * r0 + np.cos(theta) * d
    r = (RE + h) * up
    v = v_h * fwd + v_v * up
    return r, v, up


def run():
    cons = {
        "GPS L1": (walker(6, 4, 55.0, 26560e3), lambda i: F_L1),
        "Galileo E1": (walker(3, 8, 56.0, 29600e3), lambda i: F_L1),
        "GLONASS L1": (walker(3, 8, 64.8, 25510e3), lambda i: F_GLO([-7, 6, 0, 1, -1, 2, -2, 3, -3, 4, -4, 5, -5, 6, -7, 0, 1, -1, 2, -2, 3, -3, 4, -4][i])),
    }
    tt = np.arange(0, 1500, 1.0)
    res = {}
    plt.figure(figsize=(9, 6))
    for k, (name, (pv, fk)) in enumerate(cons.items()):
        dop = np.full((len(tt), 24), np.nan)
        for it, t in enumerate(tt):
            r, v, up = rocket(t)
            P, V = pv(t)
            for i in range(len(P)):
                los = P[i] - r
                rng = np.linalg.norm(los)
                u = los / rng
                if np.dot(u, up) < -np.sin(np.radians(10)):
                    continue
                rr = np.dot(V[i] - v, u)
                dop[it, i] = -rr / C * fk(i)
        rate = np.gradient(dop, tt, axis=0)
        res[name] = dict(max_dop_hz=float(np.nanmax(np.abs(dop))),
                         max_rate_hz_s=float(np.nanmax(np.abs(rate))))
        plt.subplot(3, 1, k + 1)
        plt.plot(tt, dop / 1e3, lw=0.7)
        plt.ylabel("%s\nDoppler [kHz]" % name, fontsize=8)
        plt.grid(alpha=0.3)
    plt.xlabel("time from lift-off [s]  (MECO/SECO ~540 s, then LEO coast)")
    plt.tight_layout()
    plt.savefig(os.path.join(OUT, "doppler_profile.png"), dpi=110)
    # static receiver reference and TCXO error budget
    res["TCXO +-2.5ppm at L1 [Hz]"] = 2.5e-6 * F_L1
    res["g-sensitivity 1ppb/g x 10 g [Hz]"] = 1e-9 * 10 * F_L1
    json.dump(res, open(os.path.join(OUT, "doppler_summary.json"), "w"), indent=1)
    print(json.dumps(res, indent=1))


if __name__ == "__main__":
    run()
