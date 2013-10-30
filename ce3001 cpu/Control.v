module Control (input [3:0] ControlInput, output WriteEn, output [2:0] ALUop);
  assign opcode = Con;
  assign WriteEn = 1;
  assign ALUop = ControlInput[2:0];
endmodule
