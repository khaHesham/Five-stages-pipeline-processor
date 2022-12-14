module Register #(parameter W=16)(clk, rst, w_enable, D, Q);
    input clk;
    input rst;
    input w_enable;
    input [W-1:0] D;
    output reg[W-1:0] Q;


    always @(posedge clk) begin
        if (rst) Q = 0; 
        else if(w_enable) Q = D;
    end
endmodule 

module Buffer #(parameter W=16)(clk, rst, w_enable, D, Q);
    input clk;
    input rst;
    input w_enable;
    input [W-1:0] D;
    output reg[W-1:0] Q;


    always @(posedge clk) begin
        if (rst) Q = 0; 
        else if(w_enable) Q = D;
    end
endmodule

module Register_neg #(parameter W=16)(clk, rst, w_enable, D, Q);
    input clk;
    input rst;
    input w_enable;
    input [W-1:0] D;
    output reg[W-1:0] Q;


    always @(negedge clk) begin
        if (rst) Q = 0; 
        else if(w_enable) Q = D;
    end
endmodule 
