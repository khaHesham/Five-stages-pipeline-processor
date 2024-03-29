module Decode(
     clk, rst,
     opcode,interrupt,inst_before_call,src,dst,
     regWrite, WD, WA, Rsrc, Rdst, MEM_signals, EX_signals, 
     WB_signals,flush,branch_signal,detection_signal,sp,sp_value,sp_write_enable, f_d_buffer_enable, pc_enable, jump_sel, out_signal,HAZARD_POP,ret_state_before);
    
  localparam W = 16;
  localparam N = 3;
  localparam STACK_START = 2**11-1;
  localparam NO_RET  =3'b000;
  localparam NO_RTI  =3'b000;

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
  output [12:0] EX_signals;
  output [5:0] WB_signals;   
  output [W-1:0]  Rsrc, Rdst;
  output [15:0]sp; 
  output flush;

  output f_d_buffer_enable, pc_enable;
  output [1:0] jump_sel;
  output out_signal;

  output HAZARD_POP;

  output [2:0] ret_state_before;

  wire [1:0] inter_state_before, inter_state_after; 
  wire [2:0] ret_state_before,ret_state_after; 
  wire [2:0] reti_state_before, reti_state_after;

  wire [6:0] MEM_signals_in;   
  wire [12:0] EX_signals_in;
  wire [5:0] WB_signals_in; 

  wire [31:0]sp_total;
  wire [31:0] out;

   
//states
Register  #(3)return_state(clk, rst, 1'b1, ret_state_after, ret_state_before);
Register  #(2)interrupt_state(clk, rst, 1'b1, inter_state_after, inter_state_before);
Register  #(3)return_interrupt_state(clk, rst, 1'b1, reti_state_after, reti_state_before);
  
signExtend signextended(sp_value, out);
//

Register_neg  #(32, STACK_START)sp_reg(clk, rst, sp_write_enable, out, sp_total);
assign sp=sp_total[15:0];

assign sel = branch_signal || detection_signal;
MUX #(13) mux_1 ( // determins EX_signals
    .in('{ 13'b0000000000000,EX_signals_in }),
    .sel(sel),
    .out(EX_signals)
  );

  MUX #(7) mux_2 ( // determins MEM_signals
    .in('{ 7'b0000000 , MEM_signals_in}),
    .sel(sel),
    .out(MEM_signals)
  );

  MUX #(6) mux_3 ( // determins WB_signals
    .in('{6'b000000 , WB_signals_in}),
    .sel(sel),
    .out(WB_signals)
  );



    Control_Unit cu(opcode,interrupt,inst_before_call,inter_state_before,ret_state_before,reti_state_before,f_d_buffer_enable,pc_enable,flush,jump_sel,MEM_signals_in,EX_signals_in,WB_signals_in,inter_state_after,ret_state_after,reti_state_after, out_signal);
    regFile regFile_inst(clk, rst, regWrite, WD, WA, src, dst, Rsrc, Rdst);

    assign HAZARD_POP = (ret_state_before == NO_RET) && (reti_state_before == NO_RTI);

endmodule