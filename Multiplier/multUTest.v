module test_multU;
  
  //input
 // wire [31:0] multiplier;
//  wire [31:0] multiplicand;

  //output
  wire [63:0] product;
  
  multU mult(product,32'd4,32'd4);

  initial #100 begin
    //multiplier = 32'd4;
//    multiplicand = 32'd4;  


    $display ("\nUnsigned Multiplication Test");
      
    $display ("product \tmultiplier \tmultiplicand");

    $monitor ("%d      \t%b         \t%b", product, 32'h4, 32'h4);
  end


endmodule