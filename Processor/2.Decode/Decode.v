module DecodeStage(clk, rst, data_in, data_out, regWrite, WD);

    localparam W = 16;
    localparam N = 3;
    localparam F_D_SIZE = 2*W;
    localparam D_E_SIZE = 18+3*W;

    input clk, rst, regWrite; //regWrite coming from WB
    input [W-1:0] WD; //WD coming from WB
    input [F_D_SIZE-1:0] data_in;
    output [D_E_SIZE-1:0] data_out;

    wire [5:0] opcode;
    wire [N-1:0] src;
    wire [N-1:0] dst;
    wire [3:0] shamt;
    wire [W-1:0] imm_D, Rsrc, Rdst;

    wire [4:0] MEM_signals; //memRead(1), memWrite(1), memAddress(2), memData(1)
    wire [5:0] EX_signals;  //ALUop(4+1enable), shamSelt(1)
    wire [2:0] WB_signals;  //regWrite(1), WBsel(2)


    Register #(F_D_SIZE) F_D_buffer(clk, rst, 1, data_in, {opcode, src, dst, shamt, imm_D});

    regFile #(W, N) regFile_inst(clk, rst, regWrite, WD, dst, src, dst, Rsrc, Rdst);

    Control_Unit CU(opcode, MEM_signals, EX_signals, WB_signals);

    Register #(D_E_SIZE) D_E_buffer(clk, rst, 1, {MEM_signals, EX_signals, WB_signals, Rsrc, Rdst, shamt, imm_D}, data_out);

endmodule
