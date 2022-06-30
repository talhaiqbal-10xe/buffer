`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:46:15 06/30/2022 
// Design Name: 
// Module Name:    buffer_2d 
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
`define SerialInit 5'b00001
`define FilterBitWidth 8 // coefficient bit width
`define FilterSize 5

module buffer_2d
#(parameter DataBitWidth=12)
(
input clk,rst,en,
input [`FilterSize*`FilterSize*`FilterBitWidth-1:0] f_coeff,
input signed [DataBitWidth-1:0] d_in,
output signed [DataBitWidth-1:0] d_out
    );

reg [`FilterSize-1:0] state;	 
wire [`FilterBitWidth-1:0] coeff [0:`FilterSize-1][0:`FilterSize-1];
wire [DataBitWidth-1:0] data [0:`FilterSize-1][0:`FilterSize-1];
wire [DataBitWidth*`FilterSize*`FilterSize-1:0] buffer_data;

wire rst_out;
assign rst_out = rst;

wire en_out;
assign en_out = en;

genvar i,j,n;
generate
for ( i=0; i<=`FilterSize-1; i=i+1)
     begin
     for ( j=0; j<= `FilterSize-1; j=j+1)
	       begin
			 assign coeff[i][j] = f_coeff[i*(`FilterSize*`FilterBitWidth)+j*`FilterBitWidth+`FilterBitWidth-1:
              			           i*(`FilterSize*`FilterBitWidth)+j*`FilterBitWidth];
          assign data[i][j] =	buffer_data[i*(`FilterSize*DataBitWidth)+j*DataBitWidth+DataBitWidth-1:
              			           i*(`FilterSize*DataBitWidth)+j*DataBitWidth];									  
	       end
	  end
endgenerate

generate

for (j=0;j<=`FilterSize-1;j=j+1)
     begin :buffer
	  buffer1d b(clk,rst_out,en_out,state[j],d_in,buffer_data[j*(DataBitWidth*`FilterSize)+DataBitWidth*`FilterSize-1:
	                                                          j*(DataBitWidth*`FilterSize)]);
	  end
endgenerate

always @ (posedge clk)
if (rst) 
    begin
	 state <= 1;
	 end
else
    if (en)
	     begin
		  state<={state[`FilterSize-2:0],state[`FilterSize-1]};
		  end
    


endmodule
