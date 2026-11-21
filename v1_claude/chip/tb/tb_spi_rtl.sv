`timescale 1ns/1ps
module tb;
  reg clk = 0, rst_n = 1;
  reg [3:0] inp = 4'b0010;      // input[1] = CS_N high
  wire [37:0] bout;
  wire [3:0] ana;
  chip_core #(.NUM_INPUT_PADS(4), .NUM_BIDIR_PADS(38), .NUM_ANALOG_PADS(4)) dut (
    .clk(clk), .rst_n(rst_n), .input_in(inp), .input_pu(), .input_pd(),
    .bidir_in(38'b0), .bidir_out(bout), .bidir_oe(), .bidir_cs(), .bidir_sl(), .bidir_ie(), .bidir_pu(), .bidir_pd(),
    .analog(ana));
  task frame(input [23:0] w); integer k; begin
    inp[1] = 0; #50;
    for (k = 23; k >= 0; k = k - 1) begin inp[0] = w[k]; #50 clk = 1; #50 clk = 0; end
    #50 inp[1] = 1; #100;
  end endtask
  initial begin
    #50 rst_n = 0; #100 rst_n = 1; #100;
    $display("POR  ctl=%05h (expect 08000)", dut.ctl);
    frame(24'h813A96);
    $display("WR1  ctl=%05h (expect 13A96)", dut.ctl);
    frame(24'h0100D5);
    $display("WR2  ctl=%05h (expect 100D5)", dut.ctl);
    $display("ADC  pads I_SIGN I_MAG Q_SIGN Q_MAG CLKOUT=%b (macro all 0, expect 00100: Q_SIGN inverted)", {bout[0],bout[1],bout[2],bout[3],bout[4]});
    $finish;
  end
endmodule
module gnss_afe_analog(inout RFIN, REFIN, input IG1A,IG1B,IG2A,IG2B,IG3A,IG3B,B0,B1,AFC0,AFC1,AFC2,AFC3,AFC4,AFC5,AFC6,AFC7,ICP2,
  output I_SIGN,I_MAG,Q_SIGN,Q_MAG,CLKOUT, inout AFCOUT, VCTRL);
  assign {I_SIGN,I_MAG,Q_SIGN,Q_MAG,CLKOUT} = 0;
endmodule
