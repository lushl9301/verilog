module eightBitCounter(
    input clk,
    input cnten,
	 input rst,
    output cnt
    );
	
reg [7:0] cnt;
always @(posedge clk)
	begin
		if (!rst)
			cnt <= 0;
		else if (cnten)
			cnt <= cnt + 1;
	end;

endmodule
