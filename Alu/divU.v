module divU(output reg [31:0] divisionHIRes, // Register where the quotioent of the result will be stored 
            output reg [31:0] divisionLOQuo, // Register where the residue of the result will be stored 
            input [1:0] sign, // Sign signal that will come from the Control Unit
           // Inputs for the division algorithm
            input [31:0] dividend, 
            input [31:0] divisor);
  
   //Hacer diagrama de bloque
   // iverilog -o output.out divU.v divUTest.v
    reg [31:0] numToSub;
    reg [31:0] counter;
    reg [31:0] invDivisor;
    reg [31:0] invDividend;


   always @ (dividend, divisor) begin
      
      counter = 32'd0;
     // We can't change the inputs so we store this values in temporary variables
      invDivisor = divisor;
      invDividend = dividend;

     //Checks if both the dividend and the diveder are negative numbers      
     //If they are, take the 2's complement of both and then pass them as parameters for the division algorithm
        if((sign[1]==1) && (dividend[31]==1) && (divisor[31]==1))
         begin
           invDivisor = -(invDivisor);
           invDividend = -(invDividend);
         end  

     //Checks if the dividend is a negative number
     //If it is, take the 2's complement and pass it as a parameter for the division algorithm
     //Since in order for the program to enter this if-statement only the dividend is negative so we don't change the divisor
        if((sign[1]==1) && (dividend[31]==1) && (divisor[31]==0))
         begin
           invDividend = -(invDividend);
         end 

     //Checks if the divisor is a negative number
     //If it is, take the 2's complement and pass it as a parameter for the division algorithm
     //Since in order for the program to enter this if-statement only the divisor is negative so we don't change the dividend
        if((sign[1]==1) && (dividend[31]==0) && (divisor[31]==1))
         begin
           invDivisor = -(invDivisor);
         end 

        numToSub = invDividend; // numToSub will be subtracted in every iteration by the divisor until the while condition is met.

      // Subtract divisor from numToSub and add 1 to the counter for every iteration the while statement is true.
      while(numToSub >= invDivisor) begin
        numToSub = numToSub - invDivisor;
        counter = counter +1;
      end

      //The idea of this following if-statements is to invert the quotient if our division was supposed to return 
      //a negative product
        if((sign[1]==1) && (dividend[31]==0) && (divisor[31]==1))
                begin 
                  counter = -counter;
                end


        if((sign[1]==1) && (dividend[31]==1) && (divisor[31]==0))
                begin
                  counter = -counter;
                end
      // The quotient will be stored in divisionLOQuo and the residue will be stored in divisionHIRes
      divisionHIRes = numToSub;
      divisionLOQuo = counter;

    end
endmodule