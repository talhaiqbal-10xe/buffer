`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:35:30 06/30/2022
// Design Name:   buffer1d
// Module Name:   C:/Users/user3/Downloads/Documents/convolution_2/buffer1d_tb.v
// Project Name:  convolution_2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: buffer1d
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module buffer1d_tb;

	// Inputs
	reg clk;
	reg rst;
	reg en;
	reg shift;
	reg [11:0] d_in;

	// Outputs
	wire [59:0] d_out;

	// Instantiate the Unit Under Test (UUT)
	buffer1d uut (
		.clk(clk), 
		.rst(rst), 
		.en(en), 
		.shift(shift), 
		.d_in(d_in), 
		.d_out(d_out)
	);
integer i;
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		en = 0;
		shift = 0;
		d_in = 0;

		// Wait 100 ns for global reset to finish
		#20;
		rst=0;
		en=1;
		shift=1;
		for (i=0;i<5;i=i+1)
		     begin
			  d_in=i;
		     #20;
			  end
	   
		shift =0;
		#20
		shift=1;
		for (i=0;i<5;i=i+1)
		     begin
			  d_in=i+5;
		     #20; 
			  end
        
		// Add stimulus here

	end

always #10 
begin 
clk=~clk;
end  

      
endmodule

