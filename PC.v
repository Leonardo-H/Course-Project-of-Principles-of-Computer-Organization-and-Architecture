`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:22:07 11/21/2016 
// Design Name: 
// Module Name:    PC 
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
module PC(
    input clk,
    input reset,
    input en,
	 input [31:0]instr,
	 input [31:0] Branchpc,
	 input [31:0] regdata,
	 input [31:0] jpc,
	 input [2:0]pc_sel,
	 output [31:0] pc,
	 output [31:0] pc4,
	 output [31:0] pc8,
	 input valid,
	 input [31:2]epc,
	 input intbranch,
	 input [1:0]fderet,
	 input [31:0]B,
	 input [31:0]WD,
	 output [31:2]fepc
    );
	 reg [31:0]pc=32'h00003000;
	 wire [31:0]fepc;
	 assign pc4=pc+4;
	 assign pc8=pc+8;
	 assign fepc=fderet==0? {epc,{2'b00}} :
					 fderet==1? B :
					 fderet==2? WD:{epc,{2'b00}};
	 always @(posedge clk)begin
		 if(reset)
			pc<=32'h00003000;
		 else if(intbranch)pc<=32'h00004180;
		 else if(en)begin
		 case(pc_sel)
			 3'b000: pc<=pc+4;
			 3'b001: if(valid)pc<=Branchpc;
					   else pc<=pc+4;
			 3'b010: pc<=regdata;
			 3'b011: pc<=jpc;
			 3'b100: pc<=fepc;
			 default: pc<=pc+4;
		 endcase
		 end
	 end


endmodule
