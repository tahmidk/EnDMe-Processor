/**---------------------------------------------------------------------
 *	Module:		Register File
 *	Class:		CSE 141L - SP18
 * Authors: 	Tahmid Khan
 *					Shengyuan Lin
 *----------------------------------------------------------------------
 *	[Inputs]
 *		CLK - the clock wire
 * 	reg_in - the wire from instr determining which register to work 
 *			with (4-bits)
 * 	data_in - the data that will be stored given write_ctrl (8-bits)
 *		write_ctrl - control signal that enables/disables writing data_in
 *			to the register indicated by reg_in (1-bit)
 *
 * [Outputs]
 * 	data_out - the data contained in register reg_in (8-bits)
 *		dst_out - the data contained in register $dst (8-bits)
 * 
 ---------------------------------------------------------------------*/

module reg_file(
  input CLK,
  input [3:0] reg_in,
  input [7:0] data_in,
  input write_ctrl,
  output [7:0] data_out,
  output [7:0] dst_out
);

	// The register file itself, an array of 16 8-bit registers
	logic [7:0] core[16];
	
	// Register file writes on posedge CLK iff write_ctrl = 1
	always_ff @(posedge clk) 
		if(write_ctrl)		
			core[reg_in] <= data_in;

	// Do reads automatically rather than sequentially
	always_comb data_out = core[reg_in];
	always_comb dst_out = core[15]

endmodule