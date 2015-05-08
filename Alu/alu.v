module alu(output reg  [31:0] Y, outHI, outLO, output reg [3:0] carryFlag, input [3:0] operation,input [1:0] sign, input [31:0] A,B, input [3:0] cmpsignal);


  	//Outputs from modules
  	wire [31:0] productHI;
  	wire [31:0] productLO;
  	wire [31:0] divisionHI;
  	wire [31:0] divisionLO;
  	wire [31:0] addSubResult;
  	wire [31:0] luiOutput;
  	wire [31:0] cmpResult;
  	wire [3:0] adderCarryFlag;
  	wire [3:0] compCarryFlag;

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
  	adder addSub(addSubResult,adderCarryFlag,A,B,sign);
  	lui luiModule(luiOutput,A);
  	comparator cmp(cmpResult, compCarryFlag, A,B, cmpsignal);

always @ (operation, A, B, sign, cmpsignal) begin

	case (operation)
	//Pasa valor B a salida
	4'b0000: assign Y = B;
	//Sumar o restar (con y sin signo)
	4'b0001: begin assign Y = addSubResult; assign carryFlag = adderCarryFlag; end
	//Multiplicacion (con y sin signo)
	4'b0010: begin assign outHI = productHI; assign outLO = productLO; end
	//Division (con y sin signo)
	4'b0011: begin assign outHI = divisionHI; assign outLO = divisionLO; end
	//AND logico
	4'b0100: assign Y = A & B;
	//OR logico
	4'b0101: assign Y = A | B;
	//NOR logico
	4'b0110: assign Y = ~(A | B);
	//Shift logico a la derecha
	4'b0111: assign Y = (A>>B);
	//Shift lofico a la izquierda
	4'b1000: assign Y = (A<<B);
	//Shift aritmetico a la derecha
	4'b1001: assign Y = $signed(A) >>> B;
	//LUI
	4'b1010: assign Y = luiOutput;
	//add 4
	4'b1011: assign Y = B + 32'd4;
	//XOR logico
	4'b1100: assign Y = (A ^ B);
	//Comparator
	4'b1101: begin assign Y = cmpResult; assign carryFlag = compCarryFlag; end
	//Move to Hi
	4'b1110: assign outHI = A;
	//Move to Lo
	4'b1111: assign outLO = A;
	endcase

end

//For debugging, displays ALU output values when it changes
always @ (Y) begin
	$display("ALU Output changed to %d after operation %b with inputs A=%d B=%d",Y,operation,A,B);
end

always @ (outHI, outLO) begin
	$display("ALU HI=%h LO=%h after operation %b with Y=%d A=%d B=%d",outHI,outLO,operation,Y,A,B);
end

always @ (carryFlag) begin
	$display("CarryFlags=%b",carryFlag);
end

endmodule