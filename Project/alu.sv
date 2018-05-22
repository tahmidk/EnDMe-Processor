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
	output logic [7:0] rslt_out,
	output zero_out
);

	// Convert op_ctrl signal to readable enumeration (e.g. 000 --> ADD)
	ALU_Ops op;
	assign op = ALU_Ops'(op_ctrl);

	// Main combinational logic
	always_comb
		begin
			// Initialize defaults
			rslt_out = 'd0;
			zero_out = 'd0;
		
			// Find which operation to execute using switch-case block
			case(op)
				// Addition
				ADD: 
					begin
						sum = reg_in + acc_in;
						rslt_out = sum[7:0];
					end
				// Subtraction
				SUB: 
					begin
						diff = reg_in - acc_in;
						if(diff == 0) begin
							zero_out = 1
						end
						else begin
							zero_out = 0
						end
					end
				// Logical shift left
				SLL: 
					rslt_out = acc_in << reg_in
				// Logical right shift
				SRL: 
					rslt_out = acc_in >> reg_in
				// Compare equality
				EQU:
					rslt_out = (acc_in == reg_in)
				// Compare greater than
				GTR:
					rslt_out = (reg_in > acc_in)
				// Bitwise AND
				AND:
					rslt_out = acc_in & reg_in
				// Bitwise XOR
				XOR:
					rslt_out = acc_in ^ reg_in
			endcase
		end

	
endmodule 
