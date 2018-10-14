`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:06:40 11/21/2016 
// Design Name: 
// Module Name:    EX_MEM 
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
module EX_MEM(
    input clk,
    input reset,
    input [31:0] instrE,
	 input [31:0] instrD,
    output [31:0] instrM,
    input [31:0] resultE,
    output [31:0] ALUoutM,
    input [31:0] WriteDataE,
    output [31:0] WriteDataM,
	 input [31:0] pc8E,
	 output [31:0]pc8M,
	 input intclr,
	 input clr
    );
	 

	 initial begin
		instrM<=0;
		ALUoutM<=0;
		WriteDataM<=0;
		pc8M<=0;
	 end
	 reg [31:0]instrM,ALUoutM,WriteDataM,pc8M;
	 assign eretD=instrD==32'h42000018;
	 assign eretE=instrE==32'h42000018;
	 always@(posedge clk)begin
		if(reset||intclr&&!eretD&&!eretE||clr)begin
			instrM<=0;
			ALUoutM<=0;
			WriteDataM<=0;
		end
		else begin
			instrM<=instrE;
			ALUoutM<=resultE;
			WriteDataM<=WriteDataE;
			pc8M<=pc8E;
		end	 
	 end


endmodule
