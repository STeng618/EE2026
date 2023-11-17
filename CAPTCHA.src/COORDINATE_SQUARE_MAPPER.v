`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.10.2023 16:31:55
// Design Name: 
// Module Name: COORDINATE_SQUARE_MAPPER
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

module COORDINATE_SQUARE_MAPPER(
    input [6:0] coordinate_x, coordinate_y,
    output [4:0] square
);
    assign square = 
    ( coordinate_x >= 5 && coordinate_x <= 15 ) ? (
        ( coordinate_y >= 5 && coordinate_y <= 15 ) ? 0 :
        ( coordinate_y >= 27 && coordinate_y <= 37 ) ? 3 :
        ( coordinate_y >= 49 && coordinate_y <= 59 ) ? 6 :
        BUFFER_SQUARE
    ) : (
    ( coordinate_x >= 27 && coordinate_x <= 37 ) ? (
        ( coordinate_y >= 5 && coordinate_y <= 15 ) ? 1 :
        ( coordinate_y >= 27 && coordinate_y <= 37 ) ? 4 :
        ( coordinate_y >= 49 && coordinate_y <= 59 ) ? 7 :
        BUFFER_SQUARE
    ) : (
    ( coordinate_x >= 49 && coordinate_x <= 59 ) ? (
        ( coordinate_y >= 5 && coordinate_y <= 15 ) ? 2 :
        ( coordinate_y >= 27 && coordinate_y <= 37 ) ? 5 :
        ( coordinate_y >= 49 && coordinate_y <= 59 ) ? 8 :
        BUFFER_SQUARE
    ) : BUFFER_SQUARE
    ) );
endmodule
