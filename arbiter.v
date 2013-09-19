module arbiter (input clk, rq1, rq2, rq3, rst,
                output gt1, gt2, gt3);
   reg                 gt1, gt2, gt3;
   reg [1:0]           state;
   parameter
     a = 2'd1,
     b = 2'd2,
     c = 2'd3,
     idle = 2'd0;
   always @(rq1, rq2, rq3)
     begin
        gt1 = 0; gt2 = 0; gt3 = 0;
        case (state)
          idle:
            if (rq1) begin
               nst = a;
            if (!rq1 & rq2) begin
               nst = b;
            if (!rq1 & !rq2 & rq3) begin
               nst = c;
            end
          a: gt1 = 1;
          if (!rq1) begin
             nst = idle;
          end
          b: gt2 = 1;
          if (!rq2) begin
             nst = idle;
          end
          c: gt3 = 1;
          if (!rq3) begin
             nst = idle;
          end
        endcase // case (state)
     end // always @ (rq1, rq2, rq3)

   always @(posedge clk)
     begin
        if (rst)
          state <= idle;
        else state <= nst;
     end
endmodule // arbiter
