module SEVEN_SEG_MANAGER (
    input clock, is_group_running, 
    input [6:0] paint_seg,
    output reg dp,
    output reg [6:0] seg, output reg [3:0] an
);

    reg [6:0] L = 7'b1000111;
    reg [6:0] A = 7'b0001000;
    reg [6:0] U = 7'b1000001;
    reg [1:0] current_anode = 0;

    wire clk_1000Hz;
    clock_divider clock_1000Hz_inst ( clock, 49_999, clk_1000Hz );

    always @ (posedge clk_1000Hz) begin
        current_anode <= ( current_anode == 3 ) ? 0 : current_anode + 1; 
    end

    always @ (posedge clk_1000Hz) begin
        an <= 4'b1111; 
        dp <= 1;
        if ( is_group_running ) begin
            case (current_anode)
                0:
                    begin
                        an <= 4'b1110;
                        seg <=  paint_seg;
                        dp <= 1;
                    end
                1: 
                    begin
                        an <= 4'b1101;
                        seg <= L;
                        dp <= 0;
                    end
                2:
                    begin
                        an <= 4'b1011;
                        seg <= A;
                        dp <= 1;
                    end
                3:
                    begin
                        an <= 4'b0111;
                        seg <= U;
                        dp <= 1;
                    end
            endcase
        end
    end

endmodule