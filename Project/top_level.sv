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
 *		CLK		the clock (1-bit)
 *		init		the control wire that indicates shift to next state (1-bit)
 *
 *	[Output]
 *		done		expressed when PC reaches end of program 1 or 2/3
 ---------------------------------------------------------------------*/

import definitions::*;
 
module top_level(
	input CLK,
	input init,
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
	reg ctrl_reset;
	wire ctrl_branch;
	wire ctrl_jump;
	wire ctrl_zero;
	wire ctrl_regWr;
	wire ctrl_memWr;
	wire [1:0] ctrl_accDat;
	wire ctrl_accWr;
	wire [2:0] ctrl_alu;
	
	// State indicator 
	// State 0: Run Program 1 <---
	// State 1: Run Program 2     |
	// State 2: Run Program 1	   |
	// State 3: Run Program 3 ----
	reg [1:0] state = 2'b11;
	
	// Initializations
	initial done <= 0;
	initial ctrl_reset <= 0;
	
	// Increment state when given init signal
	always @(posedge init) begin
		state <= state + 1;
		#5 ctrl_reset <= 1;
		#10 ctrl_reset <= 0;
	end
	
	// ==============[ Connect all the modules ]===============
	// Initialize instruction fetch
	wire accRslt;
	assign accRslt = (acc_output == 1);
	instr_fetch IF(
		.CLK(CLK),
		.reset_ctrl(ctrl_reset),
		.dst_in(dst_data),
		.state_ctrl(state),
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
		.CLK(CLK),
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
		.accwrite_ctrl(ctrl_accWr),
		.done_ctrl(done)
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


// Runs a basic testbench (simply runs the code)
module tb_top_basic();

	reg CLK;
	reg init;
	wire done;
	
	integer i;

	always #10 CLK = ~CLK;
	initial begin
		CLK <= 0;
		init <= 0;
		
		// Let it run until it's done
		wait(done);
		
		// Print contents of the register file
		$display("[Post] Reg Data:");
		for (i=0; i < 16; i=i+1)
			$display("%d:%d",i,TOP.RF.reg_core[i]);
		
		// Print Contents of Mem File
		$display("[Post] Memory File:");
		for(i=0; i < 2**8; i=i+1)
			$display("%d:%d",i,TOP.DMEM.mem_core[i]);
		
		#10 $stop;
	end
	
	// Initialize top level module
	top_level TOP(
		.CLK(CLK),
		.init(init),
		.done(done)
	);

endmodule


// Graded test module for top level
module tb_top();

	logic      	clk            ,  // advances simulation step-by-step
					init           ;  // init (reset, start) command to DUT
	wire       	done           ;  // done flag returned by DUT
	logic[7:0] 	message1[41]   ,  // first program 1 original message, in binary
					message2[41]   ,  // program 2 decrypted message
					message3[41]   ,  // second program 1 original message
					message4[41]   ,  // program 3 decrypted message
					pre_length[4]  ,  // bytes before first character in message
					lfsr_ptrn[4]   ,  // one of 8 maximal length 8-tap shift reg. ptrns
					lfsr1[64]      ,  // states of program 1 encrypting LFSR
					lfsr2[64]      ,  // states of program 2 decrypting LFSR
					lfsr3[64]      ,  // states of program 3 encrypting LFSR
					lfsr4[64]      ,  // states of program 4 decrypting LFSR
					msg_padded1[64],  // original message, plus pre- and post-padding
					msg_padded2[64],  // original message, plus pre- and post-padding
					msg_padded3[64],  // original message, plus pre- and post-padding
					msg_padded4[64],  // original message, plus pre- and post-padding
					msg_crypto1[64],  // encrypted message according to the DUT
					msg_crypto2[64],  // encrypted message according to the DUT
					msg_crypto3[64],  // encrypted message according to the DUT
					msg_crypto4[64],  // encrypted message according to the DUT
					LFSR_ptrn[8]   ,  // 8 possible maximal-length 8-bit LFSR tap ptrns
					LFSR_init[4]   ,  // four of 255 possible NONZERO starting states
					spaces = 0     ;  // counts leading spaces for Program 3
					
	// our original American Standard Code for Information Interchange message follows
	// note in practice your design should be able to handle ANY ASCII string
	//string     str1  = "Mr. Watson, come here. I want to see you.";  // 1st program 1 input
	//string     str2  = "Knowledge comes, but wisdom lingers.     ";  // program 2 output
	//string     str3  = "  01234546789abcdefghijklmnopqrstuvwxyz. ";  // 2nd program 1 input
	//string     str4  = "  f       A joke is a very serious thing.";  // program 3 output
	string     str1  = "What is the meaning of life I ask?       ";  // 1st program 1 input
	string     str2  = "To be, or not to be, that is the question";  // program 2 output
	string     str3  = "           djakfa a sd fad ads sdf       ";  // 2nd program 1 input
	string     str4  = "                  Ajoke";  // program 3 output

	// displayed encrypted string will go here:
	string     str_enc1[64];  // first program 1 output
	string     str_enc2[64];  // program 2 input
	string     str_enc3[64];  // second program 1 output
	string     str_enc4[64];  // program 3 input

	// the 8 possible maximal-length feedback tap patterns from which to choose
	assign LFSR_ptrn[0] = 8'he1;
	assign LFSR_ptrn[1] = 8'hd4;
	assign LFSR_ptrn[2] = 8'hc6;
	assign LFSR_ptrn[3] = 8'hb8;
	assign LFSR_ptrn[4] = 8'hb4;
	assign LFSR_ptrn[5] = 8'hb2;
	assign LFSR_ptrn[6] = 8'hfa;
	assign LFSR_ptrn[7] = 8'hf3;

	// different starting LFSR state for each program -- logical OR guarantees nonzero
	assign LFSR_init[0] = $random | 8'h40;  // for 1st program 1 run
	assign LFSR_init[1] = $random | 8'h20;  // for program 2 run
	assign LFSR_init[2] = $random | 8'h10;  // for 2nd program 1 run
	assign LFSR_init[3] = $random | 8'h08;  // for program 3 run

	// set preamble lengths for the four program runs (always > 8)
	//assign pre_length[0] = 9 ;  // 1st program 1 run
	//assign pre_length[1] = 9 ;  // program 2 run
	//assign pre_length[2] = 11;  // 2nd program 1 run
	//assign pre_length[3] = 10;  // program 3 run
	assign pre_length[0] = 12 ;  // 1st program 1 run
	assign pre_length[1] = 12 ;  // program 2 run
	assign pre_length[2] = 10;  // 2nd program 1 run
	assign pre_length[3] = 9;  // program 3 run
	
	
	int lk;                     // counts leading spaces for program 3

	top_level dut(
	 .CLK(clk),
	 .init(init),
	 .done(done)
	);

	initial begin
		for(lk = 0; lk<25; lk++) begin
			if(str4[lk]==8'h20)
			  continue;
			else
			  break;
		end

		clk  = 0;  // initialize clock
		init = 1;  // activate reset

		// program 1 -- precompute encrypted message
		lfsr_ptrn[0] = LFSR_ptrn[1];  // select one of 8 permitted
		lfsr1[0]     = LFSR_init[0];  // any nonzero value (zero may be helpful for debug)
		$display("run program 1 for the first time");
		$display("%s",str1);          // print original message in transcript window
		$display("LFSR_ptrn = %h, LFSR_init = %h",lfsr_ptrn[0],lfsr1[0]);

		for(int j=0; j<64; j++)       // pre-fill message_padded with ASCII space characters
			msg_padded1[j] = 8'h20;

		for(int l=0; l<41; l++)       // overwrite up to 41 of these spaces w/ message itself
			msg_padded1[pre_length[0]+l] = str1[l];

		// compute the LFSR sequence
		for (int ii=0;ii<63;ii++)
			lfsr1[ii+1] = (lfsr1[ii]<<1)+(^(lfsr1[ii]&lfsr_ptrn[0]));

		// encrypt the message, testbench will change on falling clocks
		for (int i=0; i<64; i++) begin
			msg_crypto1[i]        = msg_padded1[i] ^ lfsr1[i];
			str_enc1[i]           = string'(msg_crypto1[i]);
		end

		for(int jj=0; jj<64; jj++)
			$write("%s",str_enc1[jj]);
		$display("\n");

		// program 2 -- precompute encrypted message
		lfsr_ptrn[1] = LFSR_ptrn[4];  // select one of 8 permitted
		lfsr2[0]     = LFSR_init[1];  // any nonzero value (zero may be helpful for debug)
		$display("run program 2");
		$display("%s",str2);          // print original message in transcript window
		$display("LFSR_ptrn = %h, LFSR_init = %h",lfsr_ptrn[1],lfsr2[0]);

		for(int j=0; j<64; j++)       // pre-fill message_padded with ASCII space characters
			msg_padded2[j] = 8'h20;

		for(int l=0; l<41; l++)       // overwrite up to 41 of these spaces w/ message itself
			msg_padded2[pre_length[1]+l] = str2[l];

		// compute the LFSR sequence
		for (int ii=0;ii<63;ii++)
			lfsr2[ii+1] = (lfsr2[ii]<<1)+(^(lfsr2[ii]&lfsr_ptrn[1]));

		// encrypt the message, testbench will change on falling clocks
		for (int i=0; i<64; i++) begin
			msg_crypto2[i]        = msg_padded2[i] ^ lfsr2[i];
			str_enc2[i]           = string'(msg_crypto2[i]);
		end
		$display("cryp_pre_2 %h %h %h %h %h %h %h %h %h",
		lfsr2[0], lfsr2[1], lfsr2[2], lfsr2[3], lfsr2[4], lfsr2[5], lfsr2[6],
			lfsr2[7], lfsr2[8]);
		//	  msg_crypto2[0], msg_crypto2[1], msg_crypto2[2], msg_crypto2[3],
		//	  msg_crypto2[4], msg_crypto2[5], msg_crypto2[6], msg_crypto2[7], msg_crypto2[8]);
		for(int jj=0; jj<64; jj++)
			$write("%s",str_enc2[jj]);
		$display("\n");

		// program 1 -- precompute encrypted message
		lfsr_ptrn[2] = LFSR_ptrn[7];  // select one of 8 permitted
		lfsr3[0]     = LFSR_init[2];  // any nonzero value (zero may be helpful for debug)
		$display("run program 1 for the second time");
		$display("%s",str3);          // print original message in transcript window
		$display("LFSR_ptrn = %h, LFSR_init = %h",lfsr_ptrn[2],lfsr3[0]);

		for(int j=0; j<64; j++)       // pre-fill message_padded with ASCII space characters
			msg_padded3[j] = 8'h20;

		for(int l=0; l<41; l++)       // overwrite up to 41 of these spaces w/ message itself
			msg_padded3[pre_length[2]+l] = str3[l];

		// compute the LFSR sequence
		for (int ii=0;ii<63;ii++)
			lfsr3[ii+1] = (lfsr3[ii]<<1)+(^(lfsr3[ii]&lfsr_ptrn[2]));  // {LFSR[6:0],(^LFSR[5:3]^LFSR[7])};           // roll the rolling code

		// encrypt the message, testbench will change on falling clocks
		for (int i=0; i<64; i++) begin
			msg_crypto3[i]        = msg_padded3[i] ^ lfsr3[i];  //{1'b0,LFSR[6:0]};       // encrypt 7 LSBs
			str_enc3[i]           = string'(msg_crypto3[i]);
		end

		for(int jj=0; jj<64; jj++)
			$write("%s",str_enc3[jj]);
		$display("\n");

		// program 3 -- precompute encrypted message
		lfsr_ptrn[3] = LFSR_ptrn[6];  // select one of 8 permitted
		lfsr4[0]     = LFSR_init[3];  // any nonzero value (zero may be helpful for debug)
		$display("run program 3");
		$display("%s",str4)        ;  // print original message in transcript window
		$display("lead space count for program 3 = %d",lk);
		$display("LFSR_ptrn = %h, LFSR_init = %h",lfsr_ptrn[3],lfsr4[0]);

		for(int j=0; j<64; j++)       // pre-fill message_padded with ASCII space characters
			msg_padded4[j] = 8'h20;

		for(int l=0; l<41; l++)       // overwrite up to 41 of these spaces w/ message itself
			msg_padded4[pre_length[3]+l] = str4[l];
	
		// count leading blanks/spaces in original message
		for(int sp=0; sp<41; sp++)
			if(str4[sp]==8'h20)
				spaces++;
			else
				break;
		//    $display("space ct = %d",spaces);
		
		// compute the LFSR sequence
		for (int ii=0;ii<63;ii++)
			lfsr4[ii+1] = (lfsr4[ii]<<1)+(^(lfsr4[ii]&lfsr_ptrn[3]));  // {LFSR[6:0],(^LFSR[5:3]^LFSR[7])};           // roll the rolling code

		// encrypt the message, testbench will change on falling clocks
		for (int i=0; i<64; i++) begin
			msg_crypto4[i]        = msg_padded4[i] ^ lfsr4[i];  // {1'b0,LFSR[6:0]};       // encrypt 7 LSBs
			str_enc4[i]           = string'(msg_crypto4[i]);
		end

		// display encrypted message
		for(int jj=0; jj<64; jj++)
			$write("%s",str_enc4[jj]);
		$display("\n");

		
		// --------------------------Run Program 1--------------------------
		// ***** load operands into your data memory *****
		// ***** use your instance name for data memory and its internal core *****
		for(int m=0; m<41; m++)
			dut.DMEM.mem_core[m] = str1[m];      // copy original string into device's data memory[0:40]
		dut.DMEM.mem_core[41] = pre_length[0];  // number of bytes preceding message
		dut.DMEM.mem_core[42] = lfsr_ptrn[0];   // LFSR feedback tap positions (8 possible ptrns)
		dut.DMEM.mem_core[43] = LFSR_init[0];   // LFSR starting state (nonzero)
		// load constants, including LUTs, for program 1 here
		$display("lfsr_init[0]=%h,dut.DMEM.mem_core[43]=%h",LFSR_init[0],dut.DMEM.mem_core[43]);
		// $display("%d  %h  %h  %h  %s",i,message[i],msg_padded[i],msg_crypto[i],str[i]);
		#20ns init = 0;
		#60ns;                                // wait for 6 clock cycles of nominal 10ns each
		wait(done);                           // wait for DUT's done flag to go high
		#10ns $display();
		$display("program 1:");
		
		// ***** reads your results and compares to test bench
		// ***** use your instance name for data memory and its internal core *****
		for(int n=0; n<64; n++)
			if(msg_crypto1[n]!=dut.DMEM.mem_core[n+64])
				$display("%d bench msg: %s %h dut msg: %h  OOPS!",
					n, msg_crypto1[n], msg_crypto1[n], dut.DMEM.mem_core[n+64]);
			else
				$display("%d bench msg: %s %h dut msg: %h",
					n, msg_crypto1[n], msg_crypto1[n], dut.DMEM.mem_core[n+64]);

					
					
					
		// --------------------------Run Program 2--------------------------
		init = 1;                          // activate reset
		for(int n=64; n<128; n++)
			dut.DMEM.mem_core[n] = msg_crypto2[n - 64];
		// load new constants into data_mem for program 2 here
		#20ns init = 0;
		#60ns;						// wait for 6 clock cycles of nominal 10ns each
		wait(done);					// wait for DUT's done flag to go high
		#10ns $display();
		$display("program 2:");
		
		// ***** reads your results and compares to test bench
		// ***** use your instance name for data memory and its internal core *****
		for(int n=0; n<41; n++)
			if(str2[n]!=dut.DMEM.mem_core[n])
				$display("%d bench msg: %s  %h dut msg: %h  OOPS!",
					n, str2[n], str2[n], dut.DMEM.mem_core[n]);
			else
				$display("%d bench msg: %s  %h dut msg: %h",
					n, str2[n], str2[n], dut.DMEM.mem_core[n]);

					
					

		// -------------------------Run Program 1--------------------------
		init = 1;
		// ***** load operands into your data memory *****
		// ***** use your instance name for data memory and its internal core *****
		for(int m=0; m<41; m++)
			dut.DMEM.mem_core[m] = str3[m];       // copy original string into device's data memory[0:40]
		dut.DMEM.mem_core[41] = pre_length[2];  // number of bytes preceding message
		dut.DMEM.mem_core[42] = lfsr_ptrn[2];   // LFSR feedback tap positions (8 possible ptrns)
		dut.DMEM.mem_core[43] = LFSR_init[2];   // LFSR starting state (nonzero)
		// $display("%d  %h  %h  %h  %s",i,message[i],msg_padded[i],msg_crypto[i],str[i]);
		#20ns init = 0;
		#60ns;                                // wait for 6 clock cycles of nominal 10ns each
		wait(done);                           // wait for DUT's done flag to go high
		#10ns $display();
		$display("program 1:");
		
		// ***** reads your results and compares to test bench
		// ***** use your instance name for data memory and its internal core *****
		for(int n=0; n<64; n++)
			if(msg_crypto3[n]!=dut.DMEM.mem_core[n+64])
				$display("%d bench msg: %s  %h dut msg: %h   OOPS!",
					n, msg_crypto3[n], msg_crypto3[n], dut.DMEM.mem_core[n+64]);
			else
				$display("%d bench msg: %s  %h dut msg: %h",
					n, msg_crypto3[n], msg_crypto3[n], dut.DMEM.mem_core[n+64]);
					
					
					
					
		// -------------------------Run Program 3--------------------------
		init = 1;                          // activate reset
		// ***** load operands into your data memory *****
		// ***** use your instance name for data memory and its internal core *****
		for(int n=64; n<128; n++)
			dut.DMEM.mem_core[n] = msg_crypto4[n - 64];
		#20ns init = 0;
		#60ns;                             // wait for 6 clock cycles of nominal 10ns each
		wait(done);                        // wait for DUT's done flag to go high
		#10ns $display();
		$display("program 3:");
		
		// ***** reads your results and compares to test bench
		// ***** use your instance name for data memory and its internal core *****
		for(int n=0; n<41-spaces; n++)
			if(str4[n+lk]!=dut.DMEM.mem_core[n])
				$display("%d bench msg: %s  %h dut msg: %h   OOPS!",
					n, str4[n+lk], str4[n+lk], dut.DMEM.mem_core[n]);
			else
				$display("%d bench msg: %s  %h dut msg: %h",
					n, str4[n+lk], str4[n+lk], dut.DMEM.mem_core[n]);
		
		
		/*
		// Print contents of the register file
		$display("[Post] Reg Data:");
		for (int n=0; n < 16; n=n+1)
			$display("%d:%d",n,dut.RF.reg_core[n]);
	
		// Print Contents of Mem File
		$display("[Post] Memory File:");
		for(int n=0; n < 2**8; n=n+1)
			$display("%d:%d",n,dut.DMEM.mem_core[n]);
		*/
		#20ns $stop;
	end

always begin     // continuous loop
  #5ns clk = 1;  // clock tick
  #5ns clk = 0;  // clock tock
end

endmodule