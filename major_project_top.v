
module major_project_top(
	
	input FPGA_CLK1_50,
	input [1:0] KEY,
	inout [35:0] GPIO_1,
	inout [19:18] GPIO_0,
	output [7:0] LED
	);
	
	wire [7:0] uselessLED;
	wire [3:0] BluetoothLED;
	
	SMK_control SMK (.FPGA_CLK1_50 (FPGA_CLK1_50),
								.KEY          (KEY),          // Rotate forward/backward
								.SW           (BluetoothLED), // Speed selection
								.LED          (LED),
								.GPIO_1       (GPIO_1)
								);
								
	DE10_NANO_Bluetooth_Slave Bluetooth (.FPGA_CLK1_50 (FPGA_CLK1_50),
													 .LED          (BluetoothLED), // Speed command from smart phone
													 .BT_UART_RX   (GPIO_0[18]),   // Read from HC05
													 .BT_UART_TX   (GPIO_0[19])	 // Transfer to HC05
													 );
													 
endmodule
