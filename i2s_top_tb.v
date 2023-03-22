`timescale 1ns / 1ns

module i2s_top_tb;

// Parameters
parameter AUDIO_DW = 16;

// Inputs
reg i_tx_sclk = 1'b1;
reg i_rst_n = 1'b0;
reg [AUDIO_DW-1:0] i_tx_prescaler = 23'd23;
wire [AUDIO_DW-1:0] i_tx_left_chan;
wire [AUDIO_DW-1:0] i_tx_right_chan;

// Outputs
wire [AUDIO_DW-1:0] o_rx_left_chan;
wire [AUDIO_DW-1:0] o_rx_right_chan;

// Instantiate the i2s_top module
i2s_top #(
	.AUDIO_DW(AUDIO_DW)
) i2s_top_inst (
	.i_tx_sclk(i_tx_sclk),
	.i_rst_n(i_rst_n),
	.i_tx_prescaler(i_tx_prescaler),
	.i_tx_left_chan(i_tx_left_chan),
	.i_tx_right_chan(i_tx_right_chan),
	
	.o_rx_left_chan(o_rx_left_chan),
	.o_rx_right_chan(o_rx_right_chan)
);

// Instantiate the sine wave generator
sine_generator dut(
    .clk(i_tx_sclk),
    .sinus(i_tx_left_chan),
    .conus(i_tx_right_chan)
);

always #1 i_tx_sclk <= ~i_tx_sclk;

initial begin
        i_rst_n <= 0;
        #1;
        i_rst_n <= 1;
        $finish();
end

endmodule
