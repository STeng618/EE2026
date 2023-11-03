parameter MAX_ROUND = 6; 

parameter BLUE = 16'b00000_000000_11111;
parameter RED = 16'b11111_000000_00000;
parameter GREEN = 16'b00000_111111_00000;
parameter WHITE = 16'b11111_111111_11111;
parameter BLACK = 0;

parameter CANVAS_SIZE = 3025;

parameter BUFFER_SQUARE = 9;
parameter BUFFER_SQUARE_X = 59, BUFFER_SQUARE_Y = 59;
parameter NUM_MOVES = 22;

// Serial Number for Possible Characters 
parameter A = 9'b101_111_010;
parameter [4:0] A_serial = 0;
parameter A_num_strokes = 7;

parameter C = 9'b111_001_111;    
parameter [4:0] C_serial = 1;
parameter C_num_strokes = 7;

parameter D = 9'b111_101_111;
parameter [4:0] D_serial = 2;
parameter D_num_strokes = 9;

parameter F = 9'b001_111_111;    
parameter [4:0] F_serial = 3;
parameter F_num_strokes = 7;

parameter I = 9'b111_010_111;    
parameter [4:0] I_serial = 4;
parameter I_num_strokes = 7;

parameter J = 9'b011_011_111;
parameter [4:0] J_serial = 5;
parameter J_num_strokes = 7;
    
parameter K = 9'b011_001_011;
parameter [4:0] K_serial = 6;
parameter K_num_strokes = 5;

parameter L = 9'b111_001_001;
parameter [4:0] L_serial = 7;
parameter L_num_strokes = 5;

parameter M = 9'b111_101_101;
parameter [4:0] M_serial = 8;
parameter M_num_strokes = 7;

parameter N = 9'b101_111_101;
parameter [4:0] N_serial = 9;
parameter N_num_strokes = 7;

parameter Q = 9'b111_111_111;
parameter [4:0] Q_serial = 10;
parameter Q_num_strokes = 10;

parameter R = 9'b101_111_111;
parameter [4:0] R_serial = 11;
parameter R_num_strokes = 9;

parameter S = 9'b111_111_111;
parameter [4:0] S_serial = 12;
parameter S_num_strokes = 9;

parameter T = 9'b010_010_111;
parameter [4:0] T_serial = 13;
parameter T_num_strokes = 5;

parameter W = 9'b101_101_111;
parameter [4:0] W_serial = 14;
parameter W_num_strokes = 7;

parameter X = 9'b101_010_101;
parameter [4:0] X_serial = 15;
parameter X_num_strokes = 5;

// Serial Number for Unused Characters 
parameter [4:0] B_serial = 16, E_serial = 17, G_serial = 18;
parameter [4:0] H_serial = 19, O_serial = 20, P_serial = 21;
parameter [4:0] U_serial = 22, V_serial = 23, Y_serial = 24, Z_serial = 25;
parameter [4:0] NULL_SERIAL = 26, BACKSPACE = 27, ENTER = 28, IMPOSSIBLE_SERIAL = 29;

parameter [2:0] ERROR_INPUT_SQUARE = 6;