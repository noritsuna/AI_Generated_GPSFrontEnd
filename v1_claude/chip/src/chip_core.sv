// SPDX-FileCopyrightText: © 2026 GNSS AFE Authors
// SPDX-License-Identifier: Apache-2.0
//
// GNSS AFE (GPS L1 C/A + Galileo E1) - digital core for the wafer.space gf180mcu template.
//
//   * SPI control registers (standard cells), behaviour identical to the transistor-level
//     spi_regs of the schematic: 24-bit frame, mode 0, MSB first; bit i of the frame lands in
//     sr[i] (sr[0] = last bit sent).  On the rising edge of CS_N the low 19 bits are copied to
//     the control outputs.  Reset (rst_n pad): all 0 except AFC7 = 1 (AFC DAC mid-scale).
//   * SPI readback (SDO): while CS_N is low, SDO shifts out {ID 10101, ctl[18:0]} MSB first, i.e.
//     the control word in use (written by the previous frame), in the same frame that writes the
//     next one.  SDO changes on the falling edge of SCLK (sample it on the rising edge, mode 0)
//     and is high-Z (pad pull-down) while CS_N is high.
//   * gnss_afe_analog: the analog hard macro (LNA, mixers, VCO/PLL, IF chains, ADCs, AFC DAC).
//
// Pad usage (the 56 pads stay at the bond positions of the slot template; chip_top.sv, slot yaml)
//   clk_PAD        SCLK
//   input_PAD[0]   SDI          input_PAD[1]  CS_N
//   bidir_PAD[0]   I_SIGN       bidir_PAD[1]  I_MAG
//   bidir_PAD[2]   Q_SIGN       bidir_PAD[3]  Q_MAG
//                  Q_SIGN is the macro's Q_SIGN inverted, so I + jQ at the pads has the GNSS
//                  signal at +fIF (the macro's own Q leads I by 90 deg = inverted spectrum).
//   bidir_PAD[4]   CLKOUT (16.368 MHz)
//   bidir_PAD[5]   SDO (SPI readback, driven while CS_N is low)
//   rf_PAD         RFIN (50 ohm) in the analog pad block: VDDV | VSS VDDA VSS RF VSS (G-S-G)
//   analog_PAD[2]  VCTRL monitor (10 kohm on-chip series resistor)
//   analog_PAD[1]  AFCOUT (TCXO pull)     analog_PAD[0] REFIN (TCXO 16.368 MHz, AC coupled)
//   nc_PAD[28:0]   unused pads (analog pad cells without a core connection; chip_top.sv)

`default_nettype none

module chip_core #(
    parameter NUM_INPUT_PADS,
    parameter NUM_BIDIR_PADS,
    parameter NUM_ANALOG_PADS
    )(
    `ifdef USE_POWER_PINS
    inout  wire VDD,
    inout  wire VSS,
    inout  wire VDDA,      // analog supply (VDDA pads)
    inout  wire VDDV,      // VCO supply (VDDV pad)
    `endif

    input  wire clk,       // SCLK
    input  wire rst_n,     // reset (active low)

    input  wire [NUM_INPUT_PADS-1:0] input_in,
    output wire [NUM_INPUT_PADS-1:0] input_pu,
    output wire [NUM_INPUT_PADS-1:0] input_pd,

    input  wire [NUM_BIDIR_PADS-1:0] bidir_in,
    output wire [NUM_BIDIR_PADS-1:0] bidir_out,
    output wire [NUM_BIDIR_PADS-1:0] bidir_oe,
    output wire [NUM_BIDIR_PADS-1:0] bidir_cs,
    output wire [NUM_BIDIR_PADS-1:0] bidir_sl,
    output wire [NUM_BIDIR_PADS-1:0] bidir_ie,
    output wire [NUM_BIDIR_PADS-1:0] bidir_pu,
    output wire [NUM_BIDIR_PADS-1:0] bidir_pd,

    inout  wire [NUM_ANALOG_PADS-1:0] analog,
    inout  wire rfin                       // RF input (analog pad block)
);

    // ------------------------------------------------------------ pads
    // inputs: CS_N pulled up so that an open pin keeps the registers latched
    assign input_pu = 2'b10;
    assign input_pd = 2'b00;

    // bidir[4:0] are outputs, bidir[5] is SDO (driven while CS_N is low)
    localparam NOUT = 5;
    wire sdo, sdo_oe;
    assign bidir_oe = {{(NUM_BIDIR_PADS-NOUT-1){1'b0}}, sdo_oe, {NOUT{1'b1}}};
    assign bidir_cs = '0;
    assign bidir_sl = {{(NUM_BIDIR_PADS-NOUT-1){1'b0}}, {(NOUT+1){1'b1}}};   // outputs with slow slew (less ground bounce)
    // SDO pad: input buffer off and pull-down always on (constants, so that only OE follows CS_N)
    assign bidir_ie = {{(NUM_BIDIR_PADS-NOUT-1){1'b1}}, {(NOUT+1){1'b0}}};
    assign bidir_pu = '0;
    assign bidir_pd = {{(NUM_BIDIR_PADS-NOUT){1'b1}}, {NOUT{1'b0}}};

    logic _unused;
    assign _unused = &{bidir_in};

    wire sdi  = input_in[0];
    wire cs_n = input_in[1];

    // ------------------------------------------------------------ SPI registers
    logic [23:0] sr;          // shift stages
    logic [18:0] ctl;         // IG1A IG1B IG2A IG2B IG3A IG3B B0 B1 AFC0..7 ICP2 BWW BWN

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            sr <= '0;
        else if (!cs_n)
            sr <= {sr[22:0], sdi};
    end

    always_ff @(posedge cs_n or negedge rst_n) begin
        if (!rst_n)
            ctl <= 19'h0_8000;    // AFC7 = 1
        else
            ctl <= sr[18:0];
    end

    // readback: bit counter cleared while CS_N is high, advanced on the falling edge of SCLK
    localparam logic [4:0] ID = 5'b10101;
    wire  [23:0] rd = {ID, ctl};
    logic [4:0]  cnt;
    wire         cnt_rst_n = rst_n & ~cs_n;

    always_ff @(negedge clk or negedge cnt_rst_n) begin
        if (!cnt_rst_n)
            cnt <= '0;
        else if (cnt != 5'd24)
            cnt <= cnt + 5'd1;
    end

    assign sdo    = (cnt < 5'd24) ? rd[5'd23 - cnt] : 1'b0;
    assign sdo_oe = ~cs_n;

    // ------------------------------------------------------------ analog macro
    wire i_sign, i_mag, q_sign, q_mag, clkout;

    gnss_afe_analog i_afe (
        `ifdef USE_POWER_PINS
        .VDDA   (VDDA),
        .VDDV   (VDDV),
        .VSS    (VSS),
        `endif
        .RFIN   (rfin),
        .REFIN  (analog[0]),
        .IG1A   (ctl[0]),  .IG1B (ctl[1]),
        .IG2A   (ctl[2]),  .IG2B (ctl[3]),
        .IG3A   (ctl[4]),  .IG3B (ctl[5]),
        .B0     (ctl[6]),  .B1   (ctl[7]),
        .AFC0   (ctl[8]),  .AFC1 (ctl[9]),  .AFC2 (ctl[10]), .AFC3 (ctl[11]),
        .AFC4   (ctl[12]), .AFC5 (ctl[13]), .AFC6 (ctl[14]), .AFC7 (ctl[15]),
        .ICP2   (ctl[16]),
        .BWK    (~ctl[17]), .BWN (ctl[18]),      // BWK = not BWW (IF filter: 0 = wider)
        .I_SIGN (i_sign),
        .I_MAG  (i_mag),
        .Q_SIGN (q_sign),
        .Q_MAG  (q_mag),
        .CLKOUT (clkout),
        .AFCOUT (analog[1]),
        .VCTRL  (analog[2])
    );

    assign bidir_out = {{(NUM_BIDIR_PADS-NOUT-1){1'b0}}, sdo, clkout, q_mag, ~q_sign, i_mag, i_sign};

endmodule

`default_nettype wire
