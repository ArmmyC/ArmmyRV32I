`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11/15/2025 01:30:42 AM
// Design Name:
// Module Name: RV32I_Core
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


module RV32I_Core(
    input clk_in,
    input reset
  );

  // ClockDivider
  wire clk_1mhz;

  // ProgramCounter
  wire [31:0] pc_address;

  // Instruction Decoder
  wire [31:0] instruction;
  wire [4:0] rs1;
  wire [4:0] rs2;
  wire [4:0] rd;
  wire [6:0] Op_code;
  wire [2:0] funct3;
  wire [6:0] funct7;
  assign rs1 = instruction[19:15];
  assign rs2 = instruction[24:20];
  assign rd = instruction[11:7];
  assign Op_code = instruction[6:0];
  assign funct3 = instruction[14:12];
  assign funct7 = instruction[31:25];

  // Control Unit
  wire branch;
  wire mem_read;
  wire mem_write;
  wire reg_write;
  wire ALUSrcA;
  wire useImm;
  wire [1:0] to_reg_src;
  wire [1:0] ALU_op;
  wire [2:0] ImmSel;
  wire [1:0] PCSel;

  // BranchLogicUnit
  wire alu_result_1bit;
  assign alu_result_1bit = ALU_result[0];
  wire branch_condition_met;

  // Register Files
  wire [31:0] read_data_1;
  wire [31:0] read_data_2;

  // ALUControl
  wire [3:0] ALU_control;

  // ALU
  wire [31:0] ALU_result;
  wire Z;

  // ImmExtender
  wire [31:0] imm_extended_out;

  // DataMemory
  wire [31:0] read_data_memory;

  // LoadExtender
  wire [1:0] alu_result_2bit;
  assign alu_result_2bit = ALU_result[1:0];
  wire [31:0] load_data_extended;

  // PC4Adder
  wire [31:0] pc_plus_4;

  // PC4Adder
  wire [31:0] pc_plus_branch;

  // MUXRegisterWrite
  wire [31:0] data_to_write_reg;

  // MUXALUSrcA
  wire [31:0] SrcA_chosen_data;

  // MUXALUSrcB
  wire [31:0] SrcB_chosen_data;

  // MUXPC
  wire [31:0] PC_chosen_address;



  ClockDivider clk_div (
                 .clk_in(clk_in),
                 .reset(reset),
                 .clk_out_1mhz(clk_1mhz)
               );

  ProgramCounter pc (
                   .clk_in(clk_1mhz),
                   .reset(reset),
                   .pc_next_address(PC_chosen_address),
                   .pc_out_address(pc_address)
                 );

  InstructionMemory im (
                      .instruction_address(pc_address),
                      .instruction(instruction)
                    );

  RegisterFiles regs (
                  .clk_in(clk_1mhz),
                  .reset(reset),
                  .read_register_1(rs1),
                  .read_register_2(rs2),
                  .write_register(rd),
                  .reg_write(reg_write),
                  .data_to_write(data_to_write_reg),
                  .read_data_1(read_data_1),
                  .read_data_2(read_data_2)
                );

  ControlUnit cu (
                .Op_code(Op_code),
                .branch_condition_met(branch_condition_met),
                .branch(branch),
                .mem_read(mem_read),
                .mem_write(mem_write),
                .reg_write(reg_write),
                .ALUSrcA(ALUSrcA),
                .useImm(useImm),
                .to_reg_src(to_reg_src),
                .ALU_op(ALU_op),
                .ImmSel(ImmSel),
                .PCSel(PCSel)
              );

  BranchLogicUnit blu(
                    .zero(Z),
                    .ALU_result(alu_result_1bit),
                    .BranchSel(funct3),
                    .result(branch_condition_met)
                  );

  ALUControl aluc (
               .funct7(funct7),
               .funct3(funct3),
               .ALU_op(ALU_op),
               .ALU_control(ALU_control)
             );

  ALU alu (
        .data1(SrcA_chosen_data),
        .data2(SrcB_chosen_data),
        .ALU_control(ALU_control),
        .ALU_result(ALU_result),
        .Z(Z)
      );

  ImmExtender imm_x (
                .instruction(instruction),
                .ImmSel(ImmSel),
                .imm_extended_out(imm_extended_out)
              );

  DataMemory dm (
               .clk_in(clk_1mhz),
               .memory_address(ALU_result),
               .mem_read(mem_read),
               .mem_write(mem_write),
               .data_to_write(read_data_2),
               .StoreSel(funct3),
               .read_data(read_data_memory)
             );

  LoadExtender load_x (
                 .read_data(read_data_memory),
                 .LoadSel(funct3),
                 .ALU_result(alu_result_2bit),
                 .load_data_extended(load_data_extended)
               );

  PC4Adder adder_4_pc(
             .pc_address(pc_address),
             .pc_next_address(pc_plus_4)
           );

  PCBranchAdder adder_branch_pc(
                  .pc_address(pc_address),
                  .branch_address(imm_extended_out),
                  .pc_next_address(pc_plus_branch)
                );

  MUXALUSrcA mux_a (
               .SrcASel(ALUSrcA),
               .PC(pc_address),
               .Register1(read_data_1),
               .chosen_output(SrcA_chosen_data)
             );

  MUXALUSrcB mux_b (
               .SrcBSel(useImm),
               .Immediate(imm_extended_out),
               .Register2(read_data_2),
               .chosen_output(SrcB_chosen_data)
             );

  MUXPC mux_pc (
          .AddressSel(PCSel),
          .PCADD4(pc_plus_4),
          .BranchTargetAddress(pc_plus_branch),
          .ALU_result(ALU_result),
          .chosen_output(PC_chosen_address)
        );

  MUXRegisterWrite mux_reg (
                     .RegSel(to_reg_src),
                     .ALU_result(ALU_result),
                     .LoadExtender_result(load_data_extended),
                     .PCADD4_result(pc_plus_4),
                     .ImmExtender_result(imm_extended_out),
                     .chosen_output(data_to_write_reg)
                   );
endmodule
