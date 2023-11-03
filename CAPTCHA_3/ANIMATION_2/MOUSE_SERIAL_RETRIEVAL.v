`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.10.2023 17:15:28
// Design Name: 
// Module Name: MOUSE_SERIAL_RETRIEVAL
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


module MOUSE_SERIAL_RETRIEVAL(
    input [11:0] mouse_x, mouse_y,
    output [4:0] mouse_serial
);

    wire is_row1, is_row2, is_row3;
    
    wire is_col1, is_col2, is_col3;
    wire is_col4, is_col5, is_col6;
    wire is_col7, is_col8, is_col9;
    
    assign is_row1 = mouse_y >= 31 && mouse_y <= 39;
    assign is_row2 = mouse_y >= 41 && mouse_y <= 49;
    assign is_row3 = mouse_y >= 51 && mouse_y <= 59;
    
    assign is_col1 = mouse_x >= 4 && mouse_x <= 12;
    assign is_col2 = mouse_x >= 14 && mouse_x <= 22;
    assign is_col3 = mouse_x >= 24 && mouse_x <= 32;
    assign is_col4 = mouse_x >= 34 && mouse_x <= 42;
    assign is_col5 = mouse_x >= 44 && mouse_x <= 52;
    assign is_col6 = mouse_x >= 54 && mouse_x <= 62;
    assign is_col7 = mouse_x >= 64 && mouse_x <= 72;
    assign is_col8 = mouse_x >= 74 && mouse_x <= 82;
    assign is_col9 = mouse_x >= 84 && mouse_x <= 92;
    
    assign mouse_serial = 
        is_row1 ? ( 
            is_col1 ? Q_serial :
            is_col2 ? W_serial :
            is_col3 ? E_serial :
            is_col4 ? R_serial :
            is_col5 ? T_serial :
            is_col6 ? Y_serial :
            is_col7 ? U_serial :
            is_col8 ? I_serial :
            is_col9 ? O_serial :
            NULL_SERIAL
        ) :
        is_row2 ? ( 
            is_col1 ? P_serial :
            is_col2 ? A_serial :
            is_col3 ? S_serial :
            is_col4 ? D_serial :
            is_col5 ? F_serial :
            is_col6 ? G_serial :
            is_col7 ? H_serial :
            is_col8 ? J_serial :
            is_col9 ? K_serial :
            NULL_SERIAL        
        ) :
        is_row3 ? ( 
            is_col1 ? L_serial :
            is_col2 ? Z_serial :
            is_col3 ? X_serial :
            is_col4 ? C_serial :
            is_col5 ? V_serial :
            is_col6 ? B_serial :
            is_col7 ? N_serial :
            is_col8 ? M_serial :
            is_col9 ? BACKSPACE :
            NULL_SERIAL          
        ) : ( mouse_x >= 74 && mouse_x <= 92 ) && ( mouse_y >= 17 && mouse_y <= 25 ) ? ENTER :
        NULL_SERIAL; 
endmodule 