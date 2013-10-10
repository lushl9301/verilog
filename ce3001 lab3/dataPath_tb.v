module dataPath_tb();
  reg [15:0] Instruction, DataInit;
  reg       InitSel, clk, reset;
  wire      ALUOut;
  topModule dataPath(.Instruction(Instruction),
                     .DataInit(DataInit),
                     .InitSel(InitSel),
                     .clk(clk),
                     .reset(reset),
                     .ALUOut(ALUOut)
                     );
  initial begin
    repeat (10) begin
      {DataInit, InitSel} = $random;
      #10 $display("%d", DataInit);
    end
    repeat (15) begin
      {Instruction, DataInit} = $random;
      InitSel = 1;
      #10 $display("Instruction = %d, ALUOut = %d", Instruction, ALUOut);
    end
    $finish;
  end // initial begin
endmodule // dataPath_tb