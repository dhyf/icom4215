module sign_extender(output reg[31:0] Y, input [15:0] imm16, input [1:0] S);

	always @ (S,imm16) begin

		if(S == 2'b01 && imm16[15]) begin
			Y[31:16] = 16'hFFFF;
			Y[15:0] = imm16;
		end

		else if(S == 2'b00 == 0 && imm16[15] == 0) begin
			Y[31:16] = 16'h0000;
			Y[15:0] = imm16;
		end

		else begin
			Y[4:0] = imm16[10:6];
			Y[31:5] = 27'd0;
		end


	end

endmodule