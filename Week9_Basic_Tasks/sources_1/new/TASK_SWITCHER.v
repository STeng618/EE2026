/**
    Highest priority task is taskD, lowest priority task is group task
    Task A corresponds to sw[0]
    Task B corresponds to sw[1]
    Task C corresponds to sw[2]
    Task D corresponds to sw[3]
    Group task is activated when no other task is running
*/
module TASK_SWITCHER (
    input [15:0] sw,
    input [15:0] pixel_data_A, pixel_data_B, pixel_data_C, pixel_data_D, group_pixel_data,
    output is_taskA_running, is_taskB_running, is_taskC_running, is_taskD_running, is_group_running,
    output [15:0] pixel_data
);
    assign is_group_running = ~sw[3] & ~sw[2] & ~sw[1] & ~sw[0]; 
    assign is_taskA_running = ~sw[3] & ~sw[2] & ~sw[1] & sw[0];
    assign is_taskB_running = ~sw[3] & ~sw[2] & sw[1];
    assign is_taskC_running = ~sw[3] & sw[2];
    assign is_taskD_running = sw[3];

    assign pixel_data = is_taskA_running ? pixel_data_A : 
                        is_taskB_running ? pixel_data_B : 
                        is_taskC_running ? pixel_data_C : 
                        is_taskD_running ? pixel_data_D : 
                        group_pixel_data;
endmodule