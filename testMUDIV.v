`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:00:44 12/07/2016
// Design Name:   MUDIV
// Module Name:   F:/verilog/project/P6/testMUDIV.v
// Project Name:  P6
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: MUDIV
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testMUDIV;

	// Inputs
	reg clk;
	reg reset;
	reg [31:0] instrE;
	reg [31:0] RegDataE1;
	reg [31:0] RegDataE2;
	// Outputs
	wire [31:0] mudivout;

	// Instantiate the Unit Under Test (UUT)
	MUDIV uut (
		.clk(clk), 
		.reset(reset), 
		.instrE(instrE), 
		.RegDataE1(RegDataE1), 
		.RegDataE2(RegDataE2), 
		.mudivout(mudivout)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		instrE = 0;
		RegDataE1 = 32'hffff0000;
		RegDataE2 = 32'h00000002;

		// Wait 100 ns for global reset to finish
		#105;
		instrE=32'h00a60018;
		#10;
		instrE=0;
				#100;
		instrE=32'h00a60019;
		#10;
		instrE=0;
		#100;
		instrE=32'h00a6001a;
		#10;
		instrE=0;
				#100;
		instrE=32'h00a6001b;
		#10;
		instrE=0;
		// Add stimulus here

	end
	
	always #5 clk=~clk;
      
endmodule

