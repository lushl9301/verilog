`include "define.v"

module Reg_File(input [`RSIZE - 1:0]      RAddr1, RAddr2, WAddr,
                input [`DSIZE - 1:0]      WData,
                input                     Wen, Clock, Reset,
                output reg [`DSIZE -1 :0] RData1, RData2
                );
  reg [`DSIZE - 1:0]                      regFile [0:15]; 
  
  always@(posedge Clock) begin
    if (!Reset) begin
      regFile[0] <= 0;
      regFile[1] <= 0;
      regFile[2] <= 0;
      regFile[3] <= 0;
      regFile[4] <= 0;
      regFile[5] <= 0;
      regFile[6] <= 0;
      regFile[7] <= 0;
      regFile[8] <= 0;
      regFile[9] <= 0;
      regFile[10] <= 0;
      regFile[11] <= 0;
      regFile[12] <= 0;
      regFile[13] <= 0;
      regFile[14] <= 0;
      regFile[15] <= 0;
    end else begin
      regFile[WAddr] <= ((Wen == 1'b1) && (WAddr != 1'b0)) ? WData : regFile[WAddr];
      if ((WAddr != 0) && (WAddr == RAddr1))  //by pass
        RData1 <= WData;
      else
        RData1 <= regFile[RAddr1];
      if ((WAddr != 0) && (WAddr == RAddr2)) //by pass
        RData2 <= WData;
      else 
        RData2 <= regFile[RAddr2];
    end // else: !if(!Reset)
  end // always@ (posedge Clock)
  
  /*
   assign RData1 = ((WAddr == RAddr1) && (WAddr != 0)) ? WData : regFile[RAddr1];
   assign RData2 = ((WAddr == RAddr2) && (WAddr != 0)) ? WData : regFile[RAddr2];
   */
  //R0 is constant 0
  //R15 is PC|Address register
  //if we want to add reg outside of RF
  //we can change back

endmodule // Reg_File

    
