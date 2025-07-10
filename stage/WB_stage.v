`timescale 1ns / 1ps

module WB_stage (
    input [31:0] PCPlus4,
    input [31:0] dataFromRAM,
    input [31:0] ALUResult,
    input memToReg,
    input [1:0] jumpType,  // 01: jalr, 10: jal

    output [31:0] writeData
);

  assign writeData = (jumpType != 2'b00) ? dataFromRAM : PCPlus4;  // If jal or jalr, write PC+4

endmodule
