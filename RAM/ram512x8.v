module ram512x8 (output reg [31:0] dataOut,
				  output reg memFuncComplete, 
				  input memFuncActive,
				  input readWrite,
				  input [8:0] address,
				  input [31:0] dataIn,
				  input [1:0] dataSize,
				  input Clk);

reg [7:0] Mem[0:511];

parameter word = 2'b11;
parameter halfWord = 2'b01;
parameter byte = 2'b00;

wire [7:0] dataByte[0:3];
reg [8:0] currentAddress;

assign dataByte[0] = dataIn[31:24];
assign dataByte[1] = dataIn[23:16];
assign dataByte[2] = dataIn[15:8];
assign dataByte[3] = dataIn[7:0];
integer i;

//Loading RAM with test program from text file

//To load test program from file
integer   fd, code, index;
reg [7:0] data;

initial begin
	$display("Loading test program to RAM...");
	fd = $fopen("testProgram.dat","r"); 
	index = 0;
	while (!($feof(fd))) begin
		code = $fscanf(fd, "%b", data);
		Mem[index]=data;
		$display("Reading from file=%b, Memory Content=%b",data,Mem[index]);
		index = index + 1;
	end
  	$fclose(fd);
  	$display("Test Program loaded in RAM...");
end

/*
//Loading RAM in time 0 (loading initial test program)
initial #0 begin
	$display("Loading test program to RAM...");
	//Test instruction 1 (addu R0+R0 = R1) [00000000000000000000100000100001]
	//Instruction 1 in bytes: B0=00000000, B1=00000000, B2=00001000, B3=00100001
	Mem[0] = 8'b00000000;
	Mem[1] = 8'b00000000;
	Mem[2] = 8'b00001000;
	Mem[3] = 8'b00100001;
	$display("Instruction 1 in memory loaded: %b %b %b %b", Mem[0],Mem[1],Mem[2],Mem[3]);
	//Test instruction 2 (addu R1+R1 = R2) [00000000001000010001000000100001]
	//Instruction 2 in bytes: B0=00000000, B1=00100001, B2=00010000, B3=00100001
	Mem[4] = 8'b00000000;
	Mem[5] = 8'b00100001;
	Mem[6] = 8'b00010000;
	Mem[7] = 8'b00100001;
	$display("Instruction 2 in memory loaded: %b %b %b %b", Mem[4],Mem[5],Mem[6],Mem[7]);
	//Test instruction 3 (add R1+15 = R3) [00100100001000110000000000001111]
	//Instruction 3 in bytes: B0=00100100, B1=00100011, B2=00000000, B3=00001111
	Mem[8] = 8'b00100100;
	Mem[9] = 8'b00100011;
	Mem[10] = 8'b00000000;
	Mem[11] = 8'b00001111;
	$display("Instruction 3 in memory loaded: %b %b %b %b", Mem[8],Mem[9],Mem[10],Mem[11]);
	$display("Test Program loaded in RAM...");
end
*/

always @ (memFuncActive, readWrite)

if(memFuncActive) begin
	
	$display("Memory active");

	memFuncComplete = 0;
	$display("Memory Function Complete: %b", memFuncComplete);


	if(readWrite) begin
		//Writing a word (4 bytes)
		if(dataSize == 3) begin
			$display("Writing a word");
			currentAddress = address;
			for(i = 3; i >= 0; i = i - 1) begin
				Mem[currentAddress] = dataByte[i];
				$display("Writing byte %h in address %d", dataByte[i], currentAddress);
				currentAddress = currentAddress + 1;
			end
		end


		//Writing a halfword (2 bytes)
		if(dataSize == 1) begin
			$display("Writing a halfword");
			currentAddress = address;
			for(i = 1; i >= 0; i = i - 1) begin
				Mem[currentAddress] = dataByte[i+2];
				$display("Writing byte %h in address %d", dataByte[i], currentAddress);
				currentAddress = currentAddress + 1;
			end			
		end

		//Writing a single byte
		if(dataSize == 0) begin
			$display("Writing a byte");
			Mem[address] = dataByte[3];
			$display("Writing byte %h in address %d", dataByte[3], address);
		end

		//Writing complete
		memFuncComplete <= 1;
	end

	else begin
		
		$display("Reading from address: %b", address);

		//Reading a word (4 bytes)
		if(dataSize == 3) begin
			$display("Reading a word");
			$display("Reading word byte 0: %h", Mem[address]);
			dataOut[31:24] = Mem[address];
			$display("Reading word byte 1: %h", Mem[address+1]);
			dataOut[23:16] = Mem[address + 1];
			$display("Reading word byte 2: %h", Mem[address+2]);
			dataOut[15:8] = Mem[address + 2];
			$display("Reading word byte 3: %h", Mem[address+3]);
			dataOut[7:0] = Mem[address+3];
		end

		//Reading a halfword (2 bytes)
		if(dataSize == 1) begin
			$display("Reading a halfword");
			// dataOut[31:24] = 8'b0;
			// dataOut[23:16] = 8'b0;
			$display("Reading halfword byte 0: %h", Mem[address]);
			dataOut[15:8] = Mem[address];
			$display("Reading halfword byte 1: %h", Mem[address+1]);
			dataOut[7:0] = Mem[address+1];
		end

		//Reading a single byte
		if(dataSize == 0) begin
			$display("Reading a byte");
			// dataOut[31:24] = 8'b0;
			// dataOut[23:16] = 8'b0;
			// dataOut[15:8] = 8'b0;
			$display("Reading byte 0: %h", Mem[address]);
			dataOut[7:0] = Mem[address];
		end

	end

	memFuncComplete = 1;
	$display("Memory Function Complete: %b", memFuncComplete);

end

endmodule
