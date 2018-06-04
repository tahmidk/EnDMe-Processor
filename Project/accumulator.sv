/**---------------------------------------------------------------------
 *	Module:		Accumulator
 *	Class:		CSE 141L - SP18
 * Authors: 	Tahmid Khan
 *					Shengyuan Lin
 *----------------------------------------------------------------------
 *	[Input]
 *		data_imm_in		data line from instruction immediate bits (8-bits)
 *		data_reg_in		data line from register file data out (8-bits)
 *		data_mem_in		data line from memory file read data (8-bits)
 *		data_alu_in		data line from alu result output (8-bits)
 *		data_ctrl		control signal for which input acc receives (2-bits)
 *		accwrite_ctrl	should we write to accumulator this cycle or not
 *
 *	[Output]
 *		acc_out			accumulator data output wire
 ---------------------------------------------------------------------*/

module accumulator(
	input CLK,
	input [7:0] data_imm_in,
	input [7:0] data_reg_in,
	input [7:0] data_mem_in,
	input [7:0] data_alu_in,
	input [1:0] data_ctrl,
	input write_ctrl,
	output reg [7:0] acc_out
);

	// Accumulator's data
	reg [7:0] acc_data;
	
	initial acc_data = 8'bxxxxxxxx;

	// Accumulator is basically a MUX with specific control signals
	mux_4 #(8) mux_din(
		.din_0(data_imm_in),
		.din_1(data_reg_in),
		.din_2(data_mem_in),
		.din_3(data_alu_in),
		.sel(data_ctrl),
		.mux_out(acc_data)
	);
	
	// Write to accumulator
	always @(negedge CLK) begin//(write_ctrl or data_ctrl) begin
		if(write_ctrl) begin
			acc_out <= acc_data;
		end
	end

endmodule


// Accumulator Testbench
module tb_accumulator();

	// Data lines
	reg [7:0] din_imm;
	reg [7:0] din_reg;
	reg [7:0] din_mem;
	reg [7:0] din_alu;
	// Controls
	reg [1:0] data_ctrl;
	reg accwrite_ctrl;
	// Output
	wire [7:0] acc_out;

	
	// Make the module
	accumulator ACC(
		.data_imm_in(din_imm),
		.data_reg_in(din_reg),
		.data_mem_in(din_mem),
		.data_alu_in(din_alu),
		.data_ctrl(data_ctrl),
		.write_ctrl(accwrite_ctrl),
		.acc_out(acc_out)
	);
	
	
	// The testbench
	initial begin
		$monitor("Data Ctrl = %d | AccWr Ctrl = %b | Output = %d", data_ctrl, accwrite_ctrl, acc_out);
		din_imm <= 'd1;
		din_reg <= 'd2;
		din_mem <= 'd3;
		din_alu <= 'd4;
	
		// Stimulus
		#5
		data_ctrl <= 2'b01;
		accwrite_ctrl <= 1'b1;
		
		#10
		data_ctrl <= 2'b11;
		accwrite_ctrl <= 1'b1;
	
		#10
		data_ctrl <= 2'b11;
		accwrite_ctrl <= 1'b1;
	
		#10
		data_ctrl <= 2'b00;
		accwrite_ctrl <= 1'b0;
		
		#10
		data_ctrl <= 2'b00;
		accwrite_ctrl <= 1'b1;
	
		#10 $stop;
	end
	
endmodule 