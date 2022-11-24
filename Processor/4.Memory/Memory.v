//for instruction memory set SIZE = 20
module Memory #(parameter WORD_SIZE = 16, SIZE = 11)(clk, rst, memRead, memWrite, addr, WD, RD);
    input clk;
    input rst;
    input memRead;
    input memWrite;

    input [SIZE-1:0] addr;
    input [WORD_SIZE-1:0] WD;
  
    output [WORD_SIZE-1:0] RD;

    reg [WORD_SIZE-1:0] mem [2**SIZE-1:0];
    reg [WORD_SIZE-1:0] RD;

    integer i;
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 2**SIZE; i = i + 1)
                mem[i] = 0;
        end 
        else if(memRead) RD = mem[addr];        
        else if(memWrite) mem[addr] = WD;
    end
endmodule
