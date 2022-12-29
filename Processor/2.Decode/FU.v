module forwarding_EXE (src_address,dest_address_current,
                        dest_MEM,dest_WB,WB_MEM, 
                        WB_WB,MEM_SP_W,WB_SP_W, sel_src, sel_dst);
  
  
  input [2:0] src_address, dest_address_current,dest_MEM,dest_WB;
  input WB_MEM, WB_WB, MEM_SP_W, WB_SP_W;
  output reg [1:0] sel_src, sel_dst;

  always @ ( * ) begin
    // initializing sel signals to z
    {sel_src, sel_dst} <= 2'bzz;
    
    
    if (src_address == dest_MEM||src_address == dest_WB) sel_src <= 2'b00;
    if (dest_address_current == dest_MEM||dest_address_current == dest_WB) sel_dst <= 2'b00; 


    if (WB_MEM||WB_WB) sel_src <= 2'b01;
    if (WB_MEM||WB_WB) sel_dst <= 2'b01;
    
    
    if (MEM_SP_W||WB_SP_W) sel_src <= 2'b10;
    if (MEM_SP_W||WB_SP_W) sel_dst <= 2'b10;
   
  end
endmodule