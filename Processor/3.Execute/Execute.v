module ALU(
           input [15:0] A,B,  // ALU 8-bit Inputs                 
           input ALU_EN, // ALU ensble and clk and rst
           input [3:0] Function_Control, //functionopcode
           output [15:0] ALU_Out, // ALU 8-bit Output
           output CarryOut,NegativeFlag,ZeroFlag // Carry Out Flag ,NegativeFlag,ZeroFlag
    );


    localparam NOT =4'b0001;
    localparam ADD =4'b0010;
    localparam STD =4'b0000;

     reg [16:0] ALU_Result;
     reg carry;

       // wire [16:0] tmp;
   // assign tmp ={1'b0,A} + {1'b0,B};
   // assign CarryOut = tmp[16]; // Carryout flag

    always @(*)
    begin
        if(ALU_EN==1)
        begin
            carry=0;
            case(Function_Control)
              ADD: // Addition
                begin
                  ALU_Result = A + B ;
                  carry=ALU_Result[16];
                end
              NOT: //  NOT DEST
                begin
                  ALU_Result = ~B;
                end
              STD: //  STD
                begin
                  ALU_Result = A; 
              // $display("ALU_Result=%b for execute IN SORE",ALU_Result);
                end
              default:begin
                ALU_Result= 16'bZ;
              end
          endcase
        end
        else begin
           ALU_Result=16'bZ;
        end
 //$display("out=%b for execute",ALU_Out);
    end

    assign ALU_Out = ALU_Result[15:0]; // ALU out

    assign ZeroFlag =( !ALU_Out ) ? 1 : 0; // Zero flag
    assign NegativeFlag = (ALU_Out[15]) ? 1:0; // NegativeFlag
    assign CarryOut=carry; //carry


endmodule