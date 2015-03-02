module test_mux_2x1;
		
	//Selection line
	reg S;

	//Inputs (4)
	reg [31:0] I0 = 32'h0;
	reg [31:0] I1 = 32'hFFFFFFFF;
	
	//Output
	wire [31:0] Y;

	//Instance of 2by1 mux
	mux_2x1 mux1 (Y, S, I0, I1);

	initial begin
		
		$display ("\n2x1 Mux Test");
		$display ("S   I0  I1  Y");
		
		//For S = 0, expect I0 as output
		S = 1'b0;
		#1 $display ("%b   %h   %h   %h", S, I0, I1, Y);

		//For S = 1, expect I1 as output
		S = 1'b1;
		#1 $display ("%b   %h   %h   %h", S, I0, I1, Y);

	end
endmodule
