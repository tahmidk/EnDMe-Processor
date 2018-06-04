/**---------------------------------------------------------------------
 *	Module:		Instruction Read-Only Memory
 *	Class:		CSE 141L - SP18
 * Authors: 	Tahmid Khan
 *					Shengyuan Lin
 *----------------------------------------------------------------------
 *	[Inputs]
 * 	addr_in		the address to read instruction from as indicated by
 *						the program counter pc (16-bits)
 *
 * [Outputs]
 * 	instr_out	the instruction at addr_in (9=bits)
 * 
 ---------------------------------------------------------------------*/

module instr_rom(
	input [15:0] addr_in,
	output logic[8:0] instr_out
);
	 
	// The memory file itself, an array of 2^16 9-bit instructions
	logic [8:0] rom[2**16];
	
	// Load machine code program into instruction ROM
	initial 
		$readmemb("machine_code.bin", rom);

	// Fetch instruction and set it to output
	assign instr_out = rom[addr_in];

endmodule


// Instruction ROM testbench
module tb_instr_rom();

	// Clock
	reg CLK;
	// Inputs
	reg [7:0] dst_in;
	// Controls
	reg reset_ctrl;
	reg br_ctrl;
	reg jmp_ctrl;
	reg accdata_in;
	reg [15:0] addr;
	wire [8:0] instr;
	// Output
	wire [15:0] instr_addr;
	
	instr_fetch IF(
		.CLK(CLK),
		.dst_in(dst_in),
		.reset_ctrl(reset_ctrl),
		.br_ctrl(br_ctrl),
		.jmp_ctrl(jmp_ctrl),
		.accdata_in(accdata_in),
		.instr_addr(addr)
	);
	
	instr_rom IROM(
		.addr_in(addr),
		.instr_out(instr)
	);
	
	always #5 CLK = ~CLK;
	
	initial begin
		CLK <= 0;
		dst_in <= 0;
		reset_ctrl <= 0;
		br_ctrl <= 0;
		jmp_ctrl <= 0;
		accdata_in <= 1;
		
		$monitor("Instruction = %b", instr);
		
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
		jmp_ctrl <= 1;
		
		#10
		// instr_addr should be 0
		jmp_ctrl <= 0;
		
		#20 $stop;
	end

endmodule 