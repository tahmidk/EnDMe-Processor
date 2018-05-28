/**---------------------------------------------------------------------
 *	Module:		Program Counter
 *	Class:		CSE 141L - SP18
 * Authors: 	Tahmid Khan
 *					Shengyuan Lin
 *----------------------------------------------------------------------
 *	[Inputs]
 * 	CLK - the clock (1-bit)
 *		reset_ctrl - the control wire that resets pc to 0 if high (1-bit)
 *		pcnext_in - the wire containing the next pc value (16-bits)
 *
 * [Outputs]
 * 	pc_out - the wire outputting the pc for the next clock cycle (16-bits)
 * 
 ---------------------------------------------------------------------*/

module pc (
	input CLK,
	input reset_ctrl,
	input [15:0] pcnext_in,
	output reg [15:0] pc_out
);

	// $pc starts at -1 at the very beginning
	initial pc_out <= -'d1;

	/* On each posedge clock, or whenever the reset control is triggered
	 *	update the program counter or reset it to 0
	 */
	always @(posedge CLK) begin
		if(reset_ctrl) 
			pc_out <= 16'h0;
		else 
			pc_out <= pcnext_in;
	end

endmodule