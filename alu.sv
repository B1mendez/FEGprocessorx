// combinational -- no clock
// sample -- change as desired
	module alu(
  input[2:0] alu_cmd,     // ALU instructions
  input[1:0] immed,
  input      direct,
  input[7:0] inA, inB,	  // 8-bit wide data path
  input      sc_i,        // shift_carry in
  output logic[7:0] rslt,
  output logic      sc_o,      // shift_carry out
                    pari,      // reduction XOR (output)
			           zero,      // NOR (output)
					     br_logic   // BR 
);

always_comb begin 
  rslt = 'b0;            
  sc_o = 'b0; 
  br_logic = 'b0;
	
  case(alu_cmd)
    3'b000: // LDR 
		rslt = inA;
	  
    3'b001: // STR
		rslt = inA;
	   
    3'b010: // MOV 
      rslt = immed;
	  
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
			if (inA == inB)
				br_logic = 'b1;
			else
				br_logic = 'b0;
		
			rslt = 1'b0;
	   end   
		
    3'b111: // br
      rslt = 1'b0;
  endcase
  
  zero = !rslt;
  pari = ^rslt;
end
   
endmodule
