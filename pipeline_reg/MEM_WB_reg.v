`timescale 1ns / 1ps

module MEM_WB_reg (
    input clk,
    input rst,

    // Inputs from MEM Stage
    input [31:0] mem_pc,
    input mem_memRead,
    input mem_memToReg,
    input mem_regWrite,
    input [1:0] mem_jumpType,  // 01: jalr, 10: jal
    input [31:0] mem_jumpOrBranchAddress,
    input [31:0] mem_dataFromRAM,  // readData from RAM
    input [31:0] mem_ALUResult,
    input [4:0] mem_rd,  // Instruction [11:7]
    input [4:0] mem_rs1,  // Instruction [19:15]
    input [4:0] mem_rs2,  // Instruction [24:20]

    // Outputs to WB Stage
    output reg [31:0] wb_pc,
    output reg wb_memRead,
    output reg wb_memToReg,
    output reg wb_regWrite,
    output reg [1:0] wb_jumpType,
    output reg [31:0] wb_jumpOrBranchAddress,
    output reg [31:0] wb_dataFromRAM,
    output reg [31:0] wb_ALUResult,
    output reg [4:0] wb_rd,
    output reg [4:0] wb_rs1,
    output reg [4:0] wb_rs2
);

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      wb_pc <= 32'b0;
      wb_memRead <= 1'b0;
      wb_memToReg <= 1'b0;
      wb_regWrite <= 1'b0;
      wb_jumpType <= 2'b00;
      wb_jumpOrBranchAddress <= 32'b0;
      wb_dataFromRAM <= 32'b0;
      wb_ALUResult <= 32'b0;
      wb_rd <= 5'b0;
      wb_rs1 <= 5'b0;
      wb_rs2 <= 5'b0;
    end else begin
      wb_pc <= mem_pc;
      wb_memRead <= mem_memRead;
      wb_memToReg <= mem_memToReg;
      wb_regWrite <= mem_regWrite;
      wb_jumpType <= mem_jumpType;
      wb_jumpOrBranchAddress <= mem_jumpOrBranchAddress;
      wb_dataFromRAM <= mem_dataFromRAM;
      wb_ALUResult <= mem_ALUResult;
      wb_rd <= mem_rd;
      wb_rs1 <= mem_rs1;
      wb_rs2 <= mem_rs2;
    end
  end

endmodule
