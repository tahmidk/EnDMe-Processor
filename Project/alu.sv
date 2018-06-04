/**---------------------------------------------------------------------
 *	Module:		Arithmetic Logic Unit
 *	Class:		CSE 141L - SP18
 * Authors: 	Tahmid Khan
 *					Shengyuan Lin
 *----------------------------------------------------------------------
 *	[Inputs]
 * 	reg_in	the data wire from the register file (8-bits)
 * 	acc_in	the output wire from the accumulator (8-bits)
 *		op_ctrl	the control wire dictating what op to execute (3-bits)
 *
 * [Outputs]
 * 	rslt_out	the result of the ALU operation (8-bits)
 * 
 ---------------------------------------------------------------------*/

import definitions::*;

module alu (
	input [7:0] reg_in,
	input [7:0] acc_in,
	input [2:0] op_ctrl,
	output logic [7:0] rslt_out
);

	// Convert op_ctrl signal to readable enumeration (e.g. 000 --> ADD)
	ALU_Ops op;
	assign op = ALU_Ops'(op_ctrl);

	// Main combinational logic
	always_comb begin
		// Initialize defaults
		rslt_out = 'd0;
	
		// Find which operation to execute using switch-case block
		case(op)
			// Addition
			Add: 
				rslt_out = reg_in + acc_in;
			// Subtraction
			Sub: 
				rslt_out = reg_in - acc_in;
			// Logical shift left
			Sfl: 
				rslt_out = acc_in << reg_in;
			// Logical right shift
			Sfr: 
				rslt_out = acc_in >> reg_in;
			// Compare equality
			Equ:
				rslt_out = (acc_in == reg_in);
			// Compare greater than
			Gtr:
				rslt_out = (reg_in > acc_in);
			// Bitwise AND
			And:
				rslt_out = acc_in & reg_in;
			// Bitwise XOR
			Xor:
				rslt_out = acc_in ^ reg_in;
		endcase
	end

endmodule 


// ALU Testbench
module tb_alu();

	// Data lines
	reg [7:0] reg_in;
	reg [7:0] acc_in;
	// Control
	reg [2:0] op_ctrl;
	// Output
	wire [7:0] rslt;
	
	// So op_ctrl will be displayed as Add or Sub instead of 000 or 001 in ModelSim
	ALU_Ops op;
	assign op = ALU_Ops'(op_ctrl);
	
	// Make the module
	alu ALU(
		.reg_in(reg_in),
		.acc_in(acc_in),
		.op_ctrl(op_ctrl),
		.rslt_out(rslt)
	);
	
	
	// The testbench
	initial begin
		$monitor("Reg = %d, Acc = %d | Op Ctrl = %s | Output = %d", reg_in, acc_in, op, rslt);
		
			reg_in <= 'd4; acc_in <= 'd1; op_ctrl <= Add;	// 4 + 1 = 5
		#5 reg_in <= 'd4; acc_in <= 'd1; op_ctrl <= Sub;	// 4 - 1 = 3
		#5 reg_in <= 'd1; acc_in <= 'd4; op_ctrl <= Sub;	// 1 - 4 = -3
		#5 reg_in <= 'd2; acc_in <= 'd4; op_ctrl <= Sfl;	// 4 << 2 = 16
		#5 reg_in <= 'd2; acc_in <= 'd4; op_ctrl <= Sfr;	// 4 >> 2 = 1
		#5 reg_in <= 'd4; acc_in <= 'd4; op_ctrl <= Equ;	// 4 == 4 = 1
		#5 reg_in <= 'd0; acc_in <= 'd4; op_ctrl <= Equ;	// 0 == 4 = 0
		#5 reg_in <= 'd4; acc_in <= 'd1; op_ctrl <= Gtr;	// 4 > 1 = 1
		#5 reg_in <= 'd1; acc_in <= 'd4; op_ctrl <= Gtr;	// 1 > 4 = 0
		#5 reg_in <= 'd1; acc_in <= 'd1; op_ctrl <= Gtr;	// 1 > 1 = 0
		#5 reg_in <= 'd4; acc_in <= 'd255; op_ctrl <= And;	// 4 & 255 = 4
		#5 reg_in <= 'd3; acc_in <= 'd1; op_ctrl <= Xor;	// 3 XOR 1 = 2
		
		#5 $stop;
	end

endmodule
