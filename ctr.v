`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:16:27 11/23/2016 
// Design Name: 
// Module Name:    ctr 
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
module ctr(
    input [31:0] instr,
    output [1:0]MemtoReg,
    output ALUBsrc,
    output RegWrite,
    output MemWrite,
	 output ALUAsrc,
    output [1:0] PC_sel,
    output [1:0] ExtOp,
    output [3:0] ALUctr,
    output beq,
	 output [4:0]RegWAddr,
	 output bgezal,
	 output bne,
	 output movz,
	 output blez,
	 output bgez,
	 output bgtz,
	 output bltz,
	 output slt,
	 output slti,
	 output sltiu,
	 output sltu,
	 output sw,
	 output sh,
	 output sb,
	 output lw,
	 output lb,
	 output lbu,
	 output lh,
	 output lhu,
	 output mult,
	 output multu,
	 output div,
	 output divu,
	 output mfhi,
	 output mflo,
	 output mtlo,
	 output mthi,
	 output madd,
	 output eret,
	 output M,
	 output E
    );
	 `define op 31:26 
	 wire addu,add,addiu,addi,subu,sub,ori,lui,lw,sw,j,jal,jr,bgezal,
	      bne,beq,blez,bgtz,bltz,sll,srl,_and,_or,_xor,lb,lbu,lh,
			lhu,sb,sh,mult,multu,div,divu,sra,sllv,srlv,srav,
			_nor,andi,xori,slt,slti,sltiu,sltu,madd,seb,nop,
			bgez,jalr,mfhi,mflo,mthi,mtlo;
	 wire [1:0]MemtoReg;
	 wire [2:0]PC_sel;
	 wire [1:0]ExtOp;
	 wire [3:0]ALUctr;
	 wire [1:0]RegDst;
	 	  
	 assign M=RegWrite||beq||bne||blez||bgtz||bltz||bgez||j||jr;
	 assign E=sb||sw||sh||mult||multu||div||divu||mthi||mtlo||mtc0||nop;
	  
						  
	 assign addu=instr[`op]==0 && instr[10:0]==11'b00000100001;
	 assign subu=instr[`op]==0 && instr[10:0]==11'b00000100011;
	 assign lui=instr[`op]==6'b001111;
    assign ori=instr[`op]==6'b001101;
	 assign lw=instr[`op]==6'b100011;
	 assign sw=instr[`op]==6'b101011;
	 assign beq=instr[`op]==6'b000100;
	 assign j=instr[`op]==6'b000010;
	 assign jal=instr[`op]==6'b000011;
	 assign jr=instr[`op]==0 && instr[20:6]==0 && instr[5:0]==6'b001000;
	 assign addi=instr[`op]==6'b001000;
	 assign bgezal=instr[`op]==6'b000001 && instr[20:16]==5'b10001;
	 assign addiu=instr[`op]==6'b001001;
	 assign add=instr[`op]==0 && instr[10:0]==11'b00000100000;
	 assign sub=instr[`op]==0 && instr[10:0]==11'b00000100010;
	 assign _and=instr[`op]==0 && instr[10:0]==11'b00000100100;
	 assign _or=instr[`op]==0 && instr[10:0]==11'b00000100101;
	 assign _xor=instr[`op]==0 && instr[10:0]==11'b00000100110;
	 assign sll=instr[31:21]==0 && instr[5:0]==0;
	 assign srl=instr[31:21]==0 && instr[5:0]==6'b000010;
	 assign bne=instr[`op]==6'b000101;
	 assign movz=instr[`op]==0 && instr[10:6]==0 && instr[5:0]==6'b001010;
	 assign _nor=instr[`op]==0 && instr[10:0]==11'b00000100111;
	 assign andi=instr[`op]==6'b001100;
	 assign xori=instr[`op]==6'b001110;
	 assign bgtz=instr[`op]==6'b000111 && instr[20:16]==5'b00000;
	 assign bgez=instr[`op]==6'b000001 && instr[20:16]==5'b00001;
	 assign bltz=instr[`op]==6'b000001 && instr[20:16]==5'b00000;
	 assign blez=instr[`op]==6'b000110 && instr[20:16]==5'b00000;
	 assign sra=instr[31:21]==0 && instr[5:0]==6'b000011;
	 assign sllv=instr[`op]==0 && instr[10:6]==0 && instr[5:0]==6'b000100;
	 assign srlv=instr[`op]==0 && instr[10:6]==0 && instr[5:0]==6'b000110;
	 assign srav=instr[`op]==0 && instr[10:6]==0 && instr[5:0]==6'b000111;
	 assign jalr=instr[`op]==0 && instr[20:16]==0 && instr[10:6]==0 && instr[5:0]==6'b001001;
	 assign slt=instr[`op]==0 && instr[10:0]==11'b00000101010;
	 assign slti=instr[`op]==6'b001010;
	 assign sltiu=instr[`op]==6'b001011;
	 assign sltu=instr[`op]==0 && instr[10:0]==11'b00000101011;
	 assign lb=instr[`op]==6'b100000;
	 assign lh=instr[`op]==6'b100001;
	 assign lbu=instr[`op]==6'b100100;
	 assign lhu=instr[`op]==6'b100101;
	 assign sb=instr[`op]==6'b101000;
	 assign sh=instr[`op]==6'b101001;
	 assign mult=instr[`op]==0 && instr[15:6]==0 && instr[5:0]==6'b011000;
	 assign multu=instr[`op]==0 && instr[15:6]==0 && instr[5:0]==6'b011001;
	 assign div=instr[`op]==0 && instr[15:6]==0 && instr[5:0]==6'b011010;
	 assign divu=instr[`op]==0 && instr[15:6]==0 && instr[5:0]==6'b011011;
	 assign mfhi=instr[31:16]==0 && instr[10:6]==0 && instr[5:0]==6'b010000;
	 assign mflo=instr[31:16]==0 && instr[10:6]==0 && instr[5:0]==6'b010010;
	 assign mthi=instr[31:26]==0 && instr[20:6]==0 && instr[5:0]==6'b010001;
	 assign mtlo=instr[31:26]==0 && instr[20:6]==0 && instr[5:0]==6'b010011;
	 assign madd=instr[`op]==6'b011100 && instr[15:0]==0;
	 assign seb=instr[`op]==6'b011111 && instr[25:21]==0 && instr[10:0]==11'b10000100000;
	 assign mtc0=instr[31:21]==11'b01000000100 && instr[10:0]==0;
	 assign mfc0=instr[31:21]==11'b01000000000 && instr[10:0]==0;
	 assign eret=instr==32'h42000018;
	 assign nop=instr==0;

	//1.extctr
	 assign ExtOp=lui ? 0:
					  ori||xori||andi ? 1: 2;
	 

		
	//2.RegWrite
	 assign 	RegWrite=instr!=0 && (bgezal||addu||addi||add||addiu||sub||subu||lui||
											movz||ori||lw||jal||sll||srl||_and||_or||_xor||xori||
											andi||_nor||sra||srlv||sllv||srav||jalr||slt||slti||
											sltiu||sltu||lh||lb||lhu||lbu||mflo||mfhi||seb||mfc0);

		
		
	//3.RegDst
	 assign RegDst=jal||bgezal ? 2:
						lui||ori||lw||addi||addiu||xori||andi||slti||sltiu||lh||lb||lhu||lbu||mfc0 ? 0:1;
		
				
	//4.1 ALUBsrc
	 assign ALUBsrc=addi||addiu||lui||ori||lw||lh||lb||lhu||lbu||sw||sb||sh||xori||andi||slti||sltiu;
	 
	//4.2 ALUAsrc
	 assign ALUAsrc=sll||srl||sra;
		
		
	//5.ALUctr[3:0]
	 assign ALUctr=subu||sub ? 1:
						ori||_or  ? 2:
						_and||andi ? 3:
						_xor||xori ? 4:
						sll||sllv  ? 5:
						srl||srlv  ? 6:
						_nor       ? 7:
						sra||srav  ? 8:
						slt||slti||sltiu||sltu ? 9:
						seb        ? 10:0;

		
	//6.MemWrite
	 assign MemWrite=sw||sh||sb;
		
	//7.MemtoReg
	 assign MemtoReg=lw||lh||lb||lhu||lbu||mfc0      ? 1:
						  jal||bgezal||jalr               ? 2:0	;

		
	//8.PC_sel
	 assign PC_sel=eret       ? 4:
						jr||jalr         ? 2:
						beq||bgezal||bne||blez||bgtz||bltz||bgez ? 1:
						jal||j     ? 3:0;

   //9.RegWAddr
	assign RegWAddr=RegDst==1 ? instr[15:11]:
						 RegDst==2 ? 31 : instr[20:16];
						 
endmodule
