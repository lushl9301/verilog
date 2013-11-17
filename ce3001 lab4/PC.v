`include "define.v"

module PC(Clk,
          Rst,
          CurrPC,
          NextPC);
  
  //declare input and output signals
  input [`MEM_SPACE-1:0] CurrPC;
  input                  Clk, Rst;
  
  output reg [15:0] NextPC;
  
  always @(posedge Clk) begin
    if (!Rst)
      NextPC <= 0;
    else begin
      NextPC <= CurrPC + 1;
    end
  end // always @ (posedge Clk)
  
endmodule // PC
