module fetch(
    input clk,
    input rst,
    output [5:0] opcode,
    output [2:0] src,
    output [2:0] dst,
    output [3:0] shiftamount
);
  wire [31:0] pc;
  reg [15:0] memoinst[2*10^6-1:0];
//   reg [5:0] opcodetemp;
//   reg [2:0] srctemp;
//   reg [2:0] dsttemp;
//   reg [3:0] shiftamounttemp;

//   assign opcode=opcodetemp;
//   assign src=srctemp;
//   assign dst=dsttemp;
//   assign shiftamount=shiftamounttemp;

//   integer i;

 initial $readmemb("D:/GITHUB/Five-stages-pipeline-processor-/Processor/1.Fetch/memory.txt",memoinst);
 
// assign memoinst[0]=16'b010001_001_111_0000;     //ld r1,r7  i->01
// assign memoinst[1]=16'b010001_010_110_0000;     //ldd r2,r6  i->01
// assign memoinst[2]=16'b000101_000_011_0000;     //Nop r0,r3  r->00
// assign memoinst[3]=16'b000011_010_001_0000;     //add r2,r1  r->00
// assign memoinst[4]=16'b000100_000_001_0000;     //not r0,r1  r->00
// assign memoinst[5]=16'b010010_010_001_0000;     //std r2,r1  i->01


// 1. LDM R1,0h          000001_001_xxx_0000
// 2. LDM R2,2h          000001_010_xxx_0000

// 3. NOP                000001_000_011_0000
// 4. ADD R2,R1          001011_010_001_0000
// 5. NOT R1             000100_000_001_0000
// 6. STD R2,R1          000010_010_001_0000

//assign pc=0;
Register #(32) pc_inst(clk, rst, 1'b1, pc+1, pc);
// always @(posedge clk)
// begin
//      //  $display("pc=%b",pc);
//   opcodetemp= memoinst[pc][15:10]; 
//       // $display("opcode=%b",opcodetemp);
//   srctemp=memoinst[pc][9:7];
//       // $display("srctemp=%b",srctemp);
//   dsttemp=memoinst[pc][6:4];
//      //  $display("dsttemp=%b",dsttemp);
//   shiftamounttemp=memoinst[pc][3:0];
//     //   $display("shiftamounttemp=%b",shiftamounttemp);
// pc = pc+1;
// end
assign opcode= memoinst[pc][15:10]; 
    // $display("opcode=%b",opcode);
assign src=memoinst[pc][9:7];
    // $display("src=%b",src);
assign dst=memoinst[pc][6:4];
    //  $display("dst=%b",dst);
assign shiftamount=memoinst[pc][3:0];
endmodule