//===============================================================================
//               Scalar multiplication unit
//  ----------------------------------------------------------------------------
//  File Name            : point_add.v
//  File Revision        : 2.0
//  Author               : Yunpeng Ji
//  Email                : ypji@tju.edu.cn
//  History:            
//                              2020.01.02        Rev2.0  Yunpeng Ji
//  ----------------------------------------------------------------------------
//  Description      : This unit supports the computation of the scalar multiplication.					   				   
//  ----------------------------------------------------------------------------
// Copyright (c) 2020,Tianjin University.
//               No.135 Yaguan Road , Jinnan District, Tianjin, 300350, China
// Tianjin University Confidential Proprietary
//===============================================================================
`timescale 1ns / 1ps
`define    Square_of_R        256'h2EA795A656F62FBDE479B522D6706E7B88F8105FAE1A5D3F27DEA312B417E2D2
`define    Globle_P           256'hB640000002A3A6F1D603AB4FF58EC74521F2934B1A7AEEDBE56F9B27E351457D
 
module point_add(
            clk,
            rst_b,
            en,
            x0,
            y0,
            x1,
            y1,
            x2,
            y2,
            sign
    );
    
    input  clk;
    input  rst_b;
    input  en;
    input   [255:0]     x0,y0;
    input  [255:0]     x1,y1;
    output     [255:0]     x2,y2;
    reg    [255:0]      x2,y2;
    output  sign;
    reg     sign;
    
    reg    [255:0]     a1,b1,a2,b2;
    wire   [255:0]      c1,c2,c3,c4;
    wire    end1,end2;
    reg     [2:0]   slc1,slc2;
    
    parameter   [5:0]   IDLE = 6'b000000,
                         S0   = 6'b000001,
                         S1   = 6'b000010,
                         S2   = 6'b000011,
                         S3   = 6'b000100,
                         S4   = 6'b000101,
                         S5   = 6'b000110,
                         S6   = 6'b000111,
                         S7   = 6'b001000,
                         S8   = 6'b001001,
                         S9   = 6'b001010,
                         S10  = 6'b001011,
                         S11  = 6'b001100,
                         S12  = 6'b001101,
                         S13  = 6'b001110,
                         S14  = 6'b001111,
                         S15  = 6'b010000,
                         S16  = 6'b010001,
                         S17  = 6'b010010,
                         S18  = 6'b010011,
                         S19  = 6'b010100,
                         S20  = 6'b010101,
                         S21  = 6'b010110,
                         S22  = 6'b010111,
                         S23  = 6'b011000,
                         S24  = 6'b011001;
                         
   	//1st always block, sequential state transition
    reg    [5:0]   NS , CS;
    always @ (posedge clk or negedge rst_b)
         if (!rst_b || (en==0))            
             CS <= IDLE;        
         else                  
             CS <= NS; 
    
    //2ed always block, sequential state transition 
    reg [255:0] v0,v1,x00,x11,tmp,tmp1;
    
    always @(*)
    if(en)
        case(CS)
            IDLE:NS = S19;
            S19:if(end1)
                    NS = S0;
                else
                    NS = S19;
            S0:NS = S1;
            S1:if(v1!=1 && v0!=1)   
                    if(v0[0]==0)
                        NS = S1;
                    else
                        NS = S2;
                else
                    NS = S5;
            S2:if(v1[0]==0)
                    NS = S2;
               else 
                    NS = S3;
           S3:NS = S4;
           S4:NS = S1; 
           S5:NS = S6;
           S6:NS = S7;
           S7:if(end1)
                NS = S8;
              else
                NS = S7;
           S8:if(end1)
                NS = S9;
              else 
                NS = S8;
           S9:if(end1)
                NS = S10;
              else
                NS = S9;
           S10:if(end1)
                NS = S11;
               else
                NS = S10;
           S11:NS = S12;
           S12:NS = S13;
           S13:NS = S14;
           S14:if(end1)
                    NS = S15;
               else
                    NS = S14;
           S15:if(end1)
                    NS = S16;
               else
                    NS = S15;
           S16:if(end1)
                    NS = S17;
               else
                    NS = S16;
           S17:NS = S18;
           S18:NS = IDLE;
        endcase
    
     
    //3rd always block, sequential state transition               
    always @ (posedge clk or negedge rst_b)  
        if(!rst_b)begin
             a1  <=  0;
             b1  <=  0;
             a2  <=  0;
             b2  <=  0;
             slc1<=  0;
             slc2<=  0;
             sign<=  0; 
             x2 <= 0;
             y2 <= 0;    
        end
        else begin
            case(CS)
                IDLE:slc1 <= 3'b100;
                S19:begin
                      a1  <=  x1;
                      b1  <=  x0;
                      sign <= 0;
                      slc1 <= 3'b010;                   
                end
                S0:begin
                    v0 <= c2;
                    v1 <= `Globle_P;
                    x11 <= 1;
                    x00 <= 0;
                end
                S1: begin
                    if(v1!=1&&v0!=1)
                        if(v0[0]==0)begin
                            v0 <= v0>>1'b1;
                            if(x11[0]==0)
                                x11 = x11>>1'b1;
                            else
                                x11 = (x11>>1'b1) + (`Globle_P>>1'b1) + 1;
                        end
                    end
                S2:if(v1[0]==0)begin
                        v1 <= v1>>1'b1;
                        if(x00[0] == 0)
                            x00 <= x00>>1'b1;
                        else
                            x00 <= (x00>>1'b1) + (`Globle_P>>1'b1) + 1;
                end
                S3:begin
                    if(v0>=v1)
                    begin
                        a1 <= x11;
                        b1 <= x00;
                        a2 <= v0;
                        b2 <= v1;
                    end
                    else
                    begin
                        a1 <= x00;
                        b1 <= x11;
                        a2 <= v1;
                        b2 <= v0;
                    end
                    slc1 <= 3'b010;
                    slc2 <= 3'b010;
                end
                S4:begin
                    if(v0 >= v1)
                        begin
                            x11 <= c2;
                            v0 <= c4;
                        end
                    else
                        begin
                            x00 <= c2;
                            v1 <= c4;
                        end
                end
                S5:begin
                    a1 <= y1;
                    b1 <= y0;
                    slc1 <= 3'b010;
                end
                S6:begin
                        if(v0 ==1)
                            a1 <= x11;
                        else     
                            a1 <= x00;
                        b1 <= c2;
                        slc1 <= 3'b100;
                   end
                S7:begin
                    a1 <= c1;
                    b1 <= `Square_of_R;
                    slc1<= 3'b100;
                end
                S8:begin
                    a1 <= c1;
                    b1 <= c1;
                    tmp <= c1;
                    slc1<=3'b100;
                end
                S9:begin
                    a1<= c1;
                    b1<=`Square_of_R;
                    slc1<=3'b100;
                end
                S10:begin
                        a1 <= c1;
                        b1 <= x0;
                        slc1 <= 3'b010;
                end
                S11:begin
                        a1 <= c2;
                        b1 <= x1;
                        slc1 <= 3'b010;
                end
                S12:begin
                        x2 <= c2;
                        a1 <= x0;
                        b1 <= c2;
                        slc1<=3'b010;
                    end
                S13: a1 <= c2;
                S14:begin
                     b1 <= tmp;
                     slc1<= 3'b100;
                end
                S15:begin
                     a1 <= c1;
                     b1 <= `Square_of_R;
                     slc1<=3'b100;
                end
                S16:begin
                    a1 <= c1;
                    b1 <= y0;
                    slc1<=3'b010;
                end
                S17:y2 <= c2;
                S18:sign <= 1;

                default:begin
                    a1  <=  a1;
                    b1  <=  b1;
                    a2  <=  a2;
                    b2  <=  b2;
                    slc1<=  slc1;
                    slc2<=  slc2;
                end
            endcase
        end
    
                                   
    fp_core  u1(.clk(clk),.rst_b(rst_b),.select(slc1),.data_ina(a1),.data_inb(b1),.data_mm(c1),.end_mm(end1),.data_as(c2));
    fp_core  u2(.clk(clk),.rst_b(rst_b),.select(slc2),.data_ina(a2),.data_inb(b2),.data_mm(c3),.end_mm(end2),.data_as(c4));
endmodule
