// control decoder
module Control #(parameter opwidth = 3, mcodebits = 3)(
  input [mcodebits-1:0] instr,    // subset of machine code (any width you need)
  input 						br_logic,
  output logic RegDst, Branch, 
     MemtoReg, MemWrite, ALUSrc, RegWrite,
  output logic[opwidth-1:0] ALUOp);	   // for up to 8 ALU operations

always_comb begin
// defaults
  RegDst 	=   'b0;   // 1: not in place  just leave 0
  Branch 	=   'b0;   // 1: branch (jump)
  MemWrite  =	 'b0;   // 1: store to memory
  ALUSrc 	=	 'b0;   // 1: immediate  0: second reg file output
  RegWrite  =	 'b1;   // 0: for store or no op  1: most other operations 
  MemtoReg  =	 'b0;   // 1: load -- route memory instead of ALU to reg_file data in
  ALUOp	   =   'b111; // y = a+0;

  
case(instr)    							
  'b000: begin					      //LDR
				MemtoReg = 'b1;       
            RegWrite = 'b0;
				ALUOp    = 3'b000;
			end
  'b001: begin  						//STR
				RegWrite = 'b0; 
				MemWrite = 'b1; 
				ALUOp    = 3'b001; 
			end
  'b010: begin				    		//MOV
				ALUOp    = 3'b010;   
         end
  'b011: begin							//XOR
				ALUOp    = 3'b011;
			end
  'b100: begin							//AND
				ALUOp    = 3'b100; 
			end
  'b101: begin							//SHIFT
				 ALUOp   = 3'b101; 
			end
  'b110: begin							//CMP
				ALUOp    = 3'b110;
			end
  'b111:	 begin						//	BR				
					if (br_logic)
						Branch = 'b1;
					
					ALUOp    = 3'b111;
					RegWrite = 'b0; 
			 end
endcase

end
	
endmodule
