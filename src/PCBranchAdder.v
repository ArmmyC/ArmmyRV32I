`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/14/2025 10:39:08 PM
// Design Name:
// Module Name: PCBranchAdder
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

// สำหรับเลื่อน address เป็น address + branchAddress
module PCBranchAdder(
    input [31:0] pc_address,        // address เก่า
    input [31:0] branch_address,    // address ที่ได้จาก Immediate B-type

    output [31:0] pc_next_address   // address ถัดไป
  );
  assign pc_next_address = pc_address + branch_address;  // address + branch_address
endmodule
