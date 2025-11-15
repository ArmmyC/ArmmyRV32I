`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/14/2025 12:20:22 AM
// Design Name:
// Module Name: PC4Adder
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

// สำหรับเลื่อน address เป็น address ถัดไป
module PC4Adder(
    input [31:0] pc_address,        // address เก่า

    output [31:0] pc_next_address   // address ถัดไป
  );
  assign pc_next_address = pc_address + 32'd4;  // address เดิม + 4
endmodule
