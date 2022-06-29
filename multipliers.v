`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:07:37 05/19/2022 
// Design Name: 
// Module Name:    multipliers 
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
module multipliers(
input [7:0] a,b,
output [15:0] out,out1
    );
wire signed [7:0] m1,m2;
assign m1=a;
assign m2=b;

assign out1=m1*m2;
assign out=a*b;

endmodule
