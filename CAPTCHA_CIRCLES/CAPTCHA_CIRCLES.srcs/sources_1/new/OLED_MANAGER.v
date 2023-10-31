`timescale 1ns / 1ps

module OLED_MANAGER(
    input clock,
    input [15:0] oled_circ, disco_data,
//    input [12:0] inclusion_zone,
    input [6:0] x, xpos,
    input [5:0] y, ypos,
    output reg [15:0] pixel_data
    );
    
    parameter WHITE = 16'b11111_111111_11111;
    parameter PURPLE = 16'b11111_000000_11110;
    
    always @(posedge clock)
    begin
        if ( ( ( x == xpos ) && ( ( ( y >= ( ypos - 2 ) ) && ( y <= ( ypos - 1 ) ) ) || ( ( y >= ( ypos + 1 ) ) && ( y <= ( ypos + 2 ) ) ) ) ) 
        || ( ( y == ypos ) && ( ( ( x >= ( xpos - 2 ) ) && ( x <= ( xpos - 1 ) ) ) || ( ( x >= ( xpos + 1 ) ) && ( x <= ( xpos + 2 ) ) ) ) ) )
            pixel_data = WHITE;
        
        else if ( disco_data ) pixel_data = disco_data;
        
        else pixel_data = oled_circ;
        
        
//        if ( ( ( x == xpos ) && ( ( y == ( ypos - 1 ) ) || ( y == ( ypos + 1 ) ) ) ) || ( ( ( x == ( xpos - 1 ) ) || ( x == ( xpos + 1 ) ) ) && ( y == ypos ) ) ) begin
//            pixel_data = WHITE;
//        end
        
//        if ( ( ( inclusion_zone % 96 ) >= ( x - 1 ) ) && ( ( inclusion_zone % 96 ) <= ( x + 1 ) ) 
//        && ( ( inclusion_zone / 96 ) <= ( y + 1 ) ) && ( ( inclusion_zone / 96 ) >= ( y - 1 ) ) )
//        pixel_data = 16'b11111_111111_00000;
    end
    
endmodule