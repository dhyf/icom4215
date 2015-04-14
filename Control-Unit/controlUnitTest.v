module test_control_unit;

	//Inputs
	reg [31:0] instruction;
	reg [3:0] aluCarryFlags;
	reg ramMFC;
	reg reset;
	reg hardwareInterrupt;
	reg maskableInterrupt;
	reg Clk;

	//Outputs
	wire [2:0] cmpsignal;
	wire trapMux;
	wire signExtend;
	wire clearPC;
	wire regFileRW;
	wire [4:0] regFileRD, regFileRS, regFileRT;
	wire [1:0] aluSign;
	wire [3:0] aluOperation;
	wire [1:0] ramDataSize;
	wire ramMFA;
	wire ramRW;
	wire [8:0] ramAddress;
	wire pcEnable, irEnable, marEnable, mdrEnable;
	wire [1:0] muxSignals; //M0; M1 from data path diagram (mux to ALU(B))
	wire muxSignals2; //S from data path diagram (mux to MDR)
	wire [1:0] muxSignals3; //Mux selector to load HI/LO registers in mult and div
	wire [31:0] nextPC;
	wire muxSignals5;

	controlUnit cu (nextPC,muxSignals5,cmpsignal,trapMux,signExtend,clearPC,regFileRW,regFileRD,regFileRS,regFileRT,
		aluSign,aluOperation,ramDataSize,ramMFA,ramRW,
		ramAddress,pcEnable,irEnable,marEnable,
		mdrEnable,muxSignals,muxSignals2,muxSignals3,
		instruction,aluCarryFlags,ramMFC,reset,
		hardwareInterrupt,maskableInterrupt,Clk);

	initial #30 $finish;

	//Clock signal
	initial begin
		Clk = 1'b0;
		forever begin
			#1 Clk = ~Clk;
		end
	end

	

	initial fork
		#0 instruction = 32'b00000000001000100001100000100000;
		#0 ramMFC = 0;
		#3 ramMFC = 1;
		#10 instruction = 32'b10000010000000000000000000000000;
	join


	initial begin

		$display("\nControl Unit Test");
		$monitor("\nTime: %d", $time);
		$monitor("\nOutput: regFileRW: %b", regFileRW);
		$monitor("\nOutput: regFileRS: %b", regFileRS);
		$monitor("\nOutput: regFileRT: %b", regFileRT);
		$monitor("\nOutput: regFileRD: %b", regFileRD);
		
	end

endmodule


