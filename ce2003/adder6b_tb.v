module adder6b_tb();
  reg [5:0] a, b;
  wire [5:0] sum;
  adder6b (.a(a), .b(b), .sum(sum));
  initial
    begin
      repeat (10) begin
        {a,b} = $random;
        //do fun stuff and make you feel clever! --Suhaib A. Fahmy
        #10
          if (a+b != sum)
            $diplay("Error: %d + %d, Error output: %d, Correct output: %d",
                    a, b, sum, a+b);
      end
      $finish;
    end // initial begin
endmodule // adder6b_tb