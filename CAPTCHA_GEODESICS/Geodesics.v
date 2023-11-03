`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2023 01:05:09 PM
// Design Name: 
// Module Name: Geodesics
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


module Geodesics(

    input clock, input [15:0] sw,
    input [6:0] x, input [5:0] y, 
    input [12:0] pixel_index,
    input [11:0] mouse_x, mouse_y,
    input mouse_l, reset,
    output [15:0] led,
    output reg [31:0] pixel_data = 16'b00000_111111_00000);

    parameter BLUE = 16'b00000_000000_11111;
    parameter BLACK = 16'b00000_000000_00000;
    parameter ORANGE = 16'b11111_101101_00000;
    parameter WHITE = 16'b11111_111111_11111;
    parameter GREEN = 16'b00000_111111_00000;
    parameter CYAN  = 16'b00000_111111_11111;
    parameter PURPLE = 16'b11111_000000_11110;  
 
 
     // Main circle
    parameter circle_radius = 32;
    
    parameter [6:0] circle_center_x = 48;
    parameter [6:0] circle_center_y = 32;
    
    // Distance calculation
    reg [31:0] distance_squared = 0;  
    reg [31:0] distance_x = 0;
    reg [31:0] distance_y = 0;
    
    // Great circle selection
    parameter std_oval_major_radius = circle_radius - 1;  
    parameter std_oval_minor_radius = 12;
    
    wire [12:0] raw_random_minor_radius;
    wire [12:0] random_minor_radius;
    
     lfsr geodesic_reference (
        .clock(clock),
        .reset(0), 
        .load(reset),
        .Q(raw_random_minor_radius));
        
    assign random_minor_radius = raw_random_minor_radius + 17;
       
   // Random point coordinates
    wire [12:0] raw_polarity;
    wire  polarity;
    
    lfsr polarity_chooser (
        .clock(clock),
        .reset(0), 
        .load(reset),
        .Q(raw_polarity));
    
    assign polarity = raw_polarity % 2;
    
    wire [12:0] raw_random_pt_H;
    wire [12:0] raw_random_pt_L;
    wire [12:0] random_pt_H;
    wire [12:0] random_pt_L;
    
    lfsr highpt (
        .clock(clock),
        .reset(0), 
        .load(reset),
        .Q(raw_random_pt_H));
    
    lfsr lowpt (
        .clock(clock),
        .reset(0), 
        .load(reset),
        .Q(raw_random_pt_L));
        
    assign random_pt_H = raw_random_pt_H + 5;
    assign random_pt_L = raw_random_pt_L + circle_center_y + 10;
    
    // Check answer
    reg answered = 0;
    reg incorrect = 0;
    reg correct = 0;
    
    // Pixel counters
    reg [10:0] pixel_drawn = 0;
    reg [10:0] pixel_correct = 0;
    
    ////////////////////////////////////////////// TBC //////////////////////////////////////////////
    assign led[15] = answered;
    assign led[14] = incorrect;
    assign led[13] = correct;
    assign led[10:0] = pixel_drawn;
    ////////////////////////////////////////////// TBC //////////////////////////////////////////////
    
    // Hold to draw
    reg purple_drawing [ 0 : 6143 ];
    integer i;
    initial begin
        for ( i = 0; i < 6144; i = i + 1 ) begin
            purple_drawing [i] = 0;
        end
    end
    
    // Track drawing
    wire [12:0] mouse_pixel_index;
    assign mouse_pixel_index = mouse_y * 96 + mouse_x;
    
    // Main loop
    always @(posedge clock) begin
    
        // Calculating distance^2 of each pixel from the circle center
        distance_x <= (x > circle_center_x) ? (x - circle_center_x) : (circle_center_x - x);
        distance_y <= (y > circle_center_y) ? (y - circle_center_y) : (circle_center_y - y);

        distance_squared <= distance_x * distance_x + distance_y * distance_y;  

        pixel_data <= BLACK;
        
        // Generating main circle
        if (distance_squared < (circle_radius * circle_radius)) begin
        
            pixel_data <= BLUE; 
            
            // Generating two random points
            if((((std_oval_major_radius + 1) * (std_oval_major_radius + 1) * (x - circle_center_x)   * (x - circle_center_x) +
                 (std_oval_minor_radius + 1) * (std_oval_minor_radius + 1) * (y - circle_center_y)   * (y - circle_center_y) >=
                 (std_oval_major_radius)     * (std_oval_major_radius)     * (std_oval_minor_radius) * (std_oval_minor_radius)) &&
                ((std_oval_major_radius - 1) * (std_oval_major_radius - 1) * (x - circle_center_x)   * (x - circle_center_x) +
                 (std_oval_minor_radius - 1) * (std_oval_minor_radius - 1) * (y - circle_center_y)   * (y - circle_center_y) <=
                 (std_oval_major_radius)     * (std_oval_major_radius)     * (std_oval_minor_radius) * (std_oval_minor_radius)))||
               (((std_oval_minor_radius + 1) * (std_oval_minor_radius + 1) * (x - circle_center_x)   * (x - circle_center_x) +
                 (std_oval_major_radius + 1) * (std_oval_major_radius + 1) * (y - circle_center_y)   * (y - circle_center_y) >=
                 (std_oval_minor_radius)     * (std_oval_minor_radius)     * (std_oval_major_radius) * (std_oval_major_radius)) &&
                ((std_oval_minor_radius - 1) * (std_oval_minor_radius - 1) * (x - circle_center_x)   * (x - circle_center_x) +
                 (std_oval_major_radius - 1) * (std_oval_major_radius - 1) * (y - circle_center_y)   * (y - circle_center_y) <=
                 (std_oval_minor_radius)     * (std_oval_minor_radius)     * (std_oval_major_radius) * (std_oval_major_radius)))) begin
                
                pixel_data <= WHITE;

            end
            
            // Generating trail behind cursor
            if (mouse_l) begin
                if (((x == mouse_x) || ((x - mouse_x) == 1) || ((mouse_x - x) == 1)) && ((y == mouse_y) || ((y - mouse_y) == 1) || ((mouse_y - y) == 1))) begin
                    purple_drawing[mouse_pixel_index] <= 1;
                    if (purple_drawing[mouse_pixel_index] == 0) pixel_drawn <= (pixel_drawn + 1);
                end
                answered <= 1;
            end
            
            if ( purple_drawing [pixel_index] == 1 ) begin
                pixel_data <= PURPLE;
            end
        end 
        
        // Generating arbitrary great circle 
        if(((std_oval_major_radius + 1) * (std_oval_major_radius + 1) * (x - circle_center_x) * (x - circle_center_x) +
            (random_minor_radius + 1) * (random_minor_radius + 1) * (y - circle_center_y) * (y - circle_center_y) >=
            (std_oval_major_radius) * (std_oval_major_radius) * (random_minor_radius) * (random_minor_radius)) &&
           ((std_oval_major_radius - 1) * (std_oval_major_radius - 1) * (x - circle_center_x) * (x - circle_center_x) +
            (random_minor_radius - 2) * (random_minor_radius - 2) * (y - circle_center_y) * (y - circle_center_y) <=
            (std_oval_major_radius) * (std_oval_major_radius) * (random_minor_radius) * (random_minor_radius))) begin
            
            if (pixel_data != CYAN) pixel_correct <= (pixel_correct + 1);
                    
            // Generating 2 random points
            if (polarity) begin
                if ((x > circle_center_x) && (y > 4)) begin
                
                    if (((y+1) == (random_pt_H)) ||
                        ((y)   == (random_pt_H))) begin
                       
                        pixel_data <= CYAN;
                        
                    end
                    if (((y+2) == (random_pt_H)) ||
                       ((y-1) == (random_pt_H))) begin
                      
                        pixel_data <= BLACK;
                       
                    end
                    if (((y-1) == (random_pt_L)) ||
                       ((y)   == (random_pt_L))) begin
                      
                        pixel_data <= CYAN;
                       
                    end
                    if (((y-2) == (random_pt_L)) ||
                      ((y+1)   == (random_pt_L))) begin
                     
                        pixel_data <= BLACK;
                      
                    end 
                end       
            end
            
            if (~polarity) begin
                if ((x < circle_center_x) && (y > 4)) begin
                
                    if (((y+1) == (random_pt_H)) ||
                        ((y)   == (random_pt_H))) begin
                       
                        pixel_data <= CYAN;
                        
                    end
                    if (((y+2) == (random_pt_H)) ||
                       ((y-1) == (random_pt_H))) begin
                      
                        pixel_data <= BLACK;
                       
                    end
                    if (((y-1) == (random_pt_L)) ||
                       ((y)   == (random_pt_L))) begin
                      
                        pixel_data <= CYAN;
                       
                    end
                    if (((y-2) == (random_pt_L)) ||
                      ((y+1)   == (random_pt_L))) begin
                     
                        pixel_data <= BLACK;
                      
                    end 
                end       
            end

            // Generating geodesics
            if ((answered) && (~mouse_l)) begin
                if ((y >= random_pt_H) && (y <= random_pt_L)) begin
                    if (~polarity) begin
                        if (x < circle_center_x) pixel_data <= CYAN;
                    end
                    if (polarity) begin
                        if (x > circle_center_x) pixel_data <= CYAN;
                    end
                end
            end
        end
        
        // Cursor
        if (((x == mouse_x) || ((x - mouse_x) == 1) || ((mouse_x - x) == 1)) && ((y == mouse_y) || ((y - mouse_y) == 1) || ((mouse_y - y) == 1))) begin
            
            pixel_data <= ORANGE;
            
        end  
        
        // Analysis
        correct <= (answered && ~mouse_l && (pixel_drawn > (pixel_correct - 5)) && (pixel_drawn < (pixel_correct + 5)));
        incorrect <= (answered && ~mouse_l && ~correct);
        
        // Reset
        if (reset) answered = 0;
        if (reset) incorrect = 0;
        if (reset) correct = 0;
        if (reset) begin
            for ( i = 0; i < 6144; i = i + 1 ) begin
                purple_drawing [i] = 0;
            end
        end
    end
endmodule


module lfsr(input clock, reset, load, output reg [3:0] Q = 4'b0000);
    
    always @ (posedge clock, posedge reset)
    begin
        if (reset) Q <= 0;
        else if (load) begin
            Q[3:1] <= Q[2:0];
            Q[0] <= ~(Q[2]^Q[3]) ;
        end
    end

endmodule
