module ALU(
           input [15:0] A,B,  // ALU 8-bit Inputs                 
           input ALU_EN,clk,rst, // ALU ensble and clk and rst
           input [3:0] Function_Control, //functionopcode
           output [15:0] ALU_Out, // ALU 8-bit Output
           output CarryOut,NegativeFlag,ZeroFlag // Carry Out Flag ,NegativeFlag,ZeroFlag
    );
     reg [16:0] ALU_Result;
     reg carry;
     assign ALU_Out = ALU_Result; // ALU out
     assign CarryOut=carry;
       // wire [16:0] tmp;
   // assign tmp ={1'b0,A} + {1'b0,B};
   // assign CarryOut = tmp[16]; // Carryout flag

    assign ZeroFlag =( !ALU_Out && !rst) ? 1 : 0; // Zero flag

    assign NegativeFlag = (ALU_Out[15] && !rst) ? 1:0; // NegativeFlag

    always @(posedge clk && ALU_EN==1)
    begin
        if(!rst)
        begin
        carry=0;
      case(Function_Control)
          4'b0010: // Addition
           begin
           ALU_Result = A + B ;
           carry=ALU_Result[16];
           end
          4'b0001: //  NOT DEST
          begin
           ALU_Result = ~B;
          end
          4'b0000: //  NOP
          begin
           ALU_Result =0;
          end
        //   4'bXXXX: //  LDM
        //  begin 
        //    ALU_Result = A;
        //    //$display("ALU_Result=%b for execute in LDD",ALU_Result);
        //  end
          4'b0010: //  STD
           begin
           ALU_Result = A; 
           // $display("ALU_Result=%b for execute IN SORE",ALU_Result);
          end
          default:begin
            ALU_Result= 4'hZ;
          end
        endcase
        end
        else
 ALU_Result=0;
 //$display("out=%b for execute",ALU_Out);
    end
endmodule