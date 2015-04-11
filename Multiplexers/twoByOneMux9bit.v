module mux_2x1_9bit  (output reg [8:0] Y, input S, input [8:0] I0 , I1);
always @ (S, I0, I1)
if (S) Y = I1;
else Y = I0;
endmodule
