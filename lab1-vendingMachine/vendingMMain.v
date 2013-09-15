`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:35:50 01/25/2013 
// Design Name: 
// Module Name:    Lab1_Part2 
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
module Lab1_Part2(
    input in1,
    input in2,
    input in5,
    input clk,
    input rst,
    input cancel,
    output reg vend,
    output reg out1,
    output reg out2,
    output reg out22
    );
	 
	 wire din1, din2, dc;
	 debounce d1(.btn(in1), .outedge(din1));
	 debounce d2(.btn(in2), .outedge(din2));
	 debounce dcancel(.btn(cancel), .outedge(dc));

	 reg [3:0] st;
	 reg [3:0] nst;
	 parameter st0=4'd0, st1=4'd1, st2=4'd2, st3=4'd3, st4=4'd4,
				vend0=4'd5, vend1=4'd6, vend2=4'd7, vend3=4'd8, vend4=4'd9,
				ref1=4'd10, ref2=4'd11, ref3=4'd12, ref4=4'd13;
	 
	 always @(posedge clk)
		if (!rst)
			st <= st0;
		else
			st <= nst;
	
	always @*
		begin
			vend = 0;
			out1 = 0;
			out2 = 0;
			out22 = 0;
			case (st)
				st0:
					begin
						if (din1) nst = st1;
						if (din2) nst = st2;
					end
				st1:
					begin
						if (din1) nst = st1;
						if (din2) nst = st2;
						if (dc) nst = ref1;
					end
				st2:
					begin
						if (din1) nst = st3;
						if (din2) nst = st4;
						if (dc) nst = ref2;
					end
				st3:
					begin
						if (din1) nst = st4;
						if (din2) nst = vend0;
						if (dc) nst = ref3;
					end
				st4:
					begin
						if (din1) nst = vend0;
						if (din2) nst = vend1;
						if (dc) nst = ref4;
					end
				vend0:
						vend = 1'b1;
				vend1:
					begin
						vend = 1'b1;
						out1 = 1'b1;
					end 
				vend2:
					begin 
						vend = 1'b1;
						out2 = 1'b1;
					end
				vend3:
					begin
						vend = 1'b1;
						out1 = 1'b1;
						out2 = 1'b1;
					end 
				vend4:
					begin 
						vend = 1'b1;
						out2 = 1'b1;
						out22 = 1'b1;
					end 
				ref1:
					out1 = 1'b1;
				ref2:
					out2 = 1'b1;
				ref3:
					begin 
						out1 = 1'b1;
						out2 = 1'b1;
					end
				ref4:
					begin 
						out2 = 1'b1;
						out22 = 1'b1;
					end
			endcase
		end
endmodule
