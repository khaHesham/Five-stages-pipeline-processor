module ALU(
           input [15:0] A,B,                        // ALU 16-bit Inputs                 
           input ALU_EN,                            // ALU Enable
           input [3:0] Function_Control,            // ALU_OP
           input [3:0] shiftamount,                 // shift amount
           input [2:0] flags_old,
           output [15:0] ALU_Out,                   // ALU 16-bit Output
           output CarryOut,NegativeFlag,ZeroFlag    // Carry Out Flag ,NegativeFlag,ZeroFlag
    );

        /*       {    CONSTANTS    }      */
        /* ------------------------------ */
        /**/  localparam INC =4'b0000;  /**/
        /**/  localparam DEC =4'b0001;  /**/
        /**/  localparam ADD =4'b0010;  /**/
        /**/                            /**/
        /**/  localparam SUB =4'b0011;  /**/
        /**/  localparam MOV =4'b0100;  /**/
        /**/  localparam NOT =4'b0101;  /**/
        /**/                            /**/
        /**/  localparam OR = 4'b0110;  /**/
        /**/  localparam AND =4'b0111;  /**/
        /**/  localparam SHL =4'b1000;  /**/
        /**/                            /**/
        /**/  localparam SHR =4'b1001;  /**/
        /**/  localparam SETC=4'b1010;  /**/
        /**/  localparam CLC =4'b1011;  /**/
        /**********************************/

    reg [16:0] ALU_Result;
    reg carry;
    reg negativeFlag;
    reg zeroflag;


    always @(*)
    begin
        if(ALU_EN==1)
        begin
            carry=flags_old[2];
            negativeFlag=flags_old[1];
            zeroflag=flags_old[0];

            case(Function_Control)
              SETC: 
                begin
                  ALU_Result = 4'hzzzz;
                  carry = 1;
                  negativeFlag=flags_old[1];
                  zeroflag=flags_old[0];
                end

              CLC: 
                begin
                  ALU_Result = 4'hzzzz;
                  carry = 0;
                  negativeFlag=flags_old[1];
                  zeroflag=flags_old[0];
                end

              INC: 
                begin
                  ALU_Result = B + 1;
                  carry = ALU_Result[16];
                  zeroflag=( !ALU_Out ) ? 1 : 0;
                end

              DEC: 
                begin
                  ALU_Result = B - 1;
                  negativeFlag = ALU_Result[16];
                  zeroflag=( !ALU_Out ) ? 1 : 0;
                  
                end

              ADD: 
                begin
                  ALU_Result = A + B;
                  carry=ALU_Result[16];
                  zeroflag=( !ALU_Out ) ? 1 : 0;
                end

              SUB: 
                begin
                  ALU_Result = A - B;
                  negativeFlag = ALU_Result[16];
                  zeroflag=( !ALU_Out ) ? 1 : 0;
                end

              NOT: 
                begin
                  ALU_Result = ~B;
                  zeroflag=( !ALU_Out ) ? 1 : 0;
                end

              MOV: 
                begin
                  ALU_Result = A;
                  zeroflag=( !ALU_Out ) ? 1 : 0;
                end

              AND: 
                begin
                  ALU_Result = A & B;
                  negativeFlag = ALU_Result[16];
                  zeroflag=( !ALU_Out ) ? 1 : 0;
                end

              OR: 
                begin
                  ALU_Result = A | B;
                  negativeFlag = ALU_Result[16];
                  zeroflag=( !ALU_Out ) ? 1 : 0;
                end

              SHL:  // TODO: how can i set carry flag for multi shifts ?
                begin
                  carry = A[15];  
                  ALU_Result = A <<< shiftamount ;  // it has to be shifted with shiftamount
                  negativeFlag = ALU_Result[16];
                  zeroflag=( !ALU_Out ) ? 1 : 0;
                end

              SHR:  // TODO: how can i set carry flag for multi shifts ?
                begin
                  carry = A[0]; 
                  ALU_Result = A >>> shiftamount ;  
                  negativeFlag = ALU_Result[16];
                  zeroflag=( !ALU_Out ) ? 1 : 0;
                end

              default:begin
                ALU_Result= 16'bZ;
              end
          endcase
        end
        else begin
           ALU_Result=16'bZ;
        end
 
    end

    assign ALU_Out = ALU_Result[15:0]; // ALU out
    assign NegativeFlag = negativeFlag;
    assign ZeroFlag = zeroflag; // Zero flag
    assign CarryOut = carry; //carry

endmodule