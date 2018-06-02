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
	reg [7:0] mem_file [2**8];

	// Initialization memory, seed with constants
	initial 
		$readmemh("mem_init.dat", mem_file);
	
	// Read data from memory immediately
	always @* begin
		data_out = mem_file[addr_in];
		$display("Memory read M[%d] = %d", addr_in, data_out);
	end

	// Write data to memory sequentially
	always_ff @(posedge CLK) begin
		if(writemem_ctrl) 
			begin
				mem_file[addr_in] <= data_in;
				$display("Memory write M[%d] = %d", addr_in, data_in);
			end
	end

endmodule


// Data Memory testbench
module tb_data_mem();

	// Clock
	reg CLK;
	// Inputs
	reg [7:0] addr;
	reg [7:0] din;
	// Controls
	reg writeMem;
	// Output
	wire [7:0] dout;
	
	// Run CLK
	always #5 CLK = ~CLK;
	
	// Make the module
	data_mem DM(
		.CLK(CLK),
		.addr_in(addr),
		.data_in(din),
		.writemem_ctrl(writeMem),
		.data_out(dout)
	);
	
	// The testbench
	initial begin
		// $monitor("addr = %d, write = %b | din = %d | dout = %d", addr, writeMem, din, dout);
		CLK <= 0;
		
		addr <= 'd0; din <= 'd33; writeMem <= 0;
		#5 addr <= 'd0; din <= 'd33; writeMem <= 1;
		#10 addr <= 'd0; din <= 'd33; writeMem <= 0;
		
		#10 addr <= 'd1; din <= 'd33; writeMem <= 0;
		#10 addr <= 'd2; din <= 'd33; writeMem <= 0;
		#10 addr <= 'd0; din <= 'd33; writeMem <= 0;
		#10 addr <= 'd42; din <= 'd33; writeMem <= 0;
		#10 addr <= 'd43; din <= 'd33; writeMem <= 0;
		#10 addr <= 'd43; din <= 'd33; writeMem <= 1;
		#10 addr <= 'd43; din <= 'd33; writeMem <= 0;

		#10 $stop;
		
	end

endmodule 