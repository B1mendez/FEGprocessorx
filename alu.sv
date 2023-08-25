// combinational -- no clock
// sample -- change as desired
module alu(
  input[2:0] alu_cmd,    // ALU instructions
  input[7:0] inA, inB,	 // 8-bit wide data path
  input      sc_i,       // shift_carry in
  output logic[7:0] rslt,
  output logic sc_o,     // shift_carry out
               pari,     // reduction XOR (output)
			   zero      // NOR (output)
);

always_comb begin 
  rslt = 'b0;            
  sc_o = 'b0;    

  case(alu_cmd)
    3'b000: // ADD
      {sc_o,rslt} = inA + inB + sc_i;
	  
    3'b001: // SLL (Shift Left Logical)
      {sc_o,rslt} = {inA, sc_i};
	  
    3'b010: // SRL (Shift Right Logical)
      {rslt,sc_o} = {sc_i,inA};
	  
    3'b011: // XOR (Bitwise XOR)
      rslt = inA ^ inB;
	  
    3'b100: // AND (Bitwise AND)
      rslt = inA & inB;
	  
    3'b101: // OR (Bitwise OR)
      rslt = inA | inB;

     3'b110: // Subtract (This might be redundant given the scope, but I'm leaving it for now)
      {sc_o,rslt} = inA - inB + sc_i;
		
    3'b111: // pass A (Simply pass input A to output)
      rslt = inA;
  endcase
  
  zero = !rslt;
  pari = ^rslt;
end
   
endmodule
