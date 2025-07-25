`timescale 1ns / 1ps

module PC (
    input clk,
    input rst,

    input PCSrc,
    input [31:0] jumpOrBranchAddress,  // jumpOrBranchAddress

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
      .PCPlus4            (PCPlus4),
      .jumpOrBranchAddress(jumpOrBranchAddress),
      .PCSrc              (PCSrc),
      .nextPCOut          (nextPCIn)
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


// All data from MEM stage
module PCMux (
    input [31:0] PCPlus4,
    input [31:0] jumpOrBranchAddress,
    input        PCSrc,

    output [31:0] nextPCOut
);

  assign nextPCOut = PCSrc ? jumpOrBranchAddress : PCPlus4;

endmodule
