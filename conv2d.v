`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 10xEngineers
// Engineer: Hafiz Talha Iqbal
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
`define top_left 3'b001
`define top 3'b010
`define left 3'b011
`define middle 3'b100
`define complete 3'b101

`define NoOfColumns 8'b0011_0010
`define NoOfRows 8'b0011_0010
`define SerialRegBW 5              //Serial Register bitwidth
`define SerialInit 5'b00001        //Serial register initial value
`define RowColBW 8                 //Bits to store number of rows and columns


 module conv2d
#(parameter AddressBitWidth=17, parameter DataBitWidth=12,
  parameter StateBitWidth=3, parameter FilterSize=5, parameter Offset=-1*$floor(FilterSize/2),
  parameter ImageSizeBitWidth=8
  )(
input clk,rst,start,
input [DataBitWidth-1:0] d_in,     // from memory
output  [AddressBitWidth-1:0]ReadAddress,
output reg [AddressBitWidth-1:0] WriteAddress,
output  [DataBitWidth-1:0] d_out,
output reg ready,WriteEnable
    );


// necessary registers and wires	 
reg [StateBitWidth-1:0] state;
reg [FilterSize-1:0] row_reg,column_reg;             // circular serial shift register to track row and column read
reg [ImageSizeBitWidth-1:0] row,column;              // location of the center pixel
reg signed[ImageSizeBitWidth:0]temp_row,temp_column; // temp_row and temp_column can be negative so 1 more bit
wire [DataBitWidth-1:0] BufferOut,BufferIn;          // Buffer data input and output 
wire signed [AddressBitWidth:0] ReadAddress2; 
reg BufferEnable,WriteEnable2;                      

// Finding valid Address
wire AddressValid;                                   // to check if the address is valid 
assign AddressValid = (temp_row>=0 && temp_row <=`NoOfRows-1) && (temp_column>=0 && temp_column <=`NoOfColumns-1);


	  
// Instantiating Buffer
assign BufferIn=AddressValid?d_in:0;                 // in case of invalid address, give 0 as input to the buffer
buffer b(clk,rst,BufferEnable,BufferIn,BufferOut);
assign d_out = BufferOut;

// Generating Read Address
assign ReadAddress2 = temp_row*`NoOfColumns+temp_column;
assign ReadAddress=ReadAddress2[AddressBitWidth-1:0]; // Neglecting MSB of ReadAddress2



always @(posedge clk)
if (rst)
    begin
	 state<=`idle;
	 WriteAddress <=0;
	 row_reg <=`SerialInit;
	 column_reg <=`SerialInit; 
	 row<=0;
	 column<=0;
	 temp_row<=0;
	 temp_column<=0;
	 BufferEnable<=0;
	 ready<=0;
	 WriteEnable2<=0;
	 end
else
    case (state)
	 `idle: begin
	       if(start)
			    begin
				 state<=`top_left;
				 BufferEnable<=1;
				 temp_row<=Offset;
				 temp_column<=Offset;
				 end				 
			 end

`top_left: begin
           if ( row_reg[FilterSize-1]==1'b1) // if one row completed
			     begin
				  row_reg<={row_reg[FilterSize-2:0],row_reg[FilterSize-1]};
				  column_reg<={column_reg[FilterSize-2:0],column_reg[FilterSize-1]};
				  temp_column<=temp_column+1;
				  temp_row<=Offset;
				  if (column_reg[FilterSize-1]==1) // if all columns are completed
				      begin
						WriteEnable2<=1;
						state<=`top;
						column<=column+1'b1;        // move to next column
					   end
				  end
			 else
			     begin
				  row_reg<={row_reg[FilterSize-2:0],row_reg[FilterSize-1]}; 
				  temp_row<=temp_row+1'b1;
				  end
			 end
			 
	  `top: begin  // traversing the first row of the image except the top left pixel
	        if (temp_column == `NoOfColumns-Offset-1 && row_reg[FilterSize-1]==1) // if row completed for the last column  
				       begin
						 WriteEnable2<=1;
						 WriteAddress<=WriteAddress+1;
						 state<=`left;
						 column<=0;
						 temp_column<=Offset;
						 row<=row+1;           // next row of the destination 
						 temp_row<=row+Offset+1; 
					    row_reg<={row_reg[FilterSize-2:0],row_reg[FilterSize-1]};
						 end
			      else
				       if (row_reg[FilterSize-1]==1)
						     begin
							  WriteEnable2<=1;
							  WriteAddress<=WriteAddress+1;
							  column<=column+1;
							  temp_column<=temp_column+1;
							  temp_row<=Offset;
							  row_reg<={row_reg[FilterSize-2:0],row_reg[FilterSize-1]};
							  end
						 else
						     begin
							  WriteEnable2<=0;
							  temp_row<=temp_row+1;
							  row_reg<={row_reg[FilterSize-2:0],row_reg[FilterSize-1]};
							  end
			  end
	     
	        
	  
	 `left: begin
	        if ( row_reg[FilterSize-1]==1'b1) 
			      begin
				   row_reg<={row_reg[FilterSize-2:0],row_reg[FilterSize-1]};
				   column_reg<={column_reg[FilterSize-2:0],column_reg[FilterSize-1]};
				   temp_column<=temp_column+1;
				   temp_row<=row+Offset;
				   if (column_reg[FilterSize-1]==1)
				       begin
						 WriteAddress<=WriteAddress+1;
						 WriteEnable2<=1;
						 state<=`middle;
						 column<=column+1'b1;
						 temp_column<=temp_column+1'b1;
					    end
				   end
			  else
			      begin
					WriteEnable2<=0;
				   row_reg<={row_reg[FilterSize-2:0],row_reg[FilterSize-1]};
				   temp_row<=temp_row+1'b1;
				   end
			  end
	
	 `middle:begin // as Offset is a negative number so it is being subtracted in the following line for addition,-1 due to 0 as starting index
           if (temp_row == `NoOfRows-Offset-1 && temp_column == `NoOfColumns-Offset-1 && row_reg[FilterSize-1]==1)
			      begin
					WriteAddress<=WriteAddress+1;
					WriteEnable2<=1;
				   state<=`complete;
				   end
			  else
			      if (temp_column == `NoOfColumns-Offset-1 && row_reg[FilterSize-1]==1)
				       begin
						 WriteAddress<=WriteAddress+1;
					    WriteEnable2<=1;
						 state<=`left;
						 column<=0;
						 temp_column<=Offset;
						 row<=row+1;
						 temp_row<=row;
					    row_reg<={row_reg[FilterSize-2:0],row_reg[FilterSize-1]};
						 end
			      else
				       if (row_reg[FilterSize-1]==1)
						     begin
							  WriteAddress<=WriteAddress+1;
					        WriteEnable2<=1;
							  column<=column+1;
							  temp_column<=temp_column+1;
							  temp_row<=row+Offset;
							  row_reg<={row_reg[FilterSize-2:0],row_reg[FilterSize-1]};
							  end
						 else
						     begin
							  WriteEnable2<=0;
							  temp_row<=temp_row+1;
							  row_reg<={row_reg[FilterSize-2:0],row_reg[FilterSize-1]};
							  end
				  end
				  
    `complete: begin
	           WriteEnable2<=0;
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

//delayed version of WriteEnable as computation gets ready in the next clock cycle, see waveform	 
always @ (posedge clk)
WriteEnable<=WriteEnable2;
endmodule
