module comparator(output reg [31:0] regDestination, input [31:0] A, B, input [2:0] instToDo);

//  SLT instToDo = 000
// SLTU instToDo = 001
// SLTI instToDo = 010
//SLTIU instToDo = 011
//CLO   instToDo = 100
//CLZ   instToDo = 101


always @ (A,B,instToDo) begin
	reg signed [31:0] signedA = A;
	reg signed [31:0] signedB = B;	
	reg [31:0]counter = 32'd0;
	integer index = 31;

	//  SLT instToDo = 000******************************************
		if (instToDo == 3'd0)
		 begin
			if(signedA<signedB)
			 regDestination = 32'b1;
			else begin
			 regDestination = 32'd0;
			end
		end

	// SLTU instToDo = 001******************************************
		if (instToDo == 3'd1)
		 begin
			if(A<B)
			 regDestination = 32'd1;
			else begin
			 regDestination = 32'd0;		
			end	
		 end

	// SLTI instToDo = 010******************************************
		if(instToDo == 3'd2)
		 begin
		 	if(signedA<signedB)
		 	 regDestination = 32'd1;
		 	else begin
		 	 regDestination = 32'd0;
		 	end
		 end

	//SLTIU instToDo = 011******************************************
		if(instToDo == 3'd3)
		 begin
		 	if(A<B)
		 	 regDestination = 32'd1;
		 	else begin
		 	 regDestination = 32'd0;
		 	end
		 end

	//CLO   instToDo = 100******************************************
		if(instToDo == 32'd4)
		 begin
			while(A[index])
			 begin 
			 counter = counter+1;
			 index = index -1;
			 end
			regDestination = counter;
		 end

	//CLZ   instToDo = 101******************************************
		if(instToDo == 32'd5)
		 begin
		 	while(A[index] == 0)
		 	 begin
		 		counter = counter +32'd1;
		 		index = index -1;
		 	 end
		 	regDestination = counter;
		 end
		
 end
endmodule