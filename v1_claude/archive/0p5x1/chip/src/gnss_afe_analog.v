// Black-box view of the analog hard macro (layout: layout/gds/gnss_afe_analog.gds).
`default_nettype none
(* blackbox *)
module gnss_afe_analog (
    `ifdef USE_POWER_PINS
    inout  wire VDDA,       // analog supply (named VDDA so that the global VDD hook leaves it alone)
    inout  wire VDDV,       // VCO supply (own pad, external low-noise LDO)
    inout  wire VSS,
    `endif
    inout  wire RFIN,
    inout  wire REFIN,
    input  wire IG1A, input wire IG1B, input wire IG2A, input wire IG2B,
    input  wire IG3A, input wire IG3B, input wire B0, input wire B1,
    input  wire AFC0, input wire AFC1, input wire AFC2, input wire AFC3,
    input  wire AFC4, input wire AFC5, input wire AFC6, input wire AFC7,
    input  wire ICP2,
    output wire I_SIGN,
    output wire I_MAG,
    output wire Q_SIGN,
    output wire Q_MAG,
    output wire CLKOUT,
    inout  wire AFCOUT,
    inout  wire VCTRL
);
endmodule
`default_nettype wire
