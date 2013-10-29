`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    15:48:11 10/12/2012
// Design Name:
// Module Name:    pixsel
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
module pixsel(
    input clk,
    input rst,
    input [7:0] in_r,
    input [7:0] in_g,
    input [7:0] in_b,
    input [7:0] in_y,
    input [7:0] in_u,
    input [7:0] in_v,
	input [2:0] in_c,
    input in_skin,
    input [7:0] in_swt,
    output reg [7:0] out_r,
    output reg [7:0] out_g,
    output reg [7:0] out_b,
	output reg [2:0] out_ctrl
    );

//Saturation logic
wire [8:0] max_r = ((in_r + 64)<255) ? in_r + 64 : 255;
wire [8:0] min_r = ((in_r - 32)>0) ? in_r - 32 : 0;
wire [8:0] max_g = ((in_g + 64)<255) ? in_g + 64 : 255;
wire [8:0] min_g = ((in_g - 32)>0) ? in_g - 32 : 0;
wire [8:0] max_b = ((in_b + 64)<255) ? in_b + 64 : 255;
wire [8:0] min_b = ((in_b - 32)>0) ? in_b - 32 : 0;
// Add code for max_g, min_g, max_b, and min_b

//Output select logic
always @(posedge clk)
begin
    if(rst) begin
        out_r <= 8'd0;
        out_g <= 8'd0;
        out_b <= 8'd0;
        out_ctrl <= 3'd0;
    end else begin
    	case(in_swt)
         1 : begin
				out_r <= in_y; out_g <= in_y; out_b <= in_y;
    		end
			
			2 : begin
				out_r <= in_u; out_g <= in_u; out_b <= in_u;
    		end
			
			3 : begin
				out_r <= in_v; out_g <= in_v; out_b <= in_v;
    		end
			/*4 : begin
				if (skind) begin
				  out_r <= in_y; out_g <= in_y; out_b <= in_y;
    		   end else begin
				  out_r <= 1'b0; out_g <= 1'b0; out_b <= 1'b0;
    		   end
			end*/
			/*8 : begin
				if (skind) begin
				  out_r <= min_r; out_g <= max_g; out_b <= min_b;
    		   end else begin
				  out_r <= in_r; out_g <= in_g; out_b <= in_b;
    		   end
			end*/
			/*16 : begin
				if (skind) begin
				  out_r <= max_r; out_g <= min_g; out_b <= min_b;
    		   end else begin
				  out_r <= in_r; out_g <= in_g; out_b <= in_b;
    		   end
			end*/
			/*32 : begin
				if (skind) begin
				  out_r <= min_r; out_g <= min_g; out_b <= max_b;
    		   end else begin
				  out_r <= in_r; out_g <= in_g; out_b <= in_b;
    		   end
			end*/
    		default : begin
    			out_r <= in_r; out_g <= in_g; out_b <= in_b;
    		end
    	endcase
    	out_ctrl <= in_c;
    end
end

endmodule
