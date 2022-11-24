module DecodeStage(clk, rst, opcode,src,dst, regWrite, WD ,Rsrc, Rdst, MEM_signals, EX_signals, WB_signals);
    
    localparam W = 16;
    localparam N = 3;

    input clk, rst, regWrite; //regWrite coming from WB
    input [W-1:0] WD; //WD coming from WB
    input [5:0] opcode;
    input [N-1:0] src; 
    input [N-1:0] dst;

    output [4:0] MEM_signals; // memRead(1), memWrite(1), memAddress(1), memData(1)
    output [5:0] EX_signals;  // ALUop(4+1enable), shamSelt(1)
    output [2:0] WB_signals;  // regWrite(1), WBsel(2)
    output [W-1:0]  Rsrc, Rdst;

    regFile #(W, N) regFile_inst(clk, rst, regWrite, WD, dst, src, dst, Rsrc, Rdst);

    Control_Unit CU(opcode, MEM_signals, EX_signals, WB_signals);

endmodule
