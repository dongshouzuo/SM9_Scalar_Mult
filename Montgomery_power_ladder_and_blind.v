//===============================================================================
//               Scalar multiplication unit
//  ----------------------------------------------------------------------------
//  File Name            : Montgomery_power_ladder_and_blind.v
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

module mult(
        clk,
        rst_b,
        en,
        l,
        x0,
        y0,
        x1,
        y1,
        sign
    );
    
    input   clk;
    input   rst_b;
    input   en;
    input   [255:0]     l,x0,y0;
    
    output  [255:0]     x1,y1;
    reg     [255:0]     x1,y1;
    
    output  sign;
    reg     sign;
	
	reg     endou ,enadd;
    reg   [255:0]  doux0,douy0,addx0,addy0,addx1,addy1,tmpx,tmpy;
    wire  [255:0]  doux1,douy1,addx2,addy2;
    wire    douend,addend;
	
	reg     [7:0]   count;
	
	reg 	[255:0]  t0x,t0y,t1x,t1y;
	
	parameter	[5:0]	IDLE = 6'b000000,
						S0   = 6'b000001,
						S1   = 6'b000011,
						S2   = 6'b000010,
						S3   = 6'b000110,
						S4   = 6'b000111,
						S5   = 6'b000101,
						S6   = 6'b000100,
						S7   = 6'b001100,
						S8   = 6'b001101,
						S9   = 6'b001111,
						S10  = 6'b001110,
						S11  = 6'b001010,
						S12  = 6'b001011,
						S13  = 6'b001001,
						S14  = 6'b001000,
						S15  = 6'b011000,
						S16  = 6'b011001,
						S17  = 6'b011011,
						S18  = 6'b011010,
						S19  = 6'b011110,
						S20  = 6'b011111,
						S21  = 6'b011101,
						S22  = 6'b011100,
						S23  = 6'b010100,
						S24  = 6'b010101,
						S25  = 6'b010111,
						S26  = 6'b010110,
						S27  = 6'b010010,
						S28  = 6'b010011,
						S29  = 6'b010001,
						S30  = 6'b010000,
						S31  = 6'b110000,
						S32  = 6'b110001,
						S33  = 6'b110011,
						S34  = 6'b110010,
						S35  = 6'b110110,
						S36  = 6'b110111,
						S37  = 6'b110101,
						S38  = 6'b110100,
						S39  = 6'b111100,
						S40  = 6'b111101,
						S41  = 6'b111111,
						S42  = 6'b111110,
						S43  = 6'b111010,
						S44  = 6'b111011,
						S45  = 6'b111001,
						S46  = 6'b111000,
						S47  = 6'b101000,
						S48  = 6'b101001,
						S49  = 6'b101011,
						S50  = 6'b101010,
						S51  = 6'b101110,
						S52  = 6'b101111,
						S53  = 6'b101101,
						S54  = 6'b101100;
						
	//1st always block, sequential state transition
	reg		[5:0]		NS, CS;
	always	@	(posedge clk or negedge rst_b)
		if(!rst_b)
			CS <= IDLE;
		else
			CS <= NS;
	
	
	//2ed always block, sequential state transition
	always	@	(*)
		case(CS)
			IDLE:begin
					if(en)
						NS = S10;
					else
						NS = IDLE;
			end
			S10:if(addend==1)
			         NS = S11;
			    else
			         NS = S10;
			S11:
			        NS = S0;
			   
			S0:NS = S1;
			S1:if(douend==1)
					NS = S2;
			   else
					NS = S1;
			S2:if(l[count]==0)
					NS = S2;
			   else
					NS = S3;
			S3:NS = S4;
			S4:if(addend == 1)
					NS = S5;
				else
					NS = S4;
			S5:NS = S6;
			S6:if(douend == 1)
					NS = S7;
				else
					NS = S6;
			S7:begin
				NS = S8;
			end
			S8:begin
				if(count == 0)
					NS = S9;
				else
					NS = S3;
			end
			S9:if(addend==1)
					NS = S12;
				else
				    NS = S9;
			S12:
					NS = S13;

			S13:NS = IDLE;
			
		endcase
		
	//3rd always block, sequential state transition 
	always	@	(posedge clk or negedge rst_b)
		if(!rst_b)
			begin
				doux0 <= 0;
                douy0 <= 0;
                addx0 <= x0;
                addy0 <= y0;
                tmpx  <= 0;
                tmpy  <= 0;
                addx1 <= 0;
                addy1 <= 0;
                sign  <= 0;
                x1    <= 0;
                y1    <= 0;
                endou <= 0;
                enadd <= 0;
				count <= 8'hffffffff;
			end
		else
			begin
				case(CS)
					IDLE:begin
					end
					S10:begin
					    addx0 <= x0;
                        addy0 <= y0;
                        addx1 <= 256'h93DE051D62BF718FF5ED0704487D01D6E1E4086909DC3280E8C4E4817C66DDDD;
                        addy1 <= 256'h21FE8DDA4F21E607631065125C395BBC1C1C00CBFA6024350C464CD70A3EA616;
                        enadd <= 1;
					end
					S11:begin
					    tmpx	<=	addx2;
                        tmpy    <=  addy2;
					end
					S0:begin
					    enadd <= 0;
						t0x	<=	tmpx;
						t0y	<=	tmpy;
						doux0	<=	tmpx;
						douy0	<=	tmpy;
						endou	<=	1;
					end
					S1:begin
						t1x	<=	doux1;
						t1y <=	douy1;
					end
					S2:begin
						endou <= 0;
						if(l[count]==0)
							begin
								count <= count - 1'b1;
							end
					end
					S3:count <= count - 1'b1;
					S4:begin
						addx0 <= t0x;
						addy0 <= t0y;
						addx1 <= t1x;
						addy1 <= t1y;
						enadd <= 1;
					end
					S5:begin
						if(l[count]==1)
							begin
								t0x <= addx2;
								t0y <= addy2;
							end
						else
							begin
								t1x <= addx2;
								t1y <= addy2;
							end
						enadd <= 0;
					end
					S6:begin
						if(l[count]==1)
							begin
								doux0 <= t1x;
								douy0 <= t1y;
							end
						else
							begin
								doux0 <= t0x;
								douy0 <= t0y;
							end
						endou <= 1;
					end
					S7:begin
						if(l[count]==1)
							begin
								t1x <= doux1;
								t1y <= douy1;
							end
						else
							begin
								t0x <= doux1;
								t0y <= douy1;
							end
						endou <= 0;
					end
					S9:begin
						addx0 <= t0x;
						addy0 <= t0y;
						addx1 <= 256'h21be51efa46944c98f1e1fbffa4422f6f1bf30765d184784f095d4b3d108bd99;
						addy1 <= 256'h7365df9724961748a96aedb561683bab150aedfc15b76878db2a7f89ab201c60;
						enadd <= 1;
					end
					S12:begin
						x1 <= addx2;
						y1 <= addy2;
					end
					S13:begin
					   sign<=1;
					end
				endcase
			end
	point_double d(.clk(clk),.rst_b(rst_b),.en(endou),.x0(doux0),.y0(douy0),.x1(doux1),.y1(douy1),.sign(douend));
    point_add    a(.clk(clk),.rst_b(rst_b),.en(enadd),.x0(addx0),.y0(addy0),.x1(addx1),.y1(addy1),.x2(addx2),.y2(addy2),.sign(addend));
endmodule
