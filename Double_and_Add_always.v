//===============================================================================
//               Scalar multiplication unit
//  ----------------------------------------------------------------------------
//  File Name            : scalar.v
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
 
module scalar(
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
	
	input	clk;
	input	rst_b;
	input	en;
	input	[255:0]		l;
	input	[255:0]		x0,y0;
	
	output	[255:0]		x1,y1;
	reg		[255:0]		x1,y1;
	output	sign;
	reg		sign;
	
	reg		[255:0]		a1,b1;
	wire	[255:0]		c1,c2;
	wire	end1;
	reg		[2:0]		slc;
	
	reg		[255:0]		tmpx,tmpy;
	reg		[255:0]		v0,v1,x00,x11;
	reg		[7:0]		count;
	
	reg		[255:0]		x,y;//record point double value
	//Gray-code 
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
			
	//2nd always block, sequential state transition 
	always	@	(*)
		case(CS)
			IDLE:begin
					if(en)
						NS = S0;
					else	
						NS = IDLE;
			end
			S0:begin
					if(l[count]==0)
						NS = S0;
					else	
						NS = S1;
			end
			S50:if(count == 0)
			         NS = S48;
			    else
			         NS = S1;
			S1:if(end1)
					NS = S2;
				else
					NS = S1;
			S2:if(end1)
						NS = S3;
					else
						NS = S2;
			S3:if(end1)
						NS = S4;
					else
						NS = S3;
			S4:if(v1 != 1 && v0 != 1)
						if(v0[0] == 0)
							NS = S4;
						else
							NS = S5;
					else
						NS = S9;
			S5:if(v1[0]==0)
						NS = S5;
					else
						NS = S6;
			S6:NS = S7;
			S7:NS = S8;
			S8:NS = S4;
			S9:NS = S10;
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
			S13:if(end1)
					NS = S14;
				else
					NS = S13;
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
			S17:if(end1)
					NS = S18;
				else
					NS = S17;
			S18:if(end1)
					NS = S19;
				else
					NS = S18;
			S19:if(end1)
					NS = S20;
				else
					NS = S19;			
			S20:NS = S21;
			S21:NS = S22;
			S22:NS = S23;
			S23:if(end1)
					NS = S24;
				else
					NS = S23;
			S24:if(end1)
					NS = S25;
				else
					NS = S24;
			S25:if(end1)
					NS = S26;
				else
					NS = S25;
			S26:NS = S27;
//			S27:if(l[count]==1) 		//0 1 judge
//					NS = S28;
//				else
//					NS = S50;
			S27:NS = S28;				
			
			S28:NS = S29;
			S29:NS = S30;
			S30:if(v1!=1 && v0!=1)   
                    if(v0[0]==0)
                        NS = S30;
                    else
                        NS = S31;
                else
                    NS = S35;
			S31:if(v1[0]==0)
					NS = S31;
				else
					NS = S32;
			S32:NS = S33;
			S33:NS = S34;
			S34:NS = S30;
			S35:NS = S36;
			S36:NS = S37;
			S37:if(end1)
					NS = S38;
				else
					NS = S37;
			S38:if(end1)
					NS = S39;
				else
					NS = S38;
			S39:if(end1)
					NS = S40;
				else
					NS = S39;
			S40:if(end1)
					NS = S41;
				else
					NS = S40;
			S41:NS = S42;
			S42:NS = S43;
			S43:NS = S44;
			S44:if(end1)
					NS = S45;
				else
					NS = S44;
			S45:if(end1)
					NS = S46;
				else
					NS = S45;
			S46:if(end1)
					NS = S47;
				else
					NS = S46;
			S47:NS = S50;
			S48:NS = S49;
			S49:NS = IDLE;
			default:NS = IDLE;
		endcase
	//3rd always block, sequential state transition
	always	@	(posedge clk or negedge rst_b)
		if(!rst_b)
			begin
				a1 		<=		0;
				b1		<=		0;
				slc		<=		3'b100;
				sign 	<=		0;
				x1		<=		0;
				y1		<=		0;
				count	<= 		8'b11111111;
				tmpx	<= 		x0;
				tmpy	<=		y0;
				v0		<=		0;
				v1		<=		0;
				x00		<=		0;
				x11		<=		0;
			end
		else	
			case(CS)
				IDLE:begin
						
				end
				S0:begin	
						count <= count - 1'b1;
				end
				S50:begin
						count	<= 	count - 1'b1;
						if(l[count]==0)
							begin
								tmpx <= x;
								tmpy <= y;
							end
						else
							begin
								tmpx <= tmpx;
								tmpy <= tmpy;
							end
				end
				S1:begin
						a1	<=	256'h2;
						b1	<=	tmpy;
						slc <=	3'b100;
				end
				S2:begin
						a1  <=	c1;
						b1	<=	`Square_of_R;
						slc	<=	3'b100;
				end
				S3:begin
						v0	<=	c1;
						v1	<=	`Globle_P;
						x11 <=	1;
						x00 <=  0;
						slc <=	3'b000;
				end
				S4:begin
						if(v1 !=1 && v0 != 1)
							if(v0[0] == 0)
								begin
									v0  <=  v0 >> 1'b1;
									if(x11[0]==0)
										x11 <= x11>>1'b1;
									else
										x11 <= (x11>>1'b1) + (`Globle_P>>1'b1) + 1;
								end
				end
				S5:if(v1[0]==0)
						begin
							v1 <= v1>>1'b1;
							if(x00[0] == 0)
								x00 <= x00>>1'b1;
							else
								x00 <= (x00>>1'b1) + (`Globle_P>>1'b1) + 1;
						end
				S6:begin
						if(v0>=v1)
							begin
								a1 <= x11;
								b1 <= x00;
							end
						else
							begin
								a1 <= x00;
								b1 <= x11;
							end;
						slc	<=	3'b010;
				end
				S7:begin
						if(v0 >= v1)
							begin
								a1 <= v0;
								b1 <= v1;
								x11 <= c2;
							end
						else
							begin
								a1 <= v1;
								b1 <= v0;
								x00 <= c2;
							end
						slc <=	3'b010;
				end
				S8:begin
						if(v0>=v1)
							begin
								v0  <= c2;
							end
						else
							begin
								v1  <= c2;
							end
				end
				S9:begin
						a1	<=	tmpx;
						b1	<=	tmpx;
						slc	<=	3'b100;
				end
				S10:begin
						a1	<=	c1;
						b1	<=	`Square_of_R;
						slc	<=	3'b100;
				end
				S11:begin
						a1	<=	256'h3;
						b1	<=	c1;
						slc	<=	3'b100;
				end
				S12:begin
						a1	<=	c1;
						b1	<=	`Square_of_R;
						slc	<=	3'b100;
				end
				S13:begin
						a1	<=	c1;
						slc <=3'b100;
						if(v0 == 1)
							b1	<=	x11;
						else
							b1 	<=	x00;
				end
				S14:begin
						a1 	<=	c1;
						b1	<=	`Square_of_R;
						slc <=	3'b100;
				end
				S15:begin
						v0	<=	c1;
						a1	<=	256'h2;
						b1	<=	tmpx;
						slc	<=	3'b100;
				end
				S16:begin
						a1	<=	c1;
						b1	<=	`Square_of_R;
						slc	<=	3'b100;
				end
				S17:begin
						a1	<=	v0;		
						b1	<=	v0;
						v1	<=	c1;		
						slc	<=3'b100;
				end
				S18:begin
						a1	<=	c1;
						b1	<=	`Square_of_R;
						slc	<=	3'b100;
				end
				S19:begin
						a1	<=	c1;
				end
				S20:begin
						b1	<=	v1;
						slc	<=	3'b010;
				end
				S21:begin
						v1	<=	c2;		
						a1	<=	tmpx;
						b1	<=	c2;
						slc	<=	3'b010;
				end
				S22:begin
						a1	<=	c2;
						slc	<=	3'b000;
				end
				S23:begin
						b1  <=	v0;
						slc	<=	3'b100;
				end
				S24:begin
						a1	<=	c1;
						b1	<=	`Square_of_R;
						slc	<=	3'b100;
				end
				S25:begin
						a1	<=	c1;
				end
				S26:begin
						b1 	<=	tmpy;
						slc	<=	3'b010;
				end
/*				S27:begin
						tmpy	<=	c2;			
						tmpx	<=	v1;
					end
					*/
				S27:begin
						y		<=	c2;
						x		<=	v1;
						tmpy	<=	c2;
						tmpx	<=	v1;
				end
						
				S28:begin
						a1		<=	tmpx;
						b1		<=	x0;
						slc		<=	3'b010;
				end
				S29:begin
						v0 		<=	c2;
						v1		<=	`Globle_P;
						x11		<=	1;
						x00		<=	0;
				end
				S30:begin
						if(v1!=1&&v0!=1)
							if(v0[0]==0)begin
								v0 <= v0>>1'b1;
								if(x11[0]==0)
									x11 = x11>>1'b1;
								else
									x11 = (x11>>1'b1) + (`Globle_P>>1'b1) + 1;
							end
					end
				S31:if(v1[0]==0)
						begin
							v1 <= v1>>1'b1;
							if(x00[0] == 0)
								x00 <= x00>>1'b1;
							else
								x00 <= (x00>>1'b1) + (`Globle_P>>1'b1) + 1;
						end
				S32:begin
						if(v0 >= v1)
							begin
								a1 <= x11;
								b1 <= x00;
							end
						else
							begin
								a1 <= x00;
								b1 <= x11;
							end
						slc <= 3'b010;
				end
				S33:begin
						if(v0 >= v1)
							begin
								a1 <= v0;
								b1 <= v1;
								x11 <= c2;
							end
						else
							begin
								a1 <= v1;
								b1 <= v0;
								x00 <= c2;
							end
						slc <= 3'b010;
					end
				S34:begin
						if(v0 >= v1)
							v0 <= c2;
						else
							v1 <= c2;
				end
				S35:begin
						a1 <= tmpy;
						b1 <= y0;
						slc <= 3'b010;
				end
				S36:begin
						if(v0 == 1)
							a1 <= x11;
						else
							a1 <= x00;
						b1 <= c2;
						slc <= 3'b100;
				end
				S37:begin
						a1 <= c1;
						b1 <= `Square_of_R;
						slc <= 3'b100;
				end
				S38:begin
						a1 <= c1;
						b1 <= c1;
						v0 <= c1;		
						slc <= 3'b100;
				end
				S39:begin
						a1 <= c1;
						b1 <= `Square_of_R;
						slc <= 3'b100;
				end
				S40:begin
						a1 <= c1;
						b1 <= x0;
						slc <= 3'b010;
				end
				S41:begin
						a1 <= c2;
						b1 <= tmpx;
						slc <= 3'b010;
				end
				S42:begin
						tmpx <= c2;
						a1	 <= x0;
						b1   <= c2;
						slc  <= 3'b010;
				end
				S43:begin
						a1 <= c2;
				end
				S44:begin
						b1 <= v0;
						slc <= 3'b100;
				end
				S45:begin
						a1 <= c1;
						b1 <= `Square_of_R;
						slc <= 3'b100;
				end
				S46:begin
						a1 <= c1;
						b1 <= y0;
						slc <= 3'b010;
				end
				S47:begin
						tmpy <= c2;
				end
				S48:begin
						x1 <= tmpx;
						y1 <= tmpy;
				end
				S49:sign <= 1;
				default:begin
						a1 <= a1;
						b1 <= b1;
						slc <= slc;
				end
			endcase
	
	fp_core u(.clk(clk),.rst_b(rst_b),.select(slc),.data_ina(a1),.data_inb(b1),.data_mm(c1),.end_mm(end1),.data_as(c2));
endmodule	

	
