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
 fetch test_fetch(clk);
   always#50 clk = ~clk;
    initial begin
clk=0;

#100;
      if(opcode==4'b0001 && src==3'b001 && dst==3'b111 && shiftamount==4'b0000)
           correct=correct+1;
           else
           begin
           failed=failed+1;
        $display("opcode=%b and src=%b and dst=%b and  shiftamount=%b",opcode,src,dst,shiftamount);
           end
#80;
      if(opcode==4'b0001 && src==3'b010 && dst==3'b110 && shiftamount==4'b0000)
              correct=correct+1;
           else
           begin
           failed=failed+1;
          $display("opcode=%b and src=%b and dst=%b and  shiftamount=%b",opcode,src,dst,shiftamount);
            end
#80;
     if(opcode==4'b0101 && src==3'b000 && dst==3'b011 && shiftamount==4'b0000)
              correct=correct+1;
           else
            begin
           failed=failed+1;
          $display("opcode=%b and src=%b and dst=%b and  shiftamount=%b",opcode,src,dst,shiftamount);
            end
#80;
     if(opcode==4'b0011 && src==3'b010 && dst==3'b001 && shiftamount==4'b0000)
           correct=correct+1;
           else
            begin
           failed=failed+1;
          $display("opcode=%b and src=%b and dst=%b and  shiftamount=%b",opcode,src,dst,shiftamount);
            end
#80;
     if(opcode==4'b0100 && src==3'b000 && dst==3'b001 && shiftamount==4'b0000)
           correct=correct+1;
           else
            begin
           failed=failed+1;
          $display("opcode=%b and src=%b and dst=%b and  shiftamount=%b",opcode,src,dst,shiftamount);
            end
#80;
     if(opcode==4'b0010 && src==3'b010 && dst==3'b001 && shiftamount==4'b0000)
            correct=correct+1;
           else
           begin
           failed=failed+1;
          $display("opcode=%b and src=%b and dst=%b and  shiftamount=%b",opcode,src,dst,shiftamount);
            end

          $display("correct_cases=%d and failed_cases=%d",correct,failed );
    end
endmodule