module Control_Unit (opcode,MEM_signals,EX_signals,WB_signals);

    localparam NOP =6'b000101 ;
    localparam NOT =6'b000100 ;
    localparam ADD =6'b000011 ;
    localparam LDD =6'b000001 ;
    localparam STD =6'b000010 ;

    output reg [3:0] MEM_signals; //memRead(1), memWrite(1), memAddress(1), memData(1)
    output reg [5:0] EX_signals;  //ALUop(4+1enable), shamSelt(1)
    output reg [2:0] WB_signals;  //regWrite(1), WBsel(2)

    /*
    |   opcode  |
    |   6-bits  |
    | 00 | 0000 | => in next phase ! => 2-bits for Instr-Type + 4-bits ALUop  

    |             WB              |
    |1-bit RegWrite | 2-bit WBsel |
    |  MEM | 0 00                 |
    |  ALU | 1 01                 |
    |  Imm | 1 10                 |
    |  xxx | 0 11                 |

    phase 1:
        R-type  • NOP [101] |  ALUOP=> 0000 | ALU_en : 1 | 
                • NOT [100] |  ALUOP=> 0001 | ALU_en : 1 | WB : 101
                • ADD [011] |  ALUOP=> 0010 | ALU_en : 1 | WB : 101
        Imm
                • LDD [001] |  ALUOP=> xxxx | ALU_en : 0 | MemRead : 1 | MemAddress : 0 | WB : 100
                • STD [010] |  ALUOP=> xxxx | ALU_en : 0 | MemWrite: 1 | MemAddress : 1 | WB : 0xx | MemData : 0    
    */

    always @(*) begin
        case (opcode)
            NOP: begin 
                EX_signals[1]=0;
                EX_signals[5:1]=4'bzzzz;
                MEM_signals[3]=0; //memread
                MEM_signals[2]=0; //memwrite
                WB_signals=3'b011;
            end
            NOT: begin 
                EX_signals[5:1]=4'b0001;
                EX_signals[1]=1;
                MEM_signals[3]=0;
                MEM_signals[2]=0;
                WB_signals=3'b101;
            end
            ADD: begin 
                EX_signals[5:1]=4'b0010;
                EX_signals[1]=1;
                MemRead=0;
                MemWrite=0;
                WB_signals=3'b101;
            end
            LDD: begin 
                EX_signals[1]=0;
                MEM_signals[3]=1;
                MEM_signals[2]=0;
                MEM_signals[1]= 0 ; // Rsrc
                WB_signals=3'b100;

            end
            STD: begin 
                EX_signals[1]=0;
                MEM_signals[3]=0;
                MEM_signals[2]=1;
                MEM_signals[1]=1;   // Rdst
                WB_signals=3'b0xx;
                MEM_signals[0]= 0;
            end
                default: begin //NOP
                EX_signals[1]=0;
                MEM_signals[3]=0;
                MEM_signals[2]=0;
            end
        endcase
    end
   
endmodule