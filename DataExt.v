`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:08:21 12/07/2016 
// Design Name: 
// Module Name:    DataExt 
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
module DataExt(
    input [1:0] Addr,
    input [31:0] Datain,
	 input [31:0] instrW,
    output [31:0] Dataout
    );
	 
	 wire lw,lh,lhu,lb,lbu;
	 wire [2:0]op;
	 ctr _ctr(.instr(instrW),.lw(lw),.lh(lh),.lhu(lhu),.lb(lb),.lbu(lbu));
	 assign op= lw? 0 : lh ? 1: lhu ? 2: lb ? 3 : lbu ? 4 :0;
	 assign Dataout = op==0?  Datain :
							op==1? (Addr[1]==1? {{16{Datain[31]}},Datain[31:16]} : {{16{Datain[15]}},Datain[15:0]}) :
							op==2? (Addr[1]==1? {{16{1'b0}},Datain[31:16]} :  {{16{1'b0}},Datain[15:0]}):
							op==3? (Addr==3 ? {{24{Datain[31]}},Datain[31:24]} : 
									  Addr==2 ? {{24{Datain[23]}},Datain[23:16]} : 
									  Addr==1 ? {{24{Datain[15]}},Datain[15:8]} : {{24{Datain[7]}},Datain[7:0]})  :
							op==4? (Addr==3 ? {{24{1'b0}},Datain[31:24]} : 
									  Addr==2 ? {{24{1'b0}},Datain[23:16]} : 
									  Addr==1 ? {{24{1'b0}},Datain[15:8]} : {{24{1'b0}},Datain[7:0]})  :  Datain;


endmodule
