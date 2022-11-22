// Generic mux
// W: input and output width
// N: number of bits of the sel. for example an 8x1 mux has N=3

module MUX #(parameter W=16, N=1)(in, sel, out);
    input [W-1:0] in [2**N-1:0];
    input [N-1:0] sel;
    output [W-1:0] out;

    assign out = in[sel];
endmodule