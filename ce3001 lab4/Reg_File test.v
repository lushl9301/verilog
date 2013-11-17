`include "define.v"

module Reg_File(
                input [`RSIZE - 1:0]      RAddr1, RAddr2, WAddr,
                input [`DSIZE - 1:0]      WData,
                input                     Wen, Clock, Reset,
                output [`DSIZE -1 :0]     RData1, RData2
                );
  reg [`DSIZE - 1:0]                      regFile [0:15];
  integer                                 i;
  
  /*
  always @(!Reset) begin
    for (i = 0; i < 8; i = i + 1) begin
      regFile[i] <= 16'b0;
    end
  end
  
  always @(posedge Clock) begin
    if (Reset) begin
      if (Wen) regFile[WAddr] <= WData;
      regFile[0] = 0;    
      RData1 = regFile[RAddr1];
      RData2 = regFile[RAddr2];
    end
  end
*/
  always@(posedge Clock) begin
    if(!Reset) begin
      regFile[0]  <= 0;
      regFile[1]  <= 0;
      regFile[2]  <= 0;
      regFile[3]  <= 0;
      regFile[4]  <= 0;
      regFile[5]  <= 0;
      regFile[6]  <= 0;
      regFile[7]  <= 0;
      regFile[8]  <= 0;
      regFile[9]  <= 0;
      regFile[10]  <= 0;
      regFile[11]  <= 0;
      regFile[12]  <= 0;
      regFile[13]  <= 0;
      regFile[14]  <= 0;
      regFile[15]  <= 0;
    end else begin 
        regFile[WAddr] <= ((Wen == 1) && (WAddr != 0)) ? WData : regFile[WAddr];
    end // else: !if(!Reset)
  end

  // bypass writing
  assign RData1 = regFile[RAddr1];
  assign RData2 = regFile[RAddr2];
  //assign RData1 = ((WAddr == RAddr1) && (WAddr != 0) && (WAddr != 15)) ? WData : regFile[RAddr1];
  //assign RData2 = ((WAddr == RAddr2) && (WAddr != 0) && (WAddr != 15)) ? WData : regFile[RAddr2];
  //assign RData1 = ((WAddr != 0) && (WAddr != 15)) ? WData : regFile[RAddr1];
  //assign RData2 = ((WAddr != 0) && (WAddr != 15)) ? WData : regFile[RAddr2];
  //R0 is constant 0
  //R15 is PC|Address register
endmodule // Reg_File

