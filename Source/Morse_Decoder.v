`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/25/2021 12:02:28 PM
// Design Name: 
// Module Name: Morse_Decoder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Morse_Decoder(
    input clk, reset_n,
    input b,
    output dot, dash, lg, wg
    );
    
    wire Q, timer_reset, counter_reset, timer_done;
    
    Morse_Decoder_FSM FSM (
        .clk(clk),
        .reset_n(reset_n),
        .b(b),
        .dot(dot),
        .dash(dash),
        .lg(lg),
        .wg(wg),
        .count(Q),
        .timer_reset(timer_reset),
        .counter_reset(counter_reset)
    );
    
    //50ms timer = 4_999_999
    timer_parameter #(.FINAL_VALUE(4_999_999)) Timer (
        .clk(clk),
        .reset_n(~timer_reset),
        .enable(~timer_reset),
        .done(timer_done)
    );
    
    udl_counter #(.BITS(4)) Counter (
        .clk(clk),
        .reset_n(~counter_reset),
        .enable(timer_done),
        .up(1'b1),
        .load(1'b0),
        .D('bz),
        .Q(Q)
    );
endmodule
