module adder(output reg [31:0] result, output reg[3:0] carryFlags, input [31:0] A,B, input sign);


//carryFlags(0) = V
//carryFlags(1) = N
//carryFlags(2) = Z
//carryFlags(3) = C

reg C;

initial begin
	carryFlags = 4'b0;
	assign{C,result} = A + B;

		if(sign)
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
				if(result[31] == 0) 
					begin
					carryFlags[2] = 1;
					end
	         end 
	     
end

endmodule