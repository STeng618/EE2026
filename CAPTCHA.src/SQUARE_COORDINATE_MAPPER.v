`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.10.2023 21:59:34
// Design Name: 
// Module Name: SQUARE_COORDINATE_MAPPER
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


module SQUARE_COORDINATE_MAPPER (
    input [4:0] square,
    output [6:0] coordinate_x, coordinate_y
);
    
    assign coordinate_x = ( square == 0 || square == 3 || square == 6 ) ? 10 :
                          ( square == 1 || square == 4 || square == 7 ) ? 32 :
                          ( square == 2 || square == 5 || square == 8 ) ? 54 : 
                          BUFFER_SQUARE_X;
    assign coordinate_y = ( square == 0 || square == 1 || square == 2 ) ? 10 :
                          ( square == 3 || square == 4 || square == 5 ) ? 32 :
                          ( square == 6 || square == 7 || square == 8 ) ? 54 : 
                          BUFFER_SQUARE_Y;
endmodule