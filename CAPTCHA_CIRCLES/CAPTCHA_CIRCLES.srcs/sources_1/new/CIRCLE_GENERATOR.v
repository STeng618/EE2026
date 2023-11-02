`timescale 1ns / 1ps

module CIRCLE_GENERATOR(
    input clock, en,
    input [12:0] rand_mod, inclusion_zone,
    output reg [12:0] c_1 = 6144, c_2 = 6144, c_3 = 6144, c_4 = 6144,
    output reg [5:0] r_1 = 63, r_2 = 63, r_3 = 63, r_4 = 63
    );
    
    parameter MAX_R = 40 + 1; // Add 1 to MAX_R
    parameter MIN_R = 11;
    
    reg [13:0] dist_1 = 16383, dist_2 = 16383, dist_3 = 16383, dist_4 = 16383;
    reg [12:0] rand_mod_last;
    
    // Distance squared between current randomly generated point and the inclusion zone
    wire [13:0] dist_c;
    DIST_CALC dist_calc_inst( .clock(clock), .x(rand_mod%96), .xpos(inclusion_zone%96), .y(rand_mod/96), .ypos(inclusion_zone/96), .dist_sq(dist_c) );
    
    always @(posedge clock)
    begin
        if ( en ) begin
            if ( inclusion_zone && ( ( r_1 == 63 ) || ( r_2 == 63 ) || ( r_3 == 63 ) || ( r_4 == 63 ) ) ) begin
                // A series of checks to ensure that (r-5)^2 > (distance between current random point to the inclusion zone)^2
                // The '-5' serves to ensure that the verification zone is not too small
                if ( ( c_1 == 6144 ) && ( dist_c <= ( ( MAX_R - 5 ) * ( MAX_R - 5 ) ) ) ) begin
                    c_1 = rand_mod_last;
                    dist_1 = dist_c;
                end
                else if ( ( c_1 != 6144 ) && ( c_2 == 6144 ) && ( dist_c <= ( ( MAX_R - 5 ) * ( MAX_R - 5 ) ) ) ) begin
                    c_2 = rand_mod_last;
                    dist_2 = dist_c;
                end
                else if ( ( c_1 != 6144 ) && ( c_2 != 6144 ) && ( c_3 == 6144 ) && ( dist_c <= ( ( MAX_R - 5 ) * ( MAX_R - 5 ) ) ) ) begin
                    c_3 = rand_mod_last;
                    dist_3 = dist_c;
                end
                else if ( ( c_1 != 6144 ) && ( c_2 != 6144 ) && ( c_3 != 6144 ) && ( c_4 == 6144 ) && ( dist_c <= ( ( MAX_R - 5 ) * ( MAX_R - 5 ) ) ) ) begin
                    c_4 = rand_mod_last;
                    dist_4 = dist_c;
                end
                
                if ( ( rand_mod % MAX_R ) >= MIN_R ) begin
                    // A series of checks to ensure that the distances (squared) between the inclusion zone 
                    // and the centres of the circles are less than the radii (squared).
                    // 
                    // The equality checks ensures that the procedure is only run once.
                    if ( ( c_1 != 6144 ) && ( r_1 == 63 ) && ( dist_1 < ( ( ( rand_mod % MAX_R ) - 1 ) * ( ( rand_mod % MAX_R ) - 1 ) ) ) )
                        r_1 = ( rand_mod % MAX_R ) + 20;
                    if ( ( c_2 != 6144 ) && ( r_2 == 63 ) && ( dist_2 < ( ( ( rand_mod % MAX_R ) - 1 ) * ( ( rand_mod % MAX_R ) - 1 ) ) ) )
                        r_2 = ( rand_mod % MAX_R ) + 20;
                    if ( ( c_3 != 6144 ) && ( r_3 == 63 ) && ( dist_3 < ( ( ( rand_mod % MAX_R ) - 1 ) * ( ( rand_mod % MAX_R ) - 1 ) ) ) )
                        r_3 = ( rand_mod % MAX_R ) + 20;
                    if ( ( c_4 != 6144 ) && ( r_4 == 63 ) && ( dist_4 < ( ( ( rand_mod % MAX_R ) - 1 ) * ( ( rand_mod % MAX_R ) - 1 ) ) ) )
                        r_4 = ( rand_mod % MAX_R ) + 20;
                end
                
                // Unfortunately, I am not able to code such that this register becomes unnecessary.
                // My values for c_n always follow the previous rand_mod values.
                rand_mod_last = rand_mod;
            end
        end
        
        else begin
            // Reset everything
            c_1 = 6144; c_2 = 6144; c_3 = 6144; c_4 = 6144;
            r_1 = 63; r_2 = 63; r_3 = 63; r_4 = 63;
        end
    end
    
endmodule