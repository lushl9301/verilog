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
		input  [7:0] SW_I,
		//output [7:0] LED_O,
		input        CLK_I,
		input        RESET_I,
//////////////////////////////////////////////////////////////////////////////////
// Camera Board signals
//////////////////////////////////////////////////////////////////////////////////
		inout        CAMA_SDA, 
		inout        CAMA_SCL,
        (* S = "TRUE" *)		
		inout  [7:0] CAMA_D_I,
        (* S = "TRUE" *)		
		inout        CAMA_PCLK_I, 
		output       CAMA_MCLK_O,
		(* S = "TRUE" *)
		inout        CAMA_LV_I, 
		(* S = "TRUE" *)
		inout        CAMA_FV_I, 
		output       CAMA_RST_O, 
		output       CAMA_PWDN_O, 
		output       CAMX_VDDEN_O, //common power supply enable (can do power cycle)	
////////////////////////////////////////////////////////////////////////////////////
// DDR2 Interface
///////////////////////////////////////////////////////////////////////////////////
		inout  [C3_NUM_DQ_PINS-1 : 0] mcb3_dram_dq,
		output [C3_MEM_ADDR_WIDTH-1 : 0]mcb3_dram_a,
		output [C3_MEM_BANKADDR_WIDTH-1 : 0]mcb3_dram_ba,
		output       mcb3_dram_ras_n, 
		output       mcb3_dram_cas_n, 
		output       mcb3_dram_we_n,
		output       mcb3_dram_odt,
		output       mcb3_dram_cke,
		output       mcb3_dram_dm, 
		inout        mcb3_dram_udqs,   
		inout        mcb3_dram_udqs_n, 
		inout        mcb3_rzq,         
		inout        mcb3_zio,         
		output       mcb3_dram_udm,    
		inout        mcb3_dram_dqs,    
		inout        mcb3_dram_dqs_n,  
		output       mcb3_dram_ck,     
		output       mcb3_dram_ck_n  
);

wire PClk, PClkX2, SerClk, SerStb;
wire VtcHs, VtcVs, VtcVde, VtcRst;
wire CamClk, CamClk_180, CamAPClk, CamADV, CamAVddEn;
wire [15:0] CamAD;
(* S = "TRUE" *)
wire dummy_t; 
wire int_CAMA_PCLK_I; 
wire int_CAMA_FV_I;
wire int_CAMA_LV_I;
wire [7:0] int_CAMA_D_I;
wire ddr2clk_2x, ddr2clk_2x_180, mcb_drp_clk, pll_ce_0, pll_ce_90, pll_lock, async_rst;
wire FbRdy, FbRdEn, FbRdRst, FbRdClk;
wire [15:0] FbRdData;
wire FbWrARst, FbWrBRst, int_FVA;
wire       skind;
wire [7:0] luma;
wire [7:0] chroma_1;
wire [7:0] chroma_2;
wire [2:0] out_c;
wire [2:0] pix_sel_out_ctrl;
wire [7:0] out_r;
wire [7:0] out_g;
wire [7:0] out_b;
wire [7:0] pix_sel_out_r;
wire [7:0] pix_sel_out_g;
wire [7:0] pix_sel_out_b;

/////////////////////////////////////////////////////////////////////////////////
// System Control Unit
// This component provides a System Clock, a Synchronous Reset and other signals
// needed for the 40:4 serialization:
//	- Serialization clock (5x System Clock)
// - Serialization strobe
// - 2x Pixel Clock
////////////////////////////////////////////////////////////////////////////////
	SysCon Inst_SysCon(
		.CLK_I(CLK_I),
		.CLK_O(),
		.RSTN_I(RESET_I),
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
// Camera A Controller
/////////////////////////////////////////////////////////////////////////////////
	camctl Inst_camctlA(
	.D_O ( CamAD),
	.PCLK_O ( CamAPClk),
	.DV_O ( CamADV),
	.RST_I ( async_rst),
	.CLK ( CamClk),
	.CLK_180 ( CamClk_180),
	.SDA ( CAMA_SDA),
	.SCL ( CAMA_SCL),
	.D_I ( int_CAMA_D_I),
	.PCLK_I ( int_CAMA_PCLK_I),
	.MCLK_O ( CAMA_MCLK_O),
	.LV_I ( int_CAMA_LV_I),
	.FV_I ( int_CAMA_FV_I),
	.RST_O ( CAMA_RST_O),
	.PWDN_O ( CAMA_PWDN_O),
	.VDDEN_O ( CamAVddEn)
	);

	
assign CAMX_VDDEN_O = CamAVddEn;

//////////////////////////////////////////////////////////////////////////////////
// Frame Buffer
//////////////////////////////////////////////////////////////////////////////////
	FBCtl  #(
		.DEBUG_EN(0),
		.COLORDEPTH(16)
	)
	Inst_FBCtl(
		.RDY_O(FbRdy),
		.ENC ( FbRdEn),
		.RSTC_I ( FbRdRst),
		.DOC ( FbRdData),
		.CLKC ( FbRdClk),
		.RD_MODE (1'b0),
		
		.ENA ( CamADV),
		.RSTA_I ( FbWrARst),
		.DIA (CamAD),
		.CLKA ( CamAPClk),
		
		.ENB (1'b0),
		.RSTB_I	(1'b0),
		.DIB (16'h0000),
		.CLKB (1'b0),
		
		.ddr2clk_2x ( DDR2Clk_2x),
		.ddr2clk_2x_180 ( DDR2Clk_2x_180),
		.pll_ce_0 ( pll_ce_0),
		.pll_ce_90 ( pll_ce_90),
		.pll_lock ( pll_lock),
		.async_rst ( async_rst),
		.mcb_drp_clk ( mcb_drp_clk),
		.mcb3_dram_dq ( mcb3_dram_dq),
		.mcb3_dram_a ( mcb3_dram_a),
		.mcb3_dram_ba ( mcb3_dram_ba),
		.mcb3_dram_ras_n ( mcb3_dram_ras_n),
		.mcb3_dram_cas_n ( mcb3_dram_cas_n),
		.mcb3_dram_we_n ( mcb3_dram_we_n),
		.mcb3_dram_odt ( mcb3_dram_odt),
		.mcb3_dram_cke ( mcb3_dram_cke),
		.mcb3_dram_dm ( mcb3_dram_dm),
		.mcb3_dram_udqs ( mcb3_dram_udqs),
		.mcb3_dram_udqs_n ( mcb3_dram_udqs_n),
		.mcb3_rzq ( mcb3_rzq),
		.mcb3_zio ( mcb3_zio),
		.mcb3_dram_udm ( mcb3_dram_udm),
		.mcb3_dram_dqs ( mcb3_dram_dqs),
		.mcb3_dram_dqs_n ( mcb3_dram_dqs_n),
		.mcb3_dram_ck ( mcb3_dram_ck),
		.mcb3_dram_ck_n ( mcb3_dram_ck_n)
	);

assign FbRdEn = VtcVde;
assign FbRdRst = async_rst;
assign FbRdClk = PClk;
//Register FV signal to meet timing for FbWrXRst
	InputSync Inst_InputSync_FVA(
		.D_I(int_CAMA_FV_I),
		.D_O (int_FVA),
		.CLK_I (CamAPClk)
	);


assign FbWrARst = async_rst | ~int_FVA;


	
//////////////////////////////////////////////////////////////////////////////////
// Video Timing Controller
// Generates horizontal and vertical sync and video data enable signals.
/////////////////////////////////////////////////////////////////////////////////
	VideoTimingCtl Inst_VideoTimingCtl(
		.PCLK_I(PClk),
		.RST_I(VtcRst),
		.VDE_O(VtcVde),
		.HS_O(VtcHs),
		.VS_O(VtcVs),
		.HCNT_O(),
		.VCNT_O()
	);
	
assign VtcRst = async_rst | ~FbRdy;

rgbyuv rgb_yuv (
    .clk(PClk),
	.rst(async_rst),
    .i_red({10'd0,FbRdData[15:11],3'b000}),
    .i_grn({10'd0,FbRdData[10:5],2'b00}),
    .i_blu({10'd0,FbRdData[4:0],3'b000}),
    .o_y(luma),
    .o_u(chroma_1),
    .o_v(chroma_2),
    .skind(skind)
);


delay_line dg (
    .clk(PClk), 
	.rst(async_rst),
    .in_r({FbRdData[15:11],3'b000}), 
    .in_g({FbRdData[10:5],2'b00}), 
    .in_b({FbRdData[4:0],3'b000}), 
    .in_c({VtcVs,VtcHs,VtcVde}), 
    .out_r(out_r), 
    .out_g(out_g), 
    .out_b(out_b), 
    .out_c(out_c)
);


pixsel pix_sel (
    .clk(PClk), 
    .rst(async_rst), 
    .in_r(out_r), 
    .in_g(out_g), 
    .in_b(out_b), 
    .in_y(luma), 
    .in_u(chroma_1), 
    .in_v(chroma_2), 
    .in_c(out_c),
    .in_skin(skind), 
    .in_swt(SW_I), 
    .out_r(pix_sel_out_r), 
    .out_g(pix_sel_out_g), 
    .out_b(pix_sel_out_b), 
    .out_ctrl(pix_sel_out_ctrl)
);	 


//////////////////////////////////////////////////////////////////////////////////
// DVI Transmitter
/////////////////////////////////////////////////////////////////////////////////
DVITransmitter Inst_DVITransmitter(
	.RED_I (pix_sel_out_r),
	.GREEN_I (pix_sel_out_g),
	.BLUE_I (pix_sel_out_b),
	.HS_I ( pix_sel_out_ctrl[1]),
	.VS_I ( pix_sel_out_ctrl[2]),
	.VDE_I ( pix_sel_out_ctrl[0]),
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


//////////////////////////////////////////////////////////////////////////////////
// Workaround for IN_TERM bug AR# 	40818
/////////////////////////////////////////////////////////////////////////////////
   IOBUF  #(
      .DRIVE (12),
      .IOSTANDARD ("DEFAULT"),
      .SLEW ("SLOW")
	  )
   Inst_IOBUF_CAMA_PCLK (
      .O (int_CAMA_PCLK_I),
      .IO (CAMA_PCLK_I), 
      .I (1'b0),
      .T (dummy_t) 
   );
   
   IOBUF #(
      .DRIVE (12),
      .IOSTANDARD ("DEFAULT"),
      .SLEW ("SLOW")
	  )
   Inst_IOBUF_CAMA_FV(
      .O (int_CAMA_FV_I),
      .IO (CAMA_FV_I),
      .I (1'b0),
      .T (dummy_t)
   );	
   
	IOBUF #(
      .DRIVE (12),
      .IOSTANDARD ("DEFAULT"),
      .SLEW ("SLOW")
	  )
   Inst_IOBUF_CAMA_LV (
      .O ( int_CAMA_LV_I), 
      .IO ( CAMA_LV_I),
      .I (1'b0),
      .T (dummy_t)
   );	
   
   
genvar i;

generate
for (i=7;i>=0;i=i-1)
    begin:Gen_IOBUF_CAMA_D

    IOBUF #(
      .DRIVE (12),
      .IOSTANDARD ("DEFAULT"),
      .SLEW ("SLOW")
	  )
   Inst_IOBUF_CAMA_D (
      .O ( int_CAMA_D_I[i]), 
      .IO ( CAMA_D_I[i]),
      .I (1'b0),
      .T ( dummy_t)
   );
   end
endgenerate;

assign dummy_t = 1'b1;

endmodule
