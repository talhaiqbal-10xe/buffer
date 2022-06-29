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
module buffer
#(parameter DataBitWidth=4, parameter ExtraBits=3,
  parameter Channels=3)
(
input clk,rst,en,
input signed [DataBitWidth*Channels-1:0] d_in,
output [DataBitWidth*Channels-1:0] d_out
    );
integer i;
reg signed [DataBitWidth+ExtraBits-1:0] mem1 [8:0];
reg signed [DataBitWidth+ExtraBits-1:0] mem2 [8:0];
reg signed [DataBitWidth+ExtraBits-1:0] mem3 [8:0];

wire signed [DataBitWidth-1:0] out1,out2,out3;

assign out1=-1*mem1[8]+-2*mem1[7]+-1*mem1[6]+mem1[2]+2*mem1[1]+mem1[0]+0*mem1[5]+0*mem1[4]+0*mem1[3];
assign out2=-1*mem2[8]+-2*mem2[7]+-1*mem2[6]+mem2[2]+2*mem2[1]+mem2[0]+0*mem2[5]+0*mem2[4]+0*mem2[3];
assign out3=-1*mem3[8]+-2*mem3[7]+-1*mem3[6]+mem3[2]+2*mem3[1]+mem3[0]+0*mem3[5]+0*mem3[4]+0*mem3[3];




assign d_out[DataBitWidth-1:0]= out1<0 ? 0: out1>15 ? 15: out1[DataBitWidth-1:0];
assign d_out[2*DataBitWidth-1:DataBitWidth]= out2<0 ? 0: out2>15 ? 15: out2[DataBitWidth-1:0];
assign d_out[3*DataBitWidth-1:2*DataBitWidth]= out3<0 ? 0: out3>15 ? 15: out3[DataBitWidth-1:0];

reg [2:0] state;
always @(posedge clk)
if (rst)
    begin
	 state<=3'b001;
	 for ( i=0;i<=8;i=i+1)
         begin
			mem1[i]<=0;
			mem2[i]<=0;
			mem3[i]<=0;
			end
	 end
else 
    if(en)
	    begin
		 state<={state[1:0],state[2]};
      
            if (state[0]==1)
				    begin
						mem1[2][DataBitWidth+ExtraBits-1:0]<=d_in[DataBitWidth-1:0];
						mem1[1][DataBitWidth+ExtraBits-1:0]<=mem1[2];
						mem1[0][DataBitWidth+ExtraBits-1:0]<=mem1[1];
						
						mem2[2][DataBitWidth+ExtraBits-1:0]<=d_in[2*DataBitWidth-1:DataBitWidth];
						mem2[1][DataBitWidth+ExtraBits-1:0]<=mem2[2];
						mem2[0][DataBitWidth+ExtraBits-1:0]<=mem2[1];
						
						mem3[2][DataBitWidth+ExtraBits-1:0]<=d_in[3*DataBitWidth-1:2*DataBitWidth];
						mem3[1][DataBitWidth+ExtraBits-1:0]<=mem3[2];
						mem3[0][DataBitWidth+ExtraBits-1:0]<=mem3[1];
						
				    end
				else if (state[1])
				         begin
							mem1[5][DataBitWidth*Channels-1:0]<=d_in[DataBitWidth*Channels-1:0];
							mem1[4][DataBitWidth*Channels-1:0]<=mem1[5];
							mem1[3][DataBitWidth*Channels-1:0]<=mem1[4];
							
							mem2[5][DataBitWidth*Channels-1:0]<=d_in[2*DataBitWidth-1:DataBitWidth];
							mem2[4][DataBitWidth*Channels-1:0]<=mem2[5];
							mem2[3][DataBitWidth*Channels-1:0]<=mem2[4];
							
							
							mem3[5][DataBitWidth*Channels-1:0]<=d_in[3*DataBitWidth-1:2*DataBitWidth];
							mem3[4][DataBitWidth*Channels-1:0]<=mem3[5];
							mem3[3][DataBitWidth*Channels-1:0]<=mem3[4];
							end
				else
							begin			
							mem1[8][DataBitWidth*Channels-1:0]<=d_in[DataBitWidth*Channels-1:0];
							mem1[7][DataBitWidth*Channels-1:0]<=mem1[8];
							mem1[6][DataBitWidth*Channels-1:0]<=mem1[7];
							
							mem2[8][DataBitWidth*Channels-1:0]<=d_in[2*DataBitWidth-1:DataBitWidth];
							mem2[7][DataBitWidth*Channels-1:0]<=mem2[8];
							mem2[6][DataBitWidth*Channels-1:0]<=mem2[7];
							
							
							mem3[8][DataBitWidth*Channels-1:0]<=d_in[3*DataBitWidth-1:2*DataBitWidth];
							mem3[7][DataBitWidth*Channels-1:0]<=mem3[8];
							mem3[6][DataBitWidth*Channels-1:0]<=mem3[7];
							end
					
	    end

endmodule
