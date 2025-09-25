`timescale 1ns / 1ps

module BranchDetection (
    input rst,

    input [31:0] instruction,
    input [31:0] rd1,
    input [31:0] rd2,

    output reg branchTaken
);

  always @(*) begin
    if (rst) begin
      branchTaken = 1'b0;
    end else begin
      if (instruction[6:0] == 7'b1100011) begin  // B-type instructions
        case (instruction[14:12])  // funct3
          3'b000:  branchTaken = (rd1 == rd2);  // beq
          3'b001:  branchTaken = (rd1 != rd2);  // bne
          3'b100:  branchTaken = ($signed(rd1) < $signed(rd2));  // blt
          3'b101:  branchTaken = ($signed(rd1) >= $signed(rd2));  // bge
          default: branchTaken = 1'b1;  // Always assume branch is taken
        endcase
      end
    end
  end

endmodule
