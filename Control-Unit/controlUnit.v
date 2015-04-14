module controlUnit (output reg [31:0] nextPC,
					output reg muxSignals5,
					output reg [2:0] cmpsignal,
					output reg trapMux,
					output reg signExtend, //Sign extension for imm16 1=y 0=n, x otherwise
					output reg clearPC, //Used for reset
					output reg regFileRW,
					output reg [4:0] regFileRD,regFileRS,regFileRT,
					output reg [1:0] aluSign,
					output reg [3:0] aluOperation,
					output reg [1:0] ramDataSize,
					output reg ramMFA,
					output reg ramRW,
					output reg [8:0] ramAddress,
					output reg pcEnable, irEnable, marEnable, mdrEnable,
					output reg [1:0] muxSignals, //M0, M1 from data path diagram (mux to ALU(B))
					output reg muxSignals2, //S from data path diagram (mux to MDR)
					output reg [1:0] muxSignals3, //Mux selector to load HI/LO registers in mult and div
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

initial #1 begin
    state=9'd0; //Initial state, no operation? 
    nextState=9'd1;    
end

always @ (instruction, aluCarryFlags, ramMFC, reset,hardwareInterrupt,maskableInterrupt, state) begin
	

	$display("Current instruction from IR: %b",instruction);

	//Reset state
	if(state == 9'd0) begin
		clearPC=1;
		$display("Clear PC in state 0: %b", clearPC);
		$display("Inside state 0");
		nextState=9'd1;
	end

	//Begin FETCH states 1-4
	else if(state == 9'd1) begin
		$display("Inside state 1");
		nextState=9'd2;
		clearPC=0; //Setting pcClear to 0 after reset (not in signals table)
		$display("Clear PC in state 1: %b", clearPC);
		aluOperation=4'b0000;
		muxSignals=2'b11;
		irEnable=0;
		pcEnable=0;
		$display("MAR enable in state 1: %b", marEnable);
		marEnable=1;
		mdrEnable=0;
		trapMux=0;
		ramMFA=0;
		regFileRW=0;
	end

	else if(state == 9'd2) begin
		$display("Inside state 2");
		// if(jmp) begin
		// 	muxSignals5 = 1;
		// 	jmp = 0;
		// end
		// else begin
		// 	muxSignals5 = 0;
		// end
		nextState=9'd3;
		aluOperation=4'b1011;
		muxSignals=2'b11;
		irEnable=0;
		pcEnable=1;
		marEnable=0;
		mdrEnable=0;
		ramRW=0;
		ramMFA=1;
		regFileRW=0;
		trapMux=0;
		ramDataSize = 2'b11;
	end

	else if(state == 9'd3) begin
		pcEnable=0;
		regFileRW=0;
		ramDataSize = 2'b11;
		$display("Inside state 3");
		$display("ramMFC= %b",ramMFC);
		if(ramMFC) begin
			$display("Going to state 4");
			nextState=9'd4;
		end
		else nextState=9'd3;
	end

	else if(state == 9'd4) begin
		$display("Inside state 4");
		nextState=9'd255;
		irEnable=1;
		pcEnable=0;
		marEnable=0;
		mdrEnable=0;
		ramMFA=0;
		regFileRW=0;
	end
	//End FETCH states 1-4

	//Begin Decode state (255)
	else if(state == 9'd255) begin
		regFileRW=0;
		$display("Inside state 255 (DECODE)");
		$display("Opcode = %b", opcode);
		$display("Function Code = %b", functionCode);
		if(opcode == 6'b000000) begin
			$display("Opcode = %b", opcode);
			if(functionCode == 6'b100001) begin
				$display("Function Code = %b", functionCode);
				nextState=9'd5; //addu
			end
			else if(functionCode == 6'b100000) begin
				nextState=9'd6; //add
			end
			else if(functionCode == 6'b100010) begin
				nextState=9'd7; //subu
			end
			else if(functionCode == 6'b100011) begin
				nextState=9'd8; //sub
			end
			else if(functionCode == 6'b011010) begin
				nextState=9'd11; //divu
			end
			else if(functionCode == 6'b011011) begin
				nextState=9'd12; //div
			end
			else if(functionCode == 6'b011000) begin
				nextState=9'd10; //multu
			end
			else if(functionCode == 6'b011001) begin
				nextState=9'd9; //mult
			end
			else if(functionCode == 6'b100100) begin
				nextState=9'd13; //and
			end
			else if(functionCode == 6'b100101) begin
				nextState=9'd14; //or
			end
			else if(functionCode == 6'b100110) begin
				nextState=9'd15; //xor
			end
			else if(functionCode == 6'b100111) begin
				nextState=9'd25; //nor
			end
			else if(functionCode == 6'b000000) begin
				nextState=9'd17; //sll
			end
			else if(functionCode == 6'b000011) begin
				nextState=9'd18; //sra
			end
			else if(functionCode == 6'b000010) begin
				nextState=9'd16; //srl
			end
			else begin
				$display("Invalid instruction: function code not found"); //function code not found
				nextState = 9'd1;
			end
		end
		else if(opcode == 6'b001000) begin
			nextState = 9'd21; //addi
		end
		else if(opcode == 6'b001001) begin
			nextState = 9'd20; //addiu
		end
		else if(opcode == 6'b001100) begin
			nextState = 9'd22; //andi
		end
		else if(opcode == 6'b001111) begin
			nextState = 9'd19; //lui
		end
		else begin
			$display("Invalid instruction: opcode not found"); //Opcode not found
			nextState = 9'd1;
		end
	end
	//End Decode state (255)

	//Add unsigned
	else if(state == 9'd5) begin
		$display("ADDU: Inside state 5");
		nextState = 9'd1;
		aluOperation=4'b0001;
		muxSignals=2'b00;
		regFileRS = instruction[25:21];
		regFileRT = instruction[20:16];
		regFileRD = instruction[15:11];
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=0;
		ramMFA=0;
		aluSign=2'b00;
		muxSignals3=2'b00;
		regFileRW=1;
	end


	//Add signed (generates overflow trap)
	else if(state == 9'd6) begin
		$display("ADD: Inside state 6");
		nextState = 9'd254;
		aluOperation=4'b0001;
		muxSignals=2'b00;
		muxSignals3=2'b00;
		regFileRS = instruction[25:21];
		regFileRT = instruction[20:16];
		regFileRD = instruction[15:11];
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=0;
		regFileRW=0;
		ramMFA=0;
		aluSign=2'b10;
	end

	//Check for overflow
	else if(state == 9'd254) begin
		if(aluCarryFlags[0]) begin
			ramAddress = 9'd448; //Address for overflow trap
			nextState=9'd3;
				irEnable=0;
			pcEnable=0;
			marEnable=0;
			mdrEnable=0;
			ramRW=0;
			ramMFA=1;
			trapMux=1;
		end
		else begin
			nextState = 9'd1;
				regFileRW=1;
		end
	end

	//Subtract unsigned
	else if(state == 9'd7) begin
		$display("SUBU: Inside state 7");
		nextState = 9'd1;
		aluOperation=4'b0001;
		muxSignals=2'b00;
		muxSignals3=2'b00;
		regFileRS = instruction[25:21];
		regFileRT = instruction[20:16];
		regFileRD = instruction[15:11];
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=0;
		regFileRW=1;
		ramMFA=0;
		aluSign=2'b01;
	end

	//Subtract signed (generates overflow)
	else if(state == 9'd8) begin
		$display("SUB: Inside state 8");
		nextState = 9'd254;
		aluOperation=4'b0001;
		muxSignals=2'b00;
		muxSignals3=2'b00;
		regFileRS = instruction[25:21];
		regFileRT = instruction[20:16];
		regFileRD = instruction[15:11];
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=0;
		regFileRW=0;
		ramMFA=0;
		aluSign=2'b11;
	end

	//Mult signed
	else if(state == 9'd9) begin
		nextState = 9'd1;
		aluOperation = 4'b0010;
		muxSignals = 2'b00;
		regFileRS = instruction[25:21];
		regFileRT = instruction[20:16];
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=0;
		ramMFA=0;
		aluSign[1] = 1;
		regFileRW = 0;
	end

	//Mult unsigned
	else if(state == 9'd10) begin
		nextState = 9'd1;
		aluOperation = 4'b0010;
		muxSignals = 2'b00;
		regFileRS = instruction[25:21];
		regFileRT = instruction[20:16];
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=0;
		ramMFA=0;
		aluSign[1] = 0;
		regFileRW = 0;
	end

	//Div unsigned
	else if(state == 9'd11) begin
		nextState = 9'd1;
		aluOperation = 4'b0011;
		muxSignals = 2'b00;
		regFileRS = instruction[25:21];
		regFileRT = instruction[20:16];
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=0;
		ramMFA=0;
		aluSign[1] = 0;
		regFileRW = 0;
	end

	//Div signed
	else if(state == 9'd12) begin
		nextState = 9'd1;
		aluOperation = 4'b0011;
		muxSignals = 2'b00;
		regFileRS = instruction[25:21];
		regFileRT = instruction[20:16];
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=0;
		ramMFA=0;
		aluSign[1] = 1;
		regFileRW = 0;
	end

	//And
	else if(state == 9'd13) begin
		nextState = 9'd1;
		aluOperation = 4'b0100;
		muxSignals = 2'b00;
		regFileRS = instruction[25:21];
		regFileRT = instruction[20:16];
		regFileRD = instruction[15:11];
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=0;
		ramMFA=0;
		muxSignals3=2'b00;
		regFileRW=1;
	end

	//Or
	else if(state == 9'd14) begin
		nextState = 9'd1;
		aluOperation = 4'b0101;
		muxSignals = 2'b00;
		regFileRS = instruction[25:21];
		regFileRT = instruction[20:16];
		regFileRD = instruction[15:11];
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=0;
		ramMFA=0;
		muxSignals3=2'b00;
		regFileRW=1;
	end

	//Xor
	else if(state == 9'd15) begin
		nextState = 9'd1;
		aluOperation = 4'b1100;
		muxSignals = 2'b00;
		regFileRS = instruction[25:21];
		regFileRT = instruction[20:16];
		regFileRD = instruction[15:11];
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=0;
		ramMFA=0;
		muxSignals3=2'b00;
		regFileRW=1;
	end

	//Logic shift right
	else if(state == 9'd16) begin
		nextState = 9'd1;
		aluOperation = 4'b0111;
		regFileRS = instruction[25:21];
		regFileRD = instruction[15:11];
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=0;
		ramMFA=0;
		muxSignals3=2'b00;
		regFileRW=1;
	end

	//Logic shift left
	else if(state == 9'd17) begin
		nextState = 9'd1;
		aluOperation = 4'b1000;
		regFileRS = instruction[25:21];
		regFileRD = instruction[15:11];
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=0;
		ramMFA=0;
		muxSignals3=2'b00;
		regFileRW=1;
	end

	//Arithmetic shift right
	else if(state == 9'd18) begin
		nextState = 9'd1;
		aluOperation = 4'b1001;
		regFileRS = instruction[25:21];
		regFileRD = instruction[15:11];
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=0;
		ramMFA=0;
		muxSignals3=2'b00;
		regFileRW=1;
	end

	//LUI
	else if(state == 9'd19) begin
		nextState = 9'd1;
		aluOperation = 4'b1010;
		regFileRS = instruction[25:21];
		regFileRD = instruction[25:21];
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=0;
		ramMFA=0;
		muxSignals3=2'b00;
		regFileRW=1;
		signExtend = 0;
	end

	//Add imm16 unsigned
	else if(state == 9'd20) begin
		nextState = 9'd1;
		aluOperation = 4'b0001;
		muxSignals = 2'b01;
		regFileRS = instruction[25:21];
		regFileRD = instruction[20:16];
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=0;
		ramMFA=0;
		aluSign = 2'b10;
		muxSignals3=2'b00;
		regFileRW=1;
		signExtend = 1;
	end

	//Add imm16 signed (generates overflow)
	else if(state == 9'd21) begin
		nextState = 9'd254;
		aluOperation = 4'b0001;
		muxSignals = 2'b01;
		regFileRS = instruction[25:21];
		regFileRD = instruction[20:16];
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=0;
		ramMFA=0;
		aluSign = 2'b10;
		muxSignals3=2'b00;
		regFileRW=0;
		signExtend = 1;
	end

	//ANDI (imm16)
	else if(state == 9'd22) begin
		nextState = 9'd1;
		aluOperation = 4'b0001;
		muxSignals = 2'b01;
		regFileRS = instruction[25:21];
		regFileRD = instruction[20:16];
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=0;
		ramMFA=0;
		aluSign = 2'b10;
		muxSignals3=2'b00;
		regFileRW=1;
		signExtend = 1;
	end

	// else if(state == 9'd1) begin
	// 	nextPC[31:28] = currentPC[31:28];
	// 	nextPC[27:0] = instruction[25:0]*4;
	// end 

	else if(instruction === 32'bx) begin
		$display("Invalid instruction: Undefined");
		nextState = 9'd1;
	end

end

always @(negedge Clk) begin
    state = nextState;
end

endmodule
