
module ascii_encoder(
	input clk,
	input [3:0] num,
	output reg [7:0] num_ascii
	);
	
	
	always @(posedge clk) begin
		case (num)
			4'd0: num_ascii <= 8'd48;  // 0 
			4'd1: num_ascii <= 8'd49;  // 1
			4'd2: num_ascii <= 8'd50;  // 2 
			4'd3: num_ascii <= 8'd51;  // 3 
			4'd4: num_ascii <= 8'd52;  // 4 
			4'd5: num_ascii <= 8'd53;  // 5 
			4'd6: num_ascii <= 8'd54;  // 6 
			4'd7: num_ascii <= 8'd55;  // 7 
			4'd8: num_ascii <= 8'd56;  // 8
			4'd9: num_ascii <= 8'd57;  // 9
			default: num_ascii <= 8'd32; // ' '
		endcase 
	end
endmodule