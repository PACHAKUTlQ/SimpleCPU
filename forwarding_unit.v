`timescale 1ns / 1ps

module ForwardingUnit (
    input [4:0] if_id_rs1,
    input [4:0] if_id_rs2,
    input [4:0] id_ex_rs1,
    input [4:0] id_ex_rs2,
    input [4:0] ex_mem_rd,
    input [4:0] ex_mem_rs2,
    input [4:0] mem_wb_rd,
    input id_branch,
    input ex_mem_regWrite,
    input ex_mem_memWrite,
    input mem_wb_regWrite,
    input mem_wb_memRead,

    output reg [1:0] forwardALU1,
    output reg [1:0] forwardALU2,
    output reg forwardBranch1,
    output reg forwardBranch2,
    output reg memSrc
);

  always @(*) begin
    forwardALU1 = 2'b00;
    forwardALU2 = 2'b00;
    forwardBranch1 = 1'b0;
    forwardBranch2 = 1'b0;
    memSrc = 1'b0;

    // EX and MEM hazards
    if (ex_mem_regWrite && ex_mem_rd && (ex_mem_rd == id_ex_rs1)) begin  // T7 p19
      forwardALU1 = 2'b10;  // From EX/MEM
    end else if (mem_wb_regWrite && mem_wb_rd && (mem_wb_rd == id_ex_rs1)) begin  // T7 p22
      forwardALU1 = 2'b01;  // From MEM/WB
    end

    if (ex_mem_regWrite && ex_mem_rd && (ex_mem_rd == id_ex_rs2)) begin  // T7 p19
      forwardALU2 = 2'b10;  // From EX/MEM
    end else if (mem_wb_regWrite && mem_wb_rd && (mem_wb_rd == id_ex_rs2)) begin  // T7 p22
      forwardALU2 = 2'b01;  // From MEM/WB
    end

    // Data hazards of 2nd preceding ALU instruction before branch
    if (id_branch && ex_mem_regWrite && ex_mem_rd && (ex_mem_rd == if_id_rs1)) begin  // T8 p18
      forwardBranch1 = 1'b1;  // From EX/MEM
    end

    if (id_branch && ex_mem_regWrite && ex_mem_rd && (ex_mem_rd == if_id_rs2)) begin  // T8 p18
      forwardBranch2 = 1'b1;  // From EX/MEM
    end

    // Load-store hazards
    if (mem_wb_memRead && ex_mem_memWrite && (mem_wb_rd == ex_mem_rs2)) begin  // T7 p42
      memSrc = 1'b1;  // From MEM/WB
    end
  end

endmodule
