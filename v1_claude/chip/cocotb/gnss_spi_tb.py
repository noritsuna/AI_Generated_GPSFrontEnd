# SPDX-FileCopyrightText: © 2026 GNSS AFE Authors
# SPDX-License-Identifier: Apache-2.0
"""SPI control register test of chip_top, RTL or gate level (GL=1, the powered netlist of the last
LibreLane run copied to ../final). The analog macro is replaced by gnss_afe_analog_model.v, which
echoes AFC0..AFC4 on the I_SIGN / I_MAG / Q_SIGN / Q_MAG / CLKOUT outputs; all 19 control bits are
also read at the macro instance inputs.
Checks: reset values (all 0, AFC7 = 1), 24-bit mode-0 frames (MSB first, bit i -> sr[i], the low
19 bits copied on CS_N rising), no update while CS_N stays low, Q_SIGN inverted at the pad,
CS_N pull-up, the unused bidir pads as inputs, the SDO readback (ID 10101 + the control word in use,
MSB first, valid at the rising edge of SCLK, not driven while CS_N is high).
usage: python3 gnss_spi_tb.py   (env: GL=1 for gate level, SLOT=0p5x0p5)"""
import os
import random
from pathlib import Path

import cocotb
from cocotb.triggers import Timer
from cocotb_tools.runner import get_runner

gl = os.getenv("GL", False)
pdk_root = os.getenv("PDK_ROOT", Path(__file__).resolve().parent / "../gf180mcu")
pdk = os.getenv("PDK", "gf180mcuD")
scl = os.getenv("SCL", "gf180mcu_fd_sc_mcu7t5v0")
pad = os.getenv("PAD", "gf180mcu_fd_io")
sram = os.getenv("SRAM", "gf180mcu_fd_ip_sram")
slot = os.getenv("SLOT", "0p5x0p5")

NAMES = ["IG1A", "IG1B", "IG2A", "IG2B", "IG3A", "IG3B", "B0", "B1"] + ["AFC%d" % i for i in range(8)] + ["ICP2", "BWK", "BWN"]
ID = 0b10101       # fixed upper 5 bits of the readback word
INV = 1 << 17      # the macro pin BWK is the inverted register bit BWW
T = 100   # ns per SCLK half period (5 MHz)


def macro(dut):
    """the analog macro instance (RTL hierarchy, or the flattened GL netlist)"""
    for path in (("i_chip_core", "i_afe"), ("i_afe",)):
        h = dut
        try:
            for p in path:
                h = getattr(h, p)
            return h
        except AttributeError:
            continue
    raise AttributeError("analog macro instance not found")


def _gl_net(dut, name):
    """a net of the flattened GL netlist with an escaped name such as \\i_chip_core.ctl[0]"""
    for n in ("\\%s " % name, "\\%s" % name, name):
        try:
            return dut._id(n, extended=False)
        except (AttributeError, KeyError):
            continue
    raise AttributeError(name)


def ctl(dut):
    if gl:      # the macro inputs are driven by the nets i_chip_core.ctl[0..18]
        return sum(int(_gl_net(dut, "i_chip_core.ctl[%d]" % i).value) << i for i in range(len(NAMES)))
    m = macro(dut)
    return sum(int(getattr(m, n).value) << i for i, n in enumerate(NAMES)) ^ INV


async def frame(dut, word, bits=24, raise_cs=True):
    """mode 0: SDI set while SCLK is low, sampled on the rising edge; MSB first"""
    dut.input_PAD.value = 0b00           # CS_N (bit 1) low, SDI 0
    await Timer(T, "ns")
    rd = 0
    for k in reversed(range(bits)):
        b = (word >> k) & 1
        dut.input_PAD.value = b          # CS_N = 0
        await Timer(T, "ns")
        rd = (rd << 1) | int(dut.bidir_PAD.value[5])     # SDO, sampled at the rising edge
        dut.clk_PAD.value = 1
        await Timer(T, "ns")
        dut.clk_PAD.value = 0
    await Timer(T, "ns")
    if raise_cs:
        dut.input_PAD.value = 0b10
        await Timer(2 * T, "ns")
    return rd


def pads(dut):
    v = dut.bidir_PAD.value
    return [int(v[i]) for i in range(5)]        # I_SIGN I_MAG Q_SIGN(pad) Q_MAG CLKOUT


@cocotb.test()
async def test_spi(dut):
    if gl:
        for n in ("VDD", "VDDA", "VDDV", "DVDD"):
            if hasattr(dut, n):
                getattr(dut, n).value = 1
        for n in ("VSS", "DVSS"):
            if hasattr(dut, n):
                getattr(dut, n).value = 0
    dut.clk_PAD.value = 0
    dut.input_PAD.value = 0b10
    dut.analog_PAD.value = 0
    dut.rst_n_PAD.value = 0
    await Timer(500, "ns")
    assert ctl(dut) == 0x08000, "reset value %05x" % ctl(dut)
    dut.rst_n_PAD.value = 1
    await Timer(200, "ns")

    # pad wiring: I_SIGN = AFC0 ... CLKOUT = AFC4 (REFIN low), Q_SIGN inverted at the pad
    for a in range(32):
        await frame(dut, (0x1A << 19) | (a << 8))
        assert ctl(dut) == a << 8, "ctl %05x" % ctl(dut)
        e = [(a >> 0) & 1, (a >> 1) & 1, 1 - ((a >> 2) & 1), (a >> 3) & 1, (a >> 4) & 1]
        assert pads(dut) == e, "AFC %02x: pads %s, expected %s" % (a, pads(dut), e)

    # random words: only the low 19 bits land, upper 5 bits ignored
    rnd = random.Random(1)
    for _ in range(40):
        w = rnd.getrandbits(24)
        before = ctl(dut)
        rd = await frame(dut, w)
        assert rd == (ID << 19) | before, "readback %06x, expected ID + %05x" % (rd, before)
        assert ctl(dut) == w & 0x7FFFF, "word %06x -> ctl %05x" % (w, ctl(dut))
    assert str(dut.bidir_PAD.value[5]).lower() not in ("1", "x"), "SDO driven while CS_N is high"

    # a longer frame reads 0 after the 24 bits; a short one restarts at the MSB next time
    w = ctl(dut)
    rd = await frame(dut, w, bits=32)
    assert rd == ((ID << 19) | w) << 8, "32-bit readback %08x" % rd
    rd = await frame(dut, w >> 12, bits=12)
    assert rd == ((ID << 19) | w) >> 12, "12-bit readback %03x" % rd

    # no update before CS_N rises, then the last 24 bits count
    await frame(dut, 0x00ABCD)
    rd = await frame(dut, 0x012345, raise_cs=False)
    assert rd == (ID << 19) | 0x0ABCD, "readback %06x" % rd
    assert ctl(dut) == 0x0ABCD
    dut.input_PAD.value = 0b10
    await Timer(2 * T, "ns")
    assert ctl(dut) == 0x12345

    # reset in operation
    dut.rst_n_PAD.value = 0
    await Timer(200, "ns")
    assert ctl(dut) == 0x08000
    dut.rst_n_PAD.value = 1
    await Timer(200, "ns")
    rd = await frame(dut, 0x008000)
    assert rd == (ID << 19) | 0x08000, "readback after reset %06x" % rd
    dut._log.info("SPI register test passed (%s)" % ("gate level" if gl else "RTL"))


def runner():
    proj = Path(__file__).resolve().parent
    defines = {f"SLOT_{slot.upper()}": True, f"PDK_{pdk.replace('-', '_')}": True, f"SCL_{scl}": True,
               f"PAD_{pad}": True, f"SRAM_{sram}": True}
    sources = []
    if gl:
        sources.append(Path(pdk_root) / pdk / "libs.ref" / scl / "verilog" / f"{scl}.v")
        sources.append(Path(pdk_root) / pdk / "libs.ref" / scl / "verilog" / "primitives.v")
        sources.append(proj / "../final/pnl/chip_top.pnl.v")
        defines.update({"FUNCTIONAL": True, "USE_POWER_PINS": True})
    else:
        sources += [proj / "../src/chip_top.sv", proj / "../src/chip_core.sv"]
    sources += [proj / "gnss_afe_analog_model.v",
                Path(pdk_root) / pdk / f"libs.ref/{pad}/verilog/{pad}.v",
                Path(pdk_root) / pdk / f"libs.ref/{sram}/verilog/{sram}__sram512x8m8wm1.v"]
    sources += [proj / f"../ip/{ip}/vh/{ip}.v" for ip in ("gf180mcu_gnss_io", "gf180mcu_ws_ip__logo", "gf180mcu_ws_ip__marker",
                "gf180mcu_ws_ip__qrcode_id", "gf180mcu_ws_ip__shuttle_id", "gf180mcu_ws_ip__project_id")
                if (proj / f"../ip/{ip}/vh/{ip}.v").exists()]
    r = get_runner(os.getenv("SIM", "icarus"))
    r.build(sources=sources, hdl_toplevel="chip_top", defines=defines, always=True,
            includes=[proj / "../src/"], build_dir="sim_build_spi" + ("_gl" if gl else ""), waves=False)
    r.test(hdl_toplevel="chip_top", test_module="gnss_spi_tb", build_dir="sim_build_spi" + ("_gl" if gl else ""))


if __name__ == "__main__":
    runner()
