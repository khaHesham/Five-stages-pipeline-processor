module tb_alu;
//Inputs
 reg[15:0] A,B;
 reg ALU_EN,clk,reset; // ALU ensble and clk and reset
 reg[3:0] Function_Control;

//Outputs
 wire[15:0] ALU_Out;
 wire CarryOut,NegativeFlag,ZeroFlag;
 // Verilog code for ALU
 integer failed ;
 integer correct;
 alu test_unit(A,B,ALU_EN,clk,reset,Function_Control,ALU_Out,CarryOut,NegativeFlag,ZeroFlag);   
  always#50 clk = ~clk;
    initial begin
  failed =0;
  correct=0;
    //testcase for add instruction
      clk=0;
      A = 16'b1001010101010101;
      B=  16'b1111111111111111;
      ALU_EN=1;
      reset=0;
      Function_Control=4'b0011;
#100;
      if(ALU_Out==16'b1001010101010100 && CarryOut == 1'b1 && NegativeFlag == 1'b1 && ZeroFlag == 1'b0)
      correct=correct+1;
      else 
begin
failed=failed+1;
 $display("ALU_Out=%b and CarryOut=%b and NegativeFlag=%b and ZeroFlag=%b",ALU_Out,CarryOut,NegativeFlag,ZeroFlag );
end
  #20;
        //for Not
      A = 16'b1010101111111111;
      B = 16'b1111111111111111;
      ALU_EN=1;
      reset=0;
      Function_Control=4'b0100;
#80;
 if(ALU_Out==16'b0 && CarryOut == 1'b0 && NegativeFlag == 1'b0 && ZeroFlag == 1'b1)
      correct=correct+1;
      else 
    begin
failed=failed+1;
 $display("ALU_Out=%b and CarryOut=%b and NegativeFlag=%b and ZeroFlag=%b",ALU_Out,CarryOut,NegativeFlag,ZeroFlag );
end
  #20;

  //NOP
      A = 16'b1111111111111111;
      B = 16'b0101010101001101;
      ALU_EN=1;
      reset=0;
      Function_Control=4'b0101;
#80;
         if(ALU_Out==16'b0 && CarryOut==0 && NegativeFlag==0 && ZeroFlag==1 )
            correct=correct+1;
else 
   begin
failed=failed+1;
 $display("ALU_Out=%b and CarryOut=%b and NegativeFlag=%b and ZeroFlag=%b",ALU_Out,CarryOut,NegativeFlag,ZeroFlag );
end

    //NOP set all flags=zero or executed as any instruction
    //here we assumed as any inst

  #20;
       //for load
      A = 16'b1010101000010111;
      B = 16'b1111111111111111;
      ALU_EN=1;
      reset=0;
      Function_Control=4'b0001;
#80;
      if(ALU_Out==16'b1010101000010111 && CarryOut==0 && NegativeFlag==1 && ZeroFlag==0 )
          correct=correct+1;
          else
        begin
failed=failed+1;
 $display("ALU_Out=%b and CarryOut=%b and NegativeFlag=%b and ZeroFlag=%b",ALU_Out,CarryOut,NegativeFlag,ZeroFlag );
end
  #20;
  //store
      A = 16'b0010101000010111;
      B = 16'b0101111111010101;
      ALU_EN=1;
      reset=0;
      Function_Control=4'b0010;    
#80;
       if(ALU_Out==16'b0010101000010111 && CarryOut==0 && NegativeFlag==0 && ZeroFlag==0 )
begin
               correct=correct+1;
//$display("ALU_Out=%b and CarryOut=%b and NegativeFlag=%b and ZeroFlag=%b",ALU_Out,CarryOut,NegativeFlag,ZeroFlag );
end
else
    begin
failed=failed+1;
 $display("ALU_Out=%b and CarryOut=%b and NegativeFlag=%b and ZeroFlag=%b",ALU_Out,CarryOut,NegativeFlag,ZeroFlag );
end

#20;
   //testcase for add and reset=1
      A = 16'b1111111111000000;
      B=  16'b1111111111111111;
      ALU_EN=1;
      reset=1;
      Function_Control=4'b0011;
#80;
      if(ALU_Out==16'b0 && CarryOut == 1'b0 && NegativeFlag == 1'b0 && ZeroFlag == 1'b0)
      correct=correct+1;
      else 
begin
failed=failed+1;
// $display("ALU_Out=%b and CarryOut=%b and NegativeFlag=%b and ZeroFlag=%b",ALU_Out,CarryOut,NegativeFlag,ZeroFlag );
end
       $display("correct_cases=%d and failed_cases=%d",correct,failed );
    end
endmodule