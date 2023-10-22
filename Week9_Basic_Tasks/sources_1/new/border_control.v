`timescale 1ns / 1ps


module border_control(input clock, btnR, btnL, is_taskB_running, output reg [2:0] border_pos = 2);

wire is_100ms;

counter_100ms unit_counter_A (.clock(clock),
                              .btnL(btnL),
                              .btnR(btnR),
                              .border_pos(border_pos),
                              .is_100ms(is_100ms));

always @(posedge clock) begin
    if (!is_taskB_running) begin
        border_pos <= 2;
    end else begin               
        if (btnR && is_100ms && border_pos != 4) begin
            border_pos = border_pos + 1;
        end
        
        if (btnL && is_100ms && border_pos != 0) begin
            border_pos = border_pos - 1;
        end
    end 
end

endmodule