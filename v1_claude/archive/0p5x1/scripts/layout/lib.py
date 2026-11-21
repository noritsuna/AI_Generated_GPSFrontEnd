"""Device-level helpers that turn schematic parameters into matched layout structures."""
from devices import mos_rows, res_array, mim_array, CAP_U
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


def cap(name, top, bot, W, L, m=1, aspect=1.0):
    """unit-cell MIM array; near-square (the last row may be partial)"""
    n = ncap(W, L, m)
    nx = max(1, int(round(math.sqrt(n * aspect))))
    # an exact factorisation if it stays within 1:2 of square, else a partial last row
    for d in range(nx, 0, -1):
        if n % d == 0:
            if n // d <= 2 * d:
                return mim_array(name, d, n // d, top, bot)
            break
    return mim_array(name, nx, None, top, bot, n=n)
