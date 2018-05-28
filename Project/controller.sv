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
 *		jmp_ctrl - the jump control signal generated (1-bit)
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
	output reg br_ctrl,
	output reg jmp_ctrl,
	output reg regwrite_ctrl,
	output reg [2:0] aluop_ctrl,
	output reg memwrite_ctrl,
	output reg [1:0] accdata_ctrl,
	output reg accwrite_ctrl
);

	// Enumerate op code into an instruction 
	Instr_O instr;
	assign instr = Instr_O'(OP);
	
	always_comb begin
		// Temporary defaults
		br_ctrl <= 1'b0;
		jmp_ctrl <= 1'b0;
		regwrite_ctrl <= 1'b0;
		aluop_ctrl <= Add;
		memwrite_ctrl <= 1'b0;
		accdata_ctrl <= 2'b00;
		accwrite_ctrl <= 1'b0;
	
		// Instruction is M-type save
		if(TYP == 1) begin 
			// $acc = #imm
			br_ctrl <= 1'b0;
			jmp_ctrl <= 1'b0;
			regwrite_ctrl <= 1'b0;
			aluop_ctrl <= Add;
			memwrite_ctrl <= 1'b0;
			accdata_ctrl <= 2'b00;
			accwrite_ctrl <= 1'b1;
		end
		// Instruction is O-type operation
		else begin
			case(instr)
				// $reg = $acc
				STORE: begin	
					br_ctrl <= 1'b0;
					jmp_ctrl <= 1'b0;
					regwrite_ctrl <= 1'b1;
					aluop_ctrl <= Add;
					memwrite_ctrl <= 1'b0;
					accdata_ctrl <= 2'b00;
					accwrite_ctrl <= 1'b0;
				end
				// $acc = M[$reg]
				LB: begin
					br_ctrl <= 1'b0;
					jmp_ctrl <= 1'b0;
					regwrite_ctrl <= 1'b0;
					aluop_ctrl <= Add;
					memwrite_ctrl <= 1'b0;
					accdata_ctrl <= 2'b10;
					accwrite_ctrl <= 1'b1;
				end
				// M[$reg] = $acc
				SB: begin
					br_ctrl <= 1'b0;
					jmp_ctrl <= 1'b0;
					regwrite_ctrl <= 1'b0;
					aluop_ctrl <= Add;
					memwrite_ctrl <= 1'b1;
					accdata_ctrl <= 2'b00;
					accwrite_ctrl <= 1'b0;
				end
				// $acc = $reg
				PUT: begin
					br_ctrl <= 1'b0;
					jmp_ctrl <= 1'b0;
					regwrite_ctrl <= 1'b0;
					aluop_ctrl <= Add;
					memwrite_ctrl <= 1'b0;
					accdata_ctrl <= 2'b01;
					accwrite_ctrl <= 1'b1;
				end
				BTR:begin
					br_ctrl <= 1'b1;
					jmp_ctrl <= 1'b0;
					regwrite_ctrl <= 1'b0;
					aluop_ctrl <= Add;
					memwrite_ctrl <= 1'b0;
					accdata_ctrl <= 2'b00;
					accwrite_ctrl <= 1'b0;
				end
				JMP: begin
					br_ctrl <= 1'b0;
					jmp_ctrl <= 1'b1;
					regwrite_ctrl <= 1'b0;
					aluop_ctrl <= Add;
					memwrite_ctrl <= 1'b0;
					accdata_ctrl <= 2'b00;
					accwrite_ctrl <= 1'b0;
				end
				// $acc = $reg + $acc
				ADD: begin
					br_ctrl <= 1'b0;
					jmp_ctrl <= 1'b0;
					regwrite_ctrl <= 1'b0;
					aluop_ctrl <= Add;
					memwrite_ctrl <= 1'b0;
					accdata_ctrl <= 2'b11;
					accwrite_ctrl <= 1'b1;
				end
				// $acc = $reg - $acc
				SUB: begin
					br_ctrl <= 1'b0;
					jmp_ctrl <= 1'b0;
					regwrite_ctrl <= 1'b0;
					aluop_ctrl <= Sub;
					memwrite_ctrl <= 1'b0;
					accdata_ctrl <= 2'b11;
					accwrite_ctrl <= 1'b1;
				end
				// $acc = $acc & $reg
				AND: begin
					br_ctrl <= 1'b0;
					jmp_ctrl <= 1'b0;
					regwrite_ctrl <= 1'b0;
					aluop_ctrl <= And;
					memwrite_ctrl <= 1'b0;
					accdata_ctrl <= 2'b11;
					accwrite_ctrl <= 1'b1;
				end
				// $acc = $acc & $reg
				XOR: begin
					br_ctrl <= 1'b0;
					jmp_ctrl <= 1'b0;
					regwrite_ctrl <= 1'b0;
					aluop_ctrl <= Xor;
					memwrite_ctrl <= 1'b0;
					accdata_ctrl <= 2'b11;
					accwrite_ctrl <= 1'b1;
				end
				// $acc = $acc << $reg
				SFL: begin
					br_ctrl <= 1'b0;
					jmp_ctrl <= 1'b0;
					regwrite_ctrl <= 1'b0;
					aluop_ctrl <= Sfl;
					memwrite_ctrl <= 1'b0;
					accdata_ctrl <= 2'b11;
					accwrite_ctrl <= 1'b1;
				end
				// $acc = $acc >> $reg
				SFR: begin
					br_ctrl <= 1'b0;
					jmp_ctrl <= 1'b0;
					regwrite_ctrl <= 1'b0;
					aluop_ctrl <= Sfr;
					memwrite_ctrl <= 1'b0;
					accdata_ctrl <= 2'b11;
					accwrite_ctrl <= 1'b1;
				end
				// $acc = ($acc == $reg) ? 1 : 0
				CMP: begin
					br_ctrl <= 1'b0;
					jmp_ctrl <= 1'b0;
					regwrite_ctrl <= 1'b0;
					aluop_ctrl <= Equ;
					memwrite_ctrl <= 1'b0;
					accdata_ctrl <= 2'b11;
					accwrite_ctrl <= 1'b1;
				end
				// $acc = ($acc > $reg) ? 1 : 0
				GTR: begin
					br_ctrl <= 1'b0;
					jmp_ctrl <= 1'b0;
					regwrite_ctrl <= 1'b0;
					aluop_ctrl <= Gtr;
					memwrite_ctrl <= 1'b0;
					accdata_ctrl <= 2'b11;
					accwrite_ctrl <= 1'b1;
				end
			endcase
		end
	end

endmodule