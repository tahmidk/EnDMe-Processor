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

	typedef enum logic[2:0] {
	  ADD = 3'b000,	// Addition
	  SUB = 3'b001,	// Subtraction
	  SLL = 3'b010,	// Logical shift left
	  SRL = 3'b011,	// Logical shift right
	  EQU = 3'b100,	// Compare equality
	  GTR = 3'b101,	// compare greater than
	  AND = 3'b110,	// Bitwise AND
	  XOR = 3'b111		// Bitwise XOR
	} ALU_Ops;
	 
endpackage // defintions