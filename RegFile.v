`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:59:59 11/21/2016 
// Design Name: 
// Module Name:    RegFile 
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
module RegFile(
    input clk,
    input reset,
	 input [31:0]pc,
    input [31:0] instrD,
    input [31:0] RegWData,
    input [4:0] RegWAddr,
    input [31:0] pc4D,
	 input [31:0] pc8E,
	 input [31:0] pc8M,
	 input [31:0] pc8W,
	 input [31:0]ALUoutM,
    input RegWrite,
	 input [3:0]forwardAD,
	 input [3:0]forwardBD,
    output [31:0] RegRData1,
    output [31:0] RegRData2,
    output [31:0] Branchpc,
    output [31:0] extimm,
	 output [31:0]jpc,
	 output [2:0]pc_sel,
	 output valid,
	 output [31:0]instrRF
    );
	 
	 
	 reg [31:0] register [31:0];
	 wire [1:0]extctr;
	 wire [31:0] extimm;
	 wire beq,bne,bgezal,movz,blez,bgtz,bltz,bgez;
	 wire beq_v,bne_v,bgezal_v,blez_v,bgtz_v,bltz_v,bgez_v;
	 wire [31:0]RD1,RD2;
	 wire invalid;
	 
	 assign bgezal_v=RegRData1==0 || RegRData1[31]==0 && RegRData1[30:0]>0;
	 assign beq_v=RegRData1==RegRData2;
	 assign bne_v=RegRData1!=RegRData2;
	 assign blez_v=RegRData1==0 || RegRData1[31]==1;
	 assign bltz_v=RegRData1[31]==1;
	 assign bgez_v=RegRData1[31]==0;
	 assign bgtz_v=RegRData1[31]==0 && RegRData1[30:0]>0;
	 assign valid=beq&&beq_v || bne&&bne_v || bgezal&&bgezal_v || blez&&blez_v || bltz&&bltz_v || bgtz&&bgtz_v ||
					  bgez&&bgez_v;
	 
	 ctr _ctr(.instr(instrD),.ExtOp(extctr),.PC_sel(pc_sel),.beq(beq),.bgezal(bgezal),.bne(bne),.movz(movz),
				 .blez(blez),.bltz(bltz),.bgez(bgez),.bgtz(bgtz),.eret(eret));


	 assign Branchpc=pc4D+(extimm<<2);
	 assign jpc={pc[31:28],instrD[25:0],{2'b00}};
	 assign RD1=register[instrD[25:21]];
	 assign RD2=register[instrD[20:16]];
	 assign invalid=~valid && bgezal || movz && RegRData2!=0;
	 assign instrRF=invalid ? 0 : instrD;
	 
	 
	 
	 
	assign extimm= extctr==2'b00 ? {instrD[15:0],{16{1'b0}}}:
						extctr==2'b01 ? {{16{1'b0}},instrD[15:0]}:
										{{16{instrD[15]}},instrD[15:0]};
																						
	assign RegRData1=forwardAD==1 ? pc8E : 
						forwardAD==2 ? ALUoutM :
						forwardAD==3 ? pc8M :
						forwardAD==4 ? RegWData :
						forwardAD==5 ? pc8W :RD1;
	assign RegRData2=forwardBD==1 ? pc8E :
					forwardBD==2 ? ALUoutM :
						forwardBD==3 ? pc8M :
						forwardBD==4 ? RegWData :
						forwardBD==5 ? pc8W :RD2;
	 

	 
	 integer i=0;
	 initial begin
	   for(i=0;i<32;i=i+1)
			register[i]=0;
	 end 
	 
	 
	 always@(posedge clk)begin
			if(reset)begin
				for(i=0;i<32;i=i+1)
				register[i]=0;
			end
			else if(RegWrite)begin
				register[RegWAddr]<=(RegWAddr==0)?0:RegWData;
				$display("$%d <= %h",RegWAddr,RegWData);
				end
	 end


endmodule
