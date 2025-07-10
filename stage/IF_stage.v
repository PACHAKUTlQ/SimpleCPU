`timescale 1ns / 1ps

module IF_stage (
    input clk,
    input rst,

    input [31:0] branchTargetAddress,
    input PCSrc,
    input [1:0] jumpType,  // 01: jalr, 10: jal
    input zeroFlag,
    input [31:0] ALUResult,

    output [31:0] PCOut,
    output [31:0] instruction
);

  PC pc_inst (
      .clk(clk),
      .rst(rst),
      .PCSrc(PCSrc),
      .branchTargetAddress(branchTargetAddress),
      .jumpType(jumpType),
      .zeroFlag(zeroFlag),
      .ALUResult(ALUResult),
      .PCOut(PCOut)
  );

  ROM rom_inst (
      .address(PCOut),
      .instruction(instruction)
  );

endmodule
