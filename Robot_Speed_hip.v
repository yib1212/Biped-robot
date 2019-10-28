module Robot_Speed_hip(

	input iClk,
	input iRst_n,
	input [1:0] iKey,
	input [1:0] iSW,
	input [7:0] iAngle,
	input [7:0] angle,
	output reg [7:0] oAngle,
	output reg flag
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
			
			oAngle <= 8'd90;
			count <= 0;
		end
		else
		begin
		
			if (iAngle > angle)
			begin
				flag <= 0;
				if (count[21] & (angle != iAngle))
				begin
					count <= 0;
					oAngle <= oAngle + `AdjAngle;
				end
				else
					count <= count + iSW + 1;
			end
				
			else if (iAngle < angle)
			begin
				flag <= 0;
				if (count[21] & (angle != iAngle))
				begin
					count <= 0;
					oAngle <= oAngle - `AdjAngle;
				end
				else
					count <= count + iSW + 1;
			end
				
			else
			begin
				count <= 0;
				flag <= 1;
			end
		end
	end
	
endmodule
