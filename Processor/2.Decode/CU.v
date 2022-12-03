module Control_Unit (opcode,MEM_signals,EX_signals,WB_signals);

    localparam NOP =6'b000101 ;
    localparam NOT =6'b000100 ;
    localparam ADD =6'b000011 ;
    localparam LDD =6'b000001 ;
    localparam STD =6'b000010 ;

    input [5:0] opcode;

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
                EX_signals=6'b000010;
                MEM_signals=4'b0000; 
                WB_signals=3'b011;
            end
            NOT: begin 
                EX_signals=6'b000110;
                MEM_signals=4'b0000;
                WB_signals=3'b101;
            end
            ADD: begin 
                EX_signals=6'b001010;
                MEM_signals=4'b0000;
                WB_signals=3'b101;
            end
            LDD: begin 
                EX_signals=6'bxxxx00;
                MEM_signals=4'b1000;
                WB_signals=3'b100;

            end
            STD: begin 
                EX_signals=6'bxxxx00;
                MEM_signals[3]=4'b0110;   
                WB_signals=3'b0xx;
            end
                default: begin //NOP
                EX_signals=6'b000010;
                MEM_signals=4'b0000; 
                WB_signals=3'b011;
            end
        endcase
    end
   
endmodule