`include "define.v"

module CPU(clk, Rst);
  
  input clk, Rst;
  /******************************************
   *
   *Buffer value and usage
   *
   *+==+=============+======+
   *+No+ signal name + Width+
   *+==+===Fetch=====+======+
   *|  |             |      |
   *+==+===Decode====+======+
   *|0 | Instruction |    16|
   *|1 | CurrPC      |    16|
   *|--+-------------+------+
   *|2 | ALUOp       |     3|
   *|3 | Signal      |(15:0)|
   *|  | MemWrite    |  (16)|
   *|  | RFWriteEn   |  (17)|
   *|4 | Flag_En     |     1|
   *+--+-------------+------+
   *|6 | Sign_Ext8   |    16|
   *|7 | Sign_Ext12  |    16|
   *|12| Zero_Ext4   |    16|
   *+==+==Execute====+======+
   *|4 | RData1      |    16|
   *|5 | RData2      |    16|
   *|8 | MuxOut[5]   |    16|
   *+==+=Mem Access==+======+
   *|6 | LHBOut      |    16|
   *|9 | FLAG        |     3|
   *|10| ALUOut      |    16|
   *|11| MEMOut      |    16|
   *+==+==Write Back=+======+
   *
   ******************************************/
  
  integer i;
  reg [15:0] ID_Buff [0:12];
  reg [17:0] ID_Buff3;
  reg [15:0] EX_Buff [0:12];
  reg [17:0] EX_Buff3;
  reg [15:0] MEM_Buff [0:12];
  reg [17:0] MEM_Buff3;
  reg [15:0] storeInstr_Buff;
  reg        Flag_En_Buff;
  
  wire [15:0] IF_Buff_0_wire;
  wire [15:0] IF_Buff_1_wire;
  wire [2:0]  IF_Buff_2_wire;
  wire [17:0] IF_Buff_3_wire;
  
  wire [15:0] ID_Buff_0_wire = ID_Buff[0];
  wire [15:0] ID_Buff_1_wire = ID_Buff[1];
  wire [15:0] ID_Buff_2_wire = ID_Buff[2];
  //########################################
  wire [17:0] ID_Buff_3_wire = ID_Buff3;
  //########################################
  wire [15:0] ID_Buff_4_wire;
  wire [15:0] ID_Buff_5_wire;
  wire [15:0] ID_Buff_12_wire = ID_Buff[12];

  wire [15:0] EX_Buff_0_wire = EX_Buff[0];
  wire [15:0] EX_Buff_1_wire = EX_Buff[1];
  //########################################
  wire [17:0] EX_Buff_3_wire = EX_Buff3;
  //########################################
  wire [15:0] EX_Buff_8_wire = EX_Buff[8];
  wire [15:0] EX_Buff_9_wire;
  wire [15:0] EX_Buff_10_wire;

  wire [15:0] MEM_Buff_0_wire = MEM_Buff[0];
  //########################################
  wire [17:0] MEM_Buff_3_wire = MEM_Buff3;
  //########################################
  wire [15:0] MEM_Buff_6_wire = MEM_Buff[6];
  wire [15:0] MEM_Buff_11_wire;
  
  wire [15:0] instr_wire;
  wire [15:0] instr2_wire;
  wire [15:0] Next_PC_wire;
  wire PC_En_wire;
  wire instr_sel_wire;
  wire [`ISIZE-1:0] storeInstr, toStoreInstr, outInstr;
  wire [`ISIZE-1:0] storeInstr_Buff_wire = storeInstr_Buff;
  
  wire Flag_En_wire;
  wire Flag_En_Buff_wire = Flag_En_Buff;
  
  wire [15:0] MuxOut [0:15];
  wire [15:0] AddOut;
  wire [15:0] LHBOut;

  //====================================//
  //*********Instruction Fectch*********//
  //====================================//


  //0 choose from Ex->Pc or Mux_0 
  assign MuxOut[9] = IF_Buff_3_wire[9] ? EX_Buff_1_wire : MuxOut[0];
  //if jump then flush stored Instruction
  assign toStoreInstr = ID_Buff_3_wire[0] ? 16'h7000 : storeInstr ;
  //1 choose from Mux_1 or NextPc
  assign MuxOut[0] = ID_Buff_3_wire[0] ? MuxOut[1] : IF_Buff_1_wire;
  //0 PC enable
  assign IF_Buff_1_wire = PC_En_wire? Next_PC_wire: Next_PC_wire-1;
  PC A1(.Clk(clk),
        .Rst(Rst),
        .CurrPC(MuxOut[9]),
        .NextPC(Next_PC_wire));

  //0
  Pre_decoder B1(.Instr(instr_wire),//this instr
                 .Instr2(instr2_wire),//next instr
                 .LastInstr(ID_Buff_0_wire),
                 .Last3Instr(MEM_Buff_0_wire),//add last is Exec
                 .PC_En(PC_En_wire), 
                 .instr_sel(instr_sel_wire),
                 .outInstr(outInstr),
                 .storeInstr(storeInstr));
  //1 if PC is stopped. Add NOP -> 7000
  assign IF_Buff_0_wire = instr_sel_wire? 16'h7000: outInstr;
  //0 -> 1
  I_memory A0(.address(MuxOut[9]),
              .storeInstr(toStoreInstr),
              .data_out(instr_wire),
              .nextData_out(instr2_wire),
              .clk(clk),
              .rst(Rst));


  //====================================//
  //*********Instruction Decode*********//
  //====================================//

  control A2(.OpCode(IF_Buff_0_wire[15:12]),
             .Cond(IF_Buff_0_wire[10:8]),
             .Flag(EX_Buff_9_wire[2:0]), 
             .LastInstr(ID_Buff_0_wire),
             .Last2Instr(EX_Buff_0_wire),
             //.Last3Instr(MEM_Buff_0_wire),
             .AddrRd(IF_Buff_0_wire[11:8]),
             .AddrRs(IF_Buff_0_wire[7:4]),
             .AddrRt(IF_Buff_0_wire[3:0]),
             .ALUOp(IF_Buff_2_wire[2:0]),
             .WriteEn(IF_Buff_3_wire[17]),
             .MemWrite(IF_Buff_3_wire[16]),
             .Signal(IF_Buff_3_wire[15:0]),
             .FlagEn(Flag_En_wire));

  //select Rd or Rt to be RData2
  assign MuxOut[8][3:0] = IF_Buff_3_wire[8] ? IF_Buff_0_wire[11:8] : IF_Buff_0_wire[3:0];

  //select R15 or Rd to be WAdrr
  assign MuxOut[3][3:0] = MEM_Buff_3_wire[3] ? 16'd15 : MEM_Buff_0_wire[11:8];

  //selct EX_out or MEM_out to be WData
  assign MuxOut[7] = MEM_Buff_3_wire[7] ? MEM_Buff_11_wire : MEM_Buff_6_wire;
  Reg_File A3(.RAddr1(IF_Buff_0_wire[7:4]),
              .RAddr2(MuxOut[8][3:0]),
              .WAddr(MuxOut[3][3:0]),
              .WData(MuxOut[7]),
              .Wen(MEM_Buff_3_wire[17]),
              .Clock(clk),
              .Reset(Rst),
              .RData1(ID_Buff_4_wire),
              .RData2(ID_Buff_5_wire));
  
  //Sign Extend & Zero Extend
  always@(posedge clk) begin
    ID_Buff[12] <= {12'b0, IF_Buff_0_wire[3:0]};
    ID_Buff[6] <= {{8{IF_Buff_0_wire[7]}}, IF_Buff_0_wire[7:0]};
    ID_Buff[7] <= {{4{IF_Buff_0_wire[11]}}, IF_Buff_0_wire[11:0]};
  end

  //PC Jump result
  assign AddOut = ID_Buff_1_wire + MuxOut[2];
  assign MuxOut[2] = ID_Buff_3_wire[2] ? ID_Buff[7] : ID_Buff[6];

  assign MuxOut[1] = ID_Buff_3_wire[1] ? MuxOut[13] : AddOut;//graph is wrong

  //============================//
  //**********Execute***********//
  //============================//
  //pass flagEn
  always @(posedge clk) begin
    Flag_En_Buff <= Flag_En_wire;    
  end
  assign MuxOut[4] = ID_Buff_3_wire[4] ? MuxOut[12] : ID_Buff[6];
  assign MuxOut[5] = ID_Buff_3_wire[5] ? MuxOut[13] : ID_Buff[6];
  assign MuxOut[11] = ID_Buff_3_wire[11] ? ID_Buff[12] : MuxOut[5];
  alu A4(.A(MuxOut[4]),
         .B(MuxOut[11]),
         .op(ID_Buff_2_wire[2:0]),
         .lastFlag(EX_Buff_9_wire[2:0]), 
         .FlagEn(Flag_En_Buff_wire), //use the output of Buffer
         .imm(ID_Buff_0_wire[3:0]),
         .clk(clk),
         .out(EX_Buff_10_wire),
         .flag(EX_Buff_9_wire[2:0]));

  assign LHBOut = {ID_Buff[6][7:0], MuxOut[13][7:0]};


  //============================//
  //**********Execute***********//
  //============================//

  /**********Memory Access************/
  D_memory A5(.address(EX_Buff_10_wire),
              .data_in(EX_Buff_8_wire),
              .data_out(MEM_Buff_11_wire), 
              .clk(clk), 
              .rst(Rst),
              .write_en(EX_Buff_3_wire[16]));

  assign MuxOut[6] = EX_Buff_3_wire[6] ? EX_Buff[1] : MuxOut[10];   
  assign MuxOut[10] = EX_Buff_3_wire[10] ? EX_Buff[6] : EX_Buff_10_wire;//EX_Buff[6] is LHBOut

  
  //============================//
  //********forwarding**********//
  //============================//
  //from ALU_out to ALU_in
  //assign MuxOut[12] = ID_Buff_3_wire[12] ? EX_Buff_10_wire : MuxOut[14];
  //assign MuxOut[13] = ID_Buff_3_wire[13] ? EX_Buff_10_wire : MuxOut[15];
  assign MuxOut[12] = ID_Buff_3_wire[12] ? MuxOut[6] : MuxOut[14];//select PC+1/ALUOut/SignExt
  assign MuxOut[13] = ID_Buff_3_wire[13] ? MuxOut[6] : MuxOut[15];//select PC+1/ALUOut/SignExt
  
  //from MEM_out || ALU_out to ALU_in
  assign MuxOut[14] = ID_Buff_3_wire[14] ? MuxOut[7] : ID_Buff_4_wire;
  assign MuxOut[15] = ID_Buff_3_wire[15] ? MuxOut[7] : ID_Buff_5_wire;
  
  //Implement LHB or logic
  
  always @(posedge clk) begin
    if (!Rst) begin
      ID_Buff3 <= 19'd0;
      EX_Buff3 <= 19'd0;
      MEM_Buff3 <= 19'd0;
      Flag_En_Buff <= 1'b0;
      storeInstr_Buff <= 16'b0;
      for (i = 0; i <= 12; i = i+1) begin
        ID_Buff[i] <= 16'd0;
        EX_Buff[i] <= 16'd0;
        MEM_Buff[i] <= 16'd0;
      end
    end else begin
      //#########################
      //### IF -> ID
      //#########################
      storeInstr_Buff <= storeInstr;

      ID_Buff[0] <= IF_Buff_0_wire;
      ID_Buff[1] <= IF_Buff_1_wire;
      ID_Buff[2] <= IF_Buff_2_wire;
      
      ID_Buff3 <= IF_Buff_3_wire;

      //#########################
      //### ID -> EX
      //#########################
      EX_Buff[0] <= ID_Buff_0_wire;
      EX_Buff[1] <= ID_Buff_1_wire;
      EX_Buff[2] <= ID_Buff_2_wire;
      EX_Buff[4] <= ID_Buff_4_wire;
      EX_Buff[5] <= ID_Buff_5_wire;
      EX_Buff[6] <= LHBOut;
      EX_Buff[7] <= ID_Buff[7];
      EX_Buff[8] <= MuxOut[5];

      EX_Buff3 <= ID_Buff_3_wire;
      //#########################
      //### EX -> MEM
      //#########################
      
      //for (i = 0; i <= 8; i = i+1)
      //  MEM_Buff[i] <=  EX_Buff[i];
      MEM_Buff[0] <= EX_Buff_0_wire;
      MEM_Buff[6] <= MuxOut[6];
      MEM_Buff[9] <= EX_Buff_9_wire;
      MEM_Buff[10] <= EX_Buff_10_wire;

      MEM_Buff3 <= EX_Buff_3_wire;
    end // else: !if(!Rst)
  end // always@ (posedge clk)

endmodule // CPU
