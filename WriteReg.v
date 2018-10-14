`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:57:18 11/23/2016 
// Design Name: 
// Module Name:    WriteReg 
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
module WriteReg(
    input [31:0] instrW,
    input [31:0] ALUoutW,
    input [31:0] DMoutW,
	 input [31:0] pc8W,
    output [31:0] RegWData,
    output RegWrite,
	 output [4:0]RegWAddr
    );
	 
	 wire [1:0]MemtoReg;
	 ctr _ctr(.instr(instrW),.RegWrite(RegWrite),.MemtoReg(MemtoReg),.RegWAddr(RegWAddr),.bgezal(bgezal));
	 assign RegWData=MemtoReg==2?pc8W:
						  MemtoReg==1?DMoutW:ALUoutW;


endmodule
