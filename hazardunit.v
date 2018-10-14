`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:48:16 11/23/2016 
// Design Name: 
// Module Name:    hazardunit 
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
module hazardunit(
    input [31:0] instrD,
	input [31:0] instrF,
    input [31:0] instrE,
    input [31:0] instrM,
	input [31:0] instrW,
	input busy,
    output [3:0] forwardAD,
    output [3:0] forwardBD,
    output [3:0] forwardAE,
    output [3:0] forwardBE,
    output [1:0]forwardM,
    output en_pc,
    output en_IFID,
	output clr_IDEX,
	output clr_IFID,
	input start,
	output [1:0]epcsel,
	output clr_EXMEM,
	output eretD,
	output [1:0]fderet
	);
	
	
	
	wire jrD,beqD,bneD,bltzD,blezD,bgtzD,bgezD;
	wire adduD,subuD,luiD,oriD,lwD,swD,addD,addiuD,subD,sllD,srlD,_andD,_orD,_xorD,jalD,addiD,bgezalD,movzD,
		adduE,subuE,luiE,oriE,lwE,swE,addE,addiuE,subE,sllE,srlE,_andE,_orE,_xorE,jalE,addiE,bgezalE,movzE,
		adduM,subuM,luiM,oriM,lwM,swM,addM,addiuM,subM,sllM,srlM,_andM,_orM,_xorM,jalM,addiM,bgezalM,movzM,
		adduW,subuW,luiW,oriW,lwW,    addW,addiuW,subW,sllW,srlW,_andW,_orW,_xorW,jalW,addiW,bgezalW,movzW,
		_norD,xoriD,andiD,sraD,sllvD,srlvD,sravD,jalrD,sltD,sltiD,sltiuD,sltuD,lbD,lbuD,lhD,lhuD,sbD,shD,eretD,eretF,
		_norE,xoriE,andiE,sraE,sllvE,srlvE,sravE,jalrE,sltE,sltiE,sltiuE,sltuE,lbE,lbuE,lhE,lhuE,sbE,shE,
		_norM,xoriM,andiM,sraM,sllvM,srlvM,sravM,jalrM,sltM,sltiM,sltiuM,sltuM,lbM,lbuM,lhM,lhuM,sbM,shM,eretM,
		_norW,xoriW,andiW,sraW,sllvW,srlvW,sravW,jalrW,sltW,sltiW,sltiuW,sltuW,lbW,lbuW,lhW,lhuW			,
		multD,multuD,divD,divuD,mfloD,mfhiD,mtloD,mthiD,sebD,mfc0D,mtc0D,
		multE,multuE,divE,divuE,mfloE,mfhiE,mtloE,mthiE,sebE,mfc0E,mtc0E,
								mfloM,mfhiM            ,sebM,mfc0M,mtc0M,
								mfloW,mfhiW            ,sebW,mfc0W      ;

			
		
		
	wire calrD,caliD,ldD,stD,
		calrE,caliE,ldE,stE,
		calrM,caliM,ldM,stM,
		calrW,caliW,ldW;
	wire bt,mdD,mdE; //beqtype,jrtype
	wire stall,stallrsrt,stallcalr,stallcali,stallld,stallst,stallrs,stallrt,stallmd;
	wire AD,BD,AE,BE; 
	wire mdfE,mdfM,mdfW,mdtD,mdtE;
	wire maddD,maddE;
	

	`define op 31:26
	`define rs 25:21
	`define rt 20:16
	`define rd 15:11
	
	assign bt=beqD||bneD||bltzD||blezD||bgtzD||bgezD;
	assign mdtD=mtloD || mthiD;
	assign mdtE=mtloE || mthiE;
	assign calrD=adduD||subuD||addD||subD||_orD||_xorD||_andD||sllD||srlD||movzD||_norD||
					sraD||sllvD||srlvD||sravD||sltD||sltuD||sebD;
	assign caliD=oriD||addiD||addiuD||andiD||xoriD||sltiD||sltiuD||andiD;
	assign ldD=lwD||lbD||lbuD||lhD||lhuD||mfc0D;
	assign stD=swD||sbD||shD;
	assign calrE=adduE||subuE||addE||subE||_orE||_xorE||_andE||sllE||srlE||movzE||_norE||
					sraE||sllvE||srlvE||sravE||sltE||sltuE||mfloE||mfhiE||sebE;
	assign caliE=oriE||addiE||addiuE||andiE||xoriE||sltiE||sltiuE||andiE;
	assign ldE=lwE||lbE||lbuE||lhE||lhuE||mfc0E;
	assign stE=swE||sbE||shE;
	assign calrM=adduM||subuM||addM||subM||_orM||_xorM||_andM||sllM||srlM||movzM||_norM||
					sraM||sllvM||srlvM||sravM||sltM||sltuM||mfloM||mfhiM||sebM;
	assign caliM=oriM||addiM||addiuM||andiM||xoriM||sltiM||sltiuM||andiM;
	assign ldM=lwM||lbM||lbuM||lhM||lhuM||mfc0M;
	assign stM=swM||sbM||shM;
	assign calrW=adduW||subuW||addW||subW||_orW||_xorW||_andW||sllW||srlW||movzW||_norW||
					sraW||sllvW||srlvW||sravW||sltW||sltuW||mfloW||mfhiW||sebW;
	assign caliW=oriW||addiW||addiuW||andiW||xoriW||sltiW||sltiuW||andiW;
	assign ldW=lwW||lbW||lbuW||lhW||lhuW||mfc0W;
	assign stall=stallrsrt||stallcalr||stallcali||stallld||stallst||stallrs||stallrt||stallmd;
	assign en_pc=!stall&&!stalleret;
	assign clr_IFID=stalleret;
	assign clr_IDEX=stall;
	assign clr_EXMEM=0;
	assign en_IFID=!stall;
	assign mdD=multD || multuD || divD || divuD;
	assign mdE=multE || multuE || divE || divuE;

	assign stallcalr=(calrD || mdD || maddD) && ldE && (instrD[`rs]==instrE[`rt] && instrD[`rs]!=0 ||   
								instrD[`rt]==instrE[`rt]&& instrD[`rt]!=0) ;
	
	assign stallcali=(caliD || mdtD)&& ldE && instrD[`rs]==instrE[`rt] && instrD[`rs]!=0;
	
	assign stallld=ldD && ldE && instrD[`rs]==instrE[`rt] && instrD[`rs]!=0;
	
	assign stallst=stD && ldE && instrD[`rs]==instrE[`rt] && instrD[`rs]!=0;

	assign stalleret=eretF && mtc0D && (instrD[`rd]==14) && (mfc0E||ldE);


	assign stallrsrt=bt && (ldE && instrD[`rs]==instrE[`rt] && instrD[`rs]!=0 || 
								ldE && instrD[`rt]==instrE[`rt] && instrD[`rt]!=0||
								(calrE) && instrD[`rs]==instrE[`rd] && instrD[`rs]!=0|| 	
								(calrE) && instrD[`rt]==instrE[`rd] && instrD[`rt]!=0||
								(caliE || luiE) && instrD[`rs]==instrE[`rt] && instrD[`rs]!=0||	
								(caliE || luiE) && instrD[`rt]==instrE[`rt] && instrD[`rt]!=0||
								ldM && instrD[`rs]==instrM[`rt] && instrD[`rs]!=0||	
								ldM && instrD[`rt]==instrM[`rt] && instrD[`rt]!=0) ;
								
	assign stallrs= (jrD || bgezalD || jalrD) && instrD[`rs]!=0 && (ldE && instrD[`rs]==instrE[`rt] || 
														(calrE) && instrD[`rs]==instrE[`rd] ||
														(caliE || luiE) && instrD[`rs]==instrE[`rt] || 
														ldM && instrD[`rs]==instrM[`rt]);
														
												
	assign stallrt=(movzD) && instrD[`rt]!=0 && (ldE && instrD[`rt]==instrE[`rt] || 
														(calrE) && instrD[`rt]==instrE[`rd] ||
														(caliE || luiE) && instrD[`rt]==instrE[`rt] || 
														ldM && instrD[`rt]==instrM[`rt]);
														

	assign stallmd=(multD || multuD || divD || divuD || mfloD || mfhiD || mthiD || mtloD) && (start || busy);

	assign AD=bt||calrD||caliD||ldD||stD||jrD||bgezalD||jalrD||mdD||mdtD||maddD;
		
	assign forwardAD= instrD[`rs]==0 ? 0 :
							AD && (jalE  ||  bgezalE ) && instrD[`rs]==31?1:
							AD && jalrE && instrD[`rs]==instrE[`rd]?1:
							AD && (calrM) && instrD[`rs]==instrM[`rd]?2:
							AD && (caliM || luiM) && instrD[`rs]==instrM[`rt]?2:
							AD &&  jalrM && instrD[`rs]==instrM[`rd]?3:
							AD && (jalM  ||  bgezalM ) && instrD[`rs]==31?3:
							AD && (calrW) && instrD[`rs]==instrW[`rd]?4:
							AD && (caliW || ldW || luiW) && instrD[`rs]==instrW[`rt]?4:
							AD &&  jalrW && instrD[`rs]==instrW[`rd]?5:
							AD && (jalW  ||  bgezalW ) && instrD[`rs]==31?5:0;
							 
	assign BD=bt||calrD||stD||mdD||maddD||mtc0D;
	 
    assign forwardBD=  instrD[`rt]==0 ? 0 :                      
							 BD && (jalE  ||  bgezalE ) && instrD[`rt]==31?1:
							 BD && jalrE && instrD[`rt]==instrE[`rd]?1:
							 BD && (calrM) && instrD[`rt]==instrM[`rd]?2:
							 BD && (caliM || luiM) && instrD[`rt]==instrM[`rt]?2:
							 BD &&  jalrM && instrD[`rt]==instrM[`rd]?3:
							 BD && (jalM  ||  bgezalM ) && instrD[`rt]==31?3:
							 BD && (calrW) && instrD[`rt]==instrW[`rd]?4:
							 BD && (caliW || ldW || luiW) && instrD[`rt]==instrW[`rt]?4:
							 BD &&  jalrW && instrD[`rt]==instrW[`rd]?5:
							 BD && (jalW  ||  bgezalW ) && instrD[`rt]==31?5:0;
							 					 
	 
	assign fderet=mtc0E && instrE[`rd]==14 ? 1 :
						mtc0M && instrM[`rd]==14 ? 2 : 0;
	 
	//rs:calrE||caliE||ldE||stE
	assign AE=calrE||caliE||ldE||stE||mdE||mdtE||maddE;
    assign forwardAE= instrE[`rs]==0 ? 0 :         
							 AE && (calrM) && instrE[`rs]==instrM[`rd]?1:                       
							 AE && (caliM || luiM) && instrE[`rs]==instrM[`rt]?1:
							 AE &&  ldW  && instrE[`rs]==instrW[`rt]?2:0;
					
	assign BE=calrE||stE||mdE||maddE||mtc0E;
    assign forwardBE= instrE[`rt]==0 ? 0 :         
							 BE && (calrM) && instrE[`rt]==instrM[`rd]?1:
							 BE && (caliM || luiM) && instrE[`rt]==instrM[`rt]?1:
						    BE && ldW  && instrE[`rt]==instrW[`rt]?2:0; 
							 
    assign forwardM= instrM[`rt]==0 ? 0 :            
							(stM || mtc0M) && ldW && instrM[`rt]==instrW[`rt]?1:0;
	 
	 
	 
	assign epcsel= mtc0E && instrE[`rd]==14 ? 1 :
						 mtc0M && instrM[`rd]==14 ? 2 : 0;
	 
	 
	///////////////////////////////////////////////////////////////////////////////////////////////	 
	assign eretF=instrF==32'h42000018;

	assign adduD=instrD[`op]==0 && instrD[10:0]==11'b00000100001;
	assign subuD=instrD[`op]==0 && instrD[10:0]==11'b00000100011;
	assign luiD=instrD[`op]==6'b001111;
	assign oriD=instrD[`op]==6'b001101;
	assign lwD=instrD[`op]==6'b100011;
	assign swD=instrD[`op]==6'b101011;
	assign beqD=instrD[`op]==6'b000100;
	assign jalD=instrD[`op]==6'b000011;
	assign jrD=instrD[`op]==0 && instrD[20:6]==0 && instrD[5:0]==6'b001000;
	assign addiD=instrD[`op]==6'b001000;
	assign bgezalD=instrD[`op]==6'b000001 && instrD[20:16]==5'b10001;
	assign addiuD=instrD[`op]==6'b001001;
	assign addD=instrD[`op]==0 && instrD[10:0]==11'b00000100000;
	assign subD=instrD[`op]==0 && instrD[10:0]==11'b00000100010;
	assign _andD=instrD[`op]==0 && instrD[10:0]==11'b00000100100;
	assign _orD=instrD[`op]==0 && instrD[10:0]==11'b00000100101;
	assign _xorD=instrD[`op]==0 && instrD[10:0]==11'b00000100110;
	assign sllD=instrD[31:21]==0 && instrD[5:0]==0;
	assign srlD=instrD[31:21]==0 && instrD[5:0]==6'b000010;
	assign bneD=instrD[`op]==6'b000101;
	assign movzD=instrD[`op]==0 && instrD[10:6]==0 && instrD[5:0]==6'b001010;
	assign _norD=instrD[`op]==0 && instrD[10:0]==11'b00000100111;
	assign andiD=instrD[`op]==6'b001100;
	assign xoriD=instrD[`op]==6'b001110;
	assign bgtzD=instrD[`op]==6'b000111 && instrD[20:16]==5'b00000;
	assign bgezD=instrD[`op]==6'b000001 && instrD[20:16]==5'b00001;
	assign bltzD=instrD[`op]==6'b000001 && instrD[20:16]==5'b00000;
	assign blezD=instrD[`op]==6'b000110 && instrD[20:16]==5'b00000;
	assign sraD=instrD[31:21]==0 && instrD[5:0]==6'b000011;
	assign sllvD=instrD[`op]==0 && instrD[10:6]==0 && instrD[5:0]==6'b000100;
	assign srlvD=instrD[`op]==0 && instrD[10:6]==0 && instrD[5:0]==6'b000110;
	assign sravD=instrD[`op]==0 && instrD[10:6]==0 && instrD[5:0]==6'b000111;
	assign jalrD=instrD[`op]==0 && instrD[20:16]==0 && instrD[10:6]==0 && instrD[5:0]==6'b001001;
	assign sltD=instrD[`op]==0 && instrD[10:0]==11'b00000101010;
	assign sltiD=instrD[`op]==6'b001010;
	assign sltiuD=instrD[`op]==6'b001011;
	assign sltuD=instrD[`op]==0 && instrD[10:0]==11'b00000101011;
	assign lbD=instrD[`op]==6'b100000;
	assign lhD=instrD[`op]==6'b100001;
	assign lbuD=instrD[`op]==6'b100100;
	assign lhuD=instrD[`op]==6'b100101;
	assign sbD=instrD[`op]==6'b101000;
	assign shD=instrD[`op]==6'b101001;	 
	assign multD=instrD[`op]==0 && instrD[15:6]==0 && instrD[5:0]==6'b011000;
	assign multuD=instrD[`op]==0 && instrD[15:6]==0 && instrD[5:0]==6'b011001;
	assign divD=instrD[`op]==0 && instrD[15:6]==0 && instrD[5:0]==6'b011010;
	assign divuD=instrD[`op]==0 && instrD[15:6]==0 && instrD[5:0]==6'b011011;
	assign mthiD=instrD[31:26]==0 && instrD[20:6]==0 && instrD[5:0]==6'b010001;
	assign mtloD=instrD[31:26]==0 && instrD[20:6]==0 && instrD[5:0]==6'b010011;
	assign mfhiD=instrD[31:16]==0 && instrD[10:6]==0 && instrD[5:0]==6'b010000;
	assign mfloD=instrD[31:16]==0 && instrD[10:6]==0 && instrD[5:0]==6'b010010;
	assign maddD=instrD[`op]==6'b011100 && instrD[15:0]==0;
	assign sebD=instrD[`op]==6'b011111 && instrD[25:21]==0 && instrD[10:0]==11'b10000100000;
	assign eretD=instrD==32'h42000018;
	assign mtc0D=instrD[31:21]==11'b01000000100 && instrD[10:0]==0;
	assign mfc0D=instrD[31:21]==11'b01000000000 && instrD[10:0]==0;

	///////////////////////////////////////////////////////////////////////////////////////////////	 

	assign adduE=instrE[`op]==0 && instrE[10:0]==11'b00000100001;
	assign subuE=instrE[`op]==0 && instrE[10:0]==11'b00000100011;
	assign luiE=instrE[`op]==6'b001111;
	assign oriE=instrE[`op]==6'b001101;
	assign lwE=instrE[`op]==6'b100011;
	assign swE=instrE[`op]==6'b101011;
	assign jalE=instrE[`op]==6'b000011;
	assign addiE=instrE[`op]==6'b001000;
	assign bgezalE=instrE[`op]==6'b000001 && instrE[20:16]==5'b10001;
	assign addiuE=instrE[`op]==6'b001001;
	assign addE=instrE[`op]==0 && instrE[10:0]==11'b00000100000;
	assign subE=instrE[`op]==0 && instrE[10:0]==11'b00000100010;
	assign _andE=instrE[`op]==0 && instrE[10:0]==11'b00000100100;
	assign _orE=instrE[`op]==0 && instrE[10:0]==11'b00000100101;
	assign _xorE=instrE[`op]==0 && instrE[10:0]==11'b00000100110;
	assign sllE=instrE[31:21]==0 && instrE[5:0]==0;
	assign srlE=instrE[31:21]==0 && instrE[5:0]==6'b000010;
	assign movzE=instrE[`op]==0 && instrE[10:6]==0 && instrE[5:0]==6'b001010;
	assign _norE=instrE[`op]==0 && instrE[10:0]==11'b00000100111;
	assign andiE=instrE[`op]==6'b001100;
	assign xoriE=instrE[`op]==6'b001110;
	assign sraE=instrE[31:21]==0 && instrE[5:0]==6'b000011;
	assign sllvE=instrE[`op]==0 && instrE[10:6]==0 && instrE[5:0]==6'b000100;
	assign srlvE=instrE[`op]==0 && instrE[10:6]==0 && instrE[5:0]==6'b000110;
	assign sravE=instrE[`op]==0 && instrE[10:6]==0 && instrE[5:0]==6'b000111;
	assign jalrE=instrE[`op]==0 && instrE[20:16]==0 && instrE[10:6]==0 && instrE[5:0]==6'b001001;
	assign sltE=instrE[`op]==0 && instrE[10:0]==11'b00000101010;
	assign sltiE=instrE[`op]==6'b001010;
	assign sltiuE=instrE[`op]==6'b001011;
	assign sltuE=instrE[`op]==0 && instrE[10:0]==11'b00000101011;	
	assign lbE=instrE[`op]==6'b100000;
	assign lhE=instrE[`op]==6'b100001;
	assign lbuE=instrE[`op]==6'b100100;
	assign lhuE=instrE[`op]==6'b100101;
	assign sbE=instrE[`op]==6'b101000;
	assign shE=instrE[`op]==6'b101001;	 
	assign mfhiE=instrE[31:16]==0 && instrE[10:6]==0 && instrE[5:0]==6'b010000;
	assign mfloE=instrE[31:16]==0 && instrE[10:6]==0 && instrE[5:0]==6'b010010;
	assign mthiE=instrE[31:26]==0 && instrE[20:6]==0 && instrE[5:0]==6'b010001;
	assign mtloE=instrE[31:26]==0 && instrE[20:6]==0 && instrE[5:0]==6'b010011;
	assign multE=instrE[`op]==0 && instrE[15:6]==0 && instrE[5:0]==6'b011000;
	assign multuE=instrE[`op]==0 && instrE[15:6]==0 && instrE[5:0]==6'b011001;
	assign divE=instrE[`op]==0 && instrE[15:6]==0 && instrE[5:0]==6'b011010;
	assign divuE=instrE[`op]==0 && instrE[15:6]==0 && instrE[5:0]==6'b011011;
	assign maddE=instrE[`op]==6'b011100 && instrE[15:0]==0;
	assign sebE=instrE[`op]==6'b011111 && instrE[25:21]==0 && instrE[10:0]==11'b10000100000;	 
	assign mtc0E=instrE[31:21]==11'b01000000100 && instrE[10:0]==0;
	assign mfc0E=instrE[31:21]==11'b01000000000 && instrE[10:0]==0;
	 
	 
	 
	///////////////////////////////////////////////////////////////////////////////////////////////	 

	assign adduM=instrM[`op]==0 && instrM[10:0]==11'b00000100001;
	assign subuM=instrM[`op]==0 && instrM[10:0]==11'b00000100011;
	assign luiM=instrM[`op]==6'b001111;
	assign oriM=instrM[`op]==6'b001101;
	assign lwM=instrM[`op]==6'b100011;
	assign swM=instrM[`op]==6'b101011;
	assign jalM=instrM[`op]==6'b000011;
	assign addiM=instrM[`op]==6'b001000;
	assign bgezalM=instrM[`op]==6'b000001 && instrM[20:16]==5'b10001;
	assign addiuM=instrM[`op]==6'b001001;
	assign addM=instrM[`op]==0 && instrM[10:0]==11'b00000100000;
	assign subM=instrM[`op]==0 && instrM[10:0]==11'b00000100010;
	assign _andM=instrM[`op]==0 && instrM[10:0]==11'b00000100100;
	assign _orM=instrM[`op]==0 && instrM[10:0]==11'b00000100101;
	assign _xorM=instrM[`op]==0 && instrM[10:0]==11'b00000100110;
	assign sllM=instrM[31:21]==0 && instrM[5:0]==0;
	assign srlM=instrM[31:21]==0 && instrM[5:0]==6'b000010;
	assign movzM=instrM[`op]==0 && instrM[10:6]==0 && instrM[5:0]==6'b001010;
	assign _norM=instrM[`op]==0 && instrM[10:0]==11'b00000100111;
	assign andiM=instrM[`op]==6'b001100;
	assign xoriM=instrM[`op]==6'b001110;
	assign sraM=instrM[31:21]==0 && instrM[5:0]==6'b000011;
	assign sllvM=instrM[`op]==0 && instrM[10:6]==0 && instrM[5:0]==6'b000100;
	assign srlvM=instrM[`op]==0 && instrM[10:6]==0 && instrM[5:0]==6'b000110;
	assign sravM=instrM[`op]==0 && instrM[10:6]==0 && instrM[5:0]==6'b000111;		 
	assign jalrM=instrM[`op]==0 && instrM[20:16]==0 && instrM[10:6]==0 && instrM[5:0]==6'b001001;
	assign sltM=instrM[`op]==0 && instrM[10:0]==11'b00000101010;
	assign sltiM=instrM[`op]==6'b001010;
	assign sltiuM=instrM[`op]==6'b001011;
	assign sltuM=instrM[`op]==0 && instrM[10:0]==11'b00000101011;	
	assign lbM=instrM[`op]==6'b100000;
	assign lhM=instrM[`op]==6'b100001;
	assign lbuM=instrM[`op]==6'b100100;
	assign lhuM=instrM[`op]==6'b100101;
	assign sbM=instrM[`op]==6'b101000;
	assign shM=instrM[`op]==6'b101001;
	assign mfhiM=instrM[31:16]==0 && instrM[10:6]==0 && instrM[5:0]==6'b010000;
	assign mfloM=instrM[31:16]==0 && instrM[10:6]==0 && instrM[5:0]==6'b010010;
	assign sebM=instrM[`op]==6'b011111 && instrM[25:21]==0 && instrM[10:0]==11'b10000100000;
	assign mtc0M=instrM[31:21]==11'b01000000100 && instrM[10:0]==0;
	assign mfc0M=instrM[31:21]==11'b01000000000 && instrM[10:0]==0;
	assign eretM=instrM==32'h42000018;


	///////////////////////////////////////////////////////////////////////////////////////////////	 

	assign adduW=instrW[`op]==0 && instrW[10:0]==11'b00000100001;
	assign subuW=instrW[`op]==0 && instrW[10:0]==11'b00000100011;
	assign luiW=instrW[`op]==6'b001111;
	assign oriW=instrW[`op]==6'b001101;
	assign lwW=instrW[`op]==6'b100011;
	assign swW=instrW[`op]==6'b101011;
	assign jalW=instrW[`op]==6'b000011;
	assign addiW=instrW[`op]==6'b001000;
	assign bgezalW=instrW[`op]==6'b000001 && instrW[20:16]==5'b10001;
	assign addiuW=instrW[`op]==6'b001001;
	assign addW=instrW[`op]==0 && instrW[10:0]==11'b00000100000;
	assign subW=instrW[`op]==0 && instrW[10:0]==11'b00000100010;
	assign _andW=instrW[`op]==0 && instrW[10:0]==11'b00000100100;
	assign _orW=instrW[`op]==0 && instrW[10:0]==11'b00000100101;
	assign _xorW=instrW[`op]==0 && instrW[10:0]==11'b00000100110;
	assign sllW=instrW[31:21]==0 && instrW[5:0]==0;
	assign srlW=instrW[31:21]==0 && instrW[5:0]==6'b000010;
	assign movzW=instrW[`op]==0 && instrW[10:6]==0 && instrW[5:0]==6'b001010;
	assign _norW=instrW[`op]==0 && instrW[10:0]==11'b00000100111;
	assign andiW=instrW[`op]==6'b001100;
	assign xoriW=instrW[`op]==6'b001110;
	assign sraW=instrW[31:21]==0 && instrW[5:0]==6'b000011;
	assign sllvW=instrW[`op]==0 && instrW[10:6]==0 && instrW[5:0]==6'b000100;
	assign srlvW=instrW[`op]==0 && instrW[10:6]==0 && instrW[5:0]==6'b000110;
	assign sravW=instrW[`op]==0 && instrW[10:6]==0 && instrW[5:0]==6'b000111;
	assign jalrW=instrW[`op]==0 && instrW[20:16]==0 && instrW[10:6]==0 && instrW[5:0]==6'b001001;	 
	assign sltW=instrW[`op]==0 && instrW[10:0]==11'b00000101010;
	assign sltiW=instrW[`op]==6'b001010;
	assign sltiuW=instrW[`op]==6'b001011;
	assign sltuW=instrW[`op]==0 && instrW[10:0]==11'b00000101011;	 
	assign lbW=instrW[`op]==6'b100000;
	assign lhW=instrW[`op]==6'b100001;
	assign lbuW=instrW[`op]==6'b100100;
	assign lhuW=instrW[`op]==6'b100101;
	assign mfhiW=instrW[31:16]==0 && instrW[10:6]==0 && instrW[5:0]==6'b010000;
	assign mfloW=instrW[31:16]==0 && instrW[10:6]==0 && instrW[5:0]==6'b010010;
	assign sebW=instrW[`op]==6'b011111 && instrW[25:21]==0 && instrW[10:0]==11'b10000100000;
	assign mfc0W=instrW[31:21]==11'b01000000000 && instrW[10:0]==0;
	 

endmodule
