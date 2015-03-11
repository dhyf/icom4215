module test_512x8_ram;

	//Inputs
	reg memFuncActive;
	reg readWrite;
	reg [8:0] address;
	reg [31:0] dataIn;
	reg [1:0] dataSize;
	reg Clk;


	//Outputs
	wire [31:0] dataOut;
	wire memFuncComplete;

	ram512x8 ram (dataOut,memFuncComplete,memFuncActive,readWrite,address,dataIn,dataSize,Clk);

	initial #500 $finish;

	//Clock signal
	initial begin
		Clk = 1'b0;
		forever begin
			#1 Clk = ~Clk;
		end
	end

	

	initial fork
		//Writing and reading word
		#0 memFuncActive=1; #0 readWrite=1; #0 address=0; #0 dataIn=32'hAABBCCDD; #0 dataSize=2'b11;
		#25 memFuncActive=0;
		#50 memFuncActive=1; #50 readWrite=0; #50 address=0; #50 dataSize=2'b11;
		#75 memFuncActive=0;

		//Writing and reading halfword
		#100 memFuncActive=1; #100 readWrite=1; #100 address=4; #100 dataIn=32'h11EEFFAA; #100 dataSize=2'b01;
		#125 memFuncActive=0;
		#150 memFuncActive=1; #150 readWrite=0; #150 address=4; #150 dataSize=2'b01;
		#175 memFuncActive=0;

		//Writing and reading byte
		#200 memFuncActive=1; #200 readWrite=1; #200 address=6; #200 dataIn=32'h11EEFF22; #200 dataSize=2'b00;
		#225 memFuncActive=0;
		#250 memFuncActive=1; #250 readWrite=0; #250 address=6; #250 dataSize=2'b00;
		#275 memFuncActive=0;
	join


	initial begin

		$display("\n512-Byte RAM Test");
		$display("		Time dataOut MFC MFA RW ADDR dataIn dataSize");
		$monitor("%d %h %b %b %b %b %h %b",$time,dataOut,memFuncComplete,memFuncActive,readWrite,address,dataIn,dataSize);		
		
	end

endmodule


