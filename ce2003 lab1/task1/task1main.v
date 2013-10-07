`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    
// Design Name: 
// Module Name:    Lab1 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Lab1(
    input btn1,
    input btn2,
    input clk,
    input rst,
    output reg [7:0] cnt
    );
	
	wire debout, edgout, clkout;

	assign en = debout|edgout;
	
	always @ (posedge clk)
	begin
		if (!rst)
			cnt <= 8'd0;
		else if (en)
			cnt <= cnt + 8'd1;
	end

	clkgen clkgen(.clk_in(clk), .clk_out(clkout));
	debounce deb(.btn(btn1), .clk(clkout), .outedge(debout));
	edgedetect edg(.btn(btn2), .clk(clkout), .outedge(edgout));


endmodule