module Control_Unit (opcode,MEM_signals,EX_signals,WB_signals,flush);

    localparam NOP =6'b000001;
    localparam NOT =6'b000100;
    localparam ADD =6'b001011;
    localparam LDM =6'b111111;
    localparam STD =6'b000010;

    input [5:0] opcode;
    output reg flush;
    output reg [3:0] MEM_signals; //memRead(1), memWrite(1), memAddress(1), memData(1)
    output reg [6:0] EX_signals;  //ALUop(4+1enable), shamSelt(1), flag_en
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

    memRead 1 ==> Rdst
    memData 1==> Rdst

    phase 1:
        R-type  • NOP [101] |  ALUOP=> 0000 | ALU_en : 1 | 
                • NOT [100] |  ALUOP=> 0001 | ALU_en : 1 | WB : 101
                • ADD [011] |  ALUOP=> 0010 | ALU_en : 1 | WB : 101
        Imm
                • LDM [001] |  ALUOP=> xxxx | ALU_en : 0 | MemRead : 1 | MemAddress : 0 | WB : 110
                • STD [010] |  ALUOP=> xxxx | ALU_en : 0 | MemWrite: 1 | MemAddress : 1 | WB : 000 | MemData : 0    
    */

    always @(*) begin
        
        case (opcode)
            NOP: begin 
                flush=1'b0;
                EX_signals=6'b0000000;
                MEM_signals=4'b0000; 
                WB_signals=3'b000;

            end
            NOT: begin 
                flush=1'b0;
                EX_signals=6'b0001101;
                MEM_signals=4'b0000;
                WB_signals=3'b101;
               
            end
            ADD: begin 
                flush=1'b0;
                EX_signals=6'b0010101;
                MEM_signals=4'b0000;
                WB_signals=3'b101;
            end
            LDM: begin 
                flush=1'b1;
                EX_signals=6'b0000000;
                MEM_signals=4'b1000;
                WB_signals=3'b110;

            end
            STD: begin
                flush=1'b0;
                EX_signals=6'b0000000;
                MEM_signals=4'b0110;   //memRead(1), memWrite(1), memAddress(1), memData(1)
                WB_signals=3'bxxx;
                
            end
                default: begin //NOP
                flush=1'b0;
                EX_signals=6'b0000100;
                MEM_signals=4'b0000; 
                WB_signals=3'b011;
            end
        endcase
    end
   
endmodule