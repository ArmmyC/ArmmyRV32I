`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/15/2025 12:30:22 PM
// Design Name:
// Module Name: tb_RV32I_Core
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module tb_RV32I_Core;
  reg clk;
  reg reset;

  RV32I_Core core (
               .clk_in(clk),
               .reset(reset)
             );

  initial
  begin
    clk = 1'b0;
  end
  always #5 clk = ~clk;

  initial
  begin
    $dumpfile("waveform.vcd");
    $dumpvars(0, tb_RV32I_Core);

    reset = 1'b1;
    #50;
    reset = 1'b0;

    #2000000;
    $finish;
  end
endmodule
