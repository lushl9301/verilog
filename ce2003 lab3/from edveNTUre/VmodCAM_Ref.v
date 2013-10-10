module VmodCAM_Ref #(
	   C3_NUM_DQ_PINS = 16, 
		C3_MEM_ADDR_WIDTH = 13, 
		C3_MEM_BANKADDR_WIDTH = 3
	) (	
		output       TMDS_TX_2_P,
		output       TMDS_TX_2_N, 
		output       TMDS_TX_1_P, 
		output       TMDS_TX_1_N,
		output       TMDS_TX_0_P, 
		output       TMDS_TX_0_N, 
		output       TMDS_TX_CLK_P, 
		output       TMDS_TX_CLK_N, 
		inout        TMDS_TX_SCL, 
		inout        TMDS_TX_SDA, 
		output [1:0] o_led,
		input        i_clk,
		input        i_reset,
		input  [5:0] i_color,
		input        i_left_b,
		input        i_right_b,
		input        i_up_b,
		input        i_down_b
);

wire PClk, PClkX2, SerClk, SerStb;
wire VtcHs, VtcVs, VtcVde, VtcRst;
wire CamClk, CamClk_180, CamAPClk, CamADV, CamAVddEn;
wire [15:0] CamAD;
(* S = "TRUE" *)
wire dummy_t; 
wire int_CAMA_Pi_clk; 
wire int_CAMA_FV_I;
wire int_CAMA_LV_I;
wire [7:0] int_CAMA_D_I;
wire ddr2clk_2x, ddr2clk_2x_180, mcb_drp_clk, pll_ce_0, pll_ce_90, pll_lock, async_rst;
wire FbRdy, FbRdEn, FbRdRst, FbRdClk;
wire [15:0] FbRdData;
wire FbWrARst, FbWrBRst, int_FVA;
wire [15:0] FiltData;
integer VtcHCnt, VtcVCnt;
wire [8:0]  w_x_coordinate;
wire [7:0]  w_y_coordinate;
wire [5:0]  w_video_data;
wire w_done;

assign o_led[0] = FbRdy;
assign o_led[1] = i_reset;

/////////////////////////////////////////////////////////////////////////////////
// System Control Unit
// This component provides a System Clock, a Synchronous Reset and other signals
// needed for the 40:4 serialization:
//	- Serialization clock (5x System Clock)
// - Serialization strobe
// - 2x Pixel Clock
////////////////////////////////////////////////////////////////////////////////
	SysCon Inst_SysCon(
		.CLK_I(i_clk),
		.CLK_O(),
		.RSTN_I(i_reset),
		.SW_I(),
		.SW_O(),
		.MSEL_O(), //mode selector synchronized with PClk
		.CAMCLK_O(CamClk),
		.CAMCLK_180_O(CamClk_180),
		.PCLK_O(PClk),
		.PCLK_X2_O(PClkX2),
		.PCLK_X10_O(SerClk),
		.SERDESSTROBE_O(SerStb),
		
		.DDR2CLK_2X_O(DDR2Clk_2x),
		.DDR2CLK_2X_180_O(DDR2Clk_2x_180),
		.MCB_DRP_CLK_O(mcb_drp_clk),
		.PLL_CE_0_O(pll_ce_0),
		.PLL_CE_90_O(pll_ce_90),
		.PLL_LOCK(pll_lock),
		.ASYNC_RST(async_rst)
	);

//////////////////////////////////////////////////////////////////////////////////
// Frame Buffer
//////////////////////////////////////////////////////////////////////////////////

FBCtl Inst_FBCtl(
	.o_rdy(FbRdy),
	.i_enc( FbRdEn),
	.i_vsync(VtcVs),
	.i_rst( FbRdRst),
	.o_data( FbRdData),
	.i_clk ( FbRdClk),
   .i_x(w_x_coordinate),
   .i_y(w_y_coordinate),
   .i_data(w_video_data),
	.i_done(w_done)
);


/////////////////////////////////////////////////////////////////////////////////
// Video Data Generator
/////////////////////////////////////////////////////////////////////////////////

DataGen Inst_DataGen(
    .i_clk(FbRdClk),
    .i_rst(FbRdRst),
    .i_color(i_color),
	 .i_buffon_up(up_pulse),
	 .i_buffon_down(down_pulse),
	 .i_buffon_left(left_pulse),
	 .i_buffon_right(right_pulse),
    .o_x(w_x_coordinate),
    .o_y(w_y_coordinate),
    .o_data(w_video_data),
	 .o_done(w_done)
);

//Debouncer for direction control switches.
debouncer d1(
 .i_clk(FbRdClk),
 .i_button(i_left_b),
 .o_pulse(left_pulse)
);

debouncer d2(
 .i_clk(FbRdClk),
 .i_button(i_right_b),
 .o_pulse(right_pulse)
);

debouncer d3(
 .i_clk(FbRdClk),
 .i_button(i_up_b),
 .o_pulse(up_pulse)
);

debouncer d4(
 .i_clk(FbRdClk),
 .i_button(i_down_b),
 .o_pulse(down_pulse)
);


assign FbRdEn = VtcVde;
assign FbRdRst = ~i_reset;
assign FbRdClk = PClk;
	
//////////////////////////////////////////////////////////////////////////////////
// Video Timing Controller
// Generates horizontal and vertical sync and video data enable signals.
/////////////////////////////////////////////////////////////////////////////////
	VideoTimingCtl Inst_VideoTimingCtl(
		.PCLK_I(PClk),
		.RST_I(VtcRst),//
		.VDE_O(VtcVde),
		.HS_O(VtcHs),
		.VS_O(VtcVs),
		.HCNT_O(VtcHCnt),
		.VCNT_O(VtcVCnt)
	);
	
assign VtcRst = ~FbRdy;

//////////////////////////////////////////////////////////////////////////////////
// DVI Transmitter
/////////////////////////////////////////////////////////////////////////////////
DVITransmitter Inst_DVITransmitter(
	.RED_I ( {FbRdData[15:11],3'b000}),
	.GREEN_I ({FbRdData[10:5],2'b00}),
	.BLUE_I ({FbRdData[4:0],3'b000}),
	.HS_I ( VtcHs),
	.VS_I ( VtcVs),
	.VDE_I ( VtcVde),
	.PCLK_I ( PClk),
	.PCLK_X2_I ( PClkX2),
	.SERCLK_I ( SerClk),
	.SERSTB_I ( SerStb),
	.TMDS_TX_2_P ( TMDS_TX_2_P),
	.TMDS_TX_2_N ( TMDS_TX_2_N),
	.TMDS_TX_1_P ( TMDS_TX_1_P),
	.TMDS_TX_1_N ( TMDS_TX_1_N),
	.TMDS_TX_0_P ( TMDS_TX_0_P),
	.TMDS_TX_0_N ( TMDS_TX_0_N),
	.TMDS_TX_CLK_P ( TMDS_TX_CLK_P),
	.TMDS_TX_CLK_N ( TMDS_TX_CLK_N)
);

endmodule
