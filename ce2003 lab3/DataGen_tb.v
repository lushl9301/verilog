`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   09:13:16 10/10/2013
// Design Name:   DataGen
// Module Name:   E:/lab3/DataGen_tb.v
// Project Name:  lab3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: DataGen
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module DataGen_tb;
  // Inputs
  reg i_clk;
  reg i_rst;
  reg i_buffon_up;
  reg i_buffon_down;
  reg i_buffon_left;
  reg i_buffon_right;
  reg [5:0] i_color;
  // Outputs
  wire [8:0] o_x;
  wire [7:0] o_y;
  wire [5:0] o_data;
  wire       o_done;
  // Instantiate the Unit Under Test (UUT)
  DataGen uut (
               .i_clk(i_clk), 
               .i_rst(i_rst), 
               .i_buffon_up(i_buffon_up), 
               .i_buffon_down(i_buffon_down), 
               .i_buffon_left(i_buffon_left), 
               .i_buffon_right(i_buffon_right), 
               .i_color(i_color), 
               .o_x(o_x), 
               .o_y(o_y), 
               .o_data(o_data), 
               .o_done(o_done)
               );
  
  always #2 i_clk = ~i_clk;
  initial begin
    // Initialize Inputs
    i_clk = 0;
    i_rst = 1;
    i_buffon_up = 0;
    i_buffon_down = 0;
    i_buffon_left = 0;
    i_buffon_right = 0;
    i_color = 0;
    #15 i_rst = 0;
    
    // Wait 100 ns for global reset to finish
    #3000;
    
    // Add stimulus here
    $finish;
  end
endmodule
