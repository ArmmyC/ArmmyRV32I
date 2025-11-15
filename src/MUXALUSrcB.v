`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/14/2025 09:42:50 PM
// Design Name:
// Module Name: MUXALUSrcB
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


// MUX สำหรับเลือกข้อมูลที่จะส่งเข้า ALU ช่องที่ 2
module MUXALUSrcB(
    input SrcBSel,                // เลือกว่าจะส่งข้อมูลไหน
    input [31:0] Immediate,       // Immediate
    input [31:0] Register2,       // ข้อมูลจาก Register2

    output [31:0] chosen_output   // ส่งข้อมูลที่เลือกออก
  );

  // 0 = Register2 (default)
  // 1 = Immediate
  assign chosen_output = (SrcBSel == 1'b1) ? Immediate : Register2;
endmodule
