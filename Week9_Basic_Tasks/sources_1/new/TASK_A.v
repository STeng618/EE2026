`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2023 04:06:16 PM
// Design Name: 
// Module Name: TaskA
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


module TASK_A(
    input clock, btnC, btnU, is_taskA_running,
    input [31:0] x, y,
    output reg [15:0] pixel_data_A
    );
    
    reg btnCd = 0;
    reg square = 0;
    
    reg [31:0] bouncer = 0;
    reg [31:0] counter = 0;
    
    always @(posedge clock) begin
        pixel_data_A = 0;
        
        if (! is_taskA_running) begin
            btnCd <= 0;
            square <= 0;
            bouncer <= 0;
            counter <= 0;
        end
        
        else begin
            if ( y == 3 || y == 60 ) begin
                if ( x >= 3 && x <= 92 ) pixel_data_A <= 16'b11111_000000_00000; // Top and bottom outer border lines
            end
            
            else begin
                if ( y > 3 && y < 60 ) begin // Side outer border lines
                    if ( x == 3 || x == 92 ) pixel_data_A <= 16'b11111_000000_00000; 
                    
                    else begin
                        if ( btnCd ) begin // Checks if btnC has been pressed
                            counter = ( counter == 549_999_999 ) ? 0 : counter + 1; // The sequence loops every 5.5 s
                            
                            if ( ( y >= 6 && y <= 8 ) || ( y >= 55 && y <= 57 ) ) begin // Orange box top and bottom border lines
                                if ( x >= 6 && x <= 89 ) pixel_data_A <= 16'hfd60;
                            end
                           
                            else begin
                                if ( y > 6 && y < 55 ) begin
                                    if ( ( x >= 6 && x <= 8 ) || ( x >= 87 && x <= 89 ) ) pixel_data_A <= 16'hfd60;
                                    
                                    else begin
                                        if ( counter >= 199_999_999 ) begin
                                            if ( y == 11 || y == 52 ) begin
                                                if ( x >= 11 && x <= 84 ) pixel_data_A = 16'b00000_111111_00000;
                                            end
                                            else begin
                                                if ( y > 11 && y < 52 ) begin
                                                    if ( x == 11 || x == 84 ) pixel_data_A = 16'b00000_111111_00000;
                                                end
                                            end
                                            
                                            if ( counter >= 349_999_999 ) begin
                                                if ( ( y >= 14 && y <= 15 ) || ( y >= 48 && y <= 49 ) ) begin
                                                    if ( x >= 14 && x <= 81 ) pixel_data_A = 16'b00000_111111_00000;
                                                end
                                                else begin
                                                   if ( y > 15 && y < 48 ) begin
                                                        if ( ( x >= 14 && x <= 15 ) || ( x >= 80 && x <= 81 ) ) pixel_data_A = 16'b00000_111111_00000;
                                                    end
                                                end
                                                
                                                if ( counter >= 449_999_999 ) begin
                                                    if ( ( y >= 18 && y <= 20 ) || ( y >= 43 && y <= 45 ) ) begin
                                                        if ( x >= 18 && x <= 77 ) pixel_data_A = 16'b00000_111111_00000;
                                                    end
                                                    else begin 
                                                        if ( y > 20 && y < 43 ) begin
                                                            if ( ( x >= 18 && x <= 20 ) || ( x >= 75 && x <= 77 ) ) pixel_data_A = 16'b00000_111111_00000;
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                    
                                    if ( bouncer == 0 && btnU ) begin
                                        square = ~square;
                                        bouncer = 1;
                                    end
                                    
                                    bouncer = ( bouncer == 9_999_999 || bouncer == 0 ) ? 0 : bouncer + 1;
                                    
                                    if ( square ) begin
                                        if ( y >= 29 && y <= 34 ) begin
                                            if ( x >= 45 && x <= 50 ) pixel_data_A = 16'b11111_000000_00000;
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            
            if ( btnC ) btnCd = 1;
        end
    end
endmodule
