`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:10:42 05/07/2022 
// Design Name: 
// Module Name:    conv2d 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`define idle 3'b000
`define left 3'b001
`define middle 3'b010
`define complete 3'b011

`define NoOfColumns 8'b0000_0101
`define NoOfRows 8'b0000_0101
module conv2d(
input clk,rst,start,
input [11:0] d_in,
output  [16:0]addr_rd,
output reg [16:0] addr_wr,
output reg [11:0] d_out,
output reg ready
    );
reg [2:0] state,row_reg,column_reg;
reg [7:0] row,column,temp_row,temp_column;
reg en;
wire [11:0] buffer_out;

assign addr_rd = temp_row*`NoOfColumns+temp_column;

buffer b(clk,rst,en,d_in,d_out);

always @(posedge clk)
if (rst)
    begin
	 state<=`idle;
	 //addr_rd <=0;
	 addr_wr <=0;
	 d_out <=0;
	 row_reg <=3'b001;
	 column_reg <=3'b001; // 001-->010-->100-->001
	 row<=0;
	 column<=0;
	 temp_row<=0;
	 temp_column<=0;
	 en<=0;
	 ready<=0;
	 end
else
    case (state)
	 `idle: begin
	       if(start)
			    begin
				 state<=`left;
				 en<=1;
				 end				 
			 end
			 
	 `left: begin
	       if ( row_reg[2]==1'b1) // previous or next value at the clock edge??
			     begin
				  row_reg<={row_reg[1:0],row_reg[2]};
				  column_reg<={column_reg[1:0],column_reg[2]};
				  temp_column<=temp_column+1;
				  temp_row<=row;
				  if (column_reg[2]==1)
				      begin
						state<=`middle;
						column<=column+1'b1;
						temp_column<=temp_column+1'b1;
					   end
				  end
			 else
			     begin
				  row_reg<={row_reg[1:0],row_reg[2]};
				  temp_row<=temp_row+1'b1;
				  end
			 end
	
	 `middle:begin
           if (temp_row == `NoOfRows-1 && temp_column == `NoOfColumns-1 && row_reg[2]==1)
			      //row == `NoOfRows-2 && temp_column == 0 && row_reg[0]==1
			      begin
				   en<=0;
				   state<=`complete;
				   end
			  else
			      if (temp_column == `NoOfColumns-1 && row_reg[2]==1)
				       begin
						 state<=`left;
						 column<=0;
						 temp_column<=0;
						 row<=row+1;
						 temp_row<=row+1;
					    row_reg<={row_reg[1:0],row_reg[2]};
						 end
			      else
				       if (row_reg[2]==1)
						     begin
							  column<=column+1;
							  temp_column<=temp_column+1;
							  temp_row<=row;
							  row_reg<={row_reg[1:0],row_reg[2]};
							  end
						 else
						     begin
							  temp_row<=temp_row+1;
							  row_reg<={row_reg[1:0],row_reg[2]};
							  end
				  end
				  
    `complete: begin
              en<=0;
              ready<=1;
				  row<=0;
				  column<=0;
				  temp_row<=0;
				  temp_column<=0;
              if (start)
                 state<=`idle;
				  end
             		 
			 
	 default: state<=`idle;
	 
	 endcase
endmodule
