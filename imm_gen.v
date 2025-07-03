`timescale 1ns / 1ps

module ImmGen (
    input [31:0] instruction,

    output reg [31:0] immGenOut
);

  always @(*) begin
    case (instruction[6:0])
      7'b0010011,  // I-type: addi
      7'b0000011:  // I-type: lw
      immGenOut = {{20{instruction[31]}}, instruction[31:20]};
      7'b0100011:  // S-type: sw
      immGenOut = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
      7'b1100011:  // B-type: beq, bne
      immGenOut = {
        {20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0
      };
      default: immGenOut = 32'b0;
    endcase
  end

endmodule
