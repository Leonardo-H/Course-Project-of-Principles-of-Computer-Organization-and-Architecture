`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:55:54 11/21/2016 
// Design Name: 
// Module Name:    ALU 
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
module ALU(
    input [31:0] instrE,
    input [31:0] RegDataE1,
    input [31:0] RegDataE2,
    input [31:0] ALUoutM,
    input [31:0] RWData,
    input [31:0] extimmE,
    input [3:0] forwardA_E,
    input [3:0] forwardB_E,
    output [31:0] result,
	 output [31:0] WriteDataE,
	 output [31:0]A,
	 output [31:0]B,
	 input [31:0]mdresult
    );
	 
	 wire [31:0] ALUA,A;
	 wire [31:0] ALUB,B;	
	 wire [31:0] ALUresult;
	 wire [3:0]ALUctr;
	 wire ALUBsrc;
	 wire ALUAsrc;
	 wire slt,slti,sltiu,sltu,mfhi,mflo;
	 wire slt_v,slti_v,sltiu_v,sltu_v;
	 wire svalid;
	 
	 assign slt_v= $signed(ALUA)<$signed(ALUB);
	 assign slti_v=$signed(ALUA)<$signed(ALUB);
	 assign sltiu_v={{1'b0},ALUA[31:0]}<{{1'b0},ALUB[31:0]};
	 assign sltu_v={{1'b0},ALUA[31:0]}<{{1'b0},ALUB[31:0]};
	 assign svalid= slt && slt_v || slti && slti_v || sltu && sltu_v || sltiu && sltiu_v;
	 assign result=(mfhi||mflo)?mdresult:ALUresult;

	 ctr _ctr(.instr(instrE),.ALUctr(ALUctr),.ALUBsrc(ALUBsrc),.ALUAsrc(ALUAsrc),.slt(slt),
				.slti(slti),.sltiu(sltiu),.sltu(sltu),.mflo(mflo),.mfhi(mfhi));

	 assign WriteDataE=B;

	 //ALUB
	 assign ALUB=ALUBsrc?extimmE:B;
	 //ALUA 
	 assign ALUA=ALUAsrc?{{27{1'b0}},instrE[10:6]}:A;
	 //A 
	 assign A=forwardA_E==1?ALUoutM:
				 forwardA_E==2?RWData:RegDataE1;
					 	 
	 //B
	 assign B=forwardB_E==1?ALUoutM:
				 forwardB_E==2?RWData:RegDataE2;
 
	//	result  
	//ALUctr[3:0]
	 assign ALUresult = ALUctr==1 ? ALUA-ALUB:
	                 ALUctr==2 ? ALUA|ALUB:
						  ALUctr==3 ? ALUA&ALUB:
						  ALUctr==4 ? ALUA^ALUB:
						  ALUctr==5 ? ALUB<<ALUA[4:0]:
						  ALUctr==6 ? ALUB>>ALUA[4:0]:
						  ALUctr==7 ? ~(ALUA|ALUB):
						  ALUctr==8 ? {{32{ALUB[31]}},ALUB[31:0]}>>ALUA[4:0] : 
						  ALUctr==9 ? (svalid ? 32'b1:32'b0) :
						  ALUctr==10 ? {{24{ALUB[7]}},ALUB[7:0]} :ALUA+ALUB;


endmodule
