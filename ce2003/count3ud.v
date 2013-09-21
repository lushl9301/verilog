module count3ud(input clk, rst, dn,
                output reg [2:0] count);
   always @(posedge clk)
     begin
	      if (rst)
          count <= 3'd0;
        else if (dn)
          count <= count - 1'b1;
        else count <= count + 1'b1;
     end
endmodule // count3ud