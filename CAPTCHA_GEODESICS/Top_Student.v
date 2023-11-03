`timescale 1ns / 1ps
    // Delete this comment and include Basys3 inputs and outputs here

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: 
//  STUDENT B NAME:
//  STUDENT C NAME: 
//  STUDENT D NAME:  LOH YIN HENG
//
//////////////////////////////////////////////////////////////////////////////////


module Top_Student (
    input clock, btnC, btnU, btnD, btnL, btnR, input [15:0] sw,
    inout PS2Clk, PS2Data,
    output dp, output [7:0] JC, output [15:0] led, output [6:0] seg, output [3:0] an
);  
    wire [6:0] x; 
    wire [5:0] y;
    
    // Connections to OLED 
    wire frame_begin;
    wire sending_pixels;
    wire sample_pixel;
    wire [12:0] pixel_index;
    wire [15:0] pixel_data;
    
    // Connections to MouseCtl
    wire [6:0] xpos; 
    wire [5:0] ypos;
    wire [3:0] zpos;
    wire left, middle, right, new_event;
    
    // Connections to paint
    wire [6:0] paint_seg;
    wire [15:0] paint_led;
    
    // Individual pixel data
    wire [15:0] pixel_data_A, pixel_data_B, pixel_data_C, pixel_data_D, group_pixel_data;
    wire is_taskA_running, is_taskB_running, is_taskC_running, is_taskD_running, is_group_running;

    // Map pixel_index to x and y
    assign x = pixel_index % 96;
    assign y = pixel_index / 96;
    
    // Instantiate OLED
    wire clk_6p25_MHz;
    clk_divider clock_6p25M_inst ( clock, 7, clk_6p25_MHz );
    Oled_Display oled_display_inst ( 
      .clk ( clk_6p25_MHz ), .reset (0) , .frame_begin ( frame_begin ), .sending_pixels ( sending_pixels ),
      .sample_pixel ( sample_pixel ), .pixel_index ( pixel_index ), .pixel_data ( pixel_data ), 
      .cs ( JC[0] ) , .sdin ( JC[1] ), .sclk ( JC[3] ), .d_cn( JC[4] ), .resn( JC[5] ), .vccen( JC[6] ), .pmoden( JC[7] )
    );

    // Instantiate MouseCtl
    MouseCtl moust_ctl ( 
        .clk ( clock ), .rst(0), .value(0), .setx (0), .sety (0), .setmax_x (0), .setmax_y (0),
        .ps2_clk (PS2Clk), .ps2_data (PS2Data),
        .xpos (xpos), .ypos(ypos), .zpos(zpos), .left(left), .middle (middle), .right(right), .new_event (new_event) 
    );

//    // Instantiate paint
//    paint paint_inst (
//        .clk_100M (clock), .mouse_l(left), .reset(right), .enable(1),  
//        .mouse_x(xpos), .mouse_y(ypos),
//        .pixel_index (pixel_index), .colour_chooser (group_pixel_data),
//        .led(paint_led), .seg (paint_seg)
//    );   
    
    wire clk_120Hz;
    clk_divider clock_120_inst ( clock, 7, clk_120Hz );
    
    Geodesics Circle (
        .clock(clk_120Hz), .x(x), .y(y), 
        .pixel_index(pixel_index),
        .sw(sw), .led(led),
        .mouse_x(xpos), .mouse_y(ypos),
        .mouse_l(left), .reset(right), 
        .pixel_data(pixel_data));

endmodule
