
module major_project_top(
	
	input FPGA_CLK1_50,
	input [2:0] SW,
	input [1:0] KEY,
	inout [35:0] GPIO_1,
	inout [19:18] GPIO_0,
	input ADC_SDO,
	output [7:0] LED,
	output ADC_SCLK, 
	output ADC_CONVST, 
	output ADC_SDI
	
	);
	
	wire [7:0] uselessLED;
	wire [3:0] BluetoothLED;
	wire [7:0] uselessLED1;
	wire FSR_flag;
	wire [63:0] angle;
	

	
	SMK_control SMK (.FPGA_CLK1_50 (FPGA_CLK1_50),
								.KEY          (KEY),          // Rotate forward/backward
								.SW           (BluetoothLED), // Speed selection
								.LED          (angle),
								.GPIO_1       (GPIO_1),
								.FSR_flag     (FSR_flag)
								);
								
	DE10_NANO_Bluetooth_Slave Bluetooth (.FPGA_CLK1_50 (FPGA_CLK1_50),
													 .angle        (angle),
													 .LED          (BluetoothLED), // Speed command from smart phone
													 .BT_UART_RX   (GPIO_0[18]),   // Read from HC05
													 .BT_UART_TX   (GPIO_0[19])	 // Transfer to HC05
													 );
													 
	adc_demo adc_d (.FPGA_CLK1_50(FPGA_CLK1_50),
						 .KEY(1'b1),
						 .SW(SW),
						 .LED(uselessLED1),
						 .ADC_SDO(ADC_SDO),
						 .ADC_SCLK(ADC_SCLK),
						 .ADC_CONVST(ADC_CONVST),
						 .ADC_SDI(ADC_SDI),
						 .FSR_flag(FSR_flag) 
						);

													 
endmodule
