module test_multU;
  
  //input
 // wire [31:0] multiplier; <---commented because the inputs will be received, the values in the instance were for illustration
//  wire [31:0] multiplicand;

  //output
  wire [31:0] productHI;
  wire [31:0] productLO;
  
  multU mult(productHI, productLO,2'b10, 32'd20,-32'd30);

  initial #100 begin
    //multiplier = 32'd4;
//    multiplicand = 32'd4;  


    $display ("\n\tUnsigned Multiplication Test");
      
    $display ("\n\tproductHI\tproductLO");

    $monitor ("\n %h  \t%h", productHI, productLO);
  end
endmodule