`timescale 1ns / 1ps

module PC (
    input clk,
    input rst,
    input PCSrc,
    input [31:0] branchTargetAddress,
    input [1:0] jumpType,  // 01: jalr, 10: jal
    input zeroFlag,
    input [31:0] ALUResult,

    output [31:0] PCOut
);

  wire [31:0] currentPC;
  wire [31:0] PCPlus4;
  wire [31:0] nextPCIn;

  PCCore pcCore (
      .clk(clk),
      .rst(rst),
      .nextPC(nextPCIn),
      .PC(currentPC)
  );

  // PC + 4
  PCAdd4 pcAdd4 (
      .PCIn   (currentPC),
      .PCPlus4(PCPlus4)
  );

  PCMux pcMux (
      .PCPlus4       (PCPlus4),
      .immInstruction(branchTargetAddress),
      .branchFlag    (PCSrc),
      .jumpType      (jumpType),
      .zeroFlag      (zeroFlag),
      .ALUResult     (ALUResult),
      .nextPCOut     (nextPCIn)
  );

  assign PCOut = currentPC;

endmodule


module PCCore (
    input clk,
    input rst,
    input [31:0] nextPC,

    output reg [31:0] PC
);

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      PC <= 32'b0;  // Initialize PC to 0 on reset
    end else begin
      PC <= nextPC;
    end
  end

endmodule


// PC + 4
module PCAdd4 (
    input  [31:0] PCIn,
    output [31:0] PCPlus4
);

  assign PCPlus4 = PCIn + 32'd4;

endmodule


module PCMux (
    input [31:0] PCPlus4,
    input [31:0] immInstruction,
    input        branchFlag,
    input [ 1:0] jumpType,        // 01: jalr, 10: jal
    input        zeroFlag,
    input [31:0] ALUResult,

    output reg [31:0] nextPCOut
);

  always @(*) begin
    if (branchFlag) begin
      if (zeroFlag) begin
        nextPCOut = immInstruction;  // beq, bne, etc.
      end else begin
        if (jumpType == 2'b10) begin
          nextPCOut = immInstruction;  // jal
        end else if (jumpType == 2'b01) begin
          nextPCOut = ALUResult;  // jalr
        end
      end
    end else begin
      nextPCOut = PCPlus4;  // PC + 4
    end
  end

endmodule
