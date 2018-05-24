/**---------------------------------------------------------------------
 *	Module:		Instruction Fetch
 *	Class:		CSE 141L - SP18
 * Authors: 	Tahmid Khan
 *					Shengyuan Lin
 *----------------------------------------------------------------------
 *	[Inputs]
 * 	CLK - the clock (1-bit)
 *		dst_in - wire accepting $dst register data (8-bits)
 *		reset_ctrl - the control wire that resets pc to 0 if high (1-bit)
 *		br_ctrl - the control wire determining control flow (btr) (1-bit)
 *		jmp_ctrl - the control wire determining control flow (jmp) (1-bit)
 *		zero_ctrl - the control wire from the ALU zero line (1-bit)
 *
 * [Outputs]
 * 	instr_addr - the address of the next instruction (16-bits)
 * 
 ---------------------------------------------------------------------*/

module instr_fetch(
	input CLK,
	input [7:0] dst_in,
	input reset_ctrl,
	input br_ctrl,
	input jmp_ctrl,
	input zero_ctrl,
	output [15:0] instr_addr
);

	wire[15:0] pc_br;		// Wire containing branched pc to 2:1 MUX
	wire[15:0] pc_inc;	// Wire from incrementor to 2:1 MUX
	wire[15:0] pc_next;	// Wire from 2:1 MUX to pc
	wire br_sel;			// Branch selector

	// The branch address is calculated combinatorily
	assign pc_br = {pc_inc[15:8], dst_in};
	
	// Initialize and wire the program counter module
	pc PC(
		.CLK(CLK), 
		.reset_ctrl(reset_ctrl),
		.pcnext_in(pc_next),
		.pc_out(instr_addr)
	);
		
	// Initialize and wire the incrementor
	incrementor INC(
		.a(instr_addr),
		.a_inc(pc_inc),
	);
	
	// Next PC source selector MUX
	assign br_sel = (br_ctrl & zero_ctrl) | jmp_ctrl;
	mux_2 mux_br(
		.din_0(pc_inc),
		.din_1(pc_br),
		.sel(br_sel),
		.mux_out(pc_next)
	);

endmodule