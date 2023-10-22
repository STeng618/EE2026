module TASK_C (
    input clock, btnC,
    input [6:0] x, input [5:0]y,
    input is_taskC_running,
    output [15:0] pixel_data_C
);

    wire [6:0] square_count;
    SQUARE_COUNTER square_counter ( btnC, clock, is_taskC_running, square_count );
    
    ANIMATOR animator ( 
       .clock (clock), .x (x), .y (y), .square_count (square_count),
       .pixel_data (pixel_data_C)
   );
endmodule

module SQUARE_COUNTER (
    input btnC, clock, is_taskC_running, 
    output reg [6:0] square_count = 0
);
    wire clk_20Hz; 
    clock_divider clock_20Hz_inst ( clock, 2_499_999, clk_20Hz );

//    wire clk_1Hz;
//    clock_divider clock_1Hz_inst ( clock, 49_999_999, clk_1Hz );
    
    reg is_animation_activated = 0;  
    reg [6:0] count_20 = 0;

    wire is_waiting_for_1sec;
    assign is_waiting_for_1sec = ( square_count == 45 || square_count == 46 || square_count == 91 );

//    wire current_clock;
//    assign current_clock = is_animation_activated ? 
//                           ( is_waiting_for_1sec ? clk_1Hz : clk_20Hz ) 
//                           : clock ;
    
    always @ ( posedge clk_20Hz ) begin

        if ( is_taskC_running ) begin

            if ( btnC ) begin
                is_animation_activated <= 1;
            end

            if ( is_animation_activated ) begin 
                 if ( is_waiting_for_1sec ) begin
                      count_20 = count_20 + 1;
                      if ( count_20 == 20 ) begin
                          count_20 = 0;
                          if ( square_count == 91 ) begin
                              square_count <= 0;
                              is_animation_activated <= 0;
                          end else begin
                              square_count <= square_count + 1;
                          end
                      end
                 end else begin
                      square_count <= square_count + 1;
                 end
            end 

        end else begin

            square_count <= 0;
            is_animation_activated <= 0;

        end

    end

endmodule

module ANIMATOR (
    input clock, input [6:0] x, input [5:0] y, input [6:0] square_count,
    output reg [15:0] pixel_data = 0
);

    wire clk_25M;
    clock_divider clock_25M_inst ( clock, 1, clk_25M );

    reg [15:0] red = 16'b11111_000000_00000;
    reg [15:0] green = 16'b00000_111111_00000;
    reg is_part_of_vertical = 0;
    reg is_part_of_horizontal = 0;

    always @ ( posedge clk_25M ) begin
        is_part_of_vertical = ( x >= 46 && x <= 48 ) && ( y >= 0 && y <= 32 );
        is_part_of_horizontal = ( x >= 46 && x <= 63 ) && ( y >= 30 && y <= 32 );

        if ( !is_part_of_vertical && !is_part_of_horizontal ) begin
            pixel_data <= 0;
        end else begin
            if ( square_count <= 30 ) begin
                pixel_data <= 0;
                if ( y <= square_count + 2 && x <= 48  ) begin
                    pixel_data <= red;
                end
            end

            if ( square_count >= 31 && square_count <= 45 ) begin
                pixel_data <= 0;
                if ( x <= square_count + 18 ) begin
                    pixel_data <= red;
                end
            end

            if ( square_count == 46 ) begin
                pixel_data <= red;
                if ( x >= 61 && x <= 63 && y >= 30 && y <= 32 ) begin
                    pixel_data <= green;
                end
            end

            if ( square_count >= 47 && square_count <= 61 ) begin
                pixel_data <= red;
                if ( y >= 30 && x >= 60 - ( square_count - 47 ) ) begin
                    pixel_data <= green;
                end
            end

            if ( square_count >= 62 && square_count <= 91 ) begin
                pixel_data <= green;
                if ( y < 29 - ( square_count - 62 ) ) begin
                    pixel_data <= red;
                end
            end

        end
    end

endmodule