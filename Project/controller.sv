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
 *		accdata_ctrl - the accumulator data-in control signal generated (2-bits)
 *		accwrite_ctrl - accumulator write control signal
 ---------------------------------------------------------------------*/
import definitions::*;

module controller(
	input TYP,
	input [3:0] OP,
	output br_ctrl,
	output regwrite_ctrl,
	output [2:0] aluop_ctrl,
	output memwrite_ctrl,
	output [1:0] accdata_ctrl,
	output accwrite_ctrl
);

	// Enumerate op code into an instruction 
	Instr_O instr;
	assign instr = Instr_O'(OP);

	always_comb
		begin
			// Temporary defaults
			br_ctrl <= 1'b0;
			regwrite_ctrl <= 1'b0;
			aluop_ctrl <= 3'b000;
			memwrite_ctrl <= 1'b0;
			accdata_ctrl <= 2'b00;
			accwrite_ctrl <= 1'b0;
		
			// Instruction is M-type save
			if(TYP == 1)
				begin
					br_ctrl <= 1'b0;
					regwrite_ctrl <= 1'b0;
					aluop_ctrl <= 3'b000;
					memwrite_ctrl <= 1'b0;
					accdata_ctrl <= 2'b00;
					accwrite_ctrl <= 1'b1;
				end
			// Instruction is O-type operation
			else
				case(instr)
					STORE: begin
						
					end
					LB: begin
						
					end
					SB: begin
					
					end
					PUT: begin
					
					end
					BTR:begin
					
					end
					JMP: begin
					
					end
					ADD: begin
					
					end
					SUB: begin
					
					end
					AND: begin
					
					end
					XOR: begin
					
					end
					SFL: begin
					
					end
					SFR: begin
					
					end
					CMP: begin
					
					end
					GTR: begin
					
					end
				endcase
		end

endmodule