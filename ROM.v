`timescale 1ns / 1ps

module ROM (
    input [31:0] address,
    output reg [31:0] instruction
);

  localparam FILENAME = "/path/to/tests/Lab3_testcase.txt";
  localparam MEM_SIZE = 1024;  // In Bytes
  localparam MEM_DEPTH_WORDS = MEM_SIZE / 4;  // 32-bit words

  // Final byte-addressable ROM
  reg [7:0] rom[0:MEM_SIZE-1];

  // Temp word-addressable memory
  reg [31:0] temp_mem[0:MEM_DEPTH_WORDS-1];

  integer i;

  initial begin
    for (i = 0; i < MEM_SIZE; i = i + 1) begin
      rom[i] = 8'h00;
    end

    $display("Initialising ROM from file: %s", FILENAME);
    $readmemb(FILENAME, temp_mem);
    for (i = 0; i < MEM_DEPTH_WORDS; i = i + 1) begin
      // temp_mem[i][31:24] = MSB = rom[i*4 + 3]
      // temp_mem[i][ 7: 0] = LSB = rom[i*4 + 0]
      {rom[i*4+3], rom[i*4+2], rom[i*4+1], rom[i*4+0]} = temp_mem[i];
    end
    $display("ROM initialisation complete.");
  end

  always @(*) begin
    if ((address[1:0] != 2'b00) || (address > (MEM_SIZE - 4))) begin
      instruction = 32'h00000013;  // nop: addi x0, x0, 0 
    end else begin
      // Assemble the 32-bit instruction from 4 bytes in Little-Endian order
      // instruction[31:24] = MSB = rom[address+3]
      // instruction[23:16] =       rom[address+2]
      // instruction[15:8]  =       rom[address+1]
      // instruction[ 7:0]  = LSB = rom[address+0]
      instruction = {rom[address+3], rom[address+2], rom[address+1], rom[address]};
    end
  end

endmodule
