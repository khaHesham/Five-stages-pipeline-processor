module Memo (clk, rst, MEM_READ, MEM_WRITE, MEM_ADDR_SEL, MEM_DATA_SEL, Rsrc, Rdst, ALU, sp, pc, pc_plus, flags, RD);

    localparam W = 16;

    input clk, rst;

    input MEM_READ, MEM_WRITE;
    input [1:0] MEM_ADDR_SEL;
    input [2:0] MEM_DATA_SEL, flags;
    input [W-1:0] Rsrc, Rdst, ALU, sp;
    input [2*W-1:0] pc, pc_plus;

    output [W-1:0] RD;

    wire [W-1:0] WA, WD;

    MUX #(W, 2) addr_mux ('{sp, ALU, Rdst, Rsrc}, MEM_ADDR_SEL, WA);
    MUX #(W, 3) data_mux ('{16'b0, pc_plus[15:0], pc_plus[31:16], pc[15:0], pc[31:16], {13'b0, flags}, Rdst, Rsrc}, MEM_DATA_SEL, WD);

    always @(negedge clk) begin
        
    end

    Memory memo(clk, rst, MEM_READ, MEM_WRITE, WA[10:0], WD, RD);

endmodule
