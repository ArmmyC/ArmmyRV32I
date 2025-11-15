`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/13/2025 10:54:31 PM
// Design Name:
// Module Name: DataMemory
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

// DataMemory สำหรับเก็บข้อมูลในรูปแบบของ Ram
// ช้ากว่า Register แต่เก็บได้เยอะกว่า
module DataMemory(
    input clk_in,                 // สัญญาณ clock
    input [31:0] memory_address,  // address ของ memory
    input mem_write,              // ตัวกำหนดว่าจะเขียนหรือไม่
    input mem_read,               // ตัวกำหนดว่าจะอ่านหรือไม่
    input [31:0] data_to_write,   // ข้อมูลที่จะเขียน
    input [2:0] StoreSel,          // ตัวเลือกวิธีการ Store ตาม funct3

    output [31:0] read_data       // ส่งออกข้อมูลที่อ่าน
  );
  parameter MEMORY_SIZE = 1024;         // กำหนดขนาดของ Memory
  reg [31:0] memory [MEMORY_SIZE-1:0];  // สร้าง array ของ memory 32bit สำหรับเก็บข้อมูล

  wire [1:0] byte_half_to_store = memory_address[1:0]; // ตัวบอกว่าจะเก็บ Byte หรือ Half ตำแหน่งไหน
  reg [3:0] byte_enable_mask; // บอก byte ที่จะเขียนตาม bit 4 3 2 1

  // 1 address เก็บได้ 1 btye หรือ 8 bits
  // ดังนั้นจึงเปลี่ยนจาก address เป็น index ด้วยการหาร 4 (32bits / 4 = 1 index)
  wire [9:0] address_to_index = memory_address[11:2];

  // ถ้า อ่านข้อมูล ให้ส่งออกข้อมูลบน address นั้น ถ้าไม่ ให้ส่ง 0
  assign read_data = mem_read ? memory[address_to_index] : 32'h0;

  always @(*)
  begin
    byte_enable_mask = 4'b0000;

    if(mem_write)
    begin

      case (StoreSel)
        3'd0: // Store byte
        begin
          case (byte_half_to_store)
            2'b00: // Store byte แรก
            begin
              byte_enable_mask = 4'b0001;
            end
            2'b01: // Store byte สอง
            begin
              byte_enable_mask = 4'b0010;
            end
            2'b10: // Store byte สาม
            begin
              byte_enable_mask = 4'b0100;
            end
            2'b11: // Store byte สี่
            begin
              byte_enable_mask = 4'b1000;
            end
            default:
              byte_enable_mask = 4'b0000;
          endcase
        end
        3'd1: // Store Half
        begin
          if(byte_half_to_store[1] == 1'b0)
          begin
            byte_enable_mask = 4'b0011; // เขียน byte ที่หนึ่งและสอง
          end
          else
          begin
            byte_enable_mask = 4'b1100; // เขียน byte ที่สามและสี่
          end
        end
        3'd2: // Store Word
        begin
          byte_enable_mask = 4'b1111; // เขียนทุก byte
        end
        default:
          byte_enable_mask = 4'b0000;
      endcase
    end
  end

  // ถ้า StoreSel เป็น 0 จะเก็บ byte
  // ถ้า StoreSel เป็น 1 จะเก็บ half
  // ถ้าไม่เลย จะเก็บ word
  wire [31:0] prepared_data_to_write = (StoreSel == 3'b000) ? {4{data_to_write[7:0]}} : (StoreSel == 3'b001) ? {2{data_to_write[15:0]}} : data_to_write;

  always @(posedge clk_in)
  begin
    if (byte_enable_mask[0] == 1)
    begin
      memory[address_to_index][7:0]   <= prepared_data_to_write[7:0];
    end
    if (byte_enable_mask[1] == 1)
    begin
      memory[address_to_index][15:8]  <= prepared_data_to_write[15:8];
    end
    if (byte_enable_mask[2] == 1)
    begin
      memory[address_to_index][23:16] <= prepared_data_to_write[23:16];
    end
    if (byte_enable_mask[3] == 1)
    begin
      memory[address_to_index][31:24] <= prepared_data_to_write[31:24];
    end
  end

endmodule
