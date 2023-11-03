`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.10.2023 18:47:15
// Design Name: 
// Module Name: ANIMATION_RESULT
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ANIMATION_RESULT(
    input clock, 
    input reset, 
    input is_second_part_completed, 
    input [4:0] first_act, second_act, third_act, fourth_act, fifth_act, sixth_act, 
    input [4:0] first_inp, second_inp, third_inp, fourth_inp, fifth_inp, sixth_inp,  
    input [6:0] pixel_x, pixel_y, input [12:0] pixel_index, 
    output reg [15:0] led, 
    output reg [15:0] animation_result_pixel_data
);

    reg analysis [ 0 : 6143 ];
    
    parameter SQUARE_SIZE = 169; 
    reg zero [ 0 : SQUARE_SIZE - 1 ]; 
    reg one [ 0 : SQUARE_SIZE - 1 ]; 
    reg two [ 0 : SQUARE_SIZE - 1 ]; 
    reg three [ 0 : SQUARE_SIZE - 1 ]; 
    reg four [ 0 : SQUARE_SIZE - 1 ]; 
    reg five [ 0 : SQUARE_SIZE - 1 ]; 
    reg six [ 0 : SQUARE_SIZE - 1 ]; 
    reg seven [ 0 : SQUARE_SIZE - 1 ]; 
    reg eight [ 0 : SQUARE_SIZE - 1 ]; 
    reg nine [ 0 : SQUARE_SIZE - 1 ]; 
    reg ten [ 0 : SQUARE_SIZE - 1 ]; 
    reg eleven [ 0 : SQUARE_SIZE - 1 ]; 
    reg twelve [ 0 : SQUARE_SIZE - 1 ]; 
    reg thirteen [ 0 : SQUARE_SIZE - 1 ]; 
    reg fourteen [ 0 : SQUARE_SIZE - 1 ]; 
    reg fifteen [ 0 : SQUARE_SIZE - 1 ]; 
    reg sixteen [ 0 : SQUARE_SIZE - 1 ]; 
    reg human [ 0 : SQUARE_SIZE - 1 ]; 
    reg bot [ 0 : SQUARE_SIZE - 1 ]; 
    
    initial begin
        $readmemh ( "Analysis.mem", analysis );
        $readmemh ( "Human.mem", human );
        $readmemh ( "Bot.mem", bot );
        $readmemh ( "0.mem", zero );
        $readmemh ( "1.mem", one);
        $readmemh ( "2.mem", two );
        $readmemh ( "3.mem", three );
        $readmemh ( "4.mem", four );
        $readmemh ( "5.mem", five );
        $readmemh ( "6.mem", six );
        $readmemh ( "7.mem", seven );
        $readmemh ( "8.mem", eight );
        $readmemh ( "9.mem", nine );
        $readmemh ( "10.mem", ten );
        $readmemh ( "11.mem", eleven );
        $readmemh ( "12.mem", twelve );
        $readmemh ( "13.mem", thirteen );
        $readmemh ( "14.mem", fourteen );
        $readmemh ( "15.mem", fifteen );
        $readmemh ( "16.mem", sixteen );
    end 
    
    
    integer i, j;
    reg [4:0] expected [0: MAX_ROUND - 1];
    reg [4:0] user_inputs [0: MAX_ROUND - 1];
    
    // position [i] corresponds to the position in user inputs at which expected [i] is found  
    reg [4:0] position [0: MAX_ROUND - 1];
    parameter NOT_FOUND = MAX_ROUND;
    
    reg [2:0] point_score = 0;
    reg [4:0] kendall_distance = 0;
    wire is_human; 
    assign is_human = point_score >= 5 && kendall_distance <= 2; 
    reg is_analysis_completed = 0;
    
    wire clock_100Hz;
    clock_divider clk_100Hz_inst ( clock, 499_999, clock_100Hz );
    
    reg is_match_found = 0;
    
    always @ ( posedge clock_100Hz ) begin
    
        if ( reset || ! is_second_part_completed ) begin
        
            point_score = 0;
            kendall_distance = 0;
            is_analysis_completed = 0;
            
        end else if ( ! is_analysis_completed ) begin 
        
            expected[0] = first_act;  user_inputs[0]= first_inp; 
            expected[1] = second_act; user_inputs[1] = second_inp;
            expected[2] = third_act;  user_inputs[2] = third_inp;
            expected[3] = fourth_act; user_inputs[3] = fourth_inp;
            expected[4] = fifth_act;  user_inputs[4] = fifth_inp;
            expected[5] = sixth_act;  user_inputs[5] = sixth_inp;
                    
            for ( i = 0; i < MAX_ROUND; i = i + 1 ) begin
                position [i] = NOT_FOUND; 
                is_match_found = 0;
                for ( j = 0; j < MAX_ROUND && ! is_match_found ; j = j + 1 ) begin
                    if ( user_inputs [j] == expected [i] ) begin
                        point_score = point_score + 1;
                        position [i] = j;
                        user_inputs [j] = IMPOSSIBLE_SERIAL; // To prevent repeated counting 
                        is_match_found = 1;
                    end 
                end 
            end 
            
            for ( i = 0; i < MAX_ROUND; i = i + 1 ) begin
                if ( position [i] != NOT_FOUND ) begin
                    for ( j = i + 1; j < MAX_ROUND; j = j + 1 ) begin
                        if ( position [i] > position [j] ) begin
                            kendall_distance = kendall_distance + 1;
                        end 
                    end 
                end 
            end 
            
            is_analysis_completed = 1;
            
        end // else if ( ! is_analysis_completed ) 
        
    end // always 
    
    wire clock_1Hz;
    clock_divider clock_1Hz_inst ( clock, 49_999_999, clock_1Hz ); 
    
    always @ ( posedge clock ) begin
        if ( is_analysis_completed ) begin
            led <= 0;
            led [point_score] <= 1;
            led [ 15 - kendall_distance ] <= clock_1Hz;
        end else begin
            led <= 0;
            led [15] <= 1;
        end 
    end 
    
    wire is_pixel_in_square_1, is_pixel_in_square_2, is_pixel_in_square_3; 
    wire [31:0] normalised_pixel_index_1, normalised_pixel_index_2, normalised_pixel_index_3, normalised_pixel_index;
    
    assign is_pixel_in_square_1 = ( pixel_x >= 66 && pixel_x <= 78 ) && ( pixel_y >= 17 && pixel_y <= 29 );
    assign is_pixel_in_square_2 = ( pixel_x >= 66 && pixel_x <= 78 ) && ( pixel_y >= 31 && pixel_y <= 43 );
    assign is_pixel_in_square_3 = ( pixel_x >= 66 && pixel_x <= 78 ) && ( pixel_y >= 46 && pixel_y <= 57 );
    assign normalised_pixel_index_1 = ( pixel_y - 17 ) * 13 + ( pixel_x - 66 ); 
    assign normalised_pixel_index_2 = ( pixel_y - 31 ) * 13 + ( pixel_x - 66 ); 
    assign normalised_pixel_index_3 = ( pixel_y - 46 ) * 13 + ( pixel_x - 66 ); 
    
    assign normalised_pixel_index = is_pixel_in_square_1 ? normalised_pixel_index_1 :  
                                    is_pixel_in_square_2 ? normalised_pixel_index_2 : normalised_pixel_index_3;
    
    reg [5:0] to_show; 
    parameter HUMAN = 17, BOT = 18, ANALYSIS = 19; 
    always @ ( pixel_index ) begin
        if ( is_pixel_in_square_1 ) begin
            to_show = point_score;
        end else if ( is_pixel_in_square_2 ) begin
            to_show = kendall_distance;
        end else if ( is_pixel_in_square_3 ) begin
            to_show = is_human ? HUMAN : BOT; 
        end else begin
            to_show = ANALYSIS; 
        end
    end 
    
    always @ ( pixel_index ) begin
        case ( to_show )
            0 : animation_result_pixel_data <= zero[normalised_pixel_index] ? WHITE : 0;
            1 : animation_result_pixel_data <= one[normalised_pixel_index] ? WHITE : 0;
            2 : animation_result_pixel_data <= two[normalised_pixel_index] ? WHITE : 0;
            3 : animation_result_pixel_data <= three[normalised_pixel_index] ? WHITE : 0;
            4 : animation_result_pixel_data <= four[normalised_pixel_index] ? WHITE : 0;
            5 : animation_result_pixel_data <= five[normalised_pixel_index] ? WHITE : 0;
            6 : animation_result_pixel_data <= six[normalised_pixel_index] ? WHITE : 0;
            7 : animation_result_pixel_data <= seven[normalised_pixel_index] ? WHITE : 0;
            8 : animation_result_pixel_data <= eight[normalised_pixel_index] ? WHITE : 0;
            9 : animation_result_pixel_data <= nine[normalised_pixel_index] ? WHITE : 0;
            10 : animation_result_pixel_data <= ten[normalised_pixel_index] ? WHITE : 0;
            11 : animation_result_pixel_data <= eleven[normalised_pixel_index] ? WHITE : 0;
            12 : animation_result_pixel_data <= twelve[normalised_pixel_index] ? WHITE : 0;
            13 : animation_result_pixel_data <= thirteen[normalised_pixel_index] ? WHITE : 0;
            14 : animation_result_pixel_data <= fourteen[normalised_pixel_index] ? WHITE : 0;
            15 : animation_result_pixel_data <= fifteen[normalised_pixel_index] ? WHITE : 0;
            16 : animation_result_pixel_data <= sixteen[normalised_pixel_index] ? WHITE : 0;
            HUMAN : animation_result_pixel_data <= human[normalised_pixel_index] ? WHITE : 0;
            BOT : animation_result_pixel_data <= bot [normalised_pixel_index] ? WHITE : 0;
            ANALYSIS : animation_result_pixel_data <= analysis[pixel_index] ? WHITE : 0;                                               
        endcase 
    end 
    
endmodule