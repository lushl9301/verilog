module edgedetect(  input clk, btn,
                    output outedge );


reg  btn_d1, btn_d2, btn_d3;

// synchronisation chain
always @(posedge clk)
begin
    btn_d1 <= btn;
    btn_d2 <= btn_d1;
    btn_d3 <= btn_d2;
end

// detect rising edge: signal is 1 and its delayed version is zero
assign outedge = btn_d2 & ~btn_d3;

endmodule
