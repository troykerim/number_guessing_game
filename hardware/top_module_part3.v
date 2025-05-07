`timescale 1ns / 1ps
/*
    Part 3:
    1 Digit Hot/Cold number game
    
    Push button 0 is the rest, user can press reset to clear the hidden number and start the counter
    
    Create a roll back counter that counts from 0 to F. 
    Value of counter should increment every clk cycle & when it reaches F, roll back to 0
    
    When user presses button 1, stop the counter and record the current number of the counter as target signal
    
    If user pushes button 3, display the target number on the right display of ssd
*/


module top_module_part3(
    input clk,
    input rst,
    input [3:0] row,    // keypad
    output [3:0] col,   // keypad
    input stop,
    input show,
    output correct,     // Green LED
    output closer,      // Red LED
    output farther      // Blue LED
    );
wire[3:0] decode_out;
wire[3:0] pulse_out;
wire[3:0] seg_in;
reg[3:0] seg_inreg;

reg key_press; //digit select

reg [31:0] count;
reg [3:0] count2;
reg [3:0] target_number;
reg count_enable = 1; //initialize counter to 1

reg[1:0] btnc_shift;
reg[3:0] curr_diff = 0;
reg[3:0] next_diff = 0;


reg farther_reg, closer_reg;

reg[31:0] count3 =0;

wire[6:0] seg_count;
wire[6:0] seg_keypad1, seg_keypad2;
wire[6:0] seg_any;
reg[3:0] decode1, decode2;

reg key_sel;

reg[6:0] curr_diff = 0;
reg[6:0] prev_diff = 0;


//KEYPAD DECODER
Decoder D0 (.clk(clk), .rst(rst), .row(row), .col(col), .DecodeOut(decode_out));  

//SEVEN SEGMENT DISPLAY FOR COUNTER
ssd_driver S1(.dig(count2), .segment(seg_count));

//SEVEN SEGMENT DISPLAY FOR KEYPAD
ssd_driver S2(.dig(decode1), .segment(seg_keypad1));
ssd_driver S3(.dig(decode2), .segment(seg_keypad2));


//Debounce logic
DeBounce #(.clk_freq(50000000), .stable_time(10)) D1(.clk(clk), .reset_n(rst), .button(decode_out[0]), .result(pulse_out[0]));
DeBounce #(.clk_freq(50000000), .stable_time(10)) D2(.clk(clk), .reset_n(rst), .button(decode_out[1]), .result(pulse_out[1]));
DeBounce #(.clk_freq(50000000), .stable_time(10)) D3(.clk(clk), .reset_n(rst), .button(decode_out[2]), .result(pulse_out[2]));
DeBounce #(.clk_freq(50000000), .stable_time(10)) D4(.clk(clk), .reset_n(rst), .button(decode_out[3]), .result(pulse_out[3]));



always @(posedge clk) 
begin
    if(rst)
    begin
        key_sel <= 0;
        decode1 <= 0;
        decode2 <= 0;
    end
    
    else if(decode_out!=pulse_out)
        key_sel <= ~key_sel; 
    
    else
    begin
        if(!key_sel)
            decode1 <= decode_out;
        else
            decode2 <= decode_out;    
        
        if(show)
        begin
            decode1 <= target_number;
            decode2 <= target_number;
        end        
    end
              
end

always @(posedge clk)
begin
    if(rst)
    begin
        curr_diff <= 0;
        next_diff <= 0;
    end
    
    else
    begin
        if(!key_sel)
            curr_diff <= (decode1 - target_number); //
        else 
            next_diff <= (decode2 - target_number);
    end     
    
end



always @(posedge clk)
    btnc_shift <= {btnc_shift,stop};

wire btnc_rise = btnc_shift == 2'b01;


always @(posedge clk)
begin
    if(rst)
        count_enable <= 1;
    else
        if(btnc_rise)
            count_enable<=0;
end

always@(posedge clk)

if(rst)
begin
    count2 <= 0;
    count <= 0;
end

else
begin
    if(count_enable)
    begin
        if(count==100000000)
        begin
            if(count2 == 4'b1111)
            begin  
                count2 <= 0;
                count<=0;
            end
            
            else
            begin
                count2<=count2+1;    
                count<=0; 
            end        
        end
        
        else
        begin
            count<=count+1;
        end       
    end
    
    else
    begin
        target_number <= count2;
    end
end
 

assign farther = (curr_diff && (next_diff < curr_diff)) ? 1'b1 : 1'b0; //blue
assign closer = (curr_diff && (next_diff > curr_diff)) ? 1'b1 : 1'b0;//red
assign correct = (decode_out == target_number) ? 1'b1 : 1'b0;
assign seg_in = seg_inreg;
assign c = (count_enable) ? 1'b0 : 1'b1;
assign segment = (count_enable) ? seg_count : seg_any;
assign seg_any = (!key_sel) ? seg_keypad1 : seg_keypad2;
endmodule
