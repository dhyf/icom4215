module data_path(input hardwareInterrupt, maskableInterrupt, reset);

reg Clk;

//Clock signal
initial #1 begin
	Clk = 1'b0;
	forever begin
		#1 Clk = ~Clk;
	end
end


initial begin
	// $monitor("Current input to trapMux(0) from MAR: %b", wire29);
	// $monitor("Current input to trapMux(1) from CU: %b", wire33);
	// $monitor("Current input to trapMux selector from CU: %b", wire32);
	// $monitor("Current output of ALU: %b",wire2);
	//$monitor("ALU Input A: %d, ALU Input B: %d, ALU Operation: %b", wire4,wire5,wire8);
	//$monitor("Mux3 Selector from CU: %b, ALU(Y) to Mux3(00) Input: %d", wire18,wire2);
	//$monitor("Mux1 output to ALU input B: %d with selector=%b",wire5,wire14);
	$monitor("PC Status OUT=%d IN=%d EN=%b", wire13, wire41, wire15,"\nCurrent value of RD (data in to regFile): %d ; regFileRW=%b; RD=%b",wire17, wire22, wire19);
	//$monitor("NextPC Value: %d", wire41);
	//$monitor("Current value of RD (data in to regFile): %d ; regFileRW=%b; RD=%b",wire17, wire22, wire19);
end


initial #50 $finish;

wire [31:0] wire1; //Alu LO to Mux 3
wire [31:0] wire2; //Alu Y to Mux 3, nextPC(0), Mux2, MAR
wire [31:0] wire3; //Alu HI to Mux3
wire [31:0] wire4; //Register file (RS) to Alu input A
wire [31:0] wire5; //Mux 1 output to Alu input B
wire [31:0] wire6; //Register file (RT) to mux1(0)
wire [1:0] wire7; //CU to alu sign
wire [3:0] wire8; //CU to alu operation
wire [3:0] wire9; //Alu to CU carryFlags
wire [31:0] wire10; //Sign extender to mux1(1)
wire [31:0] wire11; //Ram data out to mux2(1), ir
wire [31:0] wire12; //MDR output to mux1(2), RAM data in
wire [31:0] wire13; //PC out to mux1(3)
wire [1:0] wire14; //CU to mux1 selector
wire wire15; //CU to PC enable
wire wire16; //CU to PC clear
wire [31:0] wire17; //Mux3 to register file (dataRD)
wire [1:0] wire18; //CU to mux3 selector
wire [4:0] wire19; //CU to register file (RD)
wire [4:0] wire20; //CU to register file (RS)
wire [4:0] wire21; //CU to register file (RT)
wire wire22; //CU to register file (RW)
wire wire23; //CU to sign extender (mux4) selector
wire [31:0] wire24; //IR to sign extender, CU
wire wire25; //CU to IR enable
wire [31:0] wire26; //Mux2 out to MDR
wire wire27; //CU to MDR enable
wire wire28; //CU to mux2 selector
wire [31:0] wire29; //MAR to trapMux(0)
wire wire30; //CU to MAR enable
wire [8:0] wire31; //TrapMux output to RAM address in
wire wire32; //CU to TrapMux selector
wire [8:0] wire33; //CU ramAddress to trapMux(1)
wire wire34; //RAM MFC to CU
wire wire35; //CU to RAM MFA
wire wire36; //CU to RAM RW
wire [1:0] wire37; //CU dataSize to RAM dataSize
wire [2:0] wire38; //cmpsignal from CU to Alu
wire wire39; //CU muxSignals5 to nextPC selector
wire [31:0] wire40; //CU to nextPC(1)
wire [31:0] wire41; //nextPC(Y) to PC

//Instantiating RAM
ram512x8 ram (wire11,wire34,wire35,wire36,wire31,wire12,wire37,Clk);
//ram512x8 ram (dataOut,memFuncComplete,memFuncActive,readWrite,address,dataIn,dataSize,Clk);

register_file regFile (wire4,wire6,wire19,wire20,wire21,wire17,wire22,Clk);
//register_file regFile (dataRS,dataRT,RD,RS,RT,dataRD,RW,Clk);

controlUnit cu (wire40,wire39,wire38,wire32,wire23,wire16,wire22,wire19,wire20,wire21,
		wire7,wire8,wire37,wire35,wire36,
		wire33,wire15,wire25,wire30,
		wire27,wire14,wire28,wire18,wire24,wire9,wire34,reset,
		hardwareInterrupt,maskableInterrupt,Clk);
// controlUnit cu (trapMux,signExtend,clearPC,regFileRW,regFileRD,regFileRS,regFileRT,
// 	aluSign,aluOperation,ramDataSize,ramMFA,ramRW,
// 	ramAddress,regFileEnable,pcEnable,irEnable,marEnable,
// 	mdrEnable,muxSignals,muxSignals2,muxSignals3,instruction,aluCarryFlags,ramMFC,reset,
// 	hardwareInterrupt,maskableInterrupt,Clk);

alu alu10 (wire2,wire3,wire1,wire9,wire8,wire7,wire4,wire5,wire38);

sign_extender signExtender(wire10,wire24[15:0],wire23);

mux_4x1 mux1 (wire5, wire14, wire6, wire10, wire12, wire13); //Inputs: PC, MDR, IMM16, REGFILE Output: ALU(B)
//mux_4x1 mux2 (Y, S, I0, I1, I2, I3);

mux_2x1 mux2 (wire26, wire28, wire2, wire11); //Inputs: RAM Output, ALU Output Output: MDR
//mux_2x1 mux1 (Y, S, I0, I1);

mux_2x1 nextPC (wire41, wire39, wire2, wire40); //Inputs: RAM Output, ALU Output Output: MDR
//mux_2x1 mux1 (Y, S, I0, I1);

mux_4x1 mux3 (wire17, wire18, wire2, wire1, wire3, 32'd0); //Inputs: ALU(Y), ALU(LO) Output: REGFILE(dataRD)
//mux_4x1 mux2 (Y, S, I0, I1, I2, I3);

mux_2x1_9bit trapMuxModule (wire31, wire32, wire29[8:0], wire33); //Inputs MAR, CU(ramAddress) Output: RAM Address
//mux_2x1 mux1 (Y, S, I0, I1);

Register32 pcRegister (wire13,wire41,wire15,wire16,Clk);
//Register32 reg32 (Q,D,LE,Clr,Clk);

Register32 marRegister (wire29,wire2,wire30,0,Clk);
//Register32 reg32 (Q,D,LE,Clr,Clk);

Register32 irRegister (wire24,wire11,wire25,0,Clk);
//Register32 reg32 (Q,D,LE,Clr,Clk);
	
Register32 mdrRegister (wire12,wire26,wire27,0,Clk);
//Register32 reg32 (Q,D,LE,Clr,Clk);

endmodule