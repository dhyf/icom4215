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
					input regFileEnable, pcEnable, irEnable, marEnable, mdrEnable,
					input [1:0] muxSignals, //M0, M1 from data path diagram (mux to ALU(B))
					input muxSignal, //S from data path diagram (mux to MDR)
					input ramMFC,
					input reset,
					input hardwareInterrupt,
					input maskableInterrupt);

reg [3:0] state,nextState;

//always @ (instruction, aluCarryFlags, ramMFC, reset,hardwareInterrupt,maskableInterrupt)



endmodule
