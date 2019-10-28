module adc_demo (FPGA_CLK1_50, KEY, SW, LED, ADC_SCLK,
ADC_CONVST, ADC_SDO, ADC_SDI, FSR_flag);
input FPGA_CLK1_50;
input [0:0] KEY;
input [2:0] SW;
output wire [7:0] LED;
input ADC_SDO;
output ADC_SCLK, ADC_CONVST, ADC_SDI;
output reg FSR_flag;
wire [11	:0] values [7:0];
assign LED = values[SW][11:4];


always @(posedge FPGA_CLK1_50)
begin
	if(values[SW][11:4] > 8'b00111111)
		FSR_flag <= 1;
	else if (values[SW][11:4] < 8'b00111111)
		FSR_flag <= 0;
end

adc_control ADC (
	.CLOCK (FPGA_CLK1_50),
	.RESET (!KEY[0]),
	.ADC_SCLK (ADC_SCLK),
	.ADC_CS_N (ADC_CONVST),
	.ADC_DOUT (ADC_SDO),
	.ADC_DIN (ADC_SDI),
	.CH0 (values[0]), // 12‘b001111111111 阈值， 
	.CH1 (values[1]),
	.CH2 (values[2]),
	.CH3 (values[3]),
	.CH4 (values[4]),
	.CH5 (values[5]),
	.CH6 (values[6]),
	.CH7 (values[7])
);
endmodule
