`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:50:30 06/30/2022 
// Design Name: 
// Module Name:    buffer1d 
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
module buffer1d
#(parameter DataBitWidth=12, parameter BufferSize=5,parameter CoeffBitWidth=8)
(
input clk,rst,en,shift,
//input [BufferSize*CoeffBitWidth-1:0] coeff,
input signed [DataBitWidth-1:0] d_in,
//output signed [DataBitWidth-1:0] d_out
output signed [BufferSize*DataBitWidth-1:0] d_out
);
reg signed [DataBitWidth-1:0] inp_mem [0:BufferSize-1];
//wire [CoeffBitWidth-1:0] coeff_mem [0:BufferSize-1];

genvar i,j,n;
generate
for ( i=0; i<=BufferSize-1; i=i+1)
     begin 
	  //assign coeff[i][j] = coeff[i*CoeffBitWidth+CoeffBitWidth-1:i*CoeffBitWidth];
	  assign d_out[i*DataBitWidth+DataBitWidth-1:i*DataBitWidth]=inp_mem[i];
	  end
endgenerate	

integer k;
always @(posedge clk)
if (rst)
    begin
	 for ( k=0;k<=BufferSize-1;k=k+1)
         begin
			inp_mem[k]<=0;
			end
	 end
else
     if (en)
	      begin
			if (shift)
			    begin
				 inp_mem[BufferSize-1]<=d_in;
				 for (k=0;k<=BufferSize-2;k=k+1)
				      inp_mem[k]=inp_mem[k+1];
				 end
			end
						
	 

endmodule
