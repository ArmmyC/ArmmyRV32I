`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/14/2025 07:54:26 PM
// Design Name:
// Module Name: LoadExtender
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

// LoadExtender ทำหน้าที่ extend ข้อมูลที่ได้จากการ Load
module LoadExtender(
    input [31:0] read_data,                 // ข้อมูล จาก memory
    input [2:0] LoadSel,                    // ตัวเลือกวิธีการ Load ตาม funct3
    input [1:0] ALU_result,                 // 2 bit สุดท้าย สำหรับบอกตำแหน่งของ byte/half

    output reg [31:0] load_data_extended    // ส่งออกข้อมูลหลังจากที่ทำการ extend แล้ว
  );

  always @(*)
  begin
    load_data_extended = 32'd0;
    case(LoadSel)
      3'd0: // Load Byte
      begin
        case(ALU_result)
          2'b00: // load byte แรก
          begin
            load_data_extended = {{24{read_data[7]}},read_data[7:0]};
          end
          2'b01: // load byte สอง
          begin
            load_data_extended = {{24{read_data[15]}},read_data[15:8]};
          end
          2'b10: // load byte สาม
          begin
            load_data_extended = {{24{read_data[23]}},read_data[23:16]};
          end
          2'b11: // load byte สี่
          begin
            load_data_extended = {{24{read_data[31]}},read_data[31:24]};
          end
          default:
          begin
            load_data_extended = 32'd0;
          end
        endcase
      end
      3'd1: // Load Half
      begin
        if(ALU_result[1] == 1'b0) // Load Half แรก สำหรับ 00,01
        begin
          load_data_extended = {{16{read_data[15]}},read_data[15:0]};
        end
        else // Load Half สอง สำหรับ 10,11
        begin
          load_data_extended = {{16{read_data[31]}},read_data[31:16]};
        end
      end
      3'd2: // Load Word
      begin
        load_data_extended = read_data[31:0];
      end
      3'd4: // Load Byte Unsigned
      begin
        case(ALU_result)
          2'b00: // load byte แรก
          begin
            load_data_extended = {{24{1'b0}},read_data[7:0]};
          end
          2'b01: // load byte สอง
          begin
            load_data_extended = {{24{1'b0}},read_data[15:8]};
          end
          2'b10: // load byte สาม
          begin
            load_data_extended = {{24{1'b0}},read_data[23:16]};
          end
          2'b11: // load byte สี่
          begin
            load_data_extended = {{24{1'b0}},read_data[31:24]};
          end
          default:
          begin
            load_data_extended = 32'd0;
          end
        endcase
      end
      3'd5: // Load Half Unsigned
      begin
        if(ALU_result[1] == 1'b0) // Load Half แรก สำหรับ 00,01
        begin
          load_data_extended = {{16{1'b0}},read_data[15:0]};
        end
        else // Load Half สอง สำหรับ 10,11
        begin
          load_data_extended = {{16{1'b0}},read_data[31:16]};
        end
      end
      default:
      begin
        load_data_extended = 32'd0;
      end
    endcase
  end
endmodule
