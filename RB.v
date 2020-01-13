`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.01.2020 15:23:38
// Design Name: 
// Module Name: RB
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


module RB(
    input [7:0] InA,
    input [7:0] InB,
    input [7:0] CUconst,
    input [7:0] ALUout,
    input [2:0] InMuxAdd,
    input WE,
    input [3:0] RegAdd,
    output [7:0] Out,
    output [7:0] ALUinA,
    output [7:0] ALUinB,
    input [3:0] OutMuxAdd,
    input clk,
    input reset
    );
    wire [7:0] RegOut;
    wire [7:0] RegIn;
    wire [15:0] En;
    wire [7:0] Rout0;
    wire [7:0] Rout1;
    wire [7:0] Rout2;
    wire [7:0] Rout3;
    wire [7:0] Rout4;
    wire [7:0] Rout5;
    wire [7:0] Rout6;
    wire [7:0] Rout7;
    wire [7:0] Rout8;
    wire [7:0] Rout9;
    wire [7:0] Rout10;
    wire [7:0] Rout11;
    wire [7:0] Rout12;
    wire [7:0] Rout13;
    wire [7:0] Rout14;
    wire [7:0] Rout15;
    MUX3 mux1(InA,InB,CUconst,ALUout,RegOut,RegOut,RegOut,RegOut,InMuxAdd,RegIn);
    Decoder decoder1(RegAdd,WE,En);
    Register Register0(RegIn,En[0],clk,reset,Rout0);
    Register Register1(RegIn,En[1],clk,reset,Rout1);
    Register Register2(RegIn,En[2],clk,reset,Rout2);
    Register Register3(RegIn,En[3],clk,reset,Rout3);
    Register Register4(RegIn,En[4],clk,reset,Rout4);
    Register Register5(RegIn,En[5],clk,reset,Rout5);
    Register Register6(RegIn,En[6],clk,reset,Rout6);
    Register Register7(RegIn,En[7],clk,reset,Rout7);
    Register Register8(RegIn,En[8],clk,reset,Rout8);
    Register Register9(RegIn,En[9],clk,reset,Rout9);
    Register Register10(RegIn,En[10],clk,reset,Rout10);
    Register Register11(RegIn,En[11],clk,reset,Rout11);
    Register Register12(RegIn,En[12],clk,reset,Rout12);
    Register Register13(RegIn,En[13],clk,reset,Rout13);
    Register Register14(RegIn,En[14],clk,reset,Rout14);
    Register Register15(RegIn,En[15],clk,reset,Rout15);
    MUX4 mux2(Rout0,Rout1,Rout2,Rout3,Rout4,Rout5,Rout6,Rout7,Rout8,Rout9,Rout10,Rout11,Rout12,Rout13,Rout14,Rout15,OutMuxAdd,RegOut);
    
    assign Out = Rout0;
    assign ALUinA = Rout1;
    assign ALUinB = Rout2;
endmodule




module MUX3(
    input [7:0] i0,
    input [7:0] i1,
    input [7:0] i2,
    input [7:0] i3,
    input [7:0] i4,
    input [7:0] i5,
    input [7:0] i6,
    input [7:0] i7,
    input [2:0] s,
    output reg [7:0] r
    );
    
    always @(*)
    begin
        if(s == 3'b000)
        begin
            r <= i0;
        end
        else if(s == 3'b001)
        begin
            r <= i1;
        end
        else if(s == 3'b010)
        begin
            r <= i2;
        end
        else if(s == 3'b011)
        begin
            r <= i3;
        end 
        else if(s == 3'b100)
        begin
            r <= i4;
        end
        else if(s == 3'b101)
        begin
            r <= i5;
        end
        else if(s == 3'b110)
        begin
            r <= i6;
        end
        else if(s == 3'b111)
        begin
            r <= i7;
        end                 
    end
endmodule






module MUX4(
    input [7:0] i0,
    input [7:0] i1,
    input [7:0] i2,
    input [7:0] i3,
    input [7:0] i4,
    input [7:0] i5,
    input [7:0] i6,
    input [7:0] i7,
    input [7:0] i8,
    input [7:0] i9,
    input [7:0] i10,
    input [7:0] i11,
    input [7:0] i12,
    input [7:0] i13,
    input [7:0] i14,
    input [7:0] i15,
    input [3:0] s,
    output reg [7:0] r
    );
    
    always @(*)
    begin
        if(s == 4'b0000)
        begin
            r <= i0;
        end
        else if(s == 4'b0001)
        begin
            r <= i1;
        end
        else if(s == 4'b0010)
        begin
            r <= i2;
        end
        else if(s == 4'b0011)
        begin
            r <= i3;
        end 
        else if(s == 4'b0100)
        begin
            r <= i4;
        end
        else if(s == 4'b0101)
        begin
            r <= i5;
        end
        else if(s == 4'b0110)
        begin
            r <= i6;
        end
        else if(s == 4'b0111)
        begin
            r <= i7;
        end 
        else if(s == 4'b1000)
        begin
            r <= i8;
        end
        else if(s == 4'b1001)
        begin
            r <= i9;
        end
        else if(s == 4'b1010)
        begin
            r <= i10;
        end
        else if(s == 4'b1011)
        begin
            r <= i11;
        end 
        else if(s == 4'b1100)
        begin
            r <= i12;
        end
        else if(s == 4'b1101)
        begin
            r <= i13;
        end
        else if(s == 4'b1110)
        begin
            r <= i14;
        end
        else if(s == 4'b1111)
        begin
            r <= i15;
        end                 
    end
endmodule






module Decoder(
    input [3:0] i,
    input WE,
    output reg [15:0] o
    );
    
    always @(*)
    begin
        if (WE ==0)
        begin
            o <= 16'b0;
        end 
        else if (WE==1)
        begin
            if(i == 4'b0000)
            begin
                o <= 16'b0000000000000001;
            end
            else if(i == 4'b0001)
            begin
                o <= 16'b0000000000000010;
            end
            else if(i == 4'b0010)
            begin
                o <= 16'b0000000000000100;
            end
            else if(i == 4'b0011)
            begin
                o <= 16'b0000000000001000;
            end
            else if(i == 4'b0100)
            begin
                o <= 16'b0000000000010000;
            end
            else if(i == 4'b0101)
            begin
                o <= 16'b0000000000100000;
            end
            else if(i == 4'b0110)
            begin
                o <= 16'b0000000001000000;
            end
            else if(i == 4'b0111)
            begin
                o <= 16'b0000000010000000;
            end
            else if(i == 4'b1000)
            begin
                o <= 16'b0000000100000000;
            end
            else if(i == 4'b1001)
            begin
                o <= 16'b0000001000000000;
            end
            else if(i == 4'b1010)
            begin
                o <= 16'b0000010000000000;
            end 
            else if(i == 4'b1011)
            begin
                o <= 16'b0000100000000000;
            end
            else if(i == 4'b1100)
            begin
                o <= 16'b0001000000000000;
            end
            else if(i == 4'b1101)
            begin
                o <= 16'b0010000000000000;
            end
            else if(i == 4'b1110)
            begin
                o <= 16'b0100000000000000;
            end
            else if(i == 4'b1111)
            begin
                o <= 16'b1000000000000000;
            end                                             
        end
    end
endmodule



module Register(
    input [7:0] Rin,
    input En,
    input clk,
    input reset,
    output [7:0] Rout
    );
    reg [7:0] temp;
    always @(posedge clk or posedge reset)
    begin
        if(reset)
        begin
            temp <= 8'b0;
        end
        else if(En)
        begin
            temp <= Rin;            
        end
    end
    
    assign Rout = temp;

endmodule
