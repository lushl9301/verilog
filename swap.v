/*
 *
 *swap.v
 *   do a swap operation
 *
 * I just want to know
 * if a programmable logic unit can be employed for faster sorting algorithm.  
 *
 * Lu Shengliang
 *
 * stackoverflow.com/questions/13815642/what-is-the-best-way-to-exchange-2-registers-in-verilog
 */

module swap2Value(input aIn, bIn, clk, output reg aOut, bOut);
   always @(posedge clk)
     begin
	aOut <= bIn;
	bOut <= aIn;
     end      
endmodule // swap2Value

//performed well on xilinx tools. next time try to figure out the implementation.