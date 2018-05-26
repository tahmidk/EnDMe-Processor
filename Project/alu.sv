/**---------------------------------------------------------------------
 *	Module:		Arithmetic Logic Unit
 *	Class:		CSE 141L - SP18
 * Authors: 	Tahmid Khan
 *					Shengyuan Lin
 *----------------------------------------------------------------------
 *	[Inputs]
 * 	reg_in - the data wire from the register file (8-bits)
 * 	acc_in - the output wire from the accumulator (8-bits)
 *		op_ctrl - the control wire dictating what op to execute (3-bits)
 *
 * [Outputs]
 * 	rslt_out - the result of the ALU operation (8-bits)
 *		zero_out - the zero control signal for branching (1-bit)
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
			Sll: 
				rslt_out = acc_in << reg_in;
			// Logical right shift
			Srl: 
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
	reg [2:0] op;
	// Output
	wire [7:0] rslt;
	
	
	// Make the module
	alu ALU(
		.reg_in(reg_in),
		.acc_in(acc_in),
		.op_ctrl(op),
		.rslt_out(rslt)
	);
	
	
	// The testbench
	initial begin
		reg_in <= 4;
		acc_in <= 8;
		
		// 
	end

endmodule
