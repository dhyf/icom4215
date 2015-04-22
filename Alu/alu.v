module alu(output reg  [31:0] Y, outHI, outLO, output [3:0] carryFlag, input [3:0] operation,input [1:0] sign, input [31:0] A,B, input [2:0] cmpsignal);


  	//Outputs from modules
  	wire [31:0] productHI;
  	wire [31:0] productLO;
  	wire [31:0] divisionHI;
  	wire [31:0] divisionLO;
  	wire [31:0] addSubResult;
  	wire [31:0] luiOutput;
  	wire [31:0] cmpResult;

  	reg [31:0] adderResult;

	//carryFlag(0) = V
	//carryFlag(1) = N
	//carryFlag(2) = Z
	//carryFlag(3) = C

	//Combinaciones de la variable sign:
	//00 -> suma unsigned
	//01 -> resta unsigned
	//10 -> suma signed
	//11 -> resta signed
  
  	//Instances of modules for multiplication, division, addition, substraction and LUI
  	multU mult(productHI, productLO, sign, A, B);
  	divU div(divisionHI, divisionLO, sign, A, B);
  	adder addSub(addSubResult,carryFlag,A,B,sign);
  	lui luiModule(luiOutput,A);
  	comparator cmp(cmpResult, A,B, cmpsignal);

always @ (operation, A, B, sign, cmpsignal) begin

	case (operation)
	//Pasa valor B a salida
	4'b0000: Y = B;
	//Sumar o restar (con y sin signo)
	4'b0001: assign Y = addSubResult;
	//Multiplicacion (con y sin signo)
	4'b0010: begin assign outHI = productHI; assign outLO = productLO; end
	//Division (con y sin signo)
	4'b0011: begin assign outHI = divisionHI; assign outLO = divisionLO; end
	//AND logico
	4'b0100: Y <= A & B;
	//OR logico
	4'b0101: Y <= A | B;
	//NOR logico
	4'b0110: Y <= ~(A | B);
	//Shift logico a la derecha
	4'b0111: Y = (B>>A);
	//Shift lofico a la izquierda
	4'b1000: Y = (B<<A);
	//Shift aritmetico a la derecha
	4'b1001: Y = $signed(B) >>> A;
	//LUI
	4'b1010: assign Y = luiOutput;
	//add 4
	4'b1011: Y = B + 32'd4;
	//XOR logico
	4'b1100: Y = (A ^ B);
	//Comparator
	4'b1101: assign Y = cmpResult;
	default: Y = Y; //Cualquier opcion diferente devuelve la misma entrada
	endcase

end

//For debugging, displays ALU output values when it changes
always @ (Y) begin
	$display("ALU Output changed to %d after operation %b with inputs A=%d B=%d",Y,operation,A,B);
end

endmodule