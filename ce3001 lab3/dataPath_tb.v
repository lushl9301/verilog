module dataPath_tb();
  reg [15:0]  Instruction, DataInit;
  reg         InitSel, clk, reset;
  wire [15:0] ALUOut;
  topModule dataPath(.Instruction(Instruction),
                     .DataInit(DataInit),
                     .InitSel(InitSel),
                     .clk(clk),
                     .reset(reset),
                     .ALUOut(ALUOut)
                     );
  always #5 clk = ~clk;
  initial begin
    reset = 0;
    clk = 0;
    #20 reset = 1;
    repeat (20) begin
      InitSel = 0;
      {DataInit, Instruction} = $random;
      #10 $display("Instruction = %b, DataInit = %b", Instruction, DataInit);
    end
    repeat (15) begin
      {Instruction, DataInit} = $random;
      InitSel = 1;
      #10 $display("Instruction = %b, ALUOut = %b", Instruction, ALUOut);
    end
    $finish;
  end // initial begin
endmodule // dataPath_tb