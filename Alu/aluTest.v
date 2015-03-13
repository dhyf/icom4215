module test_alu;

	//Inputs
	reg [3:0] operation;
	reg [31:0] A, B;
	reg [1:0] sign;


	//Outputs
	wire [31:0] Y, outLO, outHI;
	wire [3:0] carryFlags;


	alu alu1 (Y,outHI,outLO,carryFlags,4'd0,2'd0,32'd4,32'd8);	

	// initial fork
	// 	//Pasa valor B a salida

	// 	//Sumar o restar (con y sin signo)

	// 	//Multiplicacion (con y sin signo)

	// 	//Division (con y sin signo)

	// 	//AND logico

	// 	//OR logico

	// 	//NOR logico

	// 	//Shift logico a la derecha

	// 	//Shift lofico a la izquierda

	// 	//Shift aritmetico a la derecha

	// 	//LUI

	// join


	initial begin

		$display("\nALU Test");
		$display("operation A B sign Y outLO outHI carryFlags");
		$monitor("%b %h %h %b %h",4'd0,32'd4,32'd8,2'd0,Y);		
		
	end

endmodule
