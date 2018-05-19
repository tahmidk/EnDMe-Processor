# [Usage:]
# python assembler.py [input assembly code (.txt)] [output machine code (.txt)]
# [Example:]
# python assembler.py program_9.txt machine_code.txt

# [Description:]	
# Assembler for the EnDMe ISA

# [Authors:]	
# Tahmid Khan
# Shengyuan Lin

# [Notes:]
# In input assembly file, please note the following:
#	1) Put labels on the same line as an instruction
#		Good -	loop:	
#				instruction
#				...
#		----------------------------------------------
#		Bad - 	loop:	instruction
#				...
#	2) Put comments on separate lines from instructions
#		Good - 	instruction 1
#				// comment
#				instruction 2
#		----------------------------------------------
#		Bad -	instruction	1	// comment
#				instruction 2
# 	3) Precede registers with '$'
#	4) Precede immediates with '#'

import sys

M_TYPE = '1'
O_TYPE = '0'

# The O-type opcodes
op_code = {
	'store': 0,
	'lb': 1,
	'sb': 2,
	'put': 3,
	'btr': 4,
	'jmp': 5,
	'add': 6,
	'sub': 7,
	'and': 8,
	'xor': 9,
	'sfl': 10,
	'sfr': 11,
	'cmp': 12,
	'gtr': 13
}

# The registers and corresponding values
reg_code = {
	'$acc': 0,
	'$r1': 1,
	'$r2': 2,
	'$r3': 3,
	'$r4': 4,
	'$r5': 5,
	'$r6': 6,
	'$r7': 7,
	'$r8': 8,
	'$r9': 9,
	'$r10': 10,
	'$r11': 11,
	'$r12': 12,
	'$r13': 13,
	'$pc': 14,
	'$dst': 15
}

# Data structures
instr_mc = ""		# Instruction machine code

instructions = []	# A list of all the instructions
labels = dict()		# A dict mapping all labels to the instr # after them

# Script
# Check that both command line arguments for input and output.txt are given 
if not len(sys.argv) == 2:
	print("Expected 1 argument (assembly file) but got %d" \
		% (len(sys.argv) - 1))
else:
	# Initialize input and output files
	assembly_in = open(sys.argv[1], 'r')
	machine_code_out = open("machine_code.txt", 'w')

	# Fetch all instructions and labels and initialize the instructions and
	# labels data structures
	for line in assembly_in:
		# Skip blank spaces and comments
		if str(line).startswith('\n') or str(line).startswith('#'):
			continue

		# Split line by 'space'
		members = line.split()

		# Detect label
		if len(members) == 1 and members[0].endswith(':'):
			labels[members[0][:-1]] = len(instructions)
			continue

		# Detect an instruction
		if members[0] == 'save' or members[0] in op_code:
			instructions.append(members)
		# Illegal instruction
		else:
			print("Illegal instruction \'%s\'" % str(members[0]))
			sys.exit()

	#import pdb; pdb.set_trace()
	# Convert all instructions in instructions array to machine code
	for instr in instructions:
		# Detect M-type instruction
		if instr[0] == 'save':
			# Check if argument is an immediate
			if instr[1].startswith('#'):
				imm = int(instr[1][1:])
				if imm > 255:
					print("Warning, an immediate reaches >255!")

				instr_mc = M_TYPE + '_' + '{0:08b}'.format(imm % 256)
				machine_code_out.write(instr_mc + '\n')
			# Argument is a label
			else:
				label = instr[1]
				if not label in labels:
					print("Error, cannot find label: \'%s\'" % label)
					sys.exit()

				label_ref = labels[label]
				instr_mc = M_TYPE + '_' + '{0:08b}'.format(label_ref % 256)
				machine_code_out.write(instr_mc + '\n')

		# Detect O-type instruction
		elif instr[0] in op_code:
			op = op_code[instr[0]]
			reg = 0

			if len(instr) == 2:
				register = instr[1]
				if not register in reg_code:
					print("Cannot recognize register: %s" % register)
					sys.exit()

				# Fetch the reg code
				reg = reg_code[register]

			# O-Type = Typ[9:8] + Opcode[7:4] + Regcode[3:0]
			instr_mc = O_TYPE + '_' + '{0:04b}'.format(op) \
				+ '_' + '{0:04b}'.format(reg)
			machine_code_out.write(instr_mc + '\n')

	# Close files
	assembly_in.close()
	machine_code_out.close()


