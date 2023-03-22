`timescale 1ns / 1ns

module sine_generator (
    input clk ,
    output reg [15:0] sinus,
    output reg [15:0] conus
    );

    parameter SIZE = 1024;    
    reg [15:0] rom_memory [SIZE-1:0];
    integer i;
    initial begin
        $readmemh("/home/ozoe/study/kyw/sin_wave/sine.mem", rom_memory); //File with the signal
        i = 0;
    end    
    //At every positive edge of the clock, output a sine wave sample.
    
    //always@ (posedge clk)
    always #64
    
    begin
        sinus = rom_memory[i];
        conus = rom_memory[i + (SIZE / 2)];
        i = i+ 1;
        if(i == SIZE)
            i = 0;
    end
    endmodule