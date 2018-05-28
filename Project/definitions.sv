/**---------------------------------------------------------------------
 *	Module:		Definitions Enumeration
 *	Class:		CSE 141L - SP18
 * Authors: 	Tahmid Khan
 *					Shengyuan Lin
 *----------------------------------------------------------------------
 *	[Description]
 * This file simply defines a package containing an enumerator 
 * definition ALU_OPS that enumerates the 8 possible ALU operations 
 * for code and simulation readability
 * 
 ---------------------------------------------------------------------*/
package definitions;

	// ALU Operations
	typedef enum logic[2:0] {
	  Add = 3'b000,	// Addition
	  Sub = 3'b001,	// Subtraction
	  Sfl = 3'b010,	// Logical shift left
	  Sfr = 3'b011,	// Logical shift right
	  Equ = 3'b100,	// Compare equality
	  Gtr = 3'b101,	// compare greater than
	  And = 3'b110,	// Bitwise AND
	  Xor = 3'b111		// Bitwise XOR
	} ALU_Ops;
	
	// O-Type Instructions
	typedef enum logic[3:0] {
	  STORE = 4'b0000,// Store byte to acc
	  LB = 4'b0001,	// Load byte from mem
	  SB = 4'b0010,	// Store byte from mem
	  PUT = 4'b0011,	// Put
	  BTR = 4'b0100,	// Branch on true
	  JMP = 4'b0101,	// Unconditional Jump
	  ADD = 4'b0110,	// Addition
	  SUB = 4'b0111,	// Subtraction
	  AND = 4'b1000,	// Bitwise AND
	  XOR = 4'b1001,	// Bitwise XOR
	  SFL = 4'b1010,	// Logical shift left
	  SFR = 4'b1011,	// Logical shift right
	  CMP = 4'b1100,	// Compare equality
	  GTR = 4'b1101	// Greater than
	} Instr_O;
	 
endpackage // defintions