`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.10.2023 17:21:43
// Design Name: 
// Module Name: counter_100ms
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


module counter_100ms(input clock, btnL, btnR, btnD, btnU, [3:0] border_pos, output reg is_100ms = 1);

reg [31:0] count_100ms = 0;

    always @(posedge clock) begin
        if (!is_100ms) begin
            count_100ms = count_100ms + 1;
            if (count_100ms == 9_999_999) begin
                is_100ms <= 1;
                count_100ms <= 0;
            end
        end
        
        if ( ( btnL) || ( btnR) || (btnD) || (btnU)) begin
            is_100ms <= 0;
        end
        
    end
        

endmodule
