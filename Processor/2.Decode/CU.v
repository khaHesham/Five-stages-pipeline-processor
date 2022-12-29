module Control_Unit (opcode,MEM_signals,EX_signals,WB_signals,flush);

    localparam NOP =6'b000000;
    localparam SETC=6'b000001;
    localparam CLRC=6'b000010;
    localparam NOT =6'b000011;
    localparam INC =6'b000100;
    localparam DEC =6'b000101;
    localparam PUSH=6'b111100;
    localparam POP =6'b010001;
    localparam ADD =6'b010111;
    localparam SUB =6'b011000; 
    localparam AND =6'b011001;
    localparam OR  =6'B011010;
    localparam MOV =6'b010110;
    localparam SHL =6'b011011;  
    localparam SHR =6'b011111;
    localparam LDM =6'b010010;
    localparam LDD =6'b010011;
    localparam STD =6'b010100;
    localparam JZ  =6'b100000;
    localparam JN  =6'b100001;
    localparam JC  =6'b100010;
    localparam JMP =6'b100100;
    localparam OUT =6'b001100;
    localparam IN  =6'b110011;
    localparam CALL=6'b100101;
    localparam RET =6'b100110;
    localparam RETI=6'b100111;





    input [5:0] opcode;
    output reg flush;
    output reg [3:0] MEM_signals; //memRead(1), memWrite(1), memAddress(1), memData(1)
    output reg [6:0] EX_signals;  //ALUop(4+1enable), shamSelt(1), flag_en
    output reg [2:0] WB_signals;  //regWrite(1), WBsel(2)

   
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