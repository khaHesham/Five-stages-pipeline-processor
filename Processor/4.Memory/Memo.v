module Memo (clk,rst,data_in,RD,memRead,memWrite,memAddress,memData);
    
    localparam W = 16;

    localparam Rdst_start = 0;
    localparam Rdst_end = 15;
    localparam Rsrc_start = 16;
    localparam Rsrc_end = 31;

    input clk,rst;
    input memRead,memWrite,memData,memAddress;
    input [2*W-1:0] data_in;        //*all input data is here


    reg [W-1:0] WD;
    output [W-1:0] RD;
    reg [10:0] addr;

    /*

        ?   |           data_in          |
            | [15:0] Rsrc  - [15:0] Rdst |
            |     31-16    :    15-0     |

    */
    
    always @(*) begin

       if (memAddress) begin 
        addr=data_in[Rdst_end:Rdst_start];
       end else begin
        addr=data_in[Rsrc_end:Rsrc_start];
       end

       if (memData) begin
       WD=data_in[Rdst_end:Rdst_start];
       end else begin
       WD=data_in[Rsrc_end:Rsrc_start];
       end  
    end

    Memory memo(clk, rst, memRead, memWrite, addr, WD, RD);

 
endmodule