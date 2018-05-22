/**---------------------------------------------------------------------
 *	Module:		Incrementor
 *	Class:		CSE 141L - SP18
 * Authors: 	Tahmid Khan
 *					Shengyuan Lin
 *----------------------------------------------------------------------
 *	[Inputs]
 * 	a - the value to increment by 1 (16-bits)
 *
 * [Outputs]
 * 	a_inc - a+1 with no overflow detection (16-bits)
 * 
 ---------------------------------------------------------------------*/
 
 module incrementor (
	input [15:0] a,
	output [15:0] a_inc
 );
 
	// Increment a
	assign a_inc = a + 1;
 
 endmodule