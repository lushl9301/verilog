`include "define.v"

module alu(
           input signed [`DSIZE - 1:0] A, B,
           input [2:0]                 op,
           input [2:0]                 lastFlag,
           input                       FlagEn,
           input [3:0]                 imm,
           input                       clk,
           output reg [`DSIZE - 1:0]   out,
           output reg [2:0]            flag
           );
  
  wire                                 z, v, n;
  reg [`DSIZE - 1:0]                   tmpOut;
  
  assign z = (tmpOut == 16'b0) ? 1 : 0;
  assign v = ((op == `ADD && ~(A[15] ^ B[15]) && (A[15] ^ tmpOut[15])) 
              || (op == `SUB && (A[15] ^ B[15]) && (A[15] ^ tmpOut[15]))) ? 1 : 0;
  assign n = ((op == `ADD || op == `SUB) && (~v && tmpOut[15])) ? 1 : 0;
  
  always @(*) begin
    case (op)
      `ADD: tmpOut = A + B;
      `SUB: tmpOut = A - B;
      `AND: tmpOut = A & B;
      `OR: tmpOut = A | B;
      `SLL: tmpOut = A << imm;
      `SRL: tmpOut = A >> imm;
      `SRA: tmpOut = A >>> imm;
      `RL: tmpOut = {A << imm | A >> (16 - imm)};
      default: tmpOut = 16'd0;
    endcase
  end
  always @(posedge clk) begin
    out <= tmpOut;
    if (op < 4 && FlagEn == 1'b1) begin
      flag[0] <= z;
      flag[1] <= v;
      flag[2] <= n;
    end else begin
      flag <= lastFlag;
    end
  end
  //assign out = tmpOut;
  //assign flag = (op < 4) ? {n, v, z} : lastFlag;
endmodule // alu
