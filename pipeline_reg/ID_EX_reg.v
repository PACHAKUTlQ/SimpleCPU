`timescale 1ns / 1ps

module ID_EX_reg (
    input clk,
    input rst,

    // Inputs from ID Stage
    input [31:0] id_pc,
    input [1:0] id_ALUOp,
    input id_ALUSrc,
    input id_branch,
    input id_memRead,
    input id_memToReg,
    input id_memWrite,
    input id_regWrite,
    input [31:0] id_readData1,
    input [31:0] id_readData2,
    input [31:0] id_immGenOut,
    input [4:0] id_rd,  // Instruction [11:7]
    input [2:0] id_funct3,  // Instruction [14:12]
    input id_i30,  // Instruction [30]

    // Outputs to EX Stage
    output reg [31:0] ex_pc,
    output reg [1:0] ex_ALUOp,
    output reg ex_ALUSrc,
    output reg ex_branch,
    output reg ex_memRead,
    output reg ex_memToReg,
    output reg ex_memWrite,
    output reg ex_regWrite,
    output reg [31:0] ex_readData1,
    output reg [31:0] ex_readData2,
    output reg [31:0] ex_immGenOut,
    output reg [4:0] ex_rd,
    output reg [2:0] ex_funct3,
    output reg ex_i30
);

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      ex_pc <= 32'b0;
      ex_ALUOp <= 2'b0;
      ex_ALUSrc <= 1'b0;
      ex_branch <= 1'b0;
      ex_memRead <= 1'b0;
      ex_memToReg <= 1'b0;
      ex_memWrite <= 1'b0;
      ex_regWrite <= 1'b0;
      ex_readData1 <= 32'b0;
      ex_readData2 <= 32'b0;
      ex_immGenOut <= 32'b0;
      ex_rd <= 5'b0;
      ex_funct3 <= 3'b0;
      ex_i30 <= 1'b0;
    end else begin
      ex_pc <= id_pc;
      ex_ALUOp <= id_ALUOp;
      ex_ALUSrc <= id_ALUSrc;
      ex_branch <= id_branch;
      ex_memRead <= id_memRead;
      ex_memToReg <= id_memToReg;
      ex_memWrite <= id_memWrite;
      ex_regWrite <= id_regWrite;
      ex_readData1 <= id_readData1;
      ex_readData2 <= id_readData2;
      ex_immGenOut <= id_immGenOut;
      ex_rd <= id_rd;
      ex_funct3 <= id_funct3;
      ex_i30 <= id_i30;
    end
  end

endmodule
