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

always @ (memFuncActive, readWrite)

if(memFuncActive) begin
	
	memFuncComplete = 0;


	if(readWrite) begin
		//Writing a word (4 bytes)
		if(dataSize == 3) begin
			assign currentAddress = address;
			for(i = 3; i >= 0; i = i - 1) begin
				Mem[currentAddress] = dataByte[i];
				currentAddress = currentAddress + 1;
			end
		end


		//Writing a halfword (2 bytes)
		if(dataSize == 1) begin
			assign currentAddress = address;

			for(i = 1; i >= 0; i = i - 1) begin
				Mem[currentAddress] = dataByte[i];
				currentAddress = currentAddress + 1;
			end			
		end

		//Writing a single byte
		else Mem[address] = dataByte[3];

		//Writing complete
		memFuncComplete <= 1;
	end

	else begin
		
		//Reading a word (4 bytes)
		if(dataSize == 3) begin
			dataOut[31:24] = Mem[address];
			dataOut[23:16] = Mem[address + 1];
			dataOut[15:8] = Mem[address + 2];
			dataOut[7:0] = Mem[address + 3];
		end

		//Reading a halfword (2 bytes)
		if(dataSize == 1) begin
			// dataOut[31:24] = 8'b0;
			// dataOut[23:16] = 8'b0;
			dataOut[15:8] = Mem[address];
			dataOut[7:0] = Mem[address + 1];
		end

		//Reading a single byte
		else begin
			// dataOut[31:24] = 8'b0;
			// dataOut[23:16] = 8'b0;
			// dataOut[15:8] = 8'b0;
			dataOut[7:0] = Mem[address];
		end

	end

	memFuncComplete = 1;

end

endmodule
