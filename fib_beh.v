`timescale 1ns/1ns

module Fib_Seq (
    Start, Clk, Rst, Number, Result, Done
);
    input Start, Clk, Rst;
    input [9:0]Number;
    output reg [9:0]Result;
    output reg Done;
    reg [9:0] T1, T2, NextNum;

    //State Encoding
    parameter S_Wait = 3'b000,
              S_1 = 3'b001,
              S_2 = 3'b010,
              S_3 = 3'b011,
              S_4 = 3'b100,
              S_2a = 3'b101;

    reg [2:0] State, StateNext; //3bit

    //StateReg
    always @(posedge Clk) begin
        if (Rst == 1) begin
            State <= S_Wait;
            Done <= 1'b0;
            Result <= 0;
        end
        else State <= StateNext;
    end
    
    //CombLogic(상태, input)
    always @(State, Start, Number) begin

        case (State)
            S_Wait: begin
                if (Start == 1'b1) 
                    StateNext <= S_1;
                else
                    StateNext <= S_Wait;
            end
            S_1: begin
                T1 <= 0;
                T2 <= 1;
                NextNum <= 0;
                StateNext <= S_2;
            end 
            S_2: begin
                Result <= NextNum;
                NextNum <= T1 + T2;
                StateNext <= S_2a;
            end
            S_2a: begin
                if (NextNum <= Number) 
                    begin
                    Result <= NextNum;
                    StateNext <= S_3;
                    end
                else
                    StateNext <= S_4;
            end
            S_3: begin
                T1 <= T2;
                T2 <= NextNum;
                StateNext <= S_2;
            end 
            S_4: begin
                StateNext <= S_Wait;
                Done <= 1'b1;
            end 
            default: begin
                Result <= 0;
                Done <= 1'b0;
                StateNext <= S_Wait;
            end
        endcase
    end

endmodule