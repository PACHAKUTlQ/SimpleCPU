`timescale 1ns / 1ps

`include "stage/IF_stage.v"
`include "stage/ID_stage.v"
`include "stage/EX_stage.v"
`include "stage/MEM_stage.v"
`include "stage/WB_stage.v"
`include "pipeline_reg/IF_ID_reg.v"
`include "pipeline_reg/ID_EX_reg.v"
`include "pipeline_reg/EX_MEM_reg.v"
`include "pipeline_reg/MEM_WB_reg.v"

module PipelinedProcessor (
    input clk,
    input rst
);

  // Wires between IF and ID
  wire [31:0] if_pc;
  wire [31:0] if_instruction;
  wire [31:0] id_pc;
  wire [31:0] id_instruction;

  // Wires between ID and EX
  wire [1:0] id_ALUOp;
  wire id_ALUSrc;
  wire id_branch;
  wire id_memRead;
  wire id_memToReg;
  wire id_memWrite;
  wire id_regWrite;
  wire [31:0] id_readData1;
  wire [31:0] id_readData2;
  wire [31:0] id_immGenOut;
  wire [4:0] id_rd;
  wire [2:0] id_funct3;
  wire id_i30;

  wire [31:0] ex_pc;
  wire [1:0] ex_ALUOp;
  wire ex_ALUSrc;
  wire ex_branch;
  wire ex_memRead;
  wire ex_memToReg;
  wire ex_memWrite;
  wire ex_regWrite;
  wire [31:0] ex_readData1;
  wire [31:0] ex_readData2;
  wire [31:0] ex_immGenOut;
  wire [4:0] ex_rd;
  wire [2:0] ex_funct3;
  wire ex_i30;

  // Wires between EX and MEM
  wire [31:0] ex_ALUResult;
  wire ex_zeroFlag;
  wire [31:0] ex_branchTargetAddress;
  wire [31:0] mem_ALUResult;
  wire mem_memRead;
  wire mem_memToReg;
  wire mem_memWrite;
  wire mem_regWrite;
  wire [31:0] mem_readData2;
  wire [4:0] mem_rd;
  wire [31:0] mem_branchTargetAddress;
  wire mem_zeroFlag;
  wire mem_branch;
  wire [2:0] mem_funct3;

  // Wires between MEM and WB
  wire [31:0] mem_dataFromRAM;
  wire [31:0] wb_dataFromRAM;
  wire [31:0] wb_ALUResult;
  wire wb_memToReg;
  wire wb_regWrite;
  wire [4:0] wb_rd;
  wire mem_PCSrc;

  // Wire for WB stage
  wire [31:0] wb_writeData;

  // IF Stage
  IF_stage if_stage (
      .clk(clk),
      .rst(rst),
      .PCSrc(mem_PCSrc),
      .branchTargetAddress(mem_branchTargetAddress),
      .PCOut(if_pc),
      .instruction(if_instruction)
  );

  // IF/ID Pipeline Register
  IF_ID_reg if_id_reg (
      .clk(clk),
      .rst(rst),
      .if_pc(if_pc),
      .if_instruction(if_instruction),
      .id_pc(id_pc),
      .id_instruction(id_instruction)
  );

  // ID Stage
  ID_stage id_stage (
      .clk(clk),
      .rst(rst),
      .instruction(id_instruction),
      .wb_writeData(wb_writeData),
      .wb_regWrite(wb_regWrite),
      .wb_rd(wb_rd),
      .ALUOp(id_ALUOp),
      .ALUSrc(id_ALUSrc),
      .branch(id_branch),
      .memRead(id_memRead),
      .memToReg(id_memToReg),
      .memWrite(id_memWrite),
      .id_regWrite(id_regWrite),
      .readData1(id_readData1),
      .readData2(id_readData2),
      .immGenOut(id_immGenOut),
      .id_rd(id_rd),
      .funct3(id_funct3),
      .i30(id_i30)
  );

  // ID/EX Pipeline Register
  ID_EX_reg id_ex_reg (
      .clk(clk),
      .rst(rst),
      .id_pc(id_pc),
      .id_ALUOp(id_ALUOp),
      .id_ALUSrc(id_ALUSrc),
      .id_branch(id_branch),
      .id_memRead(id_memRead),
      .id_memToReg(id_memToReg),
      .id_memWrite(id_memWrite),
      .id_regWrite(id_regWrite),
      .id_readData1(id_readData1),
      .id_readData2(id_readData2),
      .id_immGenOut(id_immGenOut),
      .id_rd(id_rd),
      .id_funct3(id_funct3),
      .id_i30(id_i30),
      .ex_pc(ex_pc),
      .ex_ALUOp(ex_ALUOp),
      .ex_ALUSrc(ex_ALUSrc),
      .ex_branch(ex_branch),
      .ex_memRead(ex_memRead),
      .ex_memToReg(ex_memToReg),
      .ex_memWrite(ex_memWrite),
      .ex_regWrite(ex_regWrite),
      .ex_readData1(ex_readData1),
      .ex_readData2(ex_readData2),
      .ex_immGenOut(ex_immGenOut),
      .ex_rd(ex_rd),
      .ex_funct3(ex_funct3),
      .ex_i30(ex_i30)
  );

  // EX Stage
  EX_stage ex_stage (
      .ex_pc(ex_pc),
      .readData1(ex_readData1),
      .readData2(ex_readData2),
      .immGenOut(ex_immGenOut),
      .funct3(ex_funct3),
      .ALUOp(ex_ALUOp),
      .i30(ex_i30),
      .ALUSrc(ex_ALUSrc),
      .ALUResult(ex_ALUResult),
      .zeroFlag(ex_zeroFlag),
      .branchTargetAddress(ex_branchTargetAddress)
  );

  // EX/MEM Pipeline Register
  EX_MEM_reg ex_mem_reg (
      .clk(clk),
      .rst(rst),
      .ex_memRead(ex_memRead),
      .ex_memToReg(ex_memToReg),
      .ex_memWrite(ex_memWrite),
      .ex_regWrite(ex_regWrite),
      .ex_ALUResult(ex_ALUResult),
      .ex_readData2(ex_readData2),
      .ex_rd(ex_rd),
      .ex_branchTargetAddress(ex_branchTargetAddress),
      .ex_zeroFlag(ex_zeroFlag),
      .ex_branch(ex_branch),
      .ex_funct3(ex_funct3),
      .mem_memRead(mem_memRead),
      .mem_memToReg(mem_memToReg),
      .mem_memWrite(mem_memWrite),
      .mem_regWrite(mem_regWrite),
      .mem_ALUResult(mem_ALUResult),
      .mem_readData2(mem_readData2),
      .mem_rd(mem_rd),
      .mem_branchTargetAddress(mem_branchTargetAddress),
      .mem_zeroFlag(mem_zeroFlag),
      .mem_branch(mem_branch),
      .mem_funct3(mem_funct3)
  );

  // MEM Stage
  MEM_stage mem_stage (
      .clk(clk),
      .ALUResult(mem_ALUResult),
      .writeData(mem_readData2),
      .memRead(mem_memRead),
      .memToReg(mem_memToReg),
      .memWrite(mem_memWrite),
      .mem_zeroFlag(mem_zeroFlag),
      .mem_branch(mem_branch),
      .mem_funct3(mem_funct3),
      .dataFromRAM(mem_dataFromRAM),
      .PCSrc(mem_PCSrc)
  );

  // MEM/WB Pipeline Register
  MEM_WB_reg mem_wb_reg (
      .clk(clk),
      .rst(rst),
      .mem_memToReg(mem_memToReg),
      .mem_regWrite(mem_regWrite),
      .mem_dataFromRAM(mem_dataFromRAM),
      .mem_ALUResult(mem_ALUResult),
      .mem_rd(mem_rd),
      .wb_memToReg(wb_memToReg),
      .wb_regWrite(wb_regWrite),
      .wb_dataFromRAM(wb_dataFromRAM),
      .wb_ALUResult(wb_ALUResult),
      .wb_rd(wb_rd)
  );

  // WB Stage
  WB_stage wb_stage (
      .dataFromRAM(wb_dataFromRAM),
      .ALUResult(wb_ALUResult),
      .memToReg(wb_memToReg),
      .writeData(wb_writeData)
  );

endmodule
