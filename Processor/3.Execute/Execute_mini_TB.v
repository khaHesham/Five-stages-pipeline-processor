
module TB;
  
  reg [15:0] A,B;
  reg [3:0] shiftamount;
  reg [3:0] Function_Control;
  reg ALU_EN;

  wire [15:0] ALU_Out;
  wire CarryOut,NegativeFlag,ZeroFlag;

  ALU testALU(A,B,ALU_EN,Function_Control,shiftamount,ALU_Out,CarryOut,NegativeFlag,ZeroFlag);

  initial begin

    ALU_EN=1;
    A = 10;
    B = 20;  
    Function_Control=3;  //sub

    #100;
    A = 20;
    B=  20;  
    Function_Control=2;  //add

    #100;
    B=16'b1111111111111111;
    Function_Control=0;  //inc checking limits   TODO: this case needs to be handled because i dont think carry will be equal 1

    #100;
    B=20;
    Function_Control=0;  //inc normal increament

    #100;
    B = 20;  
    Function_Control=1;  //dec

    #100;
    B = 0;  
    Function_Control=1;  //dec

    #100;
    A = 20;
    B=  20;  
    Function_Control=4;  //mov

    #100;
    B =  16'b0000000011111111;  
    Function_Control=5;  //not

    #100;
    A = 16'b0101010101010101;
    B=  16'b1010101010101010;  
    Function_Control=6;  //or

    #100;
    A = 16'b0101010101010101;
    B=  16'b1010101010101010;  
    Function_Control = 7;  //and


    #100;
    A = 16'b001111111111111000;  
    Function_Control = 8;  //shl   TODO: check flags
    shiftamount = 2;

    #100;
    A = 16'b001111111111111000;  
    Function_Control = 9;  //shr   TODO: check flags
    shiftamount = 2;

    #100; 
    Function_Control=10;  //SETC

    #100; 
    Function_Control=11;  //CLC

  end

endmodule