module debouncer(
input    i_clk,
input    i_button,
output   o_pulse
);

reg [21:0] counter;



always @(posedge i_clk)
begin
    if(i_button)
	     counter <= counter +1'b1;
end


assign o_pulse = (counter ==100) ? 1'b1 : 1'b0;



endmodule
