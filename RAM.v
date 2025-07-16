`timescale 1ns / 1ps

module RAM (
    input clk,

    input [31:0] address,
    input [31:0] writeData,
    input [2:0] funct3,
    input memRead,
    input memToReg,
    input memWrite,

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

  // Store
  always @(*) begin
    if (memWrite && (address[1:0] == 2'b00) && (address <= (MEM_SIZE - 4))) begin
      case (funct3)
        3'b010: begin  // sw
          $display("sw: address: %h, writeData: %h", address, writeData);
          ram[address+0] <= writeData[7:0];
          ram[address+1] <= writeData[15:8];
          ram[address+2] <= writeData[23:16];
          ram[address+3] <= writeData[31:24];
        end
        3'b000: begin  // sb
          $display("sb: address: %h, writeData: %h", address, writeData[7:0]);
          ram[address] <= writeData[7:0];
        end
      endcase
    end
  end

  // Load
  always @(*) begin
    readData <= 32'h0000_0000;

    if (memRead && (address[1:0] == 2'b00) && (address <= (MEM_SIZE - 4))) begin
      case (funct3)
        3'b010: begin  // lw
          readData <= {ram[address+3], ram[address+2], ram[address+1], ram[address]};
        end
        3'b000: begin  // lb
          readData <= {{24{ram[address][7]}}, ram[address]};
        end
        3'b100: begin  // lbu
          readData <= {{24'b0}, ram[address]};
        end
      endcase
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
