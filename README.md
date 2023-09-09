# CSE141L-FEGprocessorx
## Developers: Brian Mendez A17211975, Phiroze Duggal A17215613, Jinshi He, A17005195

The overall goal for the ISA is to be able to recover information sent to it using the additional bits/information so that it is able to accurately restore that information in case of transmission corruption. 
<br><br>
Some of our design goals include ensuring the ISA machine contains the necessary mathematical operations for the correct logical handling required for FEC. The instructions for the design should allow us to rely solely on the use of registers in order to handle the data rather than on any memory accesses as well. Processing of information and conducting of operations should be able to be done simultaneously, and our machine ought to contain several branches relating to the various cases of handling the data to perform FEC. <br><br>
Machine Type: register-register/load-store

## FEGprocessorx Overview 
- 8 registers
- Operations (8):
    - R-Type: ADD, XOR, STR, LDR (3 bits opcode, 3 bits register 1, 3 bits register 2) 
    - I-Type: MOV, AND (3 bits opcode, 3 bits register 1, 1 bits control, 2 immediate bit) 
    - J-Type: CMP (3 bits opcode, 3 bits register 1, 3 bits register 2)
    - J-Type: BNE (3 bits opcode, 6 bit Target Address) 
- Programs Passed: 3/3
- Modules/Components:
    - Top level: serves as the central hub that integrates all other modules within the processor.
    - Program Counter: responsible for managing the execution flow of the program.
    - Instruction Memory: serves as a lookup table that maps the program counter to the corresponding machine code.
    - Control Decoder: interprets the opcode of the current instruction and generates the necessary control signals to execute it.
    - Register File: handles the reading and writing of processor registers.
    - ALU (Arithmetic Logic Unit): is responsible for performing arithmetic and logical operations.
    - Data Memory: provides access to the data memory of the system.
    - Lookup Tables: works in conjunction with the Program Counter module to facilitate large jumps within the program.
    - Muxes: is used to select specific values as output based on control signals. 

## How to run and set up
- Using the assembler.py you can turn your assembly code into the appropriate machine code in this processor. (note: make sure to update distance array with the labels used in each branch statement)
- Update PC_LUT with the line number in the machine code where you want to jump to. Associate it with the distance key made in the assembler.py file.
- Add the file location of the machine code file in the instr_ROM.sv
- Update the top_level.sv file done flag (line 101) with the last line of the machine code.
- Open modelSim in quertas, compile the appropriate testbench (if you are using machine code for program 1 use prog1_tb.sv, etc...), then run -all. Check transcript to see if all cases passed. 

