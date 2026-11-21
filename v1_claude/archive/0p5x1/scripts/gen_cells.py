"""Generate all GNSS AFE xschem cells (GF180MCU, 3.3 V devices).

Run:  python3 scripts/gen_cells.py
"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from xsch import Sch

P = dict(VDD="VDD", VSS="VSS")
SUP = [("VDD", "inout"), ("VSS", "inout")]
KICK_W = "8u"  # VCO cell start-up kick NMOS (ON -> VSS)

# ---------------------------------------------------------------- digital
def inv(name="inv_lo", wn="2u", wp="4u", nfn=1, nfp=1, vdd="VDD"):
    """Static inverter (supply pin named VDD so it can be tied to VR)."""
    s = Sch(name, [("A", "in"), ("Y", "out")] + SUP, title="%s: CMOS inverter" % name)
    s.nmos("MN", "Y", "A", "VSS", W=wn, nf=nfn)
    s.pmos("MP", "Y", "A", "VDD", W=wp, nf=nfp)
    s.save(); s.save_sym()


def nand2(name="nand2", wn="2u", wp="2u"):
    s = Sch(name, [("A", "in"), ("B", "in"), ("Y", "out")] + SUP, title="NAND2")
    s.nmos("MN1", "Y", "A", "n1", W=wn)
    s.nmos("MN2", "n1", "B", "VSS", W=wn)
    s.pmos("MP1", "Y", "A", "VDD", W=wp)
    s.pmos("MP2", "Y", "B", "VDD", W=wp)
    s.save(); s.save_sym()


def nor2(name="nor2", wn="1u", wp="4u"):
    s = Sch(name, [("A", "in"), ("B", "in"), ("Y", "out")] + SUP, title="NOR2")
    s.nmos("MN1", "Y", "A", "VSS", W=wn)
    s.nmos("MN2", "Y", "B", "VSS", W=wn)
    s.pmos("MP1", "n1", "A", "VDD", W=wp)
    s.pmos("MP2", "Y", "B", "n1", W=wp)
    s.save(); s.save_sym()


def tspc_dff(name="tspc_dff", w=1.0):
    """True single-phase-clock positive-edge DFF (Yuan-Svensson 9T) + output
    inverter -> Q (non-inverted) and QB."""
    W = lambda x: "%gu" % (x * w)
    s = Sch(name, [("D", "in"), ("CK", "in"), ("Q", "out"), ("QB", "out")] + SUP,
            title="TSPC positive-edge DFF (9T) for 1.6 GHz prescaler")
    s.newrow("stage 1 (p-latch)")
    s.pmos("MP1", "a1", "D", "VDD", W=W(2))
    s.pmos("MP2", "x", "CK", "a1", W=W(2))
    s.nmos("MN1", "x", "D", "VSS", W=W(1))
    s.newrow("stage 2 (precharge)")
    s.pmos("MP3", "y", "CK", "VDD", W=W(2))
    s.nmos("MN2", "y", "x", "b2", W=W(1.5))
    s.nmos("MN3", "b2", "CK", "VSS", W=W(1.5))
    s.newrow("stage 3 (evaluate)")
    s.pmos("MP4", "QB", "y", "VDD", W=W(3))
    s.nmos("MN4", "QB", "CK", "c3", W=W(1.5))
    s.nmos("MN5", "c3", "y", "VSS", W=W(1.5))
    s.newrow("output inverter")
    s.pmos("MP5", "Q", "QB", "VDD", W=W(2))
    s.nmos("MN6", "Q", "QB", "VSS", W=W(1))
    s.save(); s.save_sym()


# ---------------------------------------------------------------- VCO
LOPH = ("L1P", "L1N", "L2P", "L2N", "L3P", "L3N", "L4P", "L4N")
VCO_LR = "0.28u"  # ring device L (0.35u: SS PEX tops out below 1.5 GHz LO with the strong latch)


def vco_core():
    """The 4 ring stages in one cell (devices of vco_cell/vco_cellk inlined) so the layout
    can put all NMOS in one row and all PMOS in one row: the ring nodes stay short."""
    st = [("1", "p4", "n4", "p1", "n1", "kh"), ("2", "p1", "n1", "p2", "n2", "kl"),
          ("3", "p2", "n2", "p3", "n3", None), ("4", "p3", "n3", "n4", "p4", None)]
    pins = [(n, "out") for n in LOPH] + [("CK", "out")] + [("ckd" + n, "out") for n in ("n1", "p2", "n2", "p3", "n3", "p4", "n4")] + \
           [("kh", "in"), ("kl", "in"), ("VR", "inout"), ("VSS", "inout")]
    s = Sch("vco_core", pins, cols=4, dx=300,
            title="VCO ring core: 4 delay cells (inverter pair + latch) + tap buffers + phase drivers")
    for k, ip, inn, op, on, fk in st:
        s.newrow("stage %s" % k)
        s.nmos("MNa" + k, on, ip, "VSS", W="16u", nf=4, L=VCO_LR)
        s.nmos("MNb" + k, op, inn, "VSS", W="16u", nf=4, L=VCO_LR)
        s.pmos("MPa" + k, on, ip, "VR", b="VR", W="24u", nf=8, L=VCO_LR)
        s.pmos("MPb" + k, op, inn, "VR", b="VR", W="24u", nf=8, L=VCO_LR)
        # cross-coupled latch: ~3/8 of the main inverter; weaker (1/8 at L=0.35u, 1/4 at L=0.28u)
        # the ring can lock into a mode with p/n not in antiphase when started from the DC
        # operating point (seen in TT/SS, B=0, VCTRL >= 2 V)
        s.nmos("MNc" + k, on, op, "VSS", W="6u", nf=2, L=VCO_LR)
        s.nmos("MNd" + k, op, on, "VSS", W="6u", nf=2, L=VCO_LR)
        s.pmos("MPc" + k, on, op, "VR", b="VR", W="12u", nf=4, L=VCO_LR)
        s.pmos("MPd" + k, op, on, "VR", b="VR", W="12u", nf=4, L=VCO_LR)
    # first tap buffer of every ring node inside the core (the ring nodes never leave it):
    # a<n> = !n, same size as inv_lo1
    # + the phase driver (L<k><P|N> = ring node <k><p|n>) right next to it: identical short tap
    # nets for all 8 phases (each mixer commutation is timed by one tap -> driver path)
    s.newrow("tap buffers + phase drivers")
    for n in ("p1", "n1", "p2", "n2", "p3", "n3", "p4", "n4"):
        L = "L" + n[1] + n[0].upper()
        s.nmos("MBN" + n, "a" + n, n, "VSS", W="2u")
        s.pmos("MBP" + n, "a" + n, n, "VR", b="VR", W="4u")
        s.nmos("MDN" + n, L, "a" + n, "VSS", W="12u", nf=4)
        s.pmos("MDP" + n, L, "a" + n, "VR", b="VR", W="24u", nf=8)
        # divider clock: a small inverter on L1P drives the long wire to the PLL divider; the same
        # inverter on the other seven phases keeps the 8 phase loads identical
        ck = "CK" if n == "p1" else "ckd" + n
        s.nmos("MCN" + n, ck, L, "VSS", W="2u")
        s.pmos("MCP" + n, ck, L, "VR", b="VR", W="4u")
    # kick devices last: listed between stages they would pair up with the main inverters
    s.newrow("start-up kick (stages 1/2) + balancing dummies")
    # every stage carries the same kick-sized drain load: each mixer commutation is timed by a
    # single stage, so unequal stage delays would show up directly as I/Q error
    for k, ip, inn, op, on, fk in st:
        s.nmos("MK" + k, on, fk or "VSS", "VSS", W="16u", nf=4, L=VCO_LR)
        s.nmos("MKD" + k, op, "VSS", "VSS", W="16u", nf=4, L=VCO_LR)
    s.save(); s.save_sym()


def vco_ring4():
    """Current-controlled 4-stage differential ring with 8 output phases.
    VCTRL -> NMOS V/I (source degenerated) -> PMOS mirror -> VR (ring supply).
    B0/B1 add binary-weighted coarse current (band select, active high)."""
    s = Sch("vco_ring4", [("VCTRL", "in"), ("B0", "in"), ("B1", "in"), ("NB", "in")] + [(n, "out") for n in LOPH] +
            [("CK", "out"), ("VR", "out")] + SUP, cols=6,
            title="VCO: 4-stage ring at fLO/2 = 785.664 MHz, 8 phases (45 deg) for the sub-harmonic mixer")
    s.newrow("V/I converter + PMOS mirror (ring is supplied by current)")
    s.nmos("MVI", "ng", "VCTRL", "ns", W="20u", nf=4, L="0.5u")
    s.rpoly("RDEG", "ns", "VSS", W="2u", L="4u")
    # supply pushing: L = 0.56u mirror (was 0.28u) and the minimum current from NB instead of a
    # 2.5 kohm VDD -> VR resistor: 184 / 243 -> ~45 / 40 MHz/V (TT / FF, tb_vco)
    s.pmos("MPD", "ng", "ng", "VDD", W="80u", L="0.56u", nf=16)
    s.pmos("MPO", "VR", "ng", "VDD", W="80u", L="0.56u", nf=16, m=16)
    s.nmos("MMIN", "ng", "NB", "VSS", W="12u", L="2u", nf=2)
    s.newrow("coarse band: 1x and 2x extra mirror branches")
    s.sub("inv_dig", "XB0", dict(A="B0", Y="b0n", **P))
    s.sub("inv_dig", "XB1", dict(A="B1", Y="b1n", **P))
    # mirror units 16 (base) + 12 (B0) + 24 (B1): bands 16/28/40/52, B=3 reaches 1.57 GHz in SS PEX
    s.pmos("MPB0", "nb0", "ng", "VDD", W="80u", L="0.56u", nf=16, m=12)
    s.pmos("MSB0", "VR", "b0n", "nb0", W="40u", nf=8, m=12)
    s.pmos("MPB1", "nb1", "ng", "VDD", W="80u", L="0.56u", nf=16, m=24)
    s.pmos("MSB1", "VR", "b1n", "nb1", W="40u", nf=8, m=24)
    s.cmim("CVR", "VR", "VSS", W="30e-6", L="30e-6")
    s.newrow("ring: 4 stages, wrap-around inversion")
    # the core drives the 8 phases (VR domain) to the sub-harmonic mixer, which makes the 1571 MHz
    # I/Q LO with stacked switches: no logic runs at 1.57 GHz
    ckd = {"ckd" + n: "ckd" + n for n in ("n1", "p2", "n2", "p3", "n3", "p4", "n4")}
    s.sub("vco_core", "XCORE", dict(kh="kh", kl="kl", CK="CK", VR="VR", VSS="VSS", **ckd, **{n: n for n in LOPH}))
    # The common mode sees 4 inversions around the ring -> a stable non-oscillating DC state exists
    # (p1=n1=p3=n3 high, p2=n2=p4=n4 low, or the inverse) at every VCTRL in TT/SS; a stronger
    # cross-coupled latch does not remove it. Start-up: detect p2==n2 for > ~5 ns from the stage-2
    # buffers and pull ONE node low hard (n1 when p1=n1 high, n2 when p2=n2 high), which makes that
    # stage strongly differential; the kick ends as soon as the raw detector deasserts. Releasing a
    # footer instead lets the stuck node rise only through the weak latch, and the slow transition
    # flips the whole common mode into the opposite latched state (relaxation between the two).
    # During oscillation dD0/dD1 are complementary, so the RC-filtered detectors stay inactive.
    s.newrow("start-up: common-mode latch detector -> kick (VR domain)")
    VR = dict(VDD="VR", VSS="VSS")
    # inputs: the core's divider-clock inverter outputs ck<n> = !n (CK = ckdp1), so the 8 phase
    # outputs carry no load besides the mixer
    s.sub("nand2", "XSUA", dict(A="ckdp2", B="ckdn2", Y="sua", **VR))   # low when p2=n2 low
    s.sub("nor2", "XSUB", dict(A="ckdp2", B="ckdn2", Y="sub", **VR))    # high when p2=n2 high (p1=n1 low)
    for k in ("1", "3", "4"):                                          # identical loads on the other ck<n>
        cp = "CK" if k == "1" else "ckdp" + k
        s.sub("nand2", "XSUAD" + k, dict(A=cp, B="ckdn" + k, Y="suad" + k, **VR))
        s.sub("nor2", "XSUBD" + k, dict(A=cp, B="ckdn" + k, Y="subd" + k, **VR))
    for nm, a in (("A", "sua"), ("B", "sub")):
        s.rpoly("RSU" + nm, a, "f" + a, W="1u", L="100u")
        s.cmim("CSU" + nm, "f" + a, "VSS", W="5e-6", L="5e-6")
    # slow to assert (RC ~5 ns), released as soon as the raw detector deasserts
    s.sub("nor2", "XSUA1", dict(A="sua", B="fsua", Y="kh", **VR))       # kh = latched (p2=n2 low)
    s.sub("inv_dig", "XSUA2", dict(A="kh", Y="khn", **VR))             # khn: matches kl loading
    s.sub("nand2", "XSUB1", dict(A="sub", B="fsub", Y="kln", **VR))
    s.sub("inv_dig", "XSUB2", dict(A="kln", Y="kl", **VR))             # kl = latched (p2=n2 high)
    s.save(); s.save_sym()


# ---------------------------------------------------------------- bias
def bias_gen():
    """Constant-gm (beta-multiplier) reference with start-up.
    Distributed (low-Vov) units: NB -> 50 uA per NMOS 16u/2u, PB -> 50 uA per PMOS 32u/2u."""
    s = Sch("bias_gen", [("NB", "out"), ("PB", "out")] + SUP, title="Constant-gm bias, 50 uA unit")
    s.newrow("core")
    s.nmos("MN1", "nbc", "nbc", "VSS", W="4u", L="2u")
    s.nmos("MN2", "pbc", "nbc", "nr", W="16u", L="2u", nf=2)
    s.rpoly("RB", "nr", "VSS", W="1u", L="4.6u")
    s.pmos("MP1", "nbc", "pbc", "VDD", W="8u", L="2u")
    s.pmos("MP2", "pbc", "pbc", "VDD", W="8u", L="2u")
    s.newrow("start-up")
    s.pmos("MSP", "st", "VSS", "VDD", W="1u", L="20u")
    s.nmos("MSN", "st", "nbc", "VSS", W="2u", L="1u")
    s.nmos("MSU", "pbc", "st", "VSS", W="1u", L="1u")
    s.newrow("low-Vov distribution diodes")
    s.pmos("MP3", "NB", "pbc", "VDD", W="8u", L="2u")
    s.nmos("MN3", "NB", "NB", "VSS", W="16u", L="2u", nf=2)
    s.nmos("MN4", "PB", "nbc", "VSS", W="4u", L="2u")
    s.pmos("MP4", "PB", "PB", "VDD", W="32u", L="2u", nf=4)
    s.cmim("CNB", "NB", "VSS", W="20e-6", L="20e-6")
    s.cmim("CPB", "VDD", "PB", W="20e-6", L="20e-6")
    s.save(); s.save_sym()



# ---------------------------------------------------------------- LNA
def lna_nc():
    """Inductorless noise-cancelling CG-CS balun LNA (single-ended 50 ohm in, differential out).
    M1 (CG) matches the input (gm1+gmb1+1/RS = 1/50 ohm); its channel noise appears in phase at X and
    OUTP_i, M2 (CS, gm2 = n*gm1) inverts the X voltage so the M1 noise cancels in OUTP-OUTN when
    gm2*R2 = R1/Rs.  Both devices are biased from scaled replicas fed by PB-mirrored currents."""
    s = Sch("lna_nc", [("RFIN", "in"), ("PB", "in"), ("OUTP", "out"), ("OUTN", "out")] + SUP, cols=5, dx=280,
            title="Noise-cancelling CG-CS balun LNA (no inductor): 50 ohm SE in, differential out")
    s.newrow("CG matching device M1 + source resistor RS (300 ohm) + load R1 (200 ohm)")
    s.nmos("M1", "op_i", "vb1", "RFIN", W="40u", nf=8, m=3)
    s.rpoly("RS", "RFIN", "VSS", W="10u", L="3u")
    s.rpoly("R1", "VDD", "op_i", W="10u", L="2u")
    s.newrow("CS noise-cancelling device M2 (AC-coupled gate) + load R2 = R1/n")
    s.cmim("CC2", "RFIN", "g2", W="45e-6", L="45e-6")
    s.rpoly("RB2", "g2", "vb2", W="1u", L="10u")
    s.nmos("M2", "on_i", "g2", "VSS", W="40u", nf=8, m=8)
    s.rpoly("R2", "VDD", "on_i", W="15u", L="1u")
    s.newrow("replica bias: M1r = M1/10 with RS*10, M2r = M2/40 (PB mirrors 300 uA / 250 uA)")
    s.pmos("MP1", "vb1", "PB", "VDD", W="32u", L="2u", nf=4, m=6)
    s.nmos("M1R", "vb1", "vb1", "s1r", W="12u", nf=2)
    s.rpoly("RSR", "s1r", "VSS", W="1u", L="3u")
    s.pmos("MP2", "vb2", "PB", "VDD", W="32u", L="2u", nf=4, m=5)
    s.nmos("M2R", "vb2", "vb2", "VSS", W="8u", nf=2)
    s.newrow("bias decoupling + output AC coupling to the mixer")
    s.cmim("CB1", "vb1", "VSS", W="50e-6", L="50e-6")
    s.cmim("CB2", "vb2", "VSS", W="50e-6", L="50e-6")
    s.cmim("COP", "op_i", "OUTP", W="45e-6", L="45e-6")
    s.cmim("CON", "on_i", "OUTN", W="45e-6", L="45e-6")
    s.save(); s.save_sym()


# ---------------------------------------------------------------- mixer
# trim NMOS width (um, L = 2 um) per LO phase: 7 fF base on every phase + the load missing after PEX
LO_TRIM = {"L1P": 0.8, "L1N": 2.65, "L2P": 1.95, "L2N": 2.1, "L3P": 1.0, "L3N": 1.1, "L4P": 4.05, "L4N": 4.05}


def mixer_iq():
    """I/Q double-balanced sub-harmonic mixers (stacked switches) sharing a 100-ohm differential RF
    termination. The LO is the 8-phase ring at fLO/2: per mixer a lower switch pair driven by phase
    k+2 (90 deg at fLO/2) and an upper quad driven by phase k multiply the RF current by
    XOR(p_k, p_k+2) = a 50 % square wave at fLO. No 1.57 GHz LO signal exists on the chip."""
    s = Sch("mixer_iq", [("RFP", "in"), ("RFN", "in")] + [(n, "in") for n in LOPH] + [("NB", "in"),
                         ("IFIP", "out"), ("IFIN", "out"), ("IFQP", "out"), ("IFQN", "out")] + SUP,
            title="I/Q sub-harmonic Gilbert mixer, RF 1575.42 MHz, LO 2 x 785.664 MHz, 2 mA/mixer, driven by lna_nc")
    s.newrow("RF input bias (LNA drives the mixer: 5 kohm to VBRF) + bias divider")
    s.rpoly("RT1", "RFP", "vbrf", W="1u", L="5u")
    s.rpoly("RT2", "RFN", "vbrf", W="1u", L="5u")
    s.rpoly("RBA", "VDD", "vbrf", W="1u", L="20u")
    s.rpoly("RBB", "vbrf", "VSS", W="1u", L="13u")
    s.cmim("CBRF", "vbrf", "VSS", W="70e-6", L="70e-6")
    # LO phases are AC-coupled onto fixed gate biases (the phase drivers swing 0..VR, and VR tracks the
    # VCO corner): 1.8 V for the upper quads, 1.2 V for the lower pairs (keeps the Gm pair saturated).
    s.newrow("LO AC coupling (2 pF) + 20 kohm to the switch-gate biases (upper 1.8 V, lower 1.2 V)")
    s.rpoly("RLUA", "VDD", "vlou", W="1u", L="47u")
    s.rpoly("RLUB", "vlou", "VSS", W="1u", L="56u")
    s.cmim("CLOU", "vlou", "VSS", W="50e-6", L="50e-6")
    s.rpoly("RLLA", "VDD", "vlol", W="1u", L="65u")
    s.rpoly("RLLB", "vlol", "VSS", W="1u", L="37u")
    s.cmim("CLOL", "vlol", "VSS", W="50e-6", L="50e-6")
    for lo in LOPH:
        g = "g" + lo.lower()
        s.cmim("CAC" + lo, lo, g, W="31.6e-6", L="31.6e-6")
        s.rpoly("RAC" + lo, g, "vlou" if lo[1] in "12" else "vlol", W="1u", L="20u")
    # LO load trim: the layout leaves the 8 phases unequally loaded (pin + gate-side wiring
    # 137..164 fF, L4 lightest), which skews the ring phases (LO I/Q +2.7 deg after PEX).  An NMOS
    # gate cap on each switch-gate node (biased in inversion, ~4.3 fF/um2) evens out the load seen by
    # the VCO (pin C + ~0.8 x gate-side C through CAC).
    s.newrow("LO load trim (NMOS gate caps on the switch-gate nodes, sized from the PEX loads)")
    for lo in LOPH:
        s.nmos("MCT" + lo, "VSS", "g" + lo.lower(), "VSS", W="%gu" % LO_TRIM[lo], L="2u")
    # I: out+ = p1.n3 + n1.p3 (upper phase 1, lower phase 3); Q: phases 2 / 4 (45 deg later = 90 deg at fLO)
    for ch, u, l, op, on in (("I", "1", "3", "IFIP", "IFIN"), ("Q", "2", "4", "IFQP", "IFQN")):
        s.newrow("%s mixer: Gm pair, lower switch pairs, upper switch quads, RC load" % ch)
        s.nmos("MT" + ch, "t" + ch, "NB", "VSS", W="40u", L="2u", nf=4, m=16)
        s.nmos("MG1" + ch, "xp" + ch, "RFP", "t" + ch, W="80u", nf=16)
        s.nmos("MG2" + ch, "xn" + ch, "RFN", "t" + ch, W="80u", nf=16)
        gpu, gnu, gpl, gnl = "gl%sp" % u, "gl%sn" % u, "gl%sp" % l, "gl%sn" % l
        for x, P_, N_ in (("p", op, on), ("n", on, op)):
            xx = "x%s%s" % (x, ch)
            ma, mb = "m%sa%s" % (x, ch), "m%sb%s" % (x, ch)
            s.nmos("MLA%s%s" % (x, ch), ma, gnl, xx, W="40u", nf=8)
            s.nmos("MLB%s%s" % (x, ch), mb, gpl, xx, W="40u", nf=8)
            s.nmos("MU1%s%s" % (x, ch), P_, gpu, ma, W="20u", nf=4)
            s.nmos("MU2%s%s" % (x, ch), N_, gnu, ma, W="20u", nf=4)
            s.nmos("MU3%s%s" % (x, ch), N_, gpu, mb, W="20u", nf=4)
            s.nmos("MU4%s%s" % (x, ch), P_, gnu, mb, W="20u", nf=4)
        s.rpoly("RL1" + ch, "VDD", op, W="2u", L="2.4u")
        s.rpoly("RL2" + ch, "VDD", on, W="2u", L="2.4u")
        s.cmim("CL1" + ch, op, "VSS", W="45e-6", L="45e-6")
        s.cmim("CL2" + ch, on, "VSS", W="45e-6", L="45e-6")
    s.save(); s.save_sym()


# ---------------------------------------------------------------- IF chain
def vga():
    """AC-coupled degenerated differential amplifier with 2-bit gain control.
    HPF ~0.3 MHz (5 pF / 100 kohm) removes DC offset + 1/f (no signal near DC
    because GPS/GAL IF = 4.092 MHz, GLONASS IF = 26.7..34.6 MHz)."""
    s = Sch("vga", [("INP", "in"), ("INN", "in"), ("GA", "in"), ("GB", "in"), ("NB", "in"),
                    ("OUTP", "out"), ("OUTN", "out")] + SUP,
            title="VGA: AC coupled, switched source degeneration (per stage ~2/6/10/11.5 dB)")
    s.newrow("AC coupling + input common mode (1.4 V)")
    s.cmim("CC1", "INP", "gp", W="50e-6", L="50e-6")
    s.cmim("CC2", "INN", "gn", W="50e-6", L="50e-6")
    s.rpoly("RB1", "gp", "vcm", W="1u", L="100u")
    s.rpoly("RB2", "gn", "vcm", W="1u", L="100u")
    s.rpoly("RCA", "VDD", "vcm", W="1u", L="34u")
    s.rpoly("RCB", "vcm", "VSS", W="1u", L="25u")
    s.cmim("CCM", "vcm", "VSS", W="30e-6", L="30e-6")
    s.newrow("diff pair, per-side tail (1 mA), loads 2 kohm (low Rout to drive the Sallen-Key)")
    s.nmos("M1", "OUTN", "gp", "s1", W="40u", nf=8, m=2)
    s.nmos("M2", "OUTP", "gn", "s2", W="40u", nf=8, m=2)
    s.nmos("MT1", "s1", "NB", "VSS", W="40u", L="2u", nf=4, m=8)
    s.nmos("MT2", "s2", "NB", "VSS", W="40u", L="2u", nf=4, m=8)
    s.rpoly("RL1", "VDD", "OUTN", W="1u", L="2u")
    s.rpoly("RL2", "VDD", "OUTP", W="1u", L="2u")
    s.newrow("degeneration network (s1-s2)")
    s.rpoly("RD0", "s1", "s2", W="1u", L="2u")
    s.nmos("MSA", "s1", "GA", "da", W="20u", nf=4)
    s.rpoly("RDA", "da", "s2", W="1u", L="3u")
    s.nmos("MSB", "s1", "GB", "db", W="40u", nf=8)
    s.rpoly("RDB", "db", "s2", W="2u", L="1.8u")
    s.save(); s.save_sym()


def sk_lpf(name, c1, c2):
    """Differential unity-gain Sallen-Key biquad with PMOS source followers
    (bulk tied to source -> A ~ 0.95).  C1: feedback (x->out), C2: y->VSS.
    C1/C2 are sized for the layout: the 5x5 um MIM units add their perimeter capacitance (+9.6 %)
    and the wiring loads the filter nodes, which put the PEX upper band edge at 5.75 MHz with the
    schematic sizes (47.6/51.2, 107.1/25.7 um).  80 % of that unit count restores ~7 MHz after
    extraction (the schematic alone then shows ~8 MHz)."""
    s = Sch(name, [("INP", "in"), ("INN", "in"), ("PB", "in"), ("OUTP", "out"), ("OUTN", "out")] + SUP,
            title="%s: Sallen-Key LPF, R1=1k (+2k VGA Rout), R2=3k, C1/C2 MIM side %s/%s um" % (name, c1, c2))
    for sd, i, o in (("P", "INP", "OUTP"), ("N", "INN", "OUTN")):
        s.newrow("side %s" % sd)
        s.rpoly("R1" + sd, i, "x" + sd, W="1u", L="1u")
        s.rpoly("R2" + sd, "x" + sd, "y" + sd, W="1u", L="3u")
        s.cmim("C1" + sd, "x" + sd, o, W="%se-6" % c1, L="%se-6" % c1)
        s.cmim("C2" + sd, "y" + sd, "VSS", W="%se-6" % c2, L="%se-6" % c2)
        s.pmos("MF" + sd, "VSS", "y" + sd, o, b=o, W="40u", nf=8)
        s.pmos("MI" + sd, o, "PB", "VDD", W="40u", L="2u", nf=4, m=16)
    s.save(); s.save_sym()


def bias_if():
    """Ratiometric tail bias for the IF VGAs: Iref = (a VDD) / RREF with RREF = 9 series copies of the
    VGA load unit (1u x 2u poly, end resistance included), so I_tail * RL = (20 a / 9) VDD = 0.64 VDD at
    every process / temperature corner (VGA output CM ~ 0.36 VDD = 1.19 V; FF needs >= 1.0 V because the
    low-Vt pair source sits at ~0.72 V).  The constant-gm NB (current x2 from
    -20 to 85 C, plus res_ss) pulled the VGA outputs to 0.53 V at SS 85 C 3.135 V (gain -35 dB).
    NBIF is a 16u/2u diode like NB, so a VGA tail (320u/2u) carries 20 x Iref (~1.1 mA).
    PBIF (32u/2u diode like PB) feeds the Sallen-Key follower sources: from the constant-gm PB they
    carried 2.2 mA at FF 85 C and went into triode at 3.135 V (IF gain -9 dB)."""
    s = Sch("bias_if", [("PB", "in"), ("NBIF", "out"), ("PBIF", "out")] + SUP, title="IF VGA tail bias: I = a VDD / Rpoly (ratiometric)")
    s.newrow("divider a = 28.3 / 98.3")
    s.rpoly("RDA", "VDD", "vdiv", W="1u", L="70u")
    s.rpoly("RDB", "vdiv", "VSS", W="1u", L="28.3u")
    s.newrow("PMOS-input OTA (50 uA tail from PB) forces v(x) = v(vdiv)")
    s.pmos("MOT", "ot", "PB", "VDD", W="32u", L="2u", nf=4)
    s.pmos("MI1", "o1", "vdiv", "ot", W="16u", L="1u", nf=2)
    s.pmos("MI2", "og", "x", "ot", W="16u", L="1u", nf=2)
    s.nmos("ML1", "o1", "o1", "VSS", W="4u", L="2u")
    s.nmos("ML2", "og", "o1", "VSS", W="4u", L="2u")
    s.cmim("CC", "og", "VSS", W="20e-6", L="20e-6")
    s.newrow("V-I: MV + RREF (9 x VGA load unit), PMOS mirror 1:1 -> NMOS diode NBIF")
    s.nmos("MV", "dp", "og", "x", W="20u", L="1u", nf=2)
    for k in range(9):
        s.rpoly("RREF%d" % k, "x" if k == 0 else "r%d" % k, "VSS" if k == 8 else "r%d" % (k + 1), W="1u", L="2u")
    s.pmos("MPD", "dp", "dp", "VDD", W="32u", L="2u", nf=4)
    s.pmos("MPM", "NBIF", "dp", "VDD", W="32u", L="2u", nf=4)
    s.nmos("MND", "NBIF", "NBIF", "VSS", W="16u", L="2u", nf=2)
    s.cmim("CNB", "NBIF", "VSS", W="20e-6", L="20e-6")
    s.newrow("PMOS bias for the Sallen-Key followers (same Iref)")
    s.nmos("MNP", "PBIF", "NBIF", "VSS", W="16u", L="2u", nf=2)
    s.pmos("MPP", "PBIF", "PBIF", "VDD", W="32u", L="2u", nf=4)
    s.cmim("CPB", "VDD", "PBIF", W="20e-6", L="20e-6")
    s.save(); s.save_sym()


def if_chain():
    s = Sch("if_chain", [("INP", "in"), ("INN", "in"), ("G1A", "in"), ("G1B", "in"),
                         ("G2A", "in"), ("G2B", "in"), ("G3A", "in"), ("G3B", "in"), ("PB", "in"),
                         ("OUTP", "out"), ("OUTN", "out")] + SUP, cols=3, dx=400,
            title="IF chain (GPS/Galileo): VGA1 - SK LPF (Q=0.54) - VGA2 - SK LPF (Q=1.31) - VGA3 - VGA4..6 (fixed); BW ~0.8-7 MHz")
    s.sub("bias_if", "XBIF", dict(PB="PB", NBIF="nbif", PBIF="pbif", **P))
    s.sub("vga", "XV1", dict(INP="INP", INN="INN", GA="G1A", GB="G1B", NB="nbif", OUTP="a1p", OUTN="a1n", **P))
    s.sub("sk_lpf1", "XF1", dict(INP="a1p", INN="a1n", PB="pbif", OUTP="f1p", OUTN="f1n", **P))
    s.sub("vga", "XV2", dict(INP="f1p", INN="f1n", GA="G2A", GB="G2B", NB="nbif", OUTP="a2p", OUTN="a2n", **P))
    s.newrow()
    s.sub("sk_lpf2", "XF2", dict(INP="a2p", INN="a2n", PB="pbif", OUTP="f2p", OUTN="f2n", **P))
    s.sub("vga", "XV3", dict(INP="f2p", INN="f2n", GA="G3A", GB="G3B", NB="nbif", OUTP="a3p", OUTN="a3n", **P))
    s.sub("vga", "XV4", dict(INP="a3p", INN="a3n", GA="VDD", GB="VDD", NB="nbif", OUTP="a4p", OUTN="a4n", **P))
    s.newrow("fixed gain stages (needed for 20 dB external LNA and 7.5 MHz noise bandwidth)")
    s.sub("vga", "XV5", dict(INP="a4p", INN="a4n", GA="VDD", GB="VDD", NB="nbif", OUTP="a5p", OUTN="a5n", **P))
    s.sub("vga", "XV6", dict(INP="a5p", INN="a5n", GA="VDD", GB="VDD", NB="nbif", OUTP="OUTP", OUTN="OUTN", **P))
    s.save(); s.save_sym()


# ---------------------------------------------------------------- ADC
def sa_comp():
    s = Sch("sa_comp", [("INP", "in"), ("INN", "in"), ("REFP", "in"), ("REFN", "in"), ("CLK", "in"),
                        ("Q", "out"), ("QB", "out")] + SUP,
            title="StrongARM comparator, decision sign[(INP-INN)-(REFP-REFN)] + SR latch")
    s.newrow("input pairs + tail")
    s.nmos("MT", "t", "CLK", "VSS", W="8u", nf=2)
    s.nmos("M1", "x1", "INP", "t", W="4u")
    s.nmos("M2", "x2", "INN", "t", W="4u")
    s.nmos("M3", "x2", "REFP", "t", W="4u")
    s.nmos("M4", "x1", "REFN", "t", W="4u")
    s.newrow("cross-coupled latch")
    s.nmos("M5", "on", "op", "x1", W="2u")
    s.nmos("M6", "op", "on", "x2", W="2u")
    s.pmos("M7", "on", "op", "VDD", W="2u")
    s.pmos("M8", "op", "on", "VDD", W="2u")
    s.newrow("reset switches")
    s.pmos("M9", "on", "CLK", "VDD", W="1u")
    s.pmos("M10", "op", "CLK", "VDD", W="1u")
    s.pmos("M11", "x1", "CLK", "VDD", W="1u")
    s.pmos("M12", "x2", "CLK", "VDD", W="1u")
    s.newrow("isolation inverters (state-independent load on op/on) + NOR SR latch")
    s.sub("inv_dig", "XI1", dict(A="op", Y="opb", **P))
    s.sub("inv_dig", "XI2", dict(A="on", Y="onb", **P))
    s.sub("nor2", "XS1", dict(A="opb", B="QB", Y="Q", **P))
    s.sub("nor2", "XS2", dict(A="onb", B="Q", Y="QB", **P))
    s.save(); s.save_sym()


def adc2b():
    s = Sch("adc2b", [("INP", "in"), ("INN", "in"), ("CLK", "in"), ("SIGN", "out"), ("MAG", "out")] + SUP,
            cols=4, dx=320,
            title="2-bit sign/magnitude ADC (MAX2769 compatible format), threshold +-0.15 V diff")
    s.newrow("threshold ladder (VCM = 0.363 VDD = 1.20 V = IF output CM, set by bias_if)")
    s.rpoly("RL0", "VDD", "thp", W="10u", L="40.1u")
    s.rpoly("RL1", "thp", "thm", W="10u", L="1.4u")
    s.rpoly("RL2", "thm", "thn", W="10u", L="1.4u")
    s.rpoly("RL3", "thn", "VSS", W="10u", L="22.3u")
    s.cmim("CT1", "thp", "VSS", W="50e-6", L="50e-6")
    s.cmim("CT2", "thm", "VSS", W="50e-6", L="50e-6")
    s.cmim("CT3", "thn", "VSS", W="50e-6", L="50e-6")
    s.newrow("comparators")
    s.sub("sa_comp", "XCS", dict(INP="INP", INN="INN", REFP="thm", REFN="thm", CLK="CLK", Q="SIGN", QB="sb", **P))
    s.sub("sa_comp", "XCH", dict(INP="INP", INN="INN", REFP="thp", REFN="thn", CLK="CLK", Q="qh", QB="qhb", **P))
    s.sub("sa_comp", "XCL", dict(INP="INP", INN="INN", REFP="thn", REFN="thp", CLK="CLK", Q="ql", QB="qlb", **P))
    s.newrow("MAG = (v > +Vth) OR (v < -Vth)")
    s.sub("nand2", "XM", dict(A="qhb", B="ql", Y="MAG", **P))
    s.save(); s.save_sym()


# ---------------------------------------------------------------- PLL
def nand3(name="nand3", wn="3u", wp="2u"):
    s = Sch(name, [("A", "in"), ("B", "in"), ("C", "in"), ("Y", "out")] + SUP, title="NAND3")
    s.nmos("MN1", "Y", "A", "n1", W=wn)
    s.nmos("MN2", "n1", "B", "n2", W=wn)
    s.nmos("MN3", "n2", "C", "VSS", W=wn)
    s.pmos("MP1", "Y", "A", "VDD", W=wp)
    s.pmos("MP2", "Y", "B", "VDD", W=wp)
    s.pmos("MP3", "Y", "C", "VDD", W=wp)
    s.save(); s.save_sym()


def dff_r():
    """74-style 6-NAND positive-edge DFF with active-low clear, D tied high."""
    s = Sch("dff_r", [("CK", "in"), ("RB", "in"), ("Q", "out")] + SUP, cols=3, dx=320,
            title="Edge DFF (D=1) with async clear for PFD")
    s.sub("nand2", "X1", dict(A="n4", B="n2", Y="n1", **P))
    s.sub("nand3", "X2", dict(A="n1", B="CK", C="RB", Y="n2", **P))
    s.sub("nand3", "X3", dict(A="n2", B="CK", C="n4", Y="n3", **P))
    s.sub("nand2", "X4", dict(A="n3", B="RB", Y="n4", **P))
    s.sub("nand2", "X5", dict(A="n2", B="qb", Y="Q", **P))
    s.sub("nand3", "X6", dict(A="Q", B="n3", C="RB", Y="qb", **P))
    s.save(); s.save_sym()


def pfd():
    s = Sch("pfd", [("REF", "in"), ("FB", "in"), ("UP", "out"), ("UPB", "out"), ("DN", "out"),
                    ("DNB", "out")] + SUP, cols=4, dx=300,
            title="Tri-state PFD with reset delay (anti dead-zone)")
    s.sub("dff_r", "XU", dict(CK="REF", RB="rb", Q="UP", **P))
    s.sub("dff_r", "XD", dict(CK="FB", RB="rb", Q="DN", **P))
    s.sub("nand2", "XR", dict(A="UP", B="DN", Y="r0", **P))
    s.sub("inv_dig", "XD1", dict(A="r0", Y="r1", **P))
    s.sub("inv_dig", "XD2", dict(A="r1", Y="r2", **P))
    s.sub("inv_dig", "XD3", dict(A="r2", Y="r3", **P))
    s.sub("inv_dig", "XD4", dict(A="r3", Y="rb", **P))
    s.sub("inv_dig", "XO1", dict(A="UP", Y="UPB", **P))
    s.sub("inv_dig", "XO2", dict(A="DN", Y="DNB", **P))
    s.save(); s.save_sym()


def cp():
    """HI = 1 adds an identical second leg (Icp x2) behind static enable switches.
    Used for band B=11 (SS): Kvco there drops to ~120 MHz/V, fc falls to 0.31 MHz near the
    loop-filter zero (257 kHz) and PM to 45 deg (38 deg with R/C spread); x2 restores ~55 deg.
    Current steering: while a switch is off its source current flows into vd, which a unity-gain
    buffer holds at OUT.  With plain switches nc fell to 0 V (pc rose to VDD) between pulses and
    charging it back from OUT took 55 fC (TT) / 123 fC (FF) per period -> static phase offset
    0.4-0.9 ns, the C2 ripple step and the reference spur (-37 dBc FF, PEX).
    The steering switch always toggles after the OUT switch (OUT one on first, off first): pc / nc
    excursions while both are off then empty into vd, not OUT.  PMOS: UPB -> inverter -> upd
    (driving the steer PMOS with UP itself let pc charge ~0.1 ns per pulse: +30 fC up);
    NMOS: DN -> DNB already lags by one inverter.
    PMOS switches 8u (MPE2 24u): with 4u they dropped ~0.4 V and at SS / HI = 1 Iup sagged to
    342 uA at VCTRL 2.5 V (0.28 ns offset); 12u fixes the sag but adds switch-charge offset."""
    s = Sch("cp", [("UPB", "in"), ("DN", "in"), ("DNB", "in"), ("PB", "in"), ("NB", "in"),
                   ("HI", "in"), ("OUT", "out")] + SUP,
            title="Current-steering charge pump, Icp = 200 uA (x2 when HI = 1), vd buffered to OUT")
    s.sub("inv_dig", "XUD", dict(A="UPB", Y="upd", **P))
    s.pmos("MPC", "pc", "PB", "VDD", W="32u", L="2u", nf=4, m=4)
    s.pmos("MPS", "OUT", "UPB", "pc", W="8u", nf=2)
    s.pmos("MPD", "vd", "upd", "pc", W="8u", nf=2)
    s.nmos("MNS", "OUT", "DN", "nc", W="2u")
    s.nmos("MND", "vd", "DNB", "nc", W="2u")
    s.nmos("MNC", "nc", "NB", "VSS", W="16u", L="2u", nf=2, m=4)
    s.newrow("boost leg (HI = 1)")
    s.sub("inv_dig", "XHI", dict(A="HI", Y="hib", **P))
    s.pmos("MPC2", "pc2", "PB", "VDD", W="32u", L="2u", nf=4, m=4)
    s.pmos("MPE2", "pe2", "hib", "pc2", W="24u", nf=4)
    s.pmos("MPS2", "OUT", "UPB", "pe2", W="8u", nf=2)
    s.pmos("MPD2", "vd", "upd", "pe2", W="8u", nf=2)
    s.nmos("MNS2", "OUT", "DN", "ne2", W="2u")
    s.nmos("MND2", "vd", "DNB", "ne2", W="2u")
    s.nmos("MNE2", "ne2", "HI", "nc2", W="4u", nf=2)
    s.nmos("MNC2", "nc2", "NB", "VSS", W="16u", L="2u", nf=2, m=4)
    s.newrow("unity-gain buffer vd = OUT (NMOS pair, 50 uA tail from NB): sinks / sources the up / down mismatch")
    s.nmos("MBT", "bt", "NB", "VSS", W="16u", L="2u", nf=2)
    s.nmos("MB1", "b1", "OUT", "bt", W="8u", L="1u", nf=2)
    s.nmos("MB2", "vd", "vd", "bt", W="8u", L="1u", nf=2)
    s.pmos("MBL1", "b1", "b1", "VDD", W="8u", L="1u", nf=2)
    s.pmos("MBL2", "vd", "b1", "VDD", W="8u", L="1u", nf=2)
    s.cmim("CVD", "vd", "VSS", W="32e-6", L="32e-6")
    s.save(); s.save_sym()


def loop_filter():
    s = Sch("loop_filter", [("VC", "inout"), ("VT", "out"), ("VSS", "inout")],
            title="2nd-order passive loop filter: R=5k, C1=120p, C2=10p (on-chip MIM); VCO tap VT from C2 via 1k / 1.5p")
    s.rpoly("RZ", "VC", "z", W="1u", L="5u")
    s.cmim("C1", "z", "VSS", W="77e-6", L="77e-6", mult=10)
    s.cmim("C2", "VC", "VSS", W="70e-6", L="70e-6")
    # the VCO tunes from C2's plate, not from the CP output: in the layout the CP current pulses
    # dropped ~0.4 kohm of wiring (260-440 mV spikes at the VCO pin, PEX).  Behind RVT the pin is
    # high-impedance: with 0.8 pF the ~14 fF from FS/FB/REFCK kicked it 20-30 mV every half
    # period (-22 dBc TT).  SEP now keeps them < 0.1 fF; 1.5 pF (pole ~100 MHz) costs FF ~1.5 deg PM
    # (4 pF: ~6 deg) and still damps the residual kicks
    s.rpoly("RVT", "VC", "VT", W="2u", L="2u")
    s.cmim("C3", "VT", "VSS", W="27.5e-6", L="27.5e-6")
    s.save(); s.save_sym()


def selfbias_buf(name, cin, rf_len, wn, wp):
    s = Sch(name, [("IN", "in"), ("OUT", "out")] + SUP,
            title="%s: AC-coupled self-biased inverter (level restore to 3.3 V)" % name)
    s.cmim("CIN", "IN", "a", W="%se-6" % cin, L="%se-6" % cin)
    s.rpoly("RF", "a", "b", W="1u", L=rf_len)
    s.nmos("MN1", "b", "a", "VSS", W=wn)
    s.pmos("MP1", "b", "a", "VDD", W=wp)
    s.nmos("MN2", "OUT", "b", "VSS", W=wn)
    s.pmos("MP2", "OUT", "b", "VDD", W=wp)
    s.save(); s.save_sym()


def div2():
    s = Sch("div2", [("CK", "in"), ("Q", "out"), ("QB", "out")] + SUP, title="TSPC divide-by-2")
    s.sub("tspc_dff", "XF", dict(D="QB", CK="CK", Q="Q", QB="QB", **P))
    s.save(); s.save_sym()


def div3():
    s = Sch("div3", [("CK", "in"), ("Q", "out")] + SUP, title="Divide-by-3: D1=NOR(Q1,Q2), D2=Q1")
    s.sub("tspc_dff", "XF1", dict(D="d1", CK="CK", Q="Q", QB="q1b", **P))
    s.sub("tspc_dff", "XF2", dict(D="Q", CK="CK", Q="q2", QB="q2b", **P))
    s.sub("nor2", "XN", dict(A="Q", B="q2", Y="d1", **P))
    s.save(); s.save_sym()


def div48():
    s = Sch("div48", [("CK", "in"), ("FS", "out"), ("FB", "out")] + SUP, cols=4, dx=300,
            title="Fixed /48 = /2/2/2 (TSPC) /3 /2 from the 785.664 MHz ring phase. FB = FS = 16.368 MHz (PFD + ADC clock)")
    s.sub("div2", "XD1", dict(CK="CK", Q="c2", QB="c2b", **P))
    s.sub("div2", "XD2", dict(CK="c2", Q="c4", QB="c4b", **P))
    s.sub("div2", "XD3", dict(CK="c4", Q="c8", QB="c8b", **P))
    s.newrow("/3 is clocked from the lightly loaded c8 (TSPC needs sharp edges); FS = buffered FB")
    s.sub("div3", "XD5", dict(CK="c8", Q="c24", **P))
    s.sub("div2", "XD6", dict(CK="c24", Q="FB", QB="c48b", **P))
    s.sub("inv_lo1", "XFB1", dict(A="FB", Y="fbi", **P))
    s.sub("inv_lo2", "XFB2", dict(A="fbi", Y="FS", **P))
    s.save(); s.save_sym()


def pll_core():
    # the reference buffer (refbuf) is outside, on VDDV: its sine-input threshold follows its
    # supply, and VDD ripple moved the REFCK edges (x96 into the LO phase: -8 dBc at 20 mVp, 1 MHz)
    s = Sch("pll_core", [("REFCK", "in"), ("LO", "in"), ("NB", "in"), ("PB", "in"),
                         ("ICP2", "in"), ("VCTRL", "out"), ("FS", "out"), ("FB", "out")] + SUP,
            cols=4, dx=300,
            title="Integer-N PLL core: fREF = 16.368 MHz (TCXO), ring 785.664 MHz / 48 (LO = 2 x ring = 1571.328 MHz)")
    s.sub("divbuf", "XDB", dict(IN="LO", OUT="ck", **P))
    s.sub("div48", "XDIV", dict(CK="ck", FS="FS", FB="FB", **P))
    # REFCK comes from the VDDV domain (refbuf): series R + diode clamps to this domain's rails
    # in front of the PFD gates (CDM between the domains, which only share VSS); ~1 kohm x ~20 fF
    # (clamp gates from tie-high / tie-low devices, not the rails: a gate on the rail's M3 spine
    # alone failed the via3 antenna ratio, KLayout ANT.11.  MTX diode -> tx ~ 0: MTHI pulls thi
    # to VDD, MTLO pulls tlo to VSS; no second stable state)
    s.rpoly("RREF", "REFCK", "refck_i", W="2u", L="2u")
    s.nmos("MCLN", "refck_i", "tlo", "VSS", W="2u")
    s.pmos("MCLP", "refck_i", "thi", "VDD", W="2u")
    s.nmos("MTX", "tx", "tx", "VSS", W="1u")
    s.pmos("MTHI", "thi", "tx", "VDD", W="1u")
    s.nmos("MTLO", "tlo", "thi", "VSS", W="1u")
    s.newrow()
    s.sub("pfd", "XPFD", dict(REF="refck_i", FB="FB", UP="up", UPB="upb", DN="dn", DNB="dnb", **P))
    # ICP2 (SPI bit 16) is set by firmware, not tied to the band: B=11 is needed only by hot SS chips
    # (Kvco ~120 MHz/V); cold SS chips at B=11 have Kvco ~600 MHz/V, where Icp x2 would push fc to ~2 MHz.
    s.sub("cp", "XCP", dict(UPB="upb", DN="dn", DNB="dnb", PB="PB", NB="NB", HI="ICP2", OUT="vcp", **P))
    s.sub("loop_filter", "XLF", dict(VC="vcp", VT="VCTRL", VSS="VSS"))
    s.save(); s.save_sym()


# ---------------------------------------------------------------- supply decoupling
def decap(n=7, a=95):
    """VDD - VSS MIM decoupling (n x a x a um, 18 pF each): the chip's own supply current through
    the VDDA / VSS bond wires moved the on-chip VDD 72 mVpp with only the ~30 pF of parasitics"""
    s = Sch("decap", SUP, title="VDD decoupling: %d x %.0f pF MIM" % (n, 2e-3 * a * a))
    for k in range(n):
        s.cmim("CD%d" % k, "VDD", "VSS", W="%de-6" % a, L="%de-6" % a)
    s.save(); s.save_sym()


# ---------------------------------------------------------------- AFC DAC
def afc_dac():
    pins = [("D%d" % i, "in") for i in range(8)] + [("OUT", "out")] + SUP
    s = Sch("afc_dac", pins, cols=4, dx=300,
            title="AFC DAC: 8-bit R-2R (R = 10 k) for VCTCXO steering (common clock-drift correction)")
    s.rpoly("RT", "n0", "VSS", W="1u", L="20u")
    for i in range(8):
        s.newrow("bit %d" % i)
        s.sub("inv_dig", "XA%d" % i, dict(A="D%d" % i, Y="db%d" % i, **P))
        # ladder driver: Ron(N) ~ Ron(P) and << 2R, else the MSB step is off by several LSB
        s.sub("inv_dac", "XB%d" % i, dict(A="db%d" % i, Y="dr%d" % i, **P))
        node = lambda k: "OUT" if k == 7 else "n%d" % k
        s.rpoly("R2_%d" % i, "dr%d" % i, node(i), W="1u", L="20u")
        if i < 7:
            s.rpoly("R1_%d" % i, node(i), node(i + 1), W="1u", L="10u")
    s.save(); s.save_sym()



# ---------------------------------------------------------------- SPI
def tg(s, name, a, b, gn, gp):
    s.nmos(name + "N", a, gn, b, W="1u")
    s.pmos(name + "P", a, gp, b, W="2u")


def dffr_s():
    """Static master-slave positive-edge DFF with async active-high reset (Q=0)."""
    s = Sch("dffr_s", [("D", "in"), ("CK", "in"), ("RST", "in"), ("Q", "out")] + SUP, cols=4, dx=300,
            title="Static TG master-slave DFF, async reset (SPI shift register)")
    s.sub("inv_dig", "XCI", dict(A="CK", Y="ckb", **P))
    s.newrow("master (transparent CK=0)")
    tg(s, "T1", "D", "m", "ckb", "CK")
    s.sub("nor2", "XM", dict(A="m", B="RST", Y="mb", **P))
    s.sub("inv_dig", "XMF", dict(A="mb", Y="mf", **P))
    tg(s, "T2", "mf", "m", "CK", "ckb")
    s.newrow("slave (transparent CK=1)")
    tg(s, "T3", "mb", "sl", "CK", "ckb")
    s.sub("nor2", "XS", dict(A="sl", B="RST", Y="Q", **P))
    s.sub("inv_dig", "XSF", dict(A="Q", Y="sf", **P))
    tg(s, "T4", "sf", "sl", "ckb", "CK")
    s.save(); s.save_sym()


def latch_s():
    s = Sch("latch_s", [("D", "in"), ("EN", "in"), ("Q", "out")] + SUP,
            title="Static D latch, transparent when EN=1")
    s.sub("inv_dig", "XEI", dict(A="EN", Y="enb", **P))
    tg(s, "TI", "D", "l", "EN", "enb")
    s.sub("inv_dig", "X1", dict(A="l", Y="lb", **P))
    s.sub("inv_dig", "X2", dict(A="lb", Y="Q", **P))
    tg(s, "TF", "Q", "l", "enb", "EN")
    s.save(); s.save_sym()


SPI_MAP = ["IG1A", "IG1B", "IG2A", "IG2B", "IG3A", "IG3B", "B0", "B1"] + ["AFC%d" % i for i in range(8)] + ["ICP2"]
SPI_BITS = 24   # frame length (3 bytes); bits 23..17 are reserved (shift stages only, no output latch)


def spi_regs():
    """3-wire SPI (mode 0, MSB first, 24-bit frame, write only).
    reg[23:17] reserved, reg[16] = ICP2 (charge pump x2),
    reg[15:8] = AFC code XOR 0x80 (0 = mid scale), reg[7:6] = B1,B0, reg[5:0] = IG3B..IG1A.
    Shift register clocked by SCLK while CS_N=0; output latches transparent while CS_N=1,
    so outputs update on the CS_N rising edge.  Power-on reset -> all register bits 0."""
    s = Sch("spi_regs", [("SCLK", "in"), ("SDI", "in"), ("CS_N", "in")] +
            [(n, "out") for n in SPI_MAP] + SUP, cols=4, dx=300,
            title="SPI register: 24 bit, mode 0, MSB first; POR defaults: gain min, band 00, AFC mid scale, Icp x1")
    s.newrow("CS_N pull-up, clock gating, power-on reset (RC 200k x 10p)")
    s.rpoly("RPU", "VDD", "CS_N", W="1u", L="100u")
    s.sub("inv_dig", "XSCB", dict(A="SCLK", Y="sclkb", **P))
    s.sub("nor2", "XSCG", dict(A="CS_N", B="sclkb", Y="sck", **P))
    s.rpoly("RPOR", "VDD", "pr", W="1u", L="200u")
    s.cmim("CPOR", "pr", "VSS", W="70e-6", L="70e-6")
    s.sub("inv_dig", "XP1", dict(A="pr", Y="por1", **P))
    s.sub("inv_dig", "XP2", dict(A="por1", Y="por2", **P))
    s.sub("inv_dig", "XP3", dict(A="por2", Y="rst", **P))
    for i in range(SPI_BITS):
        if i % 4 == 0:
            s.newrow("shift register stages %d-%d" % (i, i + 3))
        s.sub("dffr_s", "XR%d" % i, dict(D="SDI" if i == 0 else "r%d" % (i - 1), CK="sck", RST="rst",
                                         Q="r%d" % i, **P))
    s.newrow("output latches (after 16 clocks shift stage i holds frame bit i; MSB sent first)")
    for i in range(len(SPI_MAP)):
        out = SPI_MAP[i]
        if out == "AFC7":
            s.sub("latch_s", "XL%d" % i, dict(D="r%d" % i, EN="CS_N", Q="afc7n", **P))
            s.sub("inv_dig", "XAFC7", dict(A="afc7n", Y="AFC7", **P))
        else:
            s.sub("latch_s", "XL%d" % i, dict(D="r%d" % i, EN="CS_N", Q=out, **P))
    s.save(); s.save_sym()


# ---------------------------------------------------------------- TOP
def top(name="gnss_afe_top", with_spi=True):
    """with_spi=False: the analog hard macro (gnss_afe_analog) for the wafer.space chip;
    the SPI registers are then standard-cell logic in chip_core and drive the 17 controls."""
    ctl = [("SCLK", "in"), ("SDI", "in"), ("CS_N", "in")] if with_spi else [(n, "in") for n in SPI_MAP]
    pins = [("RFIN", "in"), ("REFIN", "in")] + ctl + [
            ("I_SIGN", "out"), ("I_MAG", "out"), ("Q_SIGN", "out"), ("Q_MAG", "out"),
            ("CLKOUT", "out"), ("AFCOUT", "out"), ("VCTRL", "out"), ("VDDV", "inout")] + SUP
    s = Sch(name, pins, cols=3, dx=420, dy=260,
            title="GNSS AFE (GPS L1 C/A + Galileo E1) for GF180MCU - %s" %
                  ("top level, 15 pins, on-chip NC-LNA, SPI control" if with_spi else
                   "analog hard macro (SPI registers in the digital core)"))
    if with_spi:
        s.newrow("SPI control registers")
        d = {n: n for n in SPI_MAP}
        d.update(SCLK="SCLK", SDI="SDI", CS_N="CS_N", **P)
        s.sub("spi_regs", "XSPI", d)
    s.newrow("bias + LO generation")
    s.sub("bias_gen", "XBIAS", dict(NB="nb", PB="pb", **P))
    # macro: the VCTRL pin is a monitor behind 10 kohm (isolates the pad's ~0.9 pF ESD
    # capacitance and leakage from the loop filter)
    vc = "VCTRL" if with_spi else "vctrl"
    if not with_spi:
        s.rpoly("RMON", "VCTRL", "vctrl", W="1u", L="10u")
    lo = {n: n.lower() for n in LOPH}
    # the VCO runs from its own supply pin VDDV (external low-noise LDO): supply ripple on the
    # shared VDD (SPI, ADC, dividers) would phase-modulate the LO (pushing ~45 MHz/V)
    s.sub("vco_ring4", "XVCO", dict(VCTRL=vc, B0="B0", B1="B1", NB="nb", CK="ckr", VR="vr", **lo, VDD="VDDV", VSS="VSS"))
    # reference buffer on VDDV too (next to the REFIN pad, in the VCO row)
    s.sub("refbuf", "XRB", dict(IN="REFIN", OUT="refck", VDD="VDDV", VSS="VSS"))
    s.sub("pll_core", "XPLL", dict(REFCK="refck", LO="ckr", NB="nb", PB="pb", ICP2="ICP2", VCTRL=vc,
                                   FS="fs", FB="fb", **P))
    s.newrow("RF (single-ended 50 ohm) -> noise-cancelling LNA -> I/Q mixers")
    s.sub("lna_nc", "XLNA", dict(RFIN="RFIN", PB="pb", OUTP="rfp", OUTN="rfn", **P))
    s.sub("mixer_iq", "XMIX", dict(RFP="rfp", RFN="rfn", NB="nb", IFIP="mip", IFIN="min", IFQP="mqp",
                                   IFQN="mqn", **lo, **P))
    s.sub("if_chain", "XIFI", dict(INP="mip", INN="min", G1A="IG1A", G1B="IG1B", G2A="IG2A", G2B="IG2B", G3A="IG3A", G3B="IG3B",
                                   PB="pb", OUTP="aip", OUTN="ain", **P))
    s.sub("if_chain", "XIFQ", dict(INP="mqp", INN="mqn", G1A="IG1A", G1B="IG1B", G2A="IG2A", G2B="IG2B", G3A="IG3A", G3B="IG3B",
                                   PB="pb", OUTP="aqp", OUTN="aqn", **P))
    s.newrow("2-bit ADCs (sampled at fLO/96 = 16.368 MHz), clock out, AFC DAC")
    s.sub("adc2b", "XADI", dict(INP="aip", INN="ain", CLK="fs", SIGN="I_SIGN", MAG="I_MAG", **P))
    s.sub("adc2b", "XADQ", dict(INP="aqp", INN="aqn", CLK="fs", SIGN="Q_SIGN", MAG="Q_MAG", **P))
    s.sub("inv_lo2", "XCKO1", dict(A="fs", Y="fsb", **P))
    s.sub("inv_lo2", "XCKO2", dict(A="fsb", Y="CLKOUT", **P))
    d = {"D%d" % i: "AFC%d" % i for i in range(8)}
    d.update(OUT="AFCOUT", **P)
    s.sub("afc_dac", "XAFC", d)
    s.sub("decap", "XDEC", dict(**P))
    s.save(); s.save_sym()


if __name__ == "__main__":
    inv("inv_dig", "1u", "2u")
    inv("inv_lo1", "2u", "4u", 1, 1)
    inv("inv_lo2", "6u", "12u", 2, 4)
    inv("inv_dac", "8u", "24u", 2, 4)
    nand2(); nor2(); nand3()
    tspc_dff()
    vco_core(); vco_ring4()
    bias_gen(); bias_if()
    lna_nc(); mixer_iq()
    vga(); sk_lpf("sk_lpf1", 42.6, 45.8); sk_lpf("sk_lpf2", 95.8, 23.0); if_chain()
    sa_comp(); adc2b()
    dff_r(); pfd(); cp(); loop_filter()
    selfbias_buf("refbuf", 20, "200u", "2u", "4u")
    selfbias_buf("divbuf", 12, "20u", "4u", "8u")
    div2(); div3(); div48(); pll_core()
    afc_dac(); decap()
    dffr_s(); latch_s(); spi_regs()
    top()
    top("gnss_afe_analog", with_spi=False)
    print("cells generated")
