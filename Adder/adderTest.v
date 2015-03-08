module adderTest;


	
	wire [31:0] result;
	wire carry;

	adder suma(result,carry,32'hFFFFFFFF,32'd1);

	initial begin
		
	
		$display ("\nAdder Test");
			
		$display ("result	carry");

		$monitor ("%b   %b", result, carry);


	end


endmodule