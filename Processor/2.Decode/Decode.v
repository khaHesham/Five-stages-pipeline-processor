module Decode(
     clk, rst,
     opcode,interrupt,inst_before_call,src,dst,
     regWrite, WD, WA, Rsrc, Rdst, MEM_signals, EX_signals, 
     WB_signals,flush,branch_signal,detection_signal,sp,sp_value,sp_write_enable, f_d_buffer_enable, pc_enable, jump_sel);
    
    localparam W = 16;
    localparam N = 3;

    input clk, rst, regWrite, interrupt,inst_before_call,sp_write_enable; //regWrite coming from WB
    input [W-1:0] WD; //WD comingg from WB
    input [5:0] opcode;
    input [N-1:0] src; 
    input [N-1:0] dst;
    input [2:0] WA; 
    input branch_signal;
    input detection_signal;
    input [15:0]sp_value;//stack value to be extended
    
    output [6:0] MEM_signals;   
    output [13:0] EX_signals;
    output [5:0] WB_signals;   
    output [W-1:0]  Rsrc, Rdst;
    output [15:0]sp; 
    output flush;

    output f_d_buffer_enable, pc_enable;
    output [1:0] jump_sel;

   wire inter_state_before; 
   wire ret_state_before; 
   wire reti_state_before; 
   wire inter_state_after;
   wire ret_state_after;
   wire reti_state_after;

    wire [6:0] MEM_signals_in;   
    wire [13:0] EX_signals_in;
    wire [5:0] WB_signals_in; 

    wire [31:0]sp_total;
   
//states
Register_neg  #(3)return_state(clk, rst, 1, ret_state_after, ret_state_before);
Register_neg  #(2)interrupt_state(clk, rst, 1, inter_state_after, inter_state_before);
Register_neg  #(3)return_interrupt_state(clk, rst, 1, reti_state_after, reti_state_before);
  
//
signExtend signextended(sp_value, out);
//
assign sp=sp_total[15:0];
Register_neg  #(32)sp_reg(clk, rst, sp_write_enable, out, sp);

assign sel = branch_signal || detection_signal;
mux #(14,1) mux_1 ( // determins EX_signals
    .in1(EX_signals_in),
    .in2(14'b00000000000000),
    .sel(sel),
    .out(EX_signals)
  );

  mux #(7,1) mux_2 ( // determins MEM_signals
    .in1(MEM_signals_in),
    .in2(7'b0000000),
    .sel(sel),
    .out(MEM_signals)
  );

  mux #(6,1) mux_3 ( // determins WB_signals
    .in1(WB_signals_in),
    .in2(6'b000000),
    .sel(sel),
    .out(WB_signals)
  );



    Control_Unit cu(opcode,interrupt,inst_before_call,inter_state_before,ret_state_before,reti_state_before,f_d_buffer_enable,pc_enable,flush,jump_sel,MEM_signals,EX_signals,WB_signals,inter_state_after,ret_state_after,reti_state_after);
    regFile regFile_inst(clk, rst, regWrite, WD, WA, src, dst, Rsrc, Rdst);

endmodule