/**---------------------------------------------------------------------
 *	Module:		2:1 MUX
 *	Class:		CSE 141L - SP18
 * Authors: 	Tahmid Khan
 *					Shengyuan Lin
 *----------------------------------------------------------------------
 *	[Inputs]
 * 	din_0 - the data line that will be passed with sel=0
 *		din_1 - the data line that will be passed with sel=1
 *		sel - the selector bit (1-bit)
 *
 * [Outputs]
 * 	mux_out - the data line selected by sel (16-bits)
 * 
 ---------------------------------------------------------------------*/

module  mux_2 #(parameter data_width=16)(
	input [data_width-1:0] din_0,
	input [data_width-1:0] din_1,
	input sel,
	output [data_width-1:0] mux_out
);

	always_comb
		begin
			case(sel)
				1b'0: mux_out = din_0;
				1b'1: mux_out = din_1;
			endcase
		end
		
endmodule