module MemoryStage (clk,rst,data_in,data_out,WB,
memRead,memWrite,memAddress,memData);
    
    localparam W = 16;

    localparam Imm_start = 0;
    localparam Imm_end = 15;
    localparam ALU_start = 16;
    localparam ALU_end = 31;
    localparam Rdst_start = 32;
    localparam Rdst_end = 47;
    localparam Rsrc_start = 48;
    localparam Rsrc_end = 61;

    input [2:0] WB;
    input clk,rst;
    input memRead,memWrite,memData,memAddress;
    input [4*W-1:0] data_in;     //!all input data is here
    output [3*W+3-1:0] data_out;   //! put all results here

    reg [W-1:0] WD;
    wire [W-1:0] RD;
    reg [10:0] addr;

    /*
    !   |                       data_in                        |
        | [15:0] Rsrc  - [15:0] Rdst - [15:0] ALU - [15:0] Imm |
        |    61:48     :     47:32   :   31-16    :    15-0    |

    !   |                       data_out                       |
        |   [2:0] WB - [15:0] Imm  - [15:0] ALU - [15:0] mem   |
        |    50:48   : 47:32       :   31-16    :    15-0      |

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

assign data_out={ WB ,data_in[Imm_end:Imm_start] , data_in[ALU_end:ALU_start] , RD };



    
endmodule