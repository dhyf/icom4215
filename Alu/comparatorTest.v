module comparatorTest;

	wire [31:0] regDestination;

	comparator cmp(regDestination,-32'd4, 32'd3, 3'b000);


	initial begin
		
	
		$display ("\nComparator Test");
			
		$display ("regDestination");

		$monitor ("%d",regDestination);


	end
endmodule