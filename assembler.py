def convert(inFile, outFile1):
	assembly_file = open(inFile, 'r')
	machine_file = open(outFile1, 'w')
	assembly = list(assembly_file.read().split('\n'))

	#keep track of index and file line number
	lineNum = 0;
	labelsNum = 0;

	#dictionaries to ease conversion of opcodes/operands to binary (PREVIOUS
	# OPCODES GIVEN)
	# opcodes = {'ADR' : '000', 'ADI' : '001', 'STR' : '010', 'LDR' : '011',
	# 'MOV' : '100', 'CMP' : '101', 'BR' : '110', 'HT' : '111'}

	opcodes = {'LDR': '000', 'STR': '001', 'MOV': '010', 'XOR': '011',
	'AND': '100', 'SHIFT' : '101', 'CMP' : '110', 'BNE': '111', 'ADD': '0000'}
	
	registers = {'r0' : '000', 'r1' : '001', 'r2' : '010', 'r3' : '011',
	'r4' : '100', 'r5' : '101', 'r6' : '110', 'r7' : '111'}

	distance = {'p1for': '00000', 'p2SEC': '00001', 'p2DED: '00010', 'p2for': '00011'}
	
	#reads through file to convert instructions to machine code
	for line in assembly:
		output = ""
		instr = line.split(); #split to get instruction and different operands\
		if instr == [] or instr[0] == "//":
			continue
		operation = opcodes[instr[0]]
		#make sure it is an instruction, skip over labels
		if instr[0] in opcodes:
			# AND and XOR
			# Example of AND and XOR
			# AND R0 R1 
			# instr[0] = 'AND' instr[1]=R0 instr[2]=R1
			# 100_000_001
			if operation == '100' or operation == '011':
				# R-type instruction
				output += operation
				output += registers[instr[1]]
				output += registers[instr[2]]
			# SHIFT
			# Example of SHIFT
			# SHIFT r0 R immediate
			# instr[0] = 'SHIFT' instr[1]=R0 instr[2]=1 instr[3]=immediate
			elif operation == '101':
				# R-type instruction
				output += operation
				output += registers[instr[1]]
				if instr[2] == "R":
					output += '1'
				else:
					output += '0'
				output += bin(int(instr[3]))[2:].zfill(2)
			# LDR and STR
			# Example of LDR and STR
			# LDR r0 r1
			# instr[0] = 'LDR' instr[1]=R0 instr[2]=R1
			elif operation == '000' or operation == '001':
				# I type instruction
				output += operation
				output += registers[instr[1]]
				output += registers[instr[2]]
			# MOV/AND
			# Example of MOV//AND
			# MOV R0 control immediate / AND R0 control immediate 
			# instr[0] = 'MOV' instr[1]=control instr[2]=R0 instr[3]=immediate
			elif operation == '010' or operation == '0000':
				# I type instruction
				output += '010'
				output += registers[instr[1]]
				if operation == '010':
					output += '0'
				else:
					output += '1'
				output += bin(int(instr[2]))[2:].zfill(2)
			# CMP
			# Example of CMP
			# CMP R0 R1
			# instr[0] = 'CMP' instr[1]=R0 instr[2]=R1
			elif operation == '110':
				# J type instruction
				output += operation
				output += registers[instr[1]]
				output += registers[instr[2]]
			# BNE
			# Example of BNE
			# BNE target
			# instr[0] = 'BNE' instr[1]=target			
			else:
				output += operation
				if instr[1] == "A":
					output += '1'
				else:
					output += '0'
				output += distance[instr[2]]
			#write binary to machine code output file
			machine_file.write(str(output) + '\t// ' + line + '\n')

	assembly_file.close()
	machine_file.close()

convert("program1.txt", "program1_mach.txt")
