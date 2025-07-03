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
  SingleCycleProcessor SCP (
      clk,
      rst
  );
  initial begin
    #3 clk = 0;
    forever #half_period clk = ~clk;
  end
  initial begin
    rst = 1;
    #10 rst = 0;
  end
  initial begin
    forever
    #6 begin
      $display("time:", $time);
      $display("PC:%b", SCP.PCOut);
      $display("Inst:%b", SCP.instruction);
      $display("x5(t0):%b", SCP.reg_file_inst.registerFile[5]);
      $display("x6(t1):%b", SCP.reg_file_inst.registerFile[6]);
      $display("x7(t2):%b", SCP.reg_file_inst.registerFile[7]);
      $display("x28(t3):%b", SCP.reg_file_inst.registerFile[28]);
      $display("x29(t4):%b", SCP.reg_file_inst.registerFile[29]);
      $display("x8(s0):%b", SCP.reg_file_inst.registerFile[8]);
      $display("x9(s1):%b", SCP.reg_file_inst.registerFile[9]);
      $display("Mem[0]:%b", {SCP.ram_inst.ramCore.ram[3], SCP.ram_inst.ramCore.ram[2],
                             SCP.ram_inst.ramCore.ram[1], SCP.ram_inst.ramCore.ram[0]});
      $display("Mem[4]:%b", {SCP.ram_inst.ramCore.ram[7], SCP.ram_inst.ramCore.ram[6],
                             SCP.ram_inst.ramCore.ram[5], SCP.ram_inst.ramCore.ram[4]});
    end
  end
  initial #110 $stop;
endmodule
