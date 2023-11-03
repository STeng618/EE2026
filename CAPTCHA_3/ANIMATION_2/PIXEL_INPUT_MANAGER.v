`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.10.2023 17:18:11
// Design Name: 
// Module Name: PIXEL_INPUT_MANAGER
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

module PIXEL_INPUT_MANAGER (
    input [6:0] pixel_x, pixel_y, 
    output reg is_pixel_in_input_squares, 
    output [6:0] normalised_pixel_index, 
    output reg [3:0] pixel_input_squares
);
    
    wire [6:0] ref_x, ref_y; // of pixel_input_squares; for normalisation purposes 
    // Top left of the first input square has x = 4; Each adjacent square differs by 10
    assign ref_x = pixel_input_squares * 10 + 4; 
    // Top left of all input squares has y-coordinate = 17
    assign ref_y = 17; 
    NORMALISER normaliser ( pixel_x, pixel_y, ref_x, ref_y, normalised_pixel_index ); 
    
    wire is_within_first, is_within_second, is_within_third, is_within_fourth, is_within_fifth, is_within_sixth;
    CHECK_IS_WITHIN first ( pixel_x, pixel_y, 4, 17, is_within_first );
    CHECK_IS_WITHIN second ( pixel_x, pixel_y, 14, 17, is_within_second );
    CHECK_IS_WITHIN third ( pixel_x, pixel_y, 24, 17, is_within_third );
    CHECK_IS_WITHIN fouth ( pixel_x, pixel_y, 34, 17, is_within_fourth );
    CHECK_IS_WITHIN fifth ( pixel_x, pixel_y, 44, 17, is_within_fifth );
    CHECK_IS_WITHIN sixth ( pixel_x, pixel_y, 54, 17, is_within_sixth );    
    
    always @ ( pixel_x, pixel_y ) begin
        is_pixel_in_input_squares <= 1;
        if ( is_within_first ) pixel_input_squares <= 0;
        else if ( is_within_second ) pixel_input_squares <= 1;
        else if ( is_within_third )  pixel_input_squares <= 2;
        else if ( is_within_fourth ) pixel_input_squares <= 3;
        else if ( is_within_fifth ) pixel_input_squares <= 4;
        else if ( is_within_sixth ) pixel_input_squares <= 5;
        else begin 
            is_pixel_in_input_squares <= 0;
            pixel_input_squares <= ERROR_INPUT_SQUARE;
        end 
         
    end
    
endmodule 

module NORMALISER (
    input [6:0] pixel_x, pixel_y, ref_x, ref_y, 
    output [6:0] normalised_pixel_index 
);
    assign normalised_pixel_index = ( pixel_y - ref_y ) * 9 + pixel_x - ref_x; 
endmodule 

module CHECK_IS_WITHIN (
    input [6:0] pixel_x, pixel_y, ref_x, ref_y, 
    output is_within
);
    assign is_within = ( pixel_x <= ref_x + 8 && pixel_x >= ref_x )  && 
                       ( pixel_y <= ref_y + 8 && pixel_y >= ref_y ); 
    
endmodule 
