`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:50:42 12/19/2016 
// Design Name: 
// Module Name:    timecounter 
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
module timecounter(
    input clk,
    input reset,
    input [3:2] addr,
    input We,
    input [31:0] Datain,
    output [31:0] Dataout,
    output IRQ
    );
	 parameter 		load=4'b0001,
	 					counting=4'b0010,   //count--
						ready=4'b0100,
						interrupt=4'b1000;
						
	 `define  im ctrl[3] 
	 `define  mode ctrl[2:1] 
	 `define  enable ctrl[0] 						
	 reg [3:0]state0,state1;
	 reg [31:0]preset,count;
	 reg [31:0]ctrl;
	 reg irq;
	 //ctrl={ctrl[31:4],im,mode[1:0],enable}
	 assign IRQ=irq&&`im;
	 assign Dataout=  addr==0 ? ctrl : 
							addr==1 ? preset : count;
	 
	 initial begin
		ctrl<=0;
		count<=0;
		preset<=0;
		state0<=load;
		state1<=load;
	 end
	 always@(posedge clk)begin
		if(reset)begin
			ctrl<=0;
			count<=0;
			preset<=0;
			state0<=load;
			state1<=load;
		end
		else if(We)begin
			case(addr)
			1:preset<=Datain;
			0:ctrl[3:0]<=Datain[3:0];				 
			default :preset<=Datain;
			endcase
		end
		else begin
			if(`mode==0)begin
			if(`enable==0)state0<=ready;
			else begin
				case(state0)
				load: begin 
								count<=preset;
								state0<=counting;
								state1<=load;
								irq<=0;
						end
				counting:begin
							if(`enable)count<=count-1;
							if(count==1||count==0) state0<=interrupt;
						end
				interrupt:begin
							state0<=ready;
							irq<=1;
							`enable<=0;
						end
				ready:begin
							state0<=load;
						end
				default :state0<=load;
				endcase 
				end
			end
			else if(`mode==1)begin
				case(state1)
				load: begin
							state1<=counting;
							count<=preset;
							`im<=0;
							state0<=load;
						end
				counting:begin
							count<=count-1;
							if(count==1)begin 
								state1<=load;
								`im<=1;
							end
						end
				default: state1<=load;			
				endcase 
			end
		end
	 end


endmodule
