// This file is the testbench for I_memory.v
// Liwei Yang, 2013-10-27

`include "I_memory.v"
module I_memory_tb_file_io;
reg clk;
reg rst;
reg [`MEM_SPACE-1:0] address;
wire [`ISIZE-1:0] data_out;

I_memory I_memory_inst (
  .clk(clk),
  .rst(rst),
  .address(address),
  .data_out(data_out)
);

// generate the clk
always #5 clk = ~clk;

initial
  begin
    clk = 0;
    rst = 0;
#10 rst = 1;
#10 rst = 0;
#8  address = 0;
#10 address = 1;
#10 address = 2;

#100 $stop;
  end

endmodule // end of testbench module
