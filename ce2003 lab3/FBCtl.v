module FBCtl(
             output        o_rdy,
             input         i_enc,
             input         i_rst,
             input         i_vsync,
             output [15:0] o_data,
             input         i_clk,
             input [8:0]   i_x,
             input [7:0]   i_y,
             input [5:0]   i_data,
             input         i_done
             );
  
  
  reg [16:0]               rd_addr;
  reg [16:0]               wr_addr;
  reg                      frame_buffer_wr_en;
  wire [5:0]               buff_data;
  reg [5:0]                wr_data;
  reg [10:0]               X;
  reg [9:0]                Y;
  
  assign o_rdy = i_done;
  assign o_data = {buff_data[4],{2{buff_data[5:4]}},{3{buff_data[3:2]}},buff_data[0],{2{buff_data[1:0]}}};
  

  //Buffer for storing the frame data
  
  // INSERT FRAME BUFFER INSTANTIATION HERE
  frame_buffer fb1(.clka(i_clk), .clkb(i_clk),
                   .wea(frame_buffer_wr_en),
                   .addra(wr_addr),
                   .addrb(rd_addr),
                   .dina(wr_data),
                   .doutb(buff_data)
                   );
                      
  
  //This block generates the read address for the frame buffer.
  //Resolution is 1600x900. Since our buffer is 1/16 of the actual
  //frame size, each data in the buffer maps to 16 pixels on screen.
  always @(posedge i_clk)
    begin
      if(i_rst|i_vsync)
        begin
          X <= 0;
          Y <= 0;
        end
      else
        begin
          if(i_enc)
	          begin
              if (X == 1599)
                begin
                  X <= 0;
                  if(Y == 899)
                    Y <= 0;
                  else
                    Y <= Y + 1;    
                end
              else
                X <= X + 1;
              rd_addr <= X[10:2]+400*Y[9:2];
            end		
        end
    end
  
  //This block received data from the data generator and writes into the frame buffer.
  always @(posedge i_clk)
    begin
      if(i_rst)
        begin
          frame_buffer_wr_en <= 1'b0;
          wr_addr <= 0;
        end
      else
        begin
          frame_buffer_wr_en <= 1'b1;
          wr_addr <= i_x + 400*i_y;
          wr_data <= i_data;	  
        end
    end  
endmodule
