//`timescale 1ns / 1ps

/*
    PART 2
    Get 2 digit inputs from Keypad pmod
    Display input 1 on left display of ssd
    Display input 2 on right display of ssd
    
    NOTE: You must reconfigure the XDC files with this module's I/Os.
*/
/*
module top_module(
    input  clk,
    input  rst, 
    inout [7:0] keypad,
    output  c,
    output [6:0] segment
);
  
  
//main 
wire[3:0] decode_out;
wire[3:0] pulse_out;

//secondary
reg[3:0] decode_out1reg, decode_out2reg;
wire[3:0] decode_out1, decode_out2;
wire[6:0] segment1, segment2;

reg dig_sel; //digit select

localparam count_width = 20;
reg [count_width-1:0] count = 0;

//KEYPAD DECODER
Decoder D0 (.clk(clk), .Row(keypad[7:4]), .Col(keypad[3:0]), .DecodeOut(decode_out));  

//SEVEN SEGMENT DISPLAY 
ssd_driver S1(.dig(decode_out1), .segment(segment1));
ssd_driver S2(.dig(decode_out2), .segment(segment2));

//Debounce logic
DeBounce #(.clk_freq(50000000), .stable_time(10)) D1(.clk(clk), .reset_n(rst), .button(decode_out[0]), .result(pulse_out[0]));
DeBounce #(.clk_freq(50000000), .stable_time(10)) D2(.clk(clk), .reset_n(rst), .button(decode_out[1]), .result(pulse_out[1]));
DeBounce #(.clk_freq(50000000), .stable_time(10)) D3(.clk(clk), .reset_n(rst), .button(decode_out[2]), .result(pulse_out[2]));
DeBounce #(.clk_freq(50000000), .stable_time(10)) D4(.clk(clk), .reset_n(rst), .button(decode_out[3]), .result(pulse_out[3]));


always@(posedge clk)
begin
    if(rst)
        count <= 0;
    else
        count<=count+1;
end

always @(posedge clk) 
begin

    if(rst)
    begin
        dig_sel <= 0;
        decode_out1reg <= 0;
        decode_out2reg <= 0;
    end
    
    else if(decode_out!=pulse_out)
        dig_sel <= ~dig_sel; 
    
    else
    begin
        if(!dig_sel)
            decode_out1reg <= decode_out;
        else
            decode_out2reg <= decode_out;              
    end
              
end

assign decode_out1 = decode_out1reg;
assign decode_out2 = decode_out2reg;
assign c = count[count_width-1];
assign segment = (!count[count_width-1]) ? segment1 : segment2;

//assign segment = (!clk_count[CLK_CNT_WIDTH-1]) ? segment1 : segment2;

endmodule */
