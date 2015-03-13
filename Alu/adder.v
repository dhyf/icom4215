module adder(output reg [31:0] result, output reg[3:0] carryFlags, input [31:0] A,B, input[1:0] sign);


//carryFlags(0) = V
//carryFlags(1) = N
//carryFlags(2) = Z
//carryFlags(3) = C

//Combinaciones de la variable sign:
//00 -> add unsigned
//01 -> add signed
//10 -> substract unsigned
//11 -> substract signed


//Local variable for storing the carry of the sum.
reg C;


initial begin
	//Clear the bits of the flags for the new operation.
	carryFlags = 4'b0;

	//Verifies if the operation is for adding or substracting. If the least significant bit
	// is 1 it will substract otherwise it will add.
	if(sign[0])
	   begin
	   		assign{C,result} = A - B;
	   end
	else 
		begin
			assign{C,result} = A + B;

		end
	
		//This will control the flags depending if it working with signed numbers or with unsigned.
		//If the most significant bit is 1 then it will work with signed numbers otherwise with unsigned.
		if(sign[1])
		begin
		carryFlags[1] = result[31]; //If the most significant bit will determine de Negative flag.
		carryFlags[3] = C; //If the operation gets a carry it will turn on this flag.
			if(result == 0)
			begin
			carryFlags[2] = 1; //if the operation results equals zero, it will turn on this flag.
			end
			if((A[31] == B[31]) && (A[31] != result[31])) // if two positives numbers results in a negative number or two negatives numbers results in a positive number
				begin 									  // then the overflow flags will turn on.
				carryFlags[0] = 1;
				end
	    end
		else 
			begin
			carryFlags[0] = 0;   //Overflow flags operates with signed numbers.
			carryFlags[1] = 0;   //Negative flags operates with signed numbers
			carryFlags[3] = C;   //If the operation creates a carry this flag will turn on.
				if(result == 0) 
					begin
					carryFlags[2] = 1; //if the result of the operation is zero this flag will turn on.
					end
	         end 
	     
end

endmodule