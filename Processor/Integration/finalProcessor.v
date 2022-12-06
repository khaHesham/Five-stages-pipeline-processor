`include "../1.Fetch/Fetch.v"
`include "../2.Decode/Decode.v"

module Processor(clk, rst, regWrite, WD, WA, Rsrc, Rdst,Imm, MEM_signals, EX_signals, WB_signals,flush);
    
    localparam W = 16;
    localparam N = 3;
    localparam F_D_SIZE = W;
    localparam D_E_SIZE = 17+3*W;
    // localparam E_M_SIZE = 17+3*W;
    // localparam M_W_SIZE = 3+2*W;

    input clk, rst, regWrite; //regWrite coming from WB
    input [W-1:0] WD; //WD coming from WB
    input [2:0] WA; 
    
    output [3:0] MEM_signals;   // memRead(1), memWrite(1), memAddress(1), memData(1)
    output [5:0] EX_signals;    // ALUop(4+1enable), shamSelt(1)
    output [2:0] WB_signals;    // regWrite(1), WBsel(2)
    output [W-1:0]  Rsrc, Rdst; //
    output wire flush;
    output [15:0] Imm;
//======================================================================================================================

    wire [3:0] MEM_signals_in;
    wire [5:0] EX_signals_in;
    wire [2:0] WB_signals_in;

    wire [5:0] opcode_out;
    wire [2:0] src_out, dst_out;
    wire [3:0] shiftamount_2;
    wire [15:0] Imm_in, Rsrc_in, Rdst_in, instr_in, instr_out;
    wire [D_E_SIZE-1:0] Decode_in, Decode_out;

    wire [5:0] opcode;
    wire [N-1:0] src; 
    wire [N-1:0] dst;
    wire [3:0] shiftamount;

    fetch FetchStage(clk, rst, opcode, src, dst, shiftamount);

    assign Imm_in = {opcode, src, dst, shiftamount};
    assign instr_in=(flush == 1'b1)? 16'b000101_000_011_0000 : {opcode, src, dst, shiftamount};

    Buffer #(F_D_SIZE) F_D_buffer(clk, rst, 1'b1,instr_in,instr_out );
    assign {opcode_out, src_out, dst_out, shiftamount_2}= instr_out;

    Decode DecodeStage(clk, rst, opcode,src_out, dst_out,shiftamount, regWrite, WD, WA, Rsrc_in, Rdst_in,  MEM_signals_in, EX_signals_in, WB_signals_in,flush);

    assign Decode_in={MEM_signals_in, EX_signals_in, WB_signals_in, Rsrc_in, Rdst_in, shiftamount_2, Imm_in};
    Buffer #(D_E_SIZE) D_E_buffer(clk, rst, 1'b1,Decode_in ,Decode_out);
    assign  {MEM_signals, EX_signals, WB_signals, Rsrc, Rdst, shiftamount,Imm} = Decode_out;

endmodule

// `include "../1.Fetch/Fetch.v"
// `include "../2.Decode/Decode.v"
// `include "../3.Execute/Execute.v"
// `include "../4.Memory/Memo.v"
// `include "../5.WriteBack/WB.v"
// `include "../2.Decode/MUX.v"


// module Processor (clk,rst,flush,B,WD,src_out,dst_out,Rsrc_in,Rdst_in,WA,ALU_Out,RD_in,Imm_in,mux_lines, MEM_signals_in , EX_signals_in , WB_signals_in,WB_signals_out);
//     input clk,rst;
// //===========================  LOCAL PARAMETERS    ================================    
//     localparam W = 16;
//     localparam N = 3;
//     localparam F_D_SIZE = W;
//     localparam D_E_SIZE = 17+2*W;
//     localparam E_M_SIZE = 17+3*W;
//     localparam M_W_SIZE = 3+2*W;

// //=================================================================================
// //========================     FETCH Parameters    ================================

//     wire [5:0] opcode_in,opcode_out;
//     wire [2:0] src_in;
//     output wire [2:0] src_out;
//     output wire [2:0] dst_out;
//     wire [2:0] dst_in;
//     wire [3:0] shiftamount_in,shiftamount_out,shiftamount_out_2;

// //=================================================================================
// //========================     DECODE Parameters    ===============================

//     wire regWrite; //regWrite coming from WB
//     output wire [W-1:0] WD;    //WD coming from WB
//     output wire flush;
//     output wire [W-1:0] Imm_in;
//     wire [W-1:0] Imm_out,Imm_out_2;

//     output wire [3:0] MEM_signals_in;
//     wire [3:0] MEM_signals_out,MEM_signals_out_2; // memRead(1), memWrite(1), memAddress(1), memData(1)
//     output wire [5:0] EX_signals_in;
//     wire [5:0] EX_signals_out,EX_signals_out_2;  // ALUop(4+1enable), shamSelt(1)
//     output wire [2:0] WB_signals_in,WB_signals_out;
//     wire [2:0] WB_signals_out_2,WB_signals_out_3;  // regWrite(1), WBsel(2)
    
//     wire [W-1:0] Rsrc_out;
//     wire [W-1:0] Rdst_out, Rsrc_out_2,Rdst_out_2;
//     output wire [W-1:0] Rsrc_in, Rdst_in;
//     output wire [2:0] WA;
// //================================================================================
// //                |=={*}==|     EXECUTE PARAMETERS    |=={*}==|
//     output wire [15:0] B;
//     output wire [15:0] ALU_Out;
//      wire [15:0] ALU_Out_2;
//     wire [2:0] flags;

// //================================================================================
// //                              MEMORY PARAMETERS
//     output wire [15:0] RD_in;
//     wire [15:0] RD_out;
// //================================================================================
// //                              WRITE_BACK PARAMETERS
//     output wire [W-1:0] mux_lines [3:0];
// //================================================================================
// //                              BUFFERS DATA

//    wire [F_D_SIZE-1:0] instr_in,instr_out;
//    wire [D_E_SIZE-1:0] Decode_in,Decode_out;
//    wire [E_M_SIZE-1:0] Execute_in,Execute_out;
//    wire [M_W_SIZE-1:0] Memory_in,Memory_out;



// //                           


//     //!                                                     🔴 FETCH STAGE 🔴
//     fetch FetchStage(clk,opcode_in,src_in,dst_in,shiftamount_in);
    
//     assign Imm_in = {opcode_in, src_in, dst_in, shiftamount_in};
//     assign instr_in=(flush == 1'b1)? 16'b000101_000_011_0000 : {opcode_in, src_in, dst_in, shiftamount_in};


//     Buffer #(F_D_SIZE) F_D_buffer(clk, rst, 1'b1,instr_in,instr_out );
//     //!                                                      🔴 DECODE STAGE 🔴
//     assign {opcode_out, src_out, dst_out, shiftamount_out}= instr_out;
//     Decode DecodeStage (clk, rst, opcode_out, src_out, dst_out, WB_signals_out_3[2], WD ,WA,Rsrc_in, Rdst_in, MEM_signals_in, EX_signals_in, WB_signals_in,flush);

//     assign Decode_in = {MEM_signals_in, EX_signals_in, WB_signals_in, Rsrc_in, Rdst_in, shiftamount_in, Imm_in};
//     Buffer #(D_E_SIZE) D_E_buffer(clk, rst, 1'b1,Decode_in ,Decode_out);
//     assign  {MEM_signals_out, EX_signals_out, WB_signals_out, Rsrc_out, Rdst_out, shiftamount_out,Imm_out} = Decode_out;
//     //!                                                     🔴 EXECUTE STAGE 🔴

//     assign B=(EX_signals_out[0]==1'b1)? Rdst_out:{12'b000000000000,shiftamount_out};
//     ALU ALU_Stage(Rsrc_out,B,EX_signals_out[1],clk,rst,EX_signals_out[5:2], ALU_Out, flags[2],flags[1],flags[0] );

//     assign Execute_in = {MEM_signals_out, EX_signals_out, WB_signals_out, Rsrc_out, Rdst_out, shiftamount_out,ALU_Out,Imm_out};
//     Buffer #(E_M_SIZE) E_M_buffer(clk, rst, 1'b1,Execute_in,Execute_out);
//     assign {MEM_signals_out_2, EX_signals_out_2, WB_signals_out_2, Rsrc_out_2, Rdst_out_2, shiftamount_out_2,ALU_Out_2,Imm_out_2}=Execute_out;
//     //!                                                     🔴 MEMORY STAGE 🔴

//     Memo MemoryStage(clk,rst,{Rsrc_out_2,Rdst_out_2},RD_in,MEM_signals_out_2[3],MEM_signals_out_2[2],MEM_signals_out_2[1],MEM_signals_out_2[0]);
    
//     assign Memory_in = {WB_signals_out_2,RD_in,ALU_Out_2,Imm_out_2};
//     Buffer #(M_W_SIZE) M_W_buffer(clk, rst, 1'b1,Memory_in ,Memory_out);
//     assign {WB_signals_out_3, mux_lines[0], mux_lines[1],mux_lines[2]}=Memory_out;
//     //!                                                    🔴 WRITE_BACK STAGE 🔴
//     MUX #(W,N-1) WB_Mux(mux_lines,WB_signals_out_3[1:0],WD);
    
// endmodule

