`timescale 1ns / 1ps

module OLED_MANAGER(
    input clock, en,
    input [15:0] oled_circ, disco_data,
    input [6:0] x, xpos,
    input [5:0] y, ypos,
    output reg [15:0] pixel_data
    );
    
    parameter WHITE = 16'b11111_111111_11111;
    
    always @(posedge clock)
    begin
        if ( ( ( x == xpos ) && ( ( ( y >= ( ypos - 2 ) ) && ( y <= ( ypos - 1 ) ) ) || ( ( y >= ( ypos + 1 ) ) && ( y <= ( ypos + 2 ) ) ) ) ) 
        || ( ( y == ypos ) && ( ( ( x >= ( xpos - 2 ) ) && ( x <= ( xpos - 1 ) ) ) || ( ( x >= ( xpos + 1 ) ) && ( x <= ( xpos + 2 ) ) ) ) ) )
            pixel_data = WHITE; // Plot out the mouse cursor; this can be moved to the top OLED_MANAGER
        
        else if ( disco_data && en ) pixel_data = disco_data; // Plot out scrolling lines above the circles
        
        else pixel_data = oled_circ;
        
    end
    
endmodule