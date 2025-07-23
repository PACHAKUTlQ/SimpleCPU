`timescale 1ns / 1ps

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
  wire [1:0] id_jumpType;  // 01: jalr, 10: jal
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
  wire [1:0] ex_jumpType;
  wire [31:0] ex_readData1;
  wire [31:0] ex_readData2;
  wire [31:0] ex_immGenOut;
  wire [4:0] ex_rd;
  wire [2:0] ex_funct3;
  wire ex_i30;

  // Wires between EX and MEM
  wire [31:0] ex_ALUResult;
  wire ex_zeroFlag;
  wire ex_PCSrc;
  wire [31:0] ex_jumpOrBranchAddress;
  wire [3:0] ex_ALUControl;

  wire [31:0] mem_pc;
  wire [31:0] mem_ALUResult;
  wire mem_memRead;
  wire mem_memToReg;
  wire mem_memWrite;
  wire mem_regWrite;
  wire [31:0] mem_readData2;
  wire [4:0] mem_rd;
  wire [1:0] mem_jumpType;
  wire [2:0] mem_funct3;
  wire [31:0] mem_dataFromRAM;

  // Wires between MEM and WB
  wire [31:0] wb_pc;
  wire [31:0] wb_dataFromRAM;
  wire [31:0] wb_ALUResult;
  wire wb_memToReg;
  wire wb_regWrite;
  wire [1:0] wb_jumpType;
  wire [4:0] wb_rd;

  // Wire for WB stage
  wire [31:0] wb_writeData;

  // IF Stage
  IF_stage if_stage (
      .clk(clk),
      .rst(rst),
      .PCSrc(ex_PCSrc),
      .jumpOrBranchAddress(ex_jumpOrBranchAddress),
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
      .jumpType(id_jumpType),
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
      .id_jumpType(id_jumpType),
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
      .ex_jumpType(ex_jumpType),
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
      .branch(ex_branch),
      .jumpType(ex_jumpType),  // 01: jalr, 10: jal
      .ALUResult(ex_ALUResult),
      .ALUControl(ex_ALUControl),
      .zeroFlag(ex_zeroFlag),
      .PCSrc(ex_PCSrc),
      .jumpOrBranchAddress(ex_jumpOrBranchAddress)
  );

  // EX/MEM Pipeline Register
  EX_MEM_reg ex_mem_reg (
      .clk(clk),
      .rst(rst),
      .ex_pc(ex_pc),
      .ex_memRead(ex_memRead),
      .ex_memToReg(ex_memToReg),
      .ex_memWrite(ex_memWrite),
      .ex_regWrite(ex_regWrite),
      .ex_jumpType(ex_jumpType),
      .ex_ALUResult(ex_ALUResult),
      .ex_readData2(ex_readData2),
      .ex_rd(ex_rd),
      .ex_funct3(ex_funct3),
      .mem_pc(mem_pc),
      .mem_memRead(mem_memRead),
      .mem_memToReg(mem_memToReg),
      .mem_memWrite(mem_memWrite),
      .mem_regWrite(mem_regWrite),
      .mem_jumpType(mem_jumpType),
      .mem_ALUResult(mem_ALUResult),
      .mem_readData2(mem_readData2),
      .mem_rd(mem_rd),
      .mem_funct3(mem_funct3)
  );

  // MEM Stage
  MEM_stage mem_stage (
      .clk(clk),
      .ALUResult(mem_ALUResult),
      .writeData(mem_readData2),
      .mem_funct3(mem_funct3),
      .memRead(mem_memRead),
      .memToReg(mem_memToReg),
      .memWrite(mem_memWrite),
      .dataFromRAM(mem_dataFromRAM)
  );

  // MEM/WB Pipeline Register
  MEM_WB_reg mem_wb_reg (
      .clk(clk),
      .rst(rst),
      .mem_pc(mem_pc),
      .mem_memToReg(mem_memToReg),
      .mem_regWrite(mem_regWrite),
      .mem_jumpType(mem_jumpType),
      .mem_dataFromRAM(mem_dataFromRAM),
      .mem_ALUResult(mem_ALUResult),
      .mem_rd(mem_rd),
      .wb_pc(wb_pc),
      .wb_memToReg(wb_memToReg),
      .wb_regWrite(wb_regWrite),
      .wb_jumpType(wb_jumpType),
      .wb_dataFromRAM(wb_dataFromRAM),
      .wb_ALUResult(wb_ALUResult),
      .wb_rd(wb_rd)
  );

  // WB Stage
  WB_stage wb_stage (
      .wb_pc(wb_pc),
      .dataFromRAM(wb_dataFromRAM),
      .ALUResult(wb_ALUResult),
      .memToReg(wb_memToReg),
      .jumpType(wb_jumpType),
      .writeData(wb_writeData)
  );

endmodule
