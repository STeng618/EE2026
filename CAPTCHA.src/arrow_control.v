`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.10.2023 18:23:51
// Design Name: 
// Module Name: arrow_control
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


module arrow_control(input clock, btnR, btnL, btnD, btnU, en, [12:0] pixel_index, output reg [15:0]oled_arrow, output reg [2:0] arrow_direction);

wire [6:0] x;
assign x = pixel_index%96;
    
wire [5:0] y;
assign y = pixel_index/96;

reg [2:0] arrow_pos = 0;

reg [2:0] temp_arrow = 0;

reg [15:0] temp_oled;

reg submit = 0;

wire is_100ms;

counter_100ms unit_counter_B (.clock(clock),
                              .btnL(btnL),
                              .btnR(btnR),
                              .border_pos(arrow_pos),
                              .is_100ms(is_100ms));
                              
always @(posedge clock) begin
    if (en) begin
        if (btnD) begin
        submit <= 1;
//        arrow_pos = temp_arrow;
//        oled_arrow = temp_oled;
        end
    
        if (btnU) begin
            submit <= 0;
        end 
        
        if (!submit) begin        
            if (btnR && is_100ms) begin
                arrow_pos = arrow_pos == 5 ? 0 : arrow_pos + 1;
            end
            if (btnL && is_100ms) begin
                arrow_pos = arrow_pos == 0 ? 5 : arrow_pos - 1;
            end
        end
    end
    else arrow_pos <= 0;

        
        arrow_direction <= arrow_pos;
//        temp_arrow <= arrow_pos;
//        temp_oled <= oled_arrow;
        end
    
    always @ ( pixel_index ) begin
    case (arrow_pos)
    0: oled_arrow = ((x == 43 && y >= 12 && y <= 18)|| (x == 42 && y == 13)|| (x == 41 && y == 14)|| (x == 44 && y == 13)||(x == 45 && y == 14)) ? 16'b11111_000000_00000 : 0;
    
    1: oled_arrow = ((x == 44 && y == 17)|| (x == 45 && y == 16)|| (x == 46 && y == 15)|| (x == 47 && y == 14)|| (x == 48 && y == 13)|| (x == 47 && y == 13)|| (x == 46 && y == 13)|| (x == 48 && y >= 14 && y <= 15)) ? 16'b11111_000000_00000 : 0;
    
    2: oled_arrow = ((x == 44 && y == 19)|| (x == 45 && y == 20)|| (x == 46 && y == 21)||(x == 47 && y == 22)|| (x == 48 && y >= 21 && y <= 23)|| (x >= 46 && x <= 47 && y == 23)) ? 16'b11111_000000_00000 : 0;
    
    3: oled_arrow = ((x == 43 && y >= 19 && y <= 24)|| (x == 42 && y == 23)|| (x == 41 && y == 22)|| (x == 44 && y == 23)|| (x == 45 && y == 22)) ? 16'b11111_000000_00000 : 0;
    
    4: oled_arrow = ((x == 42 && y == 19)|| (x == 41 && y == 20)|| (x == 40 && y == 21)|| (x == 39 && y == 22)|| (x == 38 && y >= 21 && y <= 23)|| (x >= 39 && x <= 40 && y == 23)) ? 16'b11111_000000_00000 : 0;
    
    5: oled_arrow = ((x == 42 && y == 17)|| (x == 41 && y == 16)|| (x == 40 && y == 15)|| (x == 39 && y >= 14 && y <= 16)|| (x >= 40 && x <= 41 && y == 14)) ? 16'b11111_000000_00000 : 0;

    default: oled_arrow = 0;
    
    endcase
    end 

endmodule
