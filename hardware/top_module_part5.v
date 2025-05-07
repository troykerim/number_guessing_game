`timescale 1ns / 1ps


module top_module_part5(
    input  clk,
    input  rst, 
    input [3:0] row,
    output [3:0] col,
    output  c,
    output [6:0] segment,
    input stop,
    input show,
    output correct,
    output closer,
    output farther,
    input select
    );

wire clk1, clk2;
wire rst1, rst2;
wire[7:0] keypad1, keypad2;
wire c1, c2;
wire[6:0] segment1, segment2;
wire stop1, stop2;
wire show1, show2;
wire correct1, correct2;
wire closer1, closer2;
wire farther1, farther2;
wire[3:0] row1, row2;
wire[3:0] col1, col2;



top_module_part4 D0(.clk(clk1), .rst(rst1), .row(row1), .col(col1), .c(c1), .segment(segment1), .stop(stop1)
,.show(show1), .correct(correct1), .farther(farther1),.closer(closer1));

top_module_part3 D1(.clk(clk2), .rst(rst2), .row(row2), .col(col2), .c(c2), .segment(segment2), .stop(stop2)
,.show(show2), .correct(correct2), .farther(farther2), .closer(closer2));

assign clk1 = (select) ? clk : 1'b0;
assign clk2 = (!select) ? clk : 1'b0;

assign rst1 = (select) ? rst : 1'b0;
assign rst2 = (!select) ? rst : 1'b0;

assign col = (select) ? col1 : col2;

assign row1 = (select) ? row : 1'b0;
assign row2 = (!select) ? row : 1'b0;

assign segment = (select)? segment1 : segment2;

assign stop1 = (select) ? stop : 1'b0;
assign stop2 = (!select) ? stop : 1'b0;

assign show1 = (select) ? show : 1'b0;
assign show2 = (!select) ? show : 1'b0;

assign correct = (select) ? correct1 : correct2;

assign farther = (select) ? farther1 : farther2;

assign closer = (select) ? closer1 : closer2;

assign c = (select) ? c1 : c2;

endmodule
