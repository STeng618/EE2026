`timescale 1ns / 1ps

module MENU(
    input clock, 
    input left, middle, right, 
    input [12:0] pixel_index,
    input [6:0] x, xpos, [5:0] y, ypos,
    input circ_pass, circ_fail, fing_pass, fing_fail, geo_pass, geo_fail, abc_pass, abc_fail,
    input [15:0] circ_pixel_data, fing_pixel_data, geo_pixel_data, abc_pixel_data, 
    output circ, fing, geo, abc,
    output [15:0] pixel_data
    );
    
    parameter SQUARE_SIZE = 169; 
    reg zero [ 0 : SQUARE_SIZE - 1 ]; 
    reg one [ 0 : SQUARE_SIZE - 1 ]; 
    reg two [ 0 : SQUARE_SIZE - 1 ]; 
    reg three [ 0 : SQUARE_SIZE - 1 ]; 
    reg four [ 0 : SQUARE_SIZE - 1 ]; 
    reg human [ 0 : SQUARE_SIZE - 1 ]; 
    reg bot [ 0 : SQUARE_SIZE - 1 ]; 
    
    reg [15:0] result [ 0 : 6143 ]; 
    initial begin
        $readmemh ( "Human.mem", human );
        $readmemh ( "Bot.mem", bot );
        $readmemh ( "0.mem", zero );
        $readmemh ( "1.mem", one);
        $readmemh ( "2.mem", two );
        $readmemh ( "3.mem", three );
        $readmemh ( "4.mem", four );
        $readmemh ( "result.mem", result ); 
    end 
    
    parameter CIRC = 0, FING = 1, GEO = 2, ABC = 3, MENU = 4, RESULT = 5;
    
    reg [15:0] menu_pixel_data, result_pixel_data; 
    
    reg [2:0] current_game = MENU; 
    reg is_right = 0;
    
    assign circ = is_right ? 0 : ( current_game == CIRC );
    assign fing = is_right ? 0 : ( current_game == FING );
    assign geo = is_right ? 0 : ( current_game == GEO );
    assign abc = is_right ? 0 : ( current_game == ABC );
    

    
    always @ ( posedge clock ) begin
        if (((pixel_index >= 126) && (pixel_index <= 127)) || ((pixel_index >= 132) && (pixel_index <= 133)) || ((pixel_index >= 136) && (pixel_index <= 139)) || ((pixel_index >= 142) && (pixel_index <= 145)) || ((pixel_index >= 148) && (pixel_index <= 150)) || pixel_index == 153 || pixel_index == 157 || ((pixel_index >= 160) && (pixel_index <= 161)) || ((pixel_index >= 221) && (pixel_index <= 224)) || ((pixel_index >= 227) && (pixel_index <= 230)) || ((pixel_index >= 233) && (pixel_index <= 236)) || ((pixel_index >= 238) && (pixel_index <= 239)) || pixel_index == 241 || ((pixel_index >= 243) && (pixel_index <= 247)) || ((pixel_index >= 255) && (pixel_index <= 258)) || ((pixel_index >= 316) && (pixel_index <= 317)) || ((pixel_index >= 323) && (pixel_index <= 325)) || ((pixel_index >= 335) && (pixel_index <= 336)) || pixel_index == 343 || ((pixel_index >= 346) && (pixel_index <= 348)) || ((pixel_index >= 352) && (pixel_index <= 355)) || ((pixel_index >= 412) && (pixel_index <= 413)) || ((pixel_index >= 419) && (pixel_index <= 421)) || ((pixel_index >= 425) && (pixel_index <= 428)) || ((pixel_index >= 431) && (pixel_index <= 432)) || ((pixel_index >= 442) && (pixel_index <= 444)) || ((pixel_index >= 448) && (pixel_index <= 451)) || ((pixel_index >= 508) && (pixel_index <= 509)) || ((pixel_index >= 521) && (pixel_index <= 523)) || ((pixel_index >= 527) && (pixel_index <= 528)) || pixel_index == 535 || pixel_index == 543 || pixel_index == 547 || ((pixel_index >= 605) && (pixel_index <= 608)) || ((pixel_index >= 623) && (pixel_index <= 624)) || ((pixel_index >= 627) && (pixel_index <= 631)) || pixel_index == 639 || pixel_index == 643 || ((pixel_index >= 702) && (pixel_index <= 703)) || pixel_index == 706 || pixel_index == 710 || pixel_index == 712 || ((pixel_index >= 724) && (pixel_index <= 726)) || pixel_index == 729 || pixel_index == 733 || pixel_index == 4057 || pixel_index == 4152 || pixel_index == 4593 || pixel_index == 4631 || pixel_index == 4668 || pixel_index == 4673 || pixel_index == 4830 || pixel_index == 4834 || pixel_index == 5025 || pixel_index == 5069 || pixel_index == 5214 || pixel_index == 5350) menu_pixel_data = 16'b0101001010001010;
        else if (pixel_index == 232 || pixel_index == 240 || pixel_index == 249 || pixel_index == 253 || pixel_index == 322 || pixel_index == 326 || pixel_index == 328 || pixel_index == 332 || pixel_index == 339 || pixel_index == 345 || pixel_index == 349 || pixel_index == 351 || pixel_index == 418 || pixel_index == 422 || pixel_index == 424 || pixel_index == 435 || pixel_index == 441 || pixel_index == 445 || pixel_index == 447 || pixel_index == 514 || pixel_index == 518 || pixel_index == 520 || pixel_index == 531 || pixel_index == 537 || pixel_index == 541 || pixel_index == 610 || pixel_index == 614 || pixel_index == 616 || pixel_index == 633 || pixel_index == 637 || pixel_index == 4580 || pixel_index == 4964 || pixel_index == 5060) menu_pixel_data = 16'b1010010100010100;
        else if (pixel_index == 350 || pixel_index == 446 || pixel_index == 542 || pixel_index == 638 || ((pixel_index >= 1645) && (pixel_index <= 1646)) || ((pixel_index >= 1648) && (pixel_index <= 1649)) || pixel_index == 1740 || pixel_index == 1746 || pixel_index == 1843 || pixel_index == 1931 || pixel_index == 1939 || pixel_index == 2027 || pixel_index == 2035 || pixel_index == 2123 || pixel_index == 2131 || pixel_index == 2316 || pixel_index == 2322 || ((pixel_index >= 2414) && (pixel_index <= 2415)) || pixel_index == 3963 || pixel_index == 4060 || pixel_index == 4155 || pixel_index == 4301 || pixel_index == 4591 || pixel_index == 4682 || pixel_index == 4876 || pixel_index == 4915 || pixel_index == 4970 || pixel_index == 5011 || pixel_index == 5121 || ((pixel_index >= 5215) && (pixel_index <= 5216)) || pixel_index == 5264 || pixel_index == 5311 || pixel_index == 5400 || pixel_index == 5405) menu_pixel_data = 16'b0000001010001010;
        else if (pixel_index == 1647 || pixel_index == 1835 || ((pixel_index >= 2219) && (pixel_index <= 2220)) || pixel_index == 2227 || pixel_index == 2317 || pixel_index == 2413 || pixel_index == 2417 || pixel_index == 3964 || pixel_index == 4304 || pixel_index == 4401 || pixel_index == 4586 || pixel_index == 4589 || pixel_index == 4626 || pixel_index == 4780 || pixel_index == 4930 || pixel_index == 5066 || pixel_index == 5070 || pixel_index == 5169 || pixel_index == 5259 || pixel_index == 5356 || pixel_index == 5359 || pixel_index == 5399) menu_pixel_data = 16'b0000000000001010;
        else if (pixel_index == 1665 || ((pixel_index >= 1667) && (pixel_index <= 1668)) || pixel_index == 1790 || pixel_index == 1804 || pixel_index == 1855 || pixel_index == 1959 || pixel_index == 2055 || pixel_index == 2073 || pixel_index == 2134 || pixel_index == 2151 || pixel_index == 2224 || ((pixel_index >= 2239) && (pixel_index <= 2240)) || ((pixel_index >= 2336) && (pixel_index <= 2337)) || pixel_index == 2341 || pixel_index == 2433 || pixel_index == 2437 || ((pixel_index >= 2553) && (pixel_index <= 2554)) || ((pixel_index >= 2576) && (pixel_index <= 2577)) || pixel_index == 4283 || pixel_index == 4285 || pixel_index == 4478 || pixel_index == 4572 || pixel_index == 4665 || pixel_index == 4761 || pixel_index == 4863 || pixel_index == 5051 || pixel_index == 5053 || pixel_index == 5144 || pixel_index == 5147 || pixel_index == 5149 || pixel_index == 5240 || pixel_index == 5243 || pixel_index == 5248 || pixel_index == 5336 || pixel_index == 5344) menu_pixel_data = 16'b0101000000000000;
        else if (pixel_index == 1666 || pixel_index == 1669 || pixel_index == 1760 || pixel_index == 1766 || pixel_index == 1863 || pixel_index == 1951 || pixel_index == 2143 || pixel_index == 2247 || pixel_index == 2342 || ((pixel_index >= 2434) && (pixel_index <= 2436)) || ((pixel_index >= 4476) && (pixel_index <= 4477)) || pixel_index == 4571 || ((pixel_index >= 4573) && (pixel_index <= 4574)) || ((pixel_index >= 4666) && (pixel_index <= 4667)) || ((pixel_index >= 4669) && (pixel_index <= 4670)) || ((pixel_index >= 4762) && (pixel_index <= 4764)) || pixel_index == 4766 || ((pixel_index >= 4857) && (pixel_index <= 4859)) || pixel_index == 4861 || pixel_index == 4953 || pixel_index == 4955 || ((pixel_index >= 5049) && (pixel_index <= 5050)) || ((pixel_index >= 5150) && (pixel_index <= 5151)) || pixel_index == 5242 || ((pixel_index >= 5246) && (pixel_index <= 5247)) || pixel_index == 5337 || (pixel_index >= 5342) && (pixel_index <= 5343)) menu_pixel_data = 16'b1010000000000000;
        else if (pixel_index == 1791 || pixel_index == 1803 || pixel_index == 1885 || pixel_index == 1901 || ((pixel_index >= 1981) && (pixel_index <= 1982)) || ((pixel_index >= 1996) && (pixel_index <= 1997)) || pixel_index == 2074 || pixel_index == 2263 || pixel_index == 2291 || pixel_index == 2359 || pixel_index == 2387 || ((pixel_index >= 2456) && (pixel_index <= 2462)) || (pixel_index >= 2476) && (pixel_index <= 2482)) menu_pixel_data = 16'b1010010100000000;
        else if (pixel_index == 1884 || pixel_index == 1887 || pixel_index == 1899 || pixel_index == 1902 || pixel_index == 2037 || pixel_index == 2084 || pixel_index == 2086 || pixel_index == 2135 || pixel_index == 2167 || pixel_index == 2175 || pixel_index == 2187 || pixel_index == 2195 || pixel_index == 2271 || pixel_index == 2283 || pixel_index == 2320 || pixel_index == 2416 || pixel_index == 2512 || ((pixel_index >= 2555) && (pixel_index <= 2558)) || ((pixel_index >= 2572) && (pixel_index <= 2575)) || pixel_index == 2616 || pixel_index == 2705 || pixel_index == 2711 || pixel_index == 2802 || pixel_index == 2806 || pixel_index == 4860) menu_pixel_data = 16'b1010001010000000;
        else if (pixel_index == 1886 || pixel_index == 1900 || ((pixel_index >= 1979) && (pixel_index <= 1980)) || ((pixel_index >= 1998) && (pixel_index <= 1999)) || pixel_index == 2075 || ((pixel_index >= 2078) && (pixel_index <= 2083)) || ((pixel_index >= 2087) && (pixel_index <= 2092)) || ((pixel_index >= 2095) && (pixel_index <= 2096)) || ((pixel_index >= 2168) && (pixel_index <= 2170)) || ((pixel_index >= 2192) && (pixel_index <= 2194)) || pixel_index == 2264 || pixel_index == 2290 || ((pixel_index >= 2360) && (pixel_index <= 2366)) || (pixel_index >= 2380) && (pixel_index <= 2386)) menu_pixel_data = 16'b1111010100000000;
        else if (pixel_index == 1978 || ((pixel_index >= 1983) && (pixel_index <= 1987)) || ((pixel_index >= 1991) && (pixel_index <= 1995)) || pixel_index == 2000 || pixel_index == 2034 || pixel_index == 2036 || pixel_index == 2038 || pixel_index == 2072 || ((pixel_index >= 2097) && (pixel_index <= 2098)) || ((pixel_index >= 2129) && (pixel_index <= 2130)) || pixel_index == 2225 || pixel_index == 2232 || pixel_index == 2328 || pixel_index == 2367 || pixel_index == 2379 || pixel_index == 2455 || pixel_index == 2483 || pixel_index == 2520 || pixel_index == 2552 || pixel_index == 2578 || pixel_index == 2608 || ((pixel_index >= 2803) && (pixel_index <= 2805)) || ((pixel_index >= 3961) && (pixel_index <= 3962)) || pixel_index == 4054 || pixel_index == 4546) menu_pixel_data = 16'b0101001010000000;
        else if (((pixel_index >= 2046) && (pixel_index <= 2048)) || ((pixel_index >= 2139) && (pixel_index <= 2140)) || pixel_index == 2145 || pixel_index == 2235 || pixel_index == 2242 || pixel_index == 2330 || pixel_index == 2338 || pixel_index == 2426 || pixel_index == 2522 || pixel_index == 2530 || pixel_index == 2618 || pixel_index == 2626 || pixel_index == 2715 || pixel_index == 2721 || ((pixel_index >= 2812) && (pixel_index <= 2816)) || pixel_index == 3960 || pixel_index == 4160 || pixel_index == 4290 || pixel_index == 4339 || pixel_index == 4385 || pixel_index == 4450 || pixel_index == 4481 || pixel_index == 4577 || pixel_index == 4679 || pixel_index == 4769 || pixel_index == 4776 || pixel_index == 4865 || pixel_index == 4869 || pixel_index == 4873 || pixel_index == 4961 || pixel_index == 5057 || pixel_index == 5062 || pixel_index == 5065 || pixel_index == 5153 || pixel_index == 5161 || pixel_index == 5204 || pixel_index == 5249 || pixel_index == 5256 || pixel_index == 5345) menu_pixel_data = 16'b0000001010000000;
        else if (((pixel_index >= 2076) && (pixel_index <= 2077)) || ((pixel_index >= 2093) && (pixel_index <= 2094)) || ((pixel_index >= 2171) && (pixel_index <= 2174)) || ((pixel_index >= 2188) && (pixel_index <= 2191)) || ((pixel_index >= 2265) && (pixel_index <= 2270)) || (pixel_index >= 2284) && (pixel_index <= 2289)) menu_pixel_data = 16'b1111010100001010;
        else if (pixel_index == 4055 || pixel_index == 4062 || pixel_index == 4149 || pixel_index == 4244 || pixel_index == 4292 || pixel_index == 4347 || pixel_index == 4353 || ((pixel_index >= 4387) && (pixel_index <= 4388)) || pixel_index == 4435 || pixel_index == 4482 || pixel_index == 4486 || pixel_index == 4583 || pixel_index == 4642 || pixel_index == 4675 || pixel_index == 4775 || pixel_index == 4866 || pixel_index == 4962 || pixel_index == 5058 || pixel_index == 5160 || pixel_index == 5254) menu_pixel_data = 16'b0101010100000000;
        else if (pixel_index == 4056 || pixel_index == 4058 || pixel_index == 4061 || ((pixel_index >= 4150) && (pixel_index <= 4151)) || ((pixel_index >= 4156) && (pixel_index <= 4159)) || ((pixel_index >= 4245) && (pixel_index <= 4247)) || ((pixel_index >= 4251) && (pixel_index <= 4256)) || pixel_index == 4340 || ((pixel_index >= 4348) && (pixel_index <= 4352)) || pixel_index == 4386 || ((pixel_index >= 4389) && (pixel_index <= 4390)) || pixel_index == 4436 || ((pixel_index >= 4443) && (pixel_index <= 4449)) || ((pixel_index >= 4483) && (pixel_index <= 4485)) || ((pixel_index >= 4531) && (pixel_index <= 4532)) || ((pixel_index >= 4540) && (pixel_index <= 4545)) || ((pixel_index >= 4578) && (pixel_index <= 4579)) || ((pixel_index >= 4581) && (pixel_index <= 4582)) || ((pixel_index >= 4627) && (pixel_index <= 4630)) || ((pixel_index >= 4637) && (pixel_index <= 4641)) || pixel_index == 4674 || ((pixel_index >= 4676) && (pixel_index <= 4677)) || ((pixel_index >= 4723) && (pixel_index <= 4728)) || ((pixel_index >= 4734) && (pixel_index <= 4738)) || ((pixel_index >= 4770) && (pixel_index <= 4771)) || pixel_index == 4774 || ((pixel_index >= 4819) && (pixel_index <= 4824)) || ((pixel_index >= 4831) && (pixel_index <= 4833)) || pixel_index == 4872 || ((pixel_index >= 4916) && (pixel_index <= 4920)) || ((pixel_index >= 4926) && (pixel_index <= 4929)) || pixel_index == 4963 || ((pixel_index >= 4967) && (pixel_index <= 4969)) || ((pixel_index >= 5012) && (pixel_index <= 5015)) || ((pixel_index >= 5022) && (pixel_index <= 5024)) || pixel_index == 5059 || ((pixel_index >= 5063) && (pixel_index <= 5064)) || ((pixel_index >= 5108) && (pixel_index <= 5110)) || ((pixel_index >= 5118) && (pixel_index <= 5120)) || ((pixel_index >= 5155) && (pixel_index <= 5159)) || pixel_index == 5205 || ((pixel_index >= 5250) && (pixel_index <= 5253)) || pixel_index == 5255 || ((pixel_index >= 5346) && (pixel_index <= 5347)) || pixel_index == 5349) menu_pixel_data = 16'b0101010100001010;
        else if (pixel_index == 4059 || ((pixel_index >= 4153) && (pixel_index <= 4154)) || ((pixel_index >= 4248) && (pixel_index <= 4250)) || ((pixel_index >= 4341) && (pixel_index <= 4346)) || pixel_index == 4400 || ((pixel_index >= 4437) && (pixel_index <= 4442)) || pixel_index == 4495 || ((pixel_index >= 4533) && (pixel_index <= 4539)) || ((pixel_index >= 4632) && (pixel_index <= 4636)) || ((pixel_index >= 4683) && (pixel_index <= 4684)) || ((pixel_index >= 4729) && (pixel_index <= 4733)) || ((pixel_index >= 4778) && (pixel_index <= 4779)) || ((pixel_index >= 4825) && (pixel_index <= 4829)) || ((pixel_index >= 4874) && (pixel_index <= 4875)) || ((pixel_index >= 4921) && (pixel_index <= 4925)) || ((pixel_index >= 4971) && (pixel_index <= 4972)) || ((pixel_index >= 4976) && (pixel_index <= 4977)) || ((pixel_index >= 5016) && (pixel_index <= 5021)) || ((pixel_index >= 5067) && (pixel_index <= 5068)) || ((pixel_index >= 5071) && (pixel_index <= 5073)) || ((pixel_index >= 5111) && (pixel_index <= 5117)) || ((pixel_index >= 5166) && (pixel_index <= 5167)) || ((pixel_index >= 5206) && (pixel_index <= 5213)) || ((pixel_index >= 5260) && (pixel_index <= 5261)) || ((pixel_index >= 5302) && (pixel_index <= 5310)) || (pixel_index >= 5401) && (pixel_index <= 5404)) menu_pixel_data = 16'b0000001010010100;
        else if (pixel_index == 4284 || ((pixel_index >= 4378) && (pixel_index <= 4381)) || ((pixel_index >= 4474) && (pixel_index <= 4475)) || pixel_index == 4570 || pixel_index == 4765 || pixel_index == 4862 || pixel_index == 4954 || ((pixel_index >= 4957) && (pixel_index <= 4959)) || ((pixel_index >= 5054) && (pixel_index <= 5055)) || ((pixel_index >= 5145) && (pixel_index <= 5146)) || pixel_index == 5241 || pixel_index == 5338) menu_pixel_data = 16'b1010001010001010;
        else if (pixel_index == 4291 || pixel_index == 4293 || pixel_index == 4487 || pixel_index == 4678 || pixel_index == 4773 || ((pixel_index >= 4867) && (pixel_index <= 4868)) || ((pixel_index >= 4870) && (pixel_index <= 4871)) || pixel_index == 5154 || pixel_index == 5348) menu_pixel_data = 16'b0000010100000000;
        else if (((pixel_index >= 4302) && (pixel_index <= 4303)) || ((pixel_index >= 4396) && (pixel_index <= 4399)) || ((pixel_index >= 4491) && (pixel_index <= 4494)) || ((pixel_index >= 4496) && (pixel_index <= 4497)) || ((pixel_index >= 4587) && (pixel_index <= 4588)) || pixel_index == 4592 || pixel_index == 5163 || pixel_index == 5165 || (pixel_index >= 5357) && (pixel_index <= 5358)) menu_pixel_data = 16'b0101001010010100;
        else if (pixel_index == 4772) menu_pixel_data = 16'b0000011110000000;
        else if (pixel_index == 5164 || pixel_index == 5168 || (pixel_index >= 5262) && (pixel_index <= 5263)) menu_pixel_data = 16'b0101010100010100;
        else menu_pixel_data = 16'b0000000000000000;
        
        // Special borders around the menus to indicate completion status of the tasks
        if ( circ_pass || circ_fail ) begin
            if ( ( x >= 6 && x <= 44 && y >= 7 && y <= 32 ) && !( x >= 8 && x <= 42 && y >= 9 && y <= 30 ) ) begin
                menu_pixel_data = ( circ_pass ) ? GREEN : RED;
            end
        end
        if ( fing_pass || fing_fail ) begin
            if ( ( x >= 50 && x <= 88 && y >= 7 && y <= 32) && !(x >= 52 && x <= 86 && y >= 9 && y <= 30 ) ) begin 
                menu_pixel_data = ( fing_pass ) ? GREEN : RED;
            end
        end
        if ( geo_pass || geo_fail ) begin
            if ( ( x >= 6 && x <= 44 && y >= 35 && y <= 60) && !(x >= 8 && x <= 42 && y >= 37 && y <= 58 ) ) begin 
                menu_pixel_data = ( geo_pass ) ? GREEN : RED;
            end 
        end
        if ( abc_pass || abc_fail ) begin
            if ( ( x >= 50 && x <= 88 && y >= 35 && y <= 60) && !(x >= 52 && x <= 86 && y >= 37 && y <= 58 ) ) begin 
                menu_pixel_data = ( abc_pass ) ? GREEN : RED;
            end 
        end
        
        if ( ( x >= 9 && x <= 41 && y >= 10 && y <= 29 ) && !( x >= 10 && x <= 40 && y >= 11 && y <= 28 ) ) menu_pixel_data = BLUE;
        else if ( ( x >= 9 && x <= 41 && y >= 38 && y <= 57 ) && !( x >= 10 && x <= 40 && y >= 39 && y <= 56 ) ) menu_pixel_data = BLUE;
        else if ( ( x >= 53 && x <= 85 && y >= 10 && y <= 29 ) && !( x >= 54 && x <= 84 && y >= 11 && y <= 28 ) ) menu_pixel_data = BLUE;
        else if ( ( x >= 53 && x <= 85 && y >= 38 && y <= 57 ) && !( x >= 54 && x <= 84 && y >= 39 && y <= 56 ) ) menu_pixel_data = BLUE;
        
        if ( ( ( x == xpos ) && ( ( ( y >= ( ypos - 2 ) ) && ( y <= ( ypos - 1 ) ) ) || ( ( y >= ( ypos + 1 ) ) && ( y <= ( ypos + 2 ) ) ) ) ) 
        || ( ( y == ypos ) && ( ( ( x >= ( xpos - 2 ) ) && ( x <= ( xpos - 1 ) ) ) || ( ( x >= ( xpos + 1 ) ) && ( x <= ( xpos + 2 ) ) ) ) ) )
            menu_pixel_data = 16'b1111111111111111; // Plot out the mouse cursor
    end
    
    reg [31:0] middle_count = 0; 
    reg [31:0] count = 0; 
    always @ ( posedge clock ) begin
        
        if ( current_game == MENU && left ) begin
            if ( xpos >= 10 && xpos <= 41 && ypos >= 10 && ypos <= 29 ) begin
                current_game = CIRC;
            end
            else if ( xpos >= 10 && xpos <= 41 && ypos >= 38 && ypos <= 57 ) begin
                current_game = GEO;
            end
            else if ( xpos >= 54 && xpos <= 85 && ypos >= 10 && ypos <= 29 ) begin
                current_game = FING;
            end
            else if ( xpos >= 54 && xpos <= 85 && ypos >= 38 && ypos <= 57 ) begin
                current_game = ABC;
            end
        end
        
        if ( middle && middle_count == 0 ) begin
            current_game = ( current_game == MENU ) ? RESULT : MENU; 
            middle_count = 1; 
        end 
        
        if ( middle_count != 0 ) begin
            middle_count = ( middle_count == 100_000_000 ) ? 0 : middle_count + 1; 
        end 
            
        if ( right ) begin
            is_right = 1;
        end
        
        if ( is_right && count <= 100_000_000 ) begin
            count = count + 1; 
            if ( count > 100_000_000 ) begin
                is_right = 0;
                count = 0;
            end
        end
        
    end
    
    wire is_pixel_in_square_1, is_pixel_in_square_2, is_pixel_in_square_3; 
    wire [31:0] normalised_pixel_index_1, normalised_pixel_index_2, normalised_pixel_index_3, normalised_pixel_index;
    
    assign is_pixel_in_square_1 = ( x >= 66 && x <= 78 ) && ( y >= 17 && y <= 29 );
    assign is_pixel_in_square_2 = ( x >= 66 && x <= 78 ) && ( y >= 31 && y <= 43 );
    assign is_pixel_in_square_3 = ( x >= 66 && x <= 78 ) && ( y >= 46 && y <= 57 );
    assign normalised_pixel_index_1 = ( y - 17 ) * 13 + ( x - 66 ); 
    assign normalised_pixel_index_2 = ( y - 31 ) * 13 + ( x - 66 ); 
    assign normalised_pixel_index_3 = ( y - 46 ) * 13 + ( x - 66 ); 
    
    assign normalised_pixel_index = is_pixel_in_square_1 ? normalised_pixel_index_1 :  
                                    is_pixel_in_square_2 ? normalised_pixel_index_2 : normalised_pixel_index_3;
                                    
    wire [2:0] pass_num, fail_num;
    assign pass_num = circ_pass + fing_pass + geo_pass + abc_pass;
    assign fail_num = circ_fail + fing_fail + geo_fail + abc_fail;
    
    wire is_human; 
    assign is_human = ( pass_num >= 3 ); 
    
    reg [5:0] to_show; 
    parameter HUMAN_FIG = 5, BOT_FIG = 6, RESULT_PAGE = 7;
    always @ ( pixel_index ) begin
        if ( is_pixel_in_square_1 ) begin
            to_show = pass_num;
        end else if ( is_pixel_in_square_2 ) begin
            to_show = fail_num;
        end else if ( is_pixel_in_square_3 ) begin
            to_show = is_human ? HUMAN_FIG : BOT_FIG; 
        end else begin
            to_show = RESULT_PAGE; 
        end
    end 
    
    always @ ( pixel_index ) begin
        case ( to_show )
            0 : result_pixel_data <= zero[normalised_pixel_index] ? WHITE : 0;
            1 : result_pixel_data <= one[normalised_pixel_index] ? WHITE : 0;
            2 : result_pixel_data <= two[normalised_pixel_index] ? WHITE : 0;
            3 : result_pixel_data <= three[normalised_pixel_index] ? WHITE : 0;
            4 : result_pixel_data <= four[normalised_pixel_index] ? WHITE : 0;
            HUMAN_FIG : result_pixel_data <= human[normalised_pixel_index] ? WHITE : 0;
            BOT_FIG : result_pixel_data <= bot[normalised_pixel_index] ? WHITE : 0;
            RESULT_PAGE : result_pixel_data <= result[pixel_index]; 
        endcase 
    end 
    
    assign pixel_data = ( current_game == MENU ) ? menu_pixel_data : 
                        ( current_game == RESULT ) ? result_pixel_data : 
                        ( current_game == CIRC ) ? circ_pixel_data : 
                        ( current_game == FING ) ? fing_pixel_data : 
                        ( current_game == GEO ) ? geo_pixel_data : abc_pixel_data; 
    
endmodule