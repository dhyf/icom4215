module test_32bit_register;
	//Load enable, clock y clear
	reg LE, Clk, Clr;

	//Input
	reg [31:0] D;

	//Output
	wire [31:0] Q;

	Register32 reg32 (Q,D,LE,Clr,Clk);

	initial #500 $finish;


	//Clock signal
	initial begin
		Clk = 1'b0;
		forever begin
			#5 Clk = ~Clk;
		end
	end

	

	initial fork
		#200 D = 32'h0;
		#200 LE = 0;
		#200 Clr = 1; #203 Clr = 0; #300 D = 32'haaaaffff; #350 LE = 1; #400 Clr = 1; #405 Clr = 0; #425 Clr = 1; #428 Clr = 0; 
	join


	initial begin
		//#200 $monitor ("Time = %d  Clk = %b",$time, Clk);

		#200 $display("\n32-Bit Register Test");
		$display("Time Clk Clr LE D Q");
		$monitor("%d %b %b %b %h %h",$time,Clk,Clr,LE,D,Q);
		
		
		//repeat (100) #5 begin
		//	D = D + 1;
		//end
		
	end

endmodule


