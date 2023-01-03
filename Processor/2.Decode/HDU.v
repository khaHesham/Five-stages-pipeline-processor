module HDU (src_F_D, dst_F_D, dst_D_E, MEM_READ, F_D_ENB, PC_ENB, FLUSH_LOAD_USE, HAZARD_POP);

    input [2:0] src_F_D, dst_F_D, dst_D_E;
    input MEM_READ, HAZARD_POP;

    output F_D_ENB, PC_ENB, FLUSH_LOAD_USE;

    wire load_use;

    assign load_use = MEM_READ && ((dst_D_E == src_F_D) || (dst_D_E == dst_F_D)) && HAZARD_POP;

    assign F_D_ENB = load_use? 0: 1;
    assign PC_ENB = load_use? 0: 1;
    assign FLUSH_LOAD_USE = load_use? 1: 0;
endmodule
