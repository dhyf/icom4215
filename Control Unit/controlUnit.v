module controlUnit (output reg regFileRW,
					output reg [4:0] regFileRD,regFileRS,regFileRT,
					output reg [1:0] aluSign,
					output reg [3:0] aluOperation,
					output reg [1:0] ramDataSize,
					output reg ramMFA,
					output reg ramRW,
					output reg [8:0] ramAddress,
					input [31:0] instruction,
					input [3:0] aluCarryFlags,
					input ramMFC,
					input reset,
					input hardwareInterrupt,
					input maskableInterrupt);



endmodule
