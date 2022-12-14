module tb_fetch;
//Inputs
 reg clk;

//Outputs
    wire [5:0] opcode;
    wire [2:0] src;
    wire [2:0] dst;
    wire [3:0] shiftamount;

 integer correct =0;
 integer failed =0;
 fetch test_fetch(clk,opcode,src,dst,shiftamount);
   always#100 clk = ~clk;
    initial begin
clk=0;
#200;
      if(opcode==6'b010001 && src==3'b001 && dst==3'b111 && shiftamount==4'b0000)
           correct=correct+1;
           else
           begin
           failed=failed+1;
        $display("LDD ->opcode=%b and src=%b and dst=%b and  shiftamount=%b",opcode,src,dst,shiftamount);
           end
#200;
      if(opcode==6'b010001 && src==3'b010 && dst==3'b110 && shiftamount==4'b0000)
              correct=correct+1;
           else
           begin
           failed=failed+1;
          $display("LDD ->opcode=%b and src=%b and dst=%b and  shiftamount=%b",opcode,src,dst,shiftamount);
            end
#200;
     if(opcode==6'b000101 && src==3'b000 && dst==3'b011 && shiftamount==4'b0000)
              correct=correct+1;
           else
            begin
           failed=failed+1;
          $display("NOP ->opcode=%b and src=%b and dst=%b and  shiftamount=%b",opcode,src,dst,shiftamount);
            end
#200;
     if(opcode==6'b000011 && src==3'b010 && dst==3'b001 && shiftamount==4'b0000)
           correct=correct+1;
           else
            begin
           failed=failed+1;
         $display("ADD -> opcode=%b and src=%b and dst=%b and  shiftamount=%b",opcode,src,dst,shiftamount);
            end
#200;
     if(opcode==6'b000100 && src==3'b000 && dst==3'b001 && shiftamount==4'b0000)
           correct=correct+1;
           else
            begin
           failed=failed+1;
          $display("NOT -> opcode=%b and src=%b and dst=%b and  shiftamount=%b",opcode,src,dst,shiftamount);
            end
#200;
     if(opcode==6'b010010 && src==3'b010 && dst==3'b001 && shiftamount==4'b0000)
            correct=correct+1;
           else
           begin
           failed=failed+1;
          $display("STD -> opcode=%b and src=%b and dst=%b and  shiftamount=%b",opcode,src,dst,shiftamount);
            end
#200;
        $display("correct_cases=%d and failed_cases=%d",correct,failed );
    end
endmodule