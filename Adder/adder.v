module adder(output [31:0] result, output  C, input [31:0] A,B);


assign{C,result} = A + B;


endmodule