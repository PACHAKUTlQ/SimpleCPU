`timescale 1ns / 1ps

module WB_stage (
    input [31:0] wb_pc,
    input [31:0] dataFromRAM,
    input [31:0] ALUResult,
    input memToReg,
    input [1:0] jumpType,  // 01: jalr, 10: jal

    output reg [31:0] writeData
);

  always @(*) begin
    if (memToReg) begin
      $display("memToReg is 1, jumpType: %b", jumpType);
      if (jumpType == 2'b00) begin  // lw, lb, lbu
        $display("lw/lb/lbu: dataFromRAM: %h", dataFromRAM);
        writeData = dataFromRAM;
      end else if (jumpType == 2'b01 || jumpType == 2'b10) begin  // jal, jalr
        $display("jal/jalr: wb_pc + 4: %h", wb_pc + 4);
        writeData = wb_pc + 4;
      end else begin
        writeData = 32'b0;
      end
    end else begin
      writeData = ALUResult;
    end
  end

endmodule
