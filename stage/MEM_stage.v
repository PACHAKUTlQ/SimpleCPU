`timescale 1ns / 1ps

module MEM_stage (
    input clk,
    input [31:0] ALUResult,
    input [31:0] writeData,
    input memRead,
    input memToReg,
    input memWrite,
    input mem_zeroFlag,
    input mem_branch,
    input [2:0] mem_funct3,

    output [31:0] dataFromRAM,
    output reg PCSrc
);

  always @(*) begin
    case (mem_funct3)
      3'b000:  PCSrc = mem_branch & mem_zeroFlag;  // beq
      3'b001:  PCSrc = mem_branch & ~mem_zeroFlag; // bne
      default: PCSrc = 1'b0;
    endcase
  end

  RAM ram_inst (
      .clk(clk),
      .ALUResult(ALUResult),
      .writeData(writeData),
      .memRead(memRead),
      .memToReg(memToReg),
      .memWrite(memWrite),
      .writeDataReg(dataFromRAM)
  );

endmodule
