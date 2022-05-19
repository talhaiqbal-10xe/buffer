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
input [DataBitWidth*Channels-1:0] d_in,
output [DataBitWidth*Channels-1:0] d_out
    );
integer i;
reg signed [DataBitWidth+ExtraBits-1:0] mem1 [8:0];
reg signed [DataBitWidth+ExtraBits-1:0] mem2 [8:0];
reg signed [DataBitWidth+ExtraBits-1:0] mem3 [8:0];

wire signed [DataBitWidth+ExtraBits-1:0] out1,out2,out3;

assign out1=mem1[8]*-1+mem1[7]*-2+mem1[6]*-1+mem1[2]+mem1[1]*2+mem1[0];
assign out2=mem2[8]*-1+mem2[7]*-2+mem2[6]*-1+mem2[2]+mem2[1]*2+mem2[0];
assign out3=mem3[8]*-1+mem3[7]*-2+mem3[6]*-1+mem3[2]+mem3[1]*2+mem3[0];

assign d_out[DataBitWidth-1:0]= out1<0 ? 0: out1>15 ? 15: out1[DataBitWidth-1:0];
assign d_out[2*DataBitWidth-1:DataBitWidth]= out2<0 ? 0: out2>15 ? 15: out2[DataBitWidth-1:0];
assign d_out[3*DataBitWidth-1:2*DataBitWidth]= out3<0 ? 0: out3>15 ? 15: out3[DataBitWidth-1:0];

always @(posedge clk)
if (rst)
    begin
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
       mem1[8][DataBitWidth-1:0]<=d_in[DataBitWidth-1:0];
		 mem2[8][DataBitWidth-1:0]<=d_in[2*DataBitWidth-1:DataBitWidth];
		 mem3[8][DataBitWidth-1:0]<=d_in[3*DataBitWidth-1:2*DataBitWidth];
		 for ( i=0;i<=7;i=i+1)
            begin
				mem1[i][DataBitWidth-1:0]<=mem1[i+1];
				mem2[i][DataBitWidth-1:0]<=mem2[i+1];
				mem3[i][DataBitWidth-1:0]<=mem3[i+1];
				end
				
					
	    end

endmodule
