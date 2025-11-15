`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/13/2025 09:01:33 PM
// Design Name:
// Module Name: InstructionMemory
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

// Memory สำหรับเก็บ Instruction ที่ได้จากภาษา C
// C --complie--> Assembly --Assemble-> Machine Code -> เข้ามาเก็บใน InstructionMemory
module InstructionMemory(
    input [31:0] instruction_address,     // address ของ instruction

    output [31:0] instruction             // คำสั่งตรง address นั้นๆ
  );

  parameter MEMORY_SIZE = 1024;           // กำหนดจำนวนของ memory
  reg [31:0] memory [MEMORY_SIZE-1:0];    // สร้าง array ของ memory 32 bits สำหรับเก็บข้อมูล

  // 1 address เก็บได้ 1 btye หรือ 8 bits
  // ดังนั้นจึงเปลี่ยนจาก address เป็น index ด้วยการหาร 4 (32bits / 4 = 1 index)
  wire [9:0] address_to_index = instruction_address[11:2];

  initial
  begin
    // อ่านไฟล์ machine code มาเก็บใน instructionMemory
    $readmemh("C:/Users/USER/Desktop/ArmWorkSpace/__CPE222/Vivado/SoCProject/SoCProject.srcs/sources_1/new/instruction.mem", memory);
  end

  assign instruction = memory[address_to_index];  // ส่งคำสั่งออกไป

endmodule
