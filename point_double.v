//===============================================================================
//               Scalar multiplication unit
//  ----------------------------------------------------------------------------
//  File Name            : point_double.v
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
 
module point_double(
            clk,
            rst_b,
            en,
            x0,
            y0,
            x1,
            y1,
            sign
    );
    
    input  clk;
    input  rst_b;
    input   [255:0]     x0,y0;
    output  [255:0]     x1,y1;
    reg     [255:0]     x1,y1;
    input en;
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
                         S24  = 6'b011001,
                         S25  = 6'b011010,
                         S26  = 6'b011011,
                         S27  = 6'b011100,
                         S28  = 6'b011101,
                         S29  = 6'b011110;
                         
   	//1st always block, sequential state transition
    reg    [5:0]   NS , CS;
    always @ (posedge clk or negedge rst_b)
         if (!rst_b || (en == 0))            
             CS <= IDLE;        
         else                  
             CS <= NS; 
    
    //2ed always block, sequential state transition 
    reg [255:0] v0,v1,x00,x11,tmp,tmp1;
    
    always @(*)
    if(en)
        case(CS)
            IDLE:NS = S25;
            S25:if(end1)
                    NS = S0;
                else
                    NS = S25;
            S0:if(end1)
                    NS = S1;
               else
                    NS = S0;
            S1:if(end1)
                    NS = S2;
               else
                    NS = S1;
            S2:if(v1 != 1 && v0 != 1)
                    if(v0[0] == 0)
                        NS = S2;
                    else
                        NS = S3;
                else
                    NS = S6;
                    
            S3:if(v1[0]==0)
                    NS = S3;
               else
                    NS = S4;
            S4:NS = S5;
            S5:NS = S2;
            S6:NS = S26;
            S26:if(end1)
                    NS = S27;
                else
                    NS = S26;
            S27:if(end1)
                    NS = S7;
                 else
                    NS = S27;            
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
           S11:if(end1)
                    NS = S12;
               else
                    NS = S11;
           S12:if(end1)
                    NS = S13;
               else
                    NS = S12;         
           S13: if(end1)
                    NS = S14;
                else
                    NS = S13;
           S14:if(end1)
                    NS = S15;
               else
                    NS = S14; 
           S15:NS = S16;    
           S16:NS = S17;
           S17:NS = S18;
           S18:if(end1) 
                    NS = S19;
               else
                    NS = S18;
           S19:if(end1)
                    NS = S20;
               else 
                    NS = S19;
           S20:if(end1)
                    NS = S21;
               else
                    NS = S20;
           S21:NS = S22;
           S22:NS = S23;
           S23:NS = S24;
           S24:NS = IDLE;
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
             x1  <=  0;
             y1  <=  0;  
                  
        end
        else begin
            case(CS)
                IDLE:begin
                  slc1 <= 3'b100; 
                  a1  <=  256'h2;
                  b1  <=  y0;
                end
                S25:begin
                    a1  <=  256'h2;
                    b1  <=  y0;
                    slc1<=  3'b100;                  
                    sign <= 0;
                end
                S0:begin
                    a1  <=  c1;
                    b1  <=  `Square_of_R;
                    slc1<=  3'b100;
                end
                S1:begin
                    v0  <=  c1;
                    v1  <=  `Globle_P;
                    x11 <= 1;
                    x00 <= 0;
                    slc1 <= 3'b000;                                    
                end
                S2:begin
                    if(v1!=1&&v0!=1)
                        if(v0[0]==0)
                            begin
                                v0  <=  v0 >> 1'b1;
                                if(x11[0]==0)
                                    x11 = x11>>1'b1;
                                else
                                    x11 = (x11>>1'b1) + (`Globle_P>>1'b1) + 1;
                            end
                end
                
                S3:if(v1[0]==0)begin
                        v1 <= v1>>1'b1;
                        if(x00[0] == 0)
                            x00 <= x00>>1'b1;
                        else
                             x00 <= (x00>>1'b1) + (`Globle_P>>1'b1) + 1;
                end
                S4:begin
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
                S5:begin
                    if(v0>=v1)
                        begin
                            x11 <= c2;
                            v0  <= c4;
                        end
                     else
                        begin
                            x00 <= c2;
                            v1  <= c4;
                        end
                end
                S6:begin
                    a1 <= x0;
                    b1 <= x0;
                    slc1 <= 3'b100;
                end
                S26:begin
                    a1 <= c1;
                    b1 <= `Square_of_R;
                    slc1 <= 3'b100;
                end
                
                S27:begin
                    a1 <= 256'h3;
                    b1 <= c1;
                    slc1 <= 3'b100;
                    end 
                S7:begin
                    a1 <= c1;
                    b1 <= `Square_of_R;
                    slc1<=3'b100;
                end                        
                S8:begin
                     a1 <= c1;
                     slc2 <= 3'b100;
                     if(v0==1)
                           b1 <= x11;
                     else 
                           b1 <= x00;
                end
                S9:begin
                    a1  <=   c1;
                    b1  <=   `Square_of_R;
                end
                S10:begin
                    tmp <= c1;
                    a1  <= 256'h2;
                    b1  <= x0;
                    slc1 <= 3'b100;
                end
                S11:begin
                    a1  <=  c1;
                    b1  <=  `Square_of_R;
                end
                S12:begin
                    a1  <= tmp;
                    b1  <= tmp;
                    tmp1 <= c1;
                    slc1<= 3'b100;
                end
                S13:begin
                    a1  <= c1;
                    b1  <= `Square_of_R;
                    slc1<=3'b100;
                end
                S14:begin 
                        a1 <= c1;
                end
                S15:begin                   
                    b1 <= tmp1;
                    slc1<=3'b010;
                end
                S16:begin
                    x1 <= c2;
                    a1 <= x0;
                    b1 <= c2;
                    slc1<=3'b010;
                end
                S17:begin
                    a1 <= c2;
                    slc1 <= 3'b000;
                end
                S18:begin
                    b1 <= tmp;                
                    slc1<= 3'b100;
                end
                S19:begin
                    a1 <= c1;
                    b1 <= `Square_of_R;
                end
                S20:a1 <= c1;
                S21:begin
                        b1 <= y0;
                        slc1 <= 3'b010;
                    end
               S22: y1 <= c2;
               S23: sign<= 1;
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

