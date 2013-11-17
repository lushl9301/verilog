`include "define.v"

module control(OpCode,
               Cond,
               Flag,
               LastInstr,
               Last2Instr,
               AddrRd,
               AddrRs,
               AddrRt,
               ALUOp,
               WriteEn,
               MemWrite,
               Signal,
               FlagEn);

  //declare input and output signal
  input [3:0]        OpCode;
  input [2:0]        Cond;
  input [2:0]        Flag;
  
  input [`ISIZE-1:0] LastInstr, Last2Instr;
  input [`RSIZE-1:0] AddrRd, AddrRs, AddrRt;
  
  output reg         MemWrite, WriteEn;
  output reg [2:0]   ALUOp;
  output reg [15:0]  Signal;
  output reg         FlagEn;

  wire [3:0]         EXECTest;
  wire               N,V,Z;
  wire               canForward1, canForward2;
  reg                FwALU2Rs, FwALU2Rt;
  reg                FwMEM2Rs, FwMEM2Rt;
  reg                BS;

  assign N = Flag[2];
  assign V = Flag[1];
  assign Z = Flag[0];
  assign EXECTest = Last2Instr[15:12];
  assign canForward1 = (LastInstr[15:12] <= `LLB && LastInstr[15:12] != `SW) ? 1 : 0;
  assign canForward2 = (Last2Instr[15:12] <= `LLB && Last2Instr[15:12] != `SW) ? 1 : 0;
  
  always @(*) begin
    
    
    case(Cond)
      
      3'b000:  BS = (Z == 1)? 1'b1:1'b0; //Equal
      3'b001:  BS = (Z == 0)? 1'b1:1'b0; //Not Equal
      3'b010:  BS = (Z == 0 && N == 0)? 1'b1:1'b0; // Greater Than
      3'b011:  BS = (N == 1)? 1'b1:1'b0; // Less Than      
      3'b100:  BS = (Z==1||(Z == 0 && N == 0))? 1'b1:1'b0; //Greater ot Equal        
      3'b101:  BS = (Z==1||N == 1)? 1'b1:1'b0; //Less or Equal
      3'b110:  BS = (V == 1)? 1'b1:1'b0;  //Overflow
      3'b111:  BS = 1'b1; // True
      default: BS = 1'b0; // False
      
    endcase // case (Cond)


    /*
     LastInstr can forward Data only and only if 
     ADD, SUB, AND, OR
     SLL, SRL, SRA, RL
     LW
     LHB, LLB
     ========= LastInstr[15:12] <= `LLB && LastInstr[15:12] != `SW
     JAL
     */

    
    /*
     ALU data forwarding detect. -> RData1
     LastInstr's Rd to this Instr's Rs
     JAL's R15      to this Instr's Rs
     */
    if ((OpCode <= `SW) && (canForward1 == 1'b1 && (LastInstr[11:8] == AddrRs) && (AddrRs != 0)
                            || (LastInstr[15:12] == `JAL) && (4'd15 == AddrRs))) begin
      FwALU2Rs = 1'b1;
    end else begin
      FwALU2Rs = 1'b0;
      //$display("Opcode = %b, LastInstr[11:8] = %h, Rs = %h, Rd = %h", OpCode, LastInstr[11:8], AddrRs, AddrRd);
    end
    
    /*
     ALU data forwarding detect. -> RData2
     
     LastInstr's Rd to this Instr's Rt     OpCode <= 4
     EXEC/JR(take Rd as RData2)            OpCode >= E
     SW take LastInstr's Rd as Rd          OpCode == 9
     LHB/LLB take LastInstr's Rd as Rd     OpCode == 10/OpCode == 11
     */
    if ((canForward1 == 1'b1)
        && ((OpCode <= 4'd4 && LastInstr[11:8] == AddrRt && AddrRt != 0)
            || ((OpCode >= `JR || OpCode >= `SW && OpCode <= `LLB) && (LastInstr[11:8] == AddrRd) && (AddrRd != 0)))) begin
      FwALU2Rt = 1'b1;
    end else begin
      FwALU2Rt = 1'b0;
    end
    if ((LastInstr[15:12] == `JAL)
      && ((OpCode <= 4'd4 && 4'd15 == AddrRt)
          || ((OpCode >= `JR || OpCode >= `SW && OpCode <= `LLB) && (4'd15 == AddrRd)))) begin
      FwALU2Rt = 1'b1;
    end
    
    /*
     MEM data forwarding detect.
     Last2Instr's Rd to this Instr's Rs
     JAL R15         to this Instr's Rs  
    */
    if ((OpCode < `SW) && ((canForward2 == 1'b1) && (Last2Instr[11:8] == AddrRs) && (AddrRs != 0)
                           || (Last2Instr[15:12] == `JAL) && (4'd15 == AddrRs))) begin
      FwMEM2Rs = 1'b1;
    end else begin
      FwMEM2Rs = 1'b0;
      //$display("Opcode = %b, Last2Instr = %h, Rs = %h", OpCode, Last2Instr, AddrRs);
    end
    
    /*
     MEM data forwarding detect.

     Last2Instr's Rd to this Instr's Rt OpCode <= 4
     EXEC/JR(take Rd as RData2)         OpCode >= E
     SW take Last2Instr's Rd as Rd      OpCode == 9
     LHB/LLB take Last2Instr's Rd as Rd OpCode == 10/OpCode == 11
     */
    if ((canForward2 == 1'b1)
        && ((OpCode <= 4'd4 && Last2Instr[11:8] == AddrRt && AddrRt != 0)
            || ((OpCode >= `JR || OpCode >= `SW && OpCode <= `LLB) && (Last2Instr[11:8] == AddrRd) && (AddrRd != 0)))) begin
      FwMEM2Rt = 1'b1;
    end else begin
      FwMEM2Rt = 1'b0;
      //$display("Opcode = %b, Last2Instr = %h, Rt = %h", OpCode, Last2Instr, AddrRt);
    end
    if ((Last2Instr[15:12] == `JAL)
        && ((OpCode <= 4'd4 && 4'd15 == AddrRt)
            || ((OpCode >= `JR || OpCode >= `SW && OpCode <= `LLB) && (4'd15 == AddrRd)))) begin
      FwMEM2Rt = 1'b0;
    end


    
    //Control Signal generating
    case (OpCode)
      
      // ADD
      4'b0000: begin
        Signal[11:0] = 12'b0000_0011_0110;
        ALUOp    = 3'b000;
        WriteEn  = 1'b1;
        MemWrite = 1'b0;
        FlagEn   = 1'b1;
      end
      //SUB
      4'b0001: begin
        Signal[11:0] = 12'b0000_0011_0110;
        ALUOp    = 3'b001;
        WriteEn  = 1'b1;
        MemWrite = 1'b0;
        FlagEn   = 1'b1;
      end             
      //AND         
      4'b0010: begin
        Signal[11:0] = 12'b0000_0011_0110;
        ALUOp    = 3'b010;
        WriteEn  = 1'b1;
        MemWrite = 1'b0;
        FlagEn   = 1'b1;
      end
      //OR        
      4'b0011: begin
        Signal[11:0] = 12'b0000_0011_0110;
        ALUOp    = 3'b011;
        WriteEn  = 1'b1;
        MemWrite = 1'b0;
        FlagEn   = 1'b1;
      end
      //SLL         
      4'b0100: begin
        Signal[11:0] = 12'b0000_0001_0110;
        ALUOp    = 3'b100;
        WriteEn  = 1'b1;
        MemWrite = 1'b0;
        FlagEn   = 1'b0;
      end
      //SRL        
      4'b0101: begin
        Signal[11:0] = 12'b0000_0001_0110;
        ALUOp    = 3'b101;
        WriteEn  = 1'b1;
        MemWrite = 1'b0;
        FlagEn   = 1'b0;
      end
      //SRA         
      4'b0110: begin
        Signal[11:0] = 12'b0000_0001_0110;
        ALUOp    = 3'b110;
        WriteEn  = 1'b1;
        MemWrite = 1'b0;
        FlagEn   = 1'b0;
      end
      //RL
      4'b0111: begin
        Signal[11:0] = 12'b0000_0001_0110;
        ALUOp    = 3'b111;
        WriteEn  = 1'b1;
        MemWrite = 1'b0;
        FlagEn   = 1'b0;
      end
      //LW         
      4'b1000: begin
        Signal[11:0] = 12'b1000_1001_0110;
        ALUOp    = 3'b000;
        WriteEn  = 1'b1;
        MemWrite = 1'b0;
        FlagEn   = 1'b0;
      end
      //SW         
      4'b1001: begin
        Signal[11:0] = 12'b1001_0011_0000;
        ALUOp    = 3'b000;
        WriteEn  = 1'b0;
        MemWrite = 1'b1;
        FlagEn   = 1'b0;
      end
      //LHB        
      4'b1010: begin
        Signal[11:0] = 12'b0101_0000_0000;
        WriteEn  = 1'b1;
        MemWrite = 1'b0;
        FlagEn   = 1'b0;
      end
      //LLB         
      //================
      //Modified!!!!!!!
      //================
      4'b1011: begin
        Signal[11:0] = 12'b0001_0000_0000;
        ALUOp    = 3'b010;
        WriteEn  = 1'b1;
        MemWrite = 1'b0;
        FlagEn   = 1'b0;
      end
      //B        
      4'b1100: begin
        if (BS == 1) begin
          Signal[11:0] = 12'b0000_0011_0001;
          ALUOp    = 3'b000;
          WriteEn  = 1'b0;
          MemWrite = 1'b0;
        end else begin
          Signal[11:0] = 12'b0000_0011_0000;
          ALUOp    = 3'b000;
          WriteEn  = 1'b0;
          MemWrite = 1'b0;
        end // else: !if(BS == 1)
        FlagEn   = 1'b0;
      end
      //JAL         
      4'b1101: begin
        Signal[11:0] = 12'b0001_0111_1101;
        ALUOp    = 3'b000;
        WriteEn  = 1'b1; 
        MemWrite = 1'b0;
        FlagEn   = 1'b0;
      end 
      //JR
      4'b1110: begin
        Signal[11:0] = 12'b0001_0000_0011;
        ALUOp    = 3'b000;
        WriteEn  = 1'b0; 
        MemWrite = 1'b0;
        FlagEn   = 1'b0;
      end
      //EXEC : EXEC(Next)to be completed
      4'b1111: begin
        Signal[11:0] = 12'b0001_0011_0111;
        ALUOp    = 3'b000;
        WriteEn  = 1'b0;
        MemWrite = 1'b0;
        FlagEn   = 1'b0;
      end    
      
    endcase // case (OpCode)
        
    if (Last2Instr[15:12] == `EXEC) begin //EXEC test
      Signal[9] = 1'b1;
      Signal[0] = 1'b0;//not modify pc. 
      //Do not change anything
      // ALUOp    = 3'b000;
      // WriteEn  = 1'b0;
      // MemWrite = 1'b0;
      // FlagEn   = 1'b0;
    end

    if (FwALU2Rs == 1'b1) begin
      Signal[12] = 1'b1;
    end else begin
      Signal[12] = 1'b0;
    end
    if (FwALU2Rt == 1'b1) begin
      Signal[13] = 1'b1;
    end else begin
      Signal[13] = 1'b0;
    end
    
    if (FwMEM2Rs == 1'b1) begin
      Signal[14] = 1'b1;
    end else begin
      Signal[14] = 1'b0;
    end
    if (FwMEM2Rt == 1'b1) begin
      Signal[15] = 1'b1;
    end else begin
      Signal[15] = 1'b0;
    end
  end
endmodule // control
