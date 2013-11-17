`include "define.v"

module Pre_decoder(Instr, LastInstr, Last3Instr, PC_En, instr_sel);
  
  //declare input and output signals
  input [`ISIZE-1:0] LastInstr, Last3Instr;
  input [`ISIZE-1:0] Instr;
  //input              LastExec;
  output reg PC_En, instr_sel;
  
  reg PC_En_wire, instr_sel_wire;
  
  always@(*) begin 
    
    PC_En = 1'b1;
    instr_sel = 1'b0;
    
    if(LastInstr[15:14] == 2'b11) begin
        
        PC_En = 1'b0;
        instr_sel = 1'b1;
        
    end
    
    if (LastInstr[15:14] == 2'b00 && Instr[15:12] == 4'b1100) begin
    
        PC_En = 1'b0;
        instr_sel = 1'b1;
        
    end
    
    if (LastInstr[15:12] == 4'b1000) begin
        
        if (LastInstr[11:8] == Instr[7:4] && Instr[15:12] < 4'd10 && Instr[7:4] != 4'd0) begin
          
          PC_En = 1'b0;
          instr_sel = 1'b1;
          
        end
        
        if (LastInstr[11:8] == Instr[3:0] && Instr[15:12] < 4'd5 && Instr[3:0] != 4'd0) begin
          
          PC_En = 1'b0;
          instr_sel = 1'b1;
          
        end
        
        if (LastInstr[11:8] == Instr[11:8] && Instr[15:12] > 4'b1101 && Instr[11:8] != 4'd0) begin
          
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

  end
    
endmodule
