module sign_extender(output reg[31:0] Y, input [15:0] imm16, input S);

	always @ (S,imm16) begin

		if(S && imm16[15]) begin
			Y[31:16] = 16'hFFFF;
		end

		else begin
			Y[31:16] = 16'h0000;
		end

		Y[15:0] = imm16;

	end

endmodule