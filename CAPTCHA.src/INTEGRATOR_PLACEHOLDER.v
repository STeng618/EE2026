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
`include "PARAMETERS.vh"

module INTEGRATOR_PLACEHOLDER ( 
    input clock, btnC, btnU, btnR, btnD, btnL, 
    input [15:0] sw,
    inout PS2Clk, PS2Data,
    output [15:0] led, 
    output reg [3:0] an, output reg [6:0] seg, output dp, output [7:0] JC
    );
    
    // Some controller for this is needed if we proceed with this.
    parameter PASS  = 7'b0001001; // H on the 7-segment
    parameter FAIL  = 7'b0000011; // b on the 7-segment
    parameter NIL   = 7'b0111111; // - on the 7-segment 
    
    
    // Mouse module
    wire [6:0] xpos;
    wire [5:0] ypos;
    wire [3:0] zpos;
    wire left, middle, right, new_event;
    
    MouseCtl mousectl_inst ( 
        .clk(clock), .rst(btnC), .value(0), .setx(0), .sety(0), .setmax_x(0), .setmax_y(0),
        .ps2_clk(PS2Clk), .ps2_data (PS2Data),
        .xpos(xpos), .ypos(ypos), .zpos(zpos), .left(left), .middle(middle), .right(right), .new_event(new_event) 
    );

    // 6.25 MHz clock for the OLED
    wire clk_6p25M;
    CLOCK_DIVIDER clk_6p25M_inst ( .clock(clock), .freq_out(6_250_000), .clk_fdiv(clk_6p25M) );
    
    
    wire frame_begin, sending_pixels, sample_pixel;
    wire [12:0] pixel_index;
    wire [15:0] pixel_data;
    
    Oled_Display oled_display_inst ( 
        .clk(clk_6p25M), .reset(0), .frame_begin(frame_begin), .sending_pixels(sending_pixels), 
        .sample_pixel(sample_pixel), .pixel_index(pixel_index), .pixel_data(pixel_data), 
        .cs(JC[0]), .sdin(JC[1]), .sclk(JC[3]), .d_cn(JC[4]), .resn(JC[5]), .vccen(JC[6]), .pmoden(JC[7]) 
    );

    // Converter from pixel_index to x & y
    wire [6:0] x;
    wire [5:0] y;
    
    CARTESIAN cartesian_inst (.pixel_index(pixel_index), .x(x), .y(y));
    
    // 13-bit RNG
    wire [12:0] rand;
    wire [12:0] rand_mod;
    LFSR_13b lfsr_13b_inst ( .clock(clock), .reset(0), .Q(rand) );
    assign rand_mod = rand % 6144; // To RNG a pixel_index: if you know a better way to do this please do change it
    
    // Menu module
    wire [15:0] circ_pixel_data, fing_pixel_data, geo_pixel_data, abc_pixel_data, lyh_led, yst_led; 
    wire circ, fing, geo, abc;
    wire circ_pass, circ_fail, fing_pass, fing_fail, geo_pass, geo_fail, abc_pass, abc_fail;
    
    MENU massimo_chua_christopher (
        .clock(clock), .pixel_index(pixel_index),
        .left(left), .middle(middle), .right (right), 
        .x(x), .xpos(xpos), .y(y), .ypos(ypos),
        .circ_pass(circ_pass), .circ_fail(circ_fail), 
        .fing_pass(fing_pass), .fing_fail(fing_fail), 
        .geo_pass(geo_pass), .geo_fail(geo_fail), 
        .abc_pass(abc_pass), .abc_fail(abc_fail),
        .circ_pixel_data (circ_pixel_data), .fing_pixel_data (fing_pixel_data), .geo_pixel_data (geo_pixel_data), .abc_pixel_data (abc_pixel_data), 
        .circ(circ), .fing(fing), .geo(geo), .abc(abc),
        .pixel_data (pixel_data) 
        );
    
    CIRCLE_TOP kristoffer_videl_wijono ( 
        .clock(clock), .left(left),
        .en(circ),
        .pixel_index(pixel_index), .rand_mod(rand_mod), .x(x), .xpos(xpos), .y(y), .ypos(ypos),
        .pass(circ_pass), .fail(circ_fail),
        .pixel_data(circ_pixel_data)
        );
        
    CAPTCHA_2 khoo_kye_wen (
        .clock ( clock ), 
        .btnR ( btnR ), .btnL ( btnL ), .btnD ( btnD ), .btnU ( btnU ), 
        .sw ( sw[1] ), .btnC ( btnC ), .en ( fing ), .x ( x ), .y ( y ), .pixel_index ( pixel_index ),
        .oled_data ( fing_pixel_data ), .pass ( fing_pass ), .fail ( fing_fail ) 
    );
    
    ANIMATION yap_shan_teng (
        .clock ( clock ),
        .is_captcha3_running ( abc ), 
        .pixel_x ( x ), .pixel_y ( y ), .pixel_index ( pixel_index ), 
        .mouse_left ( left ), .mouse_x ( xpos ), .mouse_y ( ypos ), 
        .animation_pixel_data ( abc_pixel_data ), .led ( yst_led ),
        .pass ( abc_pass ), .fail ( abc_fail ) 
    );
    
    Geodesics loh_yin_heng (
        .clock ( clock ), .sw ( sw ),
        .x ( x ), .y ( y ), .en ( geo ), 
        .pixel_index ( pixel_index ),
        .mouse_x ( xpos ), .mouse_y ( ypos ),
        .mouse_l ( left ), .reset ( right ),
        .led ( lyh_led ) ,
        .pixel_data ( geo_pixel_data ), 
        .correct ( geo_pass ), .incorrect ( geo_fail ) 
    );
    
    assign led = (geo) ? lyh_led :
                (abc) ? yst_led :
                0;
    
    
    wire clk_1000Hz; 
    clock_divider clk_1000Hz_inst ( clock, 49_999, clk_1000Hz );
    
    reg [1:0] current_anode = 0; 
    assign dp = 1; 
    always @ ( posedge clk_1000Hz ) begin
        an <= 4'b1111; 
        an [ current_anode ] <= 0;
        case ( current_anode ) 
            0 : seg <= ( abc_fail ) ? FAIL : ( ( abc_pass ) ? PASS : NIL );
            1 : seg <= ( geo_fail ) ? FAIL : ( ( geo_pass ) ? PASS : NIL );
            2 : seg <= ( fing_fail ) ? FAIL : ( ( fing_pass ) ? PASS : NIL );
            3 : seg <= ( circ_fail ) ? FAIL : ( ( circ_pass ) ? PASS : NIL );
        endcase 
        current_anode <= ( current_anode == 3 ) ? 0 : current_anode + 1; 
    end 
    
endmodule

module clock_divider( input clock_100MHz, [31:0] count , output reg slow_clock );
    reg [31:0] record = 0;
    
    always @(posedge clock_100MHz) begin
        record <= ( record == count ) ? 0 : record + 1;
        slow_clock <= ( record == 0 ) ? ~slow_clock : slow_clock;
    end 
    
endmodule
