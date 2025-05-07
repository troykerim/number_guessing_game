`timescale 1ns / 1ps
module top_module_part4
(
input  clk,
input  rst, 
//inout [7:0] keypad,
input [3:0] row,
output [3:0] col,
output  c,
output [6:0] segment,
input stop,
input show,
output correct,
output closer,
output farther
);
  
//main 
wire[3:0] decode_out;
wire[3:0] pulse_out;
wire[3:0] seg_in;
reg[3:0] seg_inreg;

reg key_press; //digit select

reg [31:0] count;


reg [3:0] target_number;
reg[3:0] target_number2;
reg count_enable = 1; //initialize counter to 1

reg[1:0] btnc_shift;
reg[3:0] curr_diff1;
reg[3:0] curr_diff2;
wire[6:0] curr_diff;

reg[3:0] prev_diff1;
reg[3:0] prev_diff2;
wire[6:0] prev_diff;

reg[3:0] prev_user_input1;
reg[3:0] prev_user_input2;
reg[3:0] curr_user_input1;
reg[3:0] curr_user_input2;


wire[6:0] seg_count, seg_count2;
wire[6:0] seg_any2;
reg [3:0] count2, count3;

wire[6:0] seg_keypad1, seg_keypad2;
wire[6:0] seg_any;
reg[3:0] decode1, decode2;


reg key_sel;


//keep both digits on
localparam count_width = 20;
reg [count_width-1:0] count_main = 0;
reg [count_width-1:0] count_main2 = 0;



reg correct_reg;
reg[1:0] diff_sel; 
reg[32:0] count_mega2;

reg[32:0] count_other = 0;



//KEYPAD DECODER
Decoder D0 (.clk(clk), .rst(rst), .row(row[3:0]), .col(col[3:0]), .DecodeOut(decode_out));  

//SEVEN SEGMENT DISPLAY FOR COUNTER
ssd_driver S1(.dig(count2), .segment(seg_count));
ssd_driver S4(.dig(count3), .segment(seg_count2));

//SEVEN SEGMENT DISPLAY FOR KEYPAD
ssd_driver S2(.dig(decode1), .segment(seg_keypad1));
ssd_driver S3(.dig(decode2), .segment(seg_keypad2));


//Debounce logic
DeBounce #(.clk_freq(50000000), .stable_time(10)) D1(.clk(clk), .reset_n(rst), .button(decode_out[0]), .result(pulse_out[0]));
DeBounce #(.clk_freq(50000000), .stable_time(10)) D2(.clk(clk), .reset_n(rst), .button(decode_out[1]), .result(pulse_out[1]));
DeBounce #(.clk_freq(50000000), .stable_time(10)) D3(.clk(clk), .reset_n(rst), .button(decode_out[2]), .result(pulse_out[2]));
DeBounce #(.clk_freq(50000000), .stable_time(10)) D4(.clk(clk), .reset_n(rst), .button(decode_out[3]), .result(pulse_out[3]));

//for keypad
always@(posedge clk)
begin
    if(rst)
        count_main <= 0;
    else
        count_main<=count_main+1;
end

//for counter
always@(posedge clk)
begin
    if(rst)
        count_main2 <= 0;
    else
        count_main2<=count_main2+1;
end

always @(posedge clk) 
begin
    if(rst)
    begin
        key_sel <= 0;
        decode1 <= 0;
        decode2 <= 0;
    end
    
    else
    begin
    
    if(decode_out!=pulse_out && count_enable == 0)
    begin
        key_sel <= ~key_sel;        
    end
    
    else
    begin      
        if(!key_sel)
        begin           
            decode1 <= decode_out;
                
        end              
        else
        begin
            decode2<= decode_out; 
        end
                      
        if(show)
        begin
            decode1 <= target_number;
            decode2 <= target_number2;
        end        
    end
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
    count3 <= 0;
end

else
begin
    if(count_enable)
    begin
        if(count==100000000)
        begin
            if(count2 == 4'b1001)
            begin  
                count2 <= 0;
                count<=0;
                count3 <= count3+1; //second 
                if(count3 == 4'b1001)
                    count3<=0;
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
        target_number2 <= count3;
    end
end

always @*
begin
    if(target_number == decode1 && target_number2 == decode2)
        correct_reg = 1;
    else
        correct_reg = 0;
end


always@*
begin


prev_diff1 = target_number-prev_user_input1;
curr_diff1 = target_number-decode1;

prev_diff2 = target_number-prev_user_input2;
curr_diff2 = target_number-decode2;    


end

assign farther = (prev_user_input2 != decode2) ? 1'b1 : 1'b0; //blue
//assign closer = (curr_diff>prev_diff) ? 1'b1 : 1'b0;//red
assign curr_diff = {curr_diff2, curr_diff1};
assign prev_diff = {prev_diff2, prev_diff1};
assign correct = correct_reg;
assign c = (count_enable) ? count_main2[count_width-1] : count_main[count_width-1];
assign segment = (count_enable) ? seg_any2 : seg_any;
assign seg_any = (!count_main[count_width-1]) ? seg_keypad1 : seg_keypad2;
assign seg_any2 = (!count_main2[count_width-1]) ? seg_count : seg_count2;
endmodule
