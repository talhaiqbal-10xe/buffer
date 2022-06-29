`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:20:12 05/19/2022
// Design Name:   conv2d
// Module Name:   C:/Users/user3/Downloads/Documents/convolution_2/test_bench_3.v
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

module test_bench_3;

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
	wire WriteEnable;

	// Instantiate the Unit Under Test (UUT)
	conv2d uut (
		.clk(clk), 
		.rst(rst),  
		.start(start), 
		.d_in(d_in), 
		.ReadAddress(ReadAddress), 
		.WriteAddress(WriteAddress), 
		.d_out(d_out), 
		.ready(ready), 
		.WriteEnable(WriteEnable)
	);

	reg [11:0] source_mem [0:24];
	reg [11:0] destination_mem [0:24];
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		start = 0;
		
		$readmemh("test_image.mem", source_mem);
		$readmemb("out_image.mem", destination_mem);


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
d_in = source_mem[ReadAddress[4:0]];   
always @(posedge WriteEnable) 
destination_mem[WriteAddress[4:0]]=d_out;   
endmodule
