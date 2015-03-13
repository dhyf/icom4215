module alu(output reg  [31:0] Y, outHI, outLO, output [3:0] carryFlag, input [3:0] operation,input [1:0] sign, input [31:0] A,B);


  	//Outputs from modules
  	wire [31:0] productHI;
  	wire [31:0] productLO;
  	wire [31:0] divisionHI;
  	wire [31:0] divisionLO;
  	wire [31:0] addSubResult;

	//carryFlag(0) = V
	//carryFlag(1) = N
	//carryFlag(2) = Z
	//carryFlag(3) = C

	//Combinaciones de la variable sign:
	//00 -> suma unsigned
	//01 -> suma signed
	//10 -> resta unsigned
	//11 -> resta signed
  
  	multU mult(productHI, productLO, sign, A, B);
  	divU div(divisionHI, divisionLO, sign, A, B);
  	adder addSub(addSubResult,carryFlag,A,B,sign);


always@ (operation, A, B, sign)

	case (operation)
	//Pasa valor B a salida
	4'b0000: Y <= B;
	//Sumar o restar (con y sin signo)
	4'b0001: Y = addSubResult;
	//Multiplicacion (con y sin signo)
	4'b0011: begin outHI = productHI; outLO = productLO; end
	//Division (con y sin signo)
	4'b0100: begin outHI = divisionHI; outLO = divisionLO; end
	//AND logico
	4'b0101: Y <= A & B;
	//OR logico
	4'b0110: Y <= A | B;
	//NOR logico
	4'b0111: Y <= ~(A | B);
	//Shift logico a la derecha
	4'b1000: Y = (B>>A);
	//Shift lofico a la izquierda
	4'b1001: Y = (B<<A);
	//Shift aritmetico a la derecha
	4'b1010: Y = $signed(B) >>> A;
	default: Y = Y;
	endcase

endmodule