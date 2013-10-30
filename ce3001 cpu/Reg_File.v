module Reg_File(
                input [`RSIZE - 1:0]      RAddr1, RAddr2, WAddr;
                input [`DSIZE - 1:0]      WData;
                input                     Wen, Clock, Reset;
                output reg [`DSIZE -1 :0] RData1, RData2;
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
    end else begin 
        RegFile[WAddr] <= ((Wen == 1) && (WAddr != 0)) ? WData : RegFile[WAddr];
    end // else: !if(!Reset)
  end

  // bypass writing
  // assign RData1 = RegFile[RAddr1];
  // assign RData2 = RegFile[RAddr2];
  assign RData1 = ((WAddr == RAddr1) && (WAddr != 0) && WAddr != 15) ? WData : RegFile[RAddr1];
  assign RData2 = ((WAddr == RAddr2) && (WAddr != 0) && WAddr != 15) ? WData : RegFile[RAddr2];
  //R0 is constant 0
  //R15 is PC|Address register
endmodule // Reg_File

