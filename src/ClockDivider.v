`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/13/2025 04:37:53 PM
// Design Name:
// Module Name: ClockDivider
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

// Clock divder สำหรับการทำให้สัญญาณ clock ช้าลง
// จาก 100M Hz ของตัวบอร์ด เป็น 1M Hz
module ClockDivider(
    input clk_in,             // สัญญาณ clock เข้า 100M Hz
    input reset,              // ปุ่ม reset
    output reg clk_out_1mhz   // สัญญาณ clock ออก
  );

  // หาได้จาก 100M / (1M * 2)
  // -1 เนื่องจาก การนับเริ่มที่ 0
  parameter MAX_COUNT_1MHZ = 50 - 1;

  reg [5:0] counter_1mhz;     // ตัวแปรสำหรับการนับ 0-49 ซึ๋งอยู่ในขอบเขต 6 bits

  always @(posedge clk_in)
  begin
    if (reset)
    begin
      counter_1mhz <= 6'd0;
      clk_out_1mhz <= 1'b0;
    end
    else
    begin
      if (counter_1mhz == MAX_COUNT_1MHZ)
      begin
        // ถ้านับจนครบแล้วให้ สลับสัญญาณของ clock แล้ว เริ่มนับใหม่
        clk_out_1mhz <= ~clk_out_1mhz;
        counter_1mhz <= 6'd0;
      end
      else
      begin
        counter_1mhz <= counter_1mhz + 1'b1;   // เพิ่มนับที่ละ 1
      end
    end
  end

endmodule
