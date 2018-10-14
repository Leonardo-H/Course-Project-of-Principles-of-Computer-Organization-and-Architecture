`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:45:05 12/07/2016 
// Design Name: 
// Module Name:    MUDIV 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module MUDIV(
	input clk,
	input reset,
	input [31:0] instrE,
    input [31:0] RegDataE1,
    input [31:0] RegDataE2,
    output [31:0] mudivout,
	output busy,
	output start,
	input IntReq
    );
	 
	wire mult,multu,div,divu,mflo,mfhi,mtlo,mthi,madd;
	reg busy;
	wire start;
	reg [1:0]choice;
	reg [3:0]count;
	reg [31:0] hi,lo;
	reg [31:0] d1,d2;
	wire [63:0]a,b;
	ctr _ctr(.instr(instrE),.mult(mult),.multu(multu),.div(div),.divu(divu),.mflo(mflo),
				.mfhi(mfhi),.mtlo(mtlo),.mthi(mthi),.madd(madd));
	
	
	assign mudivout=mflo ? lo : hi;
	
	assign start=div ||divu || mult || multu ;
	initial begin
	hi<=0;
	lo<=0;
	busy<=0;
	count<=0;
	choice<=0;
	d1<=0;
	d2<=0;
	end
	 
	 
	 

	assign a=$signed(RegDataE1)*$signed(RegDataE2);
	assign b=$signed(d1)*$signed(d2);
	always @(posedge clk)begin
	if(start && !IntReq)begin
		busy<=1;
		d1<= RegDataE1;
		d2<= RegDataE2;
		count<= div||divu ? 10 : mult || multu ? 5 : 0;
		choice<= mult? 0 : multu ? 1 : div ? 2 : divu ? 3 :0;
	end
	end
	 
	always @ (posedge clk)begin
		if(mtlo || mthi)begin
			if(mtlo) begin lo<=RegDataE1;		
//			$display("$34 <= %h",RegDataE1);
			end			
			else   begin hi<=RegDataE1;
//			$display("$33 <= %h",RegDataE1);
			end
		end
		if(madd)	{hi,lo}<={hi,lo}+a;
	end

	always@(posedge clk)begin
		if(reset) begin 
			hi<=0;
			lo<=0;
		end
		else if(busy) begin
			count<=count-1;
			if(count==1) begin
			   case(choice)              	
				2'b00 : {hi,lo}<=$signed(d1)*$signed(d2);
				2'b01 : {hi,lo}<={{1'b0},d1}*{{1'b0},d2};
				2'b10 : if(d2!=0)
						  begin lo<=$signed(d1)/$signed(d2);
								  hi<=$signed(d1)%$signed(d2);
						  end
				2'b11 : if(d2!=0)
						  begin lo<={{1'b0},d1}/{{1'b0},d2};
								  hi<={{1'b0},d1}%{{1'b0},d2};
						  end
				default:{hi,lo}<=$signed(d1)*$signed(d2);
				endcase
			   busy<=0;
				count<=0;
			end
		end
	 end
	 


endmodule
