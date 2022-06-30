`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:07:02 06/29/2022
// Design Name:   buffer
// Module Name:   C:/Users/user3/Downloads/Documents/convolution_2/buffer_tb.v
// Project Name:  convolution_2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: buffer
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module buffer_tb;

	// Inputs
	reg clk;
	reg rst;
	reg en;
	reg [199:0] f_coeff;
	reg [11:0] d_in;

	// Outputs
	wire [11:0] d_out;

	// Instantiate the Unit Under Test (UUT)
	buffer uut (
		.clk(clk), 
		.rst(rst), 
		.en(en), 
		.f_coeff(f_coeff), 
		.d_in(d_in), 
		.d_out(d_out)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		en = 0;
		f_coeff = 100'h010203040506070809;
		d_in = 0;

		// Wait 100 ns for global reset to finish
		#20;
      rst = 0;  
		// Add stimulus here

	end
always #10 
begin 
clk=~clk;
end      
endmodule

