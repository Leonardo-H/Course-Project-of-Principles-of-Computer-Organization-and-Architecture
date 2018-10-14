`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:52:26 12/20/2016 
// Design Name: 
// Module Name:    mux 
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
module mux(
    input [31:0] PrRD,
	 input [31:0] instr,
	 input [31:0] cp0Dout,
    input [31:0] DMoutM,
    input [31:0] ALUoutM,
    output [31:0] FDMout
    );
	 
	 
	 wire sel,mfc0;
	 assign mfc0=instr[31:21]==11'b01000000000 && instr[10:0]==0;
	 assign sel=ALUoutM[31:4]==28'h00007f0 || ALUoutM[31:4]==28'h00007f1;
	 assign FDMout=mfc0 ? cp0Dout : sel ? PrRD : DMoutM;


endmodule
