`timescale 1ns / 1ns

module i2s_rx #(
    parameter AUDIO_DW = 16
)(
    input i_rx_sclk,
    input i_rx_rst_n,
    input i_rx_lrclk,
    input i_rx_sdata,

    output reg [AUDIO_DW-1:0] o_rx_left_chan,
    output reg [AUDIO_DW-1:0] o_rx_right_chan
);

reg [AUDIO_DW-1:0] rx_left;
reg [AUDIO_DW-2:0] rx_right;
reg rx_lrclk_r;
wire rx_lrclk_nedge;

assign rx_lrclk_nedge = !i_rx_lrclk & rx_lrclk_r;

always @(posedge i_rx_sclk or negedge i_rx_rst_n)
	if (!i_rx_rst_n) begin
		rx_lrclk_r <= 0;
		rx_left <= 0;
		rx_right <= 0;
	end else begin
        rx_lrclk_r <= i_rx_lrclk;
        if (rx_lrclk_r) begin
            rx_right <= {rx_right[AUDIO_DW-2:0], i_rx_sdata};
        end else 
            rx_left <= {rx_left[AUDIO_DW-2:0], i_rx_sdata};
    end

always @(posedge i_rx_sclk or negedge i_rx_rst_n)
	if (!i_rx_rst_n && !rx_lrclk_nedge) begin
		o_rx_left_chan <= 0;
		o_rx_right_chan <= 0;
	end else if (rx_lrclk_nedge) begin
        o_rx_left_chan <= rx_left;
        o_rx_right_chan <= {rx_right[AUDIO_DW-2:0], i_rx_sdata};
	end

endmodule
