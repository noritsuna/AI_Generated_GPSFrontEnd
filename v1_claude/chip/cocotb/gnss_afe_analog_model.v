// Simulation-only stand-in for the analog hard macro (the real one is a black box): the digital
// outputs echo SPI control bits, so the register path and the pad wiring show at the output pads.
//   I_SIGN = AFC0, I_MAG = AFC1, Q_SIGN = AFC2, Q_MAG = AFC3, CLKOUT = AFC4 ^ REFIN
`default_nettype none
module gnss_afe_analog (
    `ifdef USE_POWER_PINS
    inout  wire VDDA,
    inout  wire VDDV,
    inout  wire VSS,
    `endif
    inout  wire RFIN,
    inout  wire REFIN,
    input  wire IG1A, input wire IG1B, input wire IG2A, input wire IG2B,
    input  wire IG3A, input wire IG3B, input wire B0, input wire B1,
    input  wire AFC0, input wire AFC1, input wire AFC2, input wire AFC3,
    input  wire AFC4, input wire AFC5, input wire AFC6, input wire AFC7,
    input  wire ICP2,
    input  wire BWK, input wire BWN,
    output wire I_SIGN,
    output wire I_MAG,
    output wire Q_SIGN,
    output wire Q_MAG,
    output wire CLKOUT,
    inout  wire AFCOUT,
    inout  wire VCTRL
);
    assign I_SIGN = AFC0;
    assign I_MAG  = AFC1;
    assign Q_SIGN = AFC2;
    assign Q_MAG  = AFC3;
    assign CLKOUT = AFC4 ^ (REFIN === 1'b1);
endmodule
`default_nettype wire
