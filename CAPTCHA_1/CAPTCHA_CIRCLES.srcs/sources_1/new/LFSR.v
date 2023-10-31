`timescale 1ns / 1ps

module LFSR_13b(
    input clock, reset,
    output reg [12:0]Q = 13'b1_0100_0010_0011
    );
    
    always @(posedge clock)
    begin
        if ( reset ) Q <= 0;
        else Q <= {Q[12], Q[11], Q[10], Q[9], Q[8], Q[7], Q[6], Q[5], Q[4], Q[3], Q[2], Q[1], Q[0], ~(Q[12]^Q[7])};
    end
    
endmodule