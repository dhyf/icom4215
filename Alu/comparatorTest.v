module comparatorTest;

	wire [31:0] regDestination;

	comparator cmp(regDestination,32'hFFFFFFFF, 32'd3, 3'b100);


	initial begin
		
	
		$display ("\nComparator Test");
			
		$display ("regDestination %d", regDestination);

		$monitor ("%d",regDestination);


	end
endmodule