module TB;
  localparam T = 100;
  localparam W = 16;
  localparam EX_SIGS_SIZE = 13;
  localparam MEM_SIGS_SIZE = 7;
  localparam WB_SIGS_SIZE = 6;
  
  reg clk, rst, interrupt;
  reg [W-1:0] in_port;

  wire [31:0] pc;
  wire [MEM_SIGS_SIZE-1:0] MEM_signals;
  wire [WB_SIGS_SIZE-1:0] WB_signals;
  wire [EX_SIGS_SIZE-1:0] EX_signals;

  wire [W-1:0] instr, imm, WD, ALU, out_port;
  wire [2:0] flags;

  wire WB_SEL;
  wire [W-1:0]sp;

  // TODO: to be removed
  wire [3:0] shamt_1;
  wire HAZARD_POP;
  wire [2:0] ret_state_before;
  wire [31:0] ret_address;
  wire [15:0] Rsrc_2;
  wire [1:0] FU_src_sel;
  wire [2:0] FLAGS_OLD;
  Processor processor_inst(clk, rst, interrupt, in_port, out_port, pc, imm, EX_signals, MEM_signals, WB_signals, ALU, flags,instr, WD,WB_SEL,Rsrc_2, sp,shamt_1,HAZARD_POP,ret_state_before,ret_address,FU_src_sel,FLAGS_OLD);
  
  always #(T/2) clk = ~clk;

  initial begin
    clk=1;
    rst=1;
    #100;
    rst=0;
  end

endmodule