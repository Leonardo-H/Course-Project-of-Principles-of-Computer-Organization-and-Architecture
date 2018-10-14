`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:21:18 11/21/2016 
// Design Name: 
// Module Name:    mips 
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
module mips(
    input clk,
    input reset
    );
	 
	 
	 wire [31:0]Devout1,Devout0;
	 wire We0,We1;
	 wire IRQ0,IRQ1;
	 wire [31:2]DevAddr,PrAddr;
	 wire [31:0]PrRD,PrWD,DevWD;
	 wire [3:0]BE;
	 wire [7:2]HWInt;
	 wire PrWe;
	 
	 
	 cpu 			_cpu(.clk(clk),.reset(reset),.PrAddr(PrAddr),.PrRD(PrRD),.PrWD(PrWD),.PrWe(PrWe),.PrBE(BE),
							.HWInt(HWInt));

	 						 
	 Bridge     _Bridge(.PrAddr(PrAddr),.BE(BE),.PrRD(PrRD),.PrWD(PrWD),.PrWe(PrWe),.irq({{4'b0000},IRQ1,IRQ0}),
							.We0(We0),.We1(We1),.DevAddr(DevAddr),.HWInt(HWInt),.readdev1(Devout1),.readdev0(Devout0),
							.DevWD(DevWD));					 
	 

	 timecounter _timer0(.clk(clk),.reset(reset),.addr(DevAddr[3:2]),.We(We0),.Datain(DevWD),.Dataout(Devout0),
								.IRQ(IRQ0));
								
	 timecounter _timer1(.clk(clk),.reset(reset),.addr(DevAddr[3:2]),.We(We1),.Datain(DevWD),.Dataout(Devout1),
								.IRQ(IRQ1));						 


endmodule
