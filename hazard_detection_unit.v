`timescale 1ns / 1ps

module HazardDetectionUnit (
    input [4:0] if_id_rs1,
    input [4:0] if_id_rs2,
    input [4:0] id_ex_rd,
    input [4:0] ex_mem_rd,
    input id_branch,
    input if_id_memWrite,
    input id_ex_regWrite,
    input id_ex_memRead,
    input ex_mem_memRead,
    input [1:0] jumpType,  // 01: jalr, 10: jal
    input branchTaken,

    output reg PCWrite,
    output reg if_idWrite,
    output reg controlFlush,
    output reg ifFlush
);

  wire is1ALUHazard;
  wire is2LoadHazard;
  wire is1LoadHazard;

  // Data hazards of immediately preceding ALU instruction before branch
  assign is1ALUHazard = id_branch && id_ex_regWrite && id_ex_rd && ((id_ex_rd == if_id_rs1) || (id_ex_rd == if_id_rs2));

  // Data hazards of 2nd preceding load instruction before branch
  assign is2LoadHazard = id_branch && ex_mem_memRead && ex_mem_rd && ((ex_mem_rd == if_id_rs1) || (ex_mem_rd == if_id_rs2));

  // Load-use hazards: immediately preceding load instruction before branch
  assign is1LoadHazard = id_ex_memRead && !if_id_memWrite && ((id_ex_rd == if_id_rs1) || (id_ex_rd == if_id_rs2));

  always @(*) begin
    PCWrite = 1'b1;
    if_idWrite = 1'b1;
    controlFlush = 1'b0;
    ifFlush = 1'b0;

    if (is1ALUHazard || is2LoadHazard || is1LoadHazard) begin
      PCWrite = 1'b0;
      if_idWrite = 1'b0;
      controlFlush = 1'b1;
    end else if (jumpType || (id_branch && branchTaken)) begin
      $display("IF Flush: ", ifFlush);
      ifFlush = 1'b1;
    end
  end

endmodule
