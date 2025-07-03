`timescale 1ns / 1ps

module PC (
    input clk,
    input rst,

    input [31:0] immGenOut,
    input [2:0] funct3,
    input branch,
    input zeroFlag,

    output [31:0] PCOut
);

  wire [31:0] currentPC;
  wire [31:0] PCPlus4;
  wire [31:0] branchTarget;
  wire [31:0] nextPCIn;
  reg branchFlag;

  PCCore pcCore (
      .clk(clk),
      .rst(rst),
      .nextPC(nextPCIn),
      .PC(currentPC)
  );

  // PC + 4
  PCAdd4 pcAdd4 (
      .PCIn           (currentPC),
      .nextInstruction(PCPlus4)
  );

  // PC + (ImmGenOut << 1)
  PCBranchAdder pcBranchAdder (
      .PCIn             (currentPC),
      .immGenOut        (immGenOut),
      .branchInstruction(branchTarget)
  );

  always @(*) begin
    case (funct3)
      3'b000:  branchFlag = branch & zeroFlag;  // beq
      3'b001:  branchFlag = branch & ~zeroFlag;  // bne
      default: branchFlag = 1'b0;
    endcase
  end


  PCMux pcMux (
      .nextInstruction  (PCPlus4),
      .branchInstruction(branchTarget),
      .branchFlag       (branchFlag),
      .nextPCOut        (nextPCIn)
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
    input [31:0] PCIn,

    output [31:0] nextInstruction
);

  assign nextInstruction = PCIn + 32'd4;

endmodule


// PC + (ImmGenOut << 1)
module PCBranchAdder (
    input [31:0] PCIn,
    input [31:0] immGenOut,

    output [31:0] branchInstruction
);

  assign branchInstruction = PCIn + (immGenOut << 1);

endmodule


module PCMux (
    input [31:0] nextInstruction,
    input [31:0] branchInstruction,
    input        branchFlag,

    output [31:0] nextPCOut
);

  assign nextPCOut = branchFlag ? branchInstruction : nextInstruction;

endmodule
