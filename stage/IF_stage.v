`timescale 1ns / 1ps

module IF_stage (
    input clk,
    input rst,
    input PCSrc,
    input [31:0] branchTargetAddress,

    output [31:0] PCOut,
    output [31:0] instruction
);

  PC pc_inst (
      .clk(clk),
      .rst(rst),
      .PCSrc(PCSrc),
      .branchTargetAddress(branchTargetAddress),
      .PCOut(PCOut)
  );

  ROM rom_inst (
      .address(PCOut),
      .instruction(instruction)
  );

endmodule
