`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:48:04 05/18/2022 
// Design Name: 
// Module Name:    line_buffer 
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
module line_buffer(
input clk,rst,en,
input [11:0] d_in,
output [11:0] d_out
    );
reg [11:0] mem [8:0];
integer i;
assign d_out=mem[8]+mem[7]+mem[6]+mem[5]+mem[4]+mem[3]+mem[2]+mem[1]+mem[0];

always @(posedge clk)
if (rst)
    begin
	 for ( i=0;i<=8;i=i+1)
         mem[i]<=0;
	 end
else 
    if(en)
       begin
       mem[8]<=d_in;
		 for ( i=0;i<=7;i=i+1)
            mem[i]<=mem[i+1];
					
	    end

endmodule
