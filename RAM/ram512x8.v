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
	fd = $fopen("testcode_mips1.txt","r"); 
	index = 0;
	while (!($feof(fd))) begin
		code = $fscanf(fd, "%b", data);
		Mem[index]=data;
		$display("%d Reading from file=%b, Memory Content=%b",index,data,Mem[index]);
		index = index + 1;
	end
  	$fclose(fd);
  	$display("Test Program loaded in RAM...");
end

//Test instruction 1 (addu R0+R0 = R1) [00000000000000000000100000100001]
//Test instruction 2 (addu R1+R1 = R2) [00000000001000010001000000100001]
//Test instruction 3 (addiu R1+15 = R3) [00100100001000110000000000001111]
//Test instruction 4 (addiu R1+31 = R4) [00100100001001000000000000011111]
//Test instruction 5 (add R3+R4 = R15) [00000000011001000111100000100000]
//Test instruction 6 (sub R3-R4 = R14) [00000000011001000111000000100010]
//Test instruction 7 (mult R3 * R4) [00000000011001000000000000011000]
//Test instruction 8 (mult R3 * R14) [00000000011011100000000000011000]
//Test instruction 9 (lw Mem[R0+000101000] -> R7) [10001100000001110000000000101000]
//Test instruction 10 (sub R14-R7 = R8) [00000001110001110100000000100010]



//Test instruction x (movn) [00000000011011100000000000011000]

//Test instruction x (clo R4 -> R5) [01110001110001010000000000100001]

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
		
		$display("Reading from address: %b\t%d", address,address);

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
			dataOut[31:24] = 8'b0;
			dataOut[23:16] = 8'b0;
			$display("Reading halfword byte 0: %h", Mem[address]);
			dataOut[15:8] = Mem[address];
			$display("Reading halfword byte 1: %h", Mem[address+1]);
			dataOut[7:0] = Mem[address+1];
		end

		//Reading a single byte
		if(dataSize == 0) begin
			$display("Reading a byte");
			dataOut[31:24] = 8'b0;
			dataOut[23:16] = 8'b0;
			dataOut[15:8] = 8'b0;
			$display("Reading byte 0: %h", Mem[address]);
			dataOut[7:0] = Mem[address];
		end

	end

	memFuncComplete = 1;
	$display("Memory Function Complete: %b", memFuncComplete);

end

endmodule
