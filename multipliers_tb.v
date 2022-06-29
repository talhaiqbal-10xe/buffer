`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:18:21 05/19/2022
// Design Name:   multipliers
// Module Name:   C:/Users/user3/Downloads/Documents/convolution_2/multipliers_tb.v
// Project Name:  convolution_2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: multipliers
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module multipliers_tb;

	// Inputs
	reg [7:0] a;
	reg [7:0] b;

	// Outputs
	wire [15:0] out;
	wire [15:0] out1;

	// Instantiate the Unit Under Test (UUT)
	multipliers uut (
		.a(a), 
		.b(b), 
		.out(out), 
		.out1(out1)
	);

	initial begin
		// Initialize Inputs
		a = 255;
		b = 1;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

