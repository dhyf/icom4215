module test_alu;

	//Inputs
	reg [3:0] operation;
	reg [31:0] A, B;
	reg [1:0] sign;


	//Outputs
	wire [31:0] Y, outLO, outHI;
	wire [3:0] carryFlags;

	alu alu1 (Y,outHI,outLO,carryFlags,sign,operation,A,B);	

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

		#0 operation=4'b1111; #0 A=32'hFFFFFFFF; #0 B=32'hAAAAAAAA; #0 sign= 2'b00;
		#5 operation=4'b0000; #5 A=32'hFFFFFFFF; #5 B=32'hAAAAAAAA; #5 sign= 2'b00;

		$display("\nALU Test");
		$display("operation A B sign Y outLO outHI carryFlags");
		$monitor("%b %h %h %b %h %h %h %b",operation,A,B,sign,Y,outLO,outHI,carryFlags);		
		
	end

endmodule
