
module Decode_TB;

//Inputs
 reg clk,rst;
 reg [15:0] WD;
 wire flush;
 wire [15:0] Rsrc_out_2,Rdst_out_2,ALU_Out_2;  //msh sam3aaaaak
 reg [2:0] WA;

 wire [15:0] Imm_out_2;
 wire [3:0] MEM_signals_out_2; // memRead(1), memWrite(1), memAddress(1), memData(1)
 wire [5:0] EX_signals_out_2;  // ALUop(4+1enable), shamSelt(1)
 wire [2:0] WB_signals_out_2;  // regWrite(1), WBsel(2)
 reg regWrite;

 wire [2:0] flags_out;

//Outputs
 Processor processor_inst(clk, rst, regWrite, WD, WA, Rsrc_out_2, Rdst_out_2,Imm_out_2,ALU_Out_2,MEM_signals_out_2, EX_signals_out_2, WB_signals_out_2,flags_out);
   always#50 clk = ~clk;
    initial begin
    clk=1;
    rst=1;

    #100;
    rst=0;

    #100;
    $display("clk %d rst %d regWrite %d WD %d WA %d Rsrc %d Rdst %d Imm %d MEM_signals %p EX_signals %p WB_signals %p flush %d",clk, rst, regWrite, WD, WA, Rsrc_out_2, Rdst_out_2,Imm_out_2, MEM_signals_out_2, EX_signals_out_2, WB_signals_out_2,flags_out,ALU_Out_2);
    
     #100;
    $display("clk %d rst %d regWrite %d WD %d WA %d Rsrc_out_2 %d Rdst_out_2 %d Imm_out_2 %d MEM_signals_out_2 %p EX_signals_out_2 %p WB_signals_out_2,flags_out,ALU_Out_2 %p %d",clk, rst, regWrite, WD, WA, Rsrc_out_2, Rdst_out_2,Imm_out_2, MEM_signals_out_2, EX_signals_out_2, WB_signals_out_2,flags_out,ALU_Out_2);
    
     #100;
    $display("clk %d rst %d regWrite %d WD %d WA %d Rsrc_out_2 %d Rdst_out_2 %d Imm_out_2 %d MEM_signals_out_2 %p EX_signals_out_2 %p WB_signals_out_2,flags_out,ALU_Out_2 %p %d",clk, rst, regWrite, WD, WA, Rsrc_out_2, Rdst_out_2,Imm_out_2, MEM_signals_out_2, EX_signals_out_2, WB_signals_out_2,flags_out,ALU_Out_2);
    
     #100;
    $display("clk %d rst %d regWrite %d WD %d WA %d Rsrc_out_2 %d Rdst_out_2 %d Imm_out_2 %d MEM_signals_out_2 %p EX_signals_out_2 %p WB_signals_out_2,flags_out,ALU_Out_2 %p %d",clk, rst, regWrite, WD, WA, Rsrc_out_2, Rdst_out_2,Imm_out_2, MEM_signals_out_2, EX_signals_out_2, WB_signals_out_2,flags_out,ALU_Out_2);
    
    #100;
    $display("clk %d rst %d regWrite %d WD %d WA %d Rsrc_out_2 %d Rdst_out_2 %d Imm_out_2 %d MEM_signals_out_2 %p EX_signals_out_2 %p WB_signals_out_2,flags_out,ALU_Out_2 %p %d",clk, rst, regWrite, WD, WA, Rsrc_out_2, Rdst_out_2,Imm_out_2, MEM_signals_out_2, EX_signals_out_2, WB_signals_out_2,flags_out,ALU_Out_2);
    
    #100;
    $display("clk %d rst %d regWrite %d WD %d WA %d Rsrc_out_2 %d Rdst_out_2 %d Imm_out_2 %d MEM_signals_out_2 %p EX_signals_out_2 %p WB_signals_out_2,flags_out,ALU_Out_2 %p %d",clk, rst, regWrite, WD, WA, Rsrc_out_2, Rdst_out_2,Imm_out_2, MEM_signals_out_2, EX_signals_out_2, WB_signals_out_2,flags_out,ALU_Out_2);
    
    #100;
    $display("clk %d rst %d regWrite %d WD %d WA %d Rsrc_out_2 %d Rdst_out_2 %d Imm_out_2 %d MEM_signals_out_2 %p EX_signals_out_2 %p WB_signals_out_2,flags_out,ALU_Out_2 %p %d",clk, rst, regWrite, WD, WA, Rsrc_out_2, Rdst_out_2,Imm_out_2, MEM_signals_out_2, EX_signals_out_2, WB_signals_out_2,flags_out,ALU_Out_2);
    
    #100;
    $display("clk %d rst %d regWrite %d WD %d WA %d Rsrc_out_2 %d Rdst_out_2 %d Imm_out_2 %d MEM_signals_out_2 %p EX_signals_out_2 %p WB_signals_out_2,flags_out,ALU_Out_2 %p %d",clk, rst, regWrite, WD, WA, Rsrc_out_2, Rdst_out_2,Imm_out_2, MEM_signals_out_2, EX_signals_out_2, WB_signals_out_2,flags_out,ALU_Out_2);
    
    #100;
    $display("clk %d rst %d regWrite %d WD %d WA %d Rsrc_out_2 %d Rdst_out_2 %d Imm_out_2 %d MEM_signals_out_2 %p EX_signals_out_2 %p WB_signals_out_2,flags_out,ALU_Out_2 %p %d",clk, rst, regWrite, WD, WA, Rsrc_out_2, Rdst_out_2,Imm_out_2, MEM_signals_out_2, EX_signals_out_2, WB_signals_out_2,flags_out,ALU_Out_2);
    
    #100;
    $display("clk %d rst %d regWrite %d WD %d WA %d Rsrc_out_2 %d Rdst_out_2 %d Imm_out_2 %d MEM_signals_out_2 %p EX_signals_out_2 %p WB_signals_out_2,flags_out,ALU_Out_2 %p %d",clk, rst, regWrite, WD, WA, Rsrc_out_2, Rdst_out_2,Imm_out_2, MEM_signals_out_2, EX_signals_out_2, WB_signals_out_2,flags_out,ALU_Out_2);
    
    #100;
    $display("clk %d rst %d regWrite %d WD %d WA %d Rsrc_out_2 %d Rdst_out_2 %d Imm_out_2 %d MEM_signals_out_2 %p EX_signals_out_2 %p WB_signals_out_2,flags_out,ALU_Out_2 %p %d",clk, rst, regWrite, WD, WA, Rsrc_out_2, Rdst_out_2,Imm_out_2, MEM_signals_out_2, EX_signals_out_2, WB_signals_out_2,flags_out,ALU_Out_2);
    
    #100;
    $display("clk %d rst %d regWrite %d WD %d WA %d Rsrc_out_2 %d Rdst_out_2 %d Imm_out_2 %d MEM_signals_out_2 %p EX_signals_out_2 %p WB_signals_out_2,flags_out,ALU_Out_2 %p %d",clk, rst, regWrite, WD, WA, Rsrc_out_2, Rdst_out_2,Imm_out_2, MEM_signals_out_2, EX_signals_out_2, WB_signals_out_2,flags_out,ALU_Out_2);
    
    #100;
    $display("clk %d rst %d regWrite %d WD %d WA %d Rsrc_out_2 %d Rdst_out_2 %d Imm_out_2 %d MEM_signals_out_2 %p EX_signals_out_2 %p WB_signals_out_2,flags_out,ALU_Out_2 %p %d",clk, rst, regWrite, WD, WA, Rsrc_out_2, Rdst_out_2,Imm_out_2, MEM_signals_out_2, EX_signals_out_2, WB_signals_out_2,flags_out,ALU_Out_2);
    
    #100;
    $display("clk %d rst %d regWrite %d WD %d WA %d Rsrc_out_2 %d Rdst_out_2 %d Imm_out_2 %d MEM_signals_out_2 %p EX_signals_out_2 %p WB_signals_out_2,flags_out,ALU_Out_2 %p %d",clk, rst, regWrite, WD, WA, Rsrc_out_2, Rdst_out_2,Imm_out_2, MEM_signals_out_2, EX_signals_out_2, WB_signals_out_2,flags_out,ALU_Out_2);
    
    #100;
    $display("clk %d rst %d regWrite %d WD %d WA %d Rsrc_out_2 %d Rdst_out_2 %d Imm_out_2 %d MEM_signals_out_2 %p EX_signals_out_2 %p WB_signals_out_2,flags_out,ALU_Out_2 %p %d",clk, rst, regWrite, WD, WA, Rsrc_out_2, Rdst_out_2,Imm_out_2, MEM_signals_out_2, EX_signals_out_2, WB_signals_out_2,flags_out,ALU_Out_2);
    
    #100;
    $display("clk %d rst %d regWrite %d WD %d WA %d Rsrc_out_2 %d Rdst_out_2 %d Imm_out_2 %d MEM_signals_out_2 %p EX_signals_out_2 %p WB_signals_out_2,flags_out,ALU_Out_2 %p %d",clk, rst, regWrite, WD, WA, Rsrc_out_2, Rdst_out_2,Imm_out_2, MEM_signals_out_2, EX_signals_out_2, WB_signals_out_2,flags_out,ALU_Out_2);
    
    // #100;

    // $display("clk %d rst %d opcode %d src %d dst %d shiftamount %d regWrite %d WD %d WA %d Rsrc_out_2 %d Rdst_out_2 %d Imm_out_2 %d MEM_signals_out_2 %p EX_signals_out_2 %p WB_signals_out_2,flags_out,ALU_Out_2 %p %d",clk, rst, opcode,src,dst,shiftamount, regWrite, WD, WA, Rsrc_out_2, Rdst_out_2,Imm_out_2, MEM_signals_out_2, EX_signals_out_2, WB_signals_out_2,flags_out,ALU_Out_2);
    // #100;

        
    end

endmodule