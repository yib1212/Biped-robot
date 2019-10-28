
module rotary_encoder(
	input clk,
	input quadA,
	input quadB,
	input reset,
	input [7:0] speed,
	output [63:0] measangle,
	output wire [7:0] angle
	
	);
	reg [7:0] Oled = 8'b0;
	reg [11:0] regangle;
	reg [2:0] quadA_delayed, quadB_delayed;
	
	
	wire [3:0] oneth;
	wire [3:0] tenth;
	wire [3:0] hundredth;
	
	wire [3:0] oneth_speed;
	wire [3:0] tenth_speed;
	wire [3:0] hundredth_speed;
	
	wire [7:0] oneth_output;
	wire [7:0] tenth_output;
	wire [7:0] hundredth_output;
	
	wire [7:0] oneth_output_speed;
	wire [7:0] tenth_output_speed;
	wire [7:0] hundredth_output_speed;
	
	always @(posedge clk)
	begin
		quadA_delayed <= {quadA_delayed[1:0], quadA};
		quadB_delayed <= {quadB_delayed[1:0], quadB};
		if (!reset)
			Oled <= 8'd100;
		else if (quadA_delayed[2:1] == 2'b01 && quadB_delayed[1] == 1'b1)
			Oled <= Oled + 1;
		else if (quadA_delayed[2:1] == 2'b01 && quadB_delayed[1] == 1'b0)
			Oled <= Oled - 1;
		else
			Oled <= Oled;
		regangle <= Oled;
	end
	
	assign angle = regangle * 9 / 10;
	assign oneth = angle %10;
	assign tenth = (angle%100)/10;
	assign hundredth = angle/100;
	
	

	
	
	//assign measangle = {8'h29, angle, 8'h41, 8'h6E,8'h67,8'h6C, 8'h65, 8'h28};
	//assign measangle = {oneth_output, tenth_output, hundredth_output, angle,8'h6C,8'h67, 8'h6E, 8'h41};

	assign measangle = {oneth_output_speed, tenth_output_speed, hundredth_output_speed,8'h7c, 8'h7c, oneth_output, tenth_output, hundredth_output};
	
	
	assign oneth_speed = speed %10;
	assign tenth_speed = (speed%100)/10;
	assign hundredth_speed = speed/100;
	
	ascii_encoder ascii_angle_one(
		.clk(clk),
		.num(oneth),
		.num_ascii(oneth_output),
		);

ascii_encoder ascii_angle_ten(
		.clk(clk),
		.num(tenth),
		.num_ascii(tenth_output),
		);

	ascii_encoder ascii__angle_hundred(
		.clk(clk),
		.num(hundredth),
		.num_ascii(hundredth_output),
		);
	
		
	ascii_encoder ascii_one(
		.clk(clk),
		.num(oneth_speed),
		.num_ascii(oneth_output_speed),
		);

	ascii_encoder ascii_ten(
		.clk(clk),
		.num(tenth_speed),
		.num_ascii(tenth_output_speed),
		);

		ascii_encoder ascii_hundred(
		.clk(clk),
		.num(hundredth_speed),
		.num_ascii(hundredth_output_speed),
		);

endmodule