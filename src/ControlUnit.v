`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/14/2025 09:23:17 AM
// Design Name:
// Module Name: ControlUnit
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

// Control Unit สำหรับควบคุมการทำงานต่างๆ ด้วย Opcode จาก Instruction
module ControlUnit(
    input [6:0] Op_code,          // Opcode จากชุดคำสั่ง
    input branch_condition_met,   // เช็คว่า เงื่อนไข branch เป็นจริงไหม

    output reg branch,            // ทำ branch หรือไม่
    output reg mem_read,          // อ่าน memory หรือไม่
    output reg mem_write,         // เขียน memory หรือไม่
    output reg reg_write,         // เขียน register หรือไม่

    // register1 (0) หรือ PC (1)
    output reg ALUSrcA,           // เลือกว่าจะส่งข้อมูลไหนไป ALU 1
    // register2 (0) หรือ immediate (1)
    output reg useImm,            // เลือกว่าจะส่งข้อมูลไหนไป ALU 2

    // 00 : AlU Result
    // 01 : Read Memory
    // 10 : PC+4
    // 11 : Immediate U-type
    output reg [1:0] to_reg_src,  // เลือก ข้อมูลที่จะส่งไปยัง register

    // 00 : Add เสมอ สำหรับ lw/sw
    // 01 : สำหรับ branch
    // 10 : สำหรับ R-type
    output reg [1:0] ALU_op,      // กำหนดการทำงานของ ALU

    // 000 : R-type หรือ defualt case
    // 001 : I-type
    // 010 : S-type
    // 011 : B-type
    // 100 : U-type
    // 101 : J-type
    output reg [2:0] ImmSel,      // เลือกรูปแบบของ Imm ที่จะใช้

    // 00 : PC + 4
    // 01 : PC + Immediate
    // 10 : ALU result
    output reg [1:0] PCSel        // เลือกข้อมูลที่จะส่งเข้า PC

  );
  always @(*)
  begin
    branch = 1'b0;
    mem_read = 1'b0;
    mem_write = 1'b0;
    reg_write = 1'b0;
    ALUSrcA = 1'b0;
    useImm = 1'b0;
    to_reg_src = 2'b00;
    ALU_op = 2'b00;
    ImmSel = 3'b000;
    PCSel = 2'b00;
    case(Op_code)
      7'b0110011: // สำหรับการทำ R-type (Register-Register)
      begin
        branch = 1'b0;
        mem_read = 1'b0;
        mem_write = 1'b0;
        reg_write = 1'b1;
        ALUSrcA = 1'b0;
        useImm = 1'b0;
        to_reg_src = 2'b00;
        ALU_op = 2'b10;
        ImmSel = 3'b000;
        PCSel = 2'b00;
      end
      7'b0010011: // สำหรับการทำ I-type (Register-Immediate) (arithmetic)
      begin
        branch = 1'b0;
        mem_read = 1'b0;
        mem_write = 1'b0;
        reg_write = 1'b1;
        ALUSrcA = 1'b0;
        useImm = 1'b1;
        to_reg_src = 2'b00;
        ALU_op = 2'b10;
        ImmSel = 3'b001;
        PCSel = 2'b00;
      end
      7'b0000011: // สำหรับการทำ I-type (Register-Immediate) (load)
      begin
        branch = 1'b0;
        mem_read = 1'b1;
        mem_write = 1'b0;
        reg_write = 1'b1;
        ALUSrcA = 1'b0;
        useImm = 1'b1;
        to_reg_src = 2'b01;
        ALU_op = 2'b00;
        ImmSel = 3'b001;
        PCSel = 2'b00;
      end
      7'b0100011: // สำหรับการทำ S-type (Store)
      begin
        branch = 1'b0;
        mem_read = 1'b0;
        mem_write = 1'b1;
        reg_write = 1'b0;
        ALUSrcA = 1'b0;
        useImm = 1'b1;
        to_reg_src = 2'b00;
        ALU_op = 2'b00;
        ImmSel = 3'b010;
        PCSel = 2'b00;
      end
      7'b1100011: // สำหรับการทำ B-type (Branch)
      begin
        branch = 1'b1;
        mem_read = 1'b0;
        mem_write = 1'b0;
        reg_write = 1'b0;
        ALUSrcA = 1'b0;
        useImm = 1'b0;
        to_reg_src = 2'b00;
        ALU_op = 2'b01;
        ImmSel = 3'b011;
        if (branch_condition_met)
        begin
          PCSel = 2'b01;
        end
        else
        begin
          PCSel = 2'b00;
        end
      end
      7'b1101111: // สำหรับการทำ J-type (JAL)
      begin
        branch = 1'b0;
        mem_read = 1'b0;
        mem_write = 1'b0;
        reg_write = 1'b1;
        ALUSrcA = 1'b0;
        useImm = 1'b0;
        to_reg_src = 2'b10;
        ALU_op = 2'b00;
        ImmSel = 3'b101;
        PCSel = 2'b01;
      end
      7'b1100111: // สำหรับการทำ J-type (JALR)
      begin
        branch = 1'b0;
        mem_read = 1'b0;
        mem_write = 1'b0;
        reg_write = 1'b1;
        ALUSrcA = 1'b0;
        useImm = 1'b1;
        to_reg_src = 2'b10;
        ALU_op = 2'b00;
        ImmSel = 3'b001;
        PCSel = 2'b10;
      end
      7'b0110111: // สำหรับการทำ U-type (LUI)
      begin
        branch = 1'b0;
        mem_read = 1'b0;
        mem_write = 1'b0;
        reg_write = 1'b1;
        ALUSrcA = 1'b0;
        useImm = 1'b1;
        to_reg_src = 2'b11;
        ALU_op = 2'b00;
        ImmSel = 3'b100;
        PCSel = 2'b00;
      end
      7'b0010111: // สำหรับการทำ U-type (AUIPC)
      begin
        branch = 1'b0;
        mem_read = 1'b0;
        mem_write = 1'b0;
        reg_write = 1'b1;
        ALUSrcA = 1'b1;
        useImm = 1'b1;
        to_reg_src = 2'b00;
        ALU_op = 2'b00;
        ImmSel = 3'b100;
        PCSel = 2'b00;
      end
      default:
      begin
        branch = 1'b0;
        mem_read = 1'b0;
        mem_write = 1'b0;
        reg_write = 1'b0;
        ALUSrcA = 1'b0;
        useImm = 1'b0;
        to_reg_src = 2'b00;
        ALU_op = 2'b00;
        ImmSel = 3'b000;
        PCSel = 2'b00;
      end
    endcase
  end

endmodule
