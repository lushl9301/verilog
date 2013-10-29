`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    09:41:41 10/12/2012
// Design Name:
// Module Name:    rgbyuv
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
module rgbyuv(
    input clk,
    input rst,
    input signed [17:0] i_red,
    input signed [17:0] i_grn,
    input signed [17:0] i_blu,
    output reg   [7:0]  o_y,
    output reg   [7:0]  o_u,
    output reg   [7:0]  o_v,
	output reg          skind
    );

reg signed [17:0] 	red_r, grn_r, blu_r;

reg signed [35:0] ry, gy, by, ru, gu, bu, rv, gv, bv;

reg [7:0]           p_y, p_u, p_v;

parameter signed [17:0]	RY_COEF = 'd66, GY_COEF = 'd129, BY_COEF = 'd25,
						RU_COEF = -'d38, GU_COEF = -'d74, BU_COEF = 'd112,
						RV_COEF = 'd112, GV_COEF = -'d94, BV_COEF = -'d18;


always @(posedge clk)
begin
    if(rst) begin
        red_r <= 18'd0;
        grn_r <= 18'd0;
        blu_r <= 18'd0;
        o_y <= 8'd0;
        o_u <= 8'd0;
        o_v <= 8'd0;
    end else begin
    	red_r <= i_red;
    	grn_r <= i_grn;
    	blu_r <= i_blu;

    //o_y <= ((RY_COEF * red_r + GY_COEF * grn_r + BY_COEF * blu_r) >>> 8) + 16;
    //o_u <= ((RU_COEF * red_r + GU_COEF * grn_r + BU_COEF * blu_r) >>> 8) + 128;
    //o_v <= ((RV_COEF * red_r + GV_COEF * grn_r + BV_COEF * blu_r) >>> 8) + 128;
        // INSERT CODE FOR o_u and o_v
        ry <= RY_COEF * red_r + GY_COEF * grn_r + BY_COEF * blu_r;
        ru <= RU_COEF * red_r + GU_COEF * grn_r + BU_COEF * blu_r;
		  rv <= RV_COEF * red_r + GV_COEF * grn_r + BV_COEF * blu_r;
        p_y <= (ry >>> 8) + 16;
        p_u <= (ru >>> 8) + 128;
        p_v <= (rv >>> 8) + 128;
        o_y <= p_y;
        o_u <= p_u;
        o_v <= p_v;
    end
end
// always @(posedge clk)
// begin
//     // ADD SKIN DETECTION CODE HERE
//   if (rst) begin
//     skind <= 1'b0;
//   end else 
//     if (73 <= p_u && p_u <= 122 and 132 <= p_v && p_v <= 173) begin
//       skind <= 1'b1;
//     else skind <= 1'b0;
// end
endmodule
