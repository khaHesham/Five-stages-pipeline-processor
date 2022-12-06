module Memo (clk,rst,Rsrc,Rdst,RD,memRead,memWrite,memAddress,memData);
    // |memRead,memWrite,memAddress,memData| => signals coming from CU.

    localparam W = 16;

    input clk,rst;
    input memRead,memWrite,memData,memAddress;
    input [W-1:0] Rsrc,Rdst;        //*all input data is here

    output [W-1:0] RD;

    wire [10:0] addr;

    assign addr =(memAddress == 1'b1)? Rdst[10:0] : Rsrc[10:0];

    Memory memo(clk, rst, memRead, memWrite, addr, Rsrc, RD);

 
endmodule