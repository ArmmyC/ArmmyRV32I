`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/13/2025 05:23:14 PM
// Design Name:
// Module Name: ALU
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

// Arithmetic Logic Unit
// สำหรับการคิดคำนวณ operation ต่างๆที่จำเป็น
module ALU(
    input [31:0] data1,             // ข้อมูล 1
    input [31:0] data2,             // ข้อมูล 2
    input [3:0] ALU_control,        // สัญญาณควบคุม
    output reg [31:0] ALU_result,   // ข้อมูลผลลัพธ์
    output reg Z                    // Zero สำหรับการที่ผลลัพธ์เป็น 0
  );

  always @(*)
  begin
    ALU_result = 32'b0;     // ค่าเริ่มต้น
    case(ALU_control)
      4'b0000:    // การบวก
      begin
        ALU_result = data1 + data2;
      end
      4'b0001:    // การลบ
      begin
        ALU_result = data1 - data2;
      end
      4'b0010:    // Logic Xor
      begin
        ALU_result = data1 ^ data2;
      end
      4'b0011:    // Logic Or
      begin
        ALU_result = data1 | data2;
      end
      4'b0100:    // Logic And
      begin
        ALU_result = data1 & data2;
      end
      4'b0101:
      begin       // SLL เลื่อนไปทางซ้าย ตาม offset ของ ข้อมูล 2
        ALU_result = data1 << data2[4:0];
      end
      4'b0110:
      begin       // SRL เลื่อนไปทางขวา ตาม offset ของ ข้อมูล 2
        ALU_result = data1 >> data2[4:0];
      end
      4'b0111:
      begin       // SRA เลื่อนไปทางขวา ตาม offset ของ ข้อมูล 2 แบบ Arithmetic หรือคงค่า MSB ไว้
        ALU_result = ($signed(data1)) >>> data2[4:0];
      end
      4'b1000:    // SLT เช็คน้อยกว่า แบบ signed
      begin
        ALU_result = ($signed(data1) < $signed(data2))  ? 32'd1 : 32'd0;
      end
      4'b1001:    // SLTU เช็คน้อยกว่าแบบ unsigned
      begin
        ALU_result = data1 < data2  ? 32'd1 : 32'd0;
      end
      default:    // ค่า default
      begin
        ALU_result = 32'b0;
      end
    endcase
    Z = (ALU_result == 32'd0) ? 1 : 0;    // Zero บอกว่า ผลลัพธ์เป็น 0 หรือไม่
  end
endmodule
