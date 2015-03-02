module test_mux_4x1;
	//Selection lines (2)
	reg [1:0] S;

	//Inputs (4)
	reg [31:0] I0;
	reg [31:0] I1;
	reg [31:0] I2;
	reg [31:0] I3;

	//Output
	wire [31:0] Y;

	mux_4x1 mux2 (Y, S, I0, I1, I2, I3);
	initial #100 begin
		S = 2'b00;
		I0 = 32'h0000AAAA;
		I1 = 32'hAAAA0000;
		I2 = 32'h0000FFFF;
		I3 = 32'hFFFF0000;
		
		$display ("\n4x1 Mux Test");
		$display ("S   I0   I1   I2   I3   Y");
		$monitor ("%b   %h   %h   %h   %h   %h", S, I0, I1, I2, I3, Y);

		repeat (3) #1 begin
			S = S + 1;
		end

	end
endmodule
