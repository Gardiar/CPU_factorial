`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.12.2018 14:47:21
// Design Name: 
// Module Name: TOP_tb
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


module TOP_tb(

    );
    reg clk;
    reg reset;
    reg [7:0] InA;
    reg [7:0] InB;
    reg Start;
    wire Busy;
    wire [7:0] Out;
        
    TOP dut(
         .clk(clk),
         .reset(reset),
         .InA(InA),
         .InB(InB),
         .start(Start),
         .busy(Busy),
         .Out(Out)
        );
         
    initial
    begin
        clk=0; reset=1; InA=8'd5; Start=0;
        #70;
        reset=0;
        #20;
        Start=1;
        #1290;
        Start=0;
        reset=1;
        #1000;
        InA=8'd3;
        Start=1;
        reset=0;
        #1000;
        Start=0;
        reset=1;
        #1000;
        InA=8'd4;
        Start=1;
        reset=0;
        #1600;
        Start=0;
        reset=1;
        #1000;
        InA=8'd2;
        Start=1;
        reset=0;
        #1000;
        Start=0;
        reset=1;
        #1000;
        InA=8'd1;
        Start=1;
        reset=0;  
    end  
         
         
    always#30 clk=~clk;
         
            
endmodule