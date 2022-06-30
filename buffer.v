`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:14:51 05/07/2022 
// Design Name: 
// Module Name:    buffer 
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
`define FilterBitWidth 8
`define FilterSize 5
module buffer
#(parameter DataBitWidth=12)
(
input clk,rst,en,
input [`FilterSize*`FilterSize*`FilterBitWidth-1:0] f_coeff,
input signed [DataBitWidth-1:0] d_in,
output signed [DataBitWidth-1:0] d_out
    );

reg signed [DataBitWidth-1:0] mem1 [0:`FilterSize*`FilterSize-1];
reg [`FilterSize-1:0] state;


assign d_out=-1*mem1[16]+-2*mem1[17]+-1*mem1[18]+mem1[6]+2*mem1[7]+mem1[8];

wire [`FilterBitWidth-1:0] coeff [0:`FilterSize-1][0:`FilterSize-1];

// saving coefficients
genvar i,j,n;
generate
for ( i=0; i<=`FilterSize-1; i=i+1)
     begin 
	  for ( j=0; j<=`FilterSize-1; j=j+1)
	       begin 
			 assign coeff[i][j] = f_coeff[i*(`FilterSize*`FilterBitWidth)+j*`FilterBitWidth+`FilterBitWidth-1:
              			           i*(`FilterSize*`FilterBitWidth)+j*`FilterBitWidth];
			 end
	  end
endgenerate		
			 

integer k;

always @(posedge clk)
if (rst)
    begin
	 state<=`SerialInit;
	 for ( k=0;k<=`FilterSize*`FilterSize-1;k=k+1)
         begin
			mem1[k]<=0;
			end
	 end
else 
    if(en)
	    begin
		 state<={state[`FilterSize-2:0],state[`FilterSize-1]};
      
					  if (state[0]==1)
							begin
							mem1[4]<=d_in;
							mem1[3]<=mem1[4];
							mem1[2]<=mem1[3];
							mem1[1]<=mem1[2];
							mem1[0]<=mem1[1];
							end
				else if (state[1])
				         begin
							mem1[9]<=d_in;
							mem1[8]<=mem1[9];
							mem1[7]<=mem1[8];
							mem1[6]<=mem1[7];
							mem1[5]<=mem1[6];
							end
				else if (state[2])
				         begin
							mem1[14]<=d_in;
							mem1[13]<=mem1[14];
							mem1[12]<=mem1[13];
							mem1[11]<=mem1[12];
							mem1[10]<=mem1[11];
							end
				else if (state[3])
				         begin
							mem1[19]<=d_in;
							mem1[18]<=mem1[19];
							mem1[17]<=mem1[18];
							mem1[16]<=mem1[17];
							mem1[15]<=mem1[16];
							end
				else if (state[4])
				         begin
							mem1[24]<=d_in;
							mem1[23]<=mem1[24];
							mem1[22]<=mem1[23];
							mem1[21]<=mem1[22];
							mem1[20]<=mem1[21];
							end
					
	    end

endmodule
