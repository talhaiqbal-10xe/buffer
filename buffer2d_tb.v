`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:49:07 06/30/2022
// Design Name:   buffer_2d
// Module Name:   C:/Users/user3/Downloads/Documents/convolution_2/buffer2d_tb.v
// Project Name:  convolution_2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: buffer_2d
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module buffer2d_tb;

	// Inputs
	reg clk;
	reg rst;
	reg en;
	reg [199:0] f_coeff;
	reg [11:0] d_in;

	// Outputs
	wire [11:0] d_out;

	// Instantiate the Unit Under Test (UUT)
	buffer_2d uut (
		.clk(clk), 
		.rst(rst), 
		.en(en), 
		.f_coeff(f_coeff), 
		.d_in(d_in), 
		.d_out(d_out)
	);
   integer i;
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		en = 0;
		f_coeff = 200'h00000000000001020100000000000000fffeff000000000000;
		d_in = 0;

		#20;
		rst=0;
		en=1;
		for (i=0;i<25;i=i+1)
		     begin
			  d_in=i;
		     #20;
			  end
	   
		en=0;
//		#20 
//		en=1;
//		for (i=0;i<5;i=i+1)
//		     begin
//			  d_in=i+5;
//		     #20; 
//			  end
        
		 //Add stimulus here

	end

always #10 
begin 
clk=~clk;
end  

endmodule

