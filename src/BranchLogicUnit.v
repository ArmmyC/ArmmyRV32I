`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/14/2025 10:42:33 PM
// Design Name:
// Module Name: BranchLogicUnit
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

// BranchLogicUnit ควบคุม operation ระหว่าง Zero กับ branch
module BranchLogicUnit(
    input zero,             // Zero จาก ALU
    input ALU_result,       // ALU_result แค่ lSB
    input [2:0] BranchSel,  // กำหนดการทำงานของ branch จาก funct3

    output reg result
  );

  always @(*)
  begin
    result = 1'b0;
    case(BranchSel)
      3'd0: // Branch if equal
      begin
        result = zero;
      end
      3'd1: // Branch if not equal
      begin
        result = (~zero) ;
      end
      3'd4: // Branch if less than
      begin
        result =ALU_result;
      end
      3'd5: // Branch if equal or greater than
      begin
        result = (~ALU_result);
      end
      3'd6: // Branch if less than (unsigned)
      begin
        result = ALU_result;
      end
      3'd7: // Branch if equal and greater than (unsigned)
      begin
        result = (~ALU_result);
      end
      default:
      begin
        result = 1'b0;
      end
    endcase
  end
endmodule
