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
    output zeroFlag,
    output [3:0] ALUControl_out
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

  assign ALUControl_out = ALUControl;

endmodule


module ALUCore (
    input [ 3:0] ALUControl,
    input [31:0] operand1,
    input [31:0] operand2,

    output reg [31:0] result,
    output reg zeroFlag
);

  always @(*) begin
    case (ALUControl)
      4'b0000: result = operand1 & operand2;  // and
      4'b0001: result = operand1 | operand2;  // or
      4'b0010: result = operand1 + operand2;  // add
      4'b0011: result = operand1 - operand2;  // sub
      4'b0100: result = operand1 - operand2;  // bge
      4'b0101: result = operand1 - operand2;  // blt
      4'b0110: result = operand1 - operand2;  // beq
      4'b0111: result = operand1 - operand2;  // bne
      4'b1000: result = operand1 << operand2;  // slli/sll
      4'b1001: result = operand1 >> operand2;  // srli/srl
      4'b1010: result = $signed($signed(operand1) >>> operand2);  // sra
      4'b1111: result = operand1 + operand2;  // jal/jalr
      default: result = 32'b0;
    endcase

    case (ALUControl)
      4'b0111: zeroFlag = (result != 32'b0);  // bne
      4'b0110: zeroFlag = (result == 32'b0);  // beq
      4'b0100: zeroFlag = ($signed(result) >= 0);  // bge
      4'b0101: zeroFlag = ($signed(result) < 0);  // blt
      default: zeroFlag = (result == 32'b0);  // Default zero flag for other operations
    endcase

    // // DEBUG: ALU
    // case (ALUControl)
    //   4'b0111: begin
    //     $display("ALU Operation: bne, Result: %h, Zero Flag: %b", result, zeroFlag);
    //     $display("operand1: %h, operand2: %h", operand1, operand2);
    //   end
    //   4'b0110: begin
    //     $display("ALU Operation: beq, Result: %h, Zero Flag: %b", result, zeroFlag);
    //     $display("operand1: %h, operand2: %h", operand1, operand2);
    //   end
    //   4'b0100: begin
    //     $display("ALU Operation: bge, Result: %h, Zero Flag: %b", result, zeroFlag);
    //     $display("operand1: %h, operand2: %h", operand1, operand2);
    //   end
    //   4'b0101: begin
    //     $display("ALU Operation: blt, Result: %h, Zero Flag: %b", result, zeroFlag);
    //     $display("operand1: %h, operand2: %h", operand1, operand2);
    //   end
    // endcase
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
      // addi, andi, slli, srli, lw, lb, lbu, sw, sb
      2'b00: begin
        case (funct3)
          3'b000:  ALUControl = 4'b0010;  // addi, lb, sb
          3'b001:  ALUControl = 4'b1000;  // slli
          3'b010:  ALUControl = 4'b0010;  // lw, sw
          3'b100:  ALUControl = 4'b0010;  // lbu
          3'b101:  ALUControl = 4'b1001;  // srli
          3'b111:  ALUControl = 4'b0000;  // andi
          default: ALUControl = 4'b0000;
        endcase
      end

      // beq, bne, bge, blt
      2'b01: begin  // Branch operations
        case (funct3)
          3'b000:  ALUControl = 4'b0110;  // beq
          3'b001:  ALUControl = 4'b0111;  // bne
          3'b101:  ALUControl = 4'b0100;  // bge
          3'b100:  ALUControl = 4'b0101;  // blt
          default: ALUControl = 4'b0000;
        endcase
      end

      // add, sub, sll, srl, sra, and, or
      2'b10: begin
        case (funct3)
          3'b000:  ALUControl = i30 ? 4'b0110 : 4'b0010;  // sub/add based on i[30]
          3'b001:  ALUControl = 4'b1000;  // sll
          3'b101:  ALUControl = i30 ? 4'b1010 : 4'b1001;  // sra/srl based on i[30]
          3'b111:  ALUControl = 4'b0000;  // and
          3'b110:  ALUControl = 4'b0001;  // or
          default: ALUControl = 4'b0000;
        endcase
      end

      // jal, jalr
      2'b11: begin
        ALUControl = 4'b1111;  // jal, jalr
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
