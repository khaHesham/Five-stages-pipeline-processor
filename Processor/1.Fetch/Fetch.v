module fetch #(parameter W=16, SIZE=20)(clk, rst, Rdst_D, Rdst_E, WD, BRANCH, FLUSH, PC_ENB, POP_L_H, JUMP_SEL, instr, imm, pc, pc_1);
    
    localparam START_ADDRESS = -1; //initial value of pc
    localparam ISR = 32'b0; //interrupt service routine address
    localparam NOP = 16'b0;

    input clk, rst, BRANCH, FLUSH, PC_ENB;
    input [1:0] JUMP_SEL, POP_L_H;
    input [W-1:0] Rdst_D, Rdst_E, WD;

    output [W-1:0] instr, imm;
    output [2*W-1:0] pc, pc_1;

    reg [W-1:0] memoinst[2**SIZE-1:0];

    wire [2:0] pc_select;
    wire [2*W-1:0] ret_address, pop_in, pc_in; 

    initial $readmemb("memory.txt", memoinst);

    assign pc_select = BRANCH? 3'b100: {1'b0, JUMP_SEL};

    //A temp register is used to buffer the popped address on two cycles.
    //The higher word is padded with 0's while the lower word is concatenated with the higher
    //The most significant bit in POP_L_H acts as an enable while the least
    //determines which word will be written.
    assign  pop_in = (POP_L_H[0] == 1)? {WD, 16'b0}: {ret_address[31:16], WD};

    Register #(2*W) pc_pop (clk, rst, POP_L_H[1], pop_in, ret_address);

    MUX #(2*W, 3) pc_mux ('{32'b0, 32'b0, 32'b0, Rdst_E, ret_address, ISR, Rdst_D, pc+1}, pc_select, pc_in);

    Register #(2*W, START_ADDRESS) pc_inst(clk, rst, PC_ENB, pc_in, pc);

    assign pc_1 = pc+1;

    assign instr = (FLUSH || BRANCH)? NOP: memoinst[pc];
    assign imm = memoinst[pc];

endmodule
