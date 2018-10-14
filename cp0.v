`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:33:01 12/19/2016 
// Design Name: 
// Module Name:    cp0 
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
module cp0(
    input [4:0] ar,
    input [4:0] aw,
    input [31:0] Din,
    input [31:0] pc,
    input [6:2] exccode,
    input [5:0] HWInt,
    input EXLSet,
    input EXLClr,
    input clk,
    input reset,
    output IntReq,
    output [31:2] EPC,
    output [31:0] Dout,
	 input [31:0]instr,
	 input branch,
	 output exl
    );
	 
	 //epc
	 reg [31:2]epc;	 
	 reg [15:10] hwint_pend ;  
	 reg [31:0]prid;
	 wire [31:0]cause;
	 wire We;	 	 
	 wire [31:0]SR;						 //SR={16'b0, im, 8'b0, exl, ie}
	 reg [15:10]im;
	 reg exl,ie;							 //cause={16'b0, hwint_pend, 10'b0}
	 reg register;
	
	 assign We=instr[31:21]==11'b01000000100 && instr[10:0]==0;    //mtc0
	 initial begin
			epc<=0;
			im<=0;
			exl<=0;
			ie<=0;
			hwint_pend<=0;
			prid<=32'h12345678;
			register<=0;
	 end
	 
	 assign EPC=epc;
	 assign SR={{16'b0},im,{8'b0},exl,ie};
	 assign cause={{16'b0},hwint_pend,{10'b0}};
	 assign Dout=  ar==12 ? SR :
						ar==13 ? cause :
						ar==14 ? {epc,{2'b00}} :
						ar==15 ? prid : 0;
	 assign IntReq = (|(HWInt[5:0] & im[15:10])) & ie & !exl ; 
	 
	 
	 always@(posedge clk)begin
		if(reset)begin
			epc<=0;
			im<=0;
			exl<=0;
			ie<=0;
			hwint_pend<=0;
		end
		else begin if(branch) epc<=pc[31:2];
		else if(We)begin
			case(aw)
			12: {im,exl,ie}<={Din[15:10],Din[1],Din[0]};
			14: epc<=Din[31:2];
			default : register<=0;
			endcase
		end
		if(EXLSet) exl<=1;
		if(EXLClr) exl<=0;
		hwint_pend<=HWInt;
		end
	 end


endmodule
