`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/14/2025 09:18:21 PM
// Design Name:
// Module Name: MUXRegisterWrite
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

// MUX สำหรับก่อนส่งไป write Register
module MUXRegisterWrite(
    input [1:0] RegSel,                 // เลือกว่าจะส่งข้อมูลชุดไหนไป
    input [31:0] ALU_result,            // ข้อมูลจาก ALU ทั่วไป R-type
    input [31:0] LoadExtender_result,   // ข้อมูลจาก LoadExtender I-type (Load)
    input [31:0] PCADD4_result,         // ข้อมูล PC + 4
    input [31:0] ImmExtender_result,    // ข้อมูลจาก ImmExtender U-type

    output [31:0] chosen_output         // ส่ง output ที่ถูกเลือก
  );

  // 00 = ALU_result (default)
  // 01 = LoadExtender_result
  // 10 = PC + 4
  // 11 = ImmExtender_result
  assign chosen_output = (RegSel == 2'b01) ? LoadExtender_result : (RegSel == 2'b10) ? PCADD4_result : (RegSel == 2'b11) ? ImmExtender_result : ALU_result;
endmodule
