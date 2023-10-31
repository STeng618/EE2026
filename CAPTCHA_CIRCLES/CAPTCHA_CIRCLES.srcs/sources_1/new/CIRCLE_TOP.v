`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: EE2026 Beasts
// Engineer: Kristoffer Videl Wijono
// 
// Create Date: 10/23/2023 04:52:02 PM
// Design Name: CAPTCHA_CIRCLES
// Module Name: CIRCLE_TOP
// Project Name: CAPTCHA
// Target Devices: Basys 3
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

module CIRCLE_TOP ( 
    input clock, btnC, left, middle, right, new_event, 
    input [15:0] sw, [12:0] pixel_index, rand_mod, [6:0] x, xpos, [5:0] y, ypos, [3:0] zpos,
    output pass, fail,
    output [15:0] pixel_data
    );
    
    wire [12:0] inclusion_zone;
    wire [5:0] r_1, r_2, r_3, r_4;
    wire [12:0] c_1, c_2, c_3, c_4;
    
    CIRCLE_GENERATOR circle_generator_inst (
        .clock(clock), .en(sw[0]),
        .rand_mod(rand_mod), .inclusion_zone(inclusion_zone),
        .c_1(c_1), .c_2(c_2), .c_3(c_3), .c_4(c_4),
        .r_1(r_1), .r_2(r_2), .r_3(r_3), .r_4(r_4)
        );
    
    
    CLICK_DETECTOR click_detector_inst (
        .clock(clock), .left(left), .en(sw[0]),
        .rand_mod(rand_mod), .c_1(c_1), .r_1(r_1), .c_2(c_2), .r_2(r_2), .c_3(c_3), .r_3(r_3), .c_4(c_4), .r_4(r_4),
        .xpos(xpos), .ypos(ypos),
        .pass(pass), .fail(fail),
        .inclusion_zone(inclusion_zone)
        );
    
    
    wire [15:0] oled_circ;
    
    RIPPLES ripples_inst (
        .clock(clock), .en(sw[0]),
        .x(x), .y(y),
        .c_1(c_1), .c_2(c_2), .c_3(c_3), .c_4(c_4),
        .r_1(r_1), .r_2(r_2), .r_3(r_3), .r_4(r_4),
        .oled_circ(oled_circ)
        );
    
    
    wire [15:0] disco_data;
    
    DISCOMBOBULATOR discombobulator_inst(
            .clock(clock), .en(sw[0]),
            .x(x), .y(y),
            .disco_data(disco_data)
            );
    
    
    OLED_MANAGER oled_manager_inst(
        .clock(clock),
        .x(x), .y(y), 
        .oled_circ(oled_circ), .disco_data(disco_data),
        .xpos(xpos), .ypos(ypos),
        .pixel_data(pixel_data)
        );
    
endmodule