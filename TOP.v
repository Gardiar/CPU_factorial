`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.01.2020 10:51:55
// Design Name: 
// Module Name: TOP
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


module TOP(
    input [7:0] InA,
    input [7:0] InB,
    input clk,
    input reset,
    input start,
    output busy,
    output [7:0] Out
    );
    wire [7:0] CUconst;
    wire [7:0] ALUout;
    wire [2:0] InMuxAdd;
    wire WE;
    wire [3:0] RegAdd;
    wire [7:0] ALUinA;
    wire [7:0] ALUinB;
    wire [3:0] OutMuxAdd;
    wire CO;
    wire Z;  
    wire [1:0] InsSel;  
    CU cu(clk,reset,start,busy,InsSel,CO,Z,WE,RegAdd,OutMuxAdd,InMuxAdd,CUconst);
//    input clk,
//    input reset,
//    input start,
//    output busy,
//    output [1:0] InsSel,
//    input CO,
//    input Z,
//    output WE,
//    output [3:0] RegAdd,
//    output [3:0] OutMuxAdd,
//    output [2:0] InMuxAdd,
//    output [7:0] CUconst   
    ALU alu(ALUinA,ALUinB,InsSel,ALUout,CO,Z);
//    input [7:0] ALUinA,
//    input [7:0] ALUinB,
//    input [1:0] InsSel,
//    output [7:0] ALUout,
//    output CO,
//    output Z
    RB rb(InA,InB,CUconst,ALUout,InMuxAdd,WE,RegAdd,Out,ALUinA,ALUinB,OutMuxAdd,clk,reset);
//    input [7:0] InA,
//    input [7:0] InB,
//    input [7:0] CUconst,
//    input [7:0] ALUout,
//    input [2:0] InMuxAdd,
//    input WE,
//    input [3:0] RegAdd,
//    output [7:0] Out,
//    output [7:0] ALUinA,
//    output [7:0] ALUinB,
//    input [3:0] OutMuxAdd,
//    input clk,
//    input reset

    
endmodule
