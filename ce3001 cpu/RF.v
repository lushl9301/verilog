// Register File module
`include "define.v"
`timescale 1ns / 1ps

module Reg_File (
	input Clock,
	input Reset,
	input Wen,
	input [`RSIZE-1:0] RAddr1, 
	input [`RSIZE-1:0] RAddr2, 
	input [`RSIZE-1:0] WAddr, 
	input [`DSIZE-1:0] WData, 

	output [`DSIZE-1:0] RData1,
	output [`DSIZE-1:0] RData2
	);

	// register array definition ( 16 registers)
	reg [`DSIZE-1:0] RegFile[0:15];

	always@(posedge Clock)
		begin
			if(!Reset)
				begin
					RegFile[0]  <= 0;
					RegFile[1]  <= 0;
					RegFile[2]  <= 0;
					RegFile[3]  <= 0;
					RegFile[4]  <= 0;
					RegFile[5]  <= 0;
					RegFile[6]  <= 0;
					RegFile[7]  <= 0;
					RegFile[8]  <= 0;
					RegFile[9]  <= 0;
					RegFile[10]  <= 0;
					RegFile[11]  <= 0;
					RegFile[12]  <= 0;
					RegFile[13]  <= 0;
					RegFile[14]  <= 0;
					RegFile[15]  <= 0;
				end
			else
				RegFile[WAddr] <= ((Wen == 1) && (WAddr != 0)) ? WData : RegFile[WAddr];
		end
	
	// bypass writing
	// assign RData1 = RegFile[RAddr1];
	// assign RData2 = RegFile[RAddr2];
	assign RData1 = ((WAddr == RAddr1) && (WAddr != 0)) ? WData : RegFile[RAddr1];
	assign RData2 = ((WAddr == RAddr2) && (WAddr != 0)) ? WData : RegFile[RAddr2];

endmodule // End of Reg_File module


