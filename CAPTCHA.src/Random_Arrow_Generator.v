`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.10.2023 09:22:47
// Design Name: 
// Module Name: Random_Arrow_Generator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
//// Revision 0.01 - File Created
//// Additional Comments:
//// 
////////////////////////////////////////////////////////////////////////////////////


module Random_Finger_Generator(
   input clock, 
   output reg [2:0] lfsr_mod    // 6-bit random number output
);

reg[5:0] lfsr = 3;
//assign lfsr[0] = (x == 6 && y >= 19 && y <= 21)||
//                 (x == 7 && y == 18)||
//                 (x == 8 && y >= 13 && y <= 20)||
//                 (x >= 9 && x <= 10 && y == 12)||
//                 (x == 11 && y >= 13 && y <= 17)||
//                 (x == 12 && y == 17)||
//                 (x == 13 && y >= 18 && y <= 19)||
//                 (x == 14 && y == 17)||
//                 (x == 15 && y >= 18 && y <= 19)||
//                 (x == 16 && y == 18)||
//                 (x == 17 && y >= 19 && y <= 21)||
//                 (x == 16 && y >= 22 && y <= 23)||
//                 (x == 15 && y >= 24 && y <= 25)||
//                 (x >= 8 && x <= 14 && y == 25)||
//                 (x == 8 && y >= 24 && y <= 25)||
//                 (x == 7 && y >= 22 && y <= 23);
                 
//assign lfsr[1] = (x == 7 && y == 15)||
//                 (x == 8 && y == 14)||
//                 (x == 9 && y == 14)||
//                 (x == 9 && y == 16)||
//                 (x == 10 && y == 15)||
//                 (x == 11 && y == 14)||
//                 (x == 12 && y == 13)||
//                 (x == 13 && y == 12)||
//                 (x == 14 && y == 11)||
//                 (x == 15 && y == 12)||
//                 (x == 15 && y == 13)||
//                 (x == 14 && y == 14)||
//                 (x == 13 && y == 15)||
//                 (x == 12 && y == 16)||
//                 (x == 13 && y == 17)||
//                 (x == 14 && y == 17)||
//                 (x == 14 && y == 18)||
//                   (x == 13 && y == 19)||
//                   (x == 15 && y == 18)||
//                   (x == 14 && y == 18)||

                 

always @(posedge clock) begin
      
        lfsr[5:1] <= lfsr[4:0];
        lfsr[0] <= ~(lfsr[3]^lfsr[4]); 
        lfsr_mod <= lfsr % 6;
        end
             



endmodule

