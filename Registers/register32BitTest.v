module test_32bit_register;
	//Load enable, clock y clear
	reg LE, Clk, Clr;

	//Input
	reg [31:0] D;

	//Output
	wire [31:0] Q;

	Register32 reg32 (Q,D,LE,Clr,Clk);

	//Clock signal
	initial begin
		Clk = 1'b0;
		forever begin
			#5 Clk = ~Clk;
		end
	end

	initial #500 $finish;


	initial begin
		//#200 $monitor ("Time = %d  Clk = %b",$time, Clk);

		#200 $display("\n32-Bit Register Test");
		$display("Time Clk Clr LE D Q");
		$monitor("%d %b %b %b %h %h",$time,Clk,Clr,LE,D,Q);
		
		D = 32'h0;
		LE = 0;
		Clr = 0; #255 Clr = 1; #260 Clr = 0; #355 Clr = 1;

		repeat (100) #5 begin
			D = D + 1;
		end

		fork
			
			#245 LE = 1; #275 LE = 0;
		join
		
	end

endmodule


