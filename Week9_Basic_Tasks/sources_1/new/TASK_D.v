`timescale 1ns / 1ps

module TASK_D (
    input clock, btnC, btnL, btnR,
    input [6:0] x, input [5:0]y,
    input is_taskD_running,
    output reg [15:0] pixel_data_D
);
    
    parameter BLUE = 16'b00000_000000_11111;
    parameter GREEN = 16'b00000_111111_00000;
    parameter BLACK = 16'b00000_000000_00000;
    
    reg L_pressed = 0;
    reg R_pressed = 0;
    reg unlocked = 0;
    
    reg [6:0] center_x = 48;
    reg [6:0] center_y = 32;
        
    reg [31:0] counter = 0;
    
    always @ (posedge clock)
    begin   
        if (~is_taskD_running) begin //start button, reset everytime
            unlocked <= 0;
            center_x <= 48;
            center_y = 32;
            counter = 0;
            L_pressed = 0;
            R_pressed = 0;
        end
        
        else if (btnR) begin
            R_pressed <= 1;
            L_pressed <= 0;
        end
        else if (btnL) begin
            L_pressed <= 1;
            R_pressed <= 0;
        end
        else if (btnC) begin
            unlocked <= 1;
        end


        if (R_pressed && (center_x < 93)) begin
            counter <= (counter == 1_249_999) ? 0 : counter + 1;
            center_x <= (counter == 1_249_999) ? center_x + 1: center_x;
        end
        
        else if (L_pressed && (center_x >2)) begin
            counter <= (counter == 1_249_999) ? 0 : counter + 1;
            center_x <= (counter == 1_249_999) ? center_x - 1: center_x;
        end
        
        
        if (~unlocked) begin
            pixel_data_D <= ((x >= 0 && x <=4) && 
                          (y >= 0 && y <=4)) ? 
                          BLUE : BLACK;
        end else begin
            pixel_data_D <= ((x >= (center_x -2) && x <= (center_x +2)) && 
                          (y >= (center_y -2) && y <= (center_y +2))) ? 
                          GREEN : BLACK;
        end        
    end
        
endmodule
