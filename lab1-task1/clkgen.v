// divides clock by 2048
module clkgen( input    clk_in,
               output   clk_out );

reg [10:0] counter = 11'd0;

always @(posedge clk_in)
begin
    counter <= counter + 1'b1;
end

assign clk_out = counter[10];

endmodule
