
module Processor ();
    input clk,rst;
//===========================  LOCAL PARAMETERS    ================================    
    localparam W = 16;
    localparam N = 3;
    localparam F_D_SIZE = 2*W;
    localparam D_E_SIZE = 18+2*W;
    localparam E_M_SIZE = 2*W;
    localparam M_W_SIZE = 18+3*W;

//=================================================================================
//========================     FETCH Parameters    ================================

    wire [5:0] opcode_in,opcode_out;
    wire [2:0] src_in,src_out;
    wire [2:0] dst_in,dst_out;
    wire [3:0] shiftamount_in,shiftamount_out;

//=================================================================================
//========================     DECODE Parameters    ================================

    wire regWrite; //regWrite coming from WB
    wire [W-1:0] WD;    //WD coming from WB

    wire [4:0] MEM_signals_in, MEM_signals_out; // memRead(1), memWrite(1), memAddress(1), memData(1)
    wire [5:0] EX_signals_in, EX_signals_out;  // ALUop(4+1enable), shamSelt(1)
    wire [2:0] WB_signals_in, WB_signals_out;  // regWrite(1), WBsel(2)
    
    wire [W-1:0]  Rsrc_in,Rsrc_out, Rdst_in,Rdst_out;
//=================================================================================
//========================     EXECUTE PARAMETERS    ==============================
//=================================================================================

    fetch FetchStage(clk,opcode_in,src_in,dst_in,shiftamount_in);
    // 
    Register #(F_D_SIZE) F_D_buffer(clk, rst, 1, {opcode_in, src_in, dst_in, shiftamount_in}, {opcode_out, src_out, dst_out, shiftamount_out});
    // 
    Decode DecodeStage(clk, rst, opcode_out, src_out, dst_out, regWrite, WD ,Rsrc_in, Rdst_in, MEM_signals_in, EX_signals_in, WB_signals_in);
    // 
    Register #(D_E_SIZE) D_E_buffer(clk, rst, 1,{MEM_signals_in, EX_signals_in, WB_signals_in, Rsrc_in, Rdst_in, shiftamount_in} ,{MEM_signals_out, EX_signals_out, WB_signals_out, Rsrc_out, Rdst_out, shiftamount_out});
    //
    ALU ALU_Stage(A,B,ALU_EN,clk,reset,Function_Control, ALU_Out, CarryOut,NegativeFlag,ZeroFlag );
    //
    Register #(E_M_SIZE) E_M_buffer(clk, rst, 1,{MEM_signals_in, EX_signals_in, WB_signals_in, Rsrc_in, Rdst_in, shiftamount_in} ,{MEM_signals_out, EX_signals_out, WB_signals_out, Rsrc_out, Rdst_out, shiftamount_out});
    // 
    Memory MemoryStage(clk,rst,data_in,data_out,WB,memRead,memWrite,memAddress,memData);
    //
    Register #(M_W_SIZE) M_W_buffer(clk, rst, 1,{MEM_signals_in, EX_signals_in, WB_signals_in, Rsrc_in, Rdst_in, shiftamount_in} ,{MEM_signals_out, EX_signals_out, WB_signals_out, Rsrc_out, Rdst_out, shiftamount_out});

    
endmodule