module test_mux_2x1;
	reg [2: 0] I;
	wire Y;
	parameter sim_time = 100;
	mux_2x1 mux1 (Y, I[2], I[0], I[1]);
	initial #sim_time $finish;
	initial begin
		I = 3'b000;
		repeat (7) #10 I = I + 3'b001;
	end
	initial begin
		$display ("   S   I1  I0  Y");
		$monitor ("   %b   %b   %b   %b", I[2], I[1], I[0], Y);
	end
endmodule
