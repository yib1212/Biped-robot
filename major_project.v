module major_project(

	input FPGA_CLK1_50,
	output [3:0] LED,
	output [5:0] flag1,
	inout [35:0] GPIO_1
	);
	
	reg [6:0] cnt;
	reg clk_slow;
	always @ (posedge FPGA_CLK1_50)
	begin
		cnt <= cnt + 1;
		if (cnt == 7'b1111111)
			clk_slow <= ~clk_slow;
	end
	
	/////////////////////////////////////////////////////////////////////////
	///////////////////////////   17/08/1029   //////////////////////////////
	/////////////////////////////////////////////////////////////////////////
	
	`define DUR_CLOCK_NUM 50000000/50            // clock count in 20 ms
	`define DEGREE_MAX `DUR_CLOCK_NUM*25/200     // 2.5 ms 125000
	`define DEGREE_MIN `DUR_CLOCK_NUM*5/200      // 0.5 ms 25000
		
	wire [5:0] flag;         // All six joints finish their state
	reg [3:0] state = 4'd11;  // State register
	reg [1:0] KEY = 0;
	reg [3:0] SW = 0;
	reg [7:0] iAngle_l1, iAngle_l2, iAngle_l3, iAngle_r1, iAngle_r2, iAngle_r3;
	wire [7:0] oAngle_l1, oAngle_l2, oAngle_l3, oAngle_r1, oAngle_r2, oAngle_r3;
	wire [31:0] PwmAngle_l1, PwmAngle_l2, PwmAngle_l3, PwmAngle_r1, PwmAngle_r2, PwmAngle_r3;
	wire RESET_N;
	wire Pwm_l1, Pwm_l2, Pwm_l3, Pwm_r1, Pwm_r2, Pwm_r3;
	
	assign RESET_N = 1;
	assign LED = state;
	assign flag1 = flag;
	
	always @ (posedge FPGA_CLK1_50)
	begin
		if (flag == 6'b111111)
		begin
			case(state)
				4'd1: state <= 4'd2;
				4'd2: state <= 4'd3;
				4'd3: state <= 4'd4;
				4'd4: state <= 4'd5;
				4'd5: state <= 4'd2;
				4'd6: state <= 4'd1;
				
				4'd7: state <= 4'd8;
				4'd8: state <= 4'd9;
				4'd9: state <= 4'd7;
				4'd10: state <= 4'd7;
				
				4'd11: state <= 4'd12;
				4'd12: state <= 4'd13;
				4'd13: state <= 4'd11;
				4'd14: state <= 4'd11;
				default: state <= state;
			endcase
		end
		else
			state <= state;
	end
	
	always @ (*)
	begin
		case(state)
			4'd0: begin
						iAngle_l1 <= 8'd90;
						iAngle_l2 <= 8'd90;
						iAngle_l3 <= 8'd90;
						iAngle_r1 <= 8'd90;
						iAngle_r2 <= 8'd90;
						iAngle_r3 <= 8'd90;
					end
			// Forward
			4'd1: begin
						iAngle_l1 <= 8'd60;
						iAngle_l2 <= 8'd90;
						iAngle_l3 <= 8'd90;
						iAngle_r1 <= 8'd60;
						iAngle_r2 <= 8'd90;
						iAngle_r3 <= 8'd90;
					end
			4'd2: begin
						iAngle_l1 <= 8'd70;
						iAngle_l2 <= 8'd110;
						iAngle_l3 <= 8'd110;
						iAngle_r1 <= 8'd70;
						iAngle_r2 <= 8'd90;
						iAngle_r3 <= 8'd110;
					end
			4'd3: begin
						iAngle_l1 <= 8'd90;
						iAngle_l2 <= 8'd110;
						iAngle_l3 <= 8'd110;
						iAngle_r1 <= 8'd90;
						iAngle_r2 <= 8'd90;
						iAngle_r3 <= 8'd110;
						    
					end
			4'd4: begin
						iAngle_l1 <= 8'd110;
						iAngle_l2 <= 8'd90;
						iAngle_l3 <= 8'd70;
						iAngle_r1 <= 8'd110;
						iAngle_r2 <= 8'd70;
						iAngle_r3 <= 8'd70;
					end
			4'd5: begin
						iAngle_l1 <= 8'd90;
						iAngle_l2 <= 8'd90; 
						iAngle_l3 <= 8'd70;
						iAngle_r1 <= 8'd90;
						iAngle_r2 <= 8'd70;
						iAngle_r3 <= 8'd70;
					end
			4'd6: begin
						iAngle_l1 <= 8'd90;
						iAngle_l2 <= 8'd90;
						iAngle_l3 <= 8'd90;
						iAngle_r1 <= 8'd90;
						iAngle_r2 <= 8'd90;
						iAngle_r3 <= 8'd90;
					end
			// right
			4'd7: begin
						iAngle_l1 <= 8'd90;
						iAngle_l2 <= 8'd60;
						iAngle_l3 <= 8'd60;
						iAngle_r1 <= 8'd100;
						iAngle_r2 <= 8'd60;
						iAngle_r3 <= 8'd60;
					end
			4'd8: begin
						iAngle_l1 <= 8'd80;
						iAngle_l2 <= 8'd120;
						iAngle_l3 <= 8'd120;
						iAngle_r1 <= 8'd80;
						iAngle_r2 <= 8'd120;
						iAngle_r3 <= 8'd120;
					end
			4'd9: begin
						iAngle_l1 <= 8'd90;
						iAngle_l2 <= 8'd90;
						iAngle_l3 <= 8'd90;
						iAngle_r1 <= 8'd90;
						iAngle_r2 <= 8'd90;
						iAngle_r3 <= 8'd90;
					end
			4'd10: begin
						iAngle_l1 <= 8'd90;
						iAngle_l2 <= 8'd90;
						iAngle_l3 <= 8'd90;
						iAngle_r1 <= 8'd90;
						iAngle_r2 <= 8'd90;
						iAngle_r3 <= 8'd90;
					end
			// left
			4'd11: begin
						iAngle_l1 <= 8'd80;
						iAngle_l2 <= 8'd120;
						iAngle_l3 <= 8'd120;
						iAngle_r1 <= 8'd90;
						iAngle_r2 <= 8'd120;
						iAngle_r3 <= 8'd120;
					end
			4'd12: begin
						iAngle_l1 <= 8'd100;
						iAngle_l2 <= 8'd60;
						iAngle_l3 <= 8'd60;
						iAngle_r1 <= 8'd100;
						iAngle_r2 <= 8'd60;
						iAngle_r3 <= 8'd60;
					end
			4'd13: begin
						iAngle_l1 <= 8'd90;
						iAngle_l2 <= 8'd90;
						iAngle_l3 <= 8'd90;
						iAngle_r1 <= 8'd90;
						iAngle_r2 <= 8'd90;
						iAngle_r3 <= 8'd90;
					end
			4'd14: begin
						iAngle_l1 <= 8'd90;
						iAngle_l2 <= 8'd90;
						iAngle_l3 <= 8'd90;
						iAngle_r1 <= 8'd90;
						iAngle_r2 <= 8'd90;
						iAngle_r3 <= 8'd90;
					end
			default: begin
							iAngle_l1 <= iAngle_l1;
							iAngle_l2 <= iAngle_l2;
							iAngle_l3 <= iAngle_l3;
							iAngle_r1 <= iAngle_r1;
							iAngle_r2 <= iAngle_r2;
							iAngle_r3 <= iAngle_r3;
						end
		endcase
	end
	
	assign PwmAngle_l1 = (((`DEGREE_MAX - `DEGREE_MIN)/180)*oAngle_l1)+`DEGREE_MIN;
	assign PwmAngle_l2 = (((`DEGREE_MAX - `DEGREE_MIN)/180)*oAngle_l2)+`DEGREE_MIN;
	assign PwmAngle_l3 = (((`DEGREE_MAX - `DEGREE_MIN)/180)*oAngle_l3)+`DEGREE_MIN;
	assign PwmAngle_r1 = (((`DEGREE_MAX - `DEGREE_MIN)/180)*oAngle_r1)+`DEGREE_MIN;
	assign PwmAngle_r2 = (((`DEGREE_MAX - `DEGREE_MIN)/180)*oAngle_r2)+`DEGREE_MIN;
	assign PwmAngle_r3 = (((`DEGREE_MAX - `DEGREE_MIN)/180)*oAngle_r3)+`DEGREE_MIN;
	
	assign GPIO_1[0] = Pwm_l1;
	assign GPIO_1[2] = Pwm_l2;
	assign GPIO_1[4] = Pwm_l3;
	assign GPIO_1[6] = Pwm_r1;
	assign GPIO_1[8] = Pwm_r2;
	assign GPIO_1[10] = Pwm_r3;
	
	Robot_Speed speed_l1 (.iClk(FPGA_CLK1_50),.iRst_n(RESET_N),.iKey(KEY[1:0]),.iSW(SW[1:0]),.iAngle(iAngle_l1),.oAngle(oAngle_l1),.flag(flag[0]));
	Robot_Speed speed_l2 (.iClk(FPGA_CLK1_50),.iRst_n(RESET_N),.iKey(KEY[1:0]),.iSW(SW[1:0]),.iAngle(iAngle_l2),.oAngle(oAngle_l2),.flag(flag[1]));
	Robot_Speed speed_l3 (.iClk(FPGA_CLK1_50),.iRst_n(RESET_N),.iKey(KEY[1:0]),.iSW(SW[1:0]),.iAngle(iAngle_l3),.oAngle(oAngle_l3),.flag(flag[2]));
	Robot_Speed speed_r1 (.iClk(FPGA_CLK1_50),.iRst_n(RESET_N),.iKey(KEY[1:0]),.iSW(SW[1:0]),.iAngle(iAngle_r1),.oAngle(oAngle_r1),.flag(flag[3]));
	Robot_Speed speed_r2 (.iClk(FPGA_CLK1_50),.iRst_n(RESET_N),.iKey(KEY[1:0]),.iSW(SW[1:0]),.iAngle(iAngle_r3),.oAngle(oAngle_r2),.flag(flag[4]));
	Robot_Speed speed_r3 (.iClk(FPGA_CLK1_50),.iRst_n(RESET_N),.iKey(KEY[1:0]),.iSW(SW[1:0]),.iAngle(iAngle_r3),.oAngle(oAngle_r3),.flag(flag[5]));
	
	PWM_Generator pwm_l1(.clk(FPGA_CLK1_50),.reset_n(RESET_N),.high_dur (PwmAngle_l1),.total_dur(`DUR_CLOCK_NUM),.PWM(Pwm_l1));
	PWM_Generator pwm_l2(.clk(FPGA_CLK1_50),.reset_n(RESET_N),.high_dur (PwmAngle_l2),.total_dur(`DUR_CLOCK_NUM),.PWM(Pwm_l2));
	PWM_Generator pwm_l3(.clk(FPGA_CLK1_50),.reset_n(RESET_N),.high_dur (PwmAngle_l3),.total_dur(`DUR_CLOCK_NUM),.PWM(Pwm_l3));
	PWM_Generator pwm_r1(.clk(FPGA_CLK1_50),.reset_n(RESET_N),.high_dur (PwmAngle_r1),.total_dur(`DUR_CLOCK_NUM),.PWM(Pwm_r1));
	PWM_Generator pwm_r2(.clk(FPGA_CLK1_50),.reset_n(RESET_N),.high_dur (PwmAngle_r2),.total_dur(`DUR_CLOCK_NUM),.PWM(Pwm_r2));
	PWM_Generator pwm_r3(.clk(FPGA_CLK1_50),.reset_n(RESET_N),.high_dur (PwmAngle_r3),.total_dur(`DUR_CLOCK_NUM),.PWM(Pwm_r3));
	/////////////////////////////////////////////////////////////////////////
	
endmodule