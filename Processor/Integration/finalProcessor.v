`include "../1.Fetch/Fetch.v"
`include "../2.Decode/Decode.v"
`include "../3.Execute/Execute.v"
`include "../4.Memory/Memo.v"
`include "../5.WriteBack/WB.v"

module Processor(clk, rst, pc, instr_out, Imm, EX_signals, MEM_signals, WB_signals, ALU_out, flags_out, mux_lines, WD);
    
//====================================================CONSTANTS=======================================================
    localparam W = 16;
    localparam N = 3;
    localparam SIZE = 11;
    localparam F_D_SIZE = W;
    localparam D_E_SIZE = 3*W + 20;
    localparam E_M_SIZE = 4*W + 10;
    localparam M_W_SIZE = 3*W + 6;
//=====================================================INPUTS&OUTPUTS=================================================
    input clk, rst;

    output [31:0] pc;
    output [3:0] MEM_signals;
    output [2:0] WB_signals;
    output [6:0] EX_signals;
    output [W-1:0] mux_lines [3:0];
    output [W-1:0] instr_out, Imm, WD, ALU_out;
    output [2:0] flags_out;
//=======================================================WIRES========================================================

    wire [6:0] EX_signals, EX_signals_1;   
    wire [3:0] MEM_signals, MEM_signals_1, MEM_signals_2; // MEM_READ(1), MEM_WRITE(1), MEM_ADDR(1), MEM_DATA(1)
    wire [2:0] WB_signals, WB_signals_1, WB_signals_2, WB_signals_3;// REG_WRITE(1), WB_SEL(2), 
    wire MEM_READ, MEM_WRITE, MEM_ADDR, MEM_DATA, ALU_EN, SHAMT_SEL, FLAGS_EN, REG_WRITE, FLUSH;
    wire [1:0] WB_SEL;
    wire [3:0] ALU_OP;

    wire [W-1:0] instr_in, instr_out;
    wire [5:0] opcode, opcode_1;
    wire [3:0] shamt, shamt_1, shamt_2;
    wire [N-1:0] src, src_1; 
    wire [N-1:0] dst, dst_1, dst_2, dst_3;
    wire [W-1:0] Rsrc, Rdst, Rsrc_1, Rdst_1, Rsrc_2, Rdst_2;
    wire [W-1:0] Imm, Imm_1, Imm_2;

    wire [W-1:0] B;
    wire [W-1:0] ALU_out, ALU_out_1;
    wire [2:0] flags, flags_out;

    //wire [W-1:0] mux_lines [3:0];
    wire [W-1:0] RD, WD;
    wire [2:0] WA; 

    wire [D_E_SIZE-1:0] Decode_in, Decode_out;
    wire [E_M_SIZE-1:0] Execute_in, Execute_out;
    wire [M_W_SIZE-1:0] Memory_in, Memory_out;


//=======================================================FETCH STAGE====================================================
    fetch FetchStage(clk, rst, opcode, src, dst, shamt, pc);

    assign Imm = {opcode, src, dst, shamt};
    assign instr_in = (FLUSH == 1'b1)? 16'b0000010000110000 : {opcode, src, dst, shamt};
//======================================================================================================================
    Buffer #(F_D_SIZE) F_D_buffer(clk, rst, 1'b1, instr_in, instr_out );
//=======================================================DECODE STAGE===================================================
    assign {opcode_1, src_1, dst_1, shamt_1} = instr_out;

    Decode DecodeStage(clk, rst, opcode_1, src_1, dst_1, shamt_1, REG_WRITE, WD, WA, Rsrc,
     Rdst, MEM_signals, EX_signals, WB_signals, FLUSH);

    assign Decode_in = {MEM_signals, EX_signals, WB_signals, Rsrc, Rdst, shamt_1, Imm, dst_1};
//======================================================================================================================
    Buffer #(D_E_SIZE) D_E_buffer(clk, rst, 1'b1, Decode_in, Decode_out);
//=======================================================EXECUTE STAGE==================================================
    assign  {MEM_signals_1, EX_signals_1, WB_signals_1, Rsrc_1, Rdst_1, shamt_2, Imm_1, dst_2} = Decode_out;
    assign {ALU_OP, ALU_EN, SHAMT_SEL, FLAGS_EN} = EX_signals_1;

    assign B = (SHAMT_SEL==1'b0)? Rdst_1 : {12'b000000000000, shamt_2};

    Register_neg #(3) flags_inst(clk, rst, FLAGS_EN, flags, flags_out);
    ALU ALU_Stage(Rsrc_1, B, ALU_EN, ALU_OP, ALU_out, flags[2], flags[1], flags[0]);

    assign Execute_in = {MEM_signals_1, WB_signals_1, Rsrc_1, Rdst_1, ALU_out, Imm_1, dst_2};
//======================================================================================================================
    Buffer #(E_M_SIZE) E_M_buffer(clk, rst, 1'b1, Execute_in, Execute_out);
//=======================================================MEMORY STAGE===================================================
    assign {MEM_signals_2, WB_signals_2, Rsrc_2, Rdst_2, ALU_out_1, Imm_2, dst_3} = Execute_out;
    assign {MEM_READ, MEM_WRITE, MEM_ADDR, MEM_DATA} = MEM_signals_2;

    Memo memoryStage (clk, rst, Rsrc_2, Rdst_2, RD, MEM_READ, MEM_WRITE, MEM_ADDR, MEM_DATA);

    assign Memory_in = {WB_signals_2, RD, ALU_out_1, Imm_2, dst_3};
//======================================================================================================================
    Buffer #(M_W_SIZE) M_E_buffer(clk, rst, 1'b1, Memory_in, Memory_out);
//=======================================================WB STAGE=======================================================
    assign {WB_signals_3, mux_lines[0], mux_lines[1], mux_lines[2], WA} = Memory_out;
    assign {REG_WRITE, WB_SEL} = WB_signals_3;

    MUX #(W,N-1) WB_Mux(mux_lines, WB_SEL, WD);

endmodule
