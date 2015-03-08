module test_register_file;

	//Inputs
	reg [4:0] RD;
	reg [4:0] RS;
	reg [4:0] RT;
	reg [31:0] dataRD;
	reg RW;
	reg Clk;

	//Outputs
	wire [31:0] dataRS;
	wire [31:0] dataRT;

	register_file regFile (dataRS,dataRT,RD,RS,RT,dataRD,RW,Clk);

	initial #500 $finish;

	//Clock signal
	initial begin
		Clk = 1'b0;
		forever begin
			#1 Clk = ~Clk;
		end
	end

	

	initial fork
		#0 dataRD = 32'd10; #0 RD = 5'b00101; #0 RW = 1;
		#50 RS = 5'b00101; #50 RW = 0;
		#100 dataRD = 32'd5; #100 RD = 5'b00110; #100 RW = 1;
		#150 RT = 5'b00110; #150 RW = 0;
		#200 dataRD = dataRS + dataRT; #200 RD = 5'b00111; #200 RW = 1;
		#250 RT = 5'b00111; #250 RS = 5'b00111; #250 RW = 0;
		#300 dataRD = 32'd100; #300 RD = 5'b00000; #300 RW = 1;
		#350 RT = 5'b00000; #350 RW = 0;
	join


	initial begin

		$display("\nRegister File Test");
		$display("		Time dataRD dataRS dataRT RD RS RT RW");
		$monitor("%d %d %d %d %b %b %b %b",$time,dataRD,dataRS,dataRT,RD,RS,RT,RW);		
		
	end

endmodule


