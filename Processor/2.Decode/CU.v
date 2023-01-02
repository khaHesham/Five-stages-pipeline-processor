module Control_Unit (opcode,interrupt,inst_before_call,inter_state_before,ret_state_before,reti_state_before,f_d_buffer_enable,pc_enable,flush,jump_sel,MEM_signals,EX_signals,WB_signals,inter_state_after,ret_state_after,reti_state_after, out_signal);
    //opcodes
    localparam NOP =6'b000000;
    localparam SETC=6'b000001;
    localparam CLRC=6'b000010;
    localparam NOT =6'b000011;
    localparam INC =6'b000100;
    localparam DEC =6'b000101;
    localparam PUSH=6'b111100;
    localparam POP =6'b110001;
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
    //states

    //interrupt
    localparam NO_INTERRUPT =2'b00;
    localparam PUSH_FLAGS =2'b01;
    localparam PUSH_1 =2'b10;
    //ret
    localparam NO_RET  =3'b000;
    localparam POP_1_RET =3'b001;
    localparam POP_2_RET =3'b010;
    localparam NOP1_RET =3'b011;
    localparam NOP2_RET =3'b100;
    localparam NOP3_RET=3'b101;
    //reti
    localparam NO_RETI  =3'b000;
    localparam POP_FLAGS =3'b001;
    localparam POP_1_RETI =3'b010;
    localparam POP_2_RETI =3'b011;
    localparam NOP1_RETI =3'b100;
    localparam NOP2_RETI =3'b101;

    //inputs
    input [5:0] opcode;
    input interrupt,inst_before_call;
    //state_before
    input [1:0] inter_state_before;
    input [2:0] ret_state_before,reti_state_before;

   //for fetch and flush also for decode 
    output reg f_d_buffer_enable,pc_enable,flush;
    output reg [1:0]jump_sel;
    //for execute , memo and WB
    output reg [6:0] MEM_signals; //memRead(1), memWrite(1), memAddress(2), memData(3)
    output reg [12:0] EX_signals;  //branch(3),call(1),alu_op(4),rsrc_sel(2),rdst_sel(1),flags_enb(1),alu_en(1)  //modified rdst_sel
    output reg [5:0] WB_signals;  //sp_wr(1), flags_wb(1),wb_sel(1),pop_l_h(2),regwrite(1)
    output reg out_signal;
    
    //state_after
    output reg [1:0] inter_state_after;
    output reg [2:0] ret_state_after,reti_state_after;
   
    always @(*) begin
        if( |inter_state_before || interrupt)  //INTERRUPT
        begin
          ret_state_after=3'b000;
          reti_state_after=3'b000;
        case(inter_state_before)   //push_flags
         NO_INTERRUPT:begin
         inter_state_after=2'b01;
         f_d_buffer_enable=0;
         pc_enable=0;
         flush=0;
         jump_sel=2'b00;
        EX_signals=13'b0000111011001;
         MEM_signals=7'b0111010;
         WB_signals=6'b100000;
        out_signal = 1'b0;
         end
         PUSH_FLAGS:begin            //push_1
        inter_state_after=2'b10;
        f_d_buffer_enable=0;
        pc_enable=1;
        flush=0;
        jump_sel=2'b10;
        EX_signals=13'b0000111011001;
        MEM_signals=7'b0111100;
        WB_signals=6'b100000;
        out_signal = 1'b0;
         end
         PUSH_1:begin                  //push_2
        inter_state_after=2'b00;
        f_d_buffer_enable=1;
        pc_enable=1;
        flush=0;
        jump_sel=2'b00;
        EX_signals=13'b0000111011001;
        MEM_signals=7'b0111011;
        WB_signals=6'b100000;
        out_signal = 1'b0;
         end
        endcase
        end
        else if( |ret_state_before || opcode==RET)   //RET
        begin
        reti_state_after=3'b000;   
        inter_state_after=2'b00; 
        case(ret_state_before)
        NO_RET:begin      //pop_1
        ret_state_after=3'b001;
        f_d_buffer_enable=0;
        pc_enable=0;
        flush=0;
        jump_sel=2'b00;
        EX_signals=13'b0000110111001;
        MEM_signals=7'b1010000;
        WB_signals=6'b101100; //TODO: regwrite was 1
        out_signal = 1'b0;
       end
       POP_1_RET:begin    //pop_2
        ret_state_after=3'b010;
        f_d_buffer_enable=0;
        pc_enable=0;
        flush=0;
        jump_sel=2'b00;
        EX_signals=13'b0000110111001;
        MEM_signals=7'b1010000;
        WB_signals=6'b101110; //TODO: regwrite was 1
        out_signal = 1'b0;
       end
       POP_2_RET:begin     //NOP1
        ret_state_after=3'b011;
        f_d_buffer_enable=0;
        pc_enable=0;
        flush=0;
        jump_sel=2'b00;
        EX_signals=13'b0000000000000;
        MEM_signals=7'b0000000;
        WB_signals=6'b000000;
        out_signal = 1'b0;
       end
       NOP1_RET:begin   //NOP2
        ret_state_after=3'b100;
        f_d_buffer_enable=0;
        pc_enable=0;
        flush=0;
        jump_sel=2'b00;
        EX_signals=13'b0000000000000;
        MEM_signals=7'b0000000;
        WB_signals=6'b000000;
        out_signal = 1'b0;
       end
       NOP2_RET:begin    //NOP3
        ret_state_after=3'b101;
        f_d_buffer_enable=0;
        pc_enable=1;
        flush=0;
        jump_sel=2'b11;
        EX_signals=13'b0000000000000;
        MEM_signals=7'b0000000;
        WB_signals=6'b000000;
        out_signal = 1'b0;
       end
        NOP3_RET:begin   //NOP4
        ret_state_after=3'b000;
        f_d_buffer_enable=1;
        pc_enable=1;
        flush=0;
        jump_sel=2'b00;
        EX_signals=13'b0000000000000;
        MEM_signals=7'b0000000;
        WB_signals=6'b000000;
        out_signal = 1'b0;
       end
        endcase
        end
        else if( |reti_state_before || opcode==RETI)   //RETI
        begin
        ret_state_after=3'b000;
        inter_state_after=2'b00;
         case(reti_state_before)
        NO_RETI:begin      //pop_flags
        reti_state_after=3'b001;
        f_d_buffer_enable=0;
        pc_enable=0;
        flush=0;
        jump_sel=2'b00;
        EX_signals=13'b0000110111001;
        MEM_signals=7'b1010000;
        WB_signals=6'b111000;
        out_signal = 1'b0;
        end
        POP_FLAGS:begin    //pop_1
        reti_state_after=3'b010;
        f_d_buffer_enable=0;
        pc_enable=0;
        flush=0;
        jump_sel=2'b00;
        EX_signals=13'b0000110111001;
        MEM_signals=7'b1010000;
        WB_signals=6'b101101;
        out_signal = 1'b0;
        end
        POP_1_RETI:begin   //pop_2
        reti_state_after=3'b011;
        f_d_buffer_enable=0;
        pc_enable=0;
        flush=0;
        jump_sel=2'b00;
        EX_signals=13'b0000110111001;
        MEM_signals=7'b1010000;
        WB_signals=6'b101111;
        out_signal = 1'b0;
        end
        POP_2_RETI:begin   //   NOP1
        reti_state_after=3'b100;
        f_d_buffer_enable=0;
        pc_enable=0;
        flush=0;
        jump_sel=2'b00;
        EX_signals=13'b0000000000000;
        MEM_signals=7'b0000000;
        WB_signals=6'b000000;
        out_signal = 1'b0;
        end
        NOP1_RETI:begin    //NOP2
        reti_state_after=3'b101;
        f_d_buffer_enable=0;
        pc_enable=1;
        flush=0;
        jump_sel=2'b11;
        EX_signals=13'b0000000000000;
        MEM_signals=7'b0000000;
        WB_signals=6'b000000;
        out_signal = 1'b0;
        end
        NOP2_RETI:begin   //NOP3
        reti_state_after=3'b000;
        f_d_buffer_enable=1;
        pc_enable=1;
        flush=0;
        jump_sel=2'b00;
        EX_signals=13'b0000000000000;
        MEM_signals=7'b0000000;
        WB_signals=6'b000000;
        out_signal = 1'b0;
        end
        endcase
        end
        else if(inst_before_call)  //call2
        begin 
        ret_state_after=3'b000;
        reti_state_after=3'b000;
        inter_state_after=2'b00;
        f_d_buffer_enable=1;
        pc_enable=1;
        flush=0;
        jump_sel=2'b00;
        EX_signals=13'b0000111011001;
        MEM_signals=7'b0111101;
        WB_signals=6'b100000;
        out_signal = 1'b0;
        end
        else 
        begin  
        ret_state_after=3'b000;
        reti_state_after=3'b000;
        inter_state_after=2'b00; 
        f_d_buffer_enable=1;
        pc_enable=1;
        flush=0; 
        case (opcode)
            NOP: begin                 //NOP
        jump_sel=2'b00;
        EX_signals=13'b0000000000000;
        MEM_signals=7'b0000000;
        WB_signals=6'b000000;
        out_signal = 1'b0;
            end
            SETC:begin        //SETC
        jump_sel=2'b00;
        EX_signals=13'b0000101000011;
        MEM_signals=7'b0000000;
        WB_signals=6'b000000;
        out_signal = 1'b0;
            end
            CLRC:begin         //CLCR
        jump_sel=2'b00;
        EX_signals=13'b0000101100011;
        MEM_signals=7'b0000000;
        WB_signals=6'b000000;
        out_signal = 1'b0;
            end
            NOT: begin        //NOT
        jump_sel=2'b00;
        EX_signals=13'b0000010100011;
        MEM_signals=7'b0000000;
        WB_signals=6'b000001;
        out_signal = 1'b0;
            end
            INC:begin           //INC
        jump_sel=2'b00;
        EX_signals=13'b0000000000011;
        MEM_signals=7'b0000000;
        WB_signals=6'b000001;
        out_signal = 1'b0;
            end
            DEC:begin      //DEC
        jump_sel=2'b00;
        EX_signals=13'b0000000100011;
        MEM_signals=7'b0000000;
        WB_signals=6'b000001;
        out_signal = 1'b0;
            end
            PUSH:begin         //PUSH
        jump_sel=2'b00;
        EX_signals=13'b0000111011001;
        MEM_signals=7'b0111001;
        WB_signals=6'b100000;
        out_signal = 1'b0;
            end
            POP:begin       //POP
        jump_sel=2'b00;
        EX_signals=13'b0000110111001;
        MEM_signals=7'b1010000;
        WB_signals=6'b101001;
        out_signal = 1'b0;
            end
            ADD: begin             //ADD
        jump_sel=2'b00;
        EX_signals=13'b0000001000011;
        MEM_signals=7'b0000000;
        WB_signals=6'b000001;
        out_signal = 1'b0;
            end
            SUB:begin        //SUB
        jump_sel=2'b00;
        EX_signals=13'b0000001100011;
        MEM_signals=7'b0000000;
        WB_signals=6'b000001;
        out_signal = 1'b0;
            end
            AND:begin          //AND
        jump_sel=2'b00;
        EX_signals=13'b0000011100011;
        MEM_signals=7'b0000000;
        WB_signals=6'b000001;
        out_signal = 1'b0;
            end
            OR:begin          //OR
        jump_sel=2'b00;
        EX_signals=13'b0000011000011;
        MEM_signals=7'b0000000;
        WB_signals=6'b000001;
        out_signal = 1'b0;
            end
            MOV:begin          //MOV
        jump_sel=2'b00;
        EX_signals=13'b0000010000001;
        MEM_signals=7'b0000000;
        WB_signals=6'b000001;
        out_signal = 1'b0;
            end
            SHL:begin             //SHL
        jump_sel=2'b00;
        EX_signals=13'b0000100000111;
        MEM_signals=7'b0000000;
        WB_signals=6'b000001;
        out_signal = 1'b0;
            end
            SHR:begin           //SHR
        jump_sel=2'b00;
        EX_signals=13'b0000100100111;
        MEM_signals=7'b0000000;
        WB_signals=6'b000001;
        out_signal = 1'b0;
            end
            LDM: begin               //LDM
        flush=1;
        jump_sel=2'b00;
        EX_signals=13'b0000010010001;
        MEM_signals=7'b0000000;
        WB_signals=6'b000001;
        out_signal = 1'b0;
            end
            LDD:begin          //LDD
        jump_sel=2'b00;
        EX_signals=13'b0000000000000;
        MEM_signals=7'b1000000;
        WB_signals=6'b001001;
        out_signal = 1'b0;
            end
            STD: begin      //STD
        jump_sel=2'b00;
        EX_signals=13'b0000000000000;
        MEM_signals=7'b0101000;
        WB_signals=6'b000000;
        out_signal = 1'b0;
            end
            JZ:begin              //JZ
        jump_sel=2'b00;
        EX_signals=13'b0010000000000;
        MEM_signals=7'b0000000;
        WB_signals=6'b000000;    
        out_signal = 1'b0;
            end
            JN:begin                 //JN
        jump_sel=2'b00;
        EX_signals=13'b0100101000000;
        MEM_signals=7'b0000000;
        WB_signals=6'b000000;       
        out_signal = 1'b0;
            end
            JC:begin                  //JC
        jump_sel=2'b00;
        EX_signals=13'b0110101000000;
        MEM_signals=7'b0000000;
        WB_signals=6'b000000;
        out_signal = 1'b0;
            end
            JMP:begin              //JMP
        flush=1;
        jump_sel=2'b01;
        EX_signals=13'b1000101000000;
        MEM_signals=7'b0000000;
        WB_signals=6'b000000;
        out_signal = 1'b0;
            end
            OUT:begin             //OUT
        jump_sel=2'b00;
        EX_signals=13'b0000110000001;
        MEM_signals=7'b0000000;
        WB_signals=6'b000000;
        out_signal = 1'b1;
            end
            IN:begin            //IN
        jump_sel=2'b00;
        EX_signals=13'b0000010001001;
        MEM_signals=7'b0000000;
        WB_signals=6'b000001;
        out_signal = 1'b0;
            end
            CALL:begin         //CALL
        f_d_buffer_enable=0;
        jump_sel=2'b01; 
        EX_signals=13'b0001111011001;
        MEM_signals=7'b0111110;
        WB_signals=6'b100000;
        out_signal = 1'b0;
            end
                default: begin //NOP
        jump_sel=2'b00;
        EX_signals=13'b0000000000000;
        MEM_signals=7'b0000000;
        WB_signals=6'b000000;
        out_signal = 1'b0;
            end
        endcase
        end
    end
endmodule