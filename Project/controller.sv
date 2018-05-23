/**---------------------------------------------------------------------
 *	Module:		Control Unit
 *	Class:		CSE 141L - SP18
 * Authors: 	Tahmid Khan
 *					Shengyuan Lin
 *----------------------------------------------------------------------
 *	[Input]
 *		TYP - the MSB of the instruction determining type (1-bit)
 *		OP - the opcode bits of the instruction (4-bits)
 *
 *	[Output]
 *		br_ctrl - the branch control signal generated (1-bit)
 *		regwrite_ctrl - the register write control signal generated (1-bit)
 *		aluop_ctrl - the alu operation control signal generated (3-bits)
 *		memwrite_ctrl - the memory write control signal generated (1-bit)
 *		acc_ctrl - the accumulator data-in control signal generated (2-bits)
 ---------------------------------------------------------------------*/

module controller(
	input TYP,
	input [3:0] OP,
	output br_ctrl,
	output regwrite_ctrl,
	output [2:0] aluop_ctrl,
	output memwrite_ctrl,
	output [1:0] acc_ctrl
);

	always_comb
		begin
			// Instruction is M-type save
			if(TYP == 1)
				begin
					br_ctrl = 1'b0
					regwrite_ctrl = 1'b0
					aluop_ctrl = 3'b000
					memwrite_ctrl = 1'b0
					acc_ctrl = 2b'0
				end
			// Instruction is O-type operation
			else
				case(OP)
					// All possible op codes
				endcase
		end

endmodule