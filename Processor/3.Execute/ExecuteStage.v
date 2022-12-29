`include "../2.Decode/Register.v"

module ExecuteStage (clk,rst,EX,FU_Src_Sel,FU_Dst_Sel,flags_wb,Rsrc,Rdst,shiftamount,Immediate,SP_Low,IN_PORT,ALU_After_E_M,WB,ALU_Result,flags_out);

// {* =======================  CONSTANTS  ====================== *}

localparam W = 16;

// Rsrc_sel:
localparam Rsrc_M1=2'b00;
localparam IN_M1=2'b01;
localparam Imm_M1=2'b10;

// Rdst_sel:
localparam Rdst_M2=2'b00;
localparam shamt_M2=2'b01;
localparam sp_M2=2'b10;

// FU selectors
localparam Mux_output=2'b00;
localparam wb=2'b01;
localparam ALU_out_after_E_M = 2'b10;




// {* ======================= SIGNALS IN ======================= *} 

input clk,rst;
input [13:0] EX;            // Execute Signals
input [1:0] FU_Src_Sel;     // FU 3rd mux selectors
input [1:0] FU_Dst_Sel;     // FU 4th mux selectors
input flags_wb;


// {* ========================  DATA IN  ======================= *}

input [W-1:0] Rsrc;
input [W-1:0] Rdst;
input [3:0] shiftamount;
input [W-1:0] Immediate;
input [W-1:0] SP_Low;
input [W-1:0] IN_PORT;
input [W-1:0] ALU_After_E_M;
input [W-1:0] WB;

// {* ========================  DATA OUT  ======================= *}

output [W-1:0] ALU_Result;
output [W-1:0] flags_out;


// {* ======================= Registers & Wires ======================= *} 
wire [2:0] Flags;       // CarryOut(1),NegativeFlag(1),ZeroFlag(1) 
wire [2:0] f_out;
wire [2:0] f_in;

reg [W-1:0] A;          // first operand of ALU
reg [W-1:0] B;          // second operand of ALU
reg [W-1:0] M1_output;  // output of First Mux  
reg [W-1:0] M2_output;


// Handle selectors
always @(*) begin
    case(EX[6:4])  // 1st Mux
        Rsrc_M1:
            begin
                M1_output = Rsrc;
            end
        IN_M1:
            begin
                M1_output = IN_PORT;
            end
        
        Imm_M1:
            begin
                M1_output = Immediate;
            end
        default:
            begin
                M1_output = Rsrc;
            end
    endcase

    case(EX[4:2])  // 2nd Mux
        Rdst_M2:
            begin
                M2_output = Rdst; 
            end

        shamt_M2:
            begin
                M2_output = {12'b000000000000,shiftamount};
            end   

        sp_M2:
            begin
                M2_output = SP_Low;
            end
        default:
            begin
                M2_output = Rdst;
            end
    endcase

    case(FU_Src_Sel)  // 2nd Mux
        Mux_output:
            begin
                A = M1_output; 
            end

        wb:
            begin
                A = WB;
            end   

        ALU_out_after_E_M:
            begin
                A = ALU_After_E_M;
            end
        default:
            begin
                A = M1_output;
            end
    endcase

    case(FU_Dst_Sel)  // 2nd Mux
        Mux_output:
            begin
                B = M2_output; 
            end

        wb:
            begin
                B = WB;
            end   

        ALU_out_after_E_M:
            begin
                B = ALU_After_E_M;
            end
        default:
            begin
                B = M2_output;
            end
    endcase
end


ALU ourALU(A,B,EX[0],EX[9:6],shiftamount,ALU_Result,Flags[2],Flags[1],Flags[0]);

assign f_in=(flags_wb)? WB[3:0] : Flags;

Register_neg #(3) flags_inst(clk, rst, EX[1] | flags_wb, f_in, f_out);

assign flags_out = {13'b0000000000000,f_out};




    
endmodule