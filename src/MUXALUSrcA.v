`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/14/2025 09:32:57 PM
// Design Name:
// Module Name: MUXALUSrcA
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

// MUX สำหรับเลือกข้อมูลที่จะส่งเข้า ALU ช่องที่ 1
module MUXALUSrcA(
    input SrcASel,                // เลือกว่าจะส่งข้อมูลไหน
    input [31:0] PC,              // PC Address
    input [31:0] Register1,       // ข้อมูลจาก Register1

    output [31:0] chosen_output   // ส่งข้อมูลที่เลือกออก
  );

  // 0 = Register1 (default)
  // 1 = PC
  assign chosen_output = (SrcASel == 1'b1) ? PC : Register1;
endmodule
