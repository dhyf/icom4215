module test_alu;

	//Inputs
	reg [3:0] operation;
	reg [31:0] A, B;
	reg [1:0] sign;


	//Outputs
	wire [31:0] Y, outLO, outHI;
	wire [3:0] carryFlags;

	alu alu10 (Y,outHI,outLO,carryFlags,operation,sign,A,B);

	initial fork	
		#0 operation=4'b0000; #0 sign=2'b00; #0 A=32'h1; #0 B=32'h1;
		#5 operation=4'b0100; #5 sign=2'b00; #5 A=32'h1; #5 B=32'h1;
		#10 operation=4'b0101; #10 sign=2'b00; #10 A=32'h1; #10 B=32'h1;
		#15 operation=4'b0110; #15 sign=2'b00; #15 A=32'h1; #15 B=32'h1;
		#20 operation=4'b0111; #20 sign=2'b00; #20 A=32'h1; #20 B=32'h1;
		#25 operation=4'b1000; #25 sign=2'b00; #25 A=32'h1; #25 B=32'h1;
		#30 operation=4'b1001; #30 sign=2'b00; #30 A=32'h1; #30 B=-32'd8;
		#35 operation=4'b1010; #35 sign=2'b00; #35 A=32'h1; #35 B=32'd2;
		#40 operation=4'b0001; #40 sign=2'b00; #40 A=32'h5; #40 B=32'd2;
		#45 operation=4'b0001; #45 sign=2'b00; #45 A=32'h2; #45 B=32'd2;
		#50 operation=4'b0010; #50 sign=2'b00; #50 A=32'h8; #50 B=32'd4;
		#55 operation=4'b0011; #55 sign=2'b00; #55 A=32'h8; #55 B=32'd3;
	join

	initial begin

		$display("\nALU Test");
		$display("time operation A B sign Y carryFlags outLO outHI");
		$monitor("%d %b %h %h %b %h %b %h %h ",$time,operation,A,B,sign,Y,carryFlags, outLO, outHI);
		
	end

endmodule
