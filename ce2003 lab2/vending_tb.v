`timescale 1ns / 1ps

module vending_tb;
  
  // Inputs
  reg in1;
  reg in2;
  reg in5;
  reg clk;
  reg rst;
  reg cancel;
  // Outputs
  wire vend;
  wire out1;
  wire out2;
  wire out22;
  // Instantiate the Unit Under Test (UUT)
  VendingMachine uut (
               .in1(in1), 
               .in2(in2), 
               .in5(in5), 
               .clk(clk), 
               .rst(rst), 
               .cancel(cancel), 
               .vend(vend), 
               .out1(out1), 
               .out2(out2), 
               .out22(out22)
               );
  always #1 clk = ~clk;
  initial begin
    // Initialize Inputs
    in1 = 0;
    in2 = 0;
    in5 = 0;
    clk = 0;
    rst = 0;
    cancel = 0;
    #10 in1 = 1'b1; in2 = 1'b0; in5 = 1'b0;
    #10 in1 = 1'b1; in2 = 1'b1; in5 = 1'b0;
    #10 in1 = 1'b1; in2 = 1'b1; in5 = 1'b1;
    #5000 in1 = 1'b0; in2 = 1'b0; rst = 1'b0; in5 = 1'b0;
    #2000 rst = 1'b1;
    #2000 $finish();//still got problems. don't use
  end // initial begin
endmodule // vending_tb
