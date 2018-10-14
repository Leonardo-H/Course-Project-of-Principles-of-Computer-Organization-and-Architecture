`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:05:33 11/22/2016 
// Design Name: 
// Module Name:    MEM_WB 
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
module MEM_WB(
    input clk,
    input reset,
	 input intclr,
    input [31:0] instrM,
	 input [31:0] instrE,
	 input [31:0] instrD,
    output [31:0] instrW,
    input [31:0] ALUoutM,
    output [31:0] ALUoutW,
    input [31:0] DMoutM,
    output [31:0] DMoutW,
	 input [31:0] pc8M,
	 output [31:0]pc8W
    );
	 reg [31:0] instrW,ALUoutW,DMoutW,pc8W;
	 initial begin
			instrW<=0;
			ALUoutW<=0;
			DMoutW<=0;
			pc8W<=0;
		end
		
	 assign eretD=instrD==32'h42000018;
	 assign eretE=instrE==32'h42000018;
		
	 always@(posedge clk)begin
		if(reset||intclr&&!eretD&&!eretE) begin
			instrW<=0;
			ALUoutW<=0;
			DMoutW<=0;
		end
		else begin
			instrW<=instrM;
			ALUoutW<=ALUoutM;
			DMoutW<=DMoutM;
			pc8W<=pc8M;
		end
	 end


endmodule
