`timescale 1ns / 1ps

module EX_MEM_reg (
    input clk,
    input rst,

    // Inputs from EX Stage
    input [31:0] ex_pc,
    input ex_memRead,
    input ex_memToReg,
    input ex_memWrite,
    input ex_regWrite,
    input ex_zeroFlag,
    input [1:0] ex_jumpType,  // 01: jalr, 10: jal
    input [31:0] ex_ALUResult,
    input [31:0] ex_readData2,
    input [4:0] ex_rd,  // Instruction [11:7]
    input [2:0] ex_funct3,  // Instruction [14:12]

    // Outputs to MEM Stage
    output reg [31:0] mem_pc,
    output reg mem_memRead,
    output reg mem_memToReg,
    output reg mem_memWrite,
    output reg mem_regWrite,
    output reg mem_zeroFlag,
    output reg [1:0] mem_jumpType,
    output reg [31:0] mem_ALUResult,
    output reg [31:0] mem_readData2,
    output reg [4:0] mem_rd,
    output reg [2:0] mem_funct3
);

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      mem_pc <= 32'b0;
      mem_memRead <= 1'b0;
      mem_memToReg <= 1'b0;
      mem_memWrite <= 1'b0;
      mem_regWrite <= 1'b0;
      mem_zeroFlag <= 1'b0;
      mem_jumpType <= 2'b00;
      mem_ALUResult <= 32'b0;
      mem_readData2 <= 32'b0;
      mem_rd <= 5'b0;
      mem_funct3 <= 3'b0;
    end else begin
      mem_pc <= ex_pc;
      mem_memRead <= ex_memRead;
      mem_memToReg <= ex_memToReg;
      mem_memWrite <= ex_memWrite;
      mem_regWrite <= ex_regWrite;
      mem_zeroFlag <= ex_zeroFlag;
      mem_jumpType <= ex_jumpType;
      mem_ALUResult <= ex_ALUResult;
      mem_readData2 <= ex_readData2;
      mem_rd <= ex_rd;
      mem_funct3 <= ex_funct3;
    end
  end

endmodule
