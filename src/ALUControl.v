`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/14/2025 06:35:18 PM
// Design Name:
// Module Name: ALUControl
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

// ALUControl สำหรับการควบคุมการทำงาน ALU
module ALUControl(
    input [6:0] funct7,             // funct7 สำหรับกำหนด operation ของ R type
    input [2:0] funct3,             // funct3 สำหรับกำหนด operation ของทุก type
    input [1:0] ALU_op,             // คำสั่งจาก Control Unit

    output reg [3:0] ALU_control    // ส่งคำสั่งควบคุม ALU
  );

  always @(*)
  begin
    ALU_control = 4'b0000;
    case(ALU_op)
      2'b00: // Add เสมอ สำหรับ lw/sw
      begin
        ALU_control = 4'b0000;
      end
      2'b01: // สำหรับ branch
      begin
        case(funct3)
          3'd0: // Branch if equal
          begin
            ALU_control = 4'b0001;
          end
          3'd1: // Branch if not equal
          begin
            ALU_control = 4'b0001;
          end
          3'd4: // Branch if less than
          begin
            ALU_control = 4'b1000;
          end
          3'd5: // Branch if equal or greater than
          begin
            ALU_control = 4'b1000;
          end
          3'd6: // Branch if less than (unsigned)
          begin
            ALU_control = 4'b1001;
          end
          3'd7: // Branch if equal and greater than (unsigned)
          begin
            ALU_control = 4'b1001;
          end
          default:
          begin
            ALU_control = 4'b0001;
          end
        endcase
      end
      2'b10: // สำหรับ R-type
      begin
        case(funct3)
          3'd0: // การบวก และ การลบ
          begin
            if(funct7 == 7'd32)
            begin
              ALU_control = 4'b0001;
            end
            else
            begin
              ALU_control = 4'b0000;
            end
          end
          3'd4: // Logic Xor
          begin
            ALU_control = 4'b0010;
          end
          3'd6: // Logic Or
          begin
            ALU_control = 4'b0011;
          end
          3'd7: // Logic And
          begin
            ALU_control = 4'b0100;
          end
          3'd1: // SLL
          begin
            ALU_control = 4'b0101;
          end
          3'd5: // SRL และ SRA
          begin
            if(funct7 == 7'd32)
            begin
              ALU_control = 4'b0111;
            end
            else
            begin
              ALU_control = 4'b0110;
            end
          end
          3'd2: // STL
          begin
            ALU_control = 4'b1000;
          end
          3'd3: // STLU
          begin
            ALU_control = 4'b1001;
          end
          default:
          begin
            ALU_control = 4'b0000;
          end
        endcase
      end
      default:
      begin
        ALU_control = 4'b0000;
      end
    endcase
  end
endmodule
