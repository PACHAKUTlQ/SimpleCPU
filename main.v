`timescale 1ns / 1ps

module SingleCycleProcessor (
    input clk,
    input rst
);

  // Wires for PC
  wire [31:0] PCOut;

  // Wires for Instruction Memory (ROM)
  wire [31:0] instruction;

  // Decoded parts of instruction
  wire [6:0] opcode;
  wire [2:0] funct3;
  wire [4:0] rs1;
  wire [4:0] rs2;
  wire [4:0] rd;
  wire i30;  // instruction[30] for ALU

  // Wires for Control Unit
  wire [1:0] ALUOp;
  wire ALUSrc;
  wire branch;
  wire memRead;
  wire memToReg;
  wire memWrite;
  wire regWrite;

  // Wires for Register File
  wire [31:0] readData1;
  wire [31:0] readData2;
  // writeData to RegFile comes from dataFromRAM

  // Wires for Immediate Generator
  wire [31:0] immGenOut;

  // Wires for ALU
  wire [31:0] ALUResult;
  wire zeroFlag;

  // Wires for Data Memory (RAM) and Mux
  wire [31:0] dataFromRAM;  // Output of RAM module which includes MemToReg Mux


  // Instruction decoding assignments
  assign opcode = instruction[6:0];
  assign funct3 = instruction[14:12];
  assign rs1 = instruction[19:15];
  assign rs2 = instruction[24:20];
  assign rd = instruction[11:7];
  assign i30 = instruction[30];

  // Instantiate Program Counter (PC)
  PC pc_inst (
      .clk(clk),
      .rst(rst),
      .immGenOut(immGenOut),
      .funct3(funct3),
      .branch(branch),
      .zeroFlag(zeroFlag),
      .PCOut(PCOut)
  );

  // Instantiate Instruction Memory (ROM)
  ROM rom_inst (
      .address(PCOut),
      .instruction(instruction)
  );

  // Instantiate Control Unit
  ControlUnit control_unit_inst (
      .opcode(opcode),
      .ALUOp(ALUOp),
      .ALUSrc(ALUSrc),
      .branch(branch),
      .memRead(memRead),
      .memToReg(memToReg),
      .memWrite(memWrite),
      .regWrite(regWrite)
  );

  // Instantiate Register File
  RegFile reg_file_inst (
      .clk(clk),
      .rst(rst),
      .rs1(rs1),
      .rs2(rs2),
      .rd(rd),
      .writeData(dataFromRAM),
      .regWrite(regWrite),
      .readData1(readData1),
      .readData2(readData2)
  );

  // Instantiate Immediate Generator
  ImmGen imm_gen_inst (
      .instruction(instruction),
      .immGenOut  (immGenOut)
  );

  // Instantiate ALU
  ALU alu_inst (
      .readData1(readData1),
      .readData2(readData2),
      .immGenOut(immGenOut),
      .funct3(funct3),
      .ALUOp(ALUOp),
      .i30(i30),
      .ALUSrc(ALUSrc),
      .result(ALUResult),
      .zeroFlag(zeroFlag)
  );

  // Instantiate Data Memory (RAM)
  RAM ram_inst (
      .clk(clk),
      .ALUResult(ALUResult),
      .writeData(readData2),
      .memRead(memRead),
      .memToReg(memToReg),
      .memWrite(memWrite),
      .writeDataReg(dataFromRAM)
  );

endmodule
