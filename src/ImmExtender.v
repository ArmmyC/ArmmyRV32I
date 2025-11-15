`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/14/2025 04:37:30 PM
// Design Name:
// Module Name: ImmExtender
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

// ImmExtender สำหรับการจัดการ Immediate ของ type ต่างๆ
module ImmExtender(
    input [31:0] instruction,           // รับชุดคำสั่งทั้งหมด
    input [2:0] ImmSel,                 // รับสัญญาณ Control รูปแบบ

    output reg [31:0] imm_extended_out  // ส่งค่า 32-bit ที่ถูก extend แล้ว
  );

  always @(*)
  begin
    imm_extended_out = 32'd0; // ค่าเริ่มต้น

    case(ImmSel)
      3'b001: // I-type
      begin
        // ต่อบิต [31:20] และ sign-extend
        imm_extended_out = {{20{instruction[31]}}, instruction[31:20]};
      end
      3'b010: // S-type
      begin
        // ต่อบิต [31:25] กับ [11:7] และ sign-extend
        imm_extended_out = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
      end
      3'b011: // B-type
      begin
        // ต่อบิต [31], [7], [30:25], [11:8] และ sign-extend
        // เติม 0 เข้าท้ายให้กลายเป็นเลขคู่
        imm_extended_out = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
      end
      3'b100: // U-type
      begin
        // ต่อบิต [31:12] และ 0 12บิต
        imm_extended_out = {instruction[31:12], {12{1'b0}}};
      end
      3'b101: // J-type
      begin
        // ต่อบิต [31], [19:12], [20], [30:21] และ signed extend
        // เติม 0 เข้าท้ายให้กลายเป็นเลขคู่
        imm_extended_out = {{11{instruction[31]}}, instruction[31],instruction[19:12],instruction[20],instruction[30:21], 1'b0};
      end
      default: // เคส default
      begin
        imm_extended_out = 32'd0;
      end
    endcase
  end
endmodule
