`include "../1.Fetch/Fetch.v"
`include "../2.Decode/Decode.v"
`include "../3.Execute/Execute.v"
`include "../4.Memory/Memo.v"
`include "../5.WriteBack/WB.v"


module Processor (clk,rst);
    input clk,rst;
//===========================  LOCAL PARAMETERS    ================================    
    localparam W = 16;
    localparam N = 3;
    localparam F_D_SIZE = W;
    localparam D_E_SIZE = 17+2*W;
    localparam E_M_SIZE = 17+3*W;
    localparam M_W_SIZE = 3+2*W;

//=================================================================================
//========================     FETCH Parameters    ================================

    wire [5:0] opcode_in,opcode_out;
    wire [2:0] src_in,src_out;
    wire [2:0] dst_in,dst_out;
    wire [3:0] shiftamount_in,shiftamount_out,shiftamount_out_2;

//=================================================================================
//========================     DECODE Parameters    ================================

    wire regWrite; //regWrite coming from WB
    wire [W-1:0] WD;    //WD coming from WB

    wire [3:0] MEM_signals_in, MEM_signals_out,MEM_signals_out_2; // memRead(1), memWrite(1), memAddress(1), memData(1)
    wire [5:0] EX_signals_in, EX_signals_out,EX_signals_out_2;  // ALUop(4+1enable), shamSelt(1)
    wire [2:0] WB_signals_in, WB_signals_out,WB_signals_out_2,WB_signals_out_3;  // regWrite(1), WBsel(2)
    
    wire [W-1:0]  Rsrc_in,Rsrc_out, Rdst_in,Rdst_out, Rsrc_out_2,Rdst_out_2;
    wire [2:0] WA;
//================================================================================
//                |=={*}==|     EXECUTE PARAMETERS    |=={*}==|
    wire [15:0] B;
    wire [15:0] ALU_Out,ALU_Out_2,ALU_Out_3,ALU_Out_4;
    wire [2:0] flags;

//================================================================================
//                              MEMORY PARAMETERS
    wire [15:0] RD_in,RD_out;
//================================================================================




    //*                                                     🔴FETCH STAGE🔴
    fetch FetchStage(clk,opcode_in,src_in,dst_in,shiftamount_in);
    // 
    Register #(F_D_SIZE) F_D_buffer(clk, rst, 1'b1, {opcode_in, src_in, dst_in, shiftamount_in}, {opcode_out, src_out, dst_out, shiftamount_out});
    //                                                      🔴DECODE STAGE🔴 

    Decode DecodeStage(clk, rst, opcode_out, src_out, dst_out, WB_signals_out_3[2], WD ,WA,Rsrc_in, Rdst_in, MEM_signals_in, EX_signals_in, WB_signals_in);
    //

    Register #(D_E_SIZE) D_E_buffer(clk, rst, 1'b1,{MEM_signals_in, EX_signals_in, WB_signals_in, Rsrc_in, Rdst_in, shiftamount_in} ,{MEM_signals_out, EX_signals_out, WB_signals_out, Rsrc_out, Rdst_out, shiftamount_out});
    //*                                                     🔴EXECUTE STAGE🔴

    assign B=(EX_signals_out[0]==1'b1)? Rdst_out:{12'b000000000000,shiftamount_out};
    ALU ALU_Stage(Rsrc_out,B,EX_signals_out[1],clk,rst,EX_signals_out[5:2], ALU_Out, flags[2],flags[1],flags[0] );

    //
    Register #(E_M_SIZE) E_M_buffer(clk, rst, 1'b1,{MEM_signals_out, EX_signals_out, WB_signals_out, Rsrc_out, Rdst_out, shiftamount_out,ALU_Out} ,{MEM_signals_out_2, EX_signals_out_2, WB_signals_out_2, Rsrc_out_2, Rdst_out_2, shiftamount_out_2,ALU_Out_2});
    //                                                      🔴MEMORY STAGE🔴

    Memo MemoryStage(clk,rst,{Rsrc_out_2,Rdst_out_2},RD_in,MEM_signals_out_2[3],MEM_signals_out_2[2],MEM_signals_out_2[1],MEM_signals_out_2[0]);
    // 

    Register #(M_W_SIZE) M_W_buffer(clk, rst, 1'b1,{WB_signals_out_2,RD_in,ALU_Out_2} ,{ WB_signals_out_3, RD_out, ALU_Out_3});
    //*                                                     🔴WRITE_BACK STAGE🔴
    assign WD=(WB_signals_out_3[0])? ALU_Out_3 : RD_out;
 
endmodule