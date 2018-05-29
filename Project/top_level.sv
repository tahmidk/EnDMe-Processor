/**---------------------------------------------------------------------
 *	Module:		Top Level EnDMe Processor
 *	Class:		CSE 141L - SP18
 * Authors: 	Tahmid Khan
 *					Shengyuan Lin
 *----------------------------------------------------------------------
 *	[Description]
 *	This module puts the EnDMe processor together module by module based
 * on the high level block diagram
 *
 *	[Input]
 *		CLK - the clock (1-bit)
 *		RESET - the control wire that resets pc to 0 if high (1-bit)
 *
 *	[Output]
 *		done - expressed when PC reaches end of program
 ---------------------------------------------------------------------*/

import definitions::*;
 
module top_level(
	input CLK,
	input RESET,
	output reg done
);
 
	// Module wires/BUS
	wire [7:0] dst_data;
	wire [15:0] instr_addr_bus;
	wire [8:0] instruction;
	wire [7:0] acc_output;
	wire [7:0] reg_output;
	wire [7:0] alu_output;
	wire [7:0] mem_output;
	
	// Parse instruction
	wire [7:0] imm;
	wire typ;
	wire [3:0] op;
	assign imm = instruction[7:0];
	assign typ = instruction[8];
	assign op = instruction[7:4];
	
	// Control wires
	wire ctrl_branch;
	wire ctrl_jump;
	wire ctrl_zero;
	wire ctrl_regWr;
	wire ctrl_memWr;
	wire [1:0] ctrl_accDat;
	wire ctrl_accWr;
	wire [2:0] ctrl_alu;
	
	// Done flag
	initial done <= 0;
	always @(posedge CLK) begin
		// Done when no more instructions
		if(^instruction === 1'bX && instr_addr_bus != 16'hffff)
			done <= 1;
	end
 
	// Initialize instruction fetch
	wire accRslt;
	assign accRslt = (acc_output == 1);
	instr_fetch IF(
		.CLK(CLK),
		.dst_in(dst_data),
		.reset_ctrl(RESET),
		.br_ctrl(ctrl_branch),
		.jmp_ctrl(ctrl_jump),
		.accdata_in(accRslt),
		.instr_addr(instr_addr_bus)
	);
	
	// Initialize instruction ROM
	instr_rom IROM(
		.addr_in(instr_addr_bus),
		.instr_out(instruction)
	);
	
	// Initialize accumulator
	accumulator ACC(
		.data_imm_in(imm),
		.data_reg_in(reg_output),
		.data_mem_in(mem_output),
		.data_alu_in(alu_output),
		.data_ctrl(ctrl_accDat),
		.write_ctrl(ctrl_accWr),
		.acc_out(acc_output)
	);
	
	// Initialize control unit
	controller CTRL(
		.TYP(typ),
		.OP(op),
		.br_ctrl(ctrl_branch),
		.jmp_ctrl(ctrl_jump),
		.regwrite_ctrl(ctrl_regWr),
		.aluop_ctrl(ctrl_alu),
		.memwrite_ctrl(ctrl_memWr),
		.accdata_ctrl(ctrl_accDat),
		.accwrite_ctrl(ctrl_accWr)
	);
	
	// Initialize register file
	reg_file RF(
		.CLK(CLK),
		.reg_in(instruction[3:0]),
		.data_in(acc_output),
		.write_ctrl(ctrl_regWr),
		.data_out(reg_output),
		.dst_out(dst_data)
	);
	
	// Initialize ALU
	alu ALU(
		.reg_in(reg_output),
		.acc_in(acc_output),
		.op_ctrl(ctrl_alu),
		.rslt_out(alu_output)
	);
	
	// Initialize data memory
	data_mem DMEM(
		.CLK(CLK),
		.addr_in(reg_output),
		.data_in(acc_output),
		.writemem_ctrl(ctrl_memWr),
		.data_out(mem_output)
	);
 
 
endmodule 


// Test module for top level
module tb_top();

	reg CLK;
	reg RESET;
	wire done;
	
	integer i;

	always #10 CLK = ~CLK;
	initial begin
		CLK <= 0;
		RESET <= 0;
		
		// Let it run until it's done
		wait(done);
		
		// Print contents of the register file
		$display("Reg Data:");
		for (i=0; i < 16; i=i+1)
			$display("%d:%d",i,TOP.RF.core[i]);
		
		// Print Contents of Mem File
		// Not Yet
		
		#10 $stop;
	end
	
	// Initialize top level module
	top_level TOP(
		.CLK(CLK),
		.RESET(RESET),
		.done(done)
	);

endmodule