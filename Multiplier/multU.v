module multU(output reg [31:0] productHI, productLO,
            input [31:0] multiplier,multiplicand);
  
   
   reg [63:0]          product;
   reg [31:0]    multiplicandToSum;  
   integer       i;

     initial begin
//initialize
        product = 64'd0;
       
        multiplicandToSum = multiplicand; 

//add/shift algorithm  for unsigned multiplication.        
         for(i=0; i<32; i=i+1) //i < 32 since the multiplier will be 32-bit
           begin
               if(multiplier[i] == 1)
                 begin 
                   product[63:32] = product[63:32] + multiplicandToSum ; 
                   product = product >> 1; 
                 end               
               else
                 begin
                     product = product >> 1;
                 end  
          end 
          productHI = product[63:32];
          productLO = product[31:0];
    end   
endmodule