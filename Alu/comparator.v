module comparator(output reg [31:0] regDestination, output reg [3:0] carryFlag, input [31:0] A, B, input [3:0] instToDo);

//  SLT instToDo = 0000
// SLTU instToDo = 0001
// SLTI instToDo = 0010
//SLTIU instToDo = 0011
//CLO   instToDo = 0100
//CLZ   instToDo = 0101
//MOVZ  instToDo = 0110
//A>= 0 instToDo = 0111
//A = B instToDo = 1000
//A < 0 instToDo = 1001
//A > 0 instToDo = 1010
//A<= 0 instToDo = 1011
//A!= 0 instToDo = 1100
//MOVN	instToDo = 1101
//A >=B instToDo = 1110
// A <B instToDo = 1111

//rs = A y rt = B


	reg signed [31:0] signedA;
	reg signed [31:0] signedB;
	reg [31:0]counter, cloCounter;
	reg flag;
	integer index, i;

always @ (A,B,instToDo) begin

	$display("Comparator: %d",instToDo);

	counter = 32'd0;
	cloCounter = 32'd0;
	index = 31;
	signedA = A;
	signedB = B;
	flag = 0;
	carryFlag = 0;
	//  SLT instToDo = 0000******************************************
		if (instToDo == 4'd0)
		 begin
			if(A<B)
			 regDestination = 32'b1;
			// jumpFlag = 0;
			else begin
			 regDestination = 32'd0;
			end
		 end

	// SLTU instToDo = 0001******************************************
		if (instToDo == 4'd1)
		 begin
			if(A<B)begin
			 	regDestination = 32'd1;
			 	end
			else begin
			 regDestination = 32'd0;		
			end	
		 end

	// SLTI instToDo = 0010******************************************
		if(instToDo == 4'd2)
		 begin
		 	if(signedA<signedB)
		 	 regDestination = 32'd1;
		 	else begin
		 	 regDestination = 32'd0;
		 	end
		 end

	//SLTIU instToDo = 0011******************************************
		if(instToDo == 4'd3)
		 begin
		 	if(A<B)
		 	 regDestination = 32'd1;
		 	else begin
		 	 regDestination = 32'd0;
		 	end
		 end

	//CLO   instToDo = 0100******************************************
		if(instToDo == 4'd4)
		 begin
		 	while(A[index] == 1'b1)
		 	 begin
		 		//$display("im here");
				counter = counter +32'd1;
		 		index = index -1;
		 	 end
		 	regDestination = counter;
		 end

	//CLZ   instToDo = 0101******************************************
		if(instToDo == 4'd5)
		 begin
		 	while(A[index] == 0)
		 	 begin
		 		counter = counter +32'd1;
		 		index = index -1;
		 	 end
		 	regDestination = counter;
		 end

	//MOVZ   instToDo = 0110
		if(instToDo == 4'd6) begin
			 if(B==32'd0) begin
				regDestination = A;
				carryFlag = 4'b0001;
			 end
	 	 end


	//A >= 0 BGEZ, BGEZAL   instToDo = 0111
		if(instToDo == 4'd7)begin		
			 if(A>=32'd0) begin
				carryFlag = 4'b0001;
		 	 end
		 end

	//A==B BEQ, TEQ   instToDo = 1000
		if(instToDo == 4'd8)begin		
			 if(A==B) begin
				carryFlag[0] = 1;
		 	 end

		 	 if(signedA==signedB)begin
		 	 	carryFlag[2] = 1;
		 	 end
		 end

	//A < 0  BLTZ, BLTZAL instToDo = 1001
		if(instToDo == 4'd9)begin		
			 if(A < 0) begin
				carryFlag[0] = 1;
		 	 end
		 end

	//A > 0 BGTZ instToDo = 1010
		if(instToDo == 4'd10)begin		
			 if(A > 0 && A[31] == 0) begin
				carryFlag[0] = 1;
		 	 end
		 end		

	//A <= 0 BLEZ instToDo = 1011
		if(instToDo == 4'd11)begin		
			 if(A <= 0) begin
				carryFlag[0] = 1;
		 	 end
		 end 

	//A != 0 BNE, TNE instToDo = 1100
		if(instToDo == 4'd12)begin		
			 if(A != B) begin
				carryFlag[0] = 1;
		 	 end

		 	 if(signedA != signedB) begin
				carryFlag[0] = 1;
		 	 end
		 end 

	//MOVN	instToDo = 1101
		if(instToDo == 4'd13) begin
			if(B != 32'd0) begin
				regDestination= A;
				carryFlag[0] = 1;
			end
		 end

	//A >= B TGE, TGEU instToDo = 1110
		if(instToDo == 4'd14)begin
			if(signedA>=signedB)begin
				carryFlag[2] = 1;
			end

			if(A>=B)begin
				carryFlag[3] = 1;
			end
		end

	// A < B TLT, TLTU instToDo = 1111
		if(instToDo == 4'd15)begin
			if(signedA<signedB)begin
				carryFlag[2] = 1;
			end

			if(A<B)begin
				carryFlag[3] = 1;
			end
		 end
 end
endmodule