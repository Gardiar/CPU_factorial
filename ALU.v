`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.01.2020 12:17:51
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [7:0] ALUinA,
    input [7:0] ALUinB,
    input [1:0] InsSel,
    output [7:0] ALUout,
    output CO,
    output Z
    );
    wire [7:0] w1,w2,w3,w4;
    wire addcout;
    wire shiftr0;
    wire [7:0] out;
    //wire co;
    AND gate1(ALUinA,ALUinB,w1);
    XOR gate2(ALUinA,ALUinB,w2);
    ADD gate3(ALUinA,ALUinB,addcout,w3);
    Circular_Left_Shift gate4(ALUinA,shiftr0,w4);
    MUX2 mux1(w1,w2,w3,w4,InsSel,ALUout);
    MUX2 mux2(8'd0,8'd0,addcout,shiftr0,InsSel,CO);
    Zero_Comparator gate5(ALUout,Z);

endmodule





module AND(
    input [7:0] a,
    input [7:0] b,  
    output [7:0] r   
    );
    assign r = a & b;
endmodule



module XOR(
    input [7:0] a,
    input [7:0] b,  
    output [7:0] r   
    );
    assign r = a ^ b;   
endmodule




module ADD(
    input [7:0] a,
    input [7:0] b,
    output cout,  
    output [7:0] r
    );
    wire [8:0]tmp;
    assign tmp = a + b;  
    assign r = tmp [7:0];  
    assign cout  = tmp [8];
endmodule





module Circular_Left_Shift(
    input [7:0] a, 
    output r0,
    output [7:0] r
    );
    assign r = {a[6:0], a[7]};
    assign r0 = r[0];
endmodule




module Zero_Comparator(
    input [7:0] a,
    output reg z   
    );
    always @(*)
    begin
        if(a == 0)
        begin
            z <= 1'b1;
        end
        else
        begin
            z <= 1'b0;
        end 
    end
endmodule



module MUX2(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    input [1:0] s,
    output reg [7:0] r
    );
    
    always @(*)
    begin
        if(s == 2'b00)
        begin
            r <= a;
        end
        else if(s == 2'b01)
        begin
            r <= b;
        end
        else if(s == 2'b10)
        begin
            r <= c;
        end
        else if(s == 2'b11)
        begin
            r <= d;
        end                 
    end
endmodule




