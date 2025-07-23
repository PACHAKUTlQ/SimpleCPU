`timescale 1ns / 1ps

module ID_stage (
    input clk,
    input rst,

    input [31:0] instruction,
    input [31:0] wb_writeData,
    input [4:0] wb_rd,  // Instruction [11:7]
    input wb_regWrite,

    output [1:0] ALUOp,
    output ALUSrc,
    output branch,
    output memRead,
    output memToReg,
    output memWrite,
    output id_regWrite,
    output [1:0] jumpType,  // 01: jalr, 10: jal
    output [31:0] readData1,
    output [31:0] readData2,
    output [31:0] immGenOut,
    output [4:0] id_rd,  // Instruction [11:7]
    output [2:0] funct3,  // Instruction [14:12]
    output i30  // Instruction [30]
);

  wire [6:0] opcode;
  wire [4:0] rs1;
  wire [4:0] rs2;

  assign opcode = instruction[6:0];
  assign funct3 = instruction[14:12];
  assign rs1 = instruction[19:15];
  assign rs2 = instruction[24:20];
  assign id_rd = instruction[11:7];
  assign i30 = instruction[30];

  ControlUnit control_unit_inst (
      .opcode(opcode),
      .ALUOp(ALUOp),
      .ALUSrc(ALUSrc),
      .branch(branch),
      .memRead(memRead),
      .memToReg(memToReg),
      .memWrite(memWrite),
      .regWrite(id_regWrite),
      .jumpType(jumpType)
  );

  RegFile reg_file_inst (
      .clk(clk),
      .rst(rst),
      .rs1(rs1),
      .rs2(rs2),
      .rd(wb_rd),
      .writeData(wb_writeData),
      .regWrite(wb_regWrite),
      .readData1(readData1),
      .readData2(readData2)
  );

  ImmGen imm_gen_inst (
      .instruction(instruction),
      .immGenOut  (immGenOut)
  );

endmodule
