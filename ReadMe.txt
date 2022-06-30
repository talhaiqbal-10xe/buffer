This code can perform 2D convolution on an array/image.

It uses a buffer to get a 5x5 patch from the image stored in a 1D memory in a row wise fasion.

The filter applied to the patch is configured in 'buffer.v' module. 

In order to verify the design, a matlab script 'image_generator.m' which generates a random 
50x50 array and applies a filter on it. The script generates a file 'input_image.mem' which
is used in the testbench named as 'test_bench0626'. The script also generates 'output_image_matlab.txt' file which contains the 
output of the convolution peformed in MATLAB.

The verilog testbench also generates an output file named as 'out_imag_verilog.txt'. Another testbench named as 'comparator'
is used to match the outputs from both sources. The signal 't' in the testbench is logically high in case of the match.

