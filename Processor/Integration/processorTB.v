module processor_TB;

//Inputs
 reg clk,rst;
 wire [15:0] B;
 wire [15:0] WD;
 wire flush;
 wire [2:0] src_out;
 wire [2:0] dst_out;
 wire [15:0] Rsrc_in,Rdst_in;  //msh sam3aaaaak
 wire [2:0] WA;
 wire [15:0] ALU_Out;
 wire [15:0] RD_in;
 wire [15:0] Imm_in;
 wire [15:0] mux_lines [3:0];
 wire [3:0] MEM_signals_in; // memRead(1), memWrite(1), memAddress(1), memData(1)
 wire [5:0] EX_signals_in;  // ALUop(4+1enable), shamSelt(1)
 wire [2:0] WB_signals_in;  // regWrite(1), WBsel(2)
 wire [2:0] WB_signals_in_final;  // regWrite(1), WBsel(2)

//Outputs

 Processor core_1(clk,rst,flush,B,WD,src_out,dst_out,Rsrc_in,Rdst_in,WA,ALU_Out,RD_in,Imm_in,mux_lines, MEM_signals_in , EX_signals_in , WB_signals_in,WB_signals_in_final);
   always#100 clk = ~clk;
    initial begin
    clk=0;
    rst=1;

    #100;
    rst=0;
    $display("clk %d rst %d flush %d B %d WD %d src_out %d dst_out %d Rsrc_in %d WA %d ALU_Out %d RD_in %d Imm_in %d mux_lines %d MEM_signals_in %p EX_signals_in %p WB_signals_in %p WB_signals_in_final %p",clk,rst,flush,B,WD,src_out,dst_out,Rsrc_in,Rdst_in,WA,ALU_Out,RD_in,Imm_in,mux_lines, MEM_signals_in , EX_signals_in , WB_signals_in,WB_signals_in_final);    
    #100;
    $display("clk %d rst %d flush %d B %d WD %d src_out %d dst_out %d Rsrc_in %d WA %d ALU_Out %d RD_in %d Imm_in %d mux_lines %d MEM_signals_in %p EX_signals_in %p WB_signals_in %p WB_signals_in_final %p",clk,rst,flush,B,WD,src_out,dst_out,Rsrc_in,Rdst_in,WA,ALU_Out,RD_in,Imm_in,mux_lines, MEM_signals_in , EX_signals_in , WB_signals_in,WB_signals_in_final);    

    #100;
    $display("clk %d rst %d flush %d B %d WD %d src_out %d dst_out %d Rsrc_in %d WA %d ALU_Out %d RD_in %d Imm_in %d mux_lines %d MEM_signals_in %p EX_signals_in %p WB_signals_in %p WB_signals_in_final %p",clk,rst,flush,B,WD,src_out,dst_out,Rsrc_in,Rdst_in,WA,ALU_Out,RD_in,Imm_in,mux_lines, MEM_signals_in , EX_signals_in , WB_signals_in,WB_signals_in_final);    
    
    #100;
    $display("clk %d rst %d flush %d B %d WD %d src_out %d dst_out %d Rsrc_in %d WA %d ALU_Out %d RD_in %d Imm_in %d mux_lines %d MEM_signals_in %p EX_signals_in %p WB_signals_in %p WB_signals_in_final %p",clk,rst,flush,B,WD,src_out,dst_out,Rsrc_in,Rdst_in,WA,ALU_Out,RD_in,Imm_in,mux_lines, MEM_signals_in , EX_signals_in , WB_signals_in,WB_signals_in_final);    

    #100;
    $display("clk %d rst %d flush %d B %d WD %d src_out %d dst_out %d Rsrc_in %d WA %d ALU_Out %d RD_in %d Imm_in %d mux_lines %d MEM_signals_in %p EX_signals_in %p WB_signals_in %p WB_signals_in_final %p",clk,rst,flush,B,WD,src_out,dst_out,Rsrc_in,Rdst_in,WA,ALU_Out,RD_in,Imm_in,mux_lines, MEM_signals_in , EX_signals_in , WB_signals_in,WB_signals_in_final);    

    #100;
    $display("clk %d rst %d flush %d B %d WD %d src_out %d dst_out %d Rsrc_in %d WA %d ALU_Out %d RD_in %d Imm_in %d mux_lines %d MEM_signals_in %p EX_signals_in %p WB_signals_in %p WB_signals_in_final %p",clk,rst,flush,B,WD,src_out,dst_out,Rsrc_in,Rdst_in,WA,ALU_Out,RD_in,Imm_in,mux_lines, MEM_signals_in , EX_signals_in , WB_signals_in,WB_signals_in_final);    

    #100;
    $display("clk %d rst %d flush %d B %d WD %d src_out %d dst_out %d Rsrc_in %d WA %d ALU_Out %d RD_in %d Imm_in %d mux_lines %d MEM_signals_in %p EX_signals_in %p WB_signals_in %p WB_signals_in_final %p",clk,rst,flush,B,WD,src_out,dst_out,Rsrc_in,Rdst_in,WA,ALU_Out,RD_in,Imm_in,mux_lines, MEM_signals_in , EX_signals_in , WB_signals_in,WB_signals_in_final);    

    #100;
    $display("clk %d rst %d flush %d B %d WD %d src_out %d dst_out %d Rsrc_in %d WA %d ALU_Out %d RD_in %d Imm_in %d mux_lines %d MEM_signals_in %p EX_signals_in %p WB_signals_in %p WB_signals_in_final %p",clk,rst,flush,B,WD,src_out,dst_out,Rsrc_in,Rdst_in,WA,ALU_Out,RD_in,Imm_in,mux_lines, MEM_signals_in , EX_signals_in , WB_signals_in,WB_signals_in_final);    

    #100;
        
    end

endmodule