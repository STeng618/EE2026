`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.10.2023 17:12:52
// Design Name: 
// Module Name: ANIMATION_SECOND
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

module ANIMATION_SECOND(
    input clock, 
    input reset, 
    input is_first_part_completed, 
    input mouse_left, input [11:0] mouse_x, mouse_y, 
    input [12:0] pixel_index, input [6:0] pixel_x, pixel_y, 
    output reg [15:0] pixel_data, 
    output reg is_second_part_completed = 0,
    output reg [15:0] led, 
    output reg [4:0] first_inp = NULL_SERIAL, second_inp = NULL_SERIAL, third_inp = NULL_SERIAL,
    output reg [4:0] fourth_inp = NULL_SERIAL, fifth_inp = NULL_SERIAL, sixth_inp = NULL_SERIAL
    
);

    reg [15:0] Ap [ 0 : 80 ]; 
    reg [15:0] Bp [ 0 : 80 ]; 
    reg [15:0] Cp [ 0 : 80 ]; 
    reg [15:0] Dp [ 0 : 80 ]; 
    reg [15:0] Ep [ 0 : 80 ]; 
    reg [15:0] Fp [ 0 : 80 ]; 
    reg [15:0] Gp [ 0 : 80 ]; 
    reg [15:0] Hp [ 0 : 80 ]; 
    reg [15:0] Ip [ 0 : 80 ]; 
    reg [15:0] Jp [ 0 : 80 ]; 
    reg [15:0] Kp [ 0 : 80 ]; 
    reg [15:0] Lp [ 0 : 80 ]; 
    reg [15:0] Mp [ 0 : 80 ]; 
    reg [15:0] Np [ 0 : 80 ]; 
    reg [15:0] Op [ 0 : 80 ]; 
    reg [15:0] Pp [ 0 : 80 ]; 
    reg [15:0] Qp [ 0 : 80 ]; 
    reg [15:0] Rp [ 0 : 80 ]; 
    reg [15:0] Sp [ 0 : 80 ]; 
    reg [15:0] Tp [ 0 : 80 ]; 
    reg [15:0] Up [ 0 : 80 ]; 
    reg [15:0] Vp [ 0 : 80 ]; 
    reg [15:0] Wp [ 0 : 80 ]; 
    reg [15:0] Xp [ 0 : 80 ]; 
    reg [15:0] Yp [ 0 : 80 ]; 
    reg [15:0] Zp [ 0 : 80 ]; 
    reg [15:0] keyboard [ 0 : 6143 ];
    initial begin
        $readmemh ( "keyboard-pixilart.mem", keyboard );
        $readmemh ( "A.mem", Ap );
        $readmemh ( "B.mem", Bp );
        $readmemh ( "C.mem", Cp );
        $readmemh ( "D.mem", Dp );
        $readmemh ( "E.mem", Ep );
        $readmemh ( "F.mem", Fp );
        $readmemh ( "G.mem", Gp );
        $readmemh ( "H.mem", Hp );
        $readmemh ( "I.mem", Ip );
        $readmemh ( "J.mem", Jp );
        $readmemh ( "K.mem", Kp );
        $readmemh ( "L.mem", Lp );
        $readmemh ( "M.mem", Mp );
        $readmemh ( "N.mem", Np );
        $readmemh ( "O.mem", Op );
        $readmemh ( "P.mem", Pp );
        $readmemh ( "Q.mem", Qp );
        $readmemh ( "R.mem", Rp );
        $readmemh ( "S.mem", Sp );
        $readmemh ( "T.mem", Tp );
        $readmemh ( "U.mem", Up );
        $readmemh ( "V.mem", Vp );
        $readmemh ( "W.mem", Wp );
        $readmemh ( "X.mem", Xp );
        $readmemh ( "Y.mem", Yp );
        $readmemh ( "Z.mem", Zp );
    end 

    reg [4:0] input_square_serial_record [ MAX_ROUND - 1 : 0 ];
    integer i;
    initial begin 
        for ( i = 0; i < MAX_ROUND; i = i + 1 ) begin
            input_square_serial_record [i] = NULL_SERIAL; 
        end 
    end
     
    wire [4:0] mouse_serial;
    MOUSE_SERIAL_RETRIEVAL mouser_serial_ins ( mouse_x, mouse_y, mouse_serial );
    reg [2:0] current_input_square = 0;
    
    always @ ( posedge mouse_left, posedge reset ) begin
    
        if ( reset ) begin 
            is_second_part_completed <= 0;
            current_input_square = 0;
            for ( i = 0; i < MAX_ROUND; i = i + 1 ) begin
                input_square_serial_record [i] = NULL_SERIAL;
            end 
        end else if ( is_first_part_completed && !is_second_part_completed ) begin 
            case ( mouse_serial ) 
                BACKSPACE : 
                    begin
                        if ( current_input_square != 0 ) begin
                            input_square_serial_record [ current_input_square - 1 ] = NULL_SERIAL;
                            current_input_square = current_input_square - 1;
                        end 
                    end 
                ENTER : 
                    begin
                        is_second_part_completed <= 1;
                        first_inp <= input_square_serial_record [0]; 
                        second_inp <= input_square_serial_record [1]; 
                        third_inp <= input_square_serial_record [2]; 
                        fourth_inp <= input_square_serial_record [3]; 
                        fifth_inp <= input_square_serial_record [4]; 
                        sixth_inp <= input_square_serial_record [5]; 
                    end
                NULL_SERIAL : 
                    begin
                        // ignore 
                    end
                default : 
                    begin
                        if ( current_input_square != MAX_ROUND ) begin
                            input_square_serial_record [ current_input_square ] = mouse_serial;
                            current_input_square = current_input_square + 1;
                        end 
                    end
            endcase 
        end // else if ( is_first_part_completed && ! is_second_part_completed ) 
    end // always 
    
    always @ ( * ) begin // For debugging 
        led <= 0;
        if ( first_inp <= 15 && first_inp >= 0 ) begin led [first_inp] <= 1; end 
        if ( second_inp <= 15 && second_inp >= 0 ) begin led [second_inp] <= 1; end 
        if ( third_inp <= 15 && third_inp >= 0 ) begin led [third_inp] <= 1; end 
        if ( fourth_inp <= 15 && fourth_inp >= 0 ) begin led [fourth_inp] <= 1; end 
        if ( fifth_inp <= 15 && fifth_inp >= 0 ) begin led [fifth_inp] <= 1; end 
        if ( sixth_inp <= 15 && sixth_inp >= 0 ) begin led [sixth_inp] <= 1; end 
    end 

    wire is_pixel_in_input_squares;
    wire [6:0] normalised_pixel_index; // from 0 - 80;
    wire [2:0] pixel_input_squares;
    PIXEL_INPUT_MANAGER pixel_input_square_inst (
        .pixel_x ( pixel_x ), .pixel_y ( pixel_y ), 
        .is_pixel_in_input_squares ( is_pixel_in_input_squares ), 
        .normalised_pixel_index ( normalised_pixel_index ), 
        .pixel_input_squares ( pixel_input_squares )
    );
    
    reg [15:0] pixel_data_input_squares;
    always @ ( pixel_index ) begin
        if ( is_pixel_in_input_squares ) begin
            case ( input_square_serial_record [ pixel_input_squares ] )
                A_serial : begin pixel_data_input_squares <= Ap [normalised_pixel_index]; end
                B_serial : begin pixel_data_input_squares <= Bp [normalised_pixel_index]; end
                C_serial : begin pixel_data_input_squares <= Cp [normalised_pixel_index]; end
                D_serial : begin pixel_data_input_squares <= Dp [normalised_pixel_index]; end
                E_serial : begin pixel_data_input_squares <= Ep [normalised_pixel_index]; end
                F_serial : begin pixel_data_input_squares <= Fp [normalised_pixel_index]; end    
                G_serial : begin pixel_data_input_squares <= Gp [normalised_pixel_index]; end
                H_serial : begin pixel_data_input_squares <= Hp [normalised_pixel_index]; end
                I_serial : begin pixel_data_input_squares <= Ip [normalised_pixel_index]; end
                J_serial : begin pixel_data_input_squares <= Jp [normalised_pixel_index]; end    
                K_serial : begin pixel_data_input_squares <= Kp [normalised_pixel_index]; end
                L_serial : begin pixel_data_input_squares <= Lp [normalised_pixel_index]; end
                M_serial : begin pixel_data_input_squares <= Mp[normalised_pixel_index]; end
                N_serial : begin pixel_data_input_squares <= Np [normalised_pixel_index]; end   
                O_serial : begin pixel_data_input_squares <= Op [normalised_pixel_index]; end    
                P_serial : begin pixel_data_input_squares <= Pp [normalised_pixel_index]; end
                Q_serial : begin pixel_data_input_squares <= Qp [normalised_pixel_index]; end
                R_serial : begin pixel_data_input_squares <= Rp [normalised_pixel_index]; end
                S_serial : begin pixel_data_input_squares <= Sp [normalised_pixel_index]; end    
                T_serial : begin pixel_data_input_squares <= Tp [normalised_pixel_index]; end
                U_serial : begin pixel_data_input_squares <= Up [normalised_pixel_index]; end
                V_serial : begin pixel_data_input_squares <= Vp [normalised_pixel_index]; end
                W_serial : begin pixel_data_input_squares <= Wp [normalised_pixel_index]; end   
                X_serial : begin pixel_data_input_squares <= Xp [normalised_pixel_index]; end
                Y_serial : begin pixel_data_input_squares <= Yp [normalised_pixel_index]; end
                Z_serial : begin pixel_data_input_squares <= Zp [normalised_pixel_index]; end
                NULL_SERIAL : begin pixel_data_input_squares <= WHITE; end  
            endcase  
        end 
    end 
    
    wire is_pixel_in_cursor; 
    assign is_pixel_in_cursor = 
        ((pixel_x == mouse_x) || ((pixel_x - mouse_x) == 1) || ((mouse_x - pixel_x) == 1)) && 
        ((pixel_y == mouse_y) || ((pixel_y - mouse_y) == 1) || ((mouse_y - pixel_y) == 1));
    
    wire clk_25M; 
    clock_divider clock_25M_inst ( clock, 1, clk_25M );
    
    always @ ( posedge clk_25M ) begin
        if ( is_pixel_in_input_squares ) begin
            pixel_data <= pixel_data_input_squares;
        end else if ( is_pixel_in_cursor ) begin
            pixel_data <= BLUE;
        end else begin
            pixel_data <= keyboard[pixel_index];
        end 
    end 
endmodule

