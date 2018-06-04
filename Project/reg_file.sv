/**---------------------------------------------------------------------
 *	Module:		Register File
 *	Class:		CSE 141L - SP18
 * Authors: 	Tahmid Khan
 *					Shengyuan Lin
 *----------------------------------------------------------------------
 *	[Inputs]
 *		CLK			the clock wire
 * 	reg_in		the wire from instr determining which register to work 
 *						with (4-bits)
 * 	data_in		the data that will be stored given write_ctrl (8-bits)
 *		write_ctrl	control signal that enables/disables writing data_in
 *						to the register indicated by reg_in (1-bit)
 *
 * [Outputs]
 * 	data_out		the data contained in register reg_in (8-bits)
 *		dst_out		the data contained in register $dst (8-bits)
 * 
 ---------------------------------------------------------------------*/

module reg_file(
  input CLK,
  input [3:0] reg_in,
  input [7:0] data_in,
  input write_ctrl,
  output [7:0] data_out,
  output [7:0] dst_out
);

	// The register file itself, an array of 16 8-bit registers
	logic [7:0] core[16];
	
	// Register file writes on posedge CLK iff write_ctrl = 1
	always_ff @(posedge CLK) 
		if(write_ctrl)		
			core[reg_in] <= data_in;

	// Do reads automatically rather than sequentially
	assign data_out = core[reg_in];
	assign dst_out = core[15];

endmodule


module tb_reg_file();

	// Clock
	reg CLK;
	// Inputs
	reg [3:0] rin;
	reg [7:0] din;
	// Controls
	reg write;
	// Output
	wire [7:0] dout;
	wire [7:0] dstout;
	
	// Clock tick
	always #5 CLK = ~CLK;
	
	// Make the module
	reg_file RF(
		.CLK(CLK),
		.reg_in(rin),
		.data_in(din),
		.write_ctrl(write),
		.data_out(dout),
		.dst_out(dstout)
	);
	
	// The testbench
	integer i;
	initial begin
		CLK <= 1'b0;
		rin <= 3'b000;
		din <= 'd13;
		write <= 1'b0;
		
		$monitor("Data out = %d", dout);
		
		// Write 22 to register 0
		#5
		write <= 1'b1;
		din <= 'd22;
		
		#10
		write <= 1'b0;
		
		// Write 13 to register 2
		#10
		rin <= 3'b010;
		write <= 1'b1;
		din <= 'd13;
		
		#10
		write <= 1'b0;
		
		// Write 187 to register 0
		#10
		rin <= 3'b000;
		write <= 1'b1;
		din <= 'd187;
		
		#10
		write <= 1'b0;
		
		// Print contents of reg file at the end
		$display("Reg Core:");
		for (i=0; i < 16; i=i+1)
			$display("%d:%d",i,RF.core[i]);
		
		#20 $stop;
	end

endmodule 