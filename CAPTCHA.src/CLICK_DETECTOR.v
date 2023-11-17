`timescale 1ns / 1ps

module CLICK_DETECTOR(
    input clock, left, en,
    input [12:0] rand_mod, c_1, c_2, c_3, c_4,
    input [6:0] r_1, r_2, r_3, r_4,
    input [6:0] xpos, input [5:0] ypos,
    output reg pass = 0, fail = 0,
    output reg [12:0] inclusion_zone
    );
    
    // To calculate the distances (squared) between the mouse positions and the centres of the circles
    wire [13:0] dist_1;
    DIST_CALC dist_calc_inst_1( .clock(clock), .x(c_1%96), .xpos(xpos), .y(c_1/96), .ypos(ypos), .dist_sq(dist_1) );
    
    wire [13:0] dist_2;
    DIST_CALC dist_calc_inst_2( .clock(clock), .x(c_2%96), .xpos(xpos), .y(c_2/96), .ypos(ypos), .dist_sq(dist_2) );
    
    wire [13:0] dist_3;
    DIST_CALC dist_calc_inst_3( .clock(clock), .x(c_3%96), .xpos(xpos), .y(c_3/96), .ypos(ypos), .dist_sq(dist_3) );
    
    wire [13:0] dist_4;
    DIST_CALC dist_calc_inst_4( .clock(clock), .x(c_4%96), .xpos(xpos), .y(c_4/96), .ypos(ypos), .dist_sq(dist_4) );
    
    reg [31:0] counter;
    
    always @(posedge clock)
    begin
        if ( en ) begin
            counter = ( counter == 100_000_000 ) ? counter : counter + 1;
            if ( ( !inclusion_zone ) // Such that this will trigger only at the start, when the inclusion_zone has yet to be defined
            && ( ( rand_mod % 96 ) > 14 ) // To ensure that the inclusion_zone is not too close to the edges
            && ( ( rand_mod % 96 ) < 81 ) 
            && ( ( rand_mod / 96 ) > 09 ) 
            && ( ( rand_mod / 96 ) < 54 ) 
            )
            inclusion_zone = rand_mod;
            
            // To be triggered when the target point has been established and the left mouse is clicked
            if ( ( counter == 100_000_000 ) && inclusion_zone && left ) begin
                // Performs a distance (squared) check between each circle's centre and the mouse position.
                // If the distances (squared) are all <= than the radii (+1 to account for the borders squared,
                // then the mouse is in the region of mutual intersection.
                if (( dist_1 <= ( ( r_1 + 1 ) * ( r_1 + 1 ) ) ) 
                &&  ( dist_2 <= ( ( r_2 + 1 ) * ( r_2 + 1 ) ) )
                &&  ( dist_3 <= ( ( r_3 + 1 ) * ( r_3 + 1 ) ) )
                &&  ( dist_4 <= ( ( r_4 + 1 ) * ( r_4 + 1 ) ) )
                ) begin
                    pass = 1;
                    fail = 0;
                end
                
                // If the mouse was clicked when the distance (squared) check failed, then a bot thou art!
                else begin
                    fail = 1;
                    pass = 0;
                end
            end
        end
        
        else begin
            // Reset everything
            inclusion_zone = 0;
            counter = 0;
        end
    end
    
endmodule