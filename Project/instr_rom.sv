/**---------------------------------------------------------------------
 *	Module:		Instruction Read-Only Memory
 *	Class:		CSE 141L - SP18
 * Authors: 	Tahmid Khan
 *					Shengyuan Lin
 *----------------------------------------------------------------------
 *	[Inputs]
 * 	addr_in - the address to read instruction from as indicated by
 *			the program counter pc (16-bits)
 *
 * [Outputs]
 * 	instr_out - the instruction at addr_in (9=bits)
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