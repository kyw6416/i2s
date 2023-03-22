`timescale 1ns / 1ns

module i2s_top #(
    parameter AUDIO_DW = 16
)(
    input i_tx_sclk,
    input i_rst_n,
    input [AUDIO_DW-1:0] i_tx_prescaler,
    input [AUDIO_DW-1:0] i_tx_left_chan,
    input [AUDIO_DW-1:0] i_tx_right_chan,

    output [AUDIO_DW-1:0] o_rx_left_chan,
    output [AUDIO_DW-1:0] o_rx_right_chan
);

wire w_sclk;
wire w_lrclk;
wire w_sdata;

i2s_tx #(
    .AUDIO_DW(AUDIO_DW)
) i2s_tx (
    .i_tx_sclk(i_tx_sclk),
    .i_tx_rst_n(i_rst_n),
    .i_tx_prescaler(i_tx_prescaler),
    
    .o_tx_sclk(w_sclk),
    .o_tx_lrclk(w_lrclk),
    .o_tx_sdata(w_sdata),
    
    .i_tx_left_chan(i_tx_left_chan),
    .i_tx_right_chan(i_tx_right_chan)
);

i2s_rx #(
    .AUDIO_DW(AUDIO_DW)
) i2s_rx (
    .i_rx_sclk(w_sclk),
    .i_rx_rst_n(i_rst_n),
    .i_rx_lrclk(w_lrclk),
    .i_rx_sdata(w_sdata),
    .o_rx_left_chan(o_rx_left_chan),
    .o_rx_right_chan(o_rx_right_chan)
);

endmodule
