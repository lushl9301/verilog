`include "define.v"

module Pre_decoder(Instr,
                   Instr2,
                   LastInstr,
                   Last3Instr,
                   PC_En,
                   instr_sel,
                   outInstr,
                   storeInstr);
  
  //declare input and output signals
  input [`ISIZE-1:0] LastInstr, Last3Instr;
  input [`ISIZE-1:0] Instr, Instr2;

  output reg [`ISIZE-1:0] outInstr, storeInstr;
  output reg PC_En, instr_sel;
  
  reg PC_En_wire, instr_sel_wire;
  
  always@(*) begin 
    
    PC_En = 1'b1;
    instr_sel = 1'b0;
    outInstr = Instr;
    storeInstr = Instr2;
  
    //$display("I come! %h", Instr2);
    //lw or sw can be reorder
    if ((Instr2[15:12] == 4'b1001 || Instr2[15:12] == 4'b1000) && Instr != 16'h7000) begin
      case (Instr[15:12]) 
        4'b0000 : begin
          if (Instr2[11:8] != Instr[11:8] && Instr2[11:8] != Instr[7:4] && Instr2[11:8] != Instr[3:0] && Instr[11:8] != Instr2[7:4]) begin
            outInstr = Instr2;
            storeInstr = Instr;
            PC_En = 1'b1;
            instr_sel = 1'b0;
          end else begin
            outInstr = Instr;
            storeInstr = Instr2;
          end
        end
        4'b0001 : begin
          if (Instr2[11:8] != Instr[11:8] && Instr2[11:8] != Instr[7:4] && Instr2[11:8] != Instr[3:0] && Instr[11:8] != Instr2[7:4]) begin
            outInstr = Instr2;
            storeInstr = Instr;
            PC_En = 1'b1;
            instr_sel = 1'b0;
          end else begin
            outInstr = Instr;
            storeInstr = Instr2;
          end
        end
        4'b0010 : begin
          if (Instr2[11:8] != Instr[11:8] && Instr2[11:8] != Instr[7:4] && Instr2[11:8] != Instr[3:0] && Instr[11:8] != Instr2[7:4]) begin
            outInstr = Instr2;
            storeInstr = Instr;
            PC_En = 1'b1;
            instr_sel = 1'b0;
          end else begin
            outInstr = Instr;
            storeInstr = Instr2;
          end
        end
        4'b0011 : begin
          if (Instr2[11:8] != Instr[11:8] && Instr2[11:8] != Instr[7:4] && Instr2[11:8] != Instr[3:0] && Instr[11:8] != Instr2[7:4]) begin
            outInstr = Instr2;
            storeInstr = Instr;
            PC_En = 1'b1;
            instr_sel = 1'b0;
          end else begin
            outInstr = Instr;
            storeInstr = Instr2;
          end
        end
        4'b0100 : begin
          if (Instr2[11:8] != Instr[11:8] && Instr2[11:8] != Instr[7:4] && Instr[11:8] != Instr2[7:4]) begin
            outInstr = Instr2;
            storeInstr = Instr;
            PC_En = 1'b1;
            instr_sel = 1'b0;
          end else begin
            outInstr = Instr;
            storeInstr = Instr2;
          end
        end
        4'b0101 : begin
          if (Instr2[11:8] != Instr[11:8] && Instr2[11:8] != Instr[7:4] && Instr[11:8] != Instr2[7:4]) begin
            outInstr = Instr2;
            storeInstr = Instr;
            PC_En = 1'b1;
            instr_sel = 1'b0;
          end else begin
            outInstr = Instr;
            storeInstr = Instr2;
          end
        end
        4'b0110 : begin
          if (Instr2[11:8] != Instr[11:8] && Instr2[11:8] != Instr[7:4] && Instr[11:8] != Instr2[7:4]) begin
            outInstr = Instr2;
            storeInstr = Instr;
            PC_En = 1'b1;
            instr_sel = 1'b0;
          end else begin
            outInstr = Instr;
            storeInstr = Instr2;
          end
        end
        4'b0111 : begin
          if (Instr2[11:8] != Instr[11:8] && Instr2[11:8] != Instr[7:4] && Instr[11:8] != Instr2[7:4]) begin
            outInstr = Instr2;
            storeInstr = Instr;
            PC_En = 1'b1;
            instr_sel = 1'b0;
          end else begin
            outInstr = Instr;
            storeInstr = Instr2;
          end
        end
        4'b1010: begin
          if (Instr2[11:8] != Instr[11:8] && Instr[11:8] != Instr2[7:4]) begin
            outInstr = Instr2;
            storeInstr = Instr;
            PC_En = 1'b1;
            instr_sel = 1'b0;
          end else begin
            outInstr = Instr;
            storeInstr = Instr2;
          end
        end
        4'b1011: begin
          if (Instr2[11:8] != Instr[11:8] && Instr[11:8] != Instr2[7:4]) begin
            outInstr = Instr2;
            storeInstr = Instr;
            PC_En = 1'b1;
            instr_sel = 1'b0;
          end else begin
            outInstr = Instr;
            storeInstr = Instr2;
          end
        end
        default : begin
          outInstr = Instr;
          storeInstr = Instr2;
        end
      endcase
    end
    
    if(LastInstr[15:14] == 2'b11) begin
        
        PC_En = 1'b0;
        instr_sel = 1'b1;
        
    end
    
    if (LastInstr[15:14] == 2'b00 && outInstr[15:12] == 4'b1100) begin
    
        PC_En = 1'b0;
        instr_sel = 1'b1;
        
    end
    
    if (LastInstr[15:12] == 4'b1000) begin
        
        if (LastInstr[11:8] == outInstr[7:4] && outInstr[15:12] < 4'd10 && outInstr[7:4] != 4'd0) begin
          
          PC_En = 1'b0;
          instr_sel = 1'b1;
          
        end
        
        if (LastInstr[11:8] == outInstr[3:0] && outInstr[15:12] < 4'd5 && outInstr[3:0] != 4'd0) begin
          
          PC_En = 1'b0;
          instr_sel = 1'b1;
          
        end
        
        if (LastInstr[11:8] == outInstr[11:8] && outInstr[15:12] > 4'b1101 && outInstr[11:8] != 4'd0) begin
          
          PC_En = 1'b0;
          instr_sel = 1'b1;
          
        end
        
    end
    
    if (LastInstr[15:0] == 16'h7000) begin
      
        PC_En = 1'b1;
        instr_sel = 1'b0;
      
    end

    //last instruction is EXEC
    //issue a 7000
    //this time don't issue 7000 anymore
    if (Last3Instr[15:12] == `EXEC && LastInstr[15:14] == 2'b11) begin

        PC_En = 1'b1;
        instr_sel = 1'b0;

    end
    if (PC_En == 1'b0) begin
      storeInstr = outInstr;
    end
    
  end

endmodule
