module decoder_5_32 (output reg [31:0] D, input [4:0] S);

always @ (D, S)

	casez (S)
		5'b00000: begin D = 32'b0; D[0] = 1; end
		5'b00001: begin D = 32'b0; D[1] = 1; end
		5'b00010: begin D = 32'b0; D[2] = 1; end
		5'b00011: begin D = 32'b0; D[3] = 1; end
		5'b00100: begin D = 32'b0; D[4] = 1; end
		5'b00101: begin D = 32'b0; D[5] = 1; end
		5'b00110: begin D = 32'b0; D[6] = 1; end
		5'b00111: begin D = 32'b0; D[7] = 1; end
		5'b01000: begin D = 32'b0; D[8] = 1; end
		5'b01001: begin D = 32'b0; D[9] = 1; end
		5'b01010: begin D = 32'b0; D[10] = 1; end
		5'b01011: begin D = 32'b0; D[11] = 1; end
		5'b01100: begin D = 32'b0; D[12] = 1; end
		5'b01101: begin D = 32'b0; D[13] = 1; end
		5'b01110: begin D = 32'b0; D[14] = 1; end
		5'b01111: begin D = 32'b0; D[15] = 1; end
		5'b10000: begin D = 32'b0; D[16] = 1; end
		5'b10001: begin D = 32'b0; D[17] = 1; end
		5'b10010: begin D = 32'b0; D[18] = 1; end
		5'b10011: begin D = 32'b0; D[19] = 1; end
		5'b10100: begin D = 32'b0; D[20] = 1; end
		5'b10101: begin D = 32'b0; D[21] = 1; end
		5'b10110: begin D = 32'b0; D[22] = 1; end
		5'b10111: begin D = 32'b0; D[23] = 1; end
		5'b11000: begin D = 32'b0; D[24] = 1; end
		5'b11001: begin D = 32'b0; D[25] = 1; end
		5'b11010: begin D = 32'b0; D[26] = 1; end
		5'b11011: begin D = 32'b0; D[27] = 1; end
		5'b11100: begin D = 32'b0; D[28] = 1; end
		5'b11101: begin D = 32'b0; D[29] = 1; end
		5'b11110: begin D = 32'b0; D[30] = 1; end
		5'b11111: begin D = 32'b0; D[31] = 1; end
	endcase

endmodule