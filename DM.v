`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:20:52 11/22/2016 
// Design Name: 
// Module Name:    DM 
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
module DM(
    input clk,
    input reset,
    input [31:0] instrM,
    input [31:0] ALUoutM,
    input [31:0] WriteDataM,
	 input [1:0] forwardM,
	 input [31:0] Dataout,
	 output [31:0]WD,
    output [31:0] DMoutM,
	 output BE,
	 output memwrite
    );
	 
	 reg [31:0] _dm[2047:0];
	 wire MemWrite;
	 wire memwrite,hit;
	 wire sw,sh,sb;
	 wire [31:0]WD;
	 wire [3:0]BE;
	 integer i;
	 initial begin 
		for(i=0;i<2048;i=i+1)
			_dm[i]=0;
	 end
	 assign hit=ALUoutM[31:13]==0;
	 assign MemWrite=memwrite && hit;
	 assign DMoutM=_dm[ALUoutM[12:2]];
	 assign WD=forwardM ? Dataout :WriteDataM;
	 ctr _ctr(.instr(instrM),.MemWrite(memwrite),.sw(sw),.sb(sb),.sh(sh));
	 assign BE=	sh ? (ALUoutM[1:0]==0? 4'b0011 : 4'b1100) :
					sb ? (ALUoutM[1:0]==0? 4'b0001 : 
							ALUoutM[1:0]==1? 4'b0010 :
							ALUoutM[1:0]==2? 4'b0100 : 4'b1000) : 4'b1111;

	 always@(posedge clk)begin
		if(reset)
			for(i=0;i<2048;i=i+1)
				_dm[i]=0;
		else if(MemWrite)begin
			case(BE)
				4'b1111: begin _dm[ALUoutM[12:2]]<=WD;
							$display("*%h <= %h",ALUoutM,WD);
							end
				4'b1100: begin _dm[ALUoutM[12:2]][31:16]<=WD[15:0];
							$display("*%h <= %h",ALUoutM,WD[15:0]);
							end
				4'b0011: begin _dm[ALUoutM[12:2]][15:0]<=WD[15:0];
							$display("*%h <= %h",ALUoutM,WD[15:0]);
							end
				4'b0001: begin _dm[ALUoutM[12:2]][7:0]<=WD[7:0];
							$display("*%h <= %h",ALUoutM,WD[7:0]);
							end
				4'b0010: begin _dm[ALUoutM[12:2]][15:8]<=WD[7:0];
							$display("*%h <= %h",ALUoutM,WD[7:0]);
							end
				4'b0100: begin _dm[ALUoutM[12:2]][23:16]<=WD[7:0];
							$display("*%h <= %h",ALUoutM,WD[7:0]);
							end
				4'b1000: begin _dm[ALUoutM[12:2]][31:24]<=WD[7:0];
							$display("*%h <= %h",ALUoutM,WD[7:0]);
							end
				default: begin _dm[ALUoutM[12:2]]<=WD;
							$display("*%h <= %h",ALUoutM,WD);
							end
			endcase
		 end
	 end


endmodule
