module controlUnit (output reg [31:0] nextPC,
					output reg muxSignals5,
					output reg [3:0] cmpsignal,
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
					input Clk,
					input [31:0] currentPC);

reg [9:0] state,nextState;
reg jmp;

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
		//$display("Clear PC in state 0: %b", clearPC);
		$display("Inside state 0");
		nextState=9'd1;
	end

	//Begin FETCH states 1-4
	else if(state == 9'd1) begin
		$display("Inside state 1");
		nextState=9'd2;
		clearPC=0; //Setting pcClear to 0 after reset (not in signals table)
		//$display("Clear PC in state 1: %b", clearPC);
		aluOperation=4'b0000;
		muxSignals=2'b11;
		irEnable=0;
		pcEnable=0;
		//$display("MAR enable in state 1: %b", marEnable);
		marEnable=1;
		mdrEnable=0;
		trapMux=0;
		ramMFA=0;
		regFileRW=0;
		muxSignals5 = 0;
	end

	else if(state == 9'd2) begin
		$display("Inside state 2, aluOperation: %b, will jump? %b, aluCarryFlags=%b",aluOperation,jmp,aluCarryFlags);
		if(jmp) begin
			muxSignals5 = 1;
			jmp = 0;
		end
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
		muxSignals5 = 0;
		pcEnable=0;
		regFileRW=0;
		ramDataSize = 2'b11;
		$display("Inside state 3");
		//$display("ramMFC= %b",ramMFC);
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
		//$display("Function Code = %b", functionCode);
		if(opcode == 6'b000000) begin
			//$display("Opcode = %b", opcode);
			$display("Function Code = %b", functionCode);
			if(functionCode == 6'b100001) begin
				nextState=9'd5; //addu
			end
			else if(functionCode == 6'b100000) begin
				nextState=9'd6; //add
			end
			else if(functionCode == 6'b100011) begin
				nextState=9'd7; //subu
			end
			else if(functionCode == 6'b100010) begin
				nextState=9'd8; //sub
			end
			else if(functionCode == 6'b011011) begin
				nextState=9'd11; //divu
			end
			else if(functionCode == 6'b011010) begin
				nextState=9'd12; //div
			end
			else if(functionCode == 6'b011001) begin
				nextState=9'd10; //multu
			end			
			else if(functionCode == 6'b011000) begin
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
				nextState=9'd31; //nor
			end
			else if(functionCode == 6'b000100) begin
				nextState=9'd17; //sllv
			end
			else if(functionCode == 6'b000111) begin
				nextState=9'd18; //srav
			end
			else if(functionCode == 6'b000110) begin
				nextState=9'd16; //srlv
			end
			else if(functionCode == 6'b101010) begin
				nextState=9'd22; //slt
			end
			else if(functionCode == 6'b101011) begin
				nextState=9'd23; //sltu
			end
			else if(functionCode == 6'b000000) begin
				nextState=9'd32; //sll
			end
			else if(functionCode == 6'b000011) begin
				nextState=9'd33; //sra
			end
			else if(functionCode == 6'b000010) begin
				nextState=9'd34; //srl
			end
			else if(functionCode == 6'b010000) begin
				nextState=9'd64; //mfhi
			end
			else if(functionCode == 6'b010010) begin
				nextState=9'd65; //mflo
			end
			else if(functionCode == 6'b001011) begin
				nextState=9'd66; //movn
			end
			else if(functionCode == 6'b001010) begin
				nextState=9'd68; //movz
			end
			else if(functionCode == 6'b010001) begin
				nextState=9'd70; //mthi
			end
			else if(functionCode == 6'b010011) begin
				nextState=9'd71; //mtlo
			end
			else if(functionCode == 6'b001001) begin
				nextState=9'd86; //jalr
			end
			else if(functionCode == 6'b001000) begin
				nextState=9'd88; //jr
			end
			else if(functionCode == 6'b110100) begin
				nextState=9'd91; //teq
			end
			else if(functionCode == 6'b110000) begin
				nextState=9'd92; //tge
			end
			else if(functionCode == 6'b110001) begin
				nextState=9'd93; //tgeu
			end
			else if(functionCode == 6'b110010) begin
				nextState=9'd94; //tlt
			end
			else if(functionCode == 6'b110011) begin
				nextState=9'd95; //tltu
			end
			else if(functionCode == 6'b110110) begin
				nextState=9'd96; //tne
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
			nextState = 9'd28; //andi
		end
		else if(opcode == 6'b001101) begin
			nextState = 9'd29; //ori
		end
		else if(opcode == 6'b001110) begin
			nextState = 9'd30; //xori
		end
		else if(opcode == 6'b001111) begin
			nextState = 9'd19; //lui
		end
		else if(opcode == 6'b011100) begin
			if(functionCode == 6'b100001) begin
				nextState = 9'd26; //CLO
			end
			else if(functionCode == 6'b100000) begin
				nextState = 9'd27; //clz
			end
			else begin
				$display("Invalid instruction: function code not found"); //function code not found
				nextState = 9'd1;
			end
		end
		else if(opcode == 6'b100011) begin
			nextState = 9'd35; //lw
		end
		else if(opcode == 6'b100001) begin
			nextState = 9'd39; //lh
		end
		else if(opcode == 6'b100101) begin
			nextState = 9'd43; //lhu
		end
		else if(opcode == 6'b100000) begin
			nextState = 9'd47; //lb
		end
		else if(opcode == 6'b100100) begin
			nextState = 9'd51; //lbu
		end
		else if(opcode == 6'b101011) begin
			nextState = 9'd55; //sw
		end
		else if(opcode == 6'b101001) begin
			nextState = 9'd58; //sh
		end
		else if(opcode == 6'b101000) begin
			nextState = 9'd61; //sb
		end
		else if(opcode == 6'b001010) begin
			nextState = 9'd24; //slti
		end
		else if(opcode == 6'b001011) begin
			nextState = 9'd25; //sltiu
		end
		else if(opcode == 6'b000100) begin
			nextState = 9'd74; //beq
		end
		// else if(opcode == 6'b000100) begin
		// 	nextState = 9'd72; //b
		// end
		else if(opcode == 6'b000001) begin
			if(instruction[20:16] == 5'b10001) begin
				nextState = 9'd76; //bgezal
			end
			// else if(instruction[20:16] == 5'b10001) begin
			// 	nextState = 9'd74; //bal
			// end
			else if(instruction[20:16] == 5'b00001) begin
			 	nextState = 9'd75; //bgez
			end
			else if(instruction[20:16] == 5'b00000) begin
			 	nextState = 9'd80; //bltz
			end
			else if(instruction[20:16] == 5'b10000) begin
			 	nextState = 9'd81; //bltzal
			end
			else begin
				$display("Invalid instruction"); //function code not found
				nextState = 9'd1;
			end
		end
		else if(opcode == 6'b000111) begin
			if(instruction[20:16] == 5'b00000) begin
				nextState = 9'd78; //bgtz
			end
			else begin
				$display("Invalid instruction"); //function code not found
				nextState = 9'd1;
			end
		end
		else if(opcode == 6'b000110) begin
			if(instruction[20:16] == 5'b00000) begin
				nextState = 9'd79; //blez
			end
			else begin
				$display("Invalid instruction"); //function code not found
				nextState = 9'd1;
			end
		end
		else if(opcode == 6'b000101) begin
			nextState = 9'd83; //bne
		end
		else if(opcode == 6'b000010) begin
			nextState = 9'd84; //j
		end
		else if(opcode == 6'b000011) begin
			nextState = 9'd85; //jal
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
		regFileRS = instruction[25:21];
		regFileRT = instruction[20:16];
		regFileRD = instruction[15:11];
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=0;
		ramMFA=0;
		aluSign=2'b10;
		muxSignals3=2'b00;
		regFileRW=0;
	end

	//Check for overflow
	else if(state == 9'd254) begin
		$display("Overflow=%b",aluCarryFlags[0]);
		if(aluCarryFlags[0]) begin
			$display("Overflow Ocurred");
			nextState=9'd3;
			irEnable=0;
			pcEnable=0;
			marEnable=0;
			mdrEnable=0;
			ramRW=0;
			ramMFA=1;
			trapMux=1;
			ramAddress = 9'd448; //Address for overflow trap
		end
		else begin
			nextState = 9'd1;
			irEnable=0;
			pcEnable=0;
			marEnable=0;
			mdrEnable=0;
			ramMFA=0;
			regFileRW=1;
			trapMux=0;
		end
	end

	//Subtract unsigned
	else if(state == 9'd7) begin
		$display("SUBU: Inside state 7");
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
		aluSign=2'b01;
		muxSignals3=2'b00;
		regFileRW=1;
	end

	//Subtract signed (generates overflow)
	else if(state == 9'd8) begin
		$display("SUB: Inside state 8");
		nextState = 9'd254;
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
		aluSign=2'b11;
		muxSignals3=2'b00;
		regFileRW=0;
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

	//SRLV
	else if(state == 9'd16) begin
		nextState = 9'd1;
		aluOperation = 4'b0111;
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

	//SLLV
	else if(state == 9'd17) begin
		nextState = 9'd1;
		aluOperation = 4'b1000;
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

	//SRAV
	else if(state == 9'd18) begin
		nextState = 9'd1;
		aluOperation = 4'b1001;
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

	//LUI
	else if(state == 9'd19) begin
		nextState = 9'd1;
		aluOperation = 4'b1010;
		muxSignals = 2'b01;
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

	//ADDIU
	else if(state == 9'd20) begin
		$display("ADDIU: Inside state 20");
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

	//ADDI
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

	//slt
	else if(state == 9'd22) begin
		$display("SLT: Inside state 22");
		nextState = 9'd1;
		aluOperation = 4'b1101;
		muxSignals = 2'b00;
		regFileRS = instruction[25:21];
		regFileRT = instruction[20:16];
		regFileRD = instruction[15:11];
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=0;
		ramMFA=0;
		muxSignals3 = 2'b00;
		regFileRW=1;
		cmpsignal = 4'b0000;
	end

	//sltu
	else if(state == 9'd23) begin
		$display("SLTU: Inside state 23");
		nextState = 9'd1;
		aluOperation = 4'b1101;
		muxSignals = 2'b00;
		regFileRS = instruction[25:21];
		regFileRT = instruction[20:16];
		regFileRD = instruction[15:11];
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=0;
		ramMFA=0;
		muxSignals3 = 2'b00;
		regFileRW=1;
		cmpsignal = 4'b0001;
	end

	//slti
	else if(state == 9'd24) begin
		$display("SLTI: Inside state 24");
		nextState = 9'd1;
		aluOperation = 4'b1101;
		muxSignals = 2'b01;
		regFileRS = instruction[25:21];
		regFileRD = instruction[20:16];
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=0;
		ramMFA=0;
		muxSignals3 = 2'b00;
		regFileRW=1;
		signExtend = 1; 
		cmpsignal = 4'b0010;
	end

	//sltiu
	else if(state == 9'd25) begin
		$display("SLTIU: Inside state 25");
		nextState = 9'd1;
		aluOperation = 4'b1101;
		muxSignals = 2'b01;
		regFileRS = instruction[25:21];
		regFileRD = instruction[20:16];
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=0;
		ramMFA=0;
		muxSignals3 = 2'b00;
		regFileRW=1;
		signExtend = 1; 
		cmpsignal = 4'b0011;
	end

	//CLO
	else if(state == 9'd26) begin
		nextState = 9'd1;
		aluOperation = 4'b1101;
		muxSignals = 2'b00;
		regFileRS = instruction[25:21];
		regFileRD = instruction[15:11];
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=0;
		ramMFA=0;
		muxSignals3=2'b00;
		regFileRW=1;
		cmpsignal = 4'b0100;
	end

	//CLZ
	else if(state == 9'd27) begin
		nextState = 9'd1;
		aluOperation = 4'b1101;
		muxSignals = 2'b00;
		regFileRS = instruction[25:21];
		regFileRD = instruction[15:11];
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=0;
		ramMFA=0;
		muxSignals3=2'b00;
		regFileRW=1;
		cmpsignal = 4'b0101;
	end

	//ANDI (imm16)
	else if(state == 9'd28) begin
		nextState = 9'd1;
		aluOperation = 4'b0100;
		muxSignals = 2'b01;
		regFileRS = instruction[25:21];
		regFileRD = instruction[20:16];
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=0;
		ramMFA=0;
		muxSignals3=2'b00;
		regFileRW=1;
		signExtend=0;
	end

	//ORI (imm16)
	else if(state == 9'd29) begin
		nextState = 9'd1;
		aluOperation = 4'b0101;
		muxSignals = 2'b01;
		regFileRS = instruction[25:21];
		regFileRD = instruction[20:16];
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=0;
		ramMFA=0;
		muxSignals3=2'b00;
		regFileRW=1;
		signExtend=0;
	end

	//XORI (imm16)
	else if(state == 9'd30) begin
		nextState = 9'd1;
		aluOperation = 4'b1100;
		muxSignals = 2'b01;
		regFileRS = instruction[25:21];
		regFileRD = instruction[20:16];
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=0;
		ramMFA=0;
		muxSignals3=2'b00;
		regFileRW=1;
		signExtend=0;
	end

	//NOR (imm16)
	else if(state == 9'd31) begin
		nextState = 9'd1;
		aluOperation = 4'b0110;
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

	//SLL
	else if(state == 9'd32) begin
		$display("SLL: Inside state 32");
		nextState = 9'd1;
		aluOperation = 4'b1000;
		muxSignals = 2'b00;
		regFileRS = 5'b0;
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

	//LW (load word) (1)
	else if(state == 9'd35) begin
		nextState = 9'd36;
		aluOperation = 4'b0001;
		muxSignals = 2'b01;
		regFileRS = instruction[25:21];
		regFileRD = instruction[20:16];
		irEnable=0;
		pcEnable=0;
		marEnable=1;
		mdrEnable=0;
		ramMFA=0;
		aluSign = 2'b00;
		regFileRW=0;
		signExtend = 1;
	end

	//LW (load word) (2)
	else if(state == 9'd36) begin
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable = 0;
		ramRW = 0;
		ramMFA=1;
		regFileRW=0;
		ramDataSize = 2'b11;
		if(ramMFC) begin
			nextState = 9'd37;
		end
		else begin
			nextState = 9'd36;
			trapMux = 0;
		end
	end

	//LW (load word) (3)
	else if(state == 9'd37) begin
		nextState = 9'd38;
		muxSignals2 = 1;
		regFileRS = instruction[25:21];
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=1;
		ramMFA=0;
		regFileRW=0;
	end

	//LW (load word) (4)
	else if(state == 9'd38) begin
		nextState = 9'd1;
		aluOperation = 4'b0000;
		muxSignals = 2'b10;
		muxSignals2 = 1;
		regFileRD = instruction[20:16];
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=0;
		ramMFA=0;
		muxSignals3 = 2'b00;
		regFileRW=1;
	end

	//LH (load half-word) (1)
	else if(state == 9'd39) begin
		nextState = 9'd40;
		aluOperation = 4'b0001;
		muxSignals = 2'b01;
		regFileRS = instruction[25:21];
		regFileRD = instruction[20:16];
		irEnable=0;
		pcEnable=0;
		marEnable=1;
		mdrEnable=0;
		ramMFA=0;
		aluSign = 2'b00;
		regFileRW=0;
		signExtend = 1;
	end

	//LH (load half-word) (2)
	else if(state == 9'd40) begin
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable = 0;
		ramRW = 0;
		ramMFA=1;
		regFileRW=0;
		ramDataSize = 2'b01;
		if(ramMFC) begin
			nextState = 9'd41;
		end
		else begin
			nextState = 9'd40;
			trapMux = 0;
		end
	end

	//LH (load half-word) (3)
	else if(state == 9'd41) begin
		nextState = 9'd42;
		muxSignals2 = 1;
		regFileRS = instruction[25:21];
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=1;
		ramMFA=0;
		regFileRW=0;
	end

	//LH (load half-word) (4)
	else if(state == 9'd42) begin
		nextState = 9'd1;
		aluOperation = 4'b0000;
		muxSignals = 2'b10;
		muxSignals2 = 1;
		regFileRD = instruction[20:16];
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=0;
		ramMFA=0;
		muxSignals3 = 2'b00;
		regFileRW=1;
	end

	//LHU (load half-word unsigned) (1)
	else if(state == 9'd43) begin
		nextState = 9'd44;
		aluOperation = 4'b0001;
		muxSignals = 2'b01;
		regFileRS = instruction[25:21];
		regFileRD = instruction[20:16];
		irEnable=0;
		pcEnable=0;
		marEnable=1;
		mdrEnable=0;
		ramMFA=0;
		aluSign = 2'b00;
		regFileRW=0;
		signExtend = 0;
	end

	//LHU (load half-word unsigned) (2)
	else if(state == 9'd44) begin
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable = 0;
		ramRW = 0;
		ramMFA=1;
		regFileRW=0;
		ramDataSize = 2'b01;
		if(ramMFC) begin
			nextState = 9'd45;
		end
		else begin
			nextState = 9'd44;
			trapMux = 0;
		end
	end

	//LHU (load half-word unsigned) (3)
	else if(state == 9'd45) begin
		nextState = 9'd46;
		muxSignals2 = 1;
		regFileRS = instruction[25:21];
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=1;
		ramMFA=0;
		regFileRW=0;
	end

	//LHU (load half-word unsigned) (4)
	else if(state == 9'd46) begin
		nextState = 9'd1;
		aluOperation = 4'b0000;
		muxSignals = 2'b10;
		muxSignals2 = 1;
		regFileRD = instruction[20:16];
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=0;
		ramMFA=0;
		muxSignals3 = 2'b00;
		regFileRW=1;
	end

	//LB (load byte) (1)
	else if(state == 9'd47) begin
		nextState = 9'd48;
		aluOperation = 4'b0001;
		muxSignals = 2'b01;
		regFileRS = instruction[25:21];
		regFileRD = instruction[20:16];
		irEnable=0;
		pcEnable=0;
		marEnable=1;
		mdrEnable=0;
		ramMFA=0;
		aluSign = 2'b00;
		regFileRW=0;
		signExtend = 1;
	end

	//LB (load byte) (2)
	else if(state == 9'd48) begin
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable = 0;
		ramRW = 0;
		ramMFA=1;
		regFileRW=0;
		ramDataSize = 2'b00;
		if(ramMFC) begin
			nextState = 9'd49;
		end
		else begin
			nextState = 9'd48;
			trapMux = 0;
		end
	end

	//LB (load byte) (3)
	else if(state == 9'd49) begin
		nextState = 9'd50;
		muxSignals2 = 1;
		regFileRS = instruction[25:21];
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=1;
		ramMFA=0;
		regFileRW=0;
	end

	//LB (load byte) (4)
	else if(state == 9'd50) begin
		nextState = 9'd1;
		aluOperation = 4'b0000;
		muxSignals = 2'b10;
		muxSignals2 = 1;
		regFileRD = instruction[20:16];
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=0;
		ramMFA=0;
		muxSignals3 = 2'b00;
		regFileRW=1;
	end

	//LBU (load byte unsigned) (1)
	else if(state == 9'd51) begin
		$display("LBU: Inside state 51");
		nextState = 9'd52;
		aluOperation = 4'b0001;
		muxSignals = 2'b01;
		regFileRS = instruction[25:21];
		regFileRD = instruction[20:16];
		irEnable=0;
		pcEnable=0;
		marEnable=1;
		mdrEnable=0;
		ramMFA=0;
		aluSign = 2'b00;
		regFileRW=0;
		signExtend = 0;
	end

	//LBU (load byte unsigned) (2)
	else if(state == 9'd52) begin
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable = 0;
		ramRW = 0;
		ramMFA=1;
		regFileRW=0;
		ramDataSize = 2'b00;
		if(ramMFC) begin
			nextState = 9'd53;
		end
		else begin
			nextState = 9'd52;
			trapMux = 0;
		end
	end

	//LBU (load byte unsigned) (3)
	else if(state == 9'd53) begin
		nextState = 9'd54;
		muxSignals2 = 1;
		regFileRS = instruction[25:21];
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=1;
		ramMFA=0;
		regFileRW=0;
	end

	//LBU (load byte unsigned) (4)
	else if(state == 9'd54) begin
		nextState = 9'd1;
		aluOperation = 4'b0000;
		muxSignals = 2'b10;
		muxSignals2 = 1;
		regFileRD = instruction[20:16];
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=0;
		ramMFA=0;
		muxSignals3 = 2'b00;
		regFileRW=1;
	end

	//SW (1)
	else if(state == 9'd55) begin
		nextState = 9'd56;
		aluOperation = 4'b0001;
		muxSignals = 2'b01;
		regFileRS = instruction[25:21];
		irEnable = 0;
		pcEnable=0;
		marEnable=1;
		mdrEnable=0;
		ramMFA=0;
		aluSign = 2'b00;
		signExtend = 1;
		regFileRW = 0;
	end

	//SW (2)
	else if(state == 9'd56) begin
		nextState = 9'd57;
		aluOperation = 4'b0000;
		muxSignals = 2'b00;
		muxSignals2 = 0;
		regFileRT = instruction[20:16];
		irEnable = 0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=1;
		ramMFA=0;
		aluSign = 2'b00;
		signExtend = 1;
	end

	//SW (3)
	else if(state == 9'd57) begin
		mdrEnable=0;
		ramMFA=1;
		ramRW = 1;
		trapMux = 0;
		ramDataSize = 2'b11;
		if(ramMFC) begin
			nextState = 9'd1;
		end
		else begin
			nextState = 9'd57;
		end
	end

	//SH (1)
	else if(state == 9'd58) begin
		nextState = 9'd59;
		aluOperation = 4'b0001;
		muxSignals = 2'b01;
		regFileRS = instruction[25:21];
		irEnable = 0;
		pcEnable=0;
		marEnable=1;
		mdrEnable=0;
		ramMFA=0;
		aluSign = 2'b00;
		signExtend = 1;
		regFileRW = 0;
	end

	//SH (2)
	else if(state == 9'd59) begin
		nextState = 9'd60;
		aluOperation = 4'b0000;
		muxSignals = 2'b00;
		muxSignals2 = 0;
		regFileRT = instruction[20:16];
		irEnable = 0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=1;
		ramMFA=0;
		aluSign = 2'b00;
		signExtend = 1;
	end

	//SH (3)
	else if(state == 9'd60) begin
		mdrEnable=0;
		ramMFA=1;
		ramRW = 1;
		trapMux = 0;
		ramDataSize = 2'b01;
		if(ramMFC) begin
			nextState = 9'd1;
		end
		else begin
			nextState = 9'd60;
		end
	end

	//SB (1)
	else if(state == 9'd61) begin
		nextState = 9'd62;
		aluOperation = 4'b0001;
		muxSignals = 2'b01;
		regFileRS = instruction[25:21];
		irEnable = 0;
		pcEnable=0;
		marEnable=1;
		mdrEnable=0;
		ramMFA=0;
		aluSign = 2'b00;
		signExtend = 1;
		regFileRW = 0;
	end

	//SB (2)
	else if(state == 9'd62) begin
		nextState = 9'd63;
		aluOperation = 4'b0000;
		muxSignals = 2'b00;
		muxSignals2 = 0;
		regFileRT = instruction[20:16];
		irEnable = 0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=1;
		ramMFA=0;
		aluSign = 2'b00;
		signExtend = 1;
	end

	//SB (3)
	else if(state == 9'd63) begin
		mdrEnable=0;
		ramMFA=1;
		ramRW = 1;
		trapMux = 0;
		ramDataSize = 2'b00;
		if(ramMFC) begin
			nextState = 9'd1;
		end
		else begin
			nextState = 9'd63;
		end
	end
	
	//MFHI
	else if(state == 9'd64) begin
		nextState = 9'd1;
		regFileRD = instruction[15:11];
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=0;
		ramMFA=0;
		muxSignals3 = 2'b10;
		regFileRW=1;
	end

	//MFLO
	else if(state == 9'd65) begin
		nextState = 9'd1;
		regFileRD = instruction[15:11];
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=0;
		ramMFA=0;
		muxSignals3 = 2'b01;
		regFileRW=1;
	end

	//MOVN
	else if(state == 9'd66) begin
		nextState = 9'd67;
		aluOperation = 4'b1101;
		muxSignals = 2'b00;
		regFileRS = instruction[25:21];
		regFileRT = instruction[20:16];
		regFileRD = instruction[15:11];
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=0;
		ramMFA=0;
		regFileRW=0;
		cmpsignal = 4'b1101;
	end

	//MOVN (2)
	else if(state == 9'd67) begin
		nextState = 9'd1;
		if(aluCarryFlags[0]) begin
			regFileRW=1;
		end
	end

	//MOVZ
	else if(state == 9'd68) begin
		nextState = 9'd69;
		aluOperation = 4'b1101;
		muxSignals = 2'b00;
		regFileRS = instruction[25:21];
		regFileRT = instruction[20:16];
		regFileRD = instruction[15:11];
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=0;
		ramMFA=0;
		regFileRW=0;
		cmpsignal = 4'b0110;
	end

	//MOVZ (2)
	else if(state == 9'd69) begin
		nextState = 9'd1;
		if(aluCarryFlags[0]) begin
			regFileRW=1;
		end
	end

	//MTHI
	else if(state == 9'd70) begin
		nextState = 9'd1;
		aluOperation = 4'b1110;
		regFileRS = instruction[25:21];
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=0;
		ramMFA=0;
		regFileRW=0;
	end

	//MTLO
	else if(state == 9'd71) begin
		nextState = 9'd1;
		aluOperation = 4'b1111;
		regFileRS = instruction[25:21];
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=0;
		ramMFA=0;
		regFileRW=0;
	end

	//BEQ
	else if(state == 9'd74) begin
		$display("BEQ / B: Inside state 74");
		nextState = 9'd1;
		muxSignals = 2'b00;
		aluOperation = 4'b1101;
		cmpsignal = 4'b1000;
		regFileRS = instruction[25:21];
		regFileRT = instruction[20:16];
		if(aluCarryFlags[0]) begin
			jmp = 1;
			nextPC = currentPC + $signed(4 * instruction[15:0]);
			nextPC[31:9] = 23'b0;
			$display("nextPC=%d",nextPC);
		end
	end 

	//BGEZ
	else if(state == 9'd75) begin
		nextState = 9'd1;
		aluOperation = 4'b1101;
		regFileRS = instruction[25:21];
		cmpsignal = 4'b0111;
		if(aluCarryFlags[0]) begin
			jmp = 1;
			nextPC = currentPC + (4 * instruction[15:0]);
		end
	end

	//BGEZAL (1)
	else if(state == 9'd76) begin
		aluOperation = 4'b1101;
		regFileRS = instruction[25:21];
		cmpsignal = 4'b0111;
		if(aluCarryFlags[0]) begin
			nextState = 9'd77;
			jmp = 1;
			nextPC = currentPC + (4 * instruction[15:0]);
		end
		else begin
			nextState = 9'd1;
		end
	end 

	//BGEZAL (2)
	else if(state == 9'd77) begin
		nextState = 9'd1;
		aluOperation = 4'b1011;
		muxSignals = 2'b11;
		regFileRD = 5'd31;
		muxSignals3 = 2'b00;
		regFileRW = 1;
	end

	//BGTZ
	else if(state == 9'd78) begin
		$display("BGTZ: Inside state 78");
		nextState = 9'd1;
		aluOperation = 4'b1101;
		regFileRS = instruction[25:21];
		cmpsignal = 4'b1010;
		if(aluCarryFlags[0]) begin
			jmp = 1;
			nextPC = currentPC + $signed(4 * instruction[15:0]);
			nextPC[31:9] = 23'b0;
			$display("nextPC=%d",nextPC);
		end
	end

	//BLEZ
	else if(state == 9'd79) begin
		nextState = 9'd1;
		aluOperation = 4'b1101;
		regFileRS = instruction[25:21];
		cmpsignal = 4'b1011;
		if(aluCarryFlags[0]) begin
			jmp = 1;
			nextPC = currentPC + (4 * instruction[15:0]);
		end
	end

	//BLTZ
	else if(state == 9'd80) begin
		nextState = 9'd1;
		aluOperation = 4'b1101;
		regFileRS = instruction[25:21];
		cmpsignal = 4'b1001;
		if(aluCarryFlags[0]) begin
			jmp = 1;
			nextPC = currentPC + (4 * instruction[15:0]);
		end
	end

	//BLTZAL (1)
	else if(state == 9'd81) begin
		nextState = 9'd82;
		aluOperation = 4'b1101;
		regFileRS = instruction[25:21];
		cmpsignal = 4'b1001;
		if(aluCarryFlags[0]) begin
			jmp = 1;
			nextPC = currentPC + (4 * instruction[15:0]);
		end
	end

	//BLTZAL (2)
	else if(state == 9'd82) begin
		nextState = 9'd1;
		aluOperation = 4'b1011;
		muxSignals = 2'b11;
		regFileRD = 5'd31;
		muxSignals3 = 2'b00;
		regFileRW = 1;
	end

	//BNE
	else if(state == 9'd83) begin
		nextState = 9'd1;
		aluOperation = 4'b1101;
		regFileRS = instruction[25:21];
		regFileRS = instruction[25:21];
		cmpsignal = 4'b1100;
		if(aluCarryFlags[0]) begin
			jmp = 1;
			nextPC = currentPC + (4 * instruction[15:0]);
		end
	end

	//J
	else if(state == 9'd84) begin
		nextState = 9'd1;
		jmp = 1;
		nextPC[31:28] = currentPC[31:28];
		nextPC[27:0] = instruction[25:0]*4;
	end

	//JAL
	else if(state == 9'd85) begin
		nextState = 9'd1;
		aluOperation = 4'b1011;
		muxSignals = 2'b11;
		regFileRD = 5'd31;
		nextPC[31:28] = currentPC[31:28];
		nextPC[27:0] = instruction[25:0]*4;
		muxSignals3 = 2'b00;
		regFileRW = 1;
		jmp = 1;
	end

	//JALR (1)
	else if(state == 9'd86) begin
		nextState = 9'd87;
		aluOperation = 4'b1011;
		muxSignals = 2'b11;
		regFileRD = instruction[15:11];
		muxSignals3 = 2'b00;
		regFileRW = 1;
		jmp = 0;
	end

	//JALR (2)
	else if(state == 9'd87) begin
		nextState = 9'd88;
		aluOperation = 4'b0000;
		muxSignals = 2'b11;
		marEnable = 1;
		regFileRW = 0;
	end

	//JALR (3)
	else if(state == 9'd88) begin
		nextState = 9'd3;
		aluOperation = 4'b0000;
		regFileRT = instruction[25:21];
		muxSignals = 2'b00;
		marEnable = 0;
		pcEnable = 1;
		ramMFA=1;
		ramRW = 0;
		trapMux=0;
		ramDataSize = 2'b11;
		muxSignals5 = 0;
	end

	//JR (1)
	else if(state == 9'd89) begin
		nextState = 9'd90;
		aluOperation = 4'b0000;
		muxSignals = 2'b11;
		marEnable = 1;
		regFileRW = 0;
	end

	//JR (2)
	else if(state == 9'd90) begin
		nextState = 9'd3;
		aluOperation = 4'b0000;
		regFileRT = instruction[25:21];
		muxSignals = 2'b00;
		marEnable = 0;
		pcEnable = 1;
		ramMFA=1;
		ramRW = 0;
		trapMux=0;
		ramDataSize = 2'b11;
		muxSignals5 = 0;
	end

	//TEQ
	else if(state == 9'd91) begin
		nextState = 9'd253;
		aluOperation = 4'b1101;
		muxSignals = 2'b00;
		cmpsignal = 4'b1000;
		regFileRS = instruction[25:21];
		regFileRT = instruction[20:16];
		irEnable = 0;
		pcEnable = 0;
		marEnable = 0;
		mdrEnable = 0;
		ramMFA = 0;
		regFileRW = 0;
	end

	//TGE
	else if(state == 9'd92) begin
		nextState = 9'd253;
		aluOperation = 4'b1101;
		muxSignals = 2'b00;
		cmpsignal = 4'b1110;
		regFileRS = instruction[25:21];
		regFileRT = instruction[20:16];
		irEnable = 0;
		pcEnable = 0;
		marEnable = 0;
		mdrEnable = 0;
		ramMFA = 0;
		regFileRW = 0;
	end

	//TGEU
	else if(state == 9'd93) begin
		nextState = 9'd252;
		aluOperation = 4'b1101;
		muxSignals = 2'b00;
		cmpsignal = 4'b1110;
		regFileRS = instruction[25:21];
		regFileRT = instruction[20:16];
		irEnable = 0;
		pcEnable = 0;
		marEnable = 0;
		mdrEnable = 0;
		ramMFA = 0;
		regFileRW = 0;
	end

	//TLT
	else if(state == 9'd94) begin
		nextState = 9'd253;
		aluOperation = 4'b1101;
		muxSignals = 2'b00;
		cmpsignal = 4'b1111;
		regFileRS = instruction[25:21];
		regFileRT = instruction[20:16];
		irEnable = 0;
		pcEnable = 0;
		marEnable = 0;
		mdrEnable = 0;
		ramMFA = 0;
		regFileRW = 0;
	end

	//TLTU
	else if(state == 9'd95) begin
		nextState = 9'd252;
		aluOperation = 4'b1101;
		muxSignals = 2'b00;
		cmpsignal = 4'b1111;
		regFileRS = instruction[25:21];
		regFileRT = instruction[20:16];
		irEnable = 0;
		pcEnable = 0;
		marEnable = 0;
		mdrEnable = 0;
		ramMFA = 0;
		regFileRW = 0;
	end

	//TNE
	else if(state == 9'd96) begin
		nextState = 9'd253;
		aluOperation = 4'b1101;
		muxSignals = 2'b00;
		cmpsignal = 4'b1100;
		regFileRS = instruction[25:21];
		regFileRT = instruction[20:16];
		irEnable = 0;
		pcEnable = 0;
		marEnable = 0;
		mdrEnable = 0;
		ramMFA = 0;
		regFileRW = 0;
	end

	//Conditional Traps Unsigned
	else if(state == 9'd252) begin
		if(aluCarryFlags[3]) begin
			$display("Conditional Trap Ocurred");
			nextState=9'd3;
			irEnable=0;
			pcEnable=0;
			marEnable=0;
			mdrEnable=0;
			ramRW=0;
			ramMFA=1;
			trapMux=1;
			ramAddress = 9'd432; //Ram address for conditional trap
		end
		else begin
			nextState = 9'd1;
		end
	end

	//Conditional Traps Signed
	else if(state == 9'd253) begin
		if(aluCarryFlags[2]) begin
			$display("Conditional Trap Ocurred");
			nextState=9'd3;
			irEnable=0;
			pcEnable=0;
			marEnable=0;
			mdrEnable=0;
			ramRW=0;
			ramMFA=1;
			trapMux=1;
			ramAddress = 9'd432; //Ram address for conditional trap
		end
		else begin
			nextState = 9'd1;
		end
	end

	else if(instruction === 32'bx) begin
		$display("Invalid instruction: Undefined");
		nextState = 9'd1;
	end

	/*Begin: Sample Instruction State Template
	
	//Instruction Name
	else if(state == 9'd999) begin
		$display("INST: Inside state 9999");
		nextState = 9'd1;
		aluOperation = 4'b0000;
		muxSignals = 2'b00;
		muxSignals2 = 0;
		regFileRS = instruction[25:21];
		regFileRT = instruction[20:16];
		regFileRD = instruction[15:11];
		irEnable=0;
		pcEnable=0;
		marEnable=0;
		mdrEnable=0;
		ramRW = 0;
		ramMFA=0;
		aluSign = 2'b00;
		muxSignals3 = 2'b00;
		regFileRW=0;
		signExtend = 0;
		trapMux = 0;
		ramAddress 9'b000000000;
		cmpsignal = 4'b0000;
		ramDataSize = 2'b00;
		jmp = 0; //Internal jump signal
		muxSignals5 = 0; //Used for jumps
	end

	End: Sample Instruction State Template */

end

always @(negedge Clk) begin
    state = nextState;
end

endmodule
