// combinational -- no clock
// sample -- change as desired
	module alu(
  input[2:0] alu_cmd,     // ALU instructions
  input[1:0] immed,
  input      direct,
  input		 moveControl,
  input[7:0] inA, inB,	  // 8-bit wide data path
  output logic[7:0] rslt,
  output logic             br_logic   // BR 
);

always_comb begin 
  br_logic = 'b0;
	
  case(alu_cmd)
    3'b000: // LDR 
		rslt = inB;
	  
    3'b001: // STR
		rslt = inB;
	   
    3'b010: // MOV & ADD
		begin
			if (moveControl) 				//ADD 
				rslt = inA + immed;
			else								//MOV
				rslt = immed;
		end
	  
    3'b011: // XOR (Bitwise XOR)
      rslt = inA ^ inB;
	  
    3'b100: // AND (Bitwise AND)
      rslt = inA & inB;
		
	 3'b101: // SHIFT 
		begin
			if (direct) 
				rslt = inA >> immed; 
			else 
				rslt = inA << immed; 
		end
    3'b110: //CMP compare function
		begin
			if (inA != inB)
				br_logic = 'b1;
			else
				br_logic = 'b0;
		
			rslt = 1'b0;
	   end   
		
    3'b111: // br
      rslt = 1'b0;
  endcase
end
   
endmodule
