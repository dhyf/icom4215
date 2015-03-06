module register_file (
	output reg [31:0] dataRS,
	output reg [31:0] dataRT,
	input [4:0] RD,
	input [4:0] RS,
	input [4:0] RT,
	input [31:0] dataRD,
	input RW,
	input Clk);

	reg [31:0] LE_RD;

	reg [31:0] Q0;
	reg [31:0] Q1;
	reg [31:0] Q2;
	reg [31:0] Q3;
	reg [31:0] Q4;
	reg [31:0] Q5;
	reg [31:0] Q6;
	reg [31:0] Q7;
	reg [31:0] Q8;
	reg [31:0] Q9;
	reg [31:0] Q10;
	reg [31:0] Q11;
	reg [31:0] Q12;
	reg [31:0] Q13;
	reg [31:0] Q14;
	reg [31:0] Q15;
	reg [31:0] Q16;
	reg [31:0] Q17;
	reg [31:0] Q18;
	reg [31:0] Q19;
	reg [31:0] Q20;
	reg [31:0] Q21;
	reg [31:0] Q22;
	reg [31:0] Q23;
	reg [31:0] Q24;
	reg [31:0] Q25;
	reg [31:0] Q26;
	reg [31:0] Q27;
	reg [31:0] Q28;
	reg [31:0] Q29;
	reg [31:0] Q30;
	reg [31:0] Q31;

	decoder_5_32 decoderRD (LE_RD,RD);

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


endmodule