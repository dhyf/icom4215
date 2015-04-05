module controlUnit (output reg regFileRW,
					output reg [4:0] regFileRD,regFileRS,regFileRT,
					output reg [1:0] aluSign,
					output reg [3:0] aluOperation,
					output reg [1:0] ramDataSize,
					output reg ramMFA,
					output reg ramRW,
					output reg [8:0] ramAddress,
					output reg regFileEnable, pcEnable, irEnable, marEnable, mdrEnable,
					output reg [1:0] muxSignals, //M0, M1 from data path diagram (mux to ALU(B))
					output reg muxSignals2, //S from data path diagram (mux to MDR)
					output reg muxSignals3, //Mux selector to load HI/LO registers in mult and div
					output reg muxSignals4, //Mux selector for imm16, unsigned = 0, sign ext = 1
					input [31:0] instruction,
					input [3:0] aluCarryFlags,
					input ramMFC,
					input reset,
					input hardwareInterrupt,
					input maskableInterrupt,
					input Clk);

reg [9:0] state,nextState;

wire [5:0] opcode;
assign opcode = instruction[31:26];

wire [5:0] functionCode;
assign functionCode = instruction[5:0];

initial begin
    state=9'd0; //Initial state, no operation? 
    nextState=9'd1;    
end

always @ (instruction, aluCarryFlags, ramMFC, reset,hardwareInterrupt,maskableInterrupt, state) begin
	if(state == 9'd0) begin
		$display("Inside state 0");
		nextState=9'd1;
	end

	else if(state == 9'd1) begin
		$display("Inside state 1");
		nextState=9'd2;
		aluOperation=4'b0000;
		muxSignals=2'b11;
		regFileEnable=0;
		irEnable=0;
		pcEnable=0;
		marEnable=1;
		mdrEnable=0;
		ramMFA=0;
	end

	else if(state == 9'd2) begin
		$display("Inside state 2");
		nextState=9'd3;
		aluOperation=4'b1011;
		muxSignals=2'b11;
		regFileEnable=0;
		irEnable=0;
		pcEnable=1;
		marEnable=0;
		mdrEnable=0;
		ramRW=1;
		ramMFA=1;
	end

	else if(state == 9'd3) begin
		$display("Inside state 3");
		$display("ramMFC= %b",ramMFC);
		if(ramMFC) begin
			$display("Going to state 4");
			nextState=9'd4;
			regFileEnable=0;
			irEnable=0;
			pcEnable=0;
			marEnable=0;
			mdrEnable=0;
			ramRW=1;
			ramMFA=1;
		end
		else nextState=9'd3;
	end

	else if(state == 9'd4) begin
		$display("Inside state 4");
		nextState=9'd255;
		regFileEnable=0;
		irEnable=1;
		pcEnable=0;
		marEnable=0;
		mdrEnable=0;
		ramRW=1;
		ramMFA=1;
	end

	else if(state == 9'd255) begin
		$display("Inside state 255 (DECODE)");
		$display("Opcode = %b", opcode);
		$display("Function Code = %b", functionCode);
		if(opcode == 6'b000000) begin
			$display("Inside opcode 000000");
			if(functionCode == 6'b100000) begin
				$display("ADDU: Inside function code 100000");
				nextState=9'd5;
			end
			else begin
				$display("Invalid instruction: function code not found"); //function code not found
				nextState = 9'd1;
			end
		end
		else begin
			$display("Invalid instruction: opcode not found"); //Opcode not found
			nextState = 9'd1;
		end
	end

	else if(state == 9'd5) begin
		$display("ADDU: Inside state 5");
		nextState = 9'd1;
		aluOperation=4'b0001;
		muxSignals=2'b00;
		regFileRS = instruction[25:21];
		regFileRT = instruction[20:16];
		regFileRD = instruction[15:11];
		regFileEnable=1;
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=0;
		regFileRW=1;
		ramMFA=0;
		aluSign=2'b00;
	end

end

always @(Clk) begin
    state = nextState;
end

endmodule
