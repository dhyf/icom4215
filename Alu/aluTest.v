module test_alu;

	//Inputs
	reg [3:0] operation;
	reg [31:0] A, B;
	reg [1:0] sign;


	//Outputs
	wire [31:0] Y, outLO, outHI;
	wire [3:0] carryFlags;

	// iverilog -o output.out adder.v divU.v multU.v lui.v alu.v aluTest.v
	//alu alu1 (Y,outHI,outLO,carryFlags,4'd0,2'd0,32'd4,32'd8);	

	// initial fork
	// 	//Pasa valor B a salida
	//alu alu0 (Y,outHI,outLO,carryFlags,4'd0,2'd0,32'd4,32'd8);	

	// 	//Sumar o restar (con y sin signo)
	//alu alu1 (Y,outHI,outLO,carryFlags,4'd1,2'b11,-32'd4,-32'd8);	

	// 	//Multiplicacion (con y sin signo)
	//alu alu2 (Y,outHI,outLO,carryFlags,4'd2,2'b10,-32'd4,-32'd8);	

	// 	//Division (con y sin signo)
	//alu alu3 (Y,outHI,outLO,carryFlags,4'd3,2'b10,32'd32,-32'd10);	

	// 	//AND logico
	//alu alu4 (Y,outHI,outLO,carryFlags,4'd4,2'b10,-32'd6,32'd7);	

	// 	//OR logico
	//alu alu5 (Y,outHI,outLO,carryFlags,4'd5,2'd0,32'd4,32'd8);	

	// 	//NOR logico
	//alu alu6 (Y,outHI,outLO,carryFlags,4'd6,2'd0,32'd4,32'd8);	

	// 	//Shift logico a la derecha
	//alu alu7 (Y,outHI,outLO,carryFlags,4'd7,2'd0,32'd1,32'd8);	

	// 	//Shift lofico a la izquierda
	//alu alu8 (Y,outHI,outLO,carryFlags,4'd8,2'd0,32'd1,32'd8);	

	// 	//Shift aritmetico a la derecha
	//alu alu9 (Y,outHI,outLO,carryFlags,4'd9,2'd0,32'd1,32'd8);	

	// 	//LUI
	alu alu10 (Y,outHI,outLO,carryFlags,4'd10,2'd0,32'd4,32'd8);	

	// join


	initial begin

		$display("\nALU Test");
		$display("operation A B sign Y outLO outHI carryFlags");
		$monitor("%b %h %h %b %h %b %h %h ",4'd0,32'd4,32'd8,2'd0,Y,carryFlags, outHI, outLO);		
		
	end

endmodule
