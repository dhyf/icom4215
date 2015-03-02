module mux_2x1  (output reg Y[31:0], input S, I0[31:0], I1[31:0]);
always @ (S, I0, I1)
if (S) Y = I1;
else Y = I0;
endmodule

