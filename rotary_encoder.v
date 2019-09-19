
module rotary_encoder(
	input clk,
	input quadA,
	input quadB,
	output reg [7:0] LED = 8'b0
	);
	
	reg [2:0] quadA_delayed, quadB_delayed;

	wire count_direction = quadA_delayed[1] ^ quadB_delayed[2];
	always @(posedge clk)
	begin
		quadA_delayed <= {quadA_delayed[1:0], quadA};
		quadB_delayed <= {quadB_delayed[1:0], quadB};
		if (quadA_delayed[2:1] == 2'b01 && quadB_delayed[1] == 1'b1)
			LED <= LED + 1;
		else if (quadA_delayed[2:1] == 2'b01 && quadB_delayed[1] == 1'b0)
			LED <= LED - 1;
		else
			LED <= LED;
	end
	
endmodule