`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:17:44 06/29/2022
// Design Name:   conv2d
// Module Name:   C:/Users/user3/Downloads/Documents/convolution_2/test_bench0629.v
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

module test_bench0629;

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

	reg [11:0] mem [0:50*50-1];
   reg [11:0] mem_out [0:50*50-1];
	
   
   integer outfile0,i;

	
		initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		start = 0;
		
		outfile0=$fopen("out_image_verilog.txt","w");
		$readmemb("input_image.mem", mem);
		
		// Wait 100 ns for global reset to finish
		#20;
		rst=0;
		start=1;
      #20;
		start=0;
		// Add stimulus here
		#280550
		for (i=0;i<=50*50-1;i=i+1)
		begin
		$fwrite(outfile0,"%b\n",mem_out[i]);
		#5;
		end
		#5;
		$fclose(outfile0);

	end

always #10 
begin 
clk=~clk;
end    
always @(*) 
d_in = mem[ReadAddress];

always @(WriteEnable)
begin
mem_out[WriteAddress]=d_out;
end

      
endmodule

