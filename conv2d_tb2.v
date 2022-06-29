`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:25:07 05/18/2022
// Design Name:   conv2d
// Module Name:   C:/Users/user3/Downloads/Documents/convolution_2/conv2d_tb2.v
// Project Name:  convolution_2
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

module conv2d_tb2;

	// Inputs
	reg clk;
	reg rst;
	reg start;
	reg [11:0] d_in;

	// Outputs
	wire [16:0] ReadAddress;
	wire [16:0] WriteAddress;
	wire [11:0] d_out;
	wire ready;

	// Instantiate the Unit Under Test (UUT)
	conv2d uut (
		.clk(clk), 
		.rst(rst), 
		.start(start), 
		.d_in(d_in), 
		.ReadAddress(ReadAddress), 
		.WriteAddress(WriteAddress), 
		.d_out(d_out), 
		.ready(ready)
	);
reg [11:0] mem [0:50*50-1];
reg [11:0] mem_out [0:50*50-1];

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		start = 0;
		
		$readmemb("input_image.mem", mem);

		// Wait 100 ns for global reset to finish
		#20;
		rst=0;
		start=1;
      #20;
		start=0;
		// Add stimulus here

	end

always #10
begin
clk=~clk;
end   
always @(*) 
d_in = mem[ReadAddress[4:0]];
endmodule

