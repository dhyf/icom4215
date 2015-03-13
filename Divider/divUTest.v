module divUTest;
  
  //input
  reg [31:0] dividend=32'd34, divisor = -32'd5;


  //output
  wire [31:0] divisionHIRes;
  wire [31:0] divisionLOQuo;
  
  divU div(divisionHIRes, divisionLOQuo, 2'b10,dividend,divisor);

  initial begin

    $display ("\n\tUnsigned Division Test");
      
    $display ("\n\tdivisionHIRes\tdivisionLOQuo   \tdivisor \tdividend");

    $monitor ("\n %h  \t%h      \t%h      \t%h", divisionHIRes, divisionLOQuo, divisor, dividend);
  end
endmodule