module multU(output reg [63:0] product,
            input [31:0] multiplier,multiplicand);
  
   
   reg           carry;
   reg [31:0]    multiplicandToSum;  
   integer       i;
 
   always @(multiplier, multiplicand)
     begin
//initialize
        product[63:32] = multiplier;
        product[31:0] = 32'd0;
        multiplicandToSum = multiplicand; 
        carry = 1'd0; //carry
 
      
//add/shift algorithm  for unsigned multiplication.        
         for(i=0; i<32; i=i+1) //i = 32 since the multiplier will be 32-bit
           begin
               if(multiplier[i])
                 begin 
                   {carry,product[63:32]} = product + multiplicandToSum ;  // curly brackets let me concatenate(shift right with 0)
                   product[63:0] = {carry,product[63:1]}; 
                 end               
               else
                 begin
                     product[63:0] = {carry,product[63:1]};
                 end  
          end 
    end   
endmodule