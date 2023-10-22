`timescale 1ns / 1ps


module TASK_B (
    input clock, btnL, btnR,
    input [6:0] x, input [5:0]y,
    input is_taskB_running,
    output reg [15:0] pixel_data_B
);

reg [15:0] green = 16'b00000_111111_00000;
reg [15:0] white = 16'b11111_111111_11111;
reg [15:0] black = 0;
     
wire is_3s;
counter_3s delay_3_seconds(.clock(clock), .is_taskB_running(is_taskB_running),
                           .is_3s(is_3s));
    
wire is_white_square;
assign is_white_square = (x >= 7 && x <= 15 && y >= 27 && y <= 35) ||
                         (x >= 25 && x <= 33 && y >= 27 && y <= 35) ||
                         (x >= 43 && x <= 51 && y >= 27 && y <= 35) ||                
                         (x >= 61 && x <= 69 && y >= 27 && y <= 35) ||
                         (x >= 79 && x <= 87 && y >= 27 && y <= 35);
wire [2:0] border_pos;                         
wire is_green_border;
wire [6:0] centre;
assign centre = border_pos * 18 + 11;
    
assign is_green_border = (x >= centre-10 && x <= centre+10 && y >= 21 && y <= 41) && !(x >= centre-7 && x <= centre+7 && y >= 24 && y <= 38); 
    
always @(posedge clock) begin
    if ( !is_taskB_running ) begin 
        pixel_data_B <= 0;
    end else begin 
        pixel_data_B <= black;
        if (is_green_border) begin
            pixel_data_B <= green;
        end
        if (is_3s) begin
            if (is_white_square) begin
                pixel_data_B <= white;
            end
        end
    end 
end


border_control border_position (.clock(clock),
                                .btnR(btnR),
                                .btnL(btnL),
                                .is_taskB_running (is_taskB_running),
                                .border_pos(border_pos));
endmodule