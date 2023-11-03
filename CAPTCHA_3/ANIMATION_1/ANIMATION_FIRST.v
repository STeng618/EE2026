`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.10.2023 17:04:47
// Design Name: 
// Module Name: ANIMATION_FIRST
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

module ANIMATION_FIRST (
    input clock, 
    input reset,  
    input [6:0] pixel_x, pixel_y, 
    output reg [15:0] pixel_data,
    output is_first_part_completed,
    output reg [4:0] first_act, second_act, third_act, fourth_act, fifth_act, sixth_act, 
    output reg [15:0] led // For Debugging 
);
    
    // Character Generator
    wire [4:0] source_square, dest_square, pixel_square;
    wire [8:0] character; 
    wire [3:0] serial;
    wire has_completed_this_round; // for updating current round 
    wire has_completed_this_stroke; // for requesting for new strokes
    reg [2:0] current_round = 0; 
    
    wire [15:0] char_gen_led;
    
    CHARACTER_GENERATOR char_generator (
        .clock ( clock ) , 
        .reset ( reset ), 
        .is_new_stroke_needed ( has_completed_this_stroke ), 
        .current_round ( current_round ), 
        .source_square ( source_square ), .dest_square( dest_square),
        .character ( character ), .has_completed_this_round ( has_completed_this_round ),
        .is_first_part_completed ( is_first_part_completed ), 
        .serial ( serial ), 
        .led ( char_gen_led )
    );
    
    COORDINATE_SQUARE_MAPPER coordinate_square_mapper (
        .coordinate_x ( pixel_x ), .coordinate_y ( pixel_y ),
        .square ( pixel_square )
    );

    always @ ( posedge has_completed_this_round, posedge reset ) begin
        if ( reset ) begin
            current_round <= 0; 
            first_act <= NULL_SERIAL; 
            second_act <= NULL_SERIAL;
            third_act <= NULL_SERIAL;
            fourth_act <= NULL_SERIAL;
            fifth_act <= NULL_SERIAL;
            sixth_act <= NULL_SERIAL;
        end else begin 
            case ( current_round ) 
                0 : first_act <= serial;
                1 : second_act <= serial;
                2 : third_act <= serial;
                3 : fourth_act <= serial;
                4 : fifth_act <= serial;
                5 : sixth_act <= serial;
            endcase 
            current_round <= current_round + 1;
        end 
    end
    
    always @ ( * ) begin
        led <= 0;
        if ( first_act != NULL_SERIAL ) begin led [first_act] <= 1; end 
        if ( second_act != NULL_SERIAL ) begin led [second_act] <= 1; end 
        if ( third_act != NULL_SERIAL ) begin led [third_act] <= 1; end 
        if ( fourth_act != NULL_SERIAL ) begin led [fourth_act] <= 1; end 
        if ( fifth_act != NULL_SERIAL ) begin led [fifth_act] <= 1; end 
        if ( sixth_act != NULL_SERIAL ) begin led [sixth_act] <= 1; end 
    end 

    wire is_animation_pixel_on; // For checking whether this pixel should be on based on the animation memory
    ANIMATION_MEMORY_MANAGER animation_memory_manager_inst (
        .clock ( clock ),
        .reset ( reset ), 
        .pixel_x ( pixel_x ), .pixel_y ( pixel_y ), .is_animation_pixel_on ( is_animation_pixel_on ),
        .source_square ( source_square ), .dest_square ( dest_square ),
        .has_completed_this_round ( has_completed_this_round ), // input to memory manager - to clear canvas
        .has_completed_this_stroke ( has_completed_this_stroke ) // output from memory manager  - to request for new strokes
    );
    
    wire clk_25M;
    clock_divider clock_25M_inst ( clock, 1, clk_25M );

    always @ ( posedge clk_25M ) begin
        if ( has_completed_this_round ) begin
            if ( pixel_square == BUFFER_SQUARE ) begin
                pixel_data <= BLACK;
            end else begin
                pixel_data <= character [ pixel_square ] ? WHITE : BLACK;
            end 
        end else begin
            if ( is_animation_pixel_on ) begin
                pixel_data <= RED;
            end else begin
                pixel_data <= BLACK;
            end
        end 
    end

endmodule

/**
    This module manages queries to the animation memory.
    It also writes to the animation memory.
    pixel_x and pixel_y can take the full range of the OLED coordinates 
**/
module ANIMATION_MEMORY_MANAGER (
    input clock, 
    inout reset, 
    input [6:0] pixel_x, pixel_y, output is_animation_pixel_on, // Query Manager
    input [4:0] source_square, dest_square, input has_completed_this_round, output has_completed_this_stroke // Memory Writer
);

    // Memory 
    reg bits_records [ CANVAS_SIZE - 1 : 0 ];
    integer i;
    initial begin
        for ( i = 0; i < CANVAS_SIZE ; i = i + 1 ) begin
            bits_records [ i ] = 0;
        end
    end

    // Query Manager 
    wire is_within_canvas;
    wire [11:0] requested_pixel_canvas_index;
    assign requested_pixel_canvas_index = ( pixel_y - 5 ) * 55 + ( pixel_x - 5 );
    assign is_within_canvas = ( pixel_x >= 5 && pixel_x <= 59 ) && ( pixel_y >= 5 && pixel_y <= 59 );
    assign is_animation_pixel_on = is_within_canvas ? bits_records [ requested_pixel_canvas_index ] : 0 ;
    
    // Memory Writer
    wire [11:0] mover_pixel_canvas_index;
    
    ANIMATION_MOVER animation_mover (
        .clock ( clock ),
        .source_square ( source_square ), .dest_square ( dest_square ),
        .has_completed_this_stroke ( has_completed_this_stroke ),
        .mover_pixel_canvas_index ( mover_pixel_canvas_index )
    );
    
    wire clock_1000Hz;
    clock_divider clk_1000Hz_inst ( clock, 49_999, clock_1000Hz );

    always @ ( posedge clock_1000Hz ) begin
        if ( reset || has_completed_this_round ) begin
            for ( i = 0; i < CANVAS_SIZE; i = i + 1 ) begin
                bits_records [ i ] = 0;
            end
        end else begin
            bits_records [ mover_pixel_canvas_index ] <= 1;
        end
    end

endmodule


/**
    This module accepts two squares,
    and outputs a pair of pixel coordinates that moves from source_square to dest_square. 
    Movements will be completed in 1 second, which is indicated by has_completed.
    source_square and dest_square are assumed to be valid - in the range of 0 - 8 
    The squares must differ by one square in the x or y direction.
**/
module ANIMATION_MOVER (
    input clock, 
    input [4:0] source_square, dest_square, 
    output has_completed_this_stroke,
    output reg [11:0] mover_pixel_canvas_index = CANVAS_SIZE - 1
);
    
    wire [6:0] source_x, source_y, dest_x, dest_y;
    SQUARE_COORDINATE_MAPPER square_coordinate_mapper_source (
        .square ( source_square ),
        .coordinate_x ( source_x ), .coordinate_y ( source_y )
    );
    SQUARE_COORDINATE_MAPPER square_coordinate_mapper_dest (
        .square ( dest_square ),
        .coordinate_x ( dest_x ), .coordinate_y ( dest_y )
    );
    
    reg [6:0] mover_x = BUFFER_SQUARE_X, mover_y = BUFFER_SQUARE_Y; 

    reg [6:0] prev_source_square = BUFFER_SQUARE, prev_dest_square = BUFFER_SQUARE;
    wire are_diff_squares;
    assign are_diff_squares = prev_source_square != source_square || prev_dest_square != dest_square;

    reg [6:0] dx = 0, dy = 0;
    parameter greater = 0, smaller_equal = 1;
    wire state_x, state_y;
    assign state_x = source_x > dest_x ? greater : smaller_equal;
    assign state_y = source_y > dest_y ? greater : smaller_equal;
    
    always @ ( * ) begin
        case ( state_x ) 
            greater : begin dx <= ( source_x - dest_x ) / NUM_MOVES; end
            smaller_equal : begin dx <= ( dest_x - source_x ) / NUM_MOVES ; end
        endcase 
    end
    
    always @ ( * ) begin
        case ( state_y ) 
            greater : begin dy <= ( source_y - dest_y ) / NUM_MOVES; end
            smaller_equal : begin dy <= ( dest_y - source_y ) / NUM_MOVES; end
        endcase 
    end

    // 22 moves in 1 second. Frequency of clock is 22 Hz.
    wire clock_22Hz;
    clock_divider clock_divider_inst ( clock, 2_272_726, clock_22Hz );
    
    always @ ( posedge clock_22Hz  ) begin
    
        if ( are_diff_squares ) begin 
        
            mover_x = source_x;
            mover_y = source_y;
            prev_source_square = source_square;
            prev_dest_square = dest_square;
            
        end else begin
        
            mover_pixel_canvas_index = ( mover_y - 5 ) * 55 + ( mover_x - 5 );
            
            if ( mover_x != dest_x ) begin
                if ( state_x == greater ) begin
                    mover_x = mover_x - dx;
                end else begin
                    mover_x = mover_x + dx;
                end 
            end
            
            if ( mover_y != dest_y ) begin
                if ( state_y == greater ) begin
                    mover_y = mover_y - dy;
                end else begin
                    mover_y = mover_y + dy;
                end 
            end

        end
    end

    assign has_completed_this_stroke = ! are_diff_squares && (mover_x == dest_x) && (mover_y == dest_y);

endmodule


