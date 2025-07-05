`timescale 1ns / 1ps

module WB_stage (
    input [31:0] dataFromRAM,
    input [31:0] ALUResult,
    input memToReg,

    output [31:0] writeData
);

  assign writeData = memToReg ? dataFromRAM : ALUResult;

endmodule
