module LED_MANAGER (
    input clock, input [15:0] paint_led,
    input is_taskA_running, is_taskB_running, is_taskC_running, is_taskD_running, is_group_running,
    output reg [15:0] led
);

    // Signals for blinking the LED at 5Hz
    wire clk_10Hz;
    clock_divider clock_5Hz_inst ( clock, 4_999_999, clk_10Hz );
    reg is_lit_up = 1; 

    always @ ( posedge clk_10Hz ) begin

        if ( is_group_running ) begin
            if ( is_lit_up ) begin
                led <= paint_led;
                is_lit_up <= 0;
            end else begin
                led <= 0;
                is_lit_up <= 1;
            end
        end 

        if ( is_taskA_running ) begin
            led <= 1;
        end 
            
        if ( is_taskB_running ) begin
            led <= 2;
        end 
            
        if ( is_taskC_running ) begin
            led <= 4;
        end 
            
        if ( is_taskD_running ) begin
            led <= 8;
        end     
             
    end

endmodule