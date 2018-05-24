/**---------------------------------------------------------------------
 *	Module:		Accumulator
 *	Class:		CSE 141L - SP18
 * Authors: 	Tahmid Khan
 *					Shengyuan Lin
 *----------------------------------------------------------------------
 *	[Input]
 *		data_imm_in - data line from instruction immediate bits (8-bits)
 *		data_reg_in - data line from register file data out (8-bits)
 *		data_mem_in - data line from memory file read data (8-bits)
 *		data_alu_in - data line from alu result output (8-bits)
 *		data_ctrl - control signal for which input acc receives (2-bits)
 *		accwrite_ctrl - should we write to accumulator this cycle or not
 *
 *	[Output]
 *		acc_out - accumulator data output wire
 ---------------------------------------------------------------------*/

module accumulator(
	input CLK,
	input [7:0] data_imm_in,
	input [7:0] data_reg_in,
	input [7:0] data_mem_in,
	input [7:0] data_alu_in,
	input [1:0] data_ctrl,
	input accwrite_ctrl,
	output [7:0] acc_out
);

	// Accumulator's data
	logic [7:0] acc_data;

	// Accumulator is basically a MUX with specific control signals
	mux_4 mux_din(
		.din_0(data_imm_in),
		.din_1(data_reg_in),
		.din_2(data_mem_in),
		.din_3(data_alu_in),
		.sel(data_ctrl),
		.mux_out(acc_data)
	);
	
	// Only write data to accumulator if acc write control is HIGH
	always_ff @(posedge CLK)
		if(accwrite_ctrl)
			acc_out <= acc_data;

endmodule