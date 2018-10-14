`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:36:40 11/21/2016 
// Design Name: 
// Module Name:    IF_ID 
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
module IF_ID(
    input clk,
    input en,
    input reset,
    input [31:0] instrF,
    output [31:0] instrD,
    input [31:0] pc4F,
    output [31:0] pc4D,
	 input [31:0] pc8F,
    output [31:0] pc8D,
	 input clr,
	 input intclr
    );
	 initial begin
		instrD<=0;
		pc4D<=0;
		pc8D<=0;
	 end
	 
	 reg [31:0]instrD,pc4D,pc8D;
	 always@(posedge clk)begin
		 if(reset||clr||intclr)begin
			 instrD<=0;
		 end
		 else if(en)begin
			instrD<=instrF;
			pc4D<=pc4F;
			pc8D<=pc8F;
		 end	 
	 end


endmodule
