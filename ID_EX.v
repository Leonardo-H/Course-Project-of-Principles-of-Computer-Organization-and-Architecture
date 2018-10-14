`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:23:01 11/21/2016 
// Design Name: 
// Module Name:    ID_EX 
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
module ID_EX(
    input clk,
    input reset,
	 input clr,
    input [31:0] instrD,
    output [31:0] instrE,
    input [31:0] extimmD,
    output [31:0] extimmE,
	 input [31:0]Reg1_D,
	 output [31:0]Reg1_E,
	 input [31:0]Reg2_D,
	 output [31:0]Reg2_E,
	 input [31:0] pc8D,
	 output [31:0]pc8E,
	 input intclr
    );
	 
	 reg [31:0]instrE,extimmE,Reg1_E,Reg2_E,pc8E;
	 initial begin
		instrE<=0;
		extimmE<=0;
		Reg1_E<=0;
		Reg2_E<=0;
		pc8E<=0;
	 end
	 assign eretD=instrD==32'h42000018;
	 always@(posedge clk)begin
		if(reset||clr||intclr&&!eretD)begin
			instrE<=0;
			extimmE<=0;
			Reg1_E<=0;
			Reg2_E<=0;
		end
		else begin
			instrE<=instrD;
			extimmE<=extimmD;
			Reg1_E<=Reg1_D;
			Reg2_E<=Reg2_D;
			pc8E<=pc8D;
		end
	 end


endmodule
