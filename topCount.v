module topCount (input clk, rst, dn,
                 output divs);
   wire [2:0]           countVal;
   count3ud mod1(.clk(clk), .rst(rst), .dn(dn), count(coundVal));
   //checkit mod2(.numin(countVal), .divs(divs));
   //just don't want to code more codes... lolz
endmodule // topCount