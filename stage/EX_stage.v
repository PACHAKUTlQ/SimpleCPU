`timescale 1ns / 1ps

module EX_stage (
    input [31:0] ex_pc,
    input [31:0] readData1,
    input [31:0] readData2,
    input [31:0] immGenOut,
    input [2:0] funct3,  // Instruction [14:12]
    input [1:0] ALUOp,
    input i30,  // Instruction [30]
    input ALUSrc,
    input branch,
    input [1:0] jumpType,  // 01: jalr, 10: jal

    output [31:0] ALUResult,
    output [3:0] ALUControl,
    output zeroFlag,
    output reg PCSrc,
    output reg [31:0] jumpOrBranchAddress
);

  wire [31:0] branchAddress;

  assign branchAddress = ex_pc + (immGenOut << 1);

  always @(*) begin
    PCSrc = 0;
    jumpOrBranchAddress = 32'b0;

    if (branch) begin
      $display("Jump or Branch triggered");
      case (jumpType)
        2'b00: begin  // B-type
          $display("B-type: ex_branchAddress = %b", branchAddress);
          $display("zeroFlag: %b", zeroFlag);
          if (zeroFlag) begin
            $display("B-type branch taken");
            PCSrc = 1;
            jumpOrBranchAddress = branchAddress;
          end
        end
        2'b01: begin  // jalr
          $display("jalr: ALUResult = %h", ALUResult);
          PCSrc = 1;
          jumpOrBranchAddress = ALUResult;
        end
        2'b10: begin  // jal
          $display("jal: ex_branchAddress = %b", branchAddress);
          PCSrc = 1;
          jumpOrBranchAddress = branchAddress;
        end
        default: begin
          $display("jumpType error");
        end
      endcase
    end
  end

  ALU alu_inst (
      .readData1(readData1),
      .readData2(readData2),
      .immGenOut(immGenOut),
      .funct3(funct3),
      .ALUOp(ALUOp),
      .i30(i30),
      .ALUSrc(ALUSrc),
      .result(ALUResult),
      .zeroFlag(zeroFlag),
      .ALUControl_out(ALUControl)
  );

endmodule
