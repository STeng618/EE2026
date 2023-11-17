`timescale 1ns / 1ps

module RIPPLES(
    input clock, en,
    input [12:0] c_1, c_2, c_3, c_4, 
    input [6:0] x, r_1, r_2, r_3, r_4,
    input [5:0] y,
    output reg [15:0] oled_circ = 0
    );
    
    parameter BLUE = 16'b00000_000000_11111;
    parameter RED = 16'b11111_000000_00000;
    parameter GREEN = 16'b00000_111111_00000;
    parameter YELLOW = 16'b11111_111010_00000;
    
    // Distance calculators between the centres of the circles and the current position of pixel_index
    wire [13:0] d_1;
    DIST_CALC dist_calc_inst_1( .clock(clock), .x(c_1%96), .xpos(x),.y(c_1/96), .ypos(y), .dist_sq(d_1) );
    
    wire [13:0] d_2;
    DIST_CALC dist_calc_inst_2( .clock(clock), .x(c_2%96), .xpos(x),.y(c_2/96), .ypos(y), .dist_sq(d_2) );
    
    wire [13:0] d_3;
    DIST_CALC dist_calc_inst_3( .clock(clock), .x(c_3%96), .xpos(x),.y(c_3/96), .ypos(y), .dist_sq(d_3) );
    
    wire [13:0] d_4;
    DIST_CALC dist_calc_inst_4( .clock(clock), .x(c_4%96), .xpos(x),.y(c_4/96), .ypos(y), .dist_sq(d_4) );
    
    reg [21:0] counter = 0;
    
    
    always @(posedge clock)
    begin
        oled_circ = 0;
        
        if ( en ) begin        
            if      ( ( counter % 1048576 < 32768 ) && ( ( ( r_1 - 1 ) * ( r_1 - 1 ) ) <= d_1 ) && ( ( ( r_1 + 1 ) * ( r_1 + 1 ) ) >= d_1 ) ) oled_circ = YELLOW;
            else if ( ( counter %  524288 < 15384 ) && ( ( ( r_2 - 1 ) * ( r_2 - 1 ) ) <= d_2 ) && ( ( ( r_2 + 1 ) * ( r_2 + 1 ) ) >= d_2 ) ) oled_circ = BLUE;
            else if ( ( counter %  262144 <  7692 ) && ( ( ( r_3 - 1 ) * ( r_3 - 1 ) ) <= d_3 ) && ( ( ( r_3 + 1 ) * ( r_3 + 1 ) ) >= d_3 ) ) oled_circ = GREEN;
            else if ( ( counter %  131072 <  3846 ) && ( ( ( r_4 - 1 ) * ( r_4 - 1 ) ) <= d_4 ) && ( ( ( r_4 + 1 ) * ( r_4 + 1 ) ) >= d_4 ) ) oled_circ = RED;
        end
        
        counter = counter + 1; // This entire counter is to blur the circles
    end
    
endmodule
