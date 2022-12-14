module fetch(
    input clk,
    input rst,
    output [5:0] opcode,
    output [2:0] src,
    output [2:0] dst,
    output [3:0] shamt,
    output [31:0] pc
);
    // 1. LDM R1,0h          000001_001_xxx_0000
    // 2. LDM R2,2h          000001_010_xxx_0000

    // 3. NOP                000001_000_011_0000
    // 4. ADD R2,R1          001011_010_001_0000
    // 5. NOT R1             000100_000_001_0000
    // 6. STD R2,R1          000010_010_001_0000

    reg [15:0] memoinst[2*10^6-1:0];

    initial $readmemb("memory.txt", memoinst);

    Register #(32) pc_inst(clk, rst, 1'b1, pc+1, pc);

    assign {opcode, src, dst, shamt} = memoinst[pc];

endmodule