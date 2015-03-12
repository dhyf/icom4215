module adderTest;


	
	wire[3:0] result;
	wire [3:0] C;

	adder suma(result,C,-4'd5,-4'd8,1);


	initial begin
		
	
		$display ("\nAdder Test");
			
		$display ("result	V   N   Z   C       A       B");

		$monitor ("%b       %b  %b   %b   %b    %d    %d", result, C[0], C[1], C[2], C[3], -(4'd10), 4'd12);


	end


endmodule