`timescale 1ns / 1ps


module counter_100ms(input clock, btnL, btnR, [2:0] border_pos, output reg is_100ms = 1);

reg [31:0] count_100ms = 0;

    always @(posedge clock) begin
        if (!is_100ms) begin
            count_100ms = count_100ms + 1;
            if (count_100ms == 9_999_999) begin
                is_100ms <= 1;
                count_100ms <= 0;
            end
        end
        
        if ( ( btnL && border_pos != 0 ) || ( btnR && border_pos != 4) ) begin
            is_100ms <= 0;
        end
        
    end
        

endmodule