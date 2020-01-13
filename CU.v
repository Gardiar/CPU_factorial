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
            //Ilk durumumuz burasýdýr. Ýþlemler bittikten sonra
            //bu bölüme gelinir.Start'ýn bire eþit olmasý ile 
            //bu bölümden çýkýlýr.(-1) sayýsý 2.rege bu kýsýmda
            //yazýlýr
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
            //Girilen A sayýsý bu kýsýnda 1. rege yazýlýr
            S1:begin
                InMuxAdd<=3'd0;
                RegAdd<=4'd1;
                WE<=1;
                Busy<=1;
                state_next<=S2;
            end
            //A'nýn kopyasý 3. rege yazýlýr.Bu state'de A sayýsýndan
            //1 çýkartýlýr ve A'nýn bire eþit olup olmadýðý belirlenir.
            //A bire eþitse birin sonucunu verecek S24'e geçilir. 
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
            //Bu kýmda bir kez daha birden çýkarma yapýlýr.   
            S3:begin
                InMuxAdd<=3'd3;
                RegAdd<=4'd1;
                WE<=1;
                Busy<=1;
                state_next<=S4;               
            end
            //Ýki defa sayýmýzdan bir çýkartýldýktan sonra sayýmýzýn 2 olup
            //olmadýðýna karar verilir. Sayýmýz 2 ise sonuc almak için
            //S24'e gidilir. Deðilse iþlemler devam etmek üzere S5'e geçilir.       
            S4:begin
                if(Z==0)
                    state_next<=S5; 
                else                        
                    state_next<=S24;                                
            end
            //Çýkardýðýmýz deðerler sayaç olarak tutulmak üzere 4. rege yazýlýr.
            //Çarpma iþlemini ALU'da taplama iþlemimiz olduðu için toplama 
            //þeklinde gerçekleþtircez
            S5:begin
                OutMuxAdd<=4'd1;
                InMuxAdd<=3'd4;
                RegAdd<=4'd4;
                WE<=1;
                Busy<=1;
                state_next<=S6;
            end
            //A sayýmýzý 1. rege yazdýk
            S6:begin
                WE<=0;
                OutMuxAdd<=4'd3;                    
                InMuxAdd<=3'd4;
                RegAdd<=4'd1; 
                WE<=1;
                Busy<=1;
                state_next<=S7;
            end
            //Ayný A sayýmýzý 2. rege yazdýk ve iki adet A sayýmýzý
            //toplayara (A+A) iþlemini bulduk.         
            S7:begin                    
                OutMuxAdd<=4'd3;
                InMuxAdd<=3'd4;
                RegAdd<=4'd2;
                WE<=1;
                Busy<=1;
                InsSel<=2'd2;
                state_next<=S8;
            end   
            //(A+A) iþleminin sonucunu 15. rege yazdýk.
            S8:begin                    
                InMuxAdd<=3'd3;
                RegAdd<=4'd15; 
                WE<=1;
                Busy<=1;                                                  
                state_next<=S9;
            end   
            //Sayacýmýzý kontrol etmek üzere 1. rege yazdýk.          
            S9:begin
                OutMuxAdd<=4'd4;
                InMuxAdd<=3'd4;
                RegAdd<=4'd1; 
                WE<=1;
                Busy<=1;              
                state_next<=S10;
            end 
            //Sayacýmýzý kotrol etmek için (-1) sayýsýný 2. rege yazdýk
            //ve sayacýmýzla topladýk            
            S10: begin
                InMuxAdd<=3'd2;
                RegAdd<=4'd2; 
                WE<=1;
                Busy<=1;
                InsSel<=2'd2;
                state_next<=S11;
            end 
            //Sonuç sýfýr çýktýysa sayýmýz 3'tür. Sayýmýz 3 ise iþlemin
            //sonucunu almak üzere S23'e geçtik, deðilse iþlemleri devam
            //ettirmek üzere S12'ye geçtik.    
            S11:begin
                if(Z==0)
                    state_next<=S12;         
                else
                    state_next<=S23;  
            end
            //Yeni sayacýmýzý 4. rege yeniden yazdýk
            S12:begin
                InMuxAdd<=3'd3;
                RegAdd<=4'd4;  
                WE<=1;
                Busy<=1;                              
                state_next<=S13;
            end
            //(A+A) sayýsýný 1.rege yazdýk
            S13:begin
                OutMuxAdd<=4'd15;
                InMuxAdd<=3'd4;
                RegAdd<=4'd1;   
                WE<=1;
                Busy<=1;    
                state_next<=S14;
            end
            //A sayýsýný 2. rege yazdýk ve (A+A) sayýsýyla topladýk.         
            S14:begin                
                OutMuxAdd<=4'd3;
                InMuxAdd<=3'd4;
                RegAdd<=4'd2; 
                WE<=1;
                Busy<=1; 
                InsSel<=2'd2;             
                state_next<=S15;
            end  
            //(A+A+A) sayýsýný 15. rege yazdýk 
            S15: begin
                InMuxAdd<=3'd3;
                RegAdd<=4'd15; 
                Busy<=1;
                WE<=1;
                InsSel<=2'd2;
                state_next<=S16;      
            end  
            //Sayacý kontrol etmek için 1. rege yazdýk          
            S16: begin
                OutMuxAdd<=4'd4;
                InMuxAdd<=3'd4;
                RegAdd<=4'd1; 
                WE<=1;
                Busy<=1;                                                  
                state_next<=S17;
            end 
            //Sayacý kontrol etmek için 2. rege (-1) yazdýk ve sayaçla
            //topladýk.  
            S17:begin      
                InMuxAdd<=3'd2;
                RegAdd<=4'd2; 
                WE<=1;
                Busy<=1;
                InsSel<=2'd2;              
                state_next<=S18;
            end   
            //Sayaç kontrol iþleminin sonucu 0 ise sayýmýzýn
            //4 olduðunu bulduk ve iþlemlerini yapmak üzere
            //S19'a geçtik. Eðer sayýmýz 5 ise S22'ye iþlemleri
            //yapmaya geçtik           
            S18:begin
                if(Z==1)
                    state_next<=S19;                 
                else
                    state_next<=S22;    
            end
            //4! iþlemi için 4*3 iþlemini önceki statelerde
            //yapmýþtýk. bu kýsýmda bulduðumuz sonucu 2 ile çarpmak
            //kaldý. Bunun için bulduðumuz sonucu kendisiyle toplamamak
            //üzere 1. ve 2. rege yazýyoruz
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
            //Bu noktada 4! iþleminin tüm adýmlarý gerçekleþtirildi. Sonucu
            //yazmak için sonuç reg0 a gönderildi ve sonrasýnda initial stateimiz
            //olan INIT durumuna geçti.         
            S21: begin  
                InMuxAdd<=3'd3;
                RegAdd<=4'd0;
                WE<=1;
                Busy<=1;
                state_next<=INIT; 
            end
            //Bu noktada 5! iþleminin tüm adýmlarý gerçekleþtirildi. Sonucu
            //yazmak için sonuç reg0 a gönderildi ve sonrasýnda initial stateimiz
            //olan INIT durumuna geçti.               
            S22: begin
                CUconst <= 120;                               
                InMuxAdd<=3'd2;
                RegAdd<=4'd0; 
                WE<=1;
                Busy<=1;
                state_next<=INIT;      
            end
            //Bu noktada 3! iþleminin tüm adýmlarý gerçekleþtirildi. Sonucu
            //yazmak için sonuç reg0 a gönderildi ve sonrasýnda initial stateimiz
            //olan INIT durumuna geçti.                          
            S23: begin
                OutMuxAdd<=4'd15;
                InMuxAdd<=3'd4;
                RegAdd<=4'd0;                 
                WE<=1;          
                Busy<=1;                                                  
                state_next<=INIT;
            end 
            //Bu noktada 1! ve ya 2! iþleminin tüm adýmlarý gerçekleþtirildi. Sonucu
            //yazmak için sonuç reg0 a gönderildi ve sonrasýnda initial stateimiz
            //olan INIT durumuna geçti.                  
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
