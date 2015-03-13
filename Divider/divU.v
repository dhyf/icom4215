module divU(output reg [31:0] divisionHIRes,
            output reg [31:0] divisionLOQuo,
            input [31:0] dividend, 
            input [31:0] divisor);
  
   //Hacer diagrama de bloque
   reg [31:0] numToSub;
   reg [31:0] counter;

    //initialize



   always @ (dividend, divisor) begin
      numToSub = dividend;
      counter = 32'd0;

      //dividend - divisor <--- is this less than divisor?
      while(numToSub >= divisor) begin
       // $display("Inside loop");   
        numToSub = numToSub - divisor;
        counter = counter +1;
      end

      divisionHIRes = numToSub;
      divisionLOQuo = counter;

    end
endmodule