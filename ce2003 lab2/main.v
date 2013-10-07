`timescale 1ns / 1ps

module main(
            input        clk,
            input        rst,
            input        write_en,
            input        show_reg,
            input        reg_data,
            input [7:0]  d_in,
            output [7:0] d_out
            );
  reg [7:0]              d_reg;
  reg [7:0]              ramdata [0:63];
  wire [5:0]             addr= d_in[5:0];
  wire                   wen, clk_out, rdata;
  debounce d1(.btn(reg_data), .clk(clk_out), .outedge(rdata));
  debounce d2(.btn(write_en), .clk(clk_out), .outedge(wen));
  clkgen c1(.clk_in(clk), .clk_out(clk_out));
  always @(posedge clk_out)
    begin
      if (!rst) begin
        d_reg <= 8'b0;
      end else if (rdata) begin
        d_reg <= d_in;
      end
      if (wen) begin
        ramdata[addr] <= d_reg;
      end
    end
  assign d_out = show_reg ? d_reg : ramdata[addr];
endmodule
