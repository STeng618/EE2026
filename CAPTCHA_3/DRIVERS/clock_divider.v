`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.10.2023 21:44:45
// Design Name: 
// Module Name: clock_divider
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


module clock_divider( input clock_100MHz, [31:0] count , output reg slow_clock );
    reg [31:0] record = 0;
    
    always @(posedge clock_100MHz) begin
        record <= ( record == count ) ? 0 : record + 1;
        slow_clock <= ( record == 0 ) ? ~slow_clock : slow_clock;
    end 
    
endmodule