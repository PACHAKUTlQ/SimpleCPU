`timescale 1ns / 1ps

module ROM (
    input [31:0] address,

    output reg [31:0] instruction
);

  localparam MEM_SIZE = 128;  // Size in Bytes
  reg [7:0] rom[0:MEM_SIZE-1];
  integer i;

  initial begin
    $display("Initialising ROM");
    for (i = 0; i < MEM_SIZE; i = i + 1) begin
      rom[i] = 8'b0000_0000;
    end

    // 0x00: addi t0, x0, -10
    {rom[3], rom[2], rom[1], rom[0]} = 32'hff600293;
    // 0x04: nop (Hazard: add needs t0)
    {rom[7], rom[6], rom[5], rom[4]} = 32'h00000013;
    // 0x08: nop
    {rom[11], rom[10], rom[9], rom[8]} = 32'h00000013;
    // 0x0C: add t1, t0, t0
    {rom[15], rom[14], rom[13], rom[12]} = 32'h00528333;
    // 0x10: nop (Hazard: sub needs t1)
    {rom[19], rom[18], rom[17], rom[16]} = 32'h00000013;
    // 0x14: nop
    {rom[23], rom[22], rom[21], rom[20]} = 32'h00000013;
    // 0x18: sub t2, t0, t1
    {rom[27], rom[26], rom[25], rom[24]} = 32'h406283b3;
    // 0x1C: and t3, t1, x0 (No hazard on t1)
    {rom[31], rom[30], rom[29], rom[28]} = 32'h00037e33;
    // 0x20: or t4, t1, t0
    {rom[35], rom[34], rom[33], rom[32]} = 32'h00536eb3;
    // 0x24: nop (Hazard: sw needs t4)
    {rom[39], rom[38], rom[37], rom[36]} = 32'h00000013;
    // 0x28: nop
    {rom[43], rom[42], rom[41], rom[40]} = 32'h00000013;
    // 0x2C: sw t4, 0(x0)
    {rom[47], rom[46], rom[45], rom[44]} = 32'h01d02023;
    // 0x30: sw t0, 4(x0)
    {rom[51], rom[50], rom[49], rom[48]} = 32'h00502223;
    // 0x34: beq t0, x0, +20 (to 0x48)
    {rom[55], rom[54], rom[53], rom[52]} = 32'h00028a63;
    // 0x38: nop (Branch delay slot)
    {rom[59], rom[58], rom[57], rom[56]} = 32'h00000013;
    // 0x3C: add t4, t1, x0
    {rom[63], rom[62], rom[61], rom[60]} = 32'h00030eb3;
    // 0x40: nop (Hazard: bne needs t4)
    {rom[67], rom[66], rom[65], rom[64]} = 32'h00000013;
    // 0x44: nop
    {rom[71], rom[70], rom[69], rom[68]} = 32'h00000013;
    // 0x48: L1: bne t1, t4, +16 (to 0x58)
    {rom[75], rom[74], rom[73], rom[72]} = 32'h01d31863;
    // 0x4C: nop (Branch delay slot)
    {rom[79], rom[78], rom[77], rom[76]} = 32'h00000013;
    // 0x50: bne t1, t3, +12 (to 0x5C)
    {rom[83], rom[82], rom[81], rom[80]} = 32'h01c31663;
    // 0x54: nop (Branch delay slot)
    {rom[87], rom[86], rom[85], rom[84]} = 32'h00000013;
    // 0x58: error1: add t2, x0, x0
    {rom[91], rom[90], rom[89], rom[88]} = 32'h000003b3;
    // 0x5C: L2: lw s0, 0(x0)
    {rom[95], rom[94], rom[93], rom[92]} = 32'h00002403;
    // 0x60: lw s1, 4(x0)
    {rom[99], rom[98], rom[97], rom[96]} = 32'h00402483;
    // 0x64: nop (Load-use hazard: addi needs s1)
    {rom[103], rom[102], rom[101], rom[100]} = 32'h00000013;
    // 0x68: nop
    {rom[107], rom[106], rom[105], rom[104]} = 32'h00000013;
    // 0x6C: addi s1, s1, 8
    {rom[111], rom[110], rom[109], rom[108]} = 32'h00848493;
    // 0x70: nop (Hazard: beq needs s1)
    {rom[115], rom[114], rom[113], rom[112]} = 32'h00000013;
    // 0x74: nop
    {rom[119], rom[118], rom[117], rom[116]} = 32'h00000013;
    // 0x78: beq s0, s1, +12 (to 0x84)
    {rom[123], rom[122], rom[121], rom[120]} = 32'h00940663;
    // 0x7C: nop (Branch delay slot)
    {rom[127], rom[126], rom[125], rom[124]} = 32'h00000013;
    // 0x80: error2: add t2, x0, x0
    {rom[131], rom[130], rom[129], rom[128]} = 32'h000003b3;
    // 0x84: L3: add t2, t2, t2
    {rom[135], rom[134], rom[133], rom[132]} = 32'h007383b3;
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
