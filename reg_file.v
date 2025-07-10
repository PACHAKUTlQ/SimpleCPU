`timescale 1ns / 1ps

module RegFile (
    input clk,
    input rst,

    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input [31:0] writeData,
    input regWrite,

    output [31:0] readData1,
    output [31:0] readData2
);

  reg [31:0] registerFile[0:31];
  integer i;

  assign readData1 = registerFile[rs1];
  assign readData2 = registerFile[rs2];

  always @(*) begin
    if (!rst && regWrite && rd != 5'b0) begin
      $display("Writing to register %d: %h", rd, writeData);
      registerFile[rd] <= writeData;
    end else begin
      $display("Not writing to register %d: regWrite=%b", rd, regWrite);
    end
  end

  always @(posedge rst) begin
    if (rst) begin
      for (i = 0; i < 32; i = i + 1) begin
        registerFile[i] <= 32'b0;
      end
    end
  end

endmodule
