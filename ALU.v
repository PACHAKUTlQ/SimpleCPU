`timescale 1ns / 1ps

module ALU (
    input [31:0] readData1,
    input [31:0] readData2,
    input [31:0] immGenOut,
    input [2:0] funct3,
    input [1:0] ALUOp,
    input i30,
    input ALUSrc,

    output [31:0] result,
    output zeroFlag
);

  wire [ 3:0] ALUControl;
  wire [31:0] operand2;

  ALUControlUnit aluControlUnit (
      .i30(i30),
      .funct3(funct3),
      .ALUOp(ALUOp),
      .ALUControl(ALUControl)
  );

  ALUMux aluMux (
      .readData2(readData2),
      .immGenOut(immGenOut),
      .ALUSrc(ALUSrc),
      .operand2(operand2)
  );

  ALUCore aluCore (
      .ALUControl(ALUControl),
      .operand1(readData1),
      .operand2(operand2),
      .result(result),
      .zeroFlag(zeroFlag)
  );

endmodule


module ALUCore (
    input [ 3:0] ALUControl,
    input [31:0] operand1,
    input [31:0] operand2,

    output reg [31:0] result,
    output zeroFlag
);

  assign zeroFlag = (result == 32'b0);

  always @(*) begin
    // zeroFlag = (result == 32'b0);
    case (ALUControl)
      4'b0000: result = operand1 & operand2;  // and
      4'b0001: result = operand1 | operand2;  // or
      4'b0010: result = operand1 + operand2;  // add
      4'b0110: result = operand1 - operand2;  // sub
      default: result = 32'b0;
    endcase
  end

endmodule


module ALUControlUnit (
    input i30,
    input [2:0] funct3,
    input [1:0] ALUOp,

    output reg [3:0] ALUControl
);

  // https://www.cs.sfu.ca/~ashriram/Courses/CS295/assets/notebooks/RISCV/RISCV_CARD.pdf

  always @(*) begin
    case (ALUOp)
      2'b00:   ALUControl = 4'b0010;  // Used for lw, sw, addi
      2'b01: begin  // Branch operations
        case (funct3)
          3'b000:  ALUControl = 4'b0110;  // beq (rs1 - rs2)
          3'b001:  ALUControl = 4'b0110;  // bne (rs1 - rs2)
          default: ALUControl = 4'b0000;
        endcase
      end
      2'b10: begin  // R-type operations
        case (funct3)
          3'b000:  ALUControl = i30 ? 4'b0110 : 4'b0010;  // sub/add based on i[30]
          3'b111:  ALUControl = 4'b0000;  // and
          3'b110:  ALUControl = 4'b0001;  // or
          default: ALUControl = 4'b0000;
        endcase
      end
      default: ALUControl = 4'b0000;
    endcase
  end

endmodule


module ALUMux (
    input [31:0] readData2,
    input [31:0] immGenOut,
    input ALUSrc,

    output [31:0] operand2
);

  assign operand2 = ALUSrc ? immGenOut : readData2;

endmodule
