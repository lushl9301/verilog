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
  always @(posedge clk)
    begin
      if (!rst) begin
        d_reg <= 8'b0;
      end else if (reg_data) begin
        d_reg <= d_in;
      end
      if (write_en) begin
        ramdata[addr] <= d_reg;
      end
    end
  assign d_out = show_reg ? d_reg : ramdata[addr];
endmodule
