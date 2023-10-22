`timescale 1ns / 1ps

module counter_3s(
    input clock, is_taskB_running,
    output reg is_3s = 0 
    );
   
reg [31:0] count3s = 0;
        
always @(posedge clock) begin
    if (!is_taskB_running) begin
        is_3s <= 0;
        count3s <= 0;
    end else begin
        if (!is_3s) begin        
            if(count3s == 299_999_999)begin
                is_3s <= 1;
            end
            else begin
                count3s <= count3s + 1;
            end
        end
    end 
end            
    
endmodule