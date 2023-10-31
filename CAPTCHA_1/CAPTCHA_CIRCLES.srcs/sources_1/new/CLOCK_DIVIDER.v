`timescale 1ns / 1ps

module CLOCK_DIVIDER (input clock, [31:0] freq_out, output reg clk_fdiv = 0);    
    reg [31:0] f_count = 0;
    wire [31:0] m_value = (100_000_000 / (2*freq_out)) - 1;
    
    always @ (posedge clock)
    begin
        f_count <= (f_count == m_value) ? 0 : f_count + 1;
        clk_fdiv <= (f_count == 0) ? ~clk_fdiv : clk_fdiv;
    end
    
endmodule