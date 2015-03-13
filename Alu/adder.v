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

	//Verifies if the operation is for adding or substracting. If sign
	if(sign[0])
	   begin
	   		assign{C,result} = A - B;
	   end
	else 
		begin
			assign{C,result} = A + B;

		end
	

		if(sign[1])
		begin
		carryFlags[1] = result[31];
		carryFlags[3] = C;
			if(result == 0)
			begin
			carryFlags[2] = 1;
			end
			if((A[31] == B[31]) && (A[31] != result[31]))
				begin
				carryFlags[0] = 1;
				end
	    end
		else 
			begin
			carryFlags[0] = 0;
			carryFlags[1] = 0;
			carryFlags[3] = C;
				if(result == 0) 
					begin
					carryFlags[2] = 1;
					end
	         end 
	     
end

endmodule