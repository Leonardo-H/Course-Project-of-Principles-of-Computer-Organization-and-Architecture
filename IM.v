`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:27:43 11/21/2016 
// Design Name: 
// Module Name:    IM 
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
module IM(
    input [31:0] pc,
    output [31:0] instr
    );
	 wire [31:0]pc2;
	 reg [31:0] _imk[2047:1120];
	 reg [31:0] _im[1119:0];
	 initial begin
		$readmemh("code.txt",_im);
		$readmemh("handler.txt",_imk);
	 end
	 assign pc2=pc-32'h3000;
	 assign instr=(pc<32'h4180) ? _im[pc2[12:2]] : _imk[pc2[12:2]]; 
endmodule
