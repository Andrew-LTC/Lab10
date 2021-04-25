`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/24/2021 08:30:55 PM
// Design Name: 
// Module Name: Morse_Decoder_FSM
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


module Morse_Decoder_FSM(
    input clk, reset_n,
    input b, 
    output dot, dash, lg, wg,
    //timer and counter
    input count,
    output timer_reset, counter_reset
    );
    
    reg [3:0] state_reg, state_next;
    localparam  s0 = 0, s1 = 1, s2 = 2, 
                s3 = 3, s4 = 4, s5 = 5, 
                s6 = 6, s7 = 7, s8 = 8, 
                s9 = 9, s10 = 10;
                
    //State Register
    always @(posedge clk, negedge reset_n)
    begin
        if(~reset_n)
            state_reg <= 0;
        else
            state_reg <= state_next;
    end
    
    //Next State Logic
    always @(*)
    begin
        case(state_reg)
            s0: if(b)                       state_next = s1;
                else if(~b)                 state_next = s0;    
            s1: if(~b)                      state_next = s0;
                else if(b & (count != 1))   state_next = s1;
                else if(b & (count == 1))   state_next = s2;
            s2: if(b)                       state_next = s4;
                else if(~b)                 state_next = s3;
            s3: if(b)                       state_next = s1;
                else if(~b)                 state_next = s6;
            s4: if(~b)                      state_next = s3;
                else if(b & (count != 2))   state_next = s4;
                else if(b & (count == 2))   state_next = s5;
            s5: if(b)                       state_next = s5;
                    else if(~b)             state_next = s6;
            s6: if(b)                       state_next = s0;
                else if(~b & (count != 3))  state_next = s6;
                else if(~b & (count == 3))  state_next = s7;
            s7: if(b)                       state_next = s8;
                else if(~b)                 state_next = s9;
            s8: state_next = s0;
            s9: if(b)                       state_next = s8;
                else if(~b & (count != 4))  state_next = s9;
                else if(~b & (count == 4))  state_next = s10;
            s10:state_next = s0;
            default: state_next = state_reg;
        endcase
    end
    
    //Output Logic
    assign timer_reset = ((state_reg == s0) | (state_reg == s2) | (state_reg == s3)
                          | (state_reg == s5) | (state_reg == s7));
                          
    assign counter_reset = ((state_reg == s0) | (state_reg == s2) | (state_reg == s3)
                          | (state_reg == s5) | (state_reg == s7));
    assign dot = (state_reg == s3);
    assign dash = (state_reg == s5);
    assign lg = (state_reg == s8);
    assign wg = (state_reg == s10);
endmodule
