module mux_2x1  (output reg Y, input S, I0, I1);
always @ (S, I0, I1)
if (S) Y = I1;
else Y = I0;
endmodule

