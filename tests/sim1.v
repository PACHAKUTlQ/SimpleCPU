`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UM-SJTU JI
// Engineer: Xu Weiqing
// 
// Create Date: 2022/10/14 21:33:21
// Design Name: 
// Module Name: test1
// Project Name: lab 4
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module sim1;
  parameter half_period = 3;
  reg clk;
  reg rst;
  PipelinedProcessor PP (
      clk,
      rst
  );
  initial begin
    #6 clk = 0;
    forever #half_period clk = ~clk;
  end
  initial begin
    rst = 1;
    #1 rst = 0;
  end
  initial begin
    forever
    #6 begin
      $display("time: %0t", $time);
      $display("PC         : %h", PP.if_stage.PCOut);
      $display("Inst       : %h", PP.if_stage.instruction);
      $display("ra (x1)    : %h", PP.id_stage.reg_file_inst.registerFile[1]);
      $display("sp (x2)    : %h", PP.id_stage.reg_file_inst.registerFile[2]);
      $display("t0 (x5)    : %h", PP.id_stage.reg_file_inst.registerFile[5]);
      $display("t1 (x6)    : %h", PP.id_stage.reg_file_inst.registerFile[6]);
      $display("t2 (x7)    : %h", PP.id_stage.reg_file_inst.registerFile[7]);
      $display("t3 (x28)   : %h", PP.id_stage.reg_file_inst.registerFile[28]);
      $display("t4 (x29)   : %h", PP.id_stage.reg_file_inst.registerFile[29]);
      // $display("Mem[0]:%b", {
      //          PP.mem_stage.ram_inst.ramCore.ram[3], PP.mem_stage.ram_inst.ramCore.ram[2],
      //          PP.mem_stage.ram_inst.ramCore.ram[1], PP.mem_stage.ram_inst.ramCore.ram[0]});
      // $display("Mem[4]:%b", {
      //          PP.mem_stage.ram_inst.ramCore.ram[7], PP.mem_stage.ram_inst.ramCore.ram[6],
      //          PP.mem_stage.ram_inst.ramCore.ram[5], PP.mem_stage.ram_inst.ramCore.ram[4]});
      // $display("EX immGen:%b", PP.ex_stage.immGenOut);
      // $display("EX branchAddress:%b", PP.ex_stage.branchAddress);
      // $display("mem_jumpOrBranchAddress:%b", PP.mem_stage.jumpOrBranchAddress);
      // $display("if_jumpOrBranchAddress:%b", PP.if_stage.jumpOrBranchAddress);
      // $display("id_regWrite:%b", PP.id_ex_reg.id_regWrite);
      // //  $display("id_rd:%b", PP.id_ex_reg.id_rd);
      // $display("ex_regWrite:%b", PP.ex_mem_reg.ex_regWrite);
      // //  $display("ex_rd:%b", PP.ex_mem_reg.ex_rd);
      // $display("mem_regWrite:%b", PP.mem_wb_reg.mem_regWrite);
      // //  $display("mem_rd:%b", PP.mem_wb_reg.mem_rd);
      // $display("wb_regWrite:%b", PP.mem_wb_reg.wb_regWrite);
      // //  $display("wb_rd:%b", PP.mem_wb_reg.wb_rd);
      // $display("WB_stage: jumpType=%h, dataFromRAM=%h, wb_pc=%h, writeData=%h",
      //          PP.wb_stage.jumpType, PP.wb_stage.dataFromRAM, PP.wb_stage.wb_pc,
      //          PP.wb_stage.writeData);
      // $display("wb_writeData:%b", PP.wb_stage.writeData);
      // $display("wb_ALUResult:%b", PP.mem_wb_reg.wb_ALUResult);
      // $display("mem_ALUResult:%b", PP.ex_mem_reg.mem_ALUResult);
      // $display("ex_ALUResult:%b", PP.ex_mem_reg.ex_ALUResult);
      // $display("ALU core inputs: %b, %b", PP.ex_stage.alu_inst.readData1,
      //          PP.ex_stage.alu_inst.aluCore.operand2);
      // $display("reg file inputs: %b, %b", PP.id_stage.reg_file_inst.rs1,
      //          PP.id_stage.reg_file_inst.rs2);
      // $display("reg file outputs: %b, %b", PP.id_stage.reg_file_inst.readData1,
      //          PP.id_stage.reg_file_inst.readData2);
    end
  end
  initial #500 $stop;

endmodule
