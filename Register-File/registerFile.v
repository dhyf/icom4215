module register_file (
	output wire [31:0] dataRS, //Output: Register Source (data, 32bit)
	output wire [31:0] dataRT, //Output: Register Target (data, 32bit)
	input [4:0] RD, //Register RD selection, 5 bits, 32 options, register to write to
	input [4:0] RS, //Register RS selection, 5 bits, 32 options, register to read
	input [4:0] RT, //Register RT selection, 5 bits, 32 options, register to read
	input [31:0] dataRD, // Input: Register Destination (data, 32bit)
	input RW, //Read / write signal, 1=Write, 0=Read
	input Clk);

	wire [31:0] LE_RD;

	wire [31:0] Q0;
	wire [31:0] Q1;
	wire [31:0] Q2;
	wire [31:0] Q3;
	wire [31:0] Q4;
	wire [31:0] Q5;
	wire [31:0] Q6;
	wire [31:0] Q7;
	wire [31:0] Q8;
	wire [31:0] Q9;
	wire [31:0] Q10;
	wire [31:0] Q11;
	wire [31:0] Q12;
	wire [31:0] Q13;
	wire [31:0] Q14;
	wire [31:0] Q15;
	wire [31:0] Q16;
	wire [31:0] Q17;
	wire [31:0] Q18;
	wire [31:0] Q19;
	wire [31:0] Q20;
	wire [31:0] Q21;
	wire [31:0] Q22;
	wire [31:0] Q23;
	wire [31:0] Q24;
	wire [31:0] Q25;
	wire [31:0] Q26;
	wire [31:0] Q27;
	wire [31:0] Q28;
	wire [31:0] Q29;
	wire [31:0] Q30;
	wire [31:0] Q31;

	decoder_5_32 decoderRD (LE_RD,RD);

	//32-bit register bank
	//Register 0 with Clr = 0, data is always 0
	Register32 register0 (Q0,dataRD,LE_RD[0] && RW,1,Clk);
	Register32 register1 (Q1,dataRD,LE_RD[1] && RW,0,Clk);
	Register32 register2 (Q2,dataRD,LE_RD[2] && RW,0,Clk);
	Register32 register3 (Q3,dataRD,LE_RD[3] && RW,0,Clk);
	Register32 register4 (Q4,dataRD,LE_RD[4] && RW,0,Clk);
	Register32 register5 (Q5,dataRD,LE_RD[5] && RW,0,Clk);
	Register32 register6 (Q6,dataRD,LE_RD[6] && RW,0,Clk);
	Register32 register7 (Q7,dataRD,LE_RD[7] && RW,0,Clk);
	Register32 register8 (Q8,dataRD,LE_RD[8] && RW,0,Clk);
	Register32 register9 (Q9,dataRD,LE_RD[9] && RW,0,Clk);
	Register32 register10 (Q10,dataRD,LE_RD[10] && RW,0,Clk);
	Register32 register11 (Q11,dataRD,LE_RD[11] && RW,0,Clk);
	Register32 register12 (Q12,dataRD,LE_RD[12] && RW,0,Clk);
	Register32 register13 (Q13,dataRD,LE_RD[13] && RW,0,Clk);
	Register32 register14 (Q14,dataRD,LE_RD[14] && RW,0,Clk);
	Register32 register15 (Q15,dataRD,LE_RD[15] && RW,0,Clk);
	Register32 register16 (Q16,dataRD,LE_RD[16] && RW,0,Clk);
	Register32 register17 (Q17,dataRD,LE_RD[17] && RW,0,Clk);
	Register32 register18 (Q18,dataRD,LE_RD[18] && RW,0,Clk);
	Register32 register19 (Q19,dataRD,LE_RD[19] && RW,0,Clk);
	Register32 register20 (Q20,dataRD,LE_RD[20] && RW,0,Clk);
	Register32 register21 (Q21,dataRD,LE_RD[21] && RW,0,Clk);
	Register32 register22 (Q22,dataRD,LE_RD[22] && RW,0,Clk);
	Register32 register23 (Q23,dataRD,LE_RD[23] && RW,0,Clk);
	Register32 register24 (Q24,dataRD,LE_RD[24] && RW,0,Clk);
	Register32 register25 (Q25,dataRD,LE_RD[25] && RW,0,Clk);
	Register32 register26 (Q26,dataRD,LE_RD[26] && RW,0,Clk);
	Register32 register27 (Q27,dataRD,LE_RD[27] && RW,0,Clk);
	Register32 register28 (Q28,dataRD,LE_RD[28] && RW,0,Clk);
	Register32 register29 (Q29,dataRD,LE_RD[29] && RW,0,Clk);
	Register32 register30 (Q30,dataRD,LE_RD[30] && RW,0,Clk);
	Register32 register31 (Q31,dataRD,LE_RD[31] && RW,0,Clk);

	mux_32x1 muxRS (dataRS,RS, Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, Q11, Q12, Q13, Q14, Q15,
				 Q16, Q17, Q18, Q19, Q20, Q21, Q22, Q23, Q24, Q25, Q26, Q27, Q28, Q29, Q30, Q31);

	mux_32x1 muxRT (dataRT,RT, Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, Q11, Q12, Q13, Q14, Q15,
				 Q16, Q17, Q18, Q19, Q20, Q21, Q22, Q23, Q24, Q25, Q26, Q27, Q28, Q29, Q30, Q31);

	//For debugging, displays the new value of a register when it changes
	always @ (Q1) begin
		$display("Value of register 1 changed: %d",Q1);
	end

	always @ (Q2) begin
		$display("Value of register 2 changed: %d",Q2);
	end

	always @ (Q3) begin
		$display("Value of register 3 changed: %d",Q3);
	end

	always @ (Q4) begin
		$display("Value of register 4 changed: %d",Q4);
	end

	always @ (Q5) begin
		$display("Value of register 5 changed: %d",Q5);
	end

	always @ (Q6) begin
		$display("Value of register 6 changed: %d",Q6);
	end

	always @ (Q7) begin
		$display("Value of register 7 changed: %d",Q7);
	end

	always @ (Q8) begin
		$display("Value of register 8 changed: %d",Q8);
	end

	always @ (Q9) begin
		$display("Value of register 9 changed: %d",Q9);
	end

	always @ (Q10) begin
		$display("Value of register 10 changed: %d",Q10);
	end

	always @ (Q11) begin
		$display("Value of register 11 changed: %d",Q11);
	end

	always @ (Q12) begin
		$display("Value of register 12 changed: %d",Q12);
	end

	always @ (Q13) begin
		$display("Value of register 13 changed: %d",Q13);
	end

	always @ (Q14) begin
		$display("Value of register 14 changed: %d",Q14);
	end

	always @ (Q15) begin
		$display("Value of register 15 changed: %d",Q15);
	end

	always @ (Q16) begin
		$display("Value of register 16 changed: %d",Q16);
	end

	always @ (Q17) begin
		$display("Value of register 17 changed: %d",Q17);
	end

	always @ (Q18) begin
		$display("Value of register 18 changed: %d",Q18);
	end

	always @ (Q19) begin
		$display("Value of register 19 changed: %d",Q19);
	end

	always @ (Q20) begin
		$display("Value of register 20 changed: %d",Q20);
	end

	always @ (Q21) begin
		$display("Value of register 21 changed: %d",Q21);
	end

	always @ (Q22) begin
		$display("Value of register 22 changed: %d",Q22);
	end

	always @ (Q23) begin
		$display("Value of register 23 changed: %d",Q23);
	end

	always @ (Q24) begin
		$display("Value of register 24 changed: %d",Q24);
	end

	always @ (Q25) begin
		$display("Value of register 25 changed: %d",Q25);
	end

	always @ (Q26) begin
		$display("Value of register 26 changed: %d",Q26);
	end

	always @ (Q27) begin
		$display("Value of register 27 changed: %d",Q27);
	end

	always @ (Q28) begin
		$display("Value of register 28 changed: %d",Q28);
	end

	always @ (Q29) begin
		$display("Value of register 29 changed: %d",Q29);
	end

	always @ (Q30) begin
		$display("Value of register 30 changed: %d",Q30);
	end

	always @ (Q31) begin
		$display("Value of register 31 changed: %d",Q31);
	end

endmodule