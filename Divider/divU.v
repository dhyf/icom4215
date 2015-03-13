module divU(output reg [31:0] divisionHIRes,
            output reg [31:0] divisionLOQuo,
            input [1:0] sign,
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

      invDivisor = divisor;
      invDividend = dividend;
     
        if((sign[1]==1) && (dividend[31]==1) && (divisor[31]==1))
         begin
               invDivisor = -(invDivisor);
               $display("if aqui toy");
               invDividend = -(invDividend);
         end    

        if((sign[1]==1) && (dividend[31]==1) && (divisor[31]==0))
         begin
               //invMultiplier = -(invMultiplier);
                $display("blah");
                $display(dividend[31], "       ", divisor[31]);
               invDividend = -(invDividend);

         end 

           if((sign[1]==1) && (dividend[31]==0) && (divisor[31]==1))
         begin
               invDivisor = -(invDivisor);
                $display("kbron de la guitarra");
                $display(dividend[31], "       ", divisor[31]);
               //invDividend = -(invDividend);

         end 

        numToSub = invDividend;
      //dividend - divisor <--- is this less than divisor?
      while(numToSub >= invDivisor) begin
       // $display("Inside loop");   
        numToSub = numToSub - invDivisor;
        counter = counter +1;
      end

        if((sign[1]==1) && (dividend[31]==0) && (divisor[31]==1))
                begin
                 $display("Z_Z");
                  //numToSub = -numToSub;  
                  counter = -counter;
                end


                if((sign[1]==1) && (dividend[31]==1) && (divisor[31]==0))
                begin
                 $display("x_x");
                  //numToSub = -numToSub;
                  counter = -counter;
                end

      divisionHIRes = numToSub;
      divisionLOQuo = counter;

    end
endmodule