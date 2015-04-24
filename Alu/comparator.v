module comparator(output reg [31:0] regDestination, input [31:0] A, B, input [2:0] instToDo);

//  SLT instToDo = 0000
// SLTU instToDo = 0001
// SLTI instToDo = 0010
//SLTIU instToDo = 0011
//CLO   instToDo = 0100
//CLZ   instToDo = 0101
//*************************v faltan por implementar
//MOVZ  instToDo = 0110
//A>=0  instToDo = 0111
//A = B instToDo = 1000
//A < 0 instToDo = 1001
//A > 0 instToDo = 1010
//A<= 0 instToDo = 1011
//A!= 0 instToDo = 1100

	reg signed [31:0] signedA;
	reg signed [31:0] signedB;
	reg [31:0]counter, cloCounter;
	reg flag;
	integer index, i;

always @ (A,B,instToDo) begin

	counter = 32'd0;
	cloCounter = 32'd0;
	index = 31;
	signedA = A;
	signedB = B;
	flag = 0;
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
			if(A<B)begin
			 	regDestination = 32'd1;
			 	end
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
		 $display("hello %h", signedA);
			for(i = 31; i >= 0; i = i - 1)
			begin
					 $display("hello2");

				if(A[i] == 1 && flag == 0)
				begin
					counter = counter + 1;
							 $display("counter %d", counter);

				end
				else begin
					flag = 1;
				end
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