module Control_Unit (opcode,MemRead,MemWrite,ALU_op,ALU_en,shamtSel,WB,MemAddress,MemData);
    input [5:0] opcode;
    output reg MemRead;
    output reg MemWrite;
    output reg [3:0] ALU_op;
    output reg ALU_en; 
    output reg shamtSel;    // 0 Rdst | 1 shamt
    output reg [2:0] WB; 
    output reg MemAddress;  // 0 Rsrc | 1 Rdst
    output reg MemData;     // 0 Rsrc | 1 Rdst
    localparam NOP =6'b000101 ;
    localparam NOT =6'b000100 ;
    localparam ADD =6'b000011 ;
    localparam LDD =6'b000001 ;
    localparam STD =6'b000010 ;

    /*
    !|   opcode  |
    |   6-bits  |
    | 00 | 0000 | => in next phase ! => 2-bits for Instr-Type + 4-bits ALUop  

    !|             WB              |
    |1-bit RegWrite | 2-bit WBsel |
    |  MEM | 0 00                 |
    |  ALU | 1 01                 |
    |  Imm | 1 10                 |
    |  xxx | 0 11                 |

    !phase 1:
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
                ALU_en=0;
                ALU_op=4'bzzzz;
                MemRead=0;
                MemWrite=0;
                WB=3'b011;
            end
            NOT: begin 
                ALU_op=4'b0001;
                ALU_en=1;
                MemRead=0;
                MemWrite=0;
                WB=3'b101;
            end
            ADD: begin 
                ALU_op=4'b0010;
                ALU_en=1;
                MemRead=0;
                MemWrite=0;
                WB=3'b101;
            end
            LDD: begin 
                ALU_en=0;
                MemRead=1;
                MemWrite=0;
                MemAddress= 0 ; // Rsrc
                WB=3'b100;

            end
            STD: begin 
                ALU_en=0;
                MemRead=0;
                MemWrite=1;
                MemAddress=1;   // Rdst
                WB=3'b0xx;
                MemData= 0;
            end
                default: begin //NOP
                ALU_en=0;
                MemRead=0;
                MemWrite=0;
            end
        endcase
    end
   
endmodule