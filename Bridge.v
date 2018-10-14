`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:47:48 12/18/2016 
// Design Name: 
// Module Name:    Bridge 
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
module Bridge(
    input [31:2] PrAddr,
	 output [31:2]DevAddr,
    input [3:0] BE,
    output [31:0]PrRD,
    output [31:0]DevWD,
	 input [31:0] PrWD,
    input PrWe,
	 output We0,
	 output We1,
	 input [7:2]irq,
	 input [31:0]readdev0,
	 input [31:0]readdev1,
    output [7:2] HWInt
    );

	
	
	
	 wire hitdev1,hitdev0,We1,We0;
	 
	 assign HWInt[7:2]=irq[7:2];
	 assign hitdev0=DevAddr[31:4]==28'h00007f0;
	 assign hitdev1=DevAddr[31:4]==28'h00007f1;
	 assign We0=hitdev0 && PrWe;
	 assign We1=hitdev1 && PrWe;
	 assign DevWD=PrWD;
	 assign DevAddr=PrAddr;
	 assign PrRD=hitdev0 ? readdev0 :
				  hitdev1 ? readdev1 : readdev1;


endmodule
