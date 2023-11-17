`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.10.2023 19:53:59
// Design Name: 
// Module Name: ANIMATION
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


module ANIMATION(
    input clock,
    input is_captcha3_running, 
    input [6:0] pixel_x, pixel_y, input [12:0] pixel_index, 
    input mouse_left, input [11:0] mouse_x, mouse_y, 
    output [15:0] animation_pixel_data , output [15:0] led,
    output pass, fail 
);
    
    wire is_first_part_completed, is_second_part_completed; 
    wire [15:0] animation_first_pixel_data, animation_second_pixel_data, animation_result_pixel_data; 
    
    wire [4:0] first_act, second_act, third_act, fourth_act, fifth_act, sixth_act; // Actual Characters shown to user 
    wire [4:0] first_inp, second_inp, third_inp, fourth_inp, fifth_inp, sixth_inp; // Answer provided by user 
    
    wire [15:0] first_led, second_led, third_led; 
    
    ANIMATION_FIRST animation_first (
        .clock ( clock ), 
        .reset ( ~is_captcha3_running ), 
        .pixel_x ( pixel_x ) , .pixel_y ( pixel_y ) , 
        .pixel_data ( animation_first_pixel_data ), 
        .is_first_part_completed ( is_first_part_completed ),
        .first_act ( first_act ), .second_act ( second_act ), .third_act ( third_act ), 
        .fourth_act ( fourth_act ), .fifth_act ( fifth_act ), .sixth_act ( sixth_act ),
        .led ( first_led ) // For Debugging 
    );
    
//    ANIMATION_FIRST animation_first_testing (
//        .clock ( clock ), 
//        .reset ( 0 ), 
//        .pixel_x ( pixel_x ) , .pixel_y ( pixel_y ) , 
//        .pixel_data ( animation_first_pixel_data ), 
//        .is_first_part_completed ( is_first_part_completed ),
//        .first_act ( first_act ), .second_act ( second_act ), .third_act ( third_act ), 
//        .fourth_act ( fourth_act ), .fifth_act ( fifth_act ), .sixth_act ( sixth_act ),
//        .led ( first_led ) // For Debugging 
//    );
    
    ANIMATION_SECOND animation_second (
        .clock ( clock ), 
        .reset ( ~is_captcha3_running ), 
        .is_first_part_completed ( is_first_part_completed ), 
        .mouse_left ( mouse_left ), .mouse_x ( mouse_x ), .mouse_y ( mouse_y ),
        .pixel_index ( pixel_index ), .pixel_x ( pixel_x ), .pixel_y ( pixel_y ),
        .pixel_data ( animation_second_pixel_data ), 
        .is_second_part_completed ( is_second_part_completed ), 
        .led ( second_led ), 
        .first_inp ( first_inp ), .second_inp ( second_inp ), .third_inp ( third_inp ), 
        .fourth_inp ( fourth_inp ), .fifth_inp ( fifth_inp ), .sixth_inp ( sixth_inp )
    );
    
    ANIMATION_RESULT animation_result (
        .clock ( clock ) , 
        .reset ( ~is_captcha3_running ), 
        .is_second_part_completed ( is_second_part_completed ), 
        .first_act ( first_act ), .second_act ( second_act ), .third_act ( third_act ), 
        .fourth_act ( fourth_act ), .fifth_act ( fifth_act ), .sixth_act ( sixth_act ), 
        .first_inp ( first_inp ), .second_inp ( second_inp ), .third_inp ( third_inp ), 
        .fourth_inp ( fourth_inp ), .fifth_inp ( fifth_inp ), .sixth_inp ( sixth_inp ), 
        .pixel_x ( pixel_x ), .pixel_y ( pixel_y ), .pixel_index ( pixel_index ), 
        .led ( third_led ), 
        .animation_result_pixel_data ( animation_result_pixel_data ), 
        .pass ( pass ), .fail ( fail )  
    );
    
//    ANIMATION_RESULT animation_result_testing (
//        .clock ( clock ) , 
//        .reset ( 0 ), 
//        .is_second_part_completed ( 1 ), 
//        .first_act ( 1 ), .second_act ( 2 ), .third_act ( 3 ), 
//        .fourth_act ( 4 ), .fifth_act ( 5 ), .sixth_act ( 6 ), 
//        .first_inp ( 6 ), .second_inp ( 5 ), .third_inp ( 4 ), 
//        .fourth_inp ( 3 ), .fifth_inp ( 9 ), .sixth_inp ( 9 ), 
//        .led ( third_led ), 
//        .animation_result_pixel_data ( animation_result_pixel_data ) 
//    );
    
    assign animation_pixel_data = ~is_first_part_completed ? animation_first_pixel_data : 
                                  ~is_second_part_completed ? animation_second_pixel_data :
                                  animation_result_pixel_data; 
                                  
    assign led = third_led;

endmodule
