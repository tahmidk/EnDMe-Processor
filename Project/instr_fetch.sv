/**---------------------------------------------------------------------
 *	Module:		Instruction Fetch
 *	Class:		CSE 141L - SP18
 * Authors: 	Tahmid Khan
 *					Shengyuan Lin
 *----------------------------------------------------------------------
 *	[Inputs]
 * 	CLK - the clock (1-bit)
 *		reset_ctrl - the control wire that resets pc to 0 if high (1-bit)
 *		branch_ctrl - the control wire determining control flow
 *
 * [Outputs]
 * 	instr_addr - the address of the next instruction (16-bits)
 * 
 ---------------------------------------------------------------------*/

module instr_fetch(
	input CLK,
	input reset_ctrl,
	input branch_ctrl,
	output [15:0] instr_addr
);

	wire[15:0] pc_br;		// Wire containing branched pc to 2:1 MUX
	wire[15:0] pc_inc;	// Wire from incrementor to 2:1 MUX
	wire[15:0] pc_next;	// Wire from 2:1 MUX to pc

	// Initialize and wire the program counter module
	pc(
		.CLK(CLK), 
		.reset_ctrl(reset_ctrl),
		.pcnext_in(pc_next),
		.pc_out(instr_addr)
	);
		
	// Initialize and wire the incrementor
	incrementor(
		.a(instr_addr),
		.a_inc(pc_inc),
	);
	
	mux_2(
		.din_0(pc_inc),
		.din_1(pc_br),
		.sel(branch_ctrl),
		.mux_out(pc_next)
	);

endmodule