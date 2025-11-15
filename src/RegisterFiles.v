`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/14/2025 12:26:05 AM
// Design Name:
// Module Name: RegisterFiles
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

// Register สำหรับเก็บข้อมูลแบบรวดเร็วใน single cycle
// เก็บได้สูงสุด 2^5 - 1 address
// address x0 ต้องมีค่าเป็น 0 เสมอ
module RegisterFiles(
    input clk_in,                 // สัญญาณ clock สำหรับการ write
    input reset,                  // ปุ่ม reset
    input [4:0] read_register_1,  // address ของ register 1 ที่จะอ่าน
    input [4:0] read_register_2,  // address ของ register 2 ที่จะอ่าน
    input [4:0] write_register,   // address ของ register ที่จะเขียนลงไป
    input reg_write,              // ตัวกำหนดว่าจะเขียนหรือไม่
    input [31:0] data_to_write,   // ข้อมูลที่จะเขียน

    output [31:0] read_data_1,    // ส่งออกข้อมูลที่อ่านจาก register 1
    output [31:0] read_data_2     // ส่งออกข้อมูลที่อ่านจาก register 2
  );
  reg [31:0] Register [31:0];     // สร้าง array ของ register 32bit สำหรับเก็บข้อมูล

  // ถ้าอ่าน address x0 จะให้ค่า 0
  assign read_data_1 = (read_register_1 == 5'd0) ? 32'd0 : Register[read_register_1];
  assign read_data_2 = (read_register_2 == 5'd0) ? 32'd0 : Register[read_register_2];

  integer i;

  initial
  begin
    // เขียนข้อมูลใน register ทุกช่องเป็น 0 ตอนเริ่มต้น
    for (i = 0; i<32 ; i=i+1)
    begin
      Register[i] <= 32'd0;
    end
  end

  always @(posedge clk_in or posedge reset)
  begin
    if(reset)
    begin
      // เขียนข้อมูลใน register ทุกช่องเป็น 0 ตอน reset
      for (i = 0; i<32 ; i=i+1)
      begin
        Register[i] <= 32'd0;
      end
    end
    else
    begin
      // ถ้าจะเขียน ต้องเขียนบน address ที่ไม่ใช่ x0
      if (reg_write && (write_register != 5'd0))
      begin
        Register[write_register] <= data_to_write; // เขียนข้อมูล
      end
    end
  end

endmodule
