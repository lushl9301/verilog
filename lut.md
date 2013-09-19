Look Up Table
=============
Think about the lookup table of trigonometric. We skipped the calculation parts and just note down the value after one time calculation.

Think about the memoization searching. 

"The tables may be precalculated and stored in static program storage, calculated (or "pre-fetched") as part of a program's initialization phase (memoization), or even stored in hardware in application-specific platforms."

"In digital logic, an n-bit lookup table can be implemented with a multiplexer whose select lines are the inputs of the LUT and whose inputs are constants. An n-bit LUT can encode any n-input Boolean function by modeling such functions as truth tables. This is an efficient way of encoding Boolean logic functions, and LUTs with 4-6 bits of input are in fact the key component of modern field-programmable gate arrays (FPGAs)."


usage:
  
  [h2]Memory
     use LUT as a memory 6-input LUT -> 64*1bit memory (2^6==64) can be combined

  [h2]shift register

    each clock cycle content shift by 1. New shift in ->  able to select length

    [http://www.xilinx.com/support/documentation/application_notes/xapp465.pdf](http://www.xilinx.com/support/documentation/application_notes/xapp465.pdf)
    
    don't understand
  
  [h2]multiplexer
    6-bit LUT can implement a 4-by-1 multiplexer (2 bit for sel)
    2 6-bit LUTs + a 2-by-1 multiplexer can implement a 8-by 1 multiplexer
    We can combine LUTs

example 1

0000
0001
0010
0011 0035

0100
0101
0110
0111 0F35

1000
1001
1010
1011 F035

1100
1101
1110
1111 FF35

5555
3333
0F0F
00FF

the LUT will be 64'H5555_3333_0F0F_00FF


example 2
a 4-input LUT contents 16'h84B7
1000_0100_1011_0111

F(3:0) = 0, 5, 8, 10, 11, 13, 14, 15
make a K-map then. figure out minimized gate-level circuit.