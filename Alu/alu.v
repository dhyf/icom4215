module alu(output reg [31:0] Y, output [3:0] carryFlag, input [3:0] S,input sign, input [31:0] A,B);


output reg carry;


//carryFlags(0) = V
//carryFlags(1) = N
//carryFlags(2) = Z
//carryFlags(3) = C


always@ (S)
	case (S)
	4'b0000: Y <= B;
	4'b0001: assign{carry,Y} = (A + B);
	4'b0011: Y = A * B;
	4'b0100: Y <= A / B;
	4'b0101: Y <= A & B;
	4'b0110: Y <= A | B;
	4'b0111: Y <= ~(B);
	4'b1000: Y = (B>>1);
	4'b1001: Y = (B<<1);
	4'b1010: Y = $signed(B) >>> 1;
	4'b1011: assign{carry,Y} = (A - B);
	endcase





endmodule