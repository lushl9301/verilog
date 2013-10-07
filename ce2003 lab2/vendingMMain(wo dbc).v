`timescale 1ns / 1ps

module VendingMachine(
                      input      in1,
                      input      in2,
                      input      in5,
                      input      clk,
                      input      rst,
                      input      cancel,
                      output reg vend,
                      output reg out1,
                      output reg out2,
                      output reg out22
                      );
  //wire                           in1, in2, in5, dc, clk;
  reg [3:0]                      st;
  reg [3:0]                      nst;
  parameter
    st0=4'd0, st1=4'd1, st2=4'd2, st3=4'd3, st4=4'd4,
    vend0=4'd5, vend1=4'd6, vend2=4'd7, vend3=4'd8, vend4=4'd9,
    ref1=4'd10, ref2=4'd11, ref3=4'd12, ref4=4'd13;
  
  //debounce d1(.btn(in1), .clk(clk), .outedge(in1));
  //debounce d2(.btn(in2), .clk(clk), .outedge(in2));
  //debounce d3(.btn(in5), .clk(clk), .outedge(in5));
  //debounce dcancel(.btn(cancel), .clk(clk), .outedge(cancel));
  
  always @(posedge clk) begin
    if (rst)
      st <= st0;
    else
      st <= nst;
  end
  
  always @*
    begin
      vend = 0;
      out1 = 0;
      out2 = 0;
      out22 = 0;
      nst = st0;
      case (st)
        st0:
          begin
            if (in1) nst = st1;
            if (in2) nst = st2;
            if (in5) nst = vend0;
          end
        st1:
          begin
            if (in1) nst = st2;
            if (in2) nst = st3;
            if (in5) nst = vend1;
            if (cancel) nst = ref1;
          end
        st2:
          begin
            if (in1) nst = st3;
            if (in2) nst = st4;
            if (in5) nst = vend2;
            if (cancel) nst = ref2;
          end
        st3:
          begin
            if (in1) nst = st4;
            if (in2) nst = vend0;
            if (in5) nst = vend3;
            if (cancel) nst = ref3;
          end
        st4:
          begin
            if (in1) nst = vend0;
            if (in2) nst = vend1;
            if (in5) nst = vend4;
            if (cancel) nst = ref4;
          end
        vend0:
          begin
            vend = 1'b1;
          end
        vend1:
          begin
            vend = 1'b1;
            out1 = 1'b1;
          end 
        vend2:
          begin
            vend = 1'b1;
            out2 = 1'b1;
          end
        vend3:
          begin
            vend = 1'b1;
            out1 = 1'b1;
            out2 = 1'b1;
          end 
        vend4:
          begin 
            vend = 1'b1;
            out2 = 1'b1;
            out22 = 1'b1;
          end 
        ref1:
          begin
            out1 = 1'b1;
          end
        ref2:
          begin
            out2 = 1'b1;
          end
        ref3:
          begin
            out1 = 1'b1;
            out2 = 1'b1;
          end
        ref4:
          begin
            out2 = 1'b1;
            out22 = 1'b1;
          end
      endcase
    end
endmodule // VeningMachine
