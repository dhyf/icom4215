module test_decoder_5x32;

	reg [4:0] S;

	wire [31:0] D;

	decoder_5_32 dec1 (D,S);

	initial begin
		
		S = 5'b0;

		$display ("\n5x32 Decoder Test");
			
		$display ("S   	D");

		$monitor ("%b   %b", S, D);

		repeat (31) #1 begin
			S = S + 1;
		end

	end

endmodule
