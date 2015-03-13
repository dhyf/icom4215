module multU(output reg [31:0] productHI, productLO, input [1:0] sign,
            input [31:0] multiplier,multiplicand);
  
   
   reg [63:0]          product;
   reg [31:0]    multiplicandToSum;  
   reg [31:0] invMultiplier;
   reg [31:0] invMultiplicand;
   integer       i;
 initial begin
  
  //initialize
    product = 64'd0;
  //We can't change the inputs so we store this values in temporary variables
    invMultiplier = multiplier;  
    invMultiplicand = multiplicand;
     //Checks if both the multiplicand and the multiplier are negative numbers
     //If they are, take the 2's complement of both and then pass them as parameters for the multiplication algorithm
        if((sign[1]==1) && (multiplicand[31]==1) && (multiplier[31]==1))
         begin
            invMultiplier = -(invMultiplier);
            invMultiplicand = -(invMultiplicand);
         end    
     //Checks if the multiplicand is a negative number
     //If it is, take the 2's complement and pass it as a parameter for the multiplication algorithm
     //Since in order for the program to enter this if-statement only the multiplicand is negative so we don't change the multiplier
        if((sign[1]==1) && (multiplicand[31]==1) && (multiplier[31]==0))
         begin
            invMultiplicand = -(invMultiplicand);
         end 
     //Checks if the multiplier is a negative number 
     //If it is, take the 2's complement and pass it as a parameter for the multiplication algorithm
     //Since in order for the program to enter this if-statement only the multiplier is negative so we don't change the multiplicand
        if((sign[1]==1) && (multiplicand[31]==0) && (multiplier[31]==1))
         begin
            invMultiplier = -(invMultiplier);
         end 

    multiplicandToSum = invMultiplicand;// multiplicandToSum will be added to the product(accumulator) each time invMultiplier[i] is 1

          //add & shift algorithm  for unsigned multiplication.        
              for(i=0; i<32; i=i+1) //i < 32 since the multiplier will be 32-bit
                begin
                     if(invMultiplier[i] == 1)
                       begin
                         product[63:32] = product[63:32] + multiplicandToSum ; 
                         product = product >> 1; 
                       end               
                     else
                       begin
                         product = product >> 1;
                       end  
                end 
          //The idea of this following if-statements is to invert the product if our multiplication was supposed to return 
          //a negative product
                if((sign[1]==1) && (multiplicand[31]==0) && (multiplier[31]==1))
                 begin
                    product = -product;
                 end

                if((sign[1]==1) && (multiplicand[31]==1) && (multiplier[31]==0))
                 begin
                    product = -product;
                 end
        // The resulting product will be stored in productHI & productLO, respectively containing the MSW and the LSW
          productHI = product[63:32];
          productLO = product[31:0];
  end   
endmodule