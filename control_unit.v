`timescale 1ns / 1ps

module ControlUnit (
    input [6:0] opcode,

    output reg [1:0] ALUOp,
    output reg ALUSrc,
    output reg branch,
    output reg memRead,
    output reg memToReg,
    output reg memWrite,
    output reg regWrite
);

  always @(*) begin
    case (opcode)
      7'b0110011: begin  // R-type
        ALUOp = 2'b10;
        ALUSrc = 1'b0;
        branch = 1'b0;
        memRead = 1'b0;
        memToReg = 1'b0;
        memWrite = 1'b0;
        regWrite = 1'b1;
      end
      7'b0010011: begin  // I-type: addi
        ALUOp = 2'b00;
        ALUSrc = 1'b1;
        branch = 1'b0;
        memRead = 1'b0;
        memToReg = 1'b0;
        memWrite = 1'b0;
        regWrite = 1'b1;
      end
      7'b0000011: begin  // I-type: lw
        ALUOp = 2'b00;
        ALUSrc = 1'b1;
        branch = 1'b0;
        memRead = 1'b1;
        memToReg = 1'b1;
        memWrite = 1'b0;
        regWrite = 1'b1;
      end
      7'b0100011: begin  // S-type: sw
        ALUOp = 2'b00;
        ALUSrc = 1'b1;
        branch = 1'b0;
        memRead = 1'b0;
        memToReg = 1'b0;
        memWrite = 1'b1;
        regWrite = 1'b0;
      end
      7'b1100011: begin  // B-type: beq, bne
        ALUOp = 2'b01;
        ALUSrc = 1'b0;
        branch = 1'b1;
        memRead = 1'b0;
        memToReg = 1'b0;
        memWrite = 1'b0;
        regWrite = 1'b0;
      end
      default: begin
        ALUOp = 2'b00;
        ALUSrc = 1'b0;
        branch = 1'b0;
        memRead = 1'b0;
        memToReg = 1'b0;
        memWrite = 1'b0;
        regWrite = 1'b0;
      end
    endcase
  end

endmodule
