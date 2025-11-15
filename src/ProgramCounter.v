`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/13/2025 08:31:27 PM
// Design Name:
// Module Name: ProgramCounter
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

// Program counter สำหรับส่ง address ของ instruction
module ProgramCounter(
    input clk_in,                   // สัญญาณ clock จาก clockDivider
    input reset,                    // ปุ่ม reset
    input [31:0] pc_next_address,   // รับ address ถัดไป

    output reg [31:0] pc_out_address    // ส่ง address ออกไป
  );

  always @(posedge clk_in or posedge reset)
  begin
    if(reset)
    begin
      pc_out_address <= 32'd0;          // reset เป็น address แรกสุด
    end
    else
    begin
      pc_out_address <= pc_next_address;  // ส่ง address ออก
    end
  end
endmodule
