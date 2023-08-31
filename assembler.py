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
	'AND': '100', 'SHIFT' : '101', 'CMP' : '110', 'BEQ': '111'}
	
	registers = {'r0' : '000', 'r1' : '001', 'r2' : '010', 'r3' : '011',
	'r4' : '100', 'r5' : '101', 'r6' : '110', 'r7' : '111'}

	distance = {'p1for1': '000000', 'p1for2': '000111'}
	
	# reads through assembly and collects labels to populate lookup table
	# lut = {}
	# for line in assembly:
	# 	instr = line.split();	
	# 	lineNum += 1
	# 	#check if it is a label or not
	# 	if instr[0] not in opcodes:
	# 		lut[instr[0].replace(':', '')] = labelsNum
	# 		lut_file.write(str(lineNum) + '\n')
	# 		labelsNum += 1
	
	#reads through file to convert instructions to machine code
	for line in assembly:
		output = ""
		instr = line.split(); #split to get instruction and different operands\
		operation = opcodes[instr[0]]
		#make sure it is an instruction, skip over labels
		if instr[0] in opcodes:
			# AND and XOR
			# Example of AND and XOR
			# ADD R0 R1 
			# instr[0] = 'ADD' instr[1]=R0 instr[2]=R1
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
			# MOV
			# Example of MOV
			# MOV R0 immediate
			# instr[0] = 'MOV' instr[1]=R0 instr[2]=immediate
			elif operation == '010':
				# I type instruction
				output += operation
				output += registers[instr[1]]
				output += '0'
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
			# BEQ
			# Example of BEQ
			# BEQ target
			# instr[0] = 'BEQ' instr[1]=target			
			else:
				output += operation
				output += distance[instr[1]]
			#write binary to machine code output file
			machine_file.write(str(output) + '\t// ' + line + '\n')

	assembly_file.close()
	machine_file.close()

convert("assembly.txt", "machine.txt")