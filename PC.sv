// program counter
// supports both relative and absolute jumps
// use either or both, as desired
module PC #(parameter D=12)(
  input reset,					// synchronous reset
        clk,
		  jump_en,
		  abs_jump,// rel. jump enable
  input       [D-1:0] target,	// how far/where to jump
  output logic[D-1:0] prog_ctr
);

  always_ff @(posedge clk)
    if(reset)
	  prog_ctr <= '0;
	else if(jump_en)
	  begin
	  if (abs_jump)
			prog_ctr <= target;
	  else	
			prog_ctr <= prog_ctr + target;
	  end
	else
	  prog_ctr <= prog_ctr + 'b1;

endmodule
