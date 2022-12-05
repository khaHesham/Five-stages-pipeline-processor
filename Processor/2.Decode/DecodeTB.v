
module Decode_TB;

//Inputs
 reg clk,rst;
 reg [15:0] WD;
 wire flush;
 reg [2:0] src;
 reg [2:0] dst;
 wire [15:0] Rsrc,Rdst;  //msh sam3aaaaak
 reg [2:0] WA;

 wire [15:0] Imm;
 wire [3:0] MEM_signals; // memRead(1), memWrite(1), memAddress(1), memData(1)
 wire [5:0] EX_signals;  // ALUop(4+1enable), shamSelt(1)
 wire [2:0] WB_signals;  // regWrite(1), WBsel(2)
 reg regWrite;
 wire [5:0] opcode;
 reg [3:0] shiftamount;

//Outputs
 Processor processor_inst(clk, rst, opcode,src,dst,shiftamount, regWrite, WD, WA, Rsrc, Rdst,Imm, MEM_signals, EX_signals, WB_signals,flush);
   always#50 clk = ~clk;
    initial begin
    clk=1;
    rst=1;

    #100;
    rst=0;
    opcode = 6'b000101;
    regWrite=1;
    WA=3'b000;
    WD=16'hffff;
    src=3'b000;
    dst = 3'b001;

    #300;
    $display("clk %d rst %d opcode %d src %d dst %d shiftamount %d regWrite %d WD %d WA %d Rsrc %d Rdst %d Imm %d MEM_signals %p EX_signals %p WB_signals %p flush %d",clk, rst, opcode,src,dst,shiftamount, regWrite, WD, WA, Rsrc, Rdst,Imm, MEM_signals, EX_signals, WB_signals,flush);
    
    // #100;

    // $display("clk %d rst %d opcode %d src %d dst %d shiftamount %d regWrite %d WD %d WA %d Rsrc %d Rdst %d Imm %d MEM_signals %p EX_signals %p WB_signals %p flush %d",clk, rst, opcode,src,dst,shiftamount, regWrite, WD, WA, Rsrc, Rdst,Imm, MEM_signals, EX_signals, WB_signals,flush);
    // #100;

        
    end

endmodule