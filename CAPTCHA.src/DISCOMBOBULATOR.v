`timescale 1ns / 1ps

module DISCOMBOBULATOR(
    input clock, en,
    input [6:0] x,
    input [5:0] y,
    output reg [15:0] disco_data
    );
    
    parameter COLOUR_1  = 16'b10101_010101_01010;
    parameter COLOUR_2  = 16'b01010_101010_10101;
    parameter COLOUR_3  = 16'b11111_110000_00000;
    parameter COLOUR_4  = 16'b11001_011001_00010;
    
    parameter SPEED_1   = 0_520_832;
    parameter SPEED_2   = 1_041_665;
    parameter SPEED_3   = 1_562_499;
    parameter SPEED_4   = 2_083_332;
    
    reg [18:0] c1 = 0;
    reg [19:0] c2 = 0;
    reg [20:0] c3 = 0, c4 = 0;
    
    reg [6:0] x1 = 11, x2 = 35, x3 = 59, x4 = 83;
    reg [5:0] y1 = 7, y2 = 23, y3 = 39, y4 = 55;
    
    always @(posedge clock)
    begin
        if ( en ) begin
            disco_data = 0;
            
            // Increment the counters
            c1 = ( c1 == SPEED_1 ) ? 0 : c1 + 1;
            c2 = ( c2 == SPEED_2 ) ? 0 : c2 + 1;
            c3 = ( c3 == SPEED_3 ) ? 0 : c3 + 1;
            c4 = ( c4 == SPEED_4 ) ? 0 : c4 + 1;
            
            if ( c1 == SPEED_1 ) begin
                x1 = ( x1 == 95 ) ? 0 : x1 + 1;
                y1 = y1 - 1;
            end
            
            if ( c2 == SPEED_2 ) begin
                x2 = ( x2 == 127 ) ? 95 : x2 - 1;
                y2 = y2 + 1;
            end
            
            if ( c3 == SPEED_3 ) begin
                x3 = ( x3 == 95 ) ? 0 : x3 + 1;
                y3 = y3 - 1;
            end
            
            if ( c4 == SPEED_4 ) begin
                x4 = ( x4 == 127 ) ? 95 : x4 - 1;
                y4 = y4 + 1;
            end
            
            // You can remove some of these if there are too many lines to the point of becoming unsolvable
            if      ( x == x1 ) disco_data = COLOUR_1;
            else if ( x == x2 ) disco_data = COLOUR_2;
            else if ( x == x3 ) disco_data = COLOUR_3;
            else if ( x == x4 ) disco_data = COLOUR_4;
            else if ( y == y1 ) disco_data = COLOUR_1;
            else if ( y == y2 ) disco_data = COLOUR_2;
            else if ( y == y3 ) disco_data = COLOUR_3;
            else if ( y == y4 ) disco_data = COLOUR_4;
        end
    end
    
endmodule
