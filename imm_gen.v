`timescale 1ns / 1ps

module ImmGen (
    input [31:0] instruction,

    output reg [31:0] immGenOut
);

  always @(*) begin
    //  add, addi, sub, and, andi, or, sll, slli, srl, srli, lw, sw, lb, lbu, and sb, beq, bne, bge, blt, jal, and jalr
    case (instruction[6:0])
      7'b0010011,  // I-type: addi, andi, slli, srli
      7'b1100111,  // I-type: jalr
      7'b0000011:  // I-type: lw, lb, lbu
      immGenOut = {{20{instruction[31]}}, instruction[31:20]};
      7'b0100011:  // S-type: sw, sb
      immGenOut = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
      7'b1100011:  // B-type: beq, bne, bge, blt
      immGenOut = {{21{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8]};
      7'b1101111:  // J-type: jal
      immGenOut = {{13{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21]};
      default: immGenOut = 32'b0;
    endcase
  end

endmodule
