
module Motor_Speed(

	input iClk,
	input iRst_n,
	input [1:0] iKey,
	input [1:0] iSW,
	output reg [7:0] oAngle
	);
	
	`define AdjAngle 1
	`define MAX_Angle 180
	`define MIN_Angle 0
	
	initial
	begin
		oAngle <= 8'd90;
	end
	
	reg [21:0] count;
	
	always @ (posedge iClk or negedge iRst_n)
	begin
		if (!iRst_n)
		begin
			oAngle <= 8'd60;
			count <= 0;
		end
		else
		begin
			case(iKey)
				2'b10:
				begin
					if (count[21] & (oAngle != `MAX_Angle))
					begin
						count <= 0;
						oAngle <= oAngle + `AdjAngle;
					end
					else
						count <= count + iSW + 1;
				end
				2'b01:
				begin
					if (count[21] & (oAngle != `MIN_Angle))
					begin
						count <= 0;
						oAngle <= oAngle - `AdjAngle;
					end
					else
						count <= count + iSW + 1;
				end
				default: count <= 0;
			endcase
		end
	end
	
endmodule
	