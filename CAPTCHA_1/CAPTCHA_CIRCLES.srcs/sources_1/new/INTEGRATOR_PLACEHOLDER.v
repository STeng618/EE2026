`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2023 04:52:02 PM
// Design Name: 
// Module Name: INTEGRATOR_PLACEHOLDER
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


module INTEGRATOR_PLACEHOLDER ( 
    input clock, btnC,
    input [15:0] sw,
    inout PS2Clk, PS2Data,
    output [3:0] an, [6:0] seg, [7:0] JC
    );
    
    parameter PASS  = 7'b0001001; // H on the 7-segment
    parameter FAIL  = 7'b0000011; // b on the 7-segment
    parameter NIL   = 7'b1111111; // 7-segment off
    
    
    wire [6:0] xpos;
    wire [5:0] ypos;
    wire [3:0] zpos;
    wire left, middle, right, new_event;
    
    MouseCtl mousectl_inst ( 
        .clk(clock), .rst(btnC), .value(0), .setx(0), .sety(0), .setmax_x(0), .setmax_y(0),
        .ps2_clk(PS2Clk), .ps2_data (PS2Data),
        .xpos(xpos), .ypos(ypos), .zpos(zpos), .left(left), .middle(middle), .right(right), .new_event(new_event) 
    );
    
    
    wire clk_6p25M;
    CLOCK_DIVIDER clk_6p25M_inst ( .clock(clock), .freq_out(6_250_000), .clk_fdiv(clk_6p25M) );
    
    
    wire frame_begin, sending_pixels, sample_pixel;
    wire [12:0] pixel_index;
    wire [15:0] pixel_data;
    
    Oled_Display oled_display_inst ( 
        .clk(clk_6p25M), .reset(btnC), .frame_begin(frame_begin), .sending_pixels(sending_pixels), 
        .sample_pixel(sample_pixel), .pixel_index(pixel_index), .pixel_data(pixel_data), 
        .cs(JC[0]), .sdin(JC[1]), .sclk(JC[3]), .d_cn(JC[4]), .resn(JC[5]), .vccen(JC[6]), .pmoden(JC[7]) 
    );
    
    
    wire [6:0] x;
    wire [5:0] y;
    
    CARTESIAN cartesian_inst (.pixel_index(pixel_index), .x(x), .y(y));
    
    
    wire [12:0] rand;
    wire [12:0] rand_mod;
    LFSR_13b lfsr_13b_inst ( .clock(clock), .reset(0), .Q(rand) );
    assign rand_mod = rand % 6144;
    
    
    wire pass, fail;
//    wire [15:0] pixel_data_circ;
    
    CIRCLE_TOP circle_top_inst( 
        .clock(clock), .btnC(btnC), .left(left), .middle(middle), .right(right), .new_event(new_event), 
        .sw(sw), .pixel_index(pixel_index), .rand_mod(rand_mod), .x(x), .xpos(xpos), .y(y), .ypos(ypos), .zpos(zpos),
        .pass(pass), .fail(fail),
        .pixel_data(pixel_data) // To change to pixel_data_circ for integration
        );
    
    
    
    
    
    
    
    
    assign an[3:0] = ( fail || pass ) ? 4'b1110 : 4'b1111;
    assign seg[6:0] = ( pass ) ? PASS : ( ( fail ) ? FAIL : NIL );
    
endmodule
