`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.10.2023 14:05:28
// Design Name: 
// Module Name: CHARACTER_GENERATOR
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

module CHARACTER_GENERATOR (
    input clock,
    input reset,  
    input is_new_stroke_needed,  
    input [2:0] current_round,
    output [4:0] source_square, dest_square,
    output [8:0] character, output [3:0] serial, output has_completed_this_round,
    output is_first_part_completed, 
    output [15:0] led
);

    wire clk_1000Hz;
    clock_divider clk_1000Hz_inst ( clock, 49_999, clk_1000Hz );

    // MAIN FSM 
    
    wire has_finished; // output from supply fsm 
    wire start; // input to supply fsm 
    
    wire done; // 2_SEC_COUNTER 
    TWO_SEC_COUNTER two_sec ( clk_1000Hz, has_completed_this_round, done );
    
    parameter MAX_ROUND = 6;
    parameter IDLE = 2'b00, DRAWING = 2'b01, FINISHED = 2'b10;
    reg [1:0] state = IDLE , next_state = IDLE ;
    
    always @ ( * ) begin
        case ( state ) 
            IDLE : next_state = (  current_round == MAX_ROUND || reset ) ? IDLE : DRAWING;
            DRAWING : next_state = reset ? IDLE : ( has_finished ? FINISHED : DRAWING );
            FINISHED : next_state = reset ? IDLE : ( done ? IDLE : FINISHED );
        endcase
    end
    
    always @ ( posedge clk_1000Hz ) begin
        state <= next_state;
    end 
    
    assign start = ( state == DRAWING ) ; // Input tp supply_fsm
    assign has_completed_this_round = ( state == FINISHED ) ;
    assign is_first_part_completed = current_round == MAX_ROUND && ~reset && state == IDLE ;
    
    SUPPLY_FSM supply_fsm (
        .clock ( clk_1000Hz ), 
        .reset ( reset ), 
        .start ( start ), .is_new_stroke_needed ( is_new_stroke_needed ),
        .has_finished ( has_finished ), .new_character ( character ), .serial ( serial ), 
        .source_square ( source_square ), .dest_square ( dest_square ), 
        .led ( led ), .current_round ( current_round ) 
    );

endmodule

module TWO_SEC_COUNTER (
    input clk_1000Hz, has_completed_this_round, 
    output done
);
    reg [31:0] count = 0;
    always @ ( posedge clk_1000Hz ) begin
        if ( has_completed_this_round ) begin
            count <= count + 1;
        end else begin
            count <= 0;
        end 
    end 
    
    assign done = count > 2000;
    
endmodule

module SUPPLY_FSM (
    input clock, 
    input reset, 
    input start, is_new_stroke_needed, input [2:0] current_round, 
    output has_finished, 
    output reg [4:0] source_square, dest_square,
    output reg [8:0] new_character, output reg [4:0] serial, 
    output reg [15:0] led
);

    reg [3:0] A_strokes [ 0 : 2 * A_num_strokes - 1 ];
    initial begin
        A_strokes [ 0 ] = 1; A_strokes [ 1 ] = 3; A_strokes [ 2 ] = 3; A_strokes [ 3 ] = 6;
        A_strokes [ 4 ] = 1; A_strokes [ 5 ] = 5; A_strokes [ 6 ] = 5; A_strokes [ 7 ] = 8;
        A_strokes [ 8 ] = 3; A_strokes [ 9 ] = 4; A_strokes [ 10 ] = 4; A_strokes [ 11 ] = 5;
        A_strokes [ 12 ] = BUFFER_SQUARE; A_strokes [ 13 ] = BUFFER_SQUARE;     
    end 
    
    reg [3:0] C_strokes [ 0 : 2 * ( C_num_strokes ) - 1 ];
    initial begin
        C_strokes [ 0 ] = 2; C_strokes [ 1 ] = 1; C_strokes [ 2 ] = 1; C_strokes [ 3 ] = 0;
        C_strokes [ 4 ] = 0; C_strokes [ 5 ] = 3; C_strokes [ 6 ] = 3; C_strokes [ 7 ] = 6;
        C_strokes [ 8 ] = 6; C_strokes [ 9 ] = 7; C_strokes [ 10 ] = 7; C_strokes [ 11 ] = 8;
        C_strokes [ 12 ] = BUFFER_SQUARE; C_strokes [ 13 ] = BUFFER_SQUARE;
    end
    
    reg [3:0] D_strokes [ 0 : 2 * ( D_num_strokes ) - 1 ];
    initial begin
        D_strokes [ 0 ] = 0; D_strokes [ 1 ] = 3; D_strokes [ 2 ] = 3; D_strokes [ 3 ] = 6;
        D_strokes [ 4 ] = 0; D_strokes [ 5 ] = 1; D_strokes [ 6 ] = 1; D_strokes [ 7 ] = 2;
        D_strokes [ 8 ] = 2; D_strokes [ 9 ] = 5; D_strokes [ 10 ] = 5; D_strokes [ 11 ] = 8;
        D_strokes [ 12 ] = 8; D_strokes [ 13 ] = 7; D_strokes [ 14 ] = 7; D_strokes [ 15 ] = 6;
        D_strokes [ 16 ] = BUFFER_SQUARE; D_strokes [ 17 ] = BUFFER_SQUARE;
    end   

    reg [3:0] F_strokes [ 0 : 2 * ( F_num_strokes ) - 1 ];
    initial begin
        F_strokes [ 0 ] = 0; F_strokes [ 1 ] = 3; F_strokes [ 2 ] = 3; F_strokes [ 3 ] = 6;
        F_strokes [ 4 ] = 0; F_strokes [ 5 ] = 1; F_strokes [ 6 ] = 1; F_strokes [ 7 ] = 2;
        F_strokes [ 8 ] = 3; F_strokes [ 9 ] = 4; F_strokes [ 10 ] = 4; F_strokes [ 11 ] = 5;
        F_strokes [ 12 ] = BUFFER_SQUARE; F_strokes [ 13 ] = BUFFER_SQUARE;
    end

    reg [3:0] I_strokes [ 0 : 2 * ( I_num_strokes ) - 1 ];
    initial begin
        I_strokes [ 0 ] = 0; I_strokes [ 1 ] = 1; I_strokes [ 2 ] = 1; I_strokes [ 3 ] = 2;
        I_strokes [ 4 ] = 1; I_strokes [ 5 ] = 4; I_strokes [ 6 ] = 4; I_strokes [ 7 ] = 7;
        I_strokes [ 8 ] = 6; I_strokes [ 9 ] = 7; I_strokes [ 10 ] = 7; I_strokes [ 11 ] = 8;
        I_strokes [ 12 ] = BUFFER_SQUARE; I_strokes [ 13 ] = BUFFER_SQUARE;
    end

   reg [3:0] J_strokes [ 0 : 2 * ( J_num_strokes ) - 1 ];
   initial begin
       J_strokes [ 0 ] = 0; J_strokes [ 1 ] = 1; J_strokes [ 2 ] = 1; J_strokes [ 3 ] = 2;
       J_strokes [ 4 ] = 1; J_strokes [ 5 ] = 4; J_strokes [ 6 ] = 4; J_strokes [ 7 ] = 7;
       J_strokes [ 8 ] = 7; J_strokes [ 9 ] = 6; J_strokes [ 10 ] = 6; J_strokes [ 11 ] = 3;
       J_strokes [ 12 ] = BUFFER_SQUARE; F_strokes [ 13 ] = BUFFER_SQUARE;
   end

    reg [3:0] K_strokes [ 0 : 2 * ( K_num_strokes ) - 1 ];
    initial begin
        K_strokes [ 0 ] = 0; K_strokes [ 1 ] = 3; K_strokes [ 2 ] = 3; K_strokes [ 3 ] = 6;
        K_strokes [ 4 ] = 1; K_strokes [ 5 ] = 3; K_strokes [ 6 ] = 3; K_strokes [ 7 ] = 7;
        K_strokes [ 8 ] = BUFFER_SQUARE; K_strokes [ 9 ] = BUFFER_SQUARE;
    end

    reg [3:0] L_strokes [ 0 : 2 * ( L_num_strokes ) - 1 ];
    initial begin
        L_strokes [ 0 ] = 0; L_strokes [ 1 ] = 3; L_strokes [ 2 ] = 3; L_strokes [ 3 ] = 6;
        L_strokes [ 4 ] = 6; L_strokes [ 5 ] = 7; L_strokes [ 6 ] = 7; L_strokes [ 7 ] = 8;
        L_strokes [ 8 ] = BUFFER_SQUARE; L_strokes [ 9 ] = BUFFER_SQUARE;
    end

    reg [3:0] M_strokes [ 0 : 2 * ( M_num_strokes ) - 1 ];
    initial begin
        M_strokes [ 0 ] = 0; M_strokes [ 1 ] = 3; M_strokes [ 2 ] = 3; M_strokes [ 3 ] = 6;
        M_strokes [ 4 ] = 0; M_strokes [ 5 ] = 7; M_strokes [ 6 ] = 2; M_strokes [ 7 ] = 7;
        M_strokes [ 8 ] = 2; M_strokes [ 9 ] = 5; M_strokes [ 10 ] = 5; M_strokes [ 11 ] = 8;
        M_strokes [ 12 ] = BUFFER_SQUARE; M_strokes [ 13 ] = BUFFER_SQUARE;
    end

    reg [3:0] N_strokes [ 0 : 2 * ( N_num_strokes ) - 1 ];
    initial begin
        N_strokes [ 0 ] = 0; N_strokes [ 1 ] = 3; N_strokes [ 2 ] = 3; N_strokes [ 3 ] = 6;
        N_strokes [ 4 ] = 0; N_strokes [ 5 ] = 4; N_strokes [ 6 ] = 4; N_strokes [ 7 ] = 8;
        N_strokes [ 8 ] = 8; N_strokes [ 9 ] = 5; N_strokes [ 10 ] = 5; N_strokes [ 11 ] = 2;
        N_strokes [ 12 ] = BUFFER_SQUARE; N_strokes [ 13 ] = BUFFER_SQUARE;
    end
    
    reg [3:0] Q_strokes [ 0 : 2 * ( Q_num_strokes ) - 1 ];
    initial begin
        Q_strokes [ 0 ] = 2; Q_strokes [ 1 ] = 1; Q_strokes [ 2 ] = 1; Q_strokes [ 3 ] = 0;
        Q_strokes [ 4 ] = 0; Q_strokes [ 5 ] = 3; Q_strokes [ 6 ] = 3; Q_strokes [ 7 ] = 6;
        Q_strokes [ 8 ] = 6; Q_strokes [ 9 ] = 7; Q_strokes [ 10 ] = 7; Q_strokes [ 11 ] = 8;
        Q_strokes [ 12 ] = 8; Q_strokes [ 13 ] = 5; Q_strokes [ 14 ] = 5; Q_strokes [ 15 ] = 2;
        Q_strokes [ 16 ] = 4; Q_strokes [ 17 ] = 8; 
        Q_strokes [ 18 ] = BUFFER_SQUARE; Q_strokes [ 19 ] = BUFFER_SQUARE;
    end
    
    reg [3:0] R_strokes [ 0 : 2 * ( R_num_strokes ) - 1 ];
    initial begin
        R_strokes [ 0 ] = 0; R_strokes [ 1 ] = 3; R_strokes [ 2 ] = 3; R_strokes [ 3 ] = 6;
        R_strokes [ 4 ] = 0; R_strokes [ 5 ] = 1; R_strokes [ 6 ] = 1; R_strokes [ 7 ] = 2;
        R_strokes [ 8 ] = 2; R_strokes [ 9 ] = 5; R_strokes [ 10 ] = 5; R_strokes [ 11 ] = 4;
        R_strokes [ 12 ] = 4; R_strokes [ 13 ] = 3; R_strokes [ 14 ] = 3; R_strokes [ 15 ] = 8;
        R_strokes [ 16 ] = BUFFER_SQUARE; R_strokes [ 17 ] = BUFFER_SQUARE;
    end
    
    reg [3:0] S_strokes [ 0 : 2 * ( S_num_strokes ) - 1 ];
    initial begin
        S_strokes [ 0 ] = 2; S_strokes [ 1 ] = 1; S_strokes [ 2 ] = 1; S_strokes [ 3 ] = 0;
        S_strokes [ 4 ] = 0; S_strokes [ 5 ] = 3; S_strokes [ 6 ] = 3; S_strokes [ 7 ] = 4;
        S_strokes [ 8 ] = 4; S_strokes [ 9 ] = 5; S_strokes [ 10 ] = 5; S_strokes [ 11 ] = 8;
        S_strokes [ 12 ] = 8; S_strokes [ 13 ] = 7; S_strokes [ 14 ] = 7; S_strokes [ 15 ] = 6;
        S_strokes [ 16 ] = BUFFER_SQUARE; S_strokes [ 17 ] = BUFFER_SQUARE;
    end

    reg [3:0] T_strokes [ 0 : 2 * ( T_num_strokes ) - 1 ];
    initial begin
        T_strokes [ 0 ] = 0; T_strokes [ 1 ] = 1; T_strokes [ 2 ] = 1; T_strokes [ 3 ] = 2;
        T_strokes [ 4 ] = 1; T_strokes [ 5 ] = 4; T_strokes [ 6 ] = 4; T_strokes [ 7 ] = 7;
        T_strokes [ 8 ] = BUFFER_SQUARE; T_strokes [ 9 ] = BUFFER_SQUARE;
    end

    reg [3:0] W_strokes [ 0 : 2 * ( W_num_strokes ) - 1 ];
    initial begin
        W_strokes [ 0 ] = 0; W_strokes [ 1 ] = 3; W_strokes [ 2 ] = 3; W_strokes [ 3 ] = 6;
        W_strokes [ 4 ] = 6; W_strokes [ 5 ] = 1; W_strokes [ 6 ] = 1; W_strokes [ 7 ] = 8;
        W_strokes [ 8 ] = 8; W_strokes [ 9 ] = 5; W_strokes [ 10 ] = 5; W_strokes [ 11 ] = 2;
        W_strokes [ 12 ] = BUFFER_SQUARE; W_strokes [ 13 ] = BUFFER_SQUARE;
    end
    
    reg [3:0] X_strokes [ 0 : 2 * ( X_num_strokes ) - 1 ];
    initial begin
        X_strokes [ 0 ] = 0; X_strokes [ 1 ] = 4; X_strokes [ 2 ] = 4; X_strokes [ 3 ] = 8;
        X_strokes [ 4 ] = 2; X_strokes [ 5 ] = 4; X_strokes [ 6 ] = 4; X_strokes [ 7 ] = 6;
        X_strokes [ 8 ] = BUFFER_SQUARE; X_strokes [ 9 ] = BUFFER_SQUARE;
    end

   parameter RANDOM_INITIAL_NUMBER = 8;
   reg [3:0] random_number = RANDOM_INITIAL_NUMBER;
   always @ ( posedge clock ) begin
       random_number[0] <= ~ ( random_number[3] ^ random_number[2] );
       random_number[1] <= random_number[0];
       random_number[2] <= random_number[1];
       random_number[3] <= random_number[2];
   end
   
   reg [5:0] max_stroke = 0, current_stroke = 0;
   assign has_finished = current_stroke == max_stroke && current_stroke != 0 ;
  
   parameter IDLE = 2'b00, RETRIEVE = 2'b01, SUPPLY = 2'b10;
   reg [1:0] state = IDLE , next_state = IDLE ;
   
   always @ ( * ) begin
       case ( state ) 
           IDLE : 
                begin next_state = start && !reset ? RETRIEVE : IDLE; end
           RETRIEVE : // Buffer state to ensure that new_character and max_stroke are updated
                begin next_state = reset ? IDLE : SUPPLY; end
           SUPPLY : 
                begin next_state = reset ? IDLE : ( ! start ? IDLE : SUPPLY ); end
       endcase
   end
   
   reg [15:0] serial_record = 0;
   
   always @ ( posedge clock ) begin
       state <= next_state;
       if ( reset ) begin
           serial_record = 0; 
           max_stroke = 0;
       end else begin
           if ( next_state == RETRIEVE ) begin
               serial = random_number;
               serial_record [serial] = 1;
               case ( serial )
                    0: begin new_character = A; max_stroke = A_num_strokes; end 
                    1: begin new_character = C; max_stroke = C_num_strokes; end
                    2: begin new_character = D; max_stroke = D_num_strokes; end
                    3: begin new_character = F; max_stroke = F_num_strokes; end
                    4: begin new_character = I; max_stroke = I_num_strokes; end
                    5: begin new_character = J; max_stroke = J_num_strokes; end
                    6: begin new_character = K; max_stroke = K_num_strokes; end
                    7: begin new_character = L; max_stroke = L_num_strokes; end
                    8: begin new_character = M; max_stroke = M_num_strokes; end
                    9: begin new_character = N; max_stroke = N_num_strokes; end
                    10: begin new_character = Q; max_stroke = Q_num_strokes; end
                    11: begin new_character = R; max_stroke = R_num_strokes; end
                    12: begin new_character = S; max_stroke = S_num_strokes; end
                    13: begin new_character = T; max_stroke = T_num_strokes; end
                    14: begin new_character = W; max_stroke = W_num_strokes; end
                    15: begin new_character = X; max_stroke = X_num_strokes; end
               endcase
           end 
       end 
   end 
 
   always @ ( posedge clock ) begin // For debugging 
        if ( reset ) begin
            led <= 0;
        end else begin
            if ( current_round == MAX_ROUND ) begin 
                led <= serial_record; // for testing 
            end else begin
                led <= 0;
                led [ current_stroke ] <= 1;
                led [ 15 - current_round ] <= 1;
            end 
        end 
   end 
   
   always @ ( posedge clock ) begin
       if ( state == IDLE || state == RETRIEVE ) begin
           current_stroke = 0;
           source_square = BUFFER_SQUARE; 
           dest_square = BUFFER_SQUARE; // This part may be problemetic. Remove if necessary
       end else begin // state == SUPPLY 
           if ( is_new_stroke_needed && current_stroke < max_stroke ) begin 
                case ( serial )
                   0: begin
                       source_square = A_strokes [ 2 * ( current_stroke ) ];
                       dest_square = A_strokes [ 2 * ( current_stroke ) + 1 ];
                   end
                   1: begin
                       source_square = C_strokes [ 2 * ( current_stroke ) ];
                       dest_square = C_strokes [ 2 * ( current_stroke ) + 1 ];
                   end
                   2: begin
                       source_square = D_strokes [ 2 * ( current_stroke ) ];
                       dest_square = D_strokes [ 2 * ( current_stroke ) + 1 ];
                   end
                   3: begin
                       source_square = F_strokes [ 2 * ( current_stroke ) ];
                       dest_square = F_strokes [ 2 * ( current_stroke ) + 1 ];
                   end
                   4: begin
                       source_square = I_strokes [ 2 * ( current_stroke ) ];
                       dest_square = I_strokes [ 2 * ( current_stroke ) + 1 ];
                   end
                   5: begin
                       source_square = J_strokes [ 2 * ( current_stroke ) ];
                       dest_square = J_strokes [ 2 * ( current_stroke ) + 1 ];
                   end
                   6: begin
                       source_square = K_strokes [ 2 * ( current_stroke ) ];
                       dest_square = K_strokes [ 2 * ( current_stroke ) + 1 ];
                   end
                   7: begin
                       source_square = L_strokes [ 2 * ( current_stroke ) ];
                       dest_square = L_strokes [ 2 * ( current_stroke ) + 1 ];
                   end
                   8: begin
                       source_square = M_strokes [ 2 * ( current_stroke ) ];
                       dest_square = M_strokes [ 2 * ( current_stroke ) + 1 ];
                   end
                   9: begin
                       source_square = N_strokes [ 2 * ( current_stroke ) ];
                       dest_square = N_strokes [ 2 * ( current_stroke ) + 1 ];
                   end
                   10: begin
                       source_square = Q_strokes [ 2 * ( current_stroke ) ];
                       dest_square = Q_strokes [ 2 * ( current_stroke ) + 1 ];
                   end
                   11: begin
                       source_square = R_strokes [ 2 * ( current_stroke ) ];
                       dest_square = R_strokes [ 2 * ( current_stroke ) + 1 ];
                   end
                   12: begin
                       source_square = S_strokes [ 2 * ( current_stroke ) ];
                       dest_square = S_strokes [ 2 * ( current_stroke ) + 1 ];
                   end
                   13: begin
                       source_square = T_strokes [ 2 * ( current_stroke ) ];
                       dest_square = T_strokes [ 2 * ( current_stroke ) + 1 ];
                   end
                   14: begin
                       source_square = W_strokes [ 2 * ( current_stroke ) ];
                       dest_square = W_strokes [ 2 * ( current_stroke ) + 1 ];
                   end
                   15: begin
                       source_square = X_strokes [ 2 * ( current_stroke ) ];
                       dest_square = X_strokes [ 2 * ( current_stroke ) + 1 ];
                   end
               endcase 
               current_stroke <= current_stroke + 1;
           end 
       end 
   end 

endmodule 

