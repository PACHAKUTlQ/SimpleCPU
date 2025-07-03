`timescale 1ns / 1ps

module MEM_WB_reg (
    input clk,
    input rst,

    // Inputs from MEM Stage
    input mem_memToReg,
    input mem_regWrite,
    input [31:0] mem_dataFromRAM,
    input [31:0] mem_ALUResult,
    input [4:0] mem_rd,

    // Outputs to WB Stage
    output reg wb_memToReg,
    output reg wb_regWrite,
    output reg [31:0] wb_dataFromRAM,
    output reg [31:0] wb_ALUResult,
    output reg [4:0] wb_rd
);

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      wb_memToReg <= 1'b0;
      wb_regWrite <= 1'b0;
      wb_dataFromRAM <= 32'b0;
      wb_ALUResult <= 32'b0;
      wb_rd <= 5'b0;
    end else begin
      wb_memToReg <= mem_memToReg;
      wb_regWrite <= mem_regWrite;
      wb_dataFromRAM <= mem_dataFromRAM;
      wb_ALUResult <= mem_ALUResult;
      wb_rd <= mem_rd;
    end
  end

endmodule
