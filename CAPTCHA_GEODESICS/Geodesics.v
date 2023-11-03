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
    output reg [31:0] pixel_data = 16'b00000_111111_00000)
    output correct, incorrect;

    parameter BLUE   = 16'b00000_000000_11111;
    parameter BLACK  = 16'b00000_000000_00000;
    parameter ORANGE = 16'b11111_101101_00000;
    parameter WHITE  = 16'b11111_111111_11111;
    parameter GREEN  = 16'b00000_111111_00000;
    parameter CYAN   = 16'b00000_111111_11111;
    parameter PURPLE = 16'b11111_000000_11110;  
    parameter RED    = 16'b11111_000000_00000;
    parameter YELLOW = 16'b11111_111111_00000;
  
        
    // Debouncing
    reg [31:0] bounce = 0;
    
    reg [10:0] state = 0;
    
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
    reg [10:0] pixel_off = 0;
    reg [10:0] pixel_overlap = 0;
    
    ////////////////////////////////////////////// TBC //////////////////////////////////////////////
    assign led[15] = answered;
    assign led[14] = incorrect;
    assign led[13] = correct;
    assign led[12] = (~bounce);
    assign led[10:0] = state;
    ////////////////////////////////////////////// TBC //////////////////////////////////////////////
    
    // Hold to draw
    reg [2:0] drawing = 0;
    reg drawing_1 [ 0 : 6143 ];
    reg drawing_2 [ 0 : 6143 ];
    reg drawing_3 [ 0 : 6143 ];
    reg red_1 [ 0 : 6143 ];
    reg red_2 [ 0 : 6143 ];
    reg red_3 [ 0 : 6143 ];
    reg compare_1 [ 0 : 6143 ];
    reg compare_2 [ 0 : 6143 ];
    reg compare_3 [ 0 : 6143 ];

    integer i;
    
    initial begin
        for ( i = 0; i < 6144; i = i + 1 ) begin
            drawing_1 [i] = 0;
        end
    end
    
    initial begin
        for ( i = 0; i < 6144; i = i + 1 ) begin
            red_1 [i] = 0;
        end
    end
    
    initial begin
        for ( i = 0; i < 6144; i = i + 1 ) begin
            compare_1 [i] = 0;
        end
    end  
    
    initial begin
        for ( i = 0; i < 6144; i = i + 1 ) begin
            drawing_2 [i] = 0;
        end
    end
    
    initial begin
        for ( i = 0; i < 6144; i = i + 1 ) begin
            red_2 [i] = 0;
        end
    end
    
    initial begin
        for ( i = 0; i < 6144; i = i + 1 ) begin
            compare_2 [i] = 0;
        end
    end  
    
    initial begin
        for ( i = 0; i < 6144; i = i + 1 ) begin
            drawing_3 [i] = 0;
        end
    end
    
    initial begin
        for ( i = 0; i < 6144; i = i + 1 ) begin
            red_3 [i] = 0;
        end
    end    
    
    initial begin
        for ( i = 0; i < 6144; i = i + 1 ) begin
            compare_3 [i] = 0;
        end
    end  
    
    // Track drawing
    wire [12:0] mouse_pixel_index;
    assign mouse_pixel_index = mouse_y * 96 + mouse_x;

    
    // Main loop
    always @(posedge clock) begin
        if (sw[0]) begin 
            state <= pixel_drawn;
        end
        
        if (sw[1]) begin 
            state <= pixel_off;
        end
        
        if (sw[2]) begin 
            state <= pixel_correct;
        end
        
        if (sw[3]) begin 
            state <= pixel_overlap;
        end
        
        if ((bounce == 0) && (reset)) begin
            bounce <= 1;
            answered = 0;
            incorrect = 0;
            correct = 0;
            pixel_drawn = 0;
            pixel_correct = 0;
            pixel_overlap = 0;
            pixel_off = 0;
            drawing <= drawing + 1;
        end
        
        bounce = ( bounce == 9_999_999 || bounce == 0 ) ? 0 : bounce + 1;          
         
        if (drawing < 4) begin
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
                    if (((x == mouse_x) || ((x - mouse_x) == 1)) && 
                        ((y == mouse_y) || ((y - mouse_y) == 1) )) begin
                        if (drawing == 1) begin
                            drawing_1[pixel_index] <= 1;
                            if (drawing_1[pixel_index] == 0) begin 
                                pixel_drawn <= (pixel_drawn + 1);
                            end
                        end
                        if (drawing == 2) begin
                            drawing_2[pixel_index] <= 1;
                            if (drawing_2[pixel_index] == 0) begin
                                pixel_drawn <= (pixel_drawn + 1);
                            end
                        end       
                        if (drawing == 3) begin
                            drawing_3[pixel_index] <= 1;
                            if (drawing_3[pixel_index] == 0) begin
                                pixel_drawn <= (pixel_drawn + 1);
                            end
                        end                      
                    end
                    answered <= 1;
                end
                
                if ( drawing_1 [pixel_index] == 1 ) begin
                    pixel_data <= PURPLE;
                end

                if ( drawing_2 [pixel_index] == 1 ) begin
                    pixel_data <= GREEN;
                end

                if ( drawing_3 [pixel_index] == 1 ) begin
                    pixel_data <= PURPLE;
                end

            end 
            
            // Generating arbitrary great circle 
            if(((std_oval_major_radius + 1) * (std_oval_major_radius + 1) * (x - circle_center_x) * (x - circle_center_x) +
                (random_minor_radius + 2) * (random_minor_radius + 2) * (y - circle_center_y) * (y - circle_center_y) >=
                (std_oval_major_radius) * (std_oval_major_radius) * (random_minor_radius) * (random_minor_radius)) &&
               ((std_oval_major_radius - 1) * (std_oval_major_radius - 1) * (x - circle_center_x) * (x - circle_center_x) +
                (random_minor_radius - 2) * (random_minor_radius - 2) * (y - circle_center_y) * (y - circle_center_y) <=
                (std_oval_major_radius) * (std_oval_major_radius) * (random_minor_radius) * (random_minor_radius))) begin
                
                if (pixel_data == RED) begin
                    if (drawing == 1) begin
                        if (red_1 [pixel_index] == 0) begin
                            red_1 [pixel_index] <= 1;
                            pixel_correct <= pixel_correct + 1;
                        end
                    end
                    if (drawing == 2) begin
                        if (red_2 [pixel_index] == 0) begin
                            red_2 [pixel_index] <= 1;
                            pixel_correct <= pixel_correct + 1;
                        end
                    end       
                    if (drawing == 3) begin
                        if (red_3 [pixel_index] == 0) begin
                            red_3 [pixel_index] <= 1;
                            pixel_correct <= pixel_correct + 1;
                        end
                    end
                end
                        
                // Generating 2 random points
                if (polarity) begin
                    if ((x > circle_center_x) && (y > 4)) begin
                    
                        if (((y+1) == (random_pt_H)) ||
                            ((y-1) == (random_pt_H)) ||
                            ((y)   == (random_pt_H))) begin
                           
                            pixel_data <= RED;
                            
                        end
                        if (((y+2) == (random_pt_H)) ||
                           ((y-2) == (random_pt_H))) begin
                          
                            pixel_data <= BLACK;
                           
                        end
                        if (((y-1) == (random_pt_L)) ||
                            ((y+1) == (random_pt_L)) ||
                           ((y)   == (random_pt_L))) begin
                          
                            pixel_data <= RED;
                           
                        end
                        if (((y-2) == (random_pt_L)) ||
                          ((y+2)   == (random_pt_L))) begin
                         
                            pixel_data <= BLACK;
                          
                        end 
                    end       
                end
                
                if (~polarity) begin
                    if ((x < circle_center_x) && (y > 4)) begin
                    
                        if (((y+1) == (random_pt_H)) ||
                            ((y-1) == (random_pt_H)) ||
                            ((y)   == (random_pt_H))) begin
                           
                            pixel_data <= RED;
                            
                        end
                        if (((y+2) == (random_pt_H)) ||
                           ((y-2) == (random_pt_H))) begin
                          
                            pixel_data <= BLACK;
                           
                        end
                        if (((y-1) == (random_pt_L)) ||
                            ((y+1) == (random_pt_L)) ||
                           ((y)   == (random_pt_L))) begin
                          
                            pixel_data <= RED;
                           
                        end
                        if (((y-2) == (random_pt_L)) ||
                            ((y+2) == (random_pt_L))) begin
                         
                            pixel_data <= BLACK;
                          
                        end 
                    end       
                end
    
                // Generating geodesics
                if ((answered) && (~mouse_l)) begin
                    if ((y >= random_pt_H) && (y <= random_pt_L)) begin
                        if (~polarity) begin
                            if (x < circle_center_x) pixel_data <= RED;
                        end
                        if (polarity) begin
                            if (x > circle_center_x) pixel_data <= RED;
                        end
                    end
                end
            end
            
            if (drawing == 1) begin
                if (compare_1 [pixel_index] == 0) begin
                    if ((red_1 [pixel_index] == 1) && (drawing_1 [pixel_index] == 1)) begin
                        pixel_overlap <= pixel_overlap + 1;
                        compare_1 [pixel_index] <= 1;
                    end
                    if ((red_1 [pixel_index] == 0) && (drawing_1 [pixel_index] == 1)) begin
                        pixel_off <= pixel_off + 1;
                        compare_1 [pixel_index] <= 1;
                    end
                end
            end
            if (drawing == 2) begin
                if (compare_2 [pixel_index] == 0) begin
                    if ((red_2 [pixel_index] == 1) && (drawing_2 [pixel_index] == 1)) begin
                        pixel_overlap <= pixel_overlap + 1;
                        compare_2 [pixel_index] <= 1;
                    end
                    if ((red_2 [pixel_index] == 0) && (drawing_2 [pixel_index] == 1)) begin
                        pixel_off <= pixel_off + 1;
                        compare_2 [pixel_index] <= 1;
                    end
                end
            end       
            if (drawing == 3) begin
                if (compare_3 [pixel_index] == 0) begin
                    if ((red_3 [pixel_index] == 1) && (drawing_3 [pixel_index] == 1)) begin
                        pixel_overlap <= pixel_overlap + 1;
                        compare_3 [pixel_index] <= 1;
                    end
                    if ((red_3 [pixel_index] == 0) && (drawing_3 [pixel_index] == 1)) begin
                        pixel_off <= pixel_off + 1;
                        compare_3 [pixel_index] <= 1;
                    end
                end
            end
            
            // Cursor
            if (((x == mouse_x) || ((x - mouse_x) == 1) || ((mouse_x - x) == 1)) && ((y == mouse_y) || ((y - mouse_y) == 1) || ((mouse_y - y) == 1))) begin
                
                pixel_data <= ORANGE;
                
            end  
            
            // Analysis
            correct <= (answered && ~mouse_l && (pixel_overlap > 7) && (pixel_off < 128));
            incorrect <= (answered && ~mouse_l && (~correct));
            
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
