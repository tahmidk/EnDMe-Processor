/**---------------------------------------------------------------------
 *	Module:		Data Memory
 *	Class:		CSE 141L - SP18
 * Authors: 	Tahmid Khan
 *					Shengyuan Lin
 *----------------------------------------------------------------------
 *	[Inputs]
 * 	CLK - the clock (1-bit)
 *		addr_in - the address to look up in memory (8-bits)
 *		data_in - the data to write to addr (8-bits)
 *		writemem_ctrl - the control signal dictating whether data_in 
 *			should be committed to memory at addr or not (1-bit)
 *
 * [Outputs]
 * 	data_out - the data at addr (8-bits)
 * 
 ---------------------------------------------------------------------*/

module data_mem (
	input CLK,
	input [7:0] addr_in,
	input [7:0]  data_in,
	input writemem_ctrl,
	output logic[7:0] data_out
);			 

	// The memory file itself, a list of 2^8 memory slots
	logic [7:0] mem_file [2**8];

	// Initialization memory, seed with constants
	//initial 
	//	$readmem_ctrlh("dataram_init.list", mem_file);

	always @*
		begin
			// Read data from memory immediately
			data_out = mem_file[addr_in];
			// Diagnostic print statement (TODO: remove after debug)
			$display("Memory read M[%d] = %d", addr_in, data_out);
		end

	// Write data to memory sequentially
	always_ff @(posedge CLK) 
		begin
			if(writemem_ctrl) 
				begin
					mem_file[addr_in] <= data_in;
					// Diagnostic print statement (TODO: remove after debug)
					$display("Memory write M[%d] = %d", addr_in, data_in);
				end
		end

endmodule