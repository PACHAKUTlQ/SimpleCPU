`timescale 1ns / 1ps

module EX_MEM_reg (
    input clk,
    input rst,

    // Inputs from EX Stage
    input ex_memRead,
    input ex_memToReg,
    input ex_memWrite,
    input ex_regWrite,
    input [31:0] ex_ALUResult,
    input [31:0] ex_readData2,
    input [4:0] ex_rd,
    input [31:0] ex_branchTargetAddress,
    input ex_zeroFlag,
    input ex_branch,
    input [2:0] ex_funct3,

    // Outputs to MEM Stage
    output reg mem_memRead,
    output reg mem_memToReg,
    output reg mem_memWrite,
    output reg mem_regWrite,
    output reg [31:0] mem_ALUResult,
    output reg [31:0] mem_readData2,
    output reg [4:0] mem_rd,
    output reg [31:0] mem_branchTargetAddress,
    output reg mem_zeroFlag,
    output reg mem_branch,
    output reg [2:0] mem_funct3
);

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      mem_memRead <= 1'b0;
      mem_memToReg <= 1'b0;
      mem_memWrite <= 1'b0;
      mem_regWrite <= 1'b0;
      mem_ALUResult <= 32'b0;
      mem_readData2 <= 32'b0;
      mem_rd <= 5'b0;
      mem_branchTargetAddress <= 32'b0;
      mem_zeroFlag <= 1'b0;
      mem_branch <= 1'b0;
      mem_funct3 <= 3'b0;
    end else begin
      mem_memRead <= ex_memRead;
      mem_memToReg <= ex_memToReg;
      mem_memWrite <= ex_memWrite;
      mem_regWrite <= ex_regWrite;
      mem_ALUResult <= ex_ALUResult;
      mem_readData2 <= ex_readData2;
      mem_rd <= ex_rd;
      mem_branchTargetAddress <= ex_branchTargetAddress;
      mem_zeroFlag <= ex_zeroFlag;
      mem_branch <= ex_branch;
      mem_funct3 <= ex_funct3;
    end
  end

endmodule
