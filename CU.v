`timescale 1ns / 1ps

module CU(
    input clk,
    input reset,
    input Start,
    (* DONT_TOUCH="TRUE"*) output reg Busy,
    (* DONT_TOUCH="TRUE"*) output reg [1:0] InsSel,
    input CO,
    input Z,
    (* DONT_TOUCH="TRUE"*) output reg WE,
    (* DONT_TOUCH="TRUE"*) output reg [3:0] RegAdd,
    (* DONT_TOUCH="TRUE"*) output reg [3:0] OutMuxAdd,
    (* DONT_TOUCH="TRUE"*) output reg [2:0] InMuxAdd,
    (* DONT_TOUCH="TRUE"*) output reg [7:0] CUconst
    );
    
    reg [5:0] current_state, state_next;

    localparam INIT = 5'd0,
        S1 = 5'd1,
        S2 = 5'd2,
        S3 = 5'd3,
        S4 = 5'd4,
        S5 = 5'd5,
        S6 = 5'd6,
        S7 = 5'd7,
        S8 = 5'd8,
        S9 = 5'd9,
        S10 = 5'd10,
        S11 = 5'd11,
        S12 = 5'd12,
        S13 = 5'd13,
        S14 = 5'd14,
        S15 = 5'd15,
        S16 = 5'd16,
        S17 = 5'd17,
        S18 = 5'd18,
        S19 = 5'd19,
        S20 = 5'd20,
        S21 = 5'd21,
        S22 = 5'd22,
        S23 = 5'd23,
        S24 = 5'd24;

    initial 
    begin
    current_state<=INIT;
    CUconst<=8'b1111_1111;
    end           
            
    always@(posedge clk, posedge reset)
    begin
        if(reset)
            current_state<=INIT;
        else
            current_state<=state_next;
    end 




    always@(*)
    begin
        state_next<=current_state;
        case(current_state)
            //Ilk durumumuz buras�d�r. ��lemler bittikten sonra
            //bu b�l�me gelinir.Start'�n bire e�it olmas� ile 
            //bu b�l�mden ��k�l�r.(-1) say�s� 2.rege bu k�s�mda
            //yaz�l�r
            INIT: begin
                InMuxAdd<=3'd2;
                OutMuxAdd<=4'd0;
                RegAdd<=4'd2;  
                WE<=1;
                CUconst<=8'b1111_1111; 
                Busy<=0;
                InsSel<=2'd1;
                if(Start)
                    state_next<=S1; 
                else
                    state_next<=INIT;
            end
            //Girilen A say�s� bu k�s�nda 1. rege yaz�l�r
            S1:begin
                InMuxAdd<=3'd0;
                RegAdd<=4'd1;
                WE<=1;
                Busy<=1;
                state_next<=S2;
            end
            //A'n�n kopyas� 3. rege yaz�l�r.Bu state'de A say�s�ndan
            //1 ��kart�l�r ve A'n�n bire e�it olup olmad��� belirlenir.
            //A bire e�itse birin sonucunu verecek S24'e ge�ilir. 
            S2:begin
                OutMuxAdd<=4'd1;
                InMuxAdd<=3'd4;
                RegAdd<=4'd3;
                WE<=1;
                Busy<=1;
                InsSel<=2'd2;
                if(Z==0)                                         
                      state_next<=S3;
                else
                      state_next<=S24;                       
            end
            //Bu k�mda bir kez daha birden ��karma yap�l�r.   
            S3:begin
                InMuxAdd<=3'd3;
                RegAdd<=4'd1;
                WE<=1;
                Busy<=1;
                state_next<=S4;               
            end
            //�ki defa say�m�zdan bir ��kart�ld�ktan sonra say�m�z�n 2 olup
            //olmad���na karar verilir. Say�m�z 2 ise sonuc almak i�in
            //S24'e gidilir. De�ilse i�lemler devam etmek �zere S5'e ge�ilir.       
            S4:begin
                if(Z==0)
                    state_next<=S5; 
                else                        
                    state_next<=S24;                                
            end
            //��kard���m�z de�erler saya� olarak tutulmak �zere 4. rege yaz�l�r.
            //�arpma i�lemini ALU'da taplama i�lemimiz oldu�u i�in toplama 
            //�eklinde ger�ekle�tircez
            S5:begin
                OutMuxAdd<=4'd1;
                InMuxAdd<=3'd4;
                RegAdd<=4'd4;
                WE<=1;
                Busy<=1;
                state_next<=S6;
            end
            //A say�m�z� 1. rege yazd�k
            S6:begin
                WE<=0;
                OutMuxAdd<=4'd3;                    
                InMuxAdd<=3'd4;
                RegAdd<=4'd1; 
                WE<=1;
                Busy<=1;
                state_next<=S7;
            end
            //Ayn� A say�m�z� 2. rege yazd�k ve iki adet A say�m�z�
            //toplayara (A+A) i�lemini bulduk.         
            S7:begin                    
                OutMuxAdd<=4'd3;
                InMuxAdd<=3'd4;
                RegAdd<=4'd2;
                WE<=1;
                Busy<=1;
                InsSel<=2'd2;
                state_next<=S8;
            end   
            //(A+A) i�leminin sonucunu 15. rege yazd�k.
            S8:begin                    
                InMuxAdd<=3'd3;
                RegAdd<=4'd15; 
                WE<=1;
                Busy<=1;                                                  
                state_next<=S9;
            end   
            //Sayac�m�z� kontrol etmek �zere 1. rege yazd�k.          
            S9:begin
                OutMuxAdd<=4'd4;
                InMuxAdd<=3'd4;
                RegAdd<=4'd1; 
                WE<=1;
                Busy<=1;              
                state_next<=S10;
            end 
            //Sayac�m�z� kotrol etmek i�in (-1) say�s�n� 2. rege yazd�k
            //ve sayac�m�zla toplad�k            
            S10: begin
                InMuxAdd<=3'd2;
                RegAdd<=4'd2; 
                WE<=1;
                Busy<=1;
                InsSel<=2'd2;
                state_next<=S11;
            end 
            //Sonu� s�f�r ��kt�ysa say�m�z 3't�r. Say�m�z 3 ise i�lemin
            //sonucunu almak �zere S23'e ge�tik, de�ilse i�lemleri devam
            //ettirmek �zere S12'ye ge�tik.    
            S11:begin
                if(Z==0)
                    state_next<=S12;         
                else
                    state_next<=S23;  
            end
            //Yeni sayac�m�z� 4. rege yeniden yazd�k
            S12:begin
                InMuxAdd<=3'd3;
                RegAdd<=4'd4;  
                WE<=1;
                Busy<=1;                              
                state_next<=S13;
            end
            //(A+A) say�s�n� 1.rege yazd�k
            S13:begin
                OutMuxAdd<=4'd15;
                InMuxAdd<=3'd4;
                RegAdd<=4'd1;   
                WE<=1;
                Busy<=1;    
                state_next<=S14;
            end
            //A say�s�n� 2. rege yazd�k ve (A+A) say�s�yla toplad�k.         
            S14:begin                
                OutMuxAdd<=4'd3;
                InMuxAdd<=3'd4;
                RegAdd<=4'd2; 
                WE<=1;
                Busy<=1; 
                InsSel<=2'd2;             
                state_next<=S15;
            end  
            //(A+A+A) say�s�n� 15. rege yazd�k 
            S15: begin
                InMuxAdd<=3'd3;
                RegAdd<=4'd15; 
                Busy<=1;
                WE<=1;
                InsSel<=2'd2;
                state_next<=S16;      
            end  
            //Sayac� kontrol etmek i�in 1. rege yazd�k          
            S16: begin
                OutMuxAdd<=4'd4;
                InMuxAdd<=3'd4;
                RegAdd<=4'd1; 
                WE<=1;
                Busy<=1;                                                  
                state_next<=S17;
            end 
            //Sayac� kontrol etmek i�in 2. rege (-1) yazd�k ve saya�la
            //toplad�k.  
            S17:begin      
                InMuxAdd<=3'd2;
                RegAdd<=4'd2; 
                WE<=1;
                Busy<=1;
                InsSel<=2'd2;              
                state_next<=S18;
            end   
            //Saya� kontrol i�leminin sonucu 0 ise say�m�z�n
            //4 oldu�unu bulduk ve i�lemlerini yapmak �zere
            //S19'a ge�tik. E�er say�m�z 5 ise S22'ye i�lemleri
            //yapmaya ge�tik           
            S18:begin
                if(Z==1)
                    state_next<=S19;                 
                else
                    state_next<=S22;    
            end
            //4! i�lemi i�in 4*3 i�lemini �nceki statelerde
            //yapm��t�k. bu k�s�mda buldu�umuz sonucu 2 ile �arpmak
            //kald�. Bunun i�in buldu�umuz sonucu kendisiyle toplamamak
            //�zere 1. ve 2. rege yaz�yoruz
            S19: begin
                OutMuxAdd<=4'd15;
                InMuxAdd<=3'd4;
                RegAdd<=4'd1; 
                WE<=1;
                Busy<=1;
                state_next<=S20;
            end     
            S20: begin   
                InMuxAdd<=3'd4;
                RegAdd<=4'd2; 
                WE<=1;
                Busy<=1;   
                InsSel<=2'd2; 
                state_next<=S21;
            end
            //Bu noktada 4! i�leminin t�m ad�mlar� ger�ekle�tirildi. Sonucu
            //yazmak i�in sonu� reg0 a g�nderildi ve sonras�nda initial stateimiz
            //olan INIT durumuna ge�ti.         
            S21: begin  
                InMuxAdd<=3'd3;
                RegAdd<=4'd0;
                WE<=1;
                Busy<=1;
                state_next<=INIT; 
            end
            //Bu noktada 5! i�leminin t�m ad�mlar� ger�ekle�tirildi. Sonucu
            //yazmak i�in sonu� reg0 a g�nderildi ve sonras�nda initial stateimiz
            //olan INIT durumuna ge�ti.               
            S22: begin
                CUconst <= 120;                               
                InMuxAdd<=3'd2;
                RegAdd<=4'd0; 
                WE<=1;
                Busy<=1;
                state_next<=INIT;      
            end
            //Bu noktada 3! i�leminin t�m ad�mlar� ger�ekle�tirildi. Sonucu
            //yazmak i�in sonu� reg0 a g�nderildi ve sonras�nda initial stateimiz
            //olan INIT durumuna ge�ti.                          
            S23: begin
                OutMuxAdd<=4'd15;
                InMuxAdd<=3'd4;
                RegAdd<=4'd0;                 
                WE<=1;          
                Busy<=1;                                                  
                state_next<=INIT;
            end 
            //Bu noktada 1! ve ya 2! i�leminin t�m ad�mlar� ger�ekle�tirildi. Sonucu
            //yazmak i�in sonu� reg0 a g�nderildi ve sonras�nda initial stateimiz
            //olan INIT durumuna ge�ti.                  
            S24:begin
                OutMuxAdd<=4'd3;
                InMuxAdd<=3'd4; 
                RegAdd<=4'd0;
                WE<=1;
                Busy<=1;
                state_next<=INIT;
            end    
                                                                  
        endcase
    end         
endmodule
