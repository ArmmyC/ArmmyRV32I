`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/13/2025 10:50:56 PM
// Design Name:
// Module Name: tb_InstructionMemory
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


module tb_InstructionMemory;

  reg  [31:0] instruction_address;
  wire [31:0] instruction;

  InstructionMemory IM (
                      .instruction_address (instruction_address),
                      .instruction (instruction)
                    );

  initial
  begin
    $dumpfile("InstructionMemory.vcd");
    $dumpvars(0, tb_InstructionMemory);

    instruction_address = 0;

    repeat(10)
    begin
      #20;
      instruction_address = instruction_address + 4;
    end

    #20;
    $finish;
  end

endmodule

