`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:20:44 05/17/2022
// Design Name:   conv2d
// Module Name:   C:/Users/user3/Downloads/Documents/convolution/conv2d_tb.v
// Project Name:  convolution
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: conv2d
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module conv2d_tb;

	// Inputs
	reg clk;
	reg rst;
	reg start;
	reg [11:0] d_in;

	// Outputs
	wire [16:0] addr_rd;
	wire [16:0] addr_wr;
	wire [11:0] d_out;
	wire ready;
   
	
	reg [11:0] mem [0:24];

	// Instantiate the Unit Under Test (UUT)
	conv2d uut (
		.clk(clk), 
		.rst(rst), 
		.start(start), 
		.d_in(d_in),  
		.addr_rd(addr_rd), 
		.addr_wr(addr_wr), 
		.d_out(d_out), 
		.ready(ready)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		start = 0;
		
		$readmemb("test_image.mem", mem);

		// Wait 100 ns for global reset to finish
		#20;
		rst=0;
		start=1;
        
		// Add stimulus here

	end

always #10
begin
clk=~clk;
end   
always @(*) 
d_in = mem[addr_rd];   
endmodule

