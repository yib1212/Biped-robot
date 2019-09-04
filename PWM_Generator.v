
// Generate the PWM signal by comparing upcounter with the threshold

module PWM_Generator(

	input	clk,
	input	reset_n,
	input	[31:0] high_dur,
	input	[31:0] total_dur,
	output reg PWM
	);
	
	reg [31:0] tick;
	
	// 'tick' is a counter for the duty circle
	// 'total_dur' is a threshold for the duty circle
	always @ (posedge clk or negedge reset_n)
	begin
		if (~reset_n)
			tick <= 0;
		else if (tick >= total_dur)
			tick <= 0;
		else
			tick <= tick + 1;
	end
	
	// If the counter smaller than the threshold, set high voltage, 
	// if the counter larger than the threshold, set low voltage. 
	always @ (posedge clk or negedge reset_n)
	begin
		if (~reset_n)
			PWM <= 0;
		else
			PWM <= (tick < high_dur) ? 1'b1 : 1'b0;
	end
	
endmodule
