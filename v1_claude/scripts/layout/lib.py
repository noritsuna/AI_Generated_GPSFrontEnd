"""Device-level helpers that turn schematic parameters into matched layout structures."""
import os
from devices import mos_rows, res_array, mim_array, mim_plates, CAP_U, MIM_PLATE_UM2
import math

UM = 1000


def nm(v):
    """'40u' / 2e-6 / 2.0 (um) -> nm int"""
    if isinstance(v, str):
        v = v.strip()
        if v.endswith("u"):
            return int(round(float(v[:-1]) * UM))
        return int(round(float(v) * 1e9))
    if v < 1e-3:
        return int(round(v * 1e9))
    return int(round(v * UM))


def _alt(s, d, n):
    """strip list s d s d ... for n fingers"""
    return [s if k % 2 == 0 else d for k in range(n + 1)]


def mos(name, typ, L, W, nf, m, d, g, s, bulk, rows=None, max_row=32):
    """Single device: nf*m fingers of W/nf, source on the outer strips."""
    F = nf * m
    Wf = nm(W) // nf
    if rows is None:
        rows = 1 if F <= max_row else 2 * ((F + 2 * max_row - 1) // (2 * max_row))
    per = [F // rows + (1 if r < F % rows else 0) for r in range(rows)]
    R = [dict(strips=_alt(s, d, f), gates=[g] * f, top=g) for f in per if f]
    return mos_rows(name, typ, nm(L), Wf, R, bulk)


def cc_seq(nA, nB):
    """Common-centroid A/B sequence of drain strips (each strip = 2 fingers): mirrored
    positions (i, n-1-i) are given to A and B alternately from the outside in
    (A B A B ... B A B A); odd left-overs go to the middle."""
    n = nA + nB
    seq = [None] * n
    a, b = nA, nB
    turn = "A"
    i, j = 0, n - 1
    while i < j:
        if (turn == "A" and a >= 2) or (b < 2 and a >= 2):
            seq[i] = seq[j] = "A"; a -= 2; turn = "B"
        elif b >= 2:
            seq[i] = seq[j] = "B"; b -= 2; turn = "A"
        else:
            break
        i += 1; j -= 1
    rest = ["A"] * a + ["B"] * b
    for k in range(n):
        if seq[k] is None:
            seq[k] = rest.pop(0)
    return seq


def cc_pair(name, typ, L, Wf, FA, FB, s, dA, dB, g, bulk, rows=1):
    """Two devices with common source and gate (current mirror / tail pair), common
    centroid: drain strips ordered A B B A ... ; with 2 rows the second row is the
    complement (B A A B) -> 2-D common centroid."""
    assert FA % (2 * rows) == 0 and FB % (2 * rows) == 0, (name, FA, FB)
    R = []
    for r in range(rows):
        seq = cc_seq(FA // 2 // rows, FB // 2 // rows)
        if r % 2:
            seq = ["B" if q == "A" else "A" for q in seq]
        strips = [s]
        for q in seq:
            strips += [dA if q == "A" else dB, s]
        R.append(dict(strips=strips, gates=[g] * (len(strips) - 1), top=g))
    return mos_rows(name, typ, nm(L), nm(Wf), R, bulk)


def cc_multi(name, typ, L, Wf, devs, s, g, bulk, rows=1):
    """N devices with common source and gate (multi-output mirror).
    devs: list of (drain_net, fingers).  Drain strips are interleaved symmetrically."""
    R = []
    for r in range(rows):
        units = []
        for dn, F in devs:
            assert F % (2 * rows) == 0, (name, dn, F)
            units += [dn] * (F // 2 // rows)
        # symmetric interleave: round-robin on half, mirrored
        half = []
        cnt = {dn: F // 2 // rows for dn, F in devs}
        tot = sum(cnt.values())
        tgt = {dn: cnt[dn] / 2.0 for dn in cnt}
        got = {dn: 0 for dn in cnt}
        for k in range(tot // 2):
            cand = [d_ for d_ in cnt if 2 * (got[d_] + 1) <= cnt[d_]]
            if not cand:
                break
            dn = max(cand, key=lambda d_: (tgt[d_] - got[d_]))
            half.append(dn); got[dn] += 1
        rest = []
        for dn in cnt:
            rest += [dn] * (cnt[dn] - 2 * got[dn])
        seq = half + rest + half[::-1]
        assert all(seq.count(dn) == cnt[dn] for dn in cnt), (name, seq)
        if r % 2:
            seq = seq[::-1]
        strips = [s]
        for dn in seq:
            strips += [dn, s]
        R.append(dict(strips=strips, gates=[g] * (len(strips) - 1), top=g))
    return mos_rows(name, typ, nm(L), nm(Wf), R, bulk)


def cross_quad(name, typ, L, Wf, F, A, B, bulk):
    """Differential pair with separate sources: A=(s,d,g), B=(s,d,g); each device is split
    into two islands of F/2 fingers placed A B / B A (2-D common centroid)."""
    h = F // 2
    def isl(dv, side):
        sN, dN, gN = dv
        d = dict(strips=_alt(sN, dN, h), gates=[gN] * h)
        d[side] = gN
        return d
    R = [[isl(A, "top"), isl(B, "bot")], [isl(B, "bot"), isl(A, "top")]]
    return mos_rows(name, typ, nm(L), nm(Wf), R, bulk)


def seg(Lnm, lmax=10 * UM):
    """number of equal segments for a resistor body length"""
    return max(1, int(math.ceil(Lnm / float(lmax) - 1e-9)))


def rchain(a, b, L, lmax=10 * UM, slots=None):
    Ln = nm(L)
    n = seg(Ln, lmax)
    return dict(a=a, b=b, n=n, L=Ln // n // 5 * 5 if Ln % n == 0 else int(round(Ln / n / 5.0)) * 5, slots=slots)


def interleave(chains):
    """Assign interdigitated slots to chains with equal segment count (ABAB...)."""
    n = chains[0]["n"]
    k = len(chains)
    for ci, ch in enumerate(chains):
        assert ch["n"] == n
        ch["slots"] = [q * k + ci for q in range(n)]
    return chains


def ncap(W, L, m=1):
    """number of 5x5 um units for a W x L (x m) MIM cap"""
    a = nm(W) * nm(L) * m
    return max(1, int(round(a / float(CAP_U * CAP_U))))


# quarter-slot shrink: solid MIM plates instead of 5x5 um units, only where the value or the
# matching does not matter (bypass / decoupling) or is kept by an area factor.  Signal-path,
# filter and matched caps (SK LPF, mixer LO coupling / IF load, LNA coupling, VGA coupling,
# small timing caps) stay unit arrays.  MIM_MERGE=0: unit arrays everywhere.
MIM_MERGE = os.environ.get("MIM_MERGE", "1") == "1"
PLATES_PER_DEV = 3
# cell -> {instance: plate-area factor}; the units add ~9.5 % perimeter capacitance (5x5 um,
# 0.2383 fF/um) that a solid plate does not: 1.09 keeps the extracted value of the unit array
MERGE = {"loop_filter": {"C1": 1.09, "C2": 1.09},
         # filter / coupling / load caps (proposal 1): same extracted value as the unit arrays
         "sk_lpf1": dict({"C1P": 1.09, "C1N": 1.09}, **{"C2" + s: 1.09 for s in ("P", "N", "WP", "WN", "NP", "NN")}),
         "sk_lpf2": dict({"C1P": 1.09, "C1N": 1.09}, **{"C2" + s: 1.09 for s in ("P", "N", "WP", "WN", "NP", "NN")}),
         "mixer_iq": {"CL1I": 1.09, "CL2I": 1.09, "CL1Q": 1.09, "CL2Q": 1.09,
                      "CBRF": 1.0, "CLOU": 1.0, "CLOL": 1.0},     # + bias decoupling
         "bias_gen": {"CNB": 1.0, "CPB": 1.0},
         "bias_if": {"CC": 1.0, "CNB": 1.0, "CPB": 1.0},
         "adc2b": {"CT1": 1.0, "CT2": 1.0, "CT3": 1.0},          # threshold ladder decoupling
         "vco_ring4": {"CVR": 1.0},                               # VR decoupling
         "lna_nc": {"CB1": 1.0, "CB2": 1.0},                      # bias bypass
         "vga": {"CCM": 1.0, "CC1": 1.09, "CC2": 1.09},           # vcm decoupling, AC coupling
         "vga_fix": {"CCM": 1.0, "CC1": 1.09, "CC2": 1.09},
         "cp": {"CVD": 1.0}}                                      # buffer node decoupling


def merge_factor(cell, inst):
    """Plate-area factor if the cap ``inst`` (without the X) of ``cell`` is merged, else None."""
    if not MIM_MERGE:
        return None
    return MERGE.get(cell, {}).get(inst)


def plates(W, L, m=1, f=1.0):
    """Solid-plate split of a W x L (x m) MIM cap (area x f): (k, pw, ph) in nm, k plates of
    pw x ph.  One plate (the schematic W x L when it is a single, not too elongated cap and
    f = 1) up to MIM_PLATE_UM2, else k equal squares."""
    w, l = nm(W), nm(L)
    a = w * l * m * f / 1e6                              # um^2
    if m == 1 and f == 1.0 and a <= MIM_PLATE_UM2 and max(w, l) <= 2 * min(w, l):
        return 1, (w // 10) * 10, (l // 10) * 10
    k = max(1, int(math.ceil(a / MIM_PLATE_UM2)))
    s = int(math.sqrt(a / k) * 100) * 10                 # nm, 10 nm grid
    return k, s, s


def cap_parts(name, top, bot, W, L, m=1, f=1.0):
    """Merged-plate MIM cap as one or more devices (<= PLATES_PER_DEV plates in a row each)."""
    k, pw, ph = plates(W, L, m, f)
    if k <= PLATES_PER_DEV:
        return [mim_plates(name, k, pw, ph, top, bot)]
    nd = -(-k // PLATES_PER_DEV)
    sizes = [k // nd + (1 if i < k % nd else 0) for i in range(nd)]
    return [mim_plates("%s_%d" % (name, i), q, pw, ph, top, bot) for i, q in enumerate(sizes)]


def cap(name, top, bot, W, L, m=1, aspect=1.0, merge=None):
    """unit-cell MIM array; near-square (the last row may be partial).
    merge = plate-area factor (from merge_factor): solid plate(s) instead"""
    if merge is not None and plates(W, L, m, merge)[0] <= PLATES_PER_DEV:
        return cap_parts(name, top, bot, W, L, m, merge)[0]
    n = ncap(W, L, m)
    nx = max(1, int(round(math.sqrt(n * aspect))))
    # an exact factorisation if it stays within 1:2 of square, else a partial last row
    for d in range(nx, 0, -1):
        if n % d == 0:
            if n // d <= 2 * d:
                return mim_array(name, d, n // d, top, bot)
            break
    return mim_array(name, nx, None, top, bot, n=n)
