`timescale 1ns / 1ns

module i2s_tx #(
    parameter AUDIO_DW = 16
)(
    input i_tx_sclk,
    input [AUDIO_DW-1:0] i_tx_prescaler,
    input i_tx_rst_n,
    
    output wire o_tx_sclk,
    output reg o_tx_lrclk,
    output reg o_tx_sdata,

    input [AUDIO_DW-1:0] i_tx_left_chan,
    input [AUDIO_DW-1:0] i_tx_right_chan
);

reg [AUDIO_DW-1:0] tx_bit_cnt;
reg [AUDIO_DW-1:0] tx_left;
reg [AUDIO_DW-1:0] tx_right;

assign o_tx_sclk = i_tx_sclk;

always @(negedge i_tx_sclk or negedge i_tx_rst_n) begin
    if (!i_tx_rst_n) begin
        tx_bit_cnt <= 1;
        tx_left <= 0;
        tx_right <= 0;
        o_tx_lrclk <= 0;
        o_tx_sdata <= 0;
        
    end else begin
		if (tx_bit_cnt >= i_tx_prescaler) begin
        	tx_bit_cnt <= 1;
    	end else begin
        	tx_bit_cnt <= tx_bit_cnt + 1;
		end
		
		if (tx_bit_cnt == i_tx_prescaler && o_tx_lrclk) begin
			tx_left <= i_tx_left_chan;
        	tx_right <= i_tx_right_chan;
    	end
                
    	o_tx_lrclk <= (tx_bit_cnt == i_tx_prescaler) ? ~o_tx_lrclk : o_tx_lrclk;
    
    	o_tx_sdata <= o_tx_lrclk ? tx_right[AUDIO_DW - tx_bit_cnt] : tx_left[AUDIO_DW - tx_bit_cnt];
    end
end

endmodule
