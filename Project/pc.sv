/**---------------------------------------------------------------------
 *	Module:		Program Counter
 *	Class:		CSE 141L - SP18
 * Authors: 	Tahmid Khan
 *					Shengyuan Lin
 *----------------------------------------------------------------------
 *	[Inputs]
 * 	CLK			the clock (1-bit)
 *		reset			the control wire that resets pc to 0 if high (1-bit)
 *		state			the current state of the processor (2-bits)
 *		pcnext_in	the wire containing the incremented pc value (16-bits)
 *		pcbr_in		the wire containing the branch taken pc value (16-bits)
 *		br_ctrl		branch taken or not (1-bit)
 *
 * [Outputs]
 * 	pc_out		the wire outputting the pc for the next clock cycle (16-bits)
 * 
 ---------------------------------------------------------------------*/

module pc (
	input CLK,
	input reset,
	input [1:0] state,
	input [15:0] pcnext_in,
	input [15:0] pcbr_in,
	input br_ctrl,
	output reg [15:0] pc_out
);

	// $pc starts at -1 at the very beginning
	initial pc_out <= -'d1;

	/* On each posedge clock, or whenever the reset control is triggered
	 *	update the program counter or reset it to 0
	 */
	always@(posedge CLK) begin
		if(reset) begin
			case(state) 
				0: pc_out <= -'d1;	// Initial state
				1: pc_out <= 'd106;	// Beginning of program 2/3 outputted by assembler.py
				2: pc_out <= -'d1;	// Initial state
				3: pc_out <= 'd106;	// Beginning of program 2/3 outputted by assembler.py
			endcase
		end
		else if(br_ctrl)
			pc_out <= pcbr_in;
		else
			pc_out <= pcnext_in;
	end

endmodule