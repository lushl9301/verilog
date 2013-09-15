module debounce(
    input btn,
    input clk,
    output outedge
    );

reg btn_d1, btn_d2;
reg [11:0] count = 12'd0;

// synchronisation chain
always @(posedge clk)
begin
	btn_d1 <= btn;
	btn_d2 <= btn_d1;
end

always @(posedge clk)
begin
	// count up to 2047 when button pressed
    if (btn_d2 & (count[11]==1'b0))
		count <= count + 1'b1;
	// reset count when button released
    else if (~btn_d2)
		count <= 10'd0;
end

// output single cycle pulse when count is 1023
assign outedge = (count == 12'd1023);

endmodule
