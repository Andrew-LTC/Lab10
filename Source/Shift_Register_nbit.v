`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/25/2021 02:45:41 PM
// Design Name: 
// Module Name: Shift_Register_nbit
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


module Shift_Register_nbit
    #(parameter N = 4)(
    input clk, reset_n,
    input SI, shift,
    output Q
    );
    
    reg [N-1:0] Q_reg, Q_next;
    
    always @(posedge clk, negedge reset_n)
    begin
        if(~reset_n)
            Q_reg <= 'b0;
        else
            Q_reg <= Q_next;
    end
    
    always @(*)
    begin
        if(shift)
            Q_next = {SI,Q_reg[N-1:1]};
        else
            Q_next = Q_reg;
    end
    
    assign Q = Q_reg;
endmodule

