`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:25:47 12/20/2016 
// Design Name: 
// Module Name:    cpu 
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
module cpu(
    input clk,
    input reset,
    output [31:2] PrAddr,
    output [3:0] PrBE,
    input [31:0] PrRD,
    output [31:0] PrWD,
    output PrWe,
    input [7:2] HWInt
    );
	 
	 
	 
	 
	 wire en_pc,en_IFID,clr_IDEX,clr_IFID;
	 wire [2:0]pc_sel;
	 wire [31:0] pc,Branchpc,jpc,pc4F,pc4D,pc8F,pc8D,pc8E,pc8M,pc8W;
	 wire [31:0] instrF,instrD,instrE,instrM,instrW;
	 wire [3:0]forwardAD,forwardBD,forwardAE,forwardBE;
	 wire [1:0]forwardM;
	 wire RegWrite;
	 wire [31:0] extimmD,extimmE,Reg1_D,Reg1_E,Reg2_D,Reg2_E;
	 wire [31:0] ALUoutM,ALUoutW,RegWData,result;
	 wire [31:0] WriteDataE,WriteDataM;
	 wire [4:0] RegWAddr;
	 wire [31:0] DMoutM, DMoutW ,Dataout;
	 wire valid;
	 wire [31:0]instrRF;
	 wire busy,start;
	 wire [3:0]BE;
	 wire [31:0]A,B,mdresult;
	 wire [31:2]epc;
	 wire [31:0]ffepc;
	 wire [31:0]intpc;
	 wire [31:0]cp0Dout,FDMout,WD;
	 wire eretD,branch;
	 wire [6:2]exccode;
	 wire [1:0]epcsel,fderet;
	 
	 
	 assign PrAddr=ALUoutM[31:2];
	 assign PrWD=WriteDataM;
	 assign PrBE=BE;
	 assign exccode=0;
	 assign PrWe=prwe;
	 
	 PC  		   _PC(/*I*/.clk(clk),	/*I*/.reset(reset),	/*I*/.en(en_pc),	/*I*/.instr(instrF),
						/*I*/.Branchpc(Branchpc),.regdata(Reg1_D),.jpc(jpc), .pc_sel(pc_sel),.pc(pc) ,.pc4(pc4F),
						.pc8(pc8F),.valid(valid),.epc(epc),.intbranch(branch),.fderet(fderet),.B(B),.fepc(ffepc),
						.WD(WD));
	 
	 
	 IM   		_IM(/*I*/.pc(pc),.instr(instrF));
	 
	 
	 IF_ID 		_IF_ID( /*I*/.clk(clk), /*I*/.en(en_IFID), /*I*/.reset(reset), .clr(clr_IFID),.intclr(IntReq),
							/*I*/.instrF(instrF), .instrD(instrD), .pc4F(pc4F), .pc4D(pc4D), .pc8F(pc8F), .pc8D(pc8D));


	 RegFile	   _RegFile(/*I*/.clk(clk),/*I*/.reset(reset),/*I*/.pc(pc),/*I*/ .instrD(instrD),
								/*I*/ .RegWData(RegWData),/*I*/ .RegWAddr(RegWAddr),/*I*/ .pc4D(pc4D), .pc8E(pc8E),
								.pc8M(pc8M) ,.pc8W(pc8W) ,/*I*/.ALUoutM(ALUoutM),/*I*/.RegWrite(RegWrite),
								/*I*/ .forwardAD(forwardAD),/*I*/ .forwardBD(forwardBD),	.RegRData1(Reg1_D), 
								.RegRData2(Reg2_D), .Branchpc(Branchpc), .extimm(extimmD),.instrRF(instrRF),
								.jpc(jpc),.pc_sel(pc_sel),.valid(valid));
						
						
	 ID_EX		_ID_EX(/*I*/.clk(clk),/*I*/.reset(reset),/*I*/.clr(clr_IDEX),/*I*/.instrD(instrRF), .instrE(instrE), 
							/*I*/.extimmD(extimmD),.extimmE(extimmE),	/*I*/.Reg1_D(Reg1_D),.Reg1_E(Reg1_E),
							/*I*/.Reg2_D(Reg2_D),	.Reg2_E(Reg2_E), .pc8D(pc8D), .pc8E(pc8E),.intclr(IntReq));
			
							
	 ALU			_ALU(/*I*/.instrE(instrE),/*I*/.RegDataE1(Reg1_E), .RegDataE2(Reg2_E),
						/*I*/ .ALUoutM(ALUoutM),/*I*/ .RWData(RegWData),/*I*/ .extimmE(extimmE),/*I*/ .forwardA_E(forwardAE),
							/*I*/ .forwardB_E(forwardBE), .result(result), .WriteDataE(WriteDataE),.A(A),.B(B),.mdresult(mdresult));
							
							
	 MUDIV      _MUDIV(.clk(clk),.reset(reset),.instrE(instrE),.RegDataE1(A), .RegDataE2(B),
		                .mudivout(mdresult),.busy(busy),.start(start),.IntReq(IntReq));						
							
	

	 EX_MEM		_EX_MEM(/*I*/.clk(clk),/*I*/.reset(reset),/*I*/ .instrE(instrE), .instrM(instrM),
								/*I*/ .resultE(result), .ALUoutM(ALUoutM),/*I*/ .WriteDataE(WriteDataE), .WriteDataM(WriteDataM),
								.pc8E(pc8E) ,.pc8M(pc8M),.intclr(IntReq),.clr(clr_EXMEM),.instrD(instrD));
			
	 DM			_DM(/*I*/.clk(clk),/*I*/.reset(reset),/*I*/ .instrM(instrM),/*I*/ .ALUoutM(ALUoutM),
						 /*I*/ .WriteDataM(WriteDataM), .forwardM(forwardM),.Dataout(Dataout), .DMoutM(DMoutM),.BE(BE),
						 .memwrite(prwe),.WD(WD));	


	 EX_Int     _EX_Int( .instrM(instrM),.IntReq(IntReq),.instrD(instrD),.pcF(pc),.instrE(instrE),.instrM(instrM),
								.pc8M(pc8M),.pc8E(pc8E),.pc8D(pc8D),.intpc(intpc),.branch(branch),.instrW(instrW),.epc(ffepc[31:2]));


	 cp0        _cp0(.clk(clk),.reset(reset),.EPC(epc),.pc(intpc),.ar(instrM[15:11]),.aw(instrM[15:11]),
						  .Dout(cp0Dout),.HWInt(HWInt),.instr(instrM),.IntReq(IntReq),.EXLSet(IntReq),.EXLClr(eretD),
						  .Din(WD),.exccode(exccode),.branch(branch),.exl(exl));	 
						  
						  
	 mux			_mux(.PrRD(PrRD),.DMoutM(DMoutM),.ALUoutM(ALUoutM),.FDMout(FDMout),.cp0Dout(cp0Dout),.instr(instrM));	  


	 MEM_WB     _MEM_WB(/*I*/.clk(clk),/*I*/.reset(reset),/*I*/ .instrM(instrM),.instrW(instrW),
								/*I*/ .ALUoutM(ALUoutM), .ALUoutW(ALUoutW),/*I*/ .DMoutM(FDMout),.DMoutW(DMoutW),
								.pc8M(pc8M) ,.pc8W(pc8W),.intclr(IntReq),.instrD(instrD),.instrE(instrE));
								
	 DataExt    _DataExt(.Addr(ALUoutW[1:0]),.Datain(DMoutW),.Dataout(Dataout),.instrW(instrW));												
								
					
	 WriteReg   _WriteReg(/*I*/ .instrW(instrW),/*I*/ .ALUoutW(ALUoutW),/*I*/ .DMoutW(Dataout), .pc8W(pc8W),
								.RegWData(RegWData), .RegWrite(RegWrite),.RegWAddr(RegWAddr));
									  			  
	 hazardunit _hazardunit(/*I*/ .instrD(instrD),/*I*/ .instrE(instrE),/*I*/ .instrM(instrM),/*I*/.instrW(instrW),
								.forwardAD(forwardAD), .forwardBD(forwardBD), .forwardAE(forwardAE), .forwardBE(forwardBE),
   							.forwardM(forwardM), .en_pc(en_pc),.en_IFID(en_IFID),.clr_IDEX(clr_IDEX),.busy(busy),
								.start(start),.clr_IFID(clr_IFID),.epcsel(epcsel),.clr_EXMEM(clr_EXMEM),.eretD(eretD),
								.instrF(instrF),.fderet(fderet));



endmodule
