module CPU_tb;
  
  reg Clk;
  reg Rst;
  
  CPU T0(.Clk(Clk), .Rst(Rst));
  
  initial
  begin
    Clk = 1'd0; Rst = 1'd0;
    #30 Rst = 1'd1;
    #100000;
    $finish;
  end
  
  always begin
    #2 Clk = ~Clk;
  end
  
endmodule