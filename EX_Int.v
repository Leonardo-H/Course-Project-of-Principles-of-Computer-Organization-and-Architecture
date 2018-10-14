`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:28:15 12/21/2016 
// Design Name: 
// Module Name:    EX_Int 
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
module EX_Int(
	 input [31:0] instrM,
	 input [31:0] instrD,
	 input [31:0] instrE,
	 input [31:0] instrW,
	 input [31:0] pcF,
	 input [31:0] pc8M,
	 input [31:0] pc8E,
	 input [31:0] pc8D,
	 input IntReq,
	 input [31:2]epc,
	 output [31:0]intpc,
	 output branch
    );
	 
	 ctr ctrM(.instr(instrM),.M(M),.E(E));
	 assign eretD=instrD==32'h42000018;
	 assign eretE=instrE==32'h42000018;
	 assign eretM=instrM==32'h42000018;
	 assign eretW=instrW==32'h42000018;
	 
	 wire [31:0]pcD,pcE,pcM;
	 assign branch=IntReq;
	 assign pcD=pc8D-8;
	 assign pcE=pc8E-8;
	 assign pcM=pc8M-8;
	 assign intpc = eretE||eretD||eretM ? {epc,{2'b00}}:
						 E ? pcE : 
						 pcM!=0 ? pcM :pcD;
						 


endmodule
