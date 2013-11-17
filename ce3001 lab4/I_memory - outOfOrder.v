`include "define.v"

module I_memory(
                input [`MEM_SPACE-1:0]  address, // address input
                input [`ISIZE-1:0] storeInstr,
                output reg [`ISIZE-1:0] data_out, // data output
                output reg [`ISIZE-1:0] nextData_out,
                input                   clk,
                input                   rst
                );
  reg [`ISIZE-1:0]                      memory [0:2**`MEM_SPACE];
  reg [8*`MAX_LINE_LENGTH:0]            line; /* Line of text read from file */
  integer                               I_init, addr_inc, i, c, r;
  
  always@(posedge clk or posedge rst) 
    begin
      if(!rst)
        begin
          
          //NOP Instruction
          data_out <= 16'h7000;
          
          addr_inc = 0;
          I_init = $fopen("I_memory_init.txt","r");
          
          while(!$feof(I_init))
            begin
              c = $fgetc(I_init);
              // check for comment
              if (c == "/" | c == "#" | c == "%")
                r = $fgets(line, I_init);
              else begin
                // Push the character back to the file then read the next time
                r = $ungetc(c, I_init);
                r = $fscanf(I_init, "%h", memory[addr_inc]);
                addr_inc = addr_inc + 1;
              end
            end
          $fclose(I_init);
          for (i = addr_inc - 1; i < 2 ** `MEM_SPACE; i = i + 1)
            begin
              memory[i] = 16'h0000;
            end
        end
      else
        begin
          if (address <= 1'b1) begin
            data_out <= memory[address];
          end else begin
            data_out <= storeInstr;
          end
          nextData_out <= memory[address + 1];
        end // else: !if(rst)
    end // always@ (posedge clk or posedge rst)
endmodule // I_memory
