`include "../1.Fetch/Fetch.v"
`include "../2.Decode/Decode.v"
`include "../3.Execute/ExecuteStage.v"
`include "../4.Memory/Memo.v"
`include "../5.WriteBack/WB.v"

module Processor(clk, rst, interrupt, in_port, out_port, pc, imm, EX_signals, MEM_signals, WB_signals, ALU_out, flags,instr, WD,WB_SEL,Rsrc_2, sp,shamt_1,HAZARD_POP,ret_state_before,ret_address,FU_src_sel,FLAGS_OLD);
    
//====================================================CONSTANTS=======================================================
    localparam W = 16;
    localparam N = 3;
    localparam SIZE = 11;

    localparam EX_SIGS_SIZE = 13;
    localparam MEM_SIGS_SIZE = 7;
    localparam WB_SIGS_SIZE = 6;

    localparam F_D_SIZE = 6*W + 1 + 1;
    localparam D_E_SIZE = 9*W + EX_SIGS_SIZE + MEM_SIGS_SIZE + WB_SIGS_SIZE + 10 + 1;
    localparam E_M_SIZE = 8*W + MEM_SIGS_SIZE + WB_SIGS_SIZE + 6 + 1;
    localparam M_W_SIZE = 2*W + WB_SIGS_SIZE + 3 + 1;

//=====================================================INPUTS&OUTPUTS=================================================
    input clk, rst, interrupt;
    input [W-1: 0] in_port;

    output WB_SEL;
    output[W-1:0] instr;


    output [31:0] pc;
    output [MEM_SIGS_SIZE-1:0] MEM_signals;
    output [WB_SIGS_SIZE-1:0] WB_signals;
    output [EX_SIGS_SIZE-1:0] EX_signals;
    output [W-1:0] imm, WD, ALU_out, out_port;
    output [2:0] flags;
    output [W-1:0] sp;

    // TODO: clear this shit after testing

    output [3:0] shamt_1;
    output HAZARD_POP;
    output [2:0] ret_state_before;
    output [31:0] ret_address;
    output [15:0] Rsrc_2;
    output [1:0]FU_src_sel;

    output [2:0] FLAGS_OLD;

    
   
//=======================================================WIRES========================================================
    //signals
    wire ALU_EN, FLAGS_EN, CALL, MEM_READ, MEM_WRITE, WB_SEL, REG_WRITE, SP_WRITE, FLAGS_WRITE;
    wire FLUSH, BRANCH, PC_ENB, F_D_ENB;
    wire RDST_SEL;
    wire [1:0] RSRC_SEL, MEM_ADDR_SEL, POP_L_H, JUMP_SEL;
    wire [2:0] BRANCH_TYPE, MEM_DATA_SEL;
    wire [3:0] ALU_OP;

    wire [EX_SIGS_SIZE-1:0] EX_signals, EX_signals_1;   
    wire [MEM_SIGS_SIZE-1:0] MEM_signals, MEM_signals_1, MEM_signals_2;
    wire [WB_SIGS_SIZE-1:0] WB_signals, WB_signals_1, WB_signals_2, WB_signals_3;
    wire out_signal, out_signal_1, out_signal_2, out_signal_3;

    wire interrupt_1;
    wire [W-1:0] instr;
    wire [5:0] opcode;
    wire [3:0] shamt, shamt_1, shamt_2;
    wire [N-1:0] src, src_1; 
    wire [N-1:0] dst, dst_1, dst_2, dst_3;
    wire [W-1:0] Rsrc, Rdst, Rsrc_1, Rdst_1, Rsrc_2, Rdst_2, Rsrc_3, Rdst_3;
    wire [W-1:0] imm, imm_1, imm_2, in_port_1,in_port_2;
    wire [W-1:0] sp, sp_1, sp_2,sp_3;
    wire [2*W-1:0] pc, pc_1, pc_2, pc_3, pc_plus, pc_plus_1, pc_plus_2, pc_plus_3;

    wire [W-1:0] ALU_out, ALU_out_1, ALU_out_2;
    wire [2:0] flags, flags_1;

    wire [W-1:0] mux_lines [3:0];
    wire [W-1:0] RD, RD_1, WD;
    wire [2:0] WA; 

    wire [F_D_SIZE-1:0] Fetch_in, Fetch_out;
    wire [D_E_SIZE-1:0] Decode_in, Decode_out;
    wire [E_M_SIZE-1:0] Execute_in, Execute_out;
    wire [M_W_SIZE-1:0] Memory_in, Memory_out;

    wire [1:0] FU_src_sel;
    wire [1:0] FU_dst_sel;

    wire HAZARD_POP;

    

//=======================================================FETCH STAGE====================================================
    fetch FetchStage(clk, rst, Rdst, Rdst_1, WD, BRANCH, FLUSH, PC_ENB && PC_ENB_CU , POP_L_H, JUMP_SEL, instr, imm, pc, pc_plus,ret_address);

    assign Fetch_in = {interrupt, instr, pc, pc_plus, in_port};
//======================================================================================================================
    Buffer #(F_D_SIZE) F_D_buffer(clk, rst, F_D_ENB_CU && F_D_ENB, Fetch_in, Fetch_out);
//=======================================================DECODE STAGE===================================================
    assign {interrupt_1, opcode, src, dst, shamt, pc_1, pc_plus_1, in_port_1} = Fetch_out;

    HDU hdu_inst(src, dst, dst_1, MEM_signals_1[6], F_D_ENB, PC_ENB, FLUSH_LOAD_USE,HAZARD_POP);

    Decode DecodeStage (clk, rst, opcode, interrupt_1, CALL, src, dst, REG_WRITE, WD, WA, Rsrc, Rdst, MEM_signals, EX_signals, WB_signals,
        FLUSH, BRANCH, FLUSH_LOAD_USE, sp, ALU_out_2, SP_WRITE, F_D_ENB_CU, PC_ENB_CU, JUMP_SEL, out_signal,HAZARD_POP,ret_state_before);

    assign Decode_in = {MEM_signals, EX_signals, WB_signals, Rsrc, Rdst, src, dst, shamt, imm, sp, in_port_1, pc_1, pc_plus_1, out_signal};
//======================================================================================================================
    Buffer #(D_E_SIZE) D_E_buffer(clk, rst, 1'b1, Decode_in, Decode_out);
//=======================================================EXECUTE STAGE==================================================
    assign  {MEM_signals_1, EX_signals_1, WB_signals_1, Rsrc_1, Rdst_1, src_1, dst_1, shamt_1, imm_1, sp_1, in_port_2, pc_2, pc_plus_2, out_signal_1} = Decode_out;
    
    assign {BRANCH_TYPE, CALL, ALU_OP, RSRC_SEL, RDST_SEL, FLAGS_EN, ALU_EN} = EX_signals_1;


    ExecuteStage letsCompute (clk, rst, EX_signals_1, FU_src_sel, FU_dst_sel, FLAGS_WRITE, Rsrc_1, Rdst_1, shamt_1, imm_1, sp_1, in_port_2, ALU_out_1, WD,ALU_out_2,ALU_out, flags,sp_2, Rsrc_2, Rdst_2,FLAGS_OLD);

    Branch jmp_Handler(BRANCH_TYPE,flags,BRANCH);

    FU fu (src_1, dst_1, dst_2, WA, WB_signals_2[0], REG_WRITE, WB_signals_1[5], WB_signals_2[5], SP_WRITE, FU_src_sel, FU_dst_sel);

    assign Execute_in = {MEM_signals_1, WB_signals_1, Rsrc_2, Rdst_2, dst_1, ALU_out, flags, sp_2, pc_2, pc_plus_2, out_signal_1};
//======================================================================================================================
    Buffer #(E_M_SIZE) E_M_buffer(clk, rst, 1'b1, Execute_in, Execute_out);
//=======================================================MEMORY STAGE===================================================
    assign {MEM_signals_2, WB_signals_2, Rsrc_3, Rdst_3, dst_2, ALU_out_1, flags_1, sp_3, pc_3, pc_plus_3, out_signal_2} = Execute_out;
    
    assign {MEM_READ, MEM_WRITE, MEM_ADDR_SEL, MEM_DATA_SEL} = MEM_signals_2;

    Memo memoryStage (clk, rst, MEM_READ, MEM_WRITE, MEM_ADDR_SEL, MEM_DATA_SEL, Rsrc_3, Rdst_3, ALU_out_1, sp_3, pc_3, pc_plus_3, flags_1, RD);

    assign Memory_in = {WB_signals_2, RD, ALU_out_1, dst_2, out_signal_2};
//======================================================================================================================
    Buffer #(M_W_SIZE) M_E_buffer(clk, rst, 1'b1, Memory_in, Memory_out);
//=======================================================WB STAGE=======================================================
    assign {WB_signals_3, RD_1, ALU_out_2, WA, out_signal_3} = Memory_out;

    assign {SP_WRITE, FLAGS_WRITE, WB_SEL, POP_L_H, REG_WRITE} = WB_signals_3;

    MUX #(W) WB_Mux('{RD_1, ALU_out_2}, WB_SEL, WD);

    assign out_port = out_signal_3? WD: 16'bz;
//======================================================================================================================

endmodule
