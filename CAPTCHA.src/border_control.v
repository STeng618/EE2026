`timescale 1ns / 1ps


module border_control(input clock, btnR, btnL, btnD, btnU, en, [12:0] pixel_index, output reg [15:0] oled_border, output reg submit_btn);

wire [6:0] x;
assign x = pixel_index%96;
    
wire [5:0] y;
assign y = pixel_index/96;
    
reg [6:0] temp_pos = 3, centre = 67;

reg [2:0] border_pos = 3;

reg submit = 0;

wire is_100ms;

counter_100ms unit_counter_A (.clock(clock),
                              .btnL(btnL),
                              .btnR(btnR),
                              .border_pos(border_pos),
                              .is_100ms(is_100ms));

always @(posedge clock) begin
    if (en) begin    
        if (!submit) begin
            if (btnR && is_100ms ) begin
                border_pos = border_pos == 5 ? 0 : border_pos + 1;
            end
            
            if (btnL && is_100ms) begin
                border_pos = border_pos == 0 ? 5 : border_pos - 1;
            end
            
            oled_border = (x >= centre-4 && x <= centre+4 && y >= 37 && y <= 45) && !(x >= centre-2 && x <= centre+2 && y >= 39 && y <= 43) ? 16'b00000_111111_00000 : 0;
            
        end
            
    //    if (border_pos == 6) border_pos = 0;
    //    else if (border_pos > 6) border_pos = 5;
        
        temp_pos = border_pos;
        
        centre = border_pos * 9 + 40;
        
        if (submit) begin
            oled_border = (x >= 25 && x <= 67 && y >= 47 && y <= 61) && !(x >= 27 && x <= 65 && y >= 49 && y <= 59) ? 16'b00000_111111_00000 : 0 ;
        end
        
        if (btnD && is_100ms) begin
            submit = 1;
        end
        
        if (btnU && is_100ms) begin
            submit = 0;
        end
        
        submit_btn <= submit;    
    end
    else border_pos <= 3;
end


//end

endmodule
