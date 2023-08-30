// combinational -- no clock
// sample -- change as desired
module alu(
  input[2:0] alu_cmd,     // ALU instructions
  input[1:0] sel_cmd,
  input[7:0] inA, inB,	  // 8-bit wide data path
  input      sc_i,        // shift_carry in
  output logic[7:0] rslt,
  output logic sc_o,      // shift_carry out
               pari,      // reduction XOR (output)
			      zero,      // NOR (output)
					br_logic   // BR 
);

always_comb begin 
  rslt = 'b0;            
  sc_o = 'b0; 
  br_logic = 'b0;

  case(alu_cmd)
    3'b000: // LDR STR & MOV
      case(sel_cmd)
			2'b00: //LDR
				rslt = inA;
			2'b01: //STR
				rslt = inB;
			2'b10: //MOV needs work!
				rslt = inB;
		endcase
	  
    3'b001: // CMP Compare function 
	   begin
			if (inA == inB)
				br_logic = 'b1;
			else
				br_logic = 'b0;
		
			rslt = 1'b0;
	   end
    3'b010: // OR (Bitwise OR)
      rslt = inA | inB;
	  
    3'b011: // XOR (Bitwise XOR)
      rslt = inA ^ inB;
	  
    3'b100: // AND (Bitwise AND)
      rslt = inA & inB;
		
	 3'b101: // SRL (Shift Right Logical)
		rslt = rslt >> 1;
		
    3'b110: // SLL (Shift Left Logical)
		rslt = rslt << 1;   
		
    3'b111: // br
      rslt = 1'b0;
  endcase
  
  zero = !rslt;
  pari = ^rslt;
end
   
endmodule
