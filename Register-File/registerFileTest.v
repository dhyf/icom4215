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
		//Writing number d10 in register 5, RW=1 (write)
		#0 dataRD = 32'd10; #0 RD = 5'b00101; #0 RW = 1;
		//Reading content of register 5 through RS
		#50 RS = 5'b00101; #50 RW = 0;
		//Writing number d5 in register 6, RW=1 (write)
		#100 dataRD = 32'd5; #100 RD = 5'b00110; #100 RW = 1;
		//Reading content of register 6 through RT
		#150 RT = 5'b00110; #150 RW = 0;
		//Writing sum of RS (register 5) and RT (register 6) in register 7, RW=1 (write)
		#200 dataRD = dataRS + dataRT; #200 RD = 5'b00111; #200 RW = 1;
		//Reading sum of 10 and 5 (15) from register 7 through RS and RT
		#250 RT = 5'b00111; #250 RS = 5'b00111; #250 RW = 0;
		//Trying to write to register 0 decimal value 100, RW=1
		#300 dataRD = 32'd100; #300 RD = 5'b00000; #300 RW = 1;
		//Reading value of register 0, permanently value 0
		#350 RT = 5'b00000; #350 RW = 0;
	join


	initial begin

		$display("\nRegister File Test");
		$display("		Time dataRD dataRS dataRT RD RS RT RW");
		$monitor("%d %d %d %d %b %b %b %b",$time,dataRD,dataRS,dataRT,RD,RS,RT,RW);		
		
	end

endmodule


