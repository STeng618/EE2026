`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: 
//  STUDENT B NAME:
//  STUDENT C NAME: 
//  STUDENT D NAME:  
//
//////////////////////////////////////////////////////////////////////////////////

module Top_Student(
    input clock, btnC, btnU, btnD, btnL, btnR, input [15:0] sw,
    inout PS2Clk, PS2Data,
    output dp, output [7:0] JC, output [15:0] led, output [6:0] seg, output [3:0] an
);  
    wire [6:0] pixel_x; 
    wire [6:0] pixel_y;

    // Connections to OLED 
    wire frame_begin;
    wire sending_pixels;
    wire sample_pixel;
    wire [12:0] pixel_index;
    wire [15:0] pixel_data;

    // Connections to MouseCtl
    wire [11:0] mouse_x, mouse_y;
    wire [3:0] zpos;
    wire mouse_left, middle, mouse_right, new_event;

    // Map pixel_index to x and y
    assign pixel_x = pixel_index % 96;
    assign pixel_y = pixel_index / 96;

    // Instantiate OLED
    wire clk_6p25M;
    clock_divider clock_6p25M_inst ( clock, 7, clk_6p25M );
    Oled_Display oled_display_inst ( 
      .clk ( clk_6p25M ), .reset (0) , .frame_begin ( frame_begin ), .sending_pixels ( sending_pixels ),
      .sample_pixel ( sample_pixel ), .pixel_index ( pixel_index ), .pixel_data ( pixel_data ), 
      .cs ( JC[0] ) , .sdin ( JC[1] ), .sclk ( JC[3] ), .d_cn( JC[4] ), .resn( JC[5] ), .vccen( JC[6] ), .pmoden( JC[7] )
    );

    // Instantiate MouseCtl
    MouseCtl moust_ctl ( 
        .clk ( clock ), .rst(0), .value(0), .setx (0), .sety (0), .setmax_x (0), .setmax_y (0),
        .ps2_clk (PS2Clk), .ps2_data (PS2Data),
        .xpos (mouse_x), .ypos(mouse_y), .zpos(zpos), .left(mouse_left), .middle (middle), .right(mouse_right), .new_event (new_event) 
    );
    
    ANIMATION animation_inst (
    .clock ( clock ), .is_captcha3_running ( sw[15] ),
    .pixel_x ( pixel_x ), .pixel_y ( pixel_y ), .pixel_index ( pixel_index ), 
    .mouse_left ( mouse_left ), .mouse_x ( mouse_x ), .mouse_y ( mouse_y ), 
    .animation_pixel_data ( pixel_data ), .led ( led )
    );

endmodule

