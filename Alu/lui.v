module lui(output reg[31:0] result, input [31:0] A);

initial begin
//Guarda el input en los bits mas significativo del output.
result[31:16] = A;
//Hace clear a los bits menos significativos del output.
result[15:0] = 0;

end

endmodule