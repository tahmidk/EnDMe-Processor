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
 *		accdata_in - the data currently in the accumulator (== 1 or not) (1-bit)
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
	input accdata_in,
	output [15:0] instr_addr
);

	wire[15:0] pc_br;		// Wire containing branched pc to 2:1 MUX
	wire[15:0] pc_inc;	// Incremented pc
	logic br_sel;			// Branch selector
	
	// The branch address is calculated absolutely
	assign pc_br = {pc_inc[15:8], dst_in};
	
	// Initialize and wire the program counter module
	assign br_sel = (br_ctrl & (^accdata_in === 1'bx ? 0 : accdata_in)) | jmp_ctrl;
	pc PC(
		.CLK(CLK), 
		.reset_ctrl(reset_ctrl),
		.pcnext_in(pc_inc),
		.pcbr_in(pc_br),
		.br_ctrl(br_sel),
		.pc_out(instr_addr)
	);
		
	// Initialize and wire the incrementor
	incrementor INC(
		.a(instr_addr),
		.a_inc(pc_inc)
	);

endmodule

module tb_instr_fetch();

	// Clock
	reg CLK;
	// Inputs
	reg [7:0] dst_in;
	// Controls
	reg reset_ctrl;
	reg br_ctrl;
	reg jmp_ctrl;
	reg accdata_in;
	// Output
	wire [15:0] instr_addr;
	
	instr_fetch IF(
		.CLK(CLK),
		.dst_in(dst_in),
		.reset_ctrl(reset_ctrl),
		.br_ctrl(br_ctrl),
		.jmp_ctrl(jmp_ctrl),
		.accdata_in(accdata_in),
		.instr_addr(instr_addr)
	);
	
	always #5 CLK = ~CLK;
	
	initial begin
		CLK <= 0;
		dst_in <= 0;
		reset_ctrl <= 0;
		br_ctrl <= 0;
		jmp_ctrl <= 0;
		accdata_in <= 1;
		
		$monitor("Address out = %d", instr_addr);
		
		#5
		// instr_addr should be 0
		
		#10
		// instr_addr should be 1
		
		#10
		// instr_addr should be 2
		
		#10
		// instr_addr should be 3
		
		#10
		// instr_addr should be 4
		br_ctrl <= 1;
		
		#10
		// instr_addr should be 0
		br_ctrl <= 0;
		
		#20 $stop;
	end
	
endmodule 