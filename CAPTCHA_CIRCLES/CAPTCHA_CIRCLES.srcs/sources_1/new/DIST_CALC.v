`timescale 1ns / 1ps

module DIST_CALC(
    input clock,
    input [6:0] x, xpos,
    input [5:0] y, ypos,
    output reg [13:0] dist_sq = 16383
    );
    
    reg [6:0] x_diff = 127;
    reg [5:0] y_diff = 63;
    
    always @(posedge clock)
    begin
        if ( x >= xpos ) x_diff = ( x - xpos );
        else x_diff = ( xpos - x );
        
        if ( y >= ypos ) y_diff = ( y - ypos );
        else y_diff = ( ypos - y );
        
        dist_sq = ( x_diff * x_diff + y_diff * y_diff );
    end
    
endmodule