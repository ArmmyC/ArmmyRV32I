`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/14/2025 10:32:25 PM
// Design Name:
// Module Name: MUXPC
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

// MUX สำหรับเลือก address ถัดไปของ PC
module MUXPC(
    input [1:0] AddressSel,             // เลือกว่าจะส่ง address ไหน
    input [31:0] PCADD4,                // PC Address + 4
    input [31:0] BranchTargetAddress,   // PC + Immediate B-type
    input [31:0] ALU_result,            // rs1 + Immediate

    output [31:0] chosen_output   // ส่ง address ที่เลือก
  );

  // 00 = PCADD4 (default)
  // 01 = BranchTargetAddress
  // 10 = rs1 + Immediate
  assign chosen_output = (AddressSel == 2'b01) ? BranchTargetAddress : (AddressSel == 2'b10) ? ALU_result : PCADD4;
endmodule
