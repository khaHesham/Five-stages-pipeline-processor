module Branch (branch_type,flags,branch);

localparam JZ = 3'b001;
localparam JN = 3'b010;
localparam JC = 3'b011;

input [2:0] branch_type;
input [2:0] flags;

output branch;

wire C,N,Z;


assign {C,N,Z} = flags;

assign branch=(branch_type==JZ && Z || branch_type==JN && N || branch_type==JC && C )? 1'b1 : 1'b0;

    
endmodule