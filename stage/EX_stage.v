`timescale 1ns / 1ps

module EX_stage (
    input [31:0] ex_pc,
    input [31:0] readData1,
    input [31:0] readData2,
    input [31:0] immGenOut,
    input [2:0] funct3,  // Instruction [14:12]
    input [1:0] ALUOp,
    input i30,  // Instruction [30]
    input ALUSrc,

    output [31:0] ALUResult,
    output zeroFlag,
    output [31:0] branchTargetAddress,
    output [3:0] ALUControl
);

  assign branchTargetAddress = ex_pc + immGenOut << 1;

  ALU alu_inst (
      .readData1(readData1),
      .readData2(readData2),
      .immGenOut(immGenOut),
      .funct3(funct3),
      .ALUOp(ALUOp),
      .i30(i30),
      .ALUSrc(ALUSrc),
      .result(ALUResult),
      .zeroFlag(zeroFlag),
      .ALUControl_out(ALUControl)
  );

endmodule
