`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/14/2025 09:10:11 AM
// Design Name:
// Module Name: tb_ALU
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


module tb_ALU(
  );
  reg [31:0] data1;
  reg [31:0] data2;
  reg [3:0] ALU_control;
  wire [31:0] ALU_result;
  wire Z;

  ALU alu (
        .data1 (data1),
        .data2 (data2),
        .ALU_control (ALU_control),
        .ALU_result (ALU_result),
        .Z (Z)
      );

  initial
  begin
    $dumpfile("waveform.vcd");
    $dumpvars(0,tb_ALU);
    data1 = 32'd200;
    data2 = 32'd100;
    ALU_control = 4'd0;

    repeat(10)
    begin
      #20
       ALU_control = ALU_control + 4'd1;
    end

    #20
     $finish;
  end
endmodule
