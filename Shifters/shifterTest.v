module shifterTest;

reg [3:0] Y;
reg [3:0] A;
reg [3:0] X;
reg [3:0] L,B,M;




	initial begin

	A = 4'b0110;
	Y = (A << 1);
	Y = (Y << 1);
	X = (Y << 1);

	B = 4'b1110;

	L = $signed(B) >>> 1;
	M = (Y <<< 1);
		
	

	
		$display ("\nShifter Test 2");

		$monitor ("%b %b  %b  %b  %b  %b",A , Y, X, B, L, M);



	end




endmodule