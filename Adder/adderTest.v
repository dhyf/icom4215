module adderTest;


	
	wire[31:0] result;
	wire [3:0] C;

	adder suma(result,C,-32'd15,32'h1,2'b10);


	initial begin
		
	
		$display ("\nAdder Test");
			
		$display ("result	V   N   Z   C       A       B");

		$monitor ("%b       %b  %b   %b   %b    %d    %b", result, C[0], C[1], C[2], C[3], (4'd10), ~4'd2);


	end


endmodule