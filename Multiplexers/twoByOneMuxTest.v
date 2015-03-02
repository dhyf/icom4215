module test_mux_2x1;
	reg S;
	reg [31: 0] I0;
	reg [31: 0] I1;
	wire [31:0] Y;

	parameter sim_time = 100;
	mux_2x1 mux1 (Y, S, I0, I1);
	initial #sim_time $finish;
	initial begin
		S = 1'b1;
		I0 = 32'h0;
		I1 = 32'hFFFFFFFF;
		
		repeat (32) #10
			S = ~S;
			I0 = I0 + 32'b1;
			I1 = I1 - 32'b1;
		end

	initial begin
		$display ("   S   I0  I1  Y");
		$monitor ("   %b   %h   %h   %h", S, I0, I1, Y);
	end
endmodule
