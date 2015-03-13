module multU(output reg [31:0] productHI, productLO, input [1:0] sign,
            input [31:0] multiplier,multiplicand);
  
   
   reg [63:0]          product;
   reg [31:0]    multiplicandToSum;  
   reg [31:0] invMultiplier;
   reg [31:0] invMultiplicand;
   integer       i;
 always @ (multiplier, multiplicand) begin
  
  //initialize
    product = 64'd0;
    invMultiplier = multiplier;
    invMultiplicand = multiplicand;

        if((sign[1]==1) && (multiplicand[31]==1) && (multiplier[31]==1))
         begin
               invMultiplier = -(invMultiplier);
               $display("if aqui toy");
               invMultiplicand = -(invMultiplicand);
         end    

        if((sign[1]==1) && (multiplicand[31]==1) && (multiplier[31]==0))
         begin
               //invMultiplier = -(invMultiplier);
                $display("blah");
                $display(multiplicand[31], "       ", multiplier[31]);
               invMultiplicand = -(invMultiplicand);

         end 

          if((sign[1]==1) && (multiplicand[31]==0) && (multiplier[31]==1))
         begin
               invMultiplier = -(invMultiplier);
                $display("bleh");
                $display(multiplicand[31], "       ", multiplier[31]);
               //invMultiplicand = -(invMultiplicand);

         end 
 multiplicandToSum = invMultiplicand;   
          //add/shift algorithm  for unsigned multiplication.        
              for(i=0; i<32; i=i+1) //i < 32 since the multiplier will be 32-bit
                begin
                     if(invMultiplier[i] == 1)
                       begin
                       // $display("Inside loop");  
                       // $display(multiplier,"      ", invMultiplier); 
                         product[63:32] = product[63:32] + multiplicandToSum ; 
                         product = product >> 1; 
                       end               
                     else
                       begin
                           product = product >> 1;
                       end  
                end 

                if((sign[1]==1) && (multiplicand[31]==0) && (multiplier[31]==1))
                begin
                 $display("Z_Z");
                  product = -product;
                end

                 if((sign[1]==1) && (multiplicand[31]==1) && (multiplier[31]==0))
                begin
                 $display("x_x");
                  product = -product;
                end

                productHI = product[63:32];
                productLO = product[31:0];
  end   
endmodule