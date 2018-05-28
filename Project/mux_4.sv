/**---------------------------------------------------------------------
 *	Module:		4:1 MUX
 *	Class:		CSE 141L - SP18
 * Authors: 	Tahmid Khan
 *					Shengyuan Lin
 *----------------------------------------------------------------------
 *	[Inputs]
 * 	din_0 - the data line that will be passed with sel=0
 *		din_1 - the data line that will be passed with sel=1
 * 	din_2 - the data line that will be passed with sel=2
 *		din_3 - the data line that will be passed with sel=3
 *		sel - the selector bits (2-bits)
 *
 * [Outputs]
 * 	mux_out - the data line selected by sel (16-bits)
 * 
 ---------------------------------------------------------------------*/

module  mux_4 #(parameter data_width=16)(
	input [data_width-1:0] din_0,
	input [data_width-1:0] din_1,
	input [data_width-1:0] din_2,
	input [data_width-1:0] din_3,
	input [1:0] sel,
	output reg [data_width-1:0] mux_out
);

	always_comb
		begin
			case(sel)
				2'b00: mux_out = din_0;
				2'b01: mux_out = din_1;
				2'b10: mux_out = din_2;
				2'b11: mux_out = din_3;
			endcase
		end
		
endmodule