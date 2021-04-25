`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/25/2021 02:13:26 PM
// Design Name: 
// Module Name: Morse_Decoder_Application
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


module Morse_Decoder_Application(
    input CLK100MHZ, resetButton,
    input bButton,
    output DP,
    output [7:0] AN,
    output [6:0] SEG
    );
    
    wire reset, b;
    button Reset (
        .clk(CLK100MHZ),
        .noisy(resetButton),
        .n_edge(reset)
    );
    button B (
        .clk(CLK100MHZ),
        .noisy(bButton),
        .n_edge(b)
    );
    
    wire dot,dash;
    wire [2:0] counterOUT;
    wire [4:0] shiftOUT;
    Morse_Decoder MD (
        .clk(CLK100MHZ),
        .reset_n(~reset),
        .b(b),
        .dot(dot),
        .dash(dash),
        .lg('bz),
        .wg('bz)
    );
    
    udl_counter #(.BITS(3)) Counter3Bit (
        .clk(CLK100MHZ),
        .reset_n(~reset),
        .enable(dot ^ dash),
        .up(1'b1),
        .load(counterOUT == 3'd5),
        .D('b0),
        .Q(counterOUT)
    );
    
    Shift_Register_nbit #(.N(5)) Shift (
        .clk(CLK100MHZ),
        .reset_n(~reset),
        .SI(dash),
        .shift(dot ^ dash),
        .Q(shiftOUT)
    );
    
    sseg_driver Display (
        .I7({2'b10,counterOUT,1'b0}),
        .I6(6'b0),
        .I5(6'b0),
        .I4({4'b1000,shiftOUT[4],1'b0}),
        .I3({4'b1000,shiftOUT[3],1'b0}),
        .I2({4'b1000,shiftOUT[2],1'b0}),
        .I1({4'b1000,shiftOUT[1],1'b0}),
        .I0({4'b1000,shiftOUT[0],1'b0}),
        .CLK100MHZ(CLK100MHZ),
        .SSEG(SEG),
        .AN(AN),
        .DP(DP)
    );
endmodule
