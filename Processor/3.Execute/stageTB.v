
module stageTB;
  
  reg [15:0] Rsrc,Rdst;
  reg [3:0] shiftamount;
  reg clk,rst;
  reg [13:0] EX;
  reg [1:0] FU_Src_Sel;
  reg [1:0] FU_Dst_Sel;
  reg flags_wb;
  reg [15:0] Immediate;
  reg [15:0] SP_Low;
  reg [15:0] IN_PORT;
  reg [15:0] ALU_After_E_M;
  reg [15:0] WB;


  wire [15:0] ALU_Result;
  wire [15:0] flags_out;

  ExecuteStage letsCompute (clk,rst,EX,FU_Src_Sel,FU_Dst_Sel,flags_wb,Rsrc,Rdst,shiftamount,Immediate,SP_Low,IN_PORT,ALU_After_E_M,WB,ALU_Result,flags_out);
    always#50 clk = ~clk;
  initial begin

    rst=1;
    clk=1;

    #100;
     rst=0;
    EX=14'b0000_0010_000011;
    Rsrc = 10;
    Rdst = 20; 
    FU_Dst_Sel=0;
    FU_Src_Sel=0;
    

  end

endmodule