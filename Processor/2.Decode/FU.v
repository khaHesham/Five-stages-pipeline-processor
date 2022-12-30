module FU (src, dst, dst_MEM, dst_WB, WB_MEM, WB_WB, EX_SP_W, MEM_SP_W, WB_SP_W, sel_src, sel_dst);
   
  input [2:0] src, dst, dst_MEM, dst_WB;
  input WB_MEM, WB_WB, MEM_SP_W, WB_SP_W, EX_SP_W;

  output reg [1:0] sel_src, sel_dst;

  always @ (*) begin
    // initializing sel signals to z
    {sel_src, sel_dst} <= 2'bzz;
    
    if (src == dst_MEM||src == dst_WB) sel_src <= 2'b00;
    if (dst == dst_MEM||dst == dst_WB) sel_dst <= 2'b00; 

    if (WB_MEM||WB_WB) sel_src <= 2'b01;
    if (WB_MEM||WB_WB) sel_dst <= 2'b01; 
    
    if (MEM_SP_W||WB_SP_W) sel_src <= 2'b10;
    if (MEM_SP_W||WB_SP_W) sel_dst <= 2'b10;

    // if(src == dst_MEM && WB_MEM) sel_src = 2'b10; //ALU to ALU forwarding
    // else if(src == dst_WB && WB_WB) sel_src = 2'b01; //MEM to ALU forwarding
    // else sel_src = 2'b00; //No forwarding

    // if(dst == dst_MEM && WB_MEM || EX_SP_W && MEM_SP_W) sel_dst = 2'b10; //ALU to ALU forwarding
    // else if(dst == dst_WB && WB_WB) sel_dst = 2'b01; //MEM to ALU forwarding
    // else if(EX_SP_W && WB_SP_W) sel_dst = 2'b11; //MEM to ALU forwading in case of sp
    // else sel_dst = 2'b00; //No forwarding

  end
endmodule
