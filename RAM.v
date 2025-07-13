`timescale 1ns / 1ps

module RAM (
    input clk,

    input [31:0] ALUResult,
    input [31:0] writeData,
    input memRead,
    input memToReg,
    input memWrite,

    output [31:0] writeDataReg
);

  wire [31:0] readData;

  RAMCore ramCore (
      .clk(clk),
      .memRead(memRead),
      .memWrite(memWrite),
      .address(ALUResult),
      .writeData(writeData),
      .readData(readData)
  );

  RAMMux ramMux (
      .readData(readData),
      .ALUResult(ALUResult),
      .memToReg(memToReg),
      .writeDataReg(writeDataReg)
  );

endmodule


module RAMCore (
    input clk,
    input memRead,
    input memWrite,
    input [31:0] address,
    input [31:0] writeData,

    output reg [31:0] readData
);

  localparam MEM_SIZE = 128;  // Size in Bytes
  reg [7:0] ram[0:MEM_SIZE-1];
  integer i;

  initial begin
    $display("Initialising RAM");
    for (i = 0; i < MEM_SIZE; i = i + 1) begin
      ram[i] = 8'b0000_0000;
    end
  end

  // Synchronous write Operation
  always @(posedge clk) begin
    // Only write if memWrite is high AND address is word-aligned AND in bounds
    if (memWrite && (address[1:0] == 2'b00) && (address <= (MEM_SIZE - 4))) begin
      // Store the 32-bit writeData into 4 bytes in Little-Endian order
      // writeData[ 7:0]  = LSB -> ram[address+0]
      // writeData[15:8]  =      -> ram[address+1]
      // writeData[23:16] =      -> ram[address+2]
      // writeData[31:24] = MSB -> ram[address+3]
      ram[address+0] <= writeData[7:0];
      ram[address+1] <= writeData[15:8];
      ram[address+2] <= writeData[23:16];
      ram[address+3] <= writeData[31:24];
      // $display("DEBUG RAM: Write Addr=%h, Data=%h", address, writeData);
    end
  end

  // Asynchronous read Operation
  always @(*) begin
    readData = 32'h0000_0000;

    if (memRead && (address[1:0] == 2'b00) && (address <= (MEM_SIZE - 4))) begin
      // Assemble the 32-bit data from 4 bytes in Little-Endian order
      // readData[31:24] = MSB = ram[address+3]
      // readData[23:16] =       ram[address+2]
      // readData[15:8]  =       ram[address+1]
      // readData[ 7:0]  = LSB = ram[address+0]
      readData = {ram[address+3], ram[address+2], ram[address+1], ram[address]};
    end
  end

  // // DEBUG: Store
  // always @(posedge clk) begin
  //   if (memWrite && (address[1:0] == 2'b00) && (address <= (MEM_SIZE - 4))) begin
  //     $display("memWrite is 1, address: %h, writeData: %h", address, writeData);
  //     $display("funct3: %b", funct3);
  //     case (funct3)
  //       3'b010: begin  // sw
  //         $display("sw: address: %h, writeData: %h", address, writeData);
  //       end
  //       3'b000: begin  // sb
  //         $display("sb: address: %h, writeData: %h", address, writeData);
  //       end
  //       default: $display("Unknown funct3 for memWrite: %b", funct3);
  //     endcase
  //   end
  // end

  // // DEBUG: Load
  // always @(posedge clk) begin
  //   if (memRead && (address[1:0] == 2'b00) && (address <= (MEM_SIZE - 4))) begin
  //     $display("memRead is 1, address: %h", address);
  //     $display("funct3: %b", funct3);
  //     case (funct3)
  //       3'b010: begin  // lw
  //         $display("lw: address: %h, readData: %h", address, readData);
  //       end
  //       3'b000: begin  // lb
  //         $display("lb: address: %h, readData: %h", address, readData);
  //       end
  //       3'b100: begin  // lbu
  //         $display("lbu: address: %h, readData: %h", address, readData);
  //       end
  //       default: $display("Unknown funct3 for memRead: %b", funct3);
  //     endcase
  //   end
  // end
endmodule
