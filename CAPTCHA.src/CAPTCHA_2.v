`timescale 1ns / 1ps

module CAPTCHA_2(input clock, btnR, btnL, btnD, btnU, sw, btnC, en, [6:0]x, [5:0]y, [12:0] pixel_index,
                 output reg [15:0] oled_data = 0, output reg pass = 0, fail = 0);
        
    reg [15:0] green = 16'b00000_111111_00000;
    reg [15:0] red = 16'b11111_000000_00000;
    reg [15:0] blue = 16'b00000_000000_11111;
    reg [15:0] white = 16'b11111_111111_11111;
    reg [15:0] black = 0;

    wire is_white_border;
    assign is_white_border = ((x >= 1 && x <= 24 && y >= 1 && y <= 34) && !(x >= 2 && x <= 23 && y >= 2 && y <= 33)) ||
                             ((x >= 27 && x <= 94 && y >= 1 && y <= 34) && !(x >= 28 && x <= 93 && y >= 2 && y <= 33)) ||
                             ((x >= 28 && x <= 64 && y >= 50 && y <= 58) && !(x >= 29 && x <= 63 && y >= 51 && y <= 57));
    
    wire is_white_square;
    assign is_white_square = (x >= 39 && x <= 41 && y >= 40 && y <= 42) ||
                             (x >= 48 && x <= 50 && y >= 40 && y <= 42) ||
                             (x >= 57 && x <= 59 && y >= 40 && y <= 42) ||                
                             (x >= 66 && x <= 68 && y >= 40 && y <= 42) ||
                             (x >= 75 && x <= 77 && y >= 40 && y <= 42) ||
                             (x >= 84 && x <= 86 && y >= 40 && y <= 42);
    
    wire draw_numbers;
    assign draw_numbers = (x == 43 && y >= 6 && y <= 10) ||
                          (x >= 45 && x <= 46 && y == 6) ||
                          (x == 46 && y >= 7 && y <= 8) ||
                          (x == 45 && y >= 8 && y <= 10) ||
                          (x == 46 && y == 10) ||
                          (x == 49 && y >= 8 && y <= 11) ||
                          (x >= 51 && x <= 52 && y == 10) ||
                          (x == 52 && y >= 11 && y <= 12) ||
                          (x == 51 && y >= 12 && y <= 14) ||
                          (x == 52 && y == 14) ||
                          (x == 55 && y >= 16 && y <= 20) ||
                          (x >= 53 && x <= 54 && y == 16) ||
                          (x >= 53 && x <= 54 && y == 18) ||
                          (x >= 53 && x <= 54 && y == 20) ||
                          (x == 53 && y >= 22 && y <= 26) ||
                          (x == 51 && y >= 22 && y <= 24) ||
                          (x == 52 && y == 24) ||
                          (x == 48 && y == 25) ||
                          (x == 47 && y >= 25 && y <= 27) ||
                          (x == 48 && y >= 27 && y <= 29) ||
                          (x == 47 && y == 29) ||
                          (x == 42 && y >= 26 && y <= 30) ||
                          (x >= 43 && x <= 44 && y == 26) ||
                          (x >= 43 && x <= 44 && y == 28) ||
                          (x >= 43 && x <= 44 && y == 30) ||
                          (x == 44 && y == 29) ||
                          (x >= 37 && x <= 39 && y == 25) ||
                          (x == 39 && y >= 26 && y <= 29) ||
                          (x == 33 && y >= 22 && y <= 26) ||
                          (x == 35 && y >= 22 && y <= 26) ||
                          (x == 34 && y == 22) ||
                          (x == 34 && y == 24) ||
                          (x == 34 && y == 26) ||
                          (x == 33 && y >= 16 && y <= 20) ||
                          (x == 31 && y >= 16 && y <= 18) ||
                          (x == 32 && y == 16) ||
                          (x == 32 && y == 18) ||
                          (x >= 31 && x <= 32 && y == 20) ||
                          (x == 33 && y >= 11 && y <= 14) ||
                          (x == 35 && y >= 11 && y <= 14) ||
                          (x == 37 && y >= 11 && y <= 14) ||
                          (x == 36 && y == 11) ||
                          (x == 36 && y == 14) ||
                          (x == 39 && y >= 7 && y <= 10) ||
                          (x == 41 && y >= 7 && y <= 10) ;
                           
    wire draw_circle;
    assign draw_circle = ((x - 43)*(x - 43) + (y - 18)*(y - 18) <= 13*13);

    parameter centreX = 44;
    parameter centreY = 18;
    parameter radius = 13; 

    wire draw_instructions;
    assign draw_instructions = (x >= 64 && x <= 66 && y == 5)||
                               (x >= 64 && x <= 66 && y == 7)||
                               (x >= 69 && x <= 71 && y == 5)||
                               (x >= 73 && x <= 75 && y == 5)||
                               (x >= 77 && x <= 79 && y == 5)||
                               (x >= 81 && x <= 83 && y == 5)||
                               (x >= 85 && x <= 87 && y == 5)||
                               (x == 64 && y == 6)||
                               (x == 66 && y == 6)||
                               (x == 69 && y >= 6 && y <= 9)||
                               (x == 71 && y >= 6 && y <= 9)||
                               (x >= 69 && x <= 71 && y == 10)||
                               (x == 64 && y >= 8 && y <= 10)||
                               (x == 65 && y == 8)||
                               (x == 66 && y == 9)||
                               (x == 67 && y == 10)||
                               (x == 74 && y >= 6 && y <= 10)||
                               (x == 77 && y >= 6 && y <= 10)||
                               (x == 79 && y >= 6 && y <= 10)||
                               (x == 78 && y == 7)||
                               (x == 82 && y >= 6 && y <= 10)||
                               (x == 85 && y >= 6 && y <= 10)||
                               (x >= 86 && x <= 87 && y == 7)||
                               (x >= 86 && x <= 87 && y == 10)||
                               //2ndrow
                               (x >= 66 && x <= 68 && y == 13)||
                               (x == 67 && y >= 14 && y <= 17)||
                               (x == 70 && y >= 13 && y <= 17)||
                               (x == 72 && y >= 13 && y <= 17)||
                               (x == 71 && y == 13)||
                               (x == 71 && y == 17)||
                               (x >= 76 && x <= 78 && y == 13)||
                               (x == 77 && y >= 14 && y <= 17)||
                               (x == 80 && y >= 13 && y <= 17)||
                               (x == 82 && y >= 13 && y <= 17)||
                               (x == 81 && y == 15)||
                               (x == 84 && y >= 13 && y <= 17)||
                               (x >= 85 && x <= 86 && y == 13)||
                               (x >= 85 && x <= 86 && y == 15)||
                               (x >= 85 && x <= 86 && y == 17)||
                               //3rdrow
                               (x == 59 && y >= 19 && y <= 24)||
                               (x == 60 && y == 19)||
                               (x == 61 && y == 20)||
                               (x == 62 && y >= 21 && y <= 22)||
                               (x == 61 && y == 23)||
                               (x == 60 && y == 24)||
                               (x == 64 && y >= 19 && y <= 24)||
                               (x == 66 && y >= 19 && y <= 24)||
                               (x == 68 && y >= 19 && y <= 21)||
                               (x == 67 && y == 19)||
                               (x == 67 && y == 21)||
                               (x == 67 && y == 22)||
                               (x == 68 && y == 23)||
                               (x == 69 && y == 24)||
                               (x == 71 && y >= 19 && y <= 24)||
                               (x >= 72 && x <= 73 && y == 19)||
                               (x >= 72 && x <= 73 && y == 21)||
                               (x >= 72 && x <= 73 && y == 24)||
                               (x >= 77 && x <= 78 && y == 19)||
                               (x == 76 && y == 20)||
                               (x == 75 && y >= 21 && y <= 22)||
                               (x == 76 && y == 23)||
                               (x >= 77 && x <= 78 && y == 24)||
                               (x >= 80 && x <= 82 && y == 19)||
                               (x == 81 && y >= 20 && y <= 24)||
                               (x == 84 && y >= 19 && y <= 24)||
                               (x == 86 && y >= 19 && y <= 24)||
                               (x == 88 && y >= 19 && y <= 24)||
                               (x == 87 && y == 19)||
                               (x == 87 && y == 24)||
                               (x == 90 && y >= 19 && y <= 24)||
                               (x == 91 && y == 20)||
                               (x == 92 && y >= 20 && y <= 24)||
                               (x == 61 && y >= 27 && y <= 32)||
                               (x == 63 && y >= 27 && y <= 32)||
                               (x == 62 && y == 27)||
                               (x == 62 && y == 32)||
                               (x == 65 && y >= 27 && y <= 32)||
                               (x >= 66 && x <= 67 && y == 27)||
                               (x >= 66 && x <= 67 && y == 29)||
                               (x == 70 && y >= 27 && y <= 32)||
                               (x >= 71 && x <= 72 && y == 27)||
                               (x >= 71 && x <= 72 && y == 29)||
                               (x == 74 && y >= 27 && y <= 32)||
                               (x == 76 && y >= 27 && y <= 32)||
                               (x == 77 && y == 28)||
                               (x == 78 && y >= 28 && y <= 32)||
                               (x == 80 && y >= 27 && y <= 32)||
                               (x >= 81 && x <= 83 && y == 27)||
                               (x >= 81 && x <= 83 && y == 32)||
                               (x == 83 && y >= 30 && y <= 32)||
                               (x == 82 && y == 30)||
                               (x == 85 && y >= 27 && y <= 32)||
                               (x >= 86 && x <= 87 && y == 27)||
                               (x >= 86 && x <= 87 && y == 29)||
                               (x >= 86 && x <= 87 && y == 32)||
                               (x == 89 && y >= 27 && y <= 32)||
                               (x == 91 && y >= 27 && y <= 29)||
                               (x == 90 && y == 27)||
                               (x == 90 && y == 29)||
                               (x == 90 && y == 30)||
                               (x == 91 && y == 31)||
                               (x == 92 && y == 32);
    
    wire draw_submit;
    assign draw_submit = (x >= 30 && x <= 33 && y == 52)||
                         (x >= 30 && x <= 33 && y == 54)||
                         (x >= 30 && x <= 33 && y == 56)||
                         (x == 30 && y == 53)||
                         (x == 33 && y == 55)||
                         (x == 36 && y >= 52 && y <= 56)||
                         (x == 39 && y >= 52 && y <= 56)||
                         (x >= 37 && x <= 38 && y == 56)||
                         (x == 42 && y >= 52 && y <= 56)||
                         (x >= 43 && x <= 44 && y == 52)||
                         (x == 44 && y == 53)||
                         (x >= 43 && x <= 45 && y == 54)||
                         (x == 45 && y == 55)||
                         (x >= 43 && x <= 45 && y == 56)||
                         (x >= 85 && x <= 87 && y == 5)||
                         (x >= 48 && x <= 52 && y == 52)||
                         (x == 48 && y >= 53 && y <= 56)||
                         (x == 50 && y >= 53 && y <= 56)||
                         (x == 52 && y >= 53 && y <= 56)||
                         (x == 55 && y >= 52 && y <= 56)||
                         (x >= 58 && x <= 62 && y == 52)||
                         (x == 60 && y >= 53 && y <= 56);
    
    wire [15:0] oled_arrow;
    wire [2:0]arrow_pos;
    arrow_control arrow_position (.clock(clock),
                                  .en(en),
                                  .btnR(btnR),
                                  .btnL(btnL),
                                  .btnD(btnD),
                                  .btnU(btnU),
                                  .pixel_index(pixel_index),
                                  .arrow_direction(arrow_pos),
                                  .oled_arrow(oled_arrow));      
    wire submit;
    wire [15:0] oled_border;    
    border_control border_position (.clock(clock),
                                    .en(en),
                                    .btnR(btnR),
                                    .btnL(btnL),
                                    .btnD(btnD),
                                    .btnU(btnU),
                                    .pixel_index(pixel_index),
                                    .submit_btn(submit),
                                    .oled_border(oled_border));
    

    wire [2:0] lfsr;
    Random_Finger_Generator unit_finger (.clock(clock),
                                         .lfsr_mod(lfsr));
                                         
    reg [2:0] fing_pos = 7;
    
    wire draw_centre;
    assign draw_centre = (x == 43 && y == 18);
    
    always @(posedge clock) begin
        if (en) begin
        
        oled_data <= black;
            if (sw) begin
                if (fing_pos == 7) begin 
                    fing_pos <= lfsr;
                end 
                case (fing_pos)
                0: if (pixel_index == 1163 || pixel_index == 1259 || pixel_index == 1355 || pixel_index == 1451 || pixel_index == 1547 || pixel_index == 1549 || pixel_index == 1551 || pixel_index == 1639 || pixel_index == 1643 || pixel_index == 1645 || pixel_index == 1647 || pixel_index == 1736 || ((pixel_index >= 1739) && (pixel_index <= 1744)) || ((pixel_index >= 1832) && (pixel_index <= 1840)) || ((pixel_index >= 1929) && (pixel_index <= 1936)) || ((pixel_index >= 2026) && (pixel_index <= 2032)) || (pixel_index >= 2122) && (pixel_index <= 2128)) oled_data <= 16'b1010010100010100;
                         else if (pixel_index == 1453 || pixel_index == 1640 || pixel_index == 1644 || pixel_index == 1646 || ((pixel_index >= 1648) && (pixel_index <= 1649)) || pixel_index == 1735 || pixel_index == 1745 || pixel_index == 1841 || pixel_index == 1928 || pixel_index == 1937 || pixel_index == 2025 || pixel_index == 2033 || pixel_index == 2129) oled_data <= 16'b0101001010001010;
                         else if (pixel_index == 1737) oled_data <= 16'b0101010100001010;
                         else oled_data <= 0;
                        
                1: if (pixel_index == 1258 || ((pixel_index >= 1353) && (pixel_index <= 1354)) || ((pixel_index >= 1359) && (pixel_index <= 1360)) || ((pixel_index >= 1449) && (pixel_index <= 1450)) || ((pixel_index >= 1453) && (pixel_index <= 1454)) || ((pixel_index >= 1544) && (pixel_index <= 1545)) || ((pixel_index >= 1548) && (pixel_index <= 1549)) || ((pixel_index >= 1640) && (pixel_index <= 1644)) || pixel_index == 1646 || ((pixel_index >= 1736) && (pixel_index <= 1741)) || ((pixel_index >= 1832) && (pixel_index <= 1837)) || ((pixel_index >= 1928) && (pixel_index <= 1934)) || ((pixel_index >= 2025) && (pixel_index <= 2029)) || ((pixel_index >= 2121) && (pixel_index <= 2125)) || (pixel_index >= 2218) && (pixel_index <= 2220)) oled_data <= 16'b1010010100010100;
                         else if (pixel_index == 1259 || pixel_index == 1264 || pixel_index == 1358 || pixel_index == 1448 || pixel_index == 1455 || ((pixel_index >= 1546) && (pixel_index <= 1547)) || pixel_index == 1639 || pixel_index == 1645 || pixel_index == 1647 || pixel_index == 1735 || pixel_index == 1742 || pixel_index == 1831 || ((pixel_index >= 1838) && (pixel_index <= 1839)) || pixel_index == 1935 || pixel_index == 2024 || ((pixel_index >= 2030) && (pixel_index <= 2031)) || pixel_index == 2126 || pixel_index == 2315) oled_data <= 16'b0101001010001010;
                         else oled_data <= 0;
                                 
                2: if (((pixel_index >= 1164) && (pixel_index <= 1166)) || pixel_index == 1257 || ((pixel_index >= 1358) && (pixel_index <= 1359)) || pixel_index == 1448 || pixel_index == 1551 || pixel_index == 1649 || pixel_index == 1744 || pixel_index == 1831 || pixel_index == 1838 || pixel_index == 1842 || pixel_index == 1931 || pixel_index == 1933 || (pixel_index >= 2026) && (pixel_index <= 2027)) oled_data <= 16'b0101001010001010;
                         else if (((pixel_index >= 1258) && (pixel_index <= 1264)) || ((pixel_index >= 1353) && (pixel_index <= 1357)) || ((pixel_index >= 1449) && (pixel_index <= 1453)) || ((pixel_index >= 1544) && (pixel_index <= 1550)) || ((pixel_index >= 1639) && (pixel_index <= 1645)) || ((pixel_index >= 1647) && (pixel_index <= 1648)) || ((pixel_index >= 1735) && (pixel_index <= 1742)) || ((pixel_index >= 1745) && (pixel_index <= 1746)) || ((pixel_index >= 1832) && (pixel_index <= 1836)) || ((pixel_index >= 1929) && (pixel_index <= 1930)) || pixel_index == 1932) oled_data <= 16'b1010010100010100;
                         else oled_data <= 0;
                                 
                3: if (((pixel_index >= 1065) && (pixel_index <= 1069)) || pixel_index == 1167 || pixel_index == 1264 || pixel_index == 1457 || pixel_index == 1544 || pixel_index == 1550 || pixel_index == 1640 || pixel_index == 1642 || pixel_index == 1644 || pixel_index == 1646 || pixel_index == 1737 || ((pixel_index >= 1740) && (pixel_index <= 1742)) || ((pixel_index >= 1837) && (pixel_index <= 1838)) || ((pixel_index >= 1933) && (pixel_index <= 1934)) || ((pixel_index >= 2029) && (pixel_index <= 2030)) || (pixel_index >= 2125) && (pixel_index <= 2126)) oled_data <= 16'b0101001010001010;
                         else if (((pixel_index >= 1160) && (pixel_index <= 1166)) || ((pixel_index >= 1256) && (pixel_index <= 1263)) || ((pixel_index >= 1352) && (pixel_index <= 1360)) || ((pixel_index >= 1448) && (pixel_index <= 1456)) || ((pixel_index >= 1545) && (pixel_index <= 1549)) || ((pixel_index >= 1552) && (pixel_index <= 1553)) || pixel_index == 1641 || pixel_index == 1643 || pixel_index == 1645 || pixel_index == 1649 || pixel_index == 1739) oled_data <= 16'b1010010100010100;
                         else oled_data <= 0;
                                 
                4: if (pixel_index == 974 || pixel_index == 1068 || pixel_index == 1072 || pixel_index == 1163 || ((pixel_index >= 1258) && (pixel_index <= 1259)) || pixel_index == 1265 || pixel_index == 1354 || ((pixel_index >= 1450) && (pixel_index <= 1451)) || pixel_index == 1458 || pixel_index == 1554 || ((pixel_index >= 1742) && (pixel_index <= 1743)) || pixel_index == 1836 || pixel_index == 1841 || pixel_index == 1936) oled_data <= 16'b0101001010001010;
                         else if (((pixel_index >= 1069) && (pixel_index <= 1071)) || ((pixel_index >= 1164) && (pixel_index <= 1168)) || ((pixel_index >= 1260) && (pixel_index <= 1264)) || ((pixel_index >= 1355) && (pixel_index <= 1361)) || ((pixel_index >= 1452) && (pixel_index <= 1457)) || ((pixel_index >= 1547) && (pixel_index <= 1553)) || ((pixel_index >= 1645) && (pixel_index <= 1649)) || ((pixel_index >= 1740) && (pixel_index <= 1741)) || ((pixel_index >= 1744) && (pixel_index <= 1745)) || ((pixel_index >= 1834) && (pixel_index <= 1835)) || ((pixel_index >= 1839) && (pixel_index <= 1840)) || ((pixel_index >= 1929) && (pixel_index <= 1930)) || pixel_index == 1935 || pixel_index == 2031) oled_data <= 16'b1010010100010100;
                         else if (pixel_index == 1643) oled_data <= 16'b0101010100001010;
                         else oled_data <= 0;
                                 
                5: if (((pixel_index >= 1262) && (pixel_index <= 1264)) || pixel_index == 1357 || pixel_index == 1362 || pixel_index == 1453 || pixel_index == 1544 || pixel_index == 1546 || pixel_index == 1548 || pixel_index == 1644 || pixel_index == 1739 || pixel_index == 1837 || pixel_index == 1842 || pixel_index == 1931 || pixel_index == 2033 || pixel_index == 2126) oled_data <= 16'b0101001010001010;
                         else if (((pixel_index >= 1358) && (pixel_index <= 1361)) || pixel_index == 1448 || pixel_index == 1452 || ((pixel_index >= 1455) && (pixel_index <= 1459)) || pixel_index == 1545 || ((pixel_index >= 1549) && (pixel_index <= 1555)) || ((pixel_index >= 1642) && (pixel_index <= 1643)) || ((pixel_index >= 1645) && (pixel_index <= 1651)) || ((pixel_index >= 1740) && (pixel_index <= 1746)) || ((pixel_index >= 1838) && (pixel_index <= 1841)) || ((pixel_index >= 1932) && (pixel_index <= 1937)) || (pixel_index >= 2026) && (pixel_index <= 2032)) oled_data <= 16'b1010010100010100;
                         else if (pixel_index == 1454) oled_data <= 16'b0101010100001010;
                         else if (pixel_index == 1930) oled_data <= 16'b0101001010000000;
                         else oled_data <= 0;
                         
                default: oled_data <= 0;
                    
                endcase
            end
            else begin 
                fing_pos <= 7;
            end
            
            if (draw_centre) begin
                oled_data <= blue;
            end
            
            if (oled_border) begin
                oled_data <= oled_border;
            end
//            if (is_3s) begin
            if (is_white_square) begin
                oled_data <= white;
            end
            
            if (is_white_border) begin
                oled_data <= white;
            end
            
            if (draw_circle) begin
                oled_data <= white;
            end
            
            if (draw_instructions) begin
                oled_data <= white;
            end
            
            if (draw_submit) begin
                oled_data <= white;
            end
            
            if (draw_numbers) begin
                oled_data <= blue;
            end
            
            if (oled_arrow) begin
                oled_data <= oled_arrow;
            end
            
            if (submit && btnC && (fing_pos == arrow_pos)) begin
                pass <= 1;
                fail <= 0;
            end
            
            if (submit && btnC && (fing_pos != arrow_pos)) begin
                fail <= 1;
                pass <= 0;
            end
            
        end
        else oled_data <= black;
//            led <= 0;
//            led [ 15 - fing_pos ] <= 1;
//            led [ arrow_pos ] <= 1;
                
    end
endmodule
