module fetch(
    input clk,
    output [5:0] opcode,
    output [2:0] src,
    output [2:0] dst,
    output [3:0] shiftamount
);
  reg [31:0] pc;
  reg [15:0] memoinst[2*10^6-1:0];
  reg [5:0] opcodetemp;
  reg [2:0] srctemp;
  reg [2:0] dsttemp;
  reg [3:0] shiftamounttemp;

  assign opcode=opcodetemp;
  assign src=srctemp;
  assign dst=dsttemp;
  assign shiftamount=shiftamounttemp;


assign memoinst[0]=16'b0001_001_111_0000;     //ldd r1,r7
assign memoinst[1]=16'b0001_010_110_0000;     //ldd r2,r6
assign memoinst[2]=16'b0101_000_011_0000;     //Nop r0,r3
assign memoinst[3]=16'b0011_010_001_0000;     //add r2,r1
assign memoinst[4]=16'b0100_000_001_0000;     //not r0,r1
assign memoinst[5]=16'b0010_010_001_0000;     //std r2,r1

assign pc=0;
always @(posedge clk)
begin
     $display("pc=%b",pc);
  opcodetemp= memoinst[pc][15:10]; 
  srctemp=memoinst[pc][9:7];
  dsttemp=memoinst[pc][6:4];
  shiftamounttemp=memoinst[pc][3:0];

pc = pc+1;
end
endmodule
