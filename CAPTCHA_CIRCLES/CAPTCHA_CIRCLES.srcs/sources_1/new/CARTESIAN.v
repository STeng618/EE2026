`timescale 1ns / 1ps

module CARTESIAN(
    input [12:0] pixel_index,
    output [6:0] x,
    output [5:0] y
    );
    
    assign x = pixel_index % 96;
    assign y = pixel_index / 96;
    
endmodule
