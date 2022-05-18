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


module conv2d
#(parameter AddressBitWidth=17, parameter DataBitWidth=12,
  parameter StateBitWidth=3, parameter FilterSize=3,
  parameter ImageSizeBitWidth=8
  )(
input clk,rst,start,
input [DataBitWidth-1:0] d_in,
output  [AddressBitWidth-1:0]ReadAddress,
output reg [AddressBitWidth-1:0] WriteAddress,
output  [DataBitWidth-1:0] d_out,
output reg ready
    );


// necessary registers and wires	 
reg [StateBitWidth-1:0] state;
reg [FilterSize-1:0] row_reg,column_reg;
reg [ImageSizeBitWidth-1:0] row,column;
reg [ImageSizeBitWidth:0]temp_row,temp_column; // temp_row and temp_column can be negative so 1 more bit
wire [DataBitWidth-1:0] BufferOut;
wire signed [AddressBitWidth:0] ReadAddress2;
reg BufferEnable;

	  
// Instantiating Buffer
buffer b(clk,rst,BufferEnable,d_in,BufferOut);

// Finding valid Address
wire AddressValid;
assign AddressValid = (temp_row>=0 && temp_row <=`NoOfRows-1) && (temp_column>=0 && temp_column <=`NoOfColumns-1);
assign d_out = AddressValid ? BufferOut:0;

// Generating Read Address
assign ReadAddress2 = temp_row*`NoOfColumns+temp_column;
assign ReadAddress=ReadAddress2[AddressBitWidth-1:0]; // Neglecting MSB of ReadAddress2



always @(posedge clk)
if (rst)
    begin
	 state<=`idle;
	 //addr_rd <=0;
	 WriteAddress <=0;
	 row_reg <=3'b001;
	 column_reg <=3'b001; // 001-->010-->100-->001
	 row<=0;
	 column<=0;
	 temp_row<=0;
	 temp_column<=0;
	 BufferEnable<=0;
	 ready<=0;
	 end
else
    case (state)
	 `idle: begin
	       if(start)
			    begin
				 state<=`left;
				 BufferEnable<=1;
				 temp_row<=temp_row-1;
				 temp_column<=temp_column-1;
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
           if (temp_row == `NoOfRows && temp_column == `NoOfColumns && row_reg[2]==1)
			      //row == `NoOfRows-2 && temp_column == 0 && row_reg[0]==1
			      begin
				   BufferEnable<=0;
				   state<=`complete;
				   end
			  else
			      if (temp_column == `NoOfColumns && row_reg[2]==1)
				       begin
						 state<=`left;
						 column<=0;
						 temp_column<=-1;
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
              BufferEnable<=0;
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
