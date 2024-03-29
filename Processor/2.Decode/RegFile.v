module regFile #(parameter W=16 ) (clk, rst, regWrite, WD, WA, src, dst, Rsrc, Rdst);
    
    localparam N=3;
    
    input clk;
    input rst;
    input regWrite;

    input [W-1:0] WD;
    input [N-1:0] WA;
    input [N-1:0] src;
    input [N-1:0] dst;
    
    output [W-1:0] Rsrc;
    output [W-1:0] Rdst;

    // wire [2**N-1:0] w_enable; 
    // wire [W-1:0] mux_lines [2**N-1:0];

    // Decoder decoder(WA, w_enable);

    // genvar i;
    // generate
    //     for (i = 0; i < 2**N; i = i+1) begin
    //         Buffer_neg #(W) register(clk, rst, w_enable[i]&regWrite, WD, mux_lines[i]);
    //     end
    // endgenerate

    // MUX #(W, N) mux_src(mux_lines, src, Rsrc);
    // MUX #(W, N) mux_dst(mux_lines, dst, Rdst);

    integer i;

    reg [W-1:0] reg_file [2**N-1:0];

    assign Rsrc = reg_file[src];
    assign Rdst = reg_file[dst];

    always @(negedge clk) begin
        if (rst) begin
            for (i = 0; i < 2**N; i=i+1) begin
                reg_file[i] = 0;
            end
        end
        else if(regWrite) reg_file[WA] = WD; 
    end

endmodule
