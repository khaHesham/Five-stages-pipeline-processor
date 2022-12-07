module Decode(clk, rst, opcode,src,dst,shiftamount, regWrite, WD, WA, Rsrc, Rdst, MEM_signals, EX_signals, WB_signals,flush);
    
    localparam W = 16;
    localparam N = 3;
    // localparam F_D_SIZE = W;
    // localparam D_E_SIZE = 17+3*W;
    // localparam E_M_SIZE = 17+3*W;
    // localparam M_W_SIZE = 3+2*W;

    input clk, rst, regWrite; //regWrite coming from WB
    input [W-1:0] WD; //WD coming from WB
    input [5:0] opcode;
    input [N-1:0] src; 
    input [N-1:0] dst;
    input [2:0] WA; 
    input [3:0] shiftamount;
    
    output [3:0] MEM_signals;   // memRead(1), memWrite(1), memAddress(1), memData(1)
    output [5:0] EX_signals;    // ALUop(4+1enable), shamSelt(1)
    output [2:0] WB_signals;    // regWrite(1), WBsel(2)
    output [W-1:0]  Rsrc, Rdst; //
    output flush;
    //output [15:0] Imm;
    

    // wire [3:0] MEM_signals_in;
    // wire [5:0] EX_signals_in;
    // wire [2:0] WB_signals_in;
    // wire [5:0] opcode_out;
    // wire [2:0] src_out;
    // wire [2:0] dst_out;
    // wire [3:0] shiftamount_2;
    // wire [15:0] Imm_in;
    // wire [15:0] Rsrc_in;
    // wire [15:0] Rdst_in, instr_in, instr_out;
    // wire [D_E_SIZE-1:0] Decode_in, Decode_out;

///////////////////////
    //assign Imm_in = {opcode, src, dst, shiftamount};
    //assign instr_in=(flush == 1'b1)? 16'b000101_000_011_0000 : {opcode, src, dst, shiftamount};

    //Buffer #(F_D_SIZE) F_D_buffer(clk, rst, 1'b1,instr_in,instr_out );
    //assign {opcode_out, src_out, dst_out, shiftamount_2}= instr_out;

    Control_Unit CU(opcode, MEM_signals, EX_signals, WB_signals,flush);
    regFile regFile_inst(clk, rst, regWrite, WD, WA, src, dst, Rsrc, Rdst);

    //assign Decode_in={MEM_signals_in, EX_signals_in, WB_signals_in, Rsrc_in, Rdst_in, shiftamount_2, Imm_in};
    //Buffer #(D_E_SIZE) D_E_buffer(clk, rst, 1'b1,Decode_in ,Decode_out);
    //assign  {MEM_signals, EX_signals, WB_signals, Rsrc, Rdst, shiftamount,Imm} = Decode_out;

endmodule
