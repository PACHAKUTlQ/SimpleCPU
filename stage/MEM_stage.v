`timescale 1ns / 1ps

module MEM_stage (
    input clk,

    input [31:0] ALUResult,
    input [31:0] writeData,
    input [2:0] mem_funct3,  // Instruction [14:12]
    input memRead,
    input memToReg,
    input memWrite,

    output [31:0] dataFromRAM
);

  RAM ram_inst (
      .clk(clk),
      .address(ALUResult),
      .writeData(writeData),
      .funct3(mem_funct3),
      .memRead(memRead),
      .memToReg(memToReg),
      .memWrite(memWrite),
      .readData(dataFromRAM)
  );

endmodule
