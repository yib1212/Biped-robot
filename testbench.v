`timescale 1ns / 100ps
`define clk_cycle 50

module testbench;

	reg clk;
	wire [3:0] LED;
	wire [35:0] GPIO_1;
	wire [5:0] flag1;

	always  #`clk_cycle clk = ~clk;

	initial
	begin
		clk = 0;
		//#100000 $stop;
	end
	
	major_project m0(.FPGA_CLK1_50(clk),.LED(LED),.GPIO_1(GPIO_1),.flag1(flag1));

endmodule