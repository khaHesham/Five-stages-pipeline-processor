
module TB;
  localparam W = 16;
  
  reg clk, rst;

  wire [31:0] pc;
  wire [3:0] MEM_signals;
  wire [2:0] WB_signals;
  wire [6:0] EX_signals;
  wire [W-1:0] mux_lines [3:0];
  wire [W-1:0] instr_out, Imm, WD, ALU_out;
  wire [2:0] flags_out;

  Processor processor_inst(clk, rst, pc, instr_out, Imm, EX_signals, MEM_signals, WB_signals, ALU_out, flags_out, mux_lines, WD);
  
  always#50 clk = ~clk;

  initial begin
    clk=1;
    rst=1;
    #100;
    rst=0;

    //$display("clk %d rst %d opcode %d src %d dst %d shiftamount %d regWrite %d WD %d WA_3 %d Rsrc_out_2 %d Rdst_out_2 %d Imm_out_2 %d MEM_signals_out_2 %p EX_signals_out_2 %p WB_signals_out_2,flags_out,ALU_Out_2 %p %d",clk, rst, opcode,src,dst,shiftamount, regWrite, WD, WA_3, Rsrc_out_2, Rdst_out_2,Imm_out_2, MEM_signals_out_2, EX_signals_out_2, WB_signals_out_2,flags_out,ALU_Out_2); 
  end

endmodule