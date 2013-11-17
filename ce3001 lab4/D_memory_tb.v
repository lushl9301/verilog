// This file is the testbench for D_memory.v
// Liwei Yang, 2013-10-27

`include "D_memory.v"
module D_memory_tb_file_io;
reg clk;
reg rst;
reg write_en;
reg [`ISIZE-1:0] address;
reg [`DSIZE-1:0] data_in;
wire [`DSIZE-1:0] data_out;

D_memory D_memory_inst (
  .clk(clk),
  .rst(rst),
  .write_en(write_en),
  .address(address),
  .data_in(data_in),
  .data_out(data_out)
);

// generate the clk
always #5 clk = ~clk;

initial
  begin
    clk = 0;
    rst = 0;
    write_en = 1;
#10 rst = 1;
#10 rst = 0;

#8
    write_en = 0;
    address = 1;
    data_in = 1;
#10 address = 2;
    data_in = 2;
#10 address = 3;
    data_in = 3;

#100 $stop;
  end

endmodule // end of testbench module
